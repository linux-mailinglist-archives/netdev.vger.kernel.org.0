Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E033CAAC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhCPBO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24252 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234205AbhCPBOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:30 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1AP3N016321
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8zi1kIY50TKylIjIldVt+Yth2w8NYFrDNaaQtaBBFH0=;
 b=VUqTXHY1otH68I+aUUq/fM8ej7UvmrfeyObBL9J8T1V8SYv79ATlz1031z8yOWmjZoG+
 NTSZOAxZDHShydXRRxg5GyVZaUBeYX/l6cLAePTt+Hu/awtPQNCkvjELLhxtQwTmsxor
 fSmBvs1OMUlEEEsHSr7p2kMs2qLExT6luE4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e3urstp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:30 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:29 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 59BE32942B57; Mon, 15 Mar 2021 18:14:26 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 08/15] libbpf: Refactor bpf_object__resolve_ksyms_btf_id
Date:   Mon, 15 Mar 2021 18:14:26 -0700
Message-ID: <20210316011426.4178537-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors most of the logic from
bpf_object__resolve_ksyms_btf_id() into a new function
bpf_object__resolve_ksym_var_btf_id().
It is to get ready for a later patch adding
bpf_object__resolve_ksym_func_btf_id() which resolves
a kernel function to the running kernel btf_id.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 125 ++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 57 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2f351d3ad3e7..7d5f9b7877bc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7403,75 +7403,86 @@ static int bpf_object__read_kallsyms_file(struct =
bpf_object *obj)
 	return err;
 }
=20
-static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
+static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
+					       struct extern_desc *ext)
 {
-	struct extern_desc *ext;
+	const struct btf_type *targ_var, *targ_type;
+	__u32 targ_type_id, local_type_id;
+	const char *targ_var_name;
+	int i, id, btf_fd, err;
 	struct btf *btf;
-	int i, j, id, btf_fd, err;
=20
-	for (i =3D 0; i < obj->nr_extern; i++) {
-		const struct btf_type *targ_var, *targ_type;
-		__u32 targ_type_id, local_type_id;
-		const char *targ_var_name;
-		int ret;
+	btf =3D obj->btf_vmlinux;
+	btf_fd =3D 0;
+	id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+	if (id =3D=3D -ENOENT) {
+		err =3D load_module_btfs(obj);
+		if (err)
+			return err;
=20
-		ext =3D &obj->externs[i];
-		if (ext->type !=3D EXT_KSYM || !ext->ksym.type_id)
-			continue;
+		for (i =3D 0; i < obj->btf_module_cnt; i++) {
+			btf =3D obj->btf_modules[i].btf;
+			/* we assume module BTF FD is always >0 */
+			btf_fd =3D obj->btf_modules[i].fd;
+			id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+			if (id !=3D -ENOENT)
+				break;
+		}
+	}
+	if (id <=3D 0) {
+		pr_warn("extern (var ksym) '%s': failed to find BTF ID in kernel BTF(s=
).\n",
+			ext->name);
+		return -ESRCH;
+	}
=20
-		btf =3D obj->btf_vmlinux;
-		btf_fd =3D 0;
-		id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
-		if (id =3D=3D -ENOENT) {
-			err =3D load_module_btfs(obj);
-			if (err)
-				return err;
+	/* find local type_id */
+	local_type_id =3D ext->ksym.type_id;
=20
-			for (j =3D 0; j < obj->btf_module_cnt; j++) {
-				btf =3D obj->btf_modules[j].btf;
-				/* we assume module BTF FD is always >0 */
-				btf_fd =3D obj->btf_modules[j].fd;
-				id =3D btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
-				if (id !=3D -ENOENT)
-					break;
-			}
-		}
-		if (id <=3D 0) {
-			pr_warn("extern (ksym) '%s': failed to find BTF ID in kernel BTF(s).\=
n",
-				ext->name);
-			return -ESRCH;
-		}
+	/* find target type_id */
+	targ_var =3D btf__type_by_id(btf, id);
+	targ_var_name =3D btf__name_by_offset(btf, targ_var->name_off);
+	targ_type =3D skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id=
);
=20
-		/* find local type_id */
-		local_type_id =3D ext->ksym.type_id;
+	err =3D bpf_core_types_are_compat(obj->btf, local_type_id,
+					btf, targ_type_id);
+	if (err <=3D 0) {
+		const struct btf_type *local_type;
+		const char *targ_name, *local_name;
=20
-		/* find target type_id */
-		targ_var =3D btf__type_by_id(btf, id);
-		targ_var_name =3D btf__name_by_offset(btf, targ_var->name_off);
-		targ_type =3D skip_mods_and_typedefs(btf, targ_var->type, &targ_type_i=
d);
+		local_type =3D btf__type_by_id(obj->btf, local_type_id);
+		local_name =3D btf__name_by_offset(obj->btf, local_type->name_off);
+		targ_name =3D btf__name_by_offset(btf, targ_type->name_off);
=20
-		ret =3D bpf_core_types_are_compat(obj->btf, local_type_id,
-						btf, targ_type_id);
-		if (ret <=3D 0) {
-			const struct btf_type *local_type;
-			const char *targ_name, *local_name;
+		pr_warn("extern (var ksym) '%s': incompatible types, expected [%d] %s =
%s, but kernel has [%d] %s %s\n",
+			ext->name, local_type_id,
+			btf_kind_str(local_type), local_name, targ_type_id,
+			btf_kind_str(targ_type), targ_name);
+		return -EINVAL;
+	}
=20
-			local_type =3D btf__type_by_id(obj->btf, local_type_id);
-			local_name =3D btf__name_by_offset(obj->btf, local_type->name_off);
-			targ_name =3D btf__name_by_offset(btf, targ_type->name_off);
+	ext->is_set =3D true;
+	ext->ksym.kernel_btf_obj_fd =3D btf_fd;
+	ext->ksym.kernel_btf_id =3D id;
+	pr_debug("extern (var ksym) '%s': resolved to [%d] %s %s\n",
+		 ext->name, id, btf_kind_str(targ_var), targ_var_name);
=20
-			pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s,=
 but kernel has [%d] %s %s\n",
-				ext->name, local_type_id,
-				btf_kind_str(local_type), local_name, targ_type_id,
-				btf_kind_str(targ_type), targ_name);
-			return -EINVAL;
-		}
+	return 0;
+}
+
+static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
+{
+	struct extern_desc *ext;
+	int i, err;
+
+	for (i =3D 0; i < obj->nr_extern; i++) {
+		ext =3D &obj->externs[i];
+		if (ext->type !=3D EXT_KSYM || !ext->ksym.type_id)
+			continue;
+
+		err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
=20
-		ext->is_set =3D true;
-		ext->ksym.kernel_btf_obj_fd =3D btf_fd;
-		ext->ksym.kernel_btf_id =3D id;
-		pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
-			 ext->name, id, btf_kind_str(targ_var), targ_var_name);
+		if (err)
+			return err;
 	}
 	return 0;
 }
--=20
2.30.2

