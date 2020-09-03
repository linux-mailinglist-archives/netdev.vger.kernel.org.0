Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3C25CD9E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgICWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgICWdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:33:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526F8C061247
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:33:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o184so2863379pfb.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=478wX6wDiMrXugRQI0Ym0QzCnh+vqlcvC0NGMz4gS8w=;
        b=ozcYyaxHoph+FbXLMTJaCFy9ECFhsZ5+eu8xnP3sD/CwNXkdoNBRc9sz1sB3fxE7Fc
         lXY+1K8fFMNTEgnrSD8jolGRYnyb6irgSTE4AC/EKakII+vx9SEnqvS1BE7TaoWVOJep
         nOPqIuCTEI2IgrkMUtht7r8lGqPvdULi+s3oPyNx53+QRSvC23eDaxhBrT2Va8sEGEcV
         PDVvMMAydEBNVQAvf6gSM0l6Lb+MAVnRiVnq2/oT3cfGSVT179XmOUcfLjsW9kIJspsW
         qu/UYF0J+AnilmgAoz9F8CfOgBsrCz6zbZ2QlhTf8BOrL8YJtyVH/Td0HQL7SvMeYdMd
         P2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=478wX6wDiMrXugRQI0Ym0QzCnh+vqlcvC0NGMz4gS8w=;
        b=lLTE9JSxLAUu17ZbNLxCShmNvCtGAmDsjo+jBgTIcr9wzL8vDq5ipZxsuIMZ66Er8H
         ciNNEBPgDB9w+9j5X5X0qqTBSzA6vQS1N6OGFYw6lrO2RMewpNpyrBUQrMPgkEloNaaK
         qwMiU5qDRTrOv28AT18DSzxYHcjZ9YHjggpEYf3IMv8Fq/NWhrZg8x0N5HeLgLDoxBK8
         6Z8xSXYNBveSGon3o+CKsvip+dP8lR/H4vCxF68E6vbSgU4I1jOUbAFobJg13Dt7KIqg
         RwIPxLzfXm2NMs5l4txVXVAnZLbfR2VRCEtA1CRDXZ7vJEZfJlNMaLtTYHLopT4RnmwL
         MbRw==
X-Gm-Message-State: AOAM533xZU2Okec0wqDpLLwE7TObCUHZDMW5y+M+qKrYVbn708WiNT+I
        3LJ9lcGhtw9aNinK26FJ02um1Ezp7Rp63tOO8D2rceTyExctHLdKf3Zee1tCr2lDOr2bgTxsTQt
        S1p6UDQ7BrYXrHtxl/2mJlp6TJaMxmtgS1JPEpHbArV/s8j/Xa7IMKCHAm8wtVw==
X-Google-Smtp-Source: ABdhPJzgfApKrqsxYGEZLNEJA6vkjjXcuQaVOa6Zgjb7MRzgM37CttTmgzQNDUvgFUdVNZgjDquvmjRyYXs=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a62:301:0:b029:13c:1611:6528 with SMTP id
 1-20020a6203010000b029013c16116528mr4108163pfd.8.1599172417508; Thu, 03 Sep
 2020 15:33:37 -0700 (PDT)
Date:   Thu,  3 Sep 2020 15:33:27 -0700
In-Reply-To: <20200903223332.881541-1-haoluo@google.com>
Message-Id: <20200903223332.881541-2-haoluo@google.com>
Mime-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 1/6] bpf: Introduce pseudo_btf_id
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
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
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
 include/linux/bpf_verifier.h   |   4 ++
 include/linux/btf.h            |  15 +++++
 include/uapi/linux/bpf.h       |  38 ++++++++---
 kernel/bpf/btf.c               |  15 -----
 kernel/bpf/verifier.c          | 112 ++++++++++++++++++++++++++++++---
 tools/include/uapi/linux/bpf.h |  38 ++++++++---
 6 files changed, 182 insertions(+), 40 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..a14063f64d96 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -308,6 +308,10 @@ struct bpf_insn_aux_data {
 			u32 map_index;		/* index into used_maps[] */
 			u32 map_off;		/* offset from value base address */
 		};
