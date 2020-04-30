Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8891BEE2D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD3COy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:14:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD3COy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:14:54 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03U29sbl011960
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:14:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3+o7l02/rlglt5SdbycnrNsOMQZhnw7LzfBDqT6Y0rA=;
 b=dT4cdiq+kLGKgOu8QoiCvllmVpJc2VjfR+Y8TXENtklNkvg3LgL14qUsqWRzwgJhwWt6
 xh0WTYZ2dp86vl3ceWqS9W4i3kQeC3/tTH4T/H6SrZysnTJ9lfBo/rXJlbzljWXB86ld
 77JcEKdNG0wwCklL4t6A0FavqlGZ5/Veqvs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30qjh00xaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:14:53 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 19:14:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 63A202EC3019; Wed, 29 Apr 2020 19:14:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] libbpf: fix false uninitialized variable warning
Date:   Wed, 29 Apr 2020 19:14:36 -0700
Message-ID: <20200430021436.1522502-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_01:2020-04-30,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=8 adultscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300014
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

