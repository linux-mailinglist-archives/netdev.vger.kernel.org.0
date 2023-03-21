Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E526C29C1
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCUFUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCUFUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:20:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E259739CE4;
        Mon, 20 Mar 2023 22:20:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id le6so14880835plb.12;
        Mon, 20 Mar 2023 22:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679376008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hlp+Ui1dMfarlEBa998LNtp9z3tMlr+TDoifOg7iOB0=;
        b=VXVl/xpHc9qAxmOCoY8rZyDqEGroMEbzH9dMVZsjhQlIeYdIWgGbt7enhmKoAAWZ1E
         sI/AKD4r7rdM3uEFEsIMgnuRK04CwQoMohmsr0THzdoZ9uKXbGeOIleit4DmxxYG2ET2
         8M+xEvPDDqj+E/x+Q2Rq9KqLIyciU/99HOAmmgqC3ewqs/Lw8vdzFqWLEM9c5R/8bm4c
         Cz9QL2agS3cqVP8UZe8iJbDi9sFZiiR8CIJdKgBtng5i60kX0IgivaVUExKz5TXyrBoX
         79787pJlYpARJiUFviZhge/zPI8MVOO63FPCB7o3jg3fDDxVOGoVszuqEZI3W3aJvZ7r
         ztPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679376008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hlp+Ui1dMfarlEBa998LNtp9z3tMlr+TDoifOg7iOB0=;
        b=PHsqrEj3ePs8y1w4pL46mDwYum3OqFZ1fsPoeLfiy+jM1voaY0RM+lq9umPYautGsu
         fX33Ehpx7GmBJXitBIv2rpA/cheLrnMbzgxZ8IdLkY1XVGtK66GfhNHoFk3Iv+Ce67/C
         ahKx6Dfow4ZAy50QT8zd9nQ3lMzufZFuiQAIhzwveFsO6yJYZIxvT08SrAWMvlI4YABl
         JKnz6GSroPYFEq27gBeGDUvIKfpFIkI56jTIEIoMU9xerS/qSxNxdk8SL549QWa/6A7c
         UFf/2tcEVNB52S0FiaO6FVlDjdF6raW6Ehmi8v8rSa/ki8Dc7LZ2u+GogTfRGAkvfhV3
         EQXw==
X-Gm-Message-State: AO0yUKXxgOMzNTG1BUMsA2O7m7L3MCL8kZ3eAGL0aQw7WMeWinnbB7v9
        MmymrUrux7AbuglircQEsVg=
X-Google-Smtp-Source: AK7set+qPKN9FuFzi0+ho/Oz46zM1aUt7AJzT0xpeefodT65PkLrHCmd2c1uYjlALIiKw5T6Ynm/NA==
X-Received: by 2002:a17:903:27cd:b0:1a1:d655:1ce4 with SMTP id km13-20020a17090327cd00b001a1d6551ce4mr831368plb.38.1679376008108;
        Mon, 20 Mar 2023 22:20:08 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:1606])
        by smtp.gmail.com with ESMTPSA id v16-20020a17090331d000b001a1ca65f434sm3757888ple.189.2023.03.20.22.20.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Mar 2023 22:20:07 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 3/4] libbpf: Support kfunc detection in light skeleton.
Date:   Mon, 20 Mar 2023 22:19:50 -0700
Message-Id: <20230321051951.58223-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
References: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Teach gen_loader to find {btf_id, btf_obj_fd} of kernel variables and kfuncs
and populate corresponding ld_imm64 and bpf_call insns.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/bpf_gen_internal.h |  4 +++-
 tools/lib/bpf/gen_loader.c       | 38 ++++++++++++++++----------------
 tools/lib/bpf/libbpf.c           |  7 ++++--
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 223308931d55..fdf44403ff36 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -11,6 +11,7 @@ struct ksym_relo_desc {
 	int insn_idx;
 	bool is_weak;
 	bool is_typeless;
+	bool is_ld64;
 };
 
 struct ksym_desc {
@@ -24,6 +25,7 @@ struct ksym_desc {
 		bool typeless;
 	};
 	int insn;
+	bool is_ld64;
 };
 
 struct bpf_gen {
@@ -65,7 +67,7 @@ void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
 void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
-			    bool is_typeless, int kind, int insn_idx);
+			    bool is_typeless, bool is_ld64, int kind, int insn_idx);
 void bpf_gen__record_relo_core(struct bpf_gen *gen, const struct bpf_core_relo *core_relo);
 void bpf_gen__populate_outer_map(struct bpf_gen *gen, int outer_map_idx, int key, int inner_map_idx);
 
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index b74c82bb831e..83e8e3bfd8ff 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -560,7 +560,7 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 }
 
 void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
-			    bool is_typeless, int kind, int insn_idx)
+			    bool is_typeless, bool is_ld64, int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -574,6 +574,7 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
 	relo->name = name;
 	relo->is_weak = is_weak;
 	relo->is_typeless = is_typeless;
