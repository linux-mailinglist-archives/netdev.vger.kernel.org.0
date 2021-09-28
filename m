Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A1941BACC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhI1XLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243207AbhI1XLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:11:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3F8C061745
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:09:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j15so183878plh.7
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26dur9paIKLElVRdcLTX2hNA9FCFD+hLRoxrw3MIGsE=;
        b=ZSRJoukLzsc0CPAjVAi3zUT0Rj7QczkV2sENdARA2z32xHpkvKNknocuv1zTNzkm1j
         yuw9JjXMM6mMeA2RosNNhkcQoIFTsKaUvvWWw/5CvTSnkq2+AQiI5zq8Qd9df34zGCj5
         BZCOmT8v4fAiJxUAtL/x70yS/amBtbuDaqwPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26dur9paIKLElVRdcLTX2hNA9FCFD+hLRoxrw3MIGsE=;
        b=kvGw7vDXKIBtfv1oHREhRzPaufZ+Dji6KXcXZeR28WSQdUMb+ENiq1/XxMMcuk2tkP
         H7mhfm5Oyjg5bIoTdW9BFEBfn3bWCTwSSOmBj5B8Y5vAzQgVXW1mRA5y7jCUTQFbj56L
         j/QCZGEgUTWd+gEVb1R4qP5+cjzlY4Rm+5c2T0oHnXTmJ76biV6CheFqqXNcBAiRYgmG
         1CquFQwIzo+DIAwW44JjzrvuN2HbmHO6hEtUwcaHjBIqMYj6+2f5mhoho5h+CcUL61zE
         AY0djrQvCv/DnPkM0KpGj+54uwk0UcFqQY0Mh0FGOFlxpHbs1NCxggMc/5gboUjaSa6k
         uaog==
X-Gm-Message-State: AOAM530mvnW5EoOZwyMMPC4WWiKyYbAwVvYBRlnPhAKsi9k9PgqhTt7t
        Y0+upF4iZzfl96gsrktEj/OI7g==
X-Google-Smtp-Source: ABdhPJypDbZe9TFemHLE+M93sExkek6MsLTpPbNNHX7qbWVS32KYkUZQaGwkl5ndQgRjoWymNLPzCQ==
X-Received: by 2002:a17:90a:4091:: with SMTP id l17mr2755538pjg.138.1632870591751;
        Tue, 28 Sep 2021 16:09:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y13sm144694pjc.50.2021.09.28.16.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 16:09:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
Date:   Tue, 28 Sep 2021 16:09:45 -0700
Message-Id: <20210928230946.4062144-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928230946.4062144-1-keescook@chromium.org>
References: <20210928230946.4062144-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6536; h=from:subject; bh=QTrb9yWbYK4FblFNy6JPUgIc30eI7Imex7fw41+XQMY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhU6C6+HLjGARSHaQSRNNSYiyWy34WeYI5V1BijsnQ YI8AnC2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYVOgugAKCRCJcvTf3G3AJisqD/ wKrle0RcrwFqdohNLv+VetOOZbiu0XT5jhRPmTkV6unaNGSilxLgyqhLN3XoEFYoAaIEXHgMPLeaT5 Sv+HuAmBq8I465O+fVB3LFhMZPkNGbhhOTVZ8c1mwYarmi3Cq2ysXuR48uY96DLSOb8W7JqEIYUbSO LwNMvjFH18rbZMtN3+cqg32jiPCT0RjFyJvB2Ou44UJkBfUtvCtyet+feX4e7GU1d8Ar4KnkCQf4F2 dBErTvFFBmpz93z5Obv6CP5Dc6vvUImoHw1aBpk1eQ9Z3zBc1+8xJ/EG20VHEB9xj72JqwW+G8v/8J wFEn90IxCn3Fll2p7IBdVyeDt2bhJpmCHPZ0UXPGIClE5kVMBVtUepTSb3fASCkJrTJX4YOC669dzV ql3y0Ui+DUuH192thwMqMtDdq5PztL3QoQ92nl1CBO3aVgGJgYSP4orzO3NkuxbeM65vX1H/2Fdfk+ rHHOk4O18E3VrT/F49ORrzC6sjM1CxgekNwla0Sc8yjGhPsuXh0EXCrLGEcVBTQLTwj3FjArqLQCt8 mxVa2XD98mGWhY8UU3m+OQ2f/6e09hjJXmSLixOhpcIbsxnTfA4HKYdULOzx6Kds63PDSHX7uZFD4q bc94e7gyTIltxhTPrRl6FaEPuqNvZwXDJhY5h2r8Iqoy/1Dlse8BcLqqDoBg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to keep ahead of cases in the kernel where Control Flow
Integrity (CFI) may trip over function call casts, enabling
-Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
various warnings and is one of the last places in the kernel triggering
this warning.

