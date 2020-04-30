Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074601BED85
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD3BZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:25:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726286AbgD3BZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:25:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U1F4Io004841
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 18:25:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3+o7l02/rlglt5SdbycnrNsOMQZhnw7LzfBDqT6Y0rA=;
 b=Sf/SHdtzoJCD5puxSO5diXsluU7EFs7VP0fG6a9ogg9vDD+FV2FUJ36KWHQcNGFEUuNZ
 Tzi9RWIRZCtzhCvwUQIM+DIrmERsMhaZ/kMItxwvABXopZSX2H5qQNNWuhMedw90k11y
 fVeYTt/X0zlYizPEV4zHQKGfKal2e3qPJo4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0dke9m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 18:25:54 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 18:25:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 79F5C2EC306A; Wed, 29 Apr 2020 18:25:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix false unused variable warning
Date:   Wed, 29 Apr 2020 18:25:44 -0700
Message-ID: <20200430012544.1347275-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_11:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some versions of GCC falsely detect that vi might not be initialized. Tha=
t's
not true, but let's silence it with NULL initialization.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d86ff8214b96..977add1b73e2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5003,8 +5003,8 @@ static int bpf_object__collect_map_relos(struct bpf=
_object *obj,
 					 GElf_Shdr *shdr, Elf_Data *data)
 {
 	int i, j, nrels, new_sz, ptr_sz =3D sizeof(void *);
+	const struct btf_var_secinfo *vi =3D NULL;
 	const struct btf_type *sec, *var, *def;
-	const struct btf_var_secinfo *vi;
 	const struct btf_member *member;
 	struct bpf_map *map, *targ_map;
 	const char *name, *mname;
--=20
2.24.1

