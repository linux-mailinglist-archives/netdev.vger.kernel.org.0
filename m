Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C775B642FAC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiLESPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiLESPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:15:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F312037D;
        Mon,  5 Dec 2022 10:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DFEBB80E6F;
        Mon,  5 Dec 2022 18:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF15BC433C1;
        Mon,  5 Dec 2022 18:15:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LcEqgcPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670264143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o5wurk9n+fhcKuPqAijagg/yKq0yv8nKTRp/gYVfZpE=;
        b=LcEqgcPK1W7vppIkpae14KX5IfmybWNqDaUyvcKm6QKriYbpy0739/kPRoBnGNSpp8fQ/U
        Hz/oilo0ZwAb/Ewhd1CUDoHmZHqIx3fNs3Cv3q1woQZrEe66pHJB8F3zVpuWlhFPc27XE2
        WVHBM7SY9OgiIWDXQdweg/im7C+HyGg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7d501ee1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Dec 2022 18:15:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: [PATCH] bpf: call get_random_u32() for random integers
Date:   Mon,  5 Dec 2022 19:15:34 +0100
Message-Id: <20221205181534.612702-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since BPF's bpf_user_rnd_u32() was introduced, there have been three
significant developments in the RNG: 1) get_random_u32() returns the
same types of bytes as /dev/urandom, eliminating the distinction between
"kernel random bytes" and "userspace random bytes", 2) get_random_u32()
operates mostly locklessly over percpu state, 3) get_random_u32() has
become quite fast.

So rather than using the old clunky Tausworthe prandom code, just call
get_random_u32(), which should fit BPF uses perfectly.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/bpf.h   |  1 -
 kernel/bpf/core.c     | 17 +----------------
 kernel/bpf/verifier.c |  2 --
 net/core/filter.c     |  1 -
 4 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0566705c1d4e..aae89318789a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2554,7 +2554,6 @@ const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
 
 /* Shared helpers among cBPF and eBPF. */
-void bpf_user_rnd_init_once(void);
 u64 bpf_user_rnd_u32(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 u64 bpf_get_raw_cpu_id(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 38159f39e2af..2cc28d63d761 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2579,14 +2579,6 @@ void bpf_prog_free(struct bpf_prog *fp)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_free);
 
-/* RNG for unpriviledged user space with separated state from prandom_u32(). */
-static DEFINE_PER_CPU(struct rnd_state, bpf_user_rnd_state);
-
-void bpf_user_rnd_init_once(void)
-{
-	prandom_init_once(&bpf_user_rnd_state);
-}
-
 BPF_CALL_0(bpf_user_rnd_u32)
 {
 	/* Should someone ever have the rather unwise idea to use some
@@ -2595,14 +2587,7 @@ BPF_CALL_0(bpf_user_rnd_u32)
 	 * transformations. Register assignments from both sides are
 	 * different, f.e. classic always sets fn(ctx, A, X) here.
 	 */
-	struct rnd_state *state;
-	u32 res;
-
-	state = &get_cpu_var(bpf_user_rnd_state);
-	res = prandom_u32_state(state);
-	put_cpu_var(bpf_user_rnd_state);
-
-	return res;
+	return get_random_u32();
 }
 
 BPF_CALL_0(bpf_get_raw_cpu_id)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 225666307bba..75a1a6526165 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14045,8 +14045,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 
 		if (insn->imm == BPF_FUNC_get_route_realm)
 			prog->dst_needed = 1;
-		if (insn->imm == BPF_FUNC_get_prandom_u32)
-			bpf_user_rnd_init_once();
 		if (insn->imm == BPF_FUNC_override_return)
 			prog->kprobe_override = 1;
 		if (insn->imm == BPF_FUNC_tail_call) {
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..7a595ac0028d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -443,7 +443,6 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
 			break;
 		case SKF_AD_OFF + SKF_AD_RANDOM:
 			*insn = BPF_EMIT_CALL(bpf_user_rnd_u32);
-			bpf_user_rnd_init_once();
 			break;
 		}
 		break;
-- 
2.38.1

