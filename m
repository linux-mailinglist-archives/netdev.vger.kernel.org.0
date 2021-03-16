Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD2D33CAB2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhCPBP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:15:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2360 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234215AbhCPBOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:55 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1AeUi015803
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VlYqc/dwAnP9Z3Ogio7FrrdWcqY1nQAq1pr98kTDUIk=;
 b=P405Yr+Y5JwyT0CsvFDE5zqM7BcOw9OtlWPcTgiyL+0NsW1wjWiECXc3FrwyypcruxYs
 8UQczDofQ05frGVcovH++yxcFGbWjLs+PmfldaCpqQI4KxW7akbfhXBA+U3t1ZEQwv7c
 LM+bt7wGE2CMaMGWaIJVshRvteK3GIGchfc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e118tug-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:54 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:53 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 58E622942B57; Mon, 15 Mar 2021 18:14:51 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 12/15] libbpf: Support extern kernel function
Date:   Mon, 15 Mar 2021 18:14:51 -0700
Message-ID: <20210316011451.4180026-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to make libbpf able to handle the following extern
kernel function declaration and do the needed relocations before
loading the bpf program to the kernel.

extern int foo(struct sock *) __attribute__((section(".ksyms")))

In the collect extern phase, needed changes is made to
bpf_object__collect_externs() and find_extern_btf_id() to collect
function.

In the collect relo phase, it will record the kernel function
call as RELO_EXTERN_FUNC.

bpf_object__resolve_ksym_func_btf_id() is added to find the func
btf_id of the running kernel.

During actual relocation, it will patch the BPF_CALL instruction with
src_reg =3D BPF_PSEUDO_FUNC_CALL and insn->imm set to the running
kernel func's btf_id.

btf_fixup_datasec() is changed also because a datasec may
only have func and its size will be 0.  The "!size" test
is postponed till it is confirmed there are vars.
It also takes this chance to remove the
"if (... || (t->size && t->size !=3D size)) { return -ENOENT; }" test
because t->size is zero at the point.

