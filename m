Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFDC7B5AF
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbfG3WZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:25:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6870 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387473AbfG3WZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:25:03 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6UMLTnB014066
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:25:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=OZSINzyCE7U842WuKXxe0vv5G8HFzhioCkEgHqmDJvY=;
 b=iVxiOOSKFpM0o3oSCTo6LnYE4rnxOHvMUvJa/fHK9xSRNpRlcP/TBQFSIPJy4LrnBWjU
 8RInfkG5qsg1ybStVYftW/vJJPp11PRNiVWSPub0JcjXnU942EW9RRfj+Mm8T/7lUIDy
 QHrvtatxU4/0ZMvBCHc1+aqVCATL7Mz4SjA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u2wn6r7bg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:25:01 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 15:25:00 -0700
Received: by devvm6270.prn2.facebook.com (Postfix, from userid 153359)
        id 7B1DB15F02474; Tue, 30 Jul 2019 15:24:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Hostname: devvm6270.prn2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <rdna@fb.com>,
        <ctakshak@fb.com>, <kernel-team@fb.com>, <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf : make libbpf_num_possible_cpus function thread safe
Date:   Tue, 30 Jul 2019 15:24:47 -0700
Message-ID: <20190730222447.3918919-1-ctakshak@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300224
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having static variable `cpus` in libbpf_num_possible_cpus function without
guarding it with mutex makes this function thread-unsafe.

If multiple threads accessing this function, in the current form; it
leads to incrementing the static variable value `cpus` in the multiple
of total available CPUs.

Let caching the number of possile CPUs handled by libbpf's users than
this library itself; and let this function be rock bottom one which reads
and parse the file (/sys/devices/system/cpu/possible) everytime it gets
called to simplify the things.

Fixes: 6446b3155521 (bpf: add a new API libbpf_num_possible_cpus())

Signed-off-by: Takshak Chahande <ctakshak@fb.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ead915aec349..e7ac0e02287e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4998,14 +4998,11 @@ int libbpf_num_possible_cpus(void)
 	static const char *fcpu = "/sys/devices/system/cpu/possible";
 	int len = 0, n = 0, il = 0, ir = 0;
 	unsigned int start = 0, end = 0;
-	static int cpus;
 	char buf[128];
 	int error = 0;
+	int cpus = 0;
 	int fd = -1;
 
-	if (cpus > 0)
-		return cpus;
-
 	fd = open(fcpu, O_RDONLY);
 	if (fd < 0) {
 		error = errno;
-- 
2.17.1