+	relo->is_ld64 = is_ld64;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
@@ -586,9 +587,11 @@ static struct ksym_desc *get_ksym_desc(struct bpf_gen *gen, struct ksym_relo_des
 	int i;
 
 	for (i = 0; i < gen->nr_ksyms; i++) {
-		if (!strcmp(gen->ksyms[i].name, relo->name)) {
-			gen->ksyms[i].ref++;
-			return &gen->ksyms[i];
+		kdesc = &gen->ksyms[i];
+		if (kdesc->kind == relo->kind && kdesc->is_ld64 == relo->is_ld64 &&
+		    !strcmp(kdesc->name, relo->name)) {
+			kdesc->ref++;
+			return kdesc;
 		}
 	}
 	kdesc = libbpf_reallocarray(gen->ksyms, gen->nr_ksyms + 1, sizeof(*kdesc));
@@ -603,6 +606,7 @@ static struct ksym_desc *get_ksym_desc(struct bpf_gen *gen, struct ksym_relo_des
 	kdesc->ref = 1;
 	kdesc->off = 0;
 	kdesc->insn = 0;
+	kdesc->is_ld64 = relo->is_ld64;
 	return kdesc;
 }
 
@@ -864,23 +868,17 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
 {
 	int insn;
 
-	pr_debug("gen: emit_relo (%d): %s at %d\n", relo->kind, relo->name, relo->insn_idx);
+	pr_debug("gen: emit_relo (%d): %s at %d %s\n",
+		 relo->kind, relo->name, relo->insn_idx, relo->is_ld64 ? "ld64" : "call");
 	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx;
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
-	switch (relo->kind) {
-	case BTF_KIND_VAR:
+	if (relo->is_ld64) {
 		if (relo->is_typeless)
 			emit_relo_ksym_typeless(gen, relo, insn);
 		else
 			emit_relo_ksym_btf(gen, relo, insn);
-		break;
-	case BTF_KIND_FUNC:
+	} else {
 		emit_relo_kfunc_btf(gen, relo, insn);
-		break;
-	default:
-		pr_warn("Unknown relocation kind '%d'\n", relo->kind);
-		gen->error = -EDOM;
-		return;
 	}
 }
 
@@ -903,18 +901,20 @@ static void cleanup_core_relo(struct bpf_gen *gen)
 
 static void cleanup_relos(struct bpf_gen *gen, int insns)
 {
+	struct ksym_desc *kdesc;
 	int i, insn;
 
 	for (i = 0; i < gen->nr_ksyms; i++) {
+		kdesc = &gen->ksyms[i];
 		/* only close fds for typed ksyms and kfuncs */
-		if (gen->ksyms[i].kind == BTF_KIND_VAR && !gen->ksyms[i].typeless) {
+		if (kdesc->is_ld64 && !kdesc->typeless) {
 			/* close fd recorded in insn[insn_idx + 1].imm */
-			insn = gen->ksyms[i].insn;
+			insn = kdesc->insn;
 			insn += sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm);
 			emit_sys_close_blob(gen, insn);
-		} else if (gen->ksyms[i].kind == BTF_KIND_FUNC) {
-			emit_sys_close_blob(gen, blob_fd_array_off(gen, gen->ksyms[i].off));
-			if (gen->ksyms[i].off < MAX_FD_ARRAY_SZ)
+		} else if (!kdesc->is_ld64) {
+			emit_sys_close_blob(gen, blob_fd_array_off(gen, kdesc->off));
+			if (kdesc->off < MAX_FD_ARRAY_SZ)
 				gen->nr_fd_array--;
 		}
 	}
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f8131f963803..5d32aa8ea38a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7070,18 +7070,21 @@ static int bpf_program_record_relos(struct bpf_program *prog)
 	for (i = 0; i < prog->nr_reloc; i++) {
 		struct reloc_desc *relo = &prog->reloc_desc[i];
 		struct extern_desc *ext = &obj->externs[relo->sym_off];
+		int kind;
 
 		switch (relo->type) {
 		case RELO_EXTERN_LD64:
 			if (ext->type != EXT_KSYM)
 				continue;
+			kind = btf_is_var(btf__type_by_id(obj->btf, ext->btf_id)) ?
+				BTF_KIND_VAR : BTF_KIND_FUNC;
 			bpf_gen__record_extern(obj->gen_loader, ext->name,
 					       ext->is_weak, !ext->ksym.type_id,
-					       BTF_KIND_VAR, relo->insn_idx);
+					       true, kind, relo->insn_idx);
 			break;
 		case RELO_EXTERN_CALL:
 			bpf_gen__record_extern(obj->gen_loader, ext->name,
-					       ext->is_weak, false, BTF_KIND_FUNC,
+					       ext->is_weak, false, false, BTF_KIND_FUNC,
 					       relo->insn_idx);
 			break;
 		case RELO_CORE: {
-- 
2.34.1

