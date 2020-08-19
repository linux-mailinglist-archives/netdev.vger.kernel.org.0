Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F2824A988
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHSWkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgHSWkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2FEC061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w17so109295ybl.9
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fel8U13mcQz8NJwoVuBeyh1ojxpwIB/G3MPwv2FpVU0=;
        b=d09BxCdwUlmvgi1tBGE7b1p9k9ZuhElD7Pf72XUY+2GwbIiLXCPuBvHIAqUvQmmJlj
         v6wyP/OPbSbVrmPw7WIHEmfSpu9iXM/ka9FbiEqsYwvdFyf4k2NQatiMn2a4xCN+DeNG
         68MjEbY34wmxzdne8bsPEI8ZrUltvKjqztBzrspV/s+rp41IpMJq/ccoOJSpJ9o2x6cs
         ACRzzjvGwQkDCHDxQw45YqGuAhuHZUugqq0HKKMclPM98RrFPbttnsoo/NQSFjS+N99d
         BpXDhfN2k+7hs7q0kaXb3AWcJMK7IsOk4rsZyzJxut+1/0Egh+zn5EwndZmJHg5wAYov
         4Udw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fel8U13mcQz8NJwoVuBeyh1ojxpwIB/G3MPwv2FpVU0=;
        b=VYZlUSfkEQcyL6ePXS48T2kxuGNbt53zsZQS/haPCPdYdpazHOa3B8PJGwIx3OWrP0
         hrIhziKt8+qOcW0IjpdJWIopWsSvYygog4Em6v9rbwGkPR3OoLA6HsS1tczi4irsQUwU
         jYBa/DcGeTTg5bQ2WdzcAVmwZCLJr+vZOCmOq7/MYBFq6wS60je7t7g1stX8ryJUobQl
         4UTIvvcHDbDFqvrSuGkUmq0WmQk0wJTewwwq3OmQbL1O9Y+xJFkjtZPYi5qL15rpXiQZ
         tiSWkVfRwaOOh2LmppoThDpfPuNjOKIdblASEAqtJyC6D2HzkSGeKgwi1YZGSUcTgPpx
         0JqA==
X-Gm-Message-State: AOAM530OaGKMcQqi/qrHwGmtqDnFaNVQQ/wGin/ESCUjoI+xy0GI6pTR
        uRv0irAVzT7eHBNcc4Znu1Ku0htLb0iPySmX6ZbkrnDnHCLvc/YPDgUuEsJFLv9Xr8NyZm8WNFe
        0O+7nskCt7B+RuFEl8hbspsj3VJzMsdjmOzvOvN60duERFjRwAiLMVwe0exIUdw==
X-Google-Smtp-Source: ABdhPJxTJLddDl62KuvmP7G4cW9FHWLCZo9MeO51ib6vpq8g3sHDg87/xQGoZiNWz5NGIkOVUBbVzrMtgwE=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:ac63:: with SMTP id r35mr831435ybd.298.1597876836156;
 Wed, 19 Aug 2020 15:40:36 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:23 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-2-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
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
 include/linux/btf.h      | 15 +++++++++
 include/uapi/linux/bpf.h | 38 ++++++++++++++++------
 kernel/bpf/btf.c         | 15 ---------
 kernel/bpf/verifier.c    | 68 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 112 insertions(+), 24 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 8b81fbb4497c..cee4089e83c0 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -107,6 +107,21 @@ static inline bool btf_type_is_func_proto(const struct btf_type *t)
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
index 0480f893facd..468376f2910b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -346,18 +346,38 @@ enum bpf_link_type {
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
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
index 91afdd4c82e3..b6d8f653afe2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -353,16 +353,6 @@ static bool btf_type_nosize_or_null(const struct btf_type *t)
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
@@ -373,11 +363,6 @@ static bool btf_type_is_array(const struct btf_type *t)
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
index ef938f17b944..47badde71f83 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7205,6 +7205,68 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	return 0;
 }
 
+/* verify ld_imm64 insn of type PSEUDO_BTF_ID is valid */
+static inline int check_pseudo_btf_id(struct bpf_verifier_env *env,
+				      struct bpf_insn *insn)
+{
+	struct bpf_reg_state *regs = cur_regs(env);
+	u32 type, id = insn->imm;
+	u64 addr;
+	const char *sym_name;
+	const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);
+
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
+	mark_reg_known_zero(env, regs, insn->dst_reg);
+
+	type = t->type;
+	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
+	if (!btf_type_is_struct(t)) {
+		u32 tsize;
+		const struct btf_type *ret;
+		const char *tname;
+
+		/* resolve the type size of ksym. */
+		ret = btf_resolve_size(btf_vmlinux, t, &tsize, NULL, NULL);
+		if (IS_ERR(ret)) {
+			tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+			verbose(env, "unable to resolve the size of type '%s': %ld\n",
+				tname, PTR_ERR(ret));
+			return -EINVAL;
+		}
+		regs[insn->dst_reg].type = PTR_TO_MEM;
+		regs[insn->dst_reg].mem_size = tsize;
+	} else {
+		regs[insn->dst_reg].type = PTR_TO_BTF_ID;
+		regs[insn->dst_reg].btf_id = type;
+	}
+	return 0;
+}
+
 /* verify BPF_LD_IMM64 instruction */
 static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
@@ -7234,6 +7296,9 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return 0;
 	}
 
+	if (insn->src_reg == BPF_PSEUDO_BTF_ID)
+		return check_pseudo_btf_id(env, insn);
+
 	map = env->used_maps[aux->map_index];
 	mark_reg_known_zero(env, regs, insn->dst_reg);
 	regs[insn->dst_reg].map_ptr = map;
@@ -9255,6 +9320,9 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 				/* valid generic load 64-bit imm */
 				goto next_insn;
 
+			if (insn[0].src_reg == BPF_PSEUDO_BTF_ID)
+				goto next_insn;
+
 			/* In final convert_pseudo_ld_imm64() step, this is
 			 * converted into regular 64-bit imm load insn.
 			 */
-- 
2.28.0.220.ged08abb693-goog

