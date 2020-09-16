Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0CB26CED6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIPWiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgIPWh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:37:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64857C06178B
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 141so263931ybe.15
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NOsssfJ80Jxaxnpxlk2jZAvBPv0057S2yLjIy6L/yns=;
        b=l4cnTSkb1lzZ1puozhVwglicr1QG0BOY7FGQAkDGhLjL0LSScyDPRY+wYN3+EGT44V
         KeQ+C9tPp3wb0DRXh4bYKb12tzvHaFQ47YVHq5UsuhsL1hFZj4xfQfE+Xw2n0riKCiGz
         ebgNdRuSe+OkaO4lzU0lk3QIlOFyEsTiaGfWirD5y8BMZu96DbZVl1lFBXLBVsjl8NMU
         p6vpzhZU2rUz0Pt8Mnn5pX//LIZL9azYbTNiF4p360Cw01/r1ATMXTp6dITNAkwpGHCo
         bM5QlhZ55kTsmPVoMoxEFVb9+S0AA5JieqvBlTwEVLZI/4KJ0oF0/boyZTf+JZ5ez8ND
         /WKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NOsssfJ80Jxaxnpxlk2jZAvBPv0057S2yLjIy6L/yns=;
        b=D33BCxaW8LexNQeqoEevwAeycPwnEGUzIY8N4NM2HbfHy1bRHN9GXdOQO0pIEtK9GR
         gMEWRNy9DGRsE/2xm5lXE/Dx974pV7sqnqNme9CVaclqhKYUlKJszNKcjlxTQfqDfNi2
         KRjMQOI5L7HhFNQDTmSei26reMNRuQZ05H/8ZOhD3VgJcH2huPbe8ybZy/eBcXUGxMeT
         VNWIuvO80qVLm1s7V65kHCjSZPPSorsrSe5zkU9H5oNHYbbrlbFMAj0brpYnjNwHiaa2
         ONWRszpzqtMm99ZMMawAORb85cTCqnCMmYlwqr9xFImWytU5Yl/LQkeWnLKu9pvYgyQ2
         BgGA==
X-Gm-Message-State: AOAM532aNrIgHrjw9MlmlfaIkM0LbZzo9nF2jVrqGSZ2k73AJKNwXXp5
        x3EQ2nx03q4VZgqt8Hz52zywNX/dBfNhRiWXSVttMQlICpTtuuPrRmqnJxXEUj/Z6vX8nLi+Izu
        RSKURMa8NwyRgoOWnbOOszCfsHP2lPF4DG+USg/b9ZPh5wPI9ofKti4470PrUkA==
X-Google-Smtp-Source: ABdhPJxUGcVO6aqlkoz8RN8L/n7i+P0DcEEKNyMMsqawLCCa3acxT9dltpcCUkziPZ/EHq50Nd/RgV38fwM=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:20d5:: with SMTP id g204mr38255640ybg.337.1600295875309;
 Wed, 16 Sep 2020 15:37:55 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:35:07 -0700
In-Reply-To: <20200916223512.2885524-1-haoluo@google.com>
Message-Id: <20200916223512.2885524-2-haoluo@google.com>
Mime-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v3 1/6] bpf: Introduce pseudo_btf_id
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pseudo_btf_id is a type of ld_imm insn that associates a btf_id to a
ksym so that further dereferences on the ksym can use the BTF info
to validate accesses. Internally, when seeing a pseudo_btf_id ld insn,
the verifier reads the btf_id stored in the insn[0]'s imm field and
marks the dst_reg as PTR_TO_BTF_ID. The btf_id points to a VAR_KIND,
which is encoded in btf_vminux by pahole. If the VAR is not of a struct
type, the dst reg will be marked as PTR_TO_MEM instead of PTR_TO_BTF_ID
and the mem_size is resolved to the size of the VAR's type.

From the VAR btf_id, the verifier can also read the address of the
ksym's corresponding kernel var from kallsyms and use that to fill
dst_reg.

Therefore, the proper functionality of pseudo_btf_id depends on (1)
kallsyms and (2) the encoding of kernel global VARs in pahole, which
should be available since pahole v1.18.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/linux/bpf_verifier.h   |   7 ++
 include/linux/btf.h            |  15 ++++
 include/uapi/linux/bpf.h       |  36 +++++++---
 kernel/bpf/btf.c               |  15 ----
 kernel/bpf/verifier.c          | 125 +++++++++++++++++++++++++++++----
 tools/include/uapi/linux/bpf.h |  36 +++++++---
 6 files changed, 188 insertions(+), 46 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..6a9dd0279ea4 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -308,6 +308,13 @@ struct bpf_insn_aux_data {
 			u32 map_index;		/* index into used_maps[] */
 			u32 map_off;		/* offset from value base address */
 		};
