Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58674206911
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbgFXAdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:33:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388073AbgFXAdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:33:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05O0VKwA018537
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 17:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=v6psWLDY9Ln/UQDHd6WDKh552YToN18sLkGqs7YwucY=;
 b=FFZC2zYLOjY9+Wvp459OF5WtkHSvSB9wvNY5bcAYetmr8gTvGY6Q6o8Lw23iPXxviRMO
 gc/ymzU6AImEoUB1R884mq8gjuOx+DPuswjEx6Y4euhNd6Hd2yjGZBaiQijghexfV92I
 yd8kxVwDHsi4r+q4V7+r6YUwUvDQ6BmLweg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uuqqg5hk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 17:33:50 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 17:33:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6D2E42EC3DE6; Tue, 23 Jun 2020 17:33:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add debug message for each created program
Date:   Tue, 23 Jun 2020 17:33:39 -0700
Message-ID: <20200624003340.802375-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_17:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=764 suspectscore=8 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar message for map creation is extremely useful, so add similar for =
BPF
programs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 18461deb1b19..f24a90c86c58 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5379,8 +5379,9 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
 	}
=20
 	ret =3D bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
-
 	if (ret >=3D 0) {
+		pr_debug("prog '%s' ('%s'): created successfully, fd=3D%d\n",
+			 prog->name, prog->section_name, ret);
 		if (log_buf && load_attr.log_level)
 			pr_debug("verifier log:\n%s", log_buf);
 		*pfd =3D ret;
--=20
2.24.1

