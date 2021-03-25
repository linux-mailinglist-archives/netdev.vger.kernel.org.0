Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702D33486AD
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhCYBw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:52:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52570 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239803AbhCYBwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1n228024049
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nU2tvlHVT2FkBfXpp7N0jPpTg3aU4tNZw3lUj0p9qsU=;
 b=MkX9TAHMPI81UMHw9jkwTF2T4dwTiI+bk3WDaMcZWf8BjPJ+/OXGneMeDs1/P94q82KF
 /trkN3Hdi7bP4VjA9odGXjISOEjtVBEf0qypwNVc9mVPl8LrfOY5evmjlSQ1ov8Q3vsu
 kxOI7pDBR8ZZesWdmnRzqSBEeT6MQ7xDr10= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fpghryw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:36 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:34 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1345929429D7; Wed, 24 Mar 2021 18:52:34 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 11/14] libbpf: Support extern kernel function
Date:   Wed, 24 Mar 2021 18:52:34 -0700
Message-ID: <20210325015234.1548923-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
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
extern function in ".ksyms" section.  The func in the BTF datasec also
needs to be replaced by an int var.  The idea is similar to the existing
handling in extern var.  In case the BTF may not have a var, a dummy ksym
var is added at the beginning of bpf_object__collect_externs()
if there is func under ksyms datasec.  It will also change the
func linkage from extern to global which the kernel can support.
It also assigns a param name if it does not have one.

In the collect relo phase, it will record the kernel function
call as RELO_EXTERN_FUNC.

bpf_object__resolve_ksym_func_btf_id() is added to find the func
btf_id of the running kernel.

During actual relocation, it will patch the BPF_CALL instruction with
src_reg =3D BPF_PSEUDO_FUNC_CALL and insn->imm set to the running
kernel func's btf_id.

The required LLVM patch: https://reviews.llvm.org/D93563

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 174 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 162 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 23148566ab3a..c65e56c581f2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -186,6 +186,7 @@ enum reloc_type {
 	RELO_CALL,
 	RELO_DATA,
 	RELO_EXTERN_VAR,
+	RELO_EXTERN_FUNC,
 	RELO_SUBPROG_ADDR,
 };
=20
@@ -1954,6 +1955,11 @@ static const char *btf_kind_str(const struct btf_typ=
e *t)
 	return __btf_kind_str(btf_kind(t));
 }
