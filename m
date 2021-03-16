Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEFB33CAA3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhCPBOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43722 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231531AbhCPBN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:13:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1DGMG015839
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xwwBwHqzy8q8MyRsfYvaHjpgtgOnPHWDwYSpwxXwFIs=;
 b=ePuyEhxnKFZgYEaytHAJ7UNJvspoyhbNEf593TiahX/1h1QqISgNi/hTenfx8CYA6I2v
 QDWUI8j1oQ79Uz/asNqPcbH9RZ5ZUmJYBTSsJp25U28tCFMhwOKATia/fiDxiehD3MsM
 SlECihwBd3rFtc/MZE5QfRZzgkd5mf7NVQI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378v3q3ppv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:55 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:13:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D23CA2942B4F; Mon, 15 Mar 2021 18:13:48 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Date:   Mon, 15 Mar 2021 18:13:48 -0700
Message-ID: <20210316011348.4175708-1-kafai@fb.com>
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
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes BTF verifier to accept extern func. It is used for
allowing bpf program to call a limited set of kernel functions
in a later patch.

When writing bpf prog, the extern kernel function needs
to be declared under a ELF section (".ksyms") which is
the same as the current extern kernel variables and that should
keep its usage consistent without requiring to remember another
section name.

For example, in a bpf_prog.c:

extern int foo(struct sock *) __attribute__((section(".ksyms")))

[24] FUNC_PROTO '(anon)' ret_type_id=3D15 vlen=3D1
	'(anon)' type_id=3D18
[25] FUNC 'foo' type_id=3D24 linkage=3Dextern
[ ... ]
[33] DATASEC '.ksyms' size=3D0 vlen=3D1
	type_id=3D25 offset=3D0 size=3D0

LLVM will put the "func" type into the BTF datasec ".ksyms".
The current "btf_datasec_check_meta()" assumes everything under
it is a "var" and ensures it has non-zero size ("!vsi->size" test).
The non-zero size check is not true for "func".  This patch postpones the
"!vsi-size" test from "btf_datasec_check_meta()" to
"btf_datasec_resolve()" which has all types collected to decide
if a vsi is a "var" or a "func" and then enforce the "vsi->size"
differently.

If the datasec only has "func", its "t->size" could be zero.
Thus, the current "!t->size" test is no longer valid.  The
invalid "t->size" will still be caught by the later
"last_vsi_end_off > t->size" check.   This patch also takes this
chance to consolidate other "t->size" tests ("vsi->offset >=3D t->size"
"vsi->size > t->size", and "t->size < sum") into the existing
"last_vsi_end_off > t->size" test.

The LLVM will also put those extern kernel function as an extern
linkage func in the BTF:

[24] FUNC_PROTO '(anon)' ret_type_id=3D15 vlen=3D1
	'(anon)' type_id=3D18
[25] FUNC 'foo' type_id=3D24 linkage=3Dextern

This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
Also extern kernel function declaration does not
necessary have arg name. Another change in btf_func_check() is
to allow extern function having no arg name.

The btf selftest is adjusted accordingly.  New tests are also added.

The required LLVM patch: https://reviews.llvm.org/D93563

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c                             |  52 ++++---
 tools/testing/selftests/bpf/prog_tests/btf.c | 154 ++++++++++++++++++-
 2 files changed, 178 insertions(+), 28 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 369faeddf1df..96cd24020a38 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3439,7 +3439,7 @@ static s32 btf_func_check_meta(struct btf_verifier_en=
v *env,
 		return -EINVAL;
 	}
