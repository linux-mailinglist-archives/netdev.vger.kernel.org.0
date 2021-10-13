Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5978742B92E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhJMHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbhJMHgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E3EC061570;
        Wed, 13 Oct 2021 00:33:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s75so1505135pgs.5;
        Wed, 13 Oct 2021 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRoomWP7bJbCrf64H9gxzP7htfUJedeDN2sQxDh6xpA=;
        b=StlXijUaP71F31vqNARLlRbDRHJZGqcf/mI31BAgS4L2ibu63/a4Pof+Xsw6dMAz3Y
         jNgQG+ql6JsnTcU7EApl/AIvoYq+xXCzbCUCR/TLdrofJfMUakVkB+EtQv3LEsOQ70lB
         ON88IDwP1sBh1j+iJyPy54+wUg8loZEjINBMZWvgElytWoTW+Tn2QCoXpnMZajdBtCGR
         +UaueYur7cRnyxXKLJsTqO47ScWhk8GkcF6x7FTnMkU4VCQQB4JPe4idU7iKDm6vRGUu
         IPICrugUtESlAm9zLZfY4pWIZAt7CZU1Ro/fiQTP6D4dsSUyBjPgLS7Tb7j0uLPrjwvB
         uqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRoomWP7bJbCrf64H9gxzP7htfUJedeDN2sQxDh6xpA=;
        b=zGyZEe8/lZh65Znz8osZynmgGqR1ur/5cmgwPiSpQowQ6fpvPu1gjfXLbIKfryysad
         ZjTr5WpfEwiUb+Px7vYiLbGp/k53Rm0h7kKEPgP9RcCDTXnS7YE64hMQ2+bjN1D6VTZ5
         XXfF5FO/GYCeK6TalglrGWcsZjVFnyVGbw8DXILEi4Os0U7Tj7KqW7Hc50Yja1NlbfrE
         3auCNwlQjnSW9fgnvPG6dBZvxBVPqNOjHubijxti7LZ4+Xka1bWZRTRgpAz4e4Ug9x9L
         ZnynXEWb3bhZ0kStKyl8/Dg6bY79v9qUuaXbutpIzxpzHLLrZ0mo+XEX6x001MfSru9B
         H69A==
X-Gm-Message-State: AOAM530YtPcBcjXZzgYro42xLE7XZyMYgdMGEqxcYArzVLscoJMiMHAf
        xrfwM9tUBUP3bIyrwcX0JaPK0n0OAAk=
X-Google-Smtp-Source: ABdhPJzBmf121kZerKdWh/pmmkv08/R6hLDgIeZZtViaxXSBX3f55gHoVgJfNHysPLJnXsSaLXSaDQ==
X-Received: by 2002:a63:b11:: with SMTP id 17mr26419693pgl.51.1634110437614;
        Wed, 13 Oct 2021 00:33:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id o14sm13348601pfh.145.2021.10.13.00.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:33:57 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to gen_loader
