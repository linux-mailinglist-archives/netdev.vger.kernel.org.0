Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B921AB2E3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 23:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438286AbgDOUsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438047AbgDOUsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 16:48:13 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDBBC061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 13:48:12 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id y1so590015wrp.5
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 13:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rjzcjb/bQPDNviyt2sPsZPltCFMp8BiGQ60Gy3cwjMA=;
        b=ELPwg0wQpckplvDqgq/mtwUdENH/PVzfd8E6bELnegHBuHnLrtjiXKnZDrXtDBq/kG
         wSRvwaYLD7fbcdIKOrNefWMQCkBW7QEWH7SMNM2jrf698FRNRJPR/E0bDGkXaZPDR0bE
         pQuRQ/y1PThCzEkL1UOC4FSej/M+mzhKZth1JSQ2DISfsjUHCbrRM1kbL5ZvoGAjIOR6
         mIpuzvCBn43L1gzAqd+De+ZuOMJElEbjYKAKhv5sjMPmDw+5grzZSNhvUoSiIMqzb8bg
         XOs4H9+a+cxcJYUyAgN0czDkbdhPM2UJWZAxaXEm1wTbA4dEnzble/dOwdoRXZ7kUFMQ
         deEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rjzcjb/bQPDNviyt2sPsZPltCFMp8BiGQ60Gy3cwjMA=;
        b=QwzHNmzaZzAWCRkkP2TFYvmylBeadsOs4IkN+6FcCTYzNvcPyhDaeuX1QF1oQX9Eds
         JNFn+xkYWqLlsCphMoKGcDWgztV36+iWIhMG6YW5B5KjJFW9oRtyjtoKfdhTMdK5xrop
         n74aKbyP/rVVk4dLHJG29m8+5bG/TFsMYeos6oEqdroN+eRGkeWXWMc98zgodIk5Y/CY
         s/dhDyvsP414+zS55s3KiOlkQKUJDoOMjJCOmAf8iX/xPkTJmDWfnQWaVCYzEy25IP3b
         NGz+Tbz4gsFnbnbMVbTeDGcqT+iOLV1xDlff9SM+HJKle9WkbuYMjMRm33B2uhS5tx2S
         ilLw==
X-Gm-Message-State: AGi0PuYU5G7LZSN1GQb/3sgAUEOAbSB+6tFLIRAJ9ALMkdu8Pwj6ogXo
        fs9WRvq6Nh20vWQdEYPp3EkGT7PDcw==
X-Google-Smtp-Source: APiQypKDe2g3J0jWNrqKmJ0h7aRpbt+PYxVirHwm7VJdlOH9O8Ia7a9ApmtarGVGFXMi+fsVUpRVLrWI7w==
X-Received: by 2002:a5d:53c4:: with SMTP id a4mr29673340wrw.47.1586983690071;
 Wed, 15 Apr 2020 13:48:10 -0700 (PDT)
Date:   Wed, 15 Apr 2020 22:47:43 +0200
Message-Id: <20200415204743.206086-1-jannh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH bpf] bpf: Use pointer type whitelist for XADD
From:   Jann Horn <jannh@google.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, check_xadd() uses a blacklist to decide whether a given
pointer type should be usable with the XADD instruction. Out of all the
pointer types that check_mem_access() accepts, only four are currently let
through by check_xadd():

PTR_TO_MAP_VALUE
PTR_TO_CTX           rejected
PTR_TO_STACK
PTR_TO_PACKET        rejected
PTR_TO_PACKET_META   rejected
PTR_TO_FLOW_KEYS     rejected
PTR_TO_SOCKET        rejected
PTR_TO_SOCK_COMMON   rejected
PTR_TO_TCP_SOCK      rejected
PTR_TO_XDP_SOCK      rejected
PTR_TO_TP_BUFFER
PTR_TO_BTF_ID

Looking at the currently permitted ones:

 - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
 - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
   the BPF stack. It also causes confusion further down, because the first
   check_mem_access() won't check whether the stack slot being read from is
   STACK_SPILL and the second check_mem_access() assumes in
   check_stack_write() that the value being written is a normal scalar.
   This means that unprivileged users can leak kernel pointers.
 - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
 - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
   tries to verify XADD on such memory, the first check_ptr_to_btf_access()
   invocation gets confused by value_regno not being a valid array index
   and writes to out-of-bounds memory.

Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
sense, and is sometimes broken on top of that.

Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
Signed-off-by: Jann Horn <jannh@google.com>
---
I'm just sending this on the public list, since the worst-case impact for
non-root users is leaking kernel pointers to userspace. In a context where
you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
effective at the moment anyway.

This breaks ten unit tests that assume that XADD is possible on the stack,
and I'm not sure how all of them should be fixed up; I'd appreciate it if
someone else could figure out how to fix them. I think some of them might
be using XADD to cast pointers to numbers, or something like that? But I'm
not sure.

Or is XADD on the stack actually something you want to support for some
reason, meaning that that part would have to be fixed differently?

 kernel/bpf/verifier.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 38cfcf701eeb7..397c17a2e970f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2699,28 +2699,6 @@ static bool is_ctx_reg(struct bpf_verifier_env *env, int regno)
 	return reg->type == PTR_TO_CTX;
 }
 
-static bool is_sk_reg(struct bpf_verifier_env *env, int regno)
-{
-	const struct bpf_reg_state *reg = reg_state(env, regno);
-
-	return type_is_sk_pointer(reg->type);
-}
-
-static bool is_pkt_reg(struct bpf_verifier_env *env, int regno)
-{
-	const struct bpf_reg_state *reg = reg_state(env, regno);
-
-	return type_is_pkt_pointer(reg->type);
-}
-
-static bool is_flow_key_reg(struct bpf_verifier_env *env, int regno)
-{
-	const struct bpf_reg_state *reg = reg_state(env, regno);
-
-	/* Separate to is_ctx_reg() since we still want to allow BPF_ST here. */
-	return reg->type == PTR_TO_FLOW_KEYS;
-}
-
 static int check_pkt_ptr_alignment(struct bpf_verifier_env *env,
 				   const struct bpf_reg_state *reg,
 				   int off, int size, bool strict)
@@ -3298,10 +3276,7 @@ static int check_xadd(struct bpf_verifier_env *env, int insn_idx, struct bpf_ins
 		return -EACCES;
 	}
 
-	if (is_ctx_reg(env, insn->dst_reg) ||
-	    is_pkt_reg(env, insn->dst_reg) ||
-	    is_flow_key_reg(env, insn->dst_reg) ||
-	    is_sk_reg(env, insn->dst_reg)) {
+	if (reg_state(env, insn->dst_reg)->type != PTR_TO_MAP_VALUE) {
 		verbose(env, "BPF_XADD stores into R%d %s is not allowed\n",
 			insn->dst_reg,
 			reg_type_str[reg_state(env, insn->dst_reg)->type]);

base-commit: 87b0f983f66f23762921129fd35966eddc3f2dae
-- 
2.26.0.110.g2183baf09c-goog