=20
+static enum btf_func_linkage btf_func_linkage(const struct btf_type *t)
+{
+	return (enum btf_func_linkage)BTF_INFO_VLEN(t->info);
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of arr=
ay
@@ -3018,7 +3024,7 @@ static bool sym_is_subprog(const GElf_Sym *sym, int t=
ext_shndx)
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
 {
 	const struct btf_type *t;
-	const char *var_name;
+	const char *tname;
 	int i, n;
=20
 	if (!btf)
@@ -3028,14 +3034,18 @@ static int find_extern_btf_id(const struct btf *btf=
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
@@ -3148,12 +3158,48 @@ static int find_int_btf_id(const struct btf *btf)
 	return 0;
 }
=20
+static int add_dummy_ksym_var(struct btf *btf)
+{
+	int i, int_btf_id, sec_btf_id, dummy_var_btf_id;
+	const struct btf_var_secinfo *vs;
+	const struct btf_type *sec;
+
+	sec_btf_id =3D btf__find_by_name_kind(btf, KSYMS_SEC,
+					    BTF_KIND_DATASEC);
+	if (sec_btf_id < 0)
+		return 0;
+
+	sec =3D btf__type_by_id(btf, sec_btf_id);
+	vs =3D btf_var_secinfos(sec);
+	for (i =3D 0; i < btf_vlen(sec); i++, vs++) {
+		const struct btf_type *vt;
+
+		vt =3D btf__type_by_id(btf, vs->type);
+		if (btf_is_func(vt))
+			break;
+	}
+
+	/* No func in ksyms sec.  No need to add dummy var. */
+	if (i =3D=3D btf_vlen(sec))
+		return 0;
+
+	int_btf_id =3D find_int_btf_id(btf);
+	dummy_var_btf_id =3D btf__add_var(btf,
+					"dummy_ksym",
+					BTF_VAR_GLOBAL_ALLOCATED,
+					int_btf_id);
+	if (dummy_var_btf_id < 0)
+		pr_warn("cannot create a dummy_ksym var\n");
+
+	return dummy_var_btf_id;
+}
+
 static int bpf_object__collect_externs(struct bpf_object *obj)
 {
 	struct btf_type *sec, *kcfg_sec =3D NULL, *ksym_sec =3D NULL;
 	const struct btf_type *t;
 	struct extern_desc *ext;
-	int i, n, off;
+	int i, n, off, dummy_var_btf_id;
 	const char *ext_name, *sec_name;
 	Elf_Scn *scn;
 	GElf_Shdr sh;
@@ -3165,6 +3211,10 @@ static int bpf_object__collect_externs(struct bpf_ob=
ject *obj)
 	if (elf_sec_hdr(obj, scn, &sh))
 		return -LIBBPF_ERRNO__FORMAT;
=20
+	dummy_var_btf_id =3D add_dummy_ksym_var(obj->btf);
+	if (dummy_var_btf_id < 0)
+		return dummy_var_btf_id;
+
 	n =3D sh.sh_size / sh.sh_entsize;
 	pr_debug("looking for externs among %d symbols...\n", n);
=20
@@ -3209,6 +3259,11 @@ static int bpf_object__collect_externs(struct bpf_ob=
ject *obj)
 		sec_name =3D btf__name_by_offset(obj->btf, sec->name_off);
=20
 		if (strcmp(sec_name, KCONFIG_SEC) =3D=3D 0) {
+			if (btf_is_func(t)) {
+				pr_warn("extern function %s is unsupported under %s section\n",
+					ext->name, KCONFIG_SEC);
+				return -ENOTSUP;
+			}
 			kcfg_sec =3D sec;
 			ext->type =3D EXT_KCFG;
 			ext->kcfg.sz =3D btf__resolve_size(obj->btf, t->type);
@@ -3230,6 +3285,11 @@ static int bpf_object__collect_externs(struct bpf_ob=
ject *obj)
 				return -ENOTSUP;
 			}
 		} else if (strcmp(sec_name, KSYMS_SEC) =3D=3D 0) {
+			if (btf_is_func(t) && ext->is_weak) {
+				pr_warn("extern weak function %s is unsupported\n",
+					ext->name);
+				return -ENOTSUP;
+			}
 			ksym_sec =3D sec;
 			ext->type =3D EXT_KSYM;
 			skip_mods_and_typedefs(obj->btf, t->type,
@@ -3256,7 +3316,14 @@ static int bpf_object__collect_externs(struct bpf_ob=
ject *obj)
 		 * extern variables in DATASEC
 		 */
 		int int_btf_id =3D find_int_btf_id(obj->btf);
+		/* For extern function, a dummy_var added earlier
+		 * will be used to replace the vs->type and
+		 * its name string will be used to refill
+		 * the missing param's name.
+		 */
+		const struct btf_type *dummy_var;
=20
+		dummy_var =3D btf__type_by_id(obj->btf, dummy_var_btf_id);
 		for (i =3D 0; i < obj->nr_extern; i++) {
 			ext =3D &obj->externs[i];
 			if (ext->type !=3D EXT_KSYM)
@@ -3275,12 +3342,32 @@ static int bpf_object__collect_externs(struct bpf_o=
bject *obj)
 			ext_name =3D btf__name_by_offset(obj->btf, vt->name_off);
 			ext =3D find_extern_by_name(obj, ext_name);
 			if (!ext) {
-				pr_warn("failed to find extern definition for BTF var '%s'\n",
-					ext_name);
+				pr_warn("failed to find extern definition for BTF %s '%s'\n",
+					btf_kind_str(vt), ext_name);
 				return -ESRCH;
 			}
-			btf_var(vt)->linkage =3D BTF_VAR_GLOBAL_ALLOCATED;
-			vt->type =3D int_btf_id;
+			if (btf_is_func(vt)) {
+				const struct btf_type *func_proto;
+				struct btf_param *param;
+				int j;
+
+				func_proto =3D btf__type_by_id(obj->btf,
+							     vt->type);
+				param =3D btf_params(func_proto);
+				/* Reuse the dummy_var string if the
+				 * func proto does not have param name.
+				 */
+				for (j =3D 0; j < btf_vlen(func_proto); j++)
+					if (param[j].type && !param[j].name_off)
+						param[j].name_off =3D
+							dummy_var->name_off;
+				vs->type =3D dummy_var_btf_id;
+				vt->info &=3D ~0xffff;
+				vt->info |=3D BTF_FUNC_GLOBAL;
+			} else {
+				btf_var(vt)->linkage =3D BTF_VAR_GLOBAL_ALLOCATED;
+				vt->type =3D int_btf_id;
+			}
 			vs->offset =3D off;
 			vs->size =3D sizeof(int);
 		}
@@ -3435,7 +3522,10 @@ static int bpf_program__record_reloc(struct bpf_prog=
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
@@ -6240,6 +6330,12 @@ bpf_object__relocate_data(struct bpf_object *obj, st=
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
@@ -7360,6 +7456,7 @@ static int bpf_object__read_kallsyms_file(struct bpf_=
object *obj)
 {
 	char sym_type, sym_name[500];
 	unsigned long long sym_addr;
+	const struct btf_type *t;
 	struct extern_desc *ext;
 	int ret, err =3D 0;
 	FILE *f;
@@ -7386,6 +7483,10 @@ static int bpf_object__read_kallsyms_file(struct bpf=
_object *obj)
 		if (!ext || ext->type !=3D EXT_KSYM)
 			continue;
=20
+		t =3D btf__type_by_id(obj->btf, ext->btf_id);
+		if (!btf_is_var(t))
+			continue;
+
 		if (ext->is_set && ext->ksym.addr !=3D sym_addr) {
 			pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n=
",
 				sym_name, ext->ksym.addr, sym_addr);
@@ -7487,8 +7588,53 @@ static int bpf_object__resolve_ksym_var_btf_id(struc=
t bpf_object *obj,
 	return 0;
 }
=20
+static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
+						struct extern_desc *ext)
+{
+	int local_func_proto_id, kfunc_proto_id, kfunc_id;
+	const struct btf_type *kern_func;
+	struct btf *kern_btf =3D NULL;
+	int ret, kern_btf_fd =3D 0;
+
+	local_func_proto_id =3D ext->ksym.type_id;
+
+	kfunc_id =3D find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
+				    &kern_btf, &kern_btf_fd);
+	if (kfunc_id < 0) {
+		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+			ext->name);
+		return kfunc_id;
+	}
+
+	if (kern_btf !=3D obj->btf_vmlinux) {
+		pr_warn("extern (func ksym) '%s': function in kernel module is not suppo=
rted\n",
+			ext->name);
+		return -ENOTSUP;
+	}
+
+	kern_func =3D btf__type_by_id(kern_btf, kfunc_id);
+	kfunc_proto_id =3D kern_func->type;
+
+	ret =3D bpf_core_types_are_compat(obj->btf, local_func_proto_id,
+					kern_btf, kfunc_proto_id);
+	if (ret <=3D 0) {
+		pr_warn("extern (func ksym) '%s': func_proto [%d] incompatible with kern=
el [%d]\n",
+			ext->name, local_func_proto_id, kfunc_proto_id);
+		return -EINVAL;
+	}
+
+	ext->is_set =3D true;
+	ext->ksym.kernel_btf_obj_fd =3D kern_btf_fd;
+	ext->ksym.kernel_btf_id =3D kfunc_id;
+	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
+		 ext->name, kfunc_id);
+
+	return 0;
+}
+
 static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 {
+	const struct btf_type *t;
 	struct extern_desc *ext;
 	int i, err;
=20
@@ -7497,7 +7643,11 @@ static int bpf_object__resolve_ksyms_btf_id(struct b=
pf_object *obj)
 		if (ext->type !=3D EXT_KSYM || !ext->ksym.type_id)
 			continue;
=20
-		err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
+		t =3D btf__type_by_id(obj->btf, ext->btf_id);
+		if (btf_is_var(t))
+			err =3D bpf_object__resolve_ksym_var_btf_id(obj, ext);
+		else
+			err =3D bpf_object__resolve_ksym_func_btf_id(obj, ext);
 		if (err)
 			return err;
 	}
--=20
2.30.2