The required LLVM patch: https://reviews.llvm.org/D93563

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/btf.c    |  32 ++++++++----
 tools/lib/bpf/btf.h    |   5 ++
 tools/lib/bpf/libbpf.c | 113 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 129 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3aa58f2ac183..bb09b577c154 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1108,7 +1108,7 @@ static int btf_fixup_datasec(struct bpf_object *obj, =
struct btf *btf,
 	const struct btf_type *t_var;
 	struct btf_var_secinfo *vsi;
 	const struct btf_var *var;
-	int ret;
+	int ret, nr_vars =3D 0;
=20
 	if (!name) {
 		pr_debug("No name found in string section for DATASEC kind.\n");
@@ -1117,27 +1117,27 @@ static int btf_fixup_datasec(struct bpf_object *obj=
, struct btf *btf,
=20
 	/* .extern datasec size and var offsets were set correctly during
 	 * extern collection step, so just skip straight to sorting variables
+	 * One exception is the datasec may only have extern funcs,
+	 * t->size is 0 in this case.  This will be handled
+	 * with !nr_vars later.
 	 */
 	if (t->size)
 		goto sort_vars;
=20
-	ret =3D bpf_object__section_size(obj, name, &size);
-	if (ret || !size || (t->size && t->size !=3D size)) {
-		pr_debug("Invalid size for section %s: %u bytes\n", name, size);
-		return -ENOENT;
-	}
-
-	t->size =3D size;
+	bpf_object__section_size(obj, name, &size);
=20
 	for (i =3D 0, vsi =3D btf_var_secinfos(t); i < vars; i++, vsi++) {
 		t_var =3D btf__type_by_id(btf, vsi->type);
-		var =3D btf_var(t_var);
=20
-		if (!btf_is_var(t_var)) {
-			pr_debug("Non-VAR type seen in section %s\n", name);
+		if (btf_is_func(t_var)) {
+			continue;
+		} else if (!btf_is_var(t_var)) {
+			pr_debug("Non-VAR and Non-FUNC type seen in section %s\n", name);
 			return -EINVAL;
 		}
=20
+		nr_vars++;
+		var =3D btf_var(t_var);
 		if (var->linkage =3D=3D BTF_VAR_STATIC)
 			continue;
=20
@@ -1157,6 +1157,16 @@ static int btf_fixup_datasec(struct bpf_object *obj,=
 struct btf *btf,
 		vsi->offset =3D off;
 	}
=20
+	if (!nr_vars)
+		return 0;
+
+	if (!size) {
+		pr_debug("Invalid size for section %s: %u bytes\n", name, size);
+		return -ENOENT;
+	}
+
+	t->size =3D size;
+
 sort_vars:
 	qsort(btf_var_secinfos(t), vars, sizeof(*vsi), compare_vsi_off);
 	return 0;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 029a9cfc8c2d..07d508b70497 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -368,6 +368,11 @@ btf_var_secinfos(const struct btf_type *t)
 	return (struct btf_var_secinfo *)(t + 1);
 }
=20
+static inline enum btf_func_linkage btf_func_linkage(const struct btf_type=
 *t)
+{
+	return (enum btf_func_linkage)BTF_INFO_VLEN(t->info);
+}
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0a60fcb2fba2..49bda179bd93 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -190,6 +190,7 @@ enum reloc_type {
 	RELO_CALL,
 	RELO_DATA,
 	RELO_EXTERN_VAR,
+	RELO_EXTERN_FUNC,
 	RELO_SUBPROG_ADDR,
 };
=20
@@ -384,6 +385,7 @@ struct extern_desc {
 	int btf_id;
 	int sec_btf_id;
 	const char *name;
+	const struct btf_type *btf_type;
 	bool is_set;
 	bool is_weak;
 	union {
@@ -3022,7 +3024,7 @@ static bool sym_is_subprog(const GElf_Sym *sym, int t=
ext_shndx)
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
 {
 	const struct btf_type *t;
-	const char *var_name;
+	const char *tname;
 	int i, n;
=20
 	if (!btf)
@@ -3032,14 +3034,18 @@ static int find_extern_btf_id(const struct btf *btf=
, const char *ext_name)
 	for (i =3D 1; i <=3D n; i++) {
 		t =3D btf__type_by_id(btf, i);
=20
-		if (!btf_is_var(t))
+		if (!btf_is_var(t) && !btf_is_func(t))
 			continue;
=20
-		var_name =3D btf__name_by_offset(btf, t->name_off);
-		if (strcmp(var_name, ext_name))
+		tname =3D btf__name_by_offset(btf, t->name_off);
+		if (strcmp(tname, ext_name))
 			continue;
=20
-		if (btf_var(t)->linkage !=3D BTF_VAR_GLOBAL_EXTERN)
+		if (btf_is_var(t) &&
+		    btf_var(t)->linkage !=3D BTF_VAR_GLOBAL_EXTERN)
+			return -EINVAL;
+
+		if (btf_is_func(t) && btf_func_linkage(t) !=3D BTF_FUNC_EXTERN)
 			return -EINVAL;
=20
 		return i;
@@ -3199,10 +3205,10 @@ static int bpf_object__collect_externs(struct bpf_o=
bject *obj)
 			return ext->btf_id;
 		}
 		t =3D btf__type_by_id(obj->btf, ext->btf_id);
+		ext->btf_type =3D t;
 		ext->name =3D btf__name_by_offset(obj->btf, t->name_off);
 		ext->sym_idx =3D i;
 		ext->is_weak =3D GELF_ST_BIND(sym.st_info) =3D=3D STB_WEAK;
-
 		ext->sec_btf_id =3D find_extern_sec_btf_id(obj->btf, ext->btf_id);
 		if (ext->sec_btf_id <=3D 0) {
 			pr_warn("failed to find BTF for extern '%s' [%d] section: %d\n",
@@ -3212,6 +3218,34 @@ static int bpf_object__collect_externs(struct bpf_ob=
ject *obj)
 		sec =3D (void *)btf__type_by_id(obj->btf, ext->sec_btf_id);
 		sec_name =3D btf__name_by_offset(obj->btf, sec->name_off);
=20
+		if (btf_is_func(t)) {
+			const struct btf_type *func_proto;
+
+			func_proto =3D btf__type_by_id(obj->btf, t->type);
+			if (!func_proto || !btf_is_func_proto(func_proto)) {
+				pr_warn("extern function %s does not have a valid func_proto\n",
+					ext->name);
+				return -EINVAL;
+			}
+
+			if (ext->is_weak) {
+				pr_warn("extern weak function %s is unsupported\n",
+					ext->name);
+				return -ENOTSUP;
+			}
+
+			if (strcmp(sec_name, KSYMS_SEC)) {
+				pr_warn("extern function %s is only supported under %s section\n",
+					ext->name, KSYMS_SEC);
+				return -ENOTSUP;
+			}
+
+			ksym_sec =3D sec;
+			ext->type =3D EXT_KSYM;
+			ext->ksym.type_id =3D ext->btf_id;
+			continue;
+		}
+
 		if (strcmp(sec_name, KCONFIG_SEC) =3D=3D 0) {
 			kcfg_sec =3D sec;
 			ext->type =3D EXT_KCFG;
@@ -3271,11 +3305,13 @@ static int bpf_object__collect_externs(struct bpf_o=
bject *obj)
=20
 		sec =3D ksym_sec;
 		n =3D btf_vlen(sec);
-		for (i =3D 0, off =3D 0; i < n; i++, off +=3D sizeof(int)) {
+		for (i =3D 0, off =3D 0; i < n; i++) {
 			struct btf_var_secinfo *vs =3D btf_var_secinfos(sec) + i;
 			struct btf_type *vt;
=20
 			vt =3D (void *)btf__type_by_id(obj->btf, vs->type);
+			if (!btf_is_var(vt))
+				continue;
 			ext_name =3D btf__name_by_offset(obj->btf, vt->name_off);
 			ext =3D find_extern_by_name(obj, ext_name);
 			if (!ext) {
@@ -3287,6 +3323,7 @@ static int bpf_object__collect_externs(struct bpf_obj=
ect *obj)
 			vt->type =3D int_btf_id;
 			vs->offset =3D off;
 			vs->size =3D sizeof(int);
+			off +=3D sizeof(int);
 		}
 		sec->size =3D off;
 	}
@@ -3439,7 +3476,10 @@ static int bpf_program__record_reloc(struct bpf_prog=
ram *prog,
 		}
 		pr_debug("prog '%s': found extern #%d '%s' (sym %d) for insn #%u\n",
 			 prog->name, i, ext->name, ext->sym_idx, insn_idx);
-		reloc_desc->type =3D RELO_EXTERN_VAR;
+		if (insn->code =3D=3D (BPF_JMP | BPF_CALL))
+			reloc_desc->type =3D RELO_EXTERN_FUNC;
+		else
+			reloc_desc->type =3D RELO_EXTERN_VAR;
 		reloc_desc->insn_idx =3D insn_idx;
 		reloc_desc->sym_off =3D i; /* sym_off stores extern index */
 		return 0;
@@ -6244,6 +6284,12 @@ bpf_object__relocate_data(struct bpf_object *obj, st=
ruct bpf_program *prog)
 			}
 			relo->processed =3D true;
 			break;
+		case RELO_EXTERN_FUNC:
+			ext =3D &obj->externs[relo->sym_off];
+			insn[0].src_reg =3D BPF_PSEUDO_KFUNC_CALL;
+			insn[0].imm =3D ext->ksym.kernel_btf_id;
+			relo->processed =3D true;
+			break;
 		case RELO_SUBPROG_ADDR:
 			insn[0].src_reg =3D BPF_PSEUDO_FUNC;
 			/* will be handled as a follow up pass */
@@ -7387,7 +7433,7 @@ static int bpf_object__read_kallsyms_file(struct bpf_=
object *obj)
 		}
=20
 		ext =3D find_extern_by_name(obj, sym_name);
-		if (!ext || ext->type !=3D EXT_KSYM)
+		if (!ext || ext->type !=3D EXT_KSYM || !btf_is_var(ext->btf_type))
 			continue;
=20
 		if (ext->is_set && ext->ksym.addr !=3D sym_addr) {
@@ -7491,6 +7537,50 @@ static int bpf_object__resolve_ksym_var_btf_id(struc=
t bpf_object *obj,
 	return 0;
 }
=20
+static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
+						struct extern_desc *ext)
+{
+	int local_func_proto_id, kern_func_proto_id, kern_func_id;
+	const struct btf_type *kern_func;
+	struct btf *kern_btf =3D NULL;
+	int ret, kern_btf_fd =3D 0;
+
+	local_func_proto_id =3D ext->btf_type->type;
+
+	kern_func_id =3D find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
+					&kern_btf, &kern_btf_fd);
+	if (kern_func_id < 0) {
+		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+			ext->name);
+		return kern_func_id;
+	}
+
+	if (kern_btf !=3D obj->btf_vmlinux) {
+		pr_warn("extern (func ksym) '%s': function in kernel module is not suppo=
rted\n",
+			ext->name);
+		return -ENOTSUP;
+	}
+
+	kern_func =3D btf__type_by_id(kern_btf, kern_func_id);
+	kern_func_proto_id =3D kern_func->type;
+
+	ret =3D bpf_core_types_are_compat(obj->btf, local_func_proto_id,
+					kern_btf, kern_func_proto_id);
+	if (ret <=3D 0) {
+		pr_warn("extern (func ksym) '%s': func_proto [%d] incompatible with kern=
el [%d]\n",
+			ext->name, local_func_proto_id, kern_func_proto_id);
+		return -EINVAL;
+	}
+
+	ext->is_set =3D true;
+	ext->ksym.kernel_btf_obj_fd =3D kern_btf_fd;
+	ext->ksym.kernel_btf_id =3D kern_func_id;
+	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
+		 ext->name, kern_func_id);
+
+	return 0;
+}
+
 static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 {
 	struct extern_desc *ext;
@@ -7501,7 +7591,10 @@ static int bpf_object__resolve_ksyms_btf_id(struct b=
pf_object *obj)
 		if (ext->type !=3D EXT_KSYM || !ext->ksym.type_id)
 			continue;
=20
-		err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
+		if (btf_is_var(ext->btf_type))
+			err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
+		else
+			err =3D bpf_object__resolve_ksym_func_btf_id(obj, ext);
=20
 		if (err)
 			return err;
--=20
2.30.2

