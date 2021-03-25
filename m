Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929D83486A5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhCYBwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:52:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236066AbhCYBwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1mpW7014288
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kjfbyQ8nXpwhX6zqSy7W2JK6VhqfMbLCvXJQorb8PEU=;
 b=KxSa82Vv3sCbgmkmky1/9iS/gXkdhr/ujpq327cRUUJ3bI29AerrmLCj2ELO/hPEr2hJ
 EzC1CfNIJzg95oQwEe0Vgw3c/d+fY497OzI5FiWRopmVgT5//s6yX3zfpxLwTzxqnGof
 MlYf8ZKFtmXeCpPvVxUJmmq/5YGahukMhiQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fny9h7ab-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:17 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:15 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 420E929429D7; Wed, 24 Mar 2021 18:52:14 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf-next 08/14] libbpf: Refactor codes for finding btf id of a kernel symbol
Date:   Wed, 24 Mar 2021 18:52:14 -0700
Message-ID: <20210325015214.1547069-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors code, that finds kernel btf_id by kind
and symbol name, to a new function find_ksym_btf_id().

It also adds a new helper __btf_kind_str() to return
a string by the numeric kind value.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 44 +++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 57123a2179b4..5a0cae981784 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1920,9 +1920,9 @@ resolve_func_ptr(const struct btf *btf, __u32 id, _=
_u32 *res_id)
 	return btf_is_func_proto(t) ? t : NULL;
 }
=20
-static const char *btf_kind_str(const struct btf_type *t)
+static const char *__btf_kind_str(__u16 kind)
 {
-	switch (btf_kind(t)) {
+	switch (kind) {
 	case BTF_KIND_UNKN: return "void";
 	case BTF_KIND_INT: return "int";
 	case BTF_KIND_PTR: return "ptr";
@@ -1944,6 +1944,11 @@ static const char *btf_kind_str(const struct btf_t=
ype *t)
 	}
 }
=20
+static const char *btf_kind_str(const struct btf_type *t)
+{
+	return __btf_kind_str(btf_kind(t));
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of a=
rray
@@ -7394,18 +7399,17 @@ static int bpf_object__read_kallsyms_file(struct =
bpf_object *obj)
 	return err;
 }
=20
-static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
-					       struct extern_desc *ext)
+static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_nam=
e,
+			    __u16 kind, struct btf **res_btf,
+			    int *res_btf_fd)
 {
-	const struct btf_type *targ_var, *targ_type;
-	__u32 targ_type_id, local_type_id;
-	const char *targ_var_name;
 	int i, id, btf_fd, err;
 	struct btf *btf;
=20
 	btf =3D obj->btf_vmlinux;
 	btf_fd =3D 0;
-	id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+	id =3D btf__find_by_name_kind(btf, ksym_name, kind);
+
 	if (id =3D=3D -ENOENT) {
 		err =3D load_module_btfs(obj);
 		if (err)
@@ -7415,17 +7419,35 @@ static int bpf_object__resolve_ksym_var_btf_id(st=
ruct bpf_object *obj,
 			btf =3D obj->btf_modules[i].btf;
 			/* we assume module BTF FD is always >0 */
 			btf_fd =3D obj->btf_modules[i].fd;
-			id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+			id =3D btf__find_by_name_kind(btf, ksym_name, kind);
 			if (id !=3D -ENOENT)
 				break;
 		}
 	}
 	if (id <=3D 0) {
-		pr_warn("extern (var ksym) '%s': failed to find BTF ID in kernel BTF(s=
).\n",
-			ext->name);
+		pr_warn("extern (%s ksym) '%s': failed to find BTF ID in kernel BTF(s)=
.\n",
+			__btf_kind_str(kind), ksym_name);
 		return -ESRCH;
 	}
=20
+	*res_btf =3D btf;
+	*res_btf_fd =3D btf_fd;
+	return id;
+}
+
+static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
+					       struct extern_desc *ext)
+{
+	const struct btf_type *targ_var, *targ_type;
+	__u32 targ_type_id, local_type_id;
+	const char *targ_var_name;
+	int id, btf_fd =3D 0, err;
+	struct btf *btf =3D NULL;
+
+	id =3D find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
+	if (id < 0)
+		return id;
+
 	/* find local type_id */
 	local_type_id =3D ext->ksym.type_id;
=20
--=20
2.30.2

