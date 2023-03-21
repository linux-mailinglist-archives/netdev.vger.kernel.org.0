Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2016C3BF6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCUUjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCUUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:39:10 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E23B862;
        Tue, 21 Mar 2023 13:39:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id kq3so4945166plb.13;
        Tue, 21 Mar 2023 13:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hlp+Ui1dMfarlEBa998LNtp9z3tMlr+TDoifOg7iOB0=;
        b=ZKA+LjZP7Qd0izBYnfaud7ZiAZAxTuO07Cbi8bLClSyVmrffdKJRpQYh8kTydZzZ+z
         qyLXMP17NmKMUcJY9+ISRULrYJIaLzBnRGS9Vd4oLw1qpVfhHSc2NLzBpNV/4EqmobM7
         BT4jlCMdpTItjhZshpiPmKSeqdwmk+qpo0otRmG5U45RdBSgp6svpY4Do+QyaiHER4mI
         Sw7byk4QLK1IRSCrCdmDGad+BVJQSkzbLVT5f9Nb4Dq8WDMeCmadtjLqQcMP3/BpBnL+
         v25T+e69crpXrI42iortoQ0mZCcWbI3Zp5RztmfWHmbtgocTBww7lXdJ0ZegTM0m+cs0
         ZWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hlp+Ui1dMfarlEBa998LNtp9z3tMlr+TDoifOg7iOB0=;
        b=NnYWZ8Hj02xYcsIpZxXe+uINgmhbNEygSD8nrhBUbIeg3PHQfBZG3vWN0Vn7d3Rqm3
         7QSYQvIrlxpHKsLSlBgaIJG7mmbXTbUCN7H9gLWd0oWifEDXfUV28zDSctXf0hNdE28J
         JS93+FxlHtFaBtgWi47hGHhP2QGjx6d6u3MhsgCTac+HSe5TVo/DQO2lvhj1tTI+hqV6
         l0woPTG36cbQGFdKVCoB5YOChMCP9q3lDqJ+9AyE6B70qUlGifZMs9iLdzWw8LMB5ykY
         iCPe9su/V5YxoMv9c4ClZcPDw7GZEIoZBgcJUd9Drg5DdUsqtsqAKDCLl0KABzRqtWrY
         uj/A==
X-Gm-Message-State: AO0yUKVxNObpj/u6txjdxYOF1U1T14K7gVvfSpHi9OcWNIW+IQdiVGog
        rFEpVmDGXZAeM4vWE7xeyrI=
X-Google-Smtp-Source: AK7set87Le+EgWstCpX+zsRd8jFVB2e2cCpMhTRgS+zPB+fhpz3WDCgi6i+g3u65B7puybVv5292fA==
X-Received: by 2002:a17:90b:3b46:b0:23b:50ff:59ba with SMTP id ot6-20020a17090b3b4600b0023b50ff59bamr1018463pjb.21.1679431148654;
        Tue, 21 Mar 2023 13:39:08 -0700 (PDT)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:500::5:34cf])
        by smtp.gmail.com with ESMTPSA id i5-20020a17090aa90500b002311c4596f6sm10549938pjq.54.2023.03.21.13.39.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Mar 2023 13:39:08 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/4] libbpf: Support kfunc detection in light skeleton.
Date:   Tue, 21 Mar 2023 13:38:53 -0700
Message-Id: <20230321203854.3035-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

