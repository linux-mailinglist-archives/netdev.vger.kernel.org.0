Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D645723F417
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHGVGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:06:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgHGVGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:41 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077KsA1K013865
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JFenIw8IBV9oYWzueV2mqeUEk3vDBpYF1PNutqwBb0Y=;
 b=J1OgXTEsfkeji8CEAri+jifyfNSsFhII5jOdP/ZKh8Yxc97ixLeuQjVRHWvnwSy7Iewv
 VQlHvWXUgOyaR2/UNFa7wqVUoLZrd+QP6rZtQwC/mhfAgKicXHhm5008//kNaQ4Nori4
 qtX/vauOmFLH8bSqAqfN3gjy9u0iwLsfduk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32qy47mmy5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:40 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D00D82EC5494; Fri,  7 Aug 2020 14:06:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 2/7] libbpf: make kernel feature probing lazy
Date:   Fri, 7 Aug 2020 14:06:24 -0700
Message-ID: <20200807210629.394335-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200807210629.394335-1-andriin@fb.com>
References: <20200807210629.394335-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=9 mlxlogscore=999 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turn libbpf's kernel feature probing into lazily-performed checks. This a=
llows
to skip performing unnecessary feature checks, if a given BPF application
doesn't rely on a particular kernel feature. As we grow number of feature
probes, libbpf might perform less unnecessary syscalls and scale better w=
ith
number of feature probes long-term.