Most places using BPF_CAST_CALL actually just want a void * to perform
math on. It's not actually performing a call, so just use a different
helper to get the void *, by way of the new BPF_CALL_IMM() helper, which
can clean up a common copy/paste idiom as well.

This change results in no object code difference.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://github.com/KSPP/linux/issues/20
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/lkml/CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com
---
 include/linux/filter.h |  6 +++++-
 kernel/bpf/hashtab.c   |  6 +++---
 kernel/bpf/verifier.c  | 26 +++++++++-----------------
 lib/test_bpf.c         |  2 +-
 4 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4a93c12543ee..6c247663d4ce 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -365,13 +365,17 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 #define BPF_CAST_CALL(x)					\
 		((u64 (*)(u64, u64, u64, u64, u64))(x))
 
+/* Convert function address to BPF immediate */
+
+#define BPF_CALL_IMM(x)	((void *)(x) - (void *)__bpf_call_base)
+
 #define BPF_EMIT_CALL(FUNC)					\
 	((struct bpf_insn) {					\
 		.code  = BPF_JMP | BPF_CALL,			\
 		.dst_reg = 0,					\
 		.src_reg = 0,					\
 		.off   = 0,					\
-		.imm   = ((FUNC) - __bpf_call_base) })
+		.imm   = BPF_CALL_IMM(FUNC) })
 
 /* Raw code statement block */
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 32471ba02708..3d8f9d6997d5 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -668,7 +668,7 @@ static int htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 
 	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
 		     (void *(*)(struct bpf_map *map, void *key))NULL));
-	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
+	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
 	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 1);
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, ret,
 				offsetof(struct htab_elem, key) +
@@ -709,7 +709,7 @@ static int htab_lru_map_gen_lookup(struct bpf_map *map,
 
 	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
 		     (void *(*)(struct bpf_map *map, void *key))NULL));
-	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
+	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
 	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 4);
 	*insn++ = BPF_LDX_MEM(BPF_B, ref_reg, ret,
 			      offsetof(struct htab_elem, lru_node) +
@@ -2397,7 +2397,7 @@ static int htab_of_map_gen_lookup(struct bpf_map *map,
 
 	BUILD_BUG_ON(!__same_type(&__htab_map_lookup_elem,
 		     (void *(*)(struct bpf_map *map, void *key))NULL));
-	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_map_lookup_elem));
+	*insn++ = BPF_EMIT_CALL(__htab_map_lookup_elem);
 	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 2);
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, ret,
 				offsetof(struct htab_elem, key) +
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7a8351604f67..1433752db740 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1744,7 +1744,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
-	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
+	desc->imm = BPF_CALL_IMM(addr);
 	err = btf_distill_func_proto(&env->log, btf_vmlinux,
 				     func_proto, func_name,
 				     &desc->func_model);
@@ -12514,8 +12514,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 			if (!bpf_pseudo_call(insn))
 				continue;
 			subprog = insn->off;
-			insn->imm = BPF_CAST_CALL(func[subprog]->bpf_func) -
-				    __bpf_call_base;
+			insn->imm = BPF_CALL_IMM(func[subprog]->bpf_func);
 		}
 
 		/* we use the aux data to keep a list of the start addresses
@@ -12995,32 +12994,25 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 patch_map_ops_generic:
 			switch (insn->imm) {
 			case BPF_FUNC_map_lookup_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_lookup_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_lookup_elem);
 				continue;
 			case BPF_FUNC_map_update_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_update_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_update_elem);
 				continue;
 			case BPF_FUNC_map_delete_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_delete_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_delete_elem);
 				continue;
 			case BPF_FUNC_map_push_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_push_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_push_elem);
 				continue;
 			case BPF_FUNC_map_pop_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_pop_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_pop_elem);
 				continue;
 			case BPF_FUNC_map_peek_elem:
-				insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_peek_elem);
 				continue;
 			case BPF_FUNC_redirect_map:
-				insn->imm = BPF_CAST_CALL(ops->map_redirect) -
-					    __bpf_call_base;
+				insn->imm = BPF_CALL_IMM(ops->map_redirect);
 				continue;
 			}
 
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 08f438e6fe9e..21ea1ab253a1 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -12439,7 +12439,7 @@ static __init int prepare_tail_call_tests(struct bpf_array **pprogs)
 					err = -EFAULT;
 					goto out_err;
 				}
-				*insn = BPF_EMIT_CALL(BPF_CAST_CALL(addr));
+				*insn = BPF_EMIT_CALL(addr);
 				if ((long)__bpf_call_base + insn->imm != addr)
 					*insn = BPF_JMP_A(0); /* Skip: NOP */
 				break;
-- 
2.30.2