=20
-	if (btf_type_vlen(t) > BTF_FUNC_GLOBAL) {
+	if (btf_type_vlen(t) > BTF_FUNC_EXTERN) {
 		btf_verifier_log_type(env, t, "Invalid func linkage");
 		return -EINVAL;
 	}
@@ -3532,7 +3532,7 @@ static s32 btf_datasec_check_meta(struct btf_verifier=
_env *env,
 				  u32 meta_left)
 {
 	const struct btf_var_secinfo *vsi;
-	u64 last_vsi_end_off =3D 0, sum =3D 0;
+	u64 last_vsi_end_off =3D 0;
 	u32 i, meta_needed;
=20
 	meta_needed =3D btf_type_vlen(t) * sizeof(*vsi);
@@ -3543,11 +3543,6 @@ static s32 btf_datasec_check_meta(struct btf_verifie=
r_env *env,
 		return -EINVAL;
 	}
=20
-	if (!t->size) {
-		btf_verifier_log_type(env, t, "size =3D=3D 0");
-		return -EINVAL;
-	}
-
 	if (btf_type_kflag(t)) {
 		btf_verifier_log_type(env, t, "Invalid btf_info kind_flag");
 		return -EINVAL;
@@ -3569,19 +3564,13 @@ static s32 btf_datasec_check_meta(struct btf_verifi=
er_env *env,
 			return -EINVAL;
 		}
=20
-		if (vsi->offset < last_vsi_end_off || vsi->offset >=3D t->size) {
+		if (vsi->offset < last_vsi_end_off) {
 			btf_verifier_log_vsi(env, t, vsi,
 					     "Invalid offset");
 			return -EINVAL;
 		}
=20
-		if (!vsi->size || vsi->size > t->size) {
-			btf_verifier_log_vsi(env, t, vsi,
-					     "Invalid size");
-			return -EINVAL;
-		}
-
-		last_vsi_end_off =3D vsi->offset + vsi->size;
+		last_vsi_end_off =3D (u64)vsi->offset + vsi->size;
 		if (last_vsi_end_off > t->size) {
 			btf_verifier_log_vsi(env, t, vsi,
 					     "Invalid offset+size");
@@ -3589,12 +3578,6 @@ static s32 btf_datasec_check_meta(struct btf_verifie=
r_env *env,
 		}
=20
 		btf_verifier_log_vsi(env, t, vsi, NULL);
-		sum +=3D vsi->size;
-	}
-
-	if (t->size < sum) {
-		btf_verifier_log_type(env, t, "Invalid btf_info size");
-		return -EINVAL;
 	}
=20
 	return meta_needed;
@@ -3611,9 +3594,28 @@ static int btf_datasec_resolve(struct btf_verifier_e=
nv *env,
 		u32 var_type_id =3D vsi->type, type_id, type_size =3D 0;
 		const struct btf_type *var_type =3D btf_type_by_id(env->btf,
 								 var_type_id);
-		if (!var_type || !btf_type_is_var(var_type)) {
+		if (!var_type) {
+			btf_verifier_log_vsi(env, v->t, vsi,
+					     "type not found");
+			return -EINVAL;
+		}
+
+		if (btf_type_is_func(var_type)) {
+			if (vsi->size || vsi->offset) {
+				btf_verifier_log_vsi(env, v->t, vsi,
+						     "Invalid size/offset");
+				return -EINVAL;
+			}
+			continue;
+		} else if (btf_type_is_var(var_type)) {
+			if (!vsi->size) {
+				btf_verifier_log_vsi(env, v->t, vsi,
+						     "Invalid size");
+				return -EINVAL;
+			}
+		} else {
 			btf_verifier_log_vsi(env, v->t, vsi,
-					     "Not a VAR kind member");
+					     "Neither a VAR nor a FUNC");
 			return -EINVAL;
 		}
=20
@@ -3849,9 +3851,11 @@ static int btf_func_check(struct btf_verifier_env *e=
nv,
 	const struct btf_param *args;
 	const struct btf *btf;
 	u16 nr_args, i;
+	bool is_extern;
=20
 	btf =3D env->btf;
 	proto_type =3D btf_type_by_id(btf, t->type);
+	is_extern =3D btf_type_vlen(t) =3D=3D BTF_FUNC_EXTERN;
=20
 	if (!proto_type || !btf_type_is_func_proto(proto_type)) {
 		btf_verifier_log_type(env, t, "Invalid type_id");
@@ -3861,7 +3865,7 @@ static int btf_func_check(struct btf_verifier_env *en=
v,
 	args =3D (const struct btf_param *)(proto_type + 1);
 	nr_args =3D btf_type_vlen(proto_type);
 	for (i =3D 0; i < nr_args; i++) {
-		if (!args[i].name_off && args[i].type) {
+		if (!is_extern && !args[i].name_off && args[i].type) {
 			btf_verifier_log_type(env, t, "Invalid arg#%u", i + 1);
 			return -EINVAL;
 		}
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/s=
elftests/bpf/prog_tests/btf.c
index 0457ae32b270..e469482833b2 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -498,7 +498,7 @@ static struct btf_raw_test raw_tests[] =3D {
 	.value_type_id =3D 7,
 	.max_entries =3D 1,
 	.btf_load_err =3D true,
-	.err_str =3D "Invalid size",
+	.err_str =3D "Invalid offset+size",
 },
 {
 	.descr =3D "global data test #10, invalid var size",
@@ -696,7 +696,7 @@ static struct btf_raw_test raw_tests[] =3D {
 	.err_str =3D "Invalid offset",
 },
 {
-	.descr =3D "global data test #15, not var kind",
+	.descr =3D "global data test #15, not var/func kind",
 	.raw_types =3D {
 		/* int */
 		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
@@ -716,7 +716,7 @@ static struct btf_raw_test raw_tests[] =3D {
 	.value_type_id =3D 3,
 	.max_entries =3D 1,
 	.btf_load_err =3D true,
-	.err_str =3D "Not a VAR kind member",
+	.err_str =3D "Neither a VAR nor a FUNC",
 },
 {
 	.descr =3D "global data test #16, invalid var referencing sec",
@@ -2803,7 +2803,7 @@ static struct btf_raw_test raw_tests[] =3D {
 			BTF_FUNC_PROTO_ARG_ENC(NAME_TBD, 1),
 			BTF_FUNC_PROTO_ARG_ENC(NAME_TBD, 2),
 		/* void func(int a, unsigned int b) */
-		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 2), 3), 	/* [4] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 3), 3), 	/* [4] */
 		BTF_END_RAW,
 	},
 	.str_sec =3D "\0a\0b\0func",
@@ -3531,6 +3531,152 @@ static struct btf_raw_test raw_tests[] =3D {
 	.max_entries =3D 1,
 },
=20
+{
+	.descr =3D "datasec: func only",
+	.raw_types =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
+		/* void (*)(void) */
+		BTF_FUNC_PROTO_ENC(0, 0),		/* [2] */
+		BTF_FUNC_ENC(NAME_NTH(1), 2),		/* [3] */
+		BTF_FUNC_ENC(NAME_NTH(2), 2),		/* [4] */
+		/* .ksym section */
+		BTF_TYPE_ENC(NAME_NTH(3), BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 2), 0), /* [=
5] */
+		BTF_VAR_SECINFO_ENC(3, 0, 0),
+		BTF_VAR_SECINFO_ENC(4, 0, 0),
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0foo1\0foo2\0.ksym\0"),
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.key_type_id =3D 1,
+	.value_type_id =3D 1,
+	.max_entries =3D 1,
+},
+
+{
+	.descr =3D "datasec: func and var",
+	.raw_types =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
+		/* void (*)(void) */
+		BTF_FUNC_PROTO_ENC(0, 0),		/* [2] */
+		BTF_FUNC_ENC(NAME_NTH(1), 2),		/* [3] */
+		BTF_FUNC_ENC(NAME_NTH(2), 2),		/* [4] */
+		/* int */
+		BTF_VAR_ENC(NAME_NTH(4), 1, 0),		/* [5] */
+		BTF_VAR_ENC(NAME_NTH(5), 1, 0),		/* [6] */
+		/* .ksym section */
+		BTF_TYPE_ENC(NAME_NTH(3), BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 4), 8), /* [=
7] */
+		BTF_VAR_SECINFO_ENC(3, 0, 0),
+		BTF_VAR_SECINFO_ENC(4, 0, 0),
+		BTF_VAR_SECINFO_ENC(5, 0, 4),
+		BTF_VAR_SECINFO_ENC(6, 4, 4),
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0foo1\0foo2\0.ksym\0a\0b\0"),
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.key_type_id =3D 1,
+	.value_type_id =3D 1,
+	.max_entries =3D 1,
+},
+
+{
+	.descr =3D "datasec: func and var, invalid size/offset for func",
+	.raw_types =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
+		/* void (*)(void) */
+		BTF_FUNC_PROTO_ENC(0, 0),		/* [2] */
+		BTF_FUNC_ENC(NAME_NTH(1), 2),		/* [3] */
+		BTF_FUNC_ENC(NAME_NTH(2), 2),		/* [4] */
+		/* int */
+		BTF_VAR_ENC(NAME_NTH(4), 1, 0),		/* [5] */
+		BTF_VAR_ENC(NAME_NTH(5), 1, 0),		/* [6] */
+		/* .ksym section */
+		BTF_TYPE_ENC(NAME_NTH(3), BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 4), 8), /* [=
7] */
+		BTF_VAR_SECINFO_ENC(3, 0, 0),
+		BTF_VAR_SECINFO_ENC(5, 0, 4),
+		BTF_VAR_SECINFO_ENC(4, 4, 0),	/* func has non zero vsi->offset */
+		BTF_VAR_SECINFO_ENC(6, 4, 4),
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0foo1\0foo2\0.ksym\0a\0b\0"),
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.key_type_id =3D 1,
+	.value_type_id =3D 1,
+	.max_entries =3D 1,
+	.btf_load_err =3D true,
+	.err_str =3D "Invalid size/offset",
+},
+
+{
+	.descr =3D "datasec: func and var, datasec size 0",
+	.raw_types =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
+		/* void (*)(void) */
+		BTF_FUNC_PROTO_ENC(0, 0),		/* [2] */
+		BTF_FUNC_ENC(NAME_NTH(1), 2),		/* [3] */
+		BTF_FUNC_ENC(NAME_NTH(2), 2),		/* [4] */
+		/* int */
+		BTF_VAR_ENC(NAME_NTH(4), 1, 0),		/* [5] */
+		BTF_VAR_ENC(NAME_NTH(5), 1, 0),		/* [6] */
+		/* .ksym section */
+		BTF_TYPE_ENC(NAME_NTH(3), BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 4), 0), /* [=
7] */
+		BTF_VAR_SECINFO_ENC(3, 0, 0),
+		BTF_VAR_SECINFO_ENC(4, 0, 0),
+		BTF_VAR_SECINFO_ENC(5, 0, 4),
+		BTF_VAR_SECINFO_ENC(6, 4, 4),
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0foo1\0foo2\0.ksym\0a\0b\0"),
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.key_type_id =3D 1,
+	.value_type_id =3D 1,
+	.max_entries =3D 1,
+	.btf_load_err =3D true,
+	.err_str =3D "Invalid offset+size",
+},
+
+{
+	.descr =3D "datasec: func and var, zero vsi->size for var",
+	.raw_types =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),	/* [1] */
+		/* void (*)(void) */
+		BTF_FUNC_PROTO_ENC(0, 0),		/* [2] */
+		BTF_FUNC_ENC(NAME_NTH(1), 2),		/* [3] */
+		BTF_FUNC_ENC(NAME_NTH(2), 2),		/* [4] */
+		/* int */
+		BTF_VAR_ENC(NAME_NTH(4), 1, 0),		/* [5] */
+		BTF_VAR_ENC(NAME_NTH(5), 1, 0),		/* [6] */
+		/* .ksym section */
+		BTF_TYPE_ENC(NAME_NTH(3), BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 4), 8), /* [=
7] */
+		BTF_VAR_SECINFO_ENC(3, 0, 0),
+		BTF_VAR_SECINFO_ENC(4, 0, 0),
+		BTF_VAR_SECINFO_ENC(5, 0, 0),	/* var has zero vsi->size */
+		BTF_VAR_SECINFO_ENC(6, 0, 4),
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0foo1\0foo2\0.ksym\0a\0b\0"),
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.key_type_id =3D 1,
+	.value_type_id =3D 1,
+	.max_entries =3D 1,
+	.btf_load_err =3D true,
+	.err_str =3D "Invalid size",
+},
+
 {
 	.descr =3D "float test #1, well-formed",
 	.raw_types =3D {
--=20
2.30.2