+		struct {
+			u32 pseudo_btf_id_type; /* type of pseudo_btf_id */
+			u32 pseudo_btf_id_meta; /* memsize or btf_id */
+		};
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
index 8dda13880957..ab00ad9b32e5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -355,18 +355,38 @@ enum bpf_link_type {
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
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
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
index b4e9c56b8b32..3b382c080cfd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7398,6 +7398,24 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return 0;
 	}
 
+	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
+		u32 type = aux->pseudo_btf_id_type;
+		u32 meta = aux->pseudo_btf_id_meta;
+
+		mark_reg_known_zero(env, regs, insn->dst_reg);
+
+		regs[insn->dst_reg].type = type;
+		if (type == PTR_TO_MEM) {
+			regs[insn->dst_reg].mem_size = meta;
+		} else if (type == PTR_TO_BTF_ID) {
+			regs[insn->dst_reg].btf_id = meta;
+		} else {
+			verbose(env, "bpf verifier is misconfigured\n");
+			return -EFAULT;
+		}
+		return 0;
+	}
+
 	map = env->used_maps[aux->map_index];
 	mark_reg_known_zero(env, regs, insn->dst_reg);
 	regs[insn->dst_reg].map_ptr = map;
@@ -9284,6 +9302,74 @@ static int do_check(struct bpf_verifier_env *env)
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
+		verbose(env, "%s: btf not available. verifier misconfigured.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	t = btf_type_by_id(btf_vmlinux, id);
+	if (!t) {
+		verbose(env, "%s: invalid btf_id %d\n", __func__, id);
+		return -ENOENT;
+	}
+
+	if (insn[1].imm != 0) {
+		verbose(env, "%s: BPF_PSEUDO_BTF_ID uses reserved fields\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (!btf_type_is_var(t)) {
+		verbose(env, "%s: btf_id %d isn't KIND_VAR\n", __func__, id);
+		return -EINVAL;
+	}
+
+	sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
+	addr = kallsyms_lookup_name(sym_name);
+	if (!addr) {
+		verbose(env, "%s: failed to find the address of symbol '%s'.\n",
+			__func__, sym_name);
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
+			verbose(env, "unable to resolve the size of type '%s': %ld\n",
+				tname, PTR_ERR(ret));
+			return -EINVAL;
+		}
+		aux->pseudo_btf_id_type = PTR_TO_MEM;
+		aux->pseudo_btf_id_meta = tsize;
+	} else {
+		aux->pseudo_btf_id_type = PTR_TO_BTF_ID;
+		aux->pseudo_btf_id_meta = type;
+	}
+	return 0;
+}
+
 static int check_map_prealloc(struct bpf_map *map)
 {
 	return (map->map_type != BPF_MAP_TYPE_HASH &&
@@ -9394,10 +9480,14 @@ static bool bpf_map_is_cgroup_storage(struct bpf_map *map)
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
+static int replace_pseudo_imm_with_ptr(struct bpf_verifier_env *env)
 {
 	struct bpf_insn *insn = env->prog->insnsi;
 	int insn_cnt = env->prog->len;
@@ -9438,6 +9528,14 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
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
@@ -11388,10 +11486,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
 
-	ret = replace_map_fd_with_map_ptr(env);
-	if (ret < 0)
-		goto skip_full_check;
-
 	if (bpf_prog_is_dev_bound(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
@@ -11417,6 +11511,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret)
 		goto skip_full_check;
 
+	ret = replace_pseudo_imm_with_ptr(env);
+	if (ret < 0)
+		goto skip_full_check;
+
 	ret = check_cfg(env);
 	if (ret < 0)
 		goto skip_full_check;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8dda13880957..ab00ad9b32e5 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -355,18 +355,38 @@ enum bpf_link_type {
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
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
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
2.28.0.526.ge36021eeef-goog