By decoupling feature checks from bpf_object, it's also possible to perfo=
rm
feature probing from libbpf static helpers and low-level APIs, if necessa=
ry.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 150 +++++++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 64 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7be04e45d29c..8e329c57be51 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -165,23 +165,26 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
=20
-struct bpf_capabilities {
+enum kern_feature_id {
 	/* v4.14: kernel support for program & map names. */
-	__u32 name:1;
+	FEAT_PROG_NAME,
 	/* v5.2: kernel support for global data sections. */
-	__u32 global_data:1;
+	FEAT_GLOBAL_DATA,
 	/* BTF_KIND_FUNC and BTF_KIND_FUNC_PROTO support */
-	__u32 btf_func:1;
+	FEAT_BTF_FUNC,
 	/* BTF_KIND_VAR and BTF_KIND_DATASEC support */
-	__u32 btf_datasec:1;
-	/* BPF_F_MMAPABLE is supported for arrays */
-	__u32 array_mmap:1;
+	FEAT_BTF_DATASEC,
 	/* BTF_FUNC_GLOBAL is supported */
-	__u32 btf_func_global:1;
+	FEAT_BTF_GLOBAL_FUNC,
+	/* BPF_F_MMAPABLE is supported for arrays */
+	FEAT_ARRAY_MMAP,
 	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
-	__u32 exp_attach_type:1;
+	FEAT_EXP_ATTACH_TYPE,
+	__FEAT_CNT,
 };
=20
+static bool kernel_supports(enum kern_feature_id feat_id);
+
 enum reloc_type {
 	RELO_LD64,
 	RELO_CALL,
@@ -253,8 +256,6 @@ struct bpf_program {
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
=20
-	struct bpf_capabilities *caps;
-
 	void *line_info;
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
@@ -436,8 +437,6 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
=20
-	struct bpf_capabilities caps;
-
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -561,7 +560,6 @@ bpf_object__add_program(struct bpf_object *obj, void =
*data, size_t size,
 	if (err)
 		return err;
=20
-	prog.caps =3D &obj->caps;
 	progs =3D obj->programs;
 	nr_progs =3D obj->nr_programs;
=20
@@ -2340,18 +2338,18 @@ static bool section_have_execinstr(struct bpf_obj=
ect *obj, int idx)
=20
 static bool btf_needs_sanitization(struct bpf_object *obj)
 {
-	bool has_func_global =3D obj->caps.btf_func_global;
-	bool has_datasec =3D obj->caps.btf_datasec;
-	bool has_func =3D obj->caps.btf_func;
+	bool has_func_global =3D kernel_supports(FEAT_BTF_GLOBAL_FUNC);
+	bool has_datasec =3D kernel_supports(FEAT_BTF_DATASEC);
+	bool has_func =3D kernel_supports(FEAT_BTF_FUNC);
=20
 	return !has_func || !has_datasec || !has_func_global;
 }
=20
 static void bpf_object__sanitize_btf(struct bpf_object *obj, struct btf =
*btf)
 {
-	bool has_func_global =3D obj->caps.btf_func_global;
-	bool has_datasec =3D obj->caps.btf_datasec;
-	bool has_func =3D obj->caps.btf_func;
+	bool has_func_global =3D kernel_supports(FEAT_BTF_GLOBAL_FUNC);
+	bool has_datasec =3D kernel_supports(FEAT_BTF_DATASEC);
+	bool has_func =3D kernel_supports(FEAT_BTF_FUNC);
 	struct btf_type *t;
 	int i, j, vlen;
=20
@@ -3429,8 +3427,7 @@ bpf_object__probe_loading(struct bpf_object *obj)
 	return 0;
 }
=20
-static int
-bpf_object__probe_name(struct bpf_object *obj)
+static int probe_kern_prog_name(void)
 {
 	struct bpf_load_program_attr attr;
 	struct bpf_insn insns[] =3D {
@@ -3449,15 +3446,14 @@ bpf_object__probe_name(struct bpf_object *obj)
 	attr.name =3D "test";
 	ret =3D bpf_load_program_xattr(&attr, NULL, 0);
 	if (ret >=3D 0) {
-		obj->caps.name =3D 1;
 		close(ret);
+		return 1;
 	}
=20
 	return 0;
 }
=20
-static int
-bpf_object__probe_global_data(struct bpf_object *obj)
+static int probe_kern_global_data(void)
 {
 	struct bpf_load_program_attr prg_attr;
 	struct bpf_create_map_attr map_attr;
@@ -3493,16 +3489,16 @@ bpf_object__probe_global_data(struct bpf_object *=
obj)
 	prg_attr.license =3D "GPL";
=20
 	ret =3D bpf_load_program_xattr(&prg_attr, NULL, 0);
+	close(map);
 	if (ret >=3D 0) {
-		obj->caps.global_data =3D 1;
 		close(ret);
+		return 1;
 	}
=20
-	close(map);
 	return 0;
 }
=20
-static int bpf_object__probe_btf_func(struct bpf_object *obj)
+static int probe_kern_btf_func(void)
 {
 	static const char strs[] =3D "\0int\0x\0a";
 	/* void x(int a) {} */
@@ -3520,7 +3516,6 @@ static int bpf_object__probe_btf_func(struct bpf_ob=
ject *obj)
 	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
 				      strs, sizeof(strs));
 	if (btf_fd >=3D 0) {
-		obj->caps.btf_func =3D 1;
 		close(btf_fd);
 		return 1;
 	}
@@ -3528,7 +3523,7 @@ static int bpf_object__probe_btf_func(struct bpf_ob=
ject *obj)
 	return 0;
 }
=20
-static int bpf_object__probe_btf_func_global(struct bpf_object *obj)
+static int probe_kern_btf_func_global(void)
 {
 	static const char strs[] =3D "\0int\0x\0a";
 	/* static void x(int a) {} */
@@ -3546,7 +3541,6 @@ static int bpf_object__probe_btf_func_global(struct=
 bpf_object *obj)
 	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
 				      strs, sizeof(strs));
 	if (btf_fd >=3D 0) {
-		obj->caps.btf_func_global =3D 1;
 		close(btf_fd);
 		return 1;
 	}
@@ -3554,7 +3548,7 @@ static int bpf_object__probe_btf_func_global(struct=
 bpf_object *obj)
 	return 0;
 }
=20
-static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
+static int probe_kern_btf_datasec(void)
 {
 	static const char strs[] =3D "\0x\0.data";
 	/* static int a; */
@@ -3573,7 +3567,6 @@ static int bpf_object__probe_btf_datasec(struct bpf=
_object *obj)
 	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
 				      strs, sizeof(strs));
 	if (btf_fd >=3D 0) {
-		obj->caps.btf_datasec =3D 1;
 		close(btf_fd);
 		return 1;
 	}
@@ -3581,7 +3574,7 @@ static int bpf_object__probe_btf_datasec(struct bpf=
_object *obj)
 	return 0;
 }
=20
-static int bpf_object__probe_array_mmap(struct bpf_object *obj)
+static int probe_kern_array_mmap(void)
 {
 	struct bpf_create_map_attr attr =3D {
 		.map_type =3D BPF_MAP_TYPE_ARRAY,
@@ -3594,16 +3587,13 @@ static int bpf_object__probe_array_mmap(struct bp=
f_object *obj)
=20
 	fd =3D bpf_create_map_xattr(&attr);
 	if (fd >=3D 0) {
-		obj->caps.array_mmap =3D 1;
 		close(fd);
 		return 1;
 	}
-
 	return 0;
 }
=20
-static int
-bpf_object__probe_exp_attach_type(struct bpf_object *obj)
+static int probe_kern_exp_attach_type(void)
 {
 	struct bpf_load_program_attr attr;
 	struct bpf_insn insns[] =3D {
@@ -3626,34 +3616,67 @@ bpf_object__probe_exp_attach_type(struct bpf_obje=
ct *obj)
=20
 	fd =3D bpf_load_program_xattr(&attr, NULL, 0);
 	if (fd >=3D 0) {
-		obj->caps.exp_attach_type =3D 1;
 		close(fd);
 		return 1;
 	}
 	return 0;
 }
=20
-static int
-bpf_object__probe_caps(struct bpf_object *obj)
-{
-	int (*probe_fn[])(struct bpf_object *obj) =3D {
-		bpf_object__probe_name,
-		bpf_object__probe_global_data,
-		bpf_object__probe_btf_func,
-		bpf_object__probe_btf_func_global,
-		bpf_object__probe_btf_datasec,
-		bpf_object__probe_array_mmap,
-		bpf_object__probe_exp_attach_type,
-	};
-	int i, ret;
+enum kern_feature_result {
+	FEAT_UNKNOWN =3D 0,
+	FEAT_SUPPORTED =3D 1,
+	FEAT_MISSING =3D 2,
+};
=20
-	for (i =3D 0; i < ARRAY_SIZE(probe_fn); i++) {
-		ret =3D probe_fn[i](obj);
-		if (ret < 0)
-			pr_debug("Probe #%d failed with %d.\n", i, ret);
+typedef int (*feature_probe_fn)(void);
+
+static struct kern_feature_desc {
+	const char *desc;
+	feature_probe_fn probe;
+	enum kern_feature_result res;
+} feature_probes[__FEAT_CNT] =3D {
+	[FEAT_PROG_NAME] =3D {
+		"BPF program name", probe_kern_prog_name,
+	},
+	[FEAT_GLOBAL_DATA] =3D {
+		"global variables", probe_kern_global_data,
+	},
+	[FEAT_BTF_FUNC] =3D {
+		"BTF functions", probe_kern_btf_func,
+	},
+	[FEAT_BTF_GLOBAL_FUNC] =3D {
+		"BTF global function", probe_kern_btf_func_global,
+	},
+	[FEAT_BTF_DATASEC] =3D {
+		"BTF data section and variable", probe_kern_btf_datasec,
+	},
+	[FEAT_ARRAY_MMAP] =3D {
+		"ARRAY map mmap()", probe_kern_array_mmap,
+	},
+	[FEAT_EXP_ATTACH_TYPE] =3D {
+		"BPF_PROG_LOAD expected_attach_type attribute",
+		probe_kern_exp_attach_type,
+	},
+};
+
+static bool kernel_supports(enum kern_feature_id feat_id)
+{
+	struct kern_feature_desc *feat =3D &feature_probes[feat_id];
+	int ret;
+
+	if (READ_ONCE(feat->res) =3D=3D FEAT_UNKNOWN) {
+		ret =3D feat->probe();
+		if (ret > 0) {
+			WRITE_ONCE(feat->res, FEAT_SUPPORTED);
+		} else if (ret =3D=3D 0) {
+			WRITE_ONCE(feat->res, FEAT_MISSING);
+		} else {
+			pr_warn("Detection of kernel %s support failed: %d\n", feat->desc, re=
t);
+			WRITE_ONCE(feat->res, FEAT_MISSING);
+		}
 	}
=20
-	return 0;
+	return READ_ONCE(feat->res) =3D=3D FEAT_SUPPORTED;
 }
=20
 static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
@@ -3755,7 +3778,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map)
=20
 	memset(&create_attr, 0, sizeof(create_attr));
=20
-	if (obj->caps.name)
+	if (kernel_supports(FEAT_PROG_NAME))
 		create_attr.name =3D map->name;
 	create_attr.map_ifindex =3D map->map_ifindex;
 	create_attr.map_type =3D def->type;
@@ -5355,12 +5378,12 @@ load_program(struct bpf_program *prog, struct bpf=
_insn *insns, int insns_cnt,
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type =3D prog->type;
 	/* old kernels might not support specifying expected_attach_type */
-	if (!prog->caps->exp_attach_type && prog->sec_def &&
+	if (!kernel_supports(FEAT_EXP_ATTACH_TYPE) && prog->sec_def &&
 	    prog->sec_def->is_exp_attach_type_optional)
 		load_attr.expected_attach_type =3D 0;
 	else
 		load_attr.expected_attach_type =3D prog->expected_attach_type;
-	if (prog->caps->name)
+	if (kernel_supports(FEAT_PROG_NAME))
 		load_attr.name =3D prog->name;
 	load_attr.insns =3D insns;
 	load_attr.insns_cnt =3D insns_cnt;
@@ -5378,7 +5401,7 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
 	}
 	/* specify func_info/line_info only if kernel supports them */
 	btf_fd =3D bpf_object__btf_fd(prog->obj);
-	if (btf_fd >=3D 0 && prog->obj->caps.btf_func) {
+	if (btf_fd >=3D 0 && kernel_supports(FEAT_BTF_FUNC)) {
 		load_attr.prog_btf_fd =3D btf_fd;
 		load_attr.func_info =3D prog->func_info;
 		load_attr.func_info_rec_size =3D prog->func_info_rec_size;
@@ -5741,11 +5764,11 @@ static int bpf_object__sanitize_maps(struct bpf_o=
bject *obj)
 	bpf_object__for_each_map(m, obj) {
 		if (!bpf_map__is_internal(m))
 			continue;
-		if (!obj->caps.global_data) {
+		if (!kernel_supports(FEAT_GLOBAL_DATA)) {
 			pr_warn("kernel doesn't support global data\n");
 			return -ENOTSUP;
 		}
-		if (!obj->caps.array_mmap)
+		if (!kernel_supports(FEAT_ARRAY_MMAP))
 			m->def.map_flags ^=3D BPF_F_MMAPABLE;
 	}
=20
@@ -5895,7 +5918,6 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
 	}
=20
 	err =3D bpf_object__probe_loading(obj);
-	err =3D err ? : bpf_object__probe_caps(obj);
 	err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
 	err =3D err ? : bpf_object__sanitize_maps(obj);
--=20
2.24.1

