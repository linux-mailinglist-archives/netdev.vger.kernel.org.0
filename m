Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03CC2F295C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404060AbhALH4W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jan 2021 02:56:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31656 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392171AbhALH4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:56:22 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C7tVZf024598
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:39 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywp997x8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:39 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 23:55:38 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 636E62ECD646; Mon, 11 Jan 2021 23:55:34 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 5/7] bpf: support BPF ksym variables in kernel modules
Date:   Mon, 11 Jan 2021 23:55:18 -0800
Message-ID: <20210112075520.4103414-6-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210112075520.4103414-1-andrii@kernel.org>
References: <20210112075520.4103414-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for directly accessing kernel module variables from BPF programs
using special ldimm64 instructions. This functionality builds upon vmlinux
ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
specifying kernel module BTF's FD in insn[1].imm field.

During BPF program load time, verifier will resolve FD to BTF object and will
take reference on BTF object itself and, for module BTFs, corresponding module
as well, to make sure it won't be unloaded from under running BPF program. The
mechanism used is similar to how bpf_prog keeps track of used bpf_maps.

One interesting change is also in how per-CPU variable is determined. The
logic is to find .data..percpu data section in provided BTF, but both vmlinux
and module each have their own .data..percpu entries in BTF. So for module's
case, the search for DATASEC record needs to look at only module's added BTF
types. This is implemented with custom search function.

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Hao Luo <haoluo@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h          |  10 +++
 include/linux/bpf_verifier.h |   3 +
 include/linux/btf.h          |   3 +
 kernel/bpf/btf.c             |  31 ++++++-
 kernel/bpf/core.c            |  23 ++++++
 kernel/bpf/verifier.c        | 154 ++++++++++++++++++++++++++++-------
 6 files changed, 194 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6e585dbc10df..1aac2af12fed 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -761,9 +761,15 @@ struct bpf_ctx_arg_aux {
 	u32 btf_id;
 };
 
