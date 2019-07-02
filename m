Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7F25D287
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBPQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:16:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725780AbfGBPQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:16:29 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x62FBcho004921
        for <netdev@vger.kernel.org>; Tue, 2 Jul 2019 08:16:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=TCguOytpLJpY49Jy7BNLWU06vek5FbJWmc+UYKhViKw=;
 b=rMGBPdqnIh+fhH/6SDzyCJp6a4a/HhpXgTyppY8qTxGQfGBX638MKCzaoE2oOgXDI7/7
 FoijPSN2F28/Iu8wiFVifN0wuG12lj10G6DMxQLi4OXmPmroK23UJ5J0fPj1I+W+cd2i
 egQy9GWO0nLP9SEaKPl/CMs8XrYTc+LXyZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tg1s71gyk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:16:27 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 08:16:26 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D8118861473; Tue,  2 Jul 2019 08:16:21 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <magnus.karlsson@intel.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] libbpf: fix GCC8 warning for strncpy
Date:   Tue, 2 Jul 2019 08:16:20 -0700
Message-ID: <20190702151620.3382559-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC8 started emitting warning about using strncpy with number of bytes
exactly equal destination size, which is generally unsafe, as can lead
to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
of bytes to ensure name is always zero-terminated.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index bf15a80a37c2..b33740221b7e 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -327,7 +327,8 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 
 	channels.cmd = ETHTOOL_GCHANNELS;
 	ifr.ifr_data = (void *)&channels;
-	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
+	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
 		ret = -errno;
-- 
2.17.1

