Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD8727DB83
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgI2WPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:15:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727922AbgI2WPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:15:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08TM9qWn025025
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:15:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=B//9bVyaRFLc7im99epAwDTAMRI7ulg0e+dfdKylx/A=;
 b=MAgqxjX9p6inv2Ev7nBiOAuxyX3TT2k+lj0cdyq0SsMm/Ypi6//hifbLxtAuFWqSoCon
 whMQ2uNNzB0DB3qZei9dWUaOGTZw5q0HfLoX8kHFuYdCI6qdywb+rsgedSxWcxiCYuk/
 F9FIMpKKTrwn/nAwxIuz680cixRPle1lncs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33t14yg4h5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:15:28 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 15:15:27 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4EA3F2EC77D4; Tue, 29 Sep 2020 15:15:23 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 1/3] libbpf: fix uninitialized variable in btf_parse_type_sec
Date:   Tue, 29 Sep 2020 15:06:02 -0700
Message-ID: <20200929220604.833631-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290191
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix obvious unitialized variable use that wasn't reported by compiler. li=
bbpf
Makefile changes to catch such errors are added separately.

Fixes: 3289959b97ca ("libbpf: Support BTF loading and raw data output in =
both endianness")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e1dbd766c698..398b1f345b3c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -347,7 +347,7 @@ static int btf_parse_type_sec(struct btf *btf)
 	struct btf_header *hdr =3D btf->hdr;
 	void *next_type =3D btf->types_data;
 	void *end_type =3D next_type + hdr->type_len;
-	int err, i, type_size;
+	int err, i =3D 0, type_size;
=20
 	/* VOID (type_id =3D=3D 0) is specially handled by btf__get_type_by_id(=
),
 	 * so ensure we can never properly use its offset from index by
--=20
2.24.1