+struct btf_mod_pair {
+	struct btf *btf;
+	struct module *module;
+};
+
 struct bpf_prog_aux {
 	atomic64_t refcnt;
 	u32 used_map_cnt;
+	u32 used_btf_cnt;
 	u32 max_ctx_offset;
 	u32 max_pkt_offset;
 	u32 max_tp_access;
@@ -802,6 +808,7 @@ struct bpf_prog_aux {
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
 	struct mutex used_maps_mutex; /* mutex for used_maps and used_map_cnt */
+	struct btf_mod_pair *used_btfs;
 	struct bpf_prog *prog;
 	struct user_struct *user;
 	u64 load_time; /* ns since boottime */
@@ -1668,6 +1675,9 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 }
 #endif /* CONFIG_BPF_SYSCALL */
 
+void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
+			  struct btf_mod_pair *used_btfs, u32 len);
+
 static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
 						 enum bpf_prog_type type)
 {
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e941fe1484e5..dfe6f85d97dd 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -340,6 +340,7 @@ struct bpf_insn_aux_data {
 };
 
 #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF program */
+#define MAX_USED_BTFS 64 /* max number of BTFs accessed by one BPF program */
 
 #define BPF_VERIFIER_TMP_LOG_SIZE	1024
 
@@ -398,7 +399,9 @@ struct bpf_verifier_env {
 	struct bpf_verifier_state_list **explored_states; /* search pruning optimization */
 	struct bpf_verifier_state_list *free_list;
 	struct bpf_map *used_maps[MAX_USED_MAPS]; /* array of map's used by eBPF program */
+	struct btf_mod_pair used_btfs[MAX_USED_BTFS]; /* array of BTF's used by BPF program */
 	u32 used_map_cnt;		/* number of used maps */
+	u32 used_btf_cnt;		/* number of used BTF objects */
 	u32 id_gen;			/* used to generate unique reg IDs */
 	bool allow_ptr_leaks;
 	bool allow_ptr_to_map_access;
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 4c200f5d242b..7fabf1428093 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -91,6 +91,9 @@ int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
 int btf_get_fd_by_id(u32 id);
 u32 btf_obj_id(const struct btf *btf);
 bool btf_is_kernel(const struct btf *btf);
+bool btf_is_module(const struct btf *btf);
+struct module *btf_try_get_module(const struct btf *btf);
+u32 btf_nr_types(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
 			   u32 expected_offset, u32 expected_size);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8d6bdb4f4d61..7ccc0133723a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -458,7 +458,7 @@ static bool btf_type_is_datasec(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
 }
 
-static u32 btf_nr_types_total(const struct btf *btf)
+u32 btf_nr_types(const struct btf *btf)
 {
 	u32 total = 0;
 
@@ -476,7 +476,7 @@ s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
 	const char *tname;
 	u32 i, total;
 
-	total = btf_nr_types_total(btf);
+	total = btf_nr_types(btf);
 	for (i = 1; i < total; i++) {
 		t = btf_type_by_id(btf, i);
 		if (BTF_INFO_KIND(t->info) != kind)
@@ -5743,6 +5743,11 @@ bool btf_is_kernel(const struct btf *btf)
 	return btf->kernel_btf;
 }
 
+bool btf_is_module(const struct btf *btf)
+{
+	return btf->kernel_btf && strcmp(btf->name, "vmlinux") != 0;
+}
+
 static int btf_id_cmp_func(const void *a, const void *b)
 {
 	const int *pa = a, *pb = b;
@@ -5877,3 +5882,25 @@ static int __init btf_module_init(void)
 
 fs_initcall(btf_module_init);
 #endif /* CONFIG_DEBUG_INFO_BTF_MODULES */
+
+struct module *btf_try_get_module(const struct btf *btf)
+{
+	struct module *res = NULL;
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+	struct btf_module *btf_mod, *tmp;
+
+	mutex_lock(&btf_module_mutex);
+	list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+		if (btf_mod->btf != btf)
+			continue;
+
+		if (try_module_get(btf_mod->module))
+			res = btf_mod->module;
+
+		break;
+	}
+	mutex_unlock(&btf_module_mutex);
+#endif
+
+	return res;
+}
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 261f8692d0d2..69c3c308de5e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2119,6 +2119,28 @@ static void bpf_free_used_maps(struct bpf_prog_aux *aux)
 	kfree(aux->used_maps);
 }
 
+void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
+			  struct btf_mod_pair *used_btfs, u32 len)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	struct btf_mod_pair *btf_mod;
+	u32 i;
+
+	for (i = 0; i < len; i++) {
+		btf_mod = &used_btfs[i];
+		if (btf_mod->module)
+			module_put(btf_mod->module);
+		btf_put(btf_mod->btf);
+	}
+#endif
+}
+
+static void bpf_free_used_btfs(struct bpf_prog_aux *aux)
+{
+	__bpf_free_used_btfs(aux, aux->used_btfs, aux->used_btf_cnt);
+	kfree(aux->used_btfs);
+}
+
 static void bpf_prog_free_deferred(struct work_struct *work)
 {
 	struct bpf_prog_aux *aux;
@@ -2126,6 +2148,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 
 	aux = container_of(work, struct bpf_prog_aux, work);
 	bpf_free_used_maps(aux);
+	bpf_free_used_btfs(aux);
 	if (bpf_prog_is_dev_bound(aux))
 		bpf_prog_offload_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8404f1..1f077d9adc67 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9703,6 +9703,36 @@ static int do_check(struct bpf_verifier_env *env)
 	return 0;
 }
 
+static int find_btf_percpu_datasec(struct btf *btf)
+{
+	const struct btf_type *t;
+	const char *tname;
+	int i, n;
+
+	/*
+	 * Both vmlinux and module each have their own ".data..percpu"
+	 * DATASECs in BTF. So for module's case, we need to skip vmlinux BTF
+	 * types to look at only module's own BTF types.
+	 */
+	n = btf_nr_types(btf);
+	if (btf_is_module(btf))
+		i = btf_nr_types(btf_vmlinux);
+	else
+		i = 1;
+
+	for(; i < n; i++) {
+		t = btf_type_by_id(btf, i);
+		if (BTF_INFO_KIND(t->info) != BTF_KIND_DATASEC)
+			continue;
+
+		tname = btf_name_by_offset(btf, t->name_off);
+		if (!strcmp(tname, ".data..percpu"))
+			return i;
+	}
+
+	return -ENOENT;
+}
+
 /* replace pseudo btf_id with kernel symbol address */
 static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			       struct bpf_insn *insn,