+		struct {
+			u32 reg_type;		/* type of pseudo_btf_id */
+			union {
+				u32 btf_id;	/* btf_id for struct typed var */
+				u32 mem_size;	/* mem_size for non-struct typed var */
+			};
+		} btf_var;
 	};
 	u64 map_key_state; /* constant (32 bit) key tracking for maps */
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
diff --git a/include/linux/btf.h b/include/linux/btf.h
index a9af5e7a7ece..592373d359b9 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -106,6 +106,21 @@ static inline bool btf_type_is_func_proto(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FUNC_PROTO;
 }
 
+static inline bool btf_type_is_var(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
+}
+
+/* union is only a special case of struct:
+ * all its offsetof(member) == 0
+ */
+static inline bool btf_type_is_struct(const struct btf_type *t)
+{
+	u8 kind = BTF_INFO_KIND(t->info);
+
+	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
+}
+
 static inline u16 btf_type_vlen(const struct btf_type *t)
 {
 	return BTF_INFO_VLEN(t->info);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..96c828a80520 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -356,18 +356,36 @@ enum bpf_link_type {
 #define BPF_F_SLEEPABLE		(1U << 4)
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
- * two extensions:
- *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd              map fd
- * insn[1].imm:      0                   offset into value
- * insn[0].off:      0                   0
- * insn[1].off:      0                   0
- * ldimm64 rewrite:  address of map      address of map[0]+offset
- * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
+ * the following extensions:
+ *
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
+ * insn[0].imm:      map fd
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map
+ * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
+/* insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/* insn[0].src_reg:  BPF_PSEUDO_BTF_ID
+ * insn[0].imm:      kernel btd id of VAR
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of the kernel variable
+ * verifier type:    PTR_TO_BTF_ID or PTR_TO_MEM, depending on whether the var
+ *                   is struct/union.
+ */
+#define BPF_PSEUDO_BTF_ID	3
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f9ac6935ab3c..5831d9f3f3c5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -355,16 +355,6 @@ static bool btf_type_nosize_or_null(const struct btf_type *t)
 	return !t || btf_type_nosize(t);
 }
 
-/* union is only a special case of struct:
- * all its offsetof(member) == 0
- */
-static bool btf_type_is_struct(const struct btf_type *t)
-{
-	u8 kind = BTF_INFO_KIND(t->info);
-
-	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
-}
-
 static bool __btf_type_is_struct(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
@@ -375,11 +365,6 @@ static bool btf_type_is_array(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_ARRAY;
 }
 
-static bool btf_type_is_var(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_VAR;
-}
-
 static bool btf_type_is_datasec(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 814bc6c1ad16..de7421a52dbc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7378,6 +7378,7 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
 	struct bpf_insn_aux_data *aux = cur_aux(env);
 	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_reg_state *dst_reg;
 	struct bpf_map *map;
 	int err;
 
@@ -7394,25 +7395,44 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	if (err)
 		return err;
 
+	dst_reg = &regs[insn->dst_reg];
 	if (insn->src_reg == 0) {
 		u64 imm = ((u64)(insn + 1)->imm << 32) | (u32)insn->imm;
 
-		regs[insn->dst_reg].type = SCALAR_VALUE;
+		dst_reg->type = SCALAR_VALUE;
 		__mark_reg_known(&regs[insn->dst_reg], imm);
 		return 0;
 	}
 
+	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
+		mark_reg_known_zero(env, regs, insn->dst_reg);
+
+		dst_reg->type = aux->btf_var.reg_type;
+		switch (dst_reg->type) {
+		case PTR_TO_MEM:
+			dst_reg->mem_size = aux->btf_var.mem_size;
+			break;
+		case PTR_TO_BTF_ID:
+			dst_reg->btf_id = aux->btf_var.btf_id;
+			break;
+		default:
+			verbose(env, "bpf verifier is misconfigured\n");
+			return -EFAULT;
+		}
+		return 0;
+	}
+
 	map = env->used_maps[aux->map_index];
 	mark_reg_known_zero(env, regs, insn->dst_reg);
-	regs[insn->dst_reg].map_ptr = map;
+	dst_reg->map_ptr = map;
 
 	if (insn->src_reg == BPF_PSEUDO_MAP_VALUE) {
-		regs[insn->dst_reg].type = PTR_TO_MAP_VALUE;
-		regs[insn->dst_reg].off = aux->map_off;
+		dst_reg->type = PTR_TO_MAP_VALUE;
+		dst_reg->off = aux->map_off;
 		if (map_value_has_spin_lock(map))
-			regs[insn->dst_reg].id = ++env->id_gen;
+			dst_reg->id = ++env->id_gen;
 	} else if (insn->src_reg == BPF_PSEUDO_MAP_FD) {
-		regs[insn->dst_reg].type = CONST_PTR_TO_MAP;
+		dst_reg->type = CONST_PTR_TO_MAP;
 	} else {
 		verbose(env, "bpf verifier is misconfigured\n");
 		return -EINVAL;
@@ -9288,6 +9308,73 @@ static int do_check(struct bpf_verifier_env *env)
 	return 0;
 }
 
+/* replace pseudo btf_id with kernel symbol address */
+static int check_pseudo_btf_id(struct bpf_verifier_env *env,
+			       struct bpf_insn *insn,
+			       struct bpf_insn_aux_data *aux)
+{
+	u32 type, id = insn->imm;
+	const struct btf_type *t;
+	const char *sym_name;
+	u64 addr;
+
+	if (!btf_vmlinux) {
+		verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
+		return -EINVAL;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, id);
+	if (!t) {
+		verbose(env, "ldimm64 insn specifies invalid btf_id %d.\n", id);
+		return -ENOENT;
+	}
+
+	if (insn[1].imm != 0) {
+		verbose(env, "reserved field (insn[1].imm) is used in pseudo_btf_id ldimm64 insn.\n");
+		return -EINVAL;
+	}
+
+	if (!btf_type_is_var(t)) {
+		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n",
+			id);
+		return -EINVAL;
+	}
+
+	sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
+	addr = kallsyms_lookup_name(sym_name);
+	if (!addr) {
+		verbose(env, "ldimm64 failed to find the address for kernel symbol '%s'.\n",
+			sym_name);
+		return -ENOENT;
+	}
+
+	insn[0].imm = (u32)addr;
+	insn[1].imm = addr >> 32;
+
+	type = t->type;
+	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
+	if (!btf_type_is_struct(t)) {
+		const struct btf_type *ret;
+		const char *tname;
+		u32 tsize;
+
+		/* resolve the type size of ksym. */
+		ret = btf_resolve_size(btf_vmlinux, t, &tsize);
+		if (IS_ERR(ret)) {
+			tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+			verbose(env, "ldimm64 unable to resolve the size of type '%s': %ld\n",
+				tname, PTR_ERR(ret));
+			return -EINVAL;
+		}
+		aux->btf_var.reg_type = PTR_TO_MEM;
+		aux->btf_var.mem_size = tsize;
+	} else {
+		aux->btf_var.reg_type = PTR_TO_BTF_ID;
+		aux->btf_var.btf_id = type;
+	}
+	return 0;
+}
+
 static int check_map_prealloc(struct bpf_map *map)
 {
 	return (map->map_type != BPF_MAP_TYPE_HASH &&
@@ -9398,10 +9485,14 @@ static bool bpf_map_is_cgroup_storage(struct bpf_map *map)
 		map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE);
 }
 
-/* look for pseudo eBPF instructions that access map FDs and
- * replace them with actual map pointers
+/* find and rewrite pseudo imm in ld_imm64 instructions:
+ *
+ * 1. if it accesses map FD, replace it with actual map pointer.
+ * 2. if it accesses btf_id of a VAR, replace it with pointer to the var.
+ *
+ * NOTE: btf_vmlinux is required for converting pseudo btf_id.
  */
-static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
+static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 {
 	struct bpf_insn *insn = env->prog->insnsi;
 	int insn_cnt = env->prog->len;
@@ -9442,6 +9533,14 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 				/* valid generic load 64-bit imm */
 				goto next_insn;
 
+			if (insn[0].src_reg == BPF_PSEUDO_BTF_ID) {
+				aux = &env->insn_aux_data[i];
+				err = check_pseudo_btf_id(env, insn, aux);
+				if (err)
+					return err;
+				goto next_insn;
+			}
+
 			/* In final convert_pseudo_ld_imm64() step, this is
 			 * converted into regular 64-bit imm load insn.
 			 */
@@ -11392,10 +11491,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
 
-	ret = replace_map_fd_with_map_ptr(env);
-	if (ret < 0)
-		goto skip_full_check;
-
 	if (bpf_prog_is_dev_bound(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
@@ -11421,6 +11516,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret)
 		goto skip_full_check;
 
+	ret = resolve_pseudo_ldimm64(env);
+	if (ret < 0)
+		goto skip_full_check;
+
 	ret = check_cfg(env);
 	if (ret < 0)
 		goto skip_full_check;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..96c828a80520 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -356,18 +356,36 @@ enum bpf_link_type {
 #define BPF_F_SLEEPABLE		(1U << 4)
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
- * two extensions:
- *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd              map fd
- * insn[1].imm:      0                   offset into value
- * insn[0].off:      0                   0
- * insn[1].off:      0                   0
- * ldimm64 rewrite:  address of map      address of map[0]+offset
- * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
+ * the following extensions:
+ *
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
+ * insn[0].imm:      map fd
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map
+ * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
+/* insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/* insn[0].src_reg:  BPF_PSEUDO_BTF_ID
+ * insn[0].imm:      kernel btd id of VAR
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of the kernel variable
+ * verifier type:    PTR_TO_BTF_ID or PTR_TO_MEM, depending on whether the var
+ *                   is struct/union.
+ */
+#define BPF_PSEUDO_BTF_ID	3
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
-- 
2.28.0.618.gf4bc123cb7-goog

