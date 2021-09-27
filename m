Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D90E419E3D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhI0S2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhI0S2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:28:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB9C06176E
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso777678pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gyzvvu34BplawGFiRX25KunAAS4/1dR6ovGk97BDMko=;
        b=AqFgl97FE4+vPmW/oUfPm4QB6nODUdWUTYULvyTCp3IhilgNVmjfon3i9ob9keQNf8
         woCGo9/wCPdefx0Uk17wMSpWEHWt4UqUlzAf0IZNh9Mpyc1E+6NH/6y4tYJrXZcVdhbn
         umsVCYp3sBHgiIFAzWpuyIxk7ZFzWMwrE5FXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gyzvvu34BplawGFiRX25KunAAS4/1dR6ovGk97BDMko=;
        b=iITtfwBAQ3tKZURrjsHcJxel/rKa0wt6MyFyZRRqIXiuq1vBGXhx6ajUQatIiEwA9A
         4gxfLN3M6m1IcTIwIb+t6jY1Kl5hc18eLj1vU9cnTkC5x68Ko8Gl2SgQeeU21aFykAK5
         1EM9Psrpx+f3WiDuKBdixKg7cPXi2KPwFvWV41mx/ZFi1+4FFAzm2/2fn8MGgl5Syltt
         8PMAyrKfm1Pu3MhWemjwvieUNyrMk1oFtf5IUaF1wbP+0aXxR2TqT4REutCtS15jbk3Z
         ytRET8X5I+FRnIsKLKHeny82uXr/qCDR2Nh63CIn2zUbyuAejWKOM3fSpcJ2qsOdYOmC
         oPLA==
X-Gm-Message-State: AOAM531LfUdUjoLtFGnKyHgLLfh1aatcDvlx0E26q5fMwNo4fhPeuiNy
        EsWeXfUENyJdMTtvpfuuMK1dqQ==
X-Google-Smtp-Source: ABdhPJyoaOvMk0IfLf2HRzl/qDsqyYT4TE+UU14FEECwgFwzBavl9qEbXkKuM7TnRlGzuhzNXodDSg==
X-Received: by 2002:a17:902:7590:b0:13d:c5d4:1b29 with SMTP id j16-20020a170902759000b0013dc5d41b29mr1196935pll.36.1632767224034;
        Mon, 27 Sep 2021 11:27:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g15sm17681849pfu.155.2021.09.27.11.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:27:03 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 1/2] bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
Date:   Mon, 27 Sep 2021 11:26:59 -0700
Message-Id: <20210927182700.2980499-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927182700.2980499-1-keescook@chromium.org>
References: <20210927182700.2980499-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5922; h=from:subject; bh=trwG88QMUpz37N/1nVjow7A8tNfjHkzeQ6HCfI516c8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhUgzz9SJeieOEbkNq+ygFiFmxJBVrJVIgw4LdlBeF LahQ+jyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYVIM8wAKCRCJcvTf3G3AJncVD/ 40BsDBm8XgAkbm6v1I7oRgAWWLOhNyFFGJW+6jWwOfzsJCYpu6PBhskJslczKfvzntBkvR5QSjEaZa IoLRyiiU4yLjVBmEAMdBIqyvTDhf8Nqkax0HJGgccbOz4D9rAu6AnvieL4cS6Q6ZTc1gMXtTzBjnJX e4Bij3eAkR3PnvEDBgXFdCFMZUv2hM1FzC8VWMRPSNWBqjJTXbf2jMThs41D1buJOFU7oK+jYHMUcX evb3pqU3iCl8Kw4kELBy1GaRrWPshVF5cHxAYiE1r/0Bw5SrjiqeEi54OLnT1wo0ZbKRgGncwPGJoM 2p88NgD1peZ6aAIAddUMadT6Yj+7CEDGb1Xx8gkgaUCdRTQp/AFk8TLHOiLNvRP+Eu29IBF4RJtVnG A9YeyG8hIicIpQ3FDePwCpwgKJ5VayEHiZyz1ZZLctzVYJG9ZYRvWFuL+EkgiX8NLFOGaPHbt57wdr cHeKPx/ftFbXocRSHeRzGHKesuG0EZTV0nLBuHG88v4t9UQnoRz3NeUG+4Tw9CsWQB3FST+SLLLQ/Z 1sYywf4dYqQ+usVvEqsWIlH6Q6I9VFWHuNw0isv0MrurmZU3S+Urg5Fe1YKHNIn03WumN8g/1sz0tc P5BFUIgu4jBRrnYdgxfCbN9LzNnhYc9BEAjlZf4uf5GCVME8P1xpjEIml8EA==
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
Cc: Andrii Nakryiko <andrii@kernel.org>
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
---
 include/linux/filter.h |  6 +++++-
 kernel/bpf/hashtab.c   |  6 +++---
 kernel/bpf/verifier.c  | 26 +++++++++-----------------
 3 files changed, 17 insertions(+), 21 deletions(-)

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
index e76b55917905..15068fa7b16d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1730,7 +1730,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
-	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
+	desc->imm = BPF_CALL_IMM(addr);
 	err = btf_distill_func_proto(&env->log, btf_vmlinux,
 				     func_proto, func_name,
 				     &desc->func_model);
@@ -12469,8 +12469,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 			if (!bpf_pseudo_call(insn))
 				continue;
 			subprog = insn->off;
-			insn->imm = BPF_CAST_CALL(func[subprog]->bpf_func) -
-				    __bpf_call_base;
+			insn->imm = BPF_CALL_IMM(func[subprog]->bpf_func);
 		}
 
 		/* we use the aux data to keep a list of the start addresses
@@ -12950,32 +12949,25 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
 
-- 
2.30.2

