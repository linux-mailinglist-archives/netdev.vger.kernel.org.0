Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E8943DB3C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJ1Ghj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhJ1Ghg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73055C061570;
        Wed, 27 Oct 2021 23:35:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f8so3701174plo.12;
        Wed, 27 Oct 2021 23:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMV7r7FDbeTl8+YSOMDTYBRHo5W4L1u0hp0ZuchYhNo=;
        b=hlgmVneKnEOIfI5BJIPNsf/xyHF+wf2BQI/hEGLev5bgvYFuSF+b9sTrdcRXZ8Bidp
         aqNA7lBvEHygjG0Kcm4BHxam9fju28xwKIJ+kakw1keWwRAUVnA2iITDunGz7tNhFJmU
         OWwy9RNIg92U06WhnlieLo+4jOKRc6ooXZBIuhQlkNXX6LWaTcOvUTE95KEvfxrohX+V
         jW6mWTz39jdMILpKHYsn9OMJMMj34Xv8n8FGPykYahu6UtES6Bq0pG2Ws+6CroQeWy0Z
         qSxIhmnUS75LdlOhMKFrHTgLkkUtky50vLnZ8D/MmHkzCfz7nNZz/AfQO7MaACeux6M9
         USbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMV7r7FDbeTl8+YSOMDTYBRHo5W4L1u0hp0ZuchYhNo=;
        b=nF5HuINREo876Ndy+DMymErJ0ndL3HtOXfP/1m34ysEYV2jMNjWXvcwPk3uNpH8Cf0
         iE0Goi+2Uizy9qoT51luXdvsSDCVjqz1XxpVpYiGO/URmL/laUJRbbfloAb4+eLVos2a
         faepv0UJLWmBY3h+1wR01mYmN4O1mI9Xg/3DLq3/t5g/zNfW9OdQpAc2nUSaJAvvm9Yi
         kVUWjnjWGnoObElGFVd71m6CsHLPpixpsCfKeYP/yMw9XIAZormwy9aGBNgJSbJ/Au3h
         BzWcHQXHzDPO1UfZlTewvwntqYwafKLPXmP4u85V9D5BwVXUnRDRePlYJTyUl72j/1Ub
         BPww==
X-Gm-Message-State: AOAM531yhSoPOkOPHmikyCq3R1Y9tlFd1lL9djbVjkB606u9fcAjXJvX
        0coLIcx0mr2+TdTzA5UElibIXowr1t/koQ==
X-Google-Smtp-Source: ABdhPJwvCWxOMkzsHmC+MRXcCKv8NXjsHp9L7mF63kdY0N1txIadbRfHSDjp7lLHK5XIS4GqCok48Q==
X-Received: by 2002:a17:90b:1c09:: with SMTP id oc9mr10669053pjb.33.1635402909784;
        Wed, 27 Oct 2021 23:35:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id t13sm1622165pgn.94.2021.10.27.23.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:09 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 2/8] libbpf: Add typeless ksym support to gen_loader
Date:   Thu, 28 Oct 2021 12:04:55 +0530
Message-Id: <20211028063501.2239335-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9449; h=from:subject; bh=1QkAZaMB8emdlGN5Ss+2rboWkYJlfDXQKPFrUbVUtNQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR+gTK0M6CgqI5qhHQFlnPHuOxXwTh4aK6V7CnG Wo3CY5OJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfgAKCRBM4MiGSL8Ryl23EA DAMQPHcznuQ380Ut1DdRFT7b7zC4o/HrtWdgijvJlN/zseB1PgOzDtWefiki5bLFtOMn7274hTB0tX dMqYI5G1xrIRfHTRUII9tiiU9+oaWkQm6/LfMcgbVOyQ5XGlSMjbkugMq8YSZXppgbKUX9GKAIi/kc 0aAhKn6PMujjqdGq+8To8PY/vAW0Npt2pr/VVIvJYYUTaYihFBELp6uup4ZdGgossvpPOPbs31ntvr 1iFxeC4Ra8pBAMhHnqtNIYKomLAQ/5qFRXlMXo1MEWq6a5U0dsD5wGpFhuwbTEsbFgG/sQhDMDKX6D u3oOYr7zhHL+GG8qkb3x7j+bemEQn+IJTLbbXjV3TuGZjd0rav/T74O7w6chjTRE0txTDazy1CQFOm 3Wu3g0MMUApm7H3uqOr3rHQyHCPfQ64PGdCCFXwVjD/0gH+W1Rx6YYVSvFZkry+ot3alxMu9reU92U d+cslSQAKNb13DLEK/ekqTHNvpfL+B7so6wA1FfxOBqvUJBeNWo3eL1ocwr/z+Kj5tIQkLKIJLxqZ1 OD03PcajERJZxSENvhAmh6cRIK/eC9gJMKCbWfL2VR5iF3sY/hEgV6v/MQALZNaqsZhtlXgxjdduJJ ubBAgFOjM2eVgeAbdzr0IfHBM79RRWdnttKD4XfA/c4k/n0++yBblHpK/8vQ==
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

We add a emit_ksym_relo_log helper that avoids duplicating common
logging instructions between typeless and weak ksym (for future commit).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h | 12 +++-
 tools/lib/bpf/gen_loader.c       | 97 ++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.c           | 13 ++---
 3 files changed, 99 insertions(+), 23 deletions(-)

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
index 937bfc7db41e..11172a868180 100644
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
@@ -700,6 +724,58 @@ static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo
 		   relo->name, kdesc->ref);
 }
 
+static void emit_ksym_relo_log(struct bpf_gen *gen, struct ksym_relo_desc *relo,
+			       int ref)
+{
+	if (!gen->log_level)
+		return;
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
+			      offsetof(struct bpf_insn, imm)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=%d w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
+		   relo->is_typeless, relo->is_weak, relo->name, ref);
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	debug_regs(gen, BPF_REG_9, -1, " var t=%d w=%d (%s:count=%d): insn.reg",
+		   relo->is_typeless, relo->is_weak, relo->name, ref);
+}
+
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
+	emit_ksym_relo_log(gen, relo, kdesc->ref);
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  */
@@ -729,14 +805,7 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
 log:
-	if (!gen->log_level)
-		return;
-	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
-			      offsetof(struct bpf_insn, imm)));
-	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
-			      offsetof(struct bpf_insn, imm)));
-	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var (%s:count=%d): imm: %%d, fd: %%d",
-		   relo->name, kdesc->ref);
+	emit_ksym_relo_log(gen, relo, kdesc->ref);
 }
 
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
@@ -748,7 +817,10 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
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
@@ -773,12 +845,13 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
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
index 59d39ce9f375..61d666dc5646 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6560,17 +6560,14 @@ static int bpf_program__record_externs(struct bpf_program *prog)
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
+					       ext->is_weak, false, BTF_KIND_FUNC,
+					       relo->insn_idx);
 			break;
 		default:
 			continue;
-- 
2.33.1