Date:   Wed, 13 Oct 2021 13:03:42 +0530
Message-Id: <20211013073348.1611155-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8369; h=from:subject; bh=8TgEgaKushKIAiqGPLv1l9iSMlIPYmNIXkt4caNZWjg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovS9JS7M3+U7F2hV071qad9yPCXsxMhADFrMZ95 LkNK8tyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8Ryo03D/ 42DqalxFhMIV7JKLaIA7Z/ujc0WtDUFL0WyoYTjDWCpbDCiyPLboy4yTifwtqwUVAhxJYOJBw5HBJp GEiRbMLrvH5OeFY8FmGFSIruQoscnHFI3OqFMGpEZvaiITCPWaI0dY+RdzyjkyXxm+Gk1cu6tmPTpg 0X7JzCH3+kuWJ2PevWmC9afOjksOMW0OQC3q72lZfiwcNO/j1M/sQFluWP4Z8kzg4Yl/y1o4wVRbk3 4pE/sUHfwFj748uAVrtJepKaiLYxOBjtyNgS93flyK53O+mGpY35i1V4yQOLYYtek2phr0svOLfZSm Hhdf1ntv3fu/XPu3NOFTN+Mu5YP4IvRLW9UUMgQHytMQkR2Er1L30mbD+ZZRqjs6DWjejgIyD5kj2H c7oq4FPtpkS2x0ujIKaIoO5tBF/IfqVxgDzLL3fu083kQSW6/hdv4Nt/VTUAWU4CzM5l5godzq1ppz xeyyPhVZ8gzbRpkVfYhIghFu8Okisw8E0piMBjbbyY4tgRfDBt4J8fzPJLJ6GoRRypl+NQJyBLZa5G /dP8lSNPm5kgsxY9G6cX91cdhfgcfRzsxHOfPfziXf3jilvMLkp7MXPqpS4Qjv9wMnwJjANeXOlEC0 czsFAAlgvatGtSt1dZGMCY6/QOWRcQjyzrcgqwvtF6qZES6haOVJNPKjOMzw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses the bpf_kallsyms_lookup_name helper added in previous patches
to relocate typeless ksyms. The return value ENOENT can be ignored, and
the value written to 'res' can be directly stored to the insn, as it is
overwritten to 0 on lookup failure. For repeating symbols, we can simply
copy the previously populated bpf_insn.

Also, we need to take care to not close fds for typeless ksym_desc, so
reuse the 'off' member's space to add a marker for typeless ksym and use
that to skip them in cleanup_relos.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h | 12 +++--
 tools/lib/bpf/gen_loader.c       | 82 ++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.c           | 13 ++---
 3 files changed, 92 insertions(+), 15 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 70eccbffefb1..9f328d044636 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -8,13 +8,19 @@ struct ksym_relo_desc {
 	int kind;
 	int insn_idx;
 	bool is_weak;
+	bool is_typeless;
 };
 
 struct ksym_desc {
 	const char *name;
 	int ref;
 	int kind;
-	int off;
+	union {
+		/* used for kfunc */
+		int off;
+		/* used for typeless ksym */
+		bool typeless;
+	};
 	int insn;
 };
 
@@ -49,7 +55,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
-			    int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    bool is_typeless, int kind, int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 937bfc7db41e..6be17dd48f02 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -559,7 +559,7 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 }
 
 void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
-			    int kind, int insn_idx)
+			    bool is_typeless, int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -572,6 +572,7 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
 	relo += gen->relo_cnt;
 	relo->name = name;
 	relo->is_weak = is_weak;
+	relo->is_typeless = is_typeless;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
@@ -621,6 +622,29 @@ static void emit_bpf_find_by_name_kind(struct bpf_gen *gen, struct ksym_relo_des
 	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
 }
 
+/* Overwrites BPF_REG_{0, 1, 2, 3, 4, 7}
+ * Returns result in BPF_REG_7
+ * Returns u64 symbol addr in BPF_REG_9
+ */
+static void emit_bpf_kallsyms_lookup_name(struct bpf_gen *gen, struct ksym_relo_desc *relo)
+{
+	int name_off, len = strlen(relo->name) + 1, res_off;
+
+	name_off = add_data(gen, relo->name, len);
+	res_off = add_data(gen, NULL, 8); /* res is u64 */
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, name_off));
+	emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
+	emit(gen, BPF_MOV64_IMM(BPF_REG_3, 0));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_4, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, res_off));
+	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_4));
+	emit(gen, BPF_EMIT_CALL(BPF_FUNC_kallsyms_lookup_name));
+	emit(gen, BPF_LDX_MEM(BPF_DW, BPF_REG_9, BPF_REG_7, 0));
+	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
+	debug_ret(gen, "kallsyms_lookup_name(%s,%d)", relo->name, relo->kind);
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  *
@@ -700,6 +724,52 @@ static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo
 		   relo->name, kdesc->ref);
 }
 
