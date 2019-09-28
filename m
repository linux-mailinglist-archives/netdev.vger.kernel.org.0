Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558ACC0FF6
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 08:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfI1Gaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 02:30:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34860 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbfI1Gai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 02:30:38 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8S6TJ2N001866
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 23:30:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=6R2Dd5IRUs0LfXRedoJRvfGPayXQYWmjdz8o5YpU+k8=;
 b=QEqlegTCWGANxAqW6c2xYpOzKbmO7CNgmormARvxyYL+H7t2JAkQV5Zhk5ScgaKHng9N
 MBw7jp+Opnud2SCXy2AqRl0jE6He7x07Alqus9FSIY3o0dpAJ5bocanDKWMsN8aj4h5X
 x7iBvAj4BfxR0mDO/EduFlkJTyi4G+V23nM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v9pnajwnt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 23:30:38 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 27 Sep 2019 23:30:35 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 070958618C8; Fri, 27 Sep 2019 23:30:35 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: count present CPUs, not theoretically possible
Date:   Fri, 27 Sep 2019 23:30:33 -0700
Message-ID: <20190928063033.1674094-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-28_03:2019-09-25,2019-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909280067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch switches libbpf_num_possible_cpus() from using possible CPU
set to present CPU set. This fixes issues with incorrect auto-sizing of
PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.

On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
be a set of any representable (i.e., potentially possible) CPU, which is
normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
tested on, while there were just two CPU cores actually present).
/sys/devices/system/cpu/present, on the other hand, will only contain
CPUs that are physically present in the system (even if not online yet),
which is what we really want, especially when creating per-CPU maps or
perf events.

On systems with HOTPLUG disabled, present and possible are identical, so
there is no change of behavior there.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..45351c074e45 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
 
 int libbpf_num_possible_cpus(void)
 {
-	static const char *fcpu = "/sys/devices/system/cpu/possible";
+	static const char *fcpu = "/sys/devices/system/cpu/present";
 	int len = 0, n = 0, il = 0, ir = 0;
 	unsigned int start = 0, end = 0;
 	int tmp_cpus = 0;
-- 
2.17.1