@@ -9710,48 +9740,57 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 {
 	const struct btf_var_secinfo *vsi;
 	const struct btf_type *datasec;
+	struct btf_mod_pair *btf_mod;
 	const struct btf_type *t;
 	const char *sym_name;
 	bool percpu = false;
 	u32 type, id = insn->imm;
+	struct btf *btf;
 	s32 datasec_id;
 	u64 addr;
-	int i;
-
-	if (!btf_vmlinux) {
-		verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
-		return -EINVAL;
-	}
+	int i, btf_fd, err;
 
-	if (insn[1].imm != 0) {
-		verbose(env, "reserved field (insn[1].imm) is used in pseudo_btf_id ldimm64 insn.\n");
-		return -EINVAL;
+	btf_fd = insn[1].imm;
+	if (btf_fd) {
+		btf = btf_get_by_fd(btf_fd);
+		if (IS_ERR(btf)) {
+			verbose(env, "invalid module BTF object FD specified.\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!btf_vmlinux) {
+			verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
+			return -EINVAL;
+		}
+		btf = btf_vmlinux;
+		btf_get(btf);
 	}
 
-	t = btf_type_by_id(btf_vmlinux, id);
+	t = btf_type_by_id(btf, id);
 	if (!t) {
 		verbose(env, "ldimm64 insn specifies invalid btf_id %d.\n", id);
-		return -ENOENT;
+		err = -ENOENT;
+		goto err_put;
 	}
 
 	if (!btf_type_is_var(t)) {
-		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n",
-			id);
-		return -EINVAL;
+		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n", id);
+		err = -EINVAL;
+		goto err_put;
 	}
 
-	sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
+	sym_name = btf_name_by_offset(btf, t->name_off);
 	addr = kallsyms_lookup_name(sym_name);
 	if (!addr) {
 		verbose(env, "ldimm64 failed to find the address for kernel symbol '%s'.\n",
 			sym_name);
-		return -ENOENT;
+		err = -ENOENT;
+		goto err_put;
 	}
 
-	datasec_id = btf_find_by_name_kind(btf_vmlinux, ".data..percpu",
-					   BTF_KIND_DATASEC);
+	datasec_id = find_btf_percpu_datasec(btf);
 	if (datasec_id > 0) {
-		datasec = btf_type_by_id(btf_vmlinux, datasec_id);
+		datasec = btf_type_by_id(btf, datasec_id);
 		for_each_vsi(i, datasec, vsi) {
 			if (vsi->type == id) {
 				percpu = true;
@@ -9764,10 +9803,10 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 	insn[1].imm = addr >> 32;
 
 	type = t->type;
-	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
+	t = btf_type_skip_modifiers(btf, type, NULL);
 	if (percpu) {
 		aux->btf_var.reg_type = PTR_TO_PERCPU_BTF_ID;
-		aux->btf_var.btf = btf_vmlinux;
+		aux->btf_var.btf = btf;
 		aux->btf_var.btf_id = type;
 	} else if (!btf_type_is_struct(t)) {
 		const struct btf_type *ret;
@@ -9775,21 +9814,54 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		u32 tsize;
 
 		/* resolve the type size of ksym. */
-		ret = btf_resolve_size(btf_vmlinux, t, &tsize);
+		ret = btf_resolve_size(btf, t, &tsize);
 		if (IS_ERR(ret)) {
-			tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+			tname = btf_name_by_offset(btf, t->name_off);
 			verbose(env, "ldimm64 unable to resolve the size of type '%s': %ld\n",
 				tname, PTR_ERR(ret));
-			return -EINVAL;
+			err = -EINVAL;
+			goto err_put;
 		}
 		aux->btf_var.reg_type = PTR_TO_MEM;
 		aux->btf_var.mem_size = tsize;
 	} else {
 		aux->btf_var.reg_type = PTR_TO_BTF_ID;
-		aux->btf_var.btf = btf_vmlinux;
+		aux->btf_var.btf = btf;
 		aux->btf_var.btf_id = type;
 	}
+
+	/* check whether we recorded this BTF (and maybe module) already */
+	for (i = 0; i < env->used_btf_cnt; i++) {
+		if (env->used_btfs[i].btf == btf) {
+			btf_put(btf);
+			return 0;
+		}
+	}
+
+	if (env->used_btf_cnt >= MAX_USED_BTFS) {
+		err = -E2BIG;
+		goto err_put;
+	}
+
+	btf_mod = &env->used_btfs[env->used_btf_cnt];
+	btf_mod->btf = btf;
+	btf_mod->module = NULL;
+
+	/* if we reference variables from kernel module, bump its refcount */
+	if (btf_is_module(btf)) {
+		btf_mod->module = btf_try_get_module(btf);
+		if (!btf_mod->module) {
+			err = -ENXIO;
+			goto err_put;
+		}
+	}
+
+	env->used_btf_cnt++;
+
 	return 0;
+err_put:
+	btf_put(btf);
+	return err;
 }
 
 static int check_map_prealloc(struct bpf_map *map)
@@ -10086,6 +10158,13 @@ static void release_maps(struct bpf_verifier_env *env)
 			     env->used_map_cnt);
 }
 
+/* drop refcnt of maps used by the rejected program */
+static void release_btfs(struct bpf_verifier_env *env)
+{
+	__bpf_free_used_btfs(env->prog->aux, env->used_btfs,
+			     env->used_btf_cnt);
+}
+
 /* convert pseudo BPF_LD_IMM64 into generic BPF_LD_IMM64 */
 static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
 {
@@ -12098,7 +12177,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		goto err_release_maps;
 	}
 
-	if (ret == 0 && env->used_map_cnt) {
+	if (ret)
+		goto err_release_maps;
+
+	if (env->used_map_cnt) {
 		/* if program passed verifier, update used_maps in bpf_prog_info */
 		env->prog->aux->used_maps = kmalloc_array(env->used_map_cnt,
 							  sizeof(env->used_maps[0]),
@@ -12112,15 +12194,29 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		memcpy(env->prog->aux->used_maps, env->used_maps,
 		       sizeof(env->used_maps[0]) * env->used_map_cnt);
 		env->prog->aux->used_map_cnt = env->used_map_cnt;
+	}
+	if (env->used_btf_cnt) {
+		/* if program passed verifier, update used_btfs in bpf_prog_aux */
+		env->prog->aux->used_btfs = kmalloc_array(env->used_btf_cnt,
+							  sizeof(env->used_btfs[0]),
+							  GFP_KERNEL);
+		if (!env->prog->aux->used_btfs) {
+			ret = -ENOMEM;
+			goto err_release_maps;
+		}
 
+		memcpy(env->prog->aux->used_btfs, env->used_btfs,
+		       sizeof(env->used_btfs[0]) * env->used_btf_cnt);
+		env->prog->aux->used_btf_cnt = env->used_btf_cnt;
+	}
+	if (env->used_map_cnt || env->used_btf_cnt) {
 		/* program is valid. Convert pseudo bpf_ld_imm64 into generic
 		 * bpf_ld_imm64 instructions
 		 */
 		convert_pseudo_ld_imm64(env);
 	}
 
-	if (ret == 0)
-		adjust_btf_func(env);
+	adjust_btf_func(env);
 
 err_release_maps:
 	if (!env->prog->aux->used_maps)
@@ -12128,6 +12224,8 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		 * them now. Otherwise free_used_maps() will release them.
 		 */
 		release_maps(env);
+	if (!env->prog->aux->used_btfs)
+		release_btfs(env);
 
 	/* extension progs temporarily inherit the attach_type of their targets
 	   for verification purposes, so set it back to zero before returning
-- 
2.24.1