+/* Expects:
+ * BPF_REG_8 - pointer to instruction
+ */
+static void emit_relo_ksym_typeless(struct bpf_gen *gen,
+				    struct ksym_relo_desc *relo, int insn)
+{
+	struct ksym_desc *kdesc;
+
+	kdesc = get_ksym_desc(gen, relo);
+	if (!kdesc)
+		return;
+	/* try to copy from existing ldimm64 insn */
+	if (kdesc->ref > 1) {
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + offsetof(struct bpf_insn, imm));
+		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
+		goto log;
+	}
+	/* remember insn offset, so we can copy ksym addr later */
+	kdesc->insn = insn;
+	/* skip typeless ksym_desc in fd closing loop in cleanup_relos */
+	kdesc->typeless = true;
+	emit_bpf_kallsyms_lookup_name(gen, relo);
+	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, -ENOENT, 1));
+	emit_check_err(gen);
+	/* store lower half of addr into insn[insn_idx].imm */
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9, offsetof(struct bpf_insn, imm)));
+	/* store upper half of addr into insn[insn_idx + 1].imm */
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9,
+		      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
+log:
+	if (!gen->log_level)
+		return;
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
+			      offsetof(struct bpf_insn, imm)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=0 w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
+		   relo->is_weak, relo->name, kdesc->ref);
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	debug_regs(gen, BPF_REG_9, -1, " var t=0 w=%d (%s:count=%d): insn.reg",
+		   relo->is_weak, relo->name, kdesc->ref);
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  */
@@ -748,7 +818,10 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
 	switch (relo->kind) {
 	case BTF_KIND_VAR:
-		emit_relo_ksym_btf(gen, relo, insn);
+		if (relo->is_typeless)
+			emit_relo_ksym_typeless(gen, relo, insn);
+		else
+			emit_relo_ksym_btf(gen, relo, insn);
 		break;
 	case BTF_KIND_FUNC:
 		emit_relo_kfunc_btf(gen, relo, insn);
@@ -773,12 +846,13 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
 	int i, insn;
 
 	for (i = 0; i < gen->nr_ksyms; i++) {
-		if (gen->ksyms[i].kind == BTF_KIND_VAR) {
+		/* only close fds for typed ksyms and kfuncs */
+		if (gen->ksyms[i].kind == BTF_KIND_VAR && !gen->ksyms[i].typeless) {
 			/* close fd recorded in insn[insn_idx + 1].imm */
 			insn = gen->ksyms[i].insn;
 			insn += sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm);
 			emit_sys_close_blob(gen, insn);
-		} else { /* BTF_KIND_FUNC */
+		} else if (gen->ksyms[i].kind == BTF_KIND_FUNC) {
 			emit_sys_close_blob(gen, blob_fd_array_off(gen, gen->ksyms[i].off));
 			if (gen->ksyms[i].off < MAX_FD_ARRAY_SZ)
 				gen->nr_fd_array--;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ae0889bebe32..2ff7c9487634 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6355,17 +6355,14 @@ static int bpf_program__record_externs(struct bpf_program *prog)
 		case RELO_EXTERN_VAR:
 			if (ext->type != EXT_KSYM)
 				continue;
-			if (!ext->ksym.type_id) {
-				pr_warn("typeless ksym %s is not supported yet\n",
-					ext->name);
-				return -ENOTSUP;
-			}
-			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+			bpf_gen__record_extern(obj->gen_loader, ext->name,
+					       ext->is_weak, !ext->ksym.type_id,
 					       BTF_KIND_VAR, relo->insn_idx);
 			break;
 		case RELO_EXTERN_FUNC:
-			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
-					       BTF_KIND_FUNC, relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name,
+					       ext->is_weak, 0, BTF_KIND_FUNC,
+					       relo->insn_idx);
 			break;
 		default:
 			continue;
-- 
2.33.0

