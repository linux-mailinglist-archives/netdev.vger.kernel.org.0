Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3B56496AF
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 23:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLKWQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 17:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiLKWQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 17:16:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7578ADEB1
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 14:16:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o5so10328440wrm.1
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 14:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.huji.ac.il; s=mailhuji;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ni6ap3ZTSSQLWT4jw5HwfmJdLJiMoNH+N4dU0gGowyA=;
        b=EYLzQOAopum3pSRQHrpnKxi13r3F+Hy0yhyJAoTuvDz33Ch7Tv2ysaS8m4GyyOxgBi
         q/k32WQO5EX91YsdGdGMabqCZ9P8blItNhs9fIQM7o1mTlleCHIr3HtU1PIWR6v+z85I
         cDLhaKRLFOCzCBXGxHMwhxnrJmimSYjeYJIx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ni6ap3ZTSSQLWT4jw5HwfmJdLJiMoNH+N4dU0gGowyA=;
        b=M2qcuu4b5Qggaua737/XCeRHoCAX7fdHhpwQJ9pm1mXfIPhPXxuivSP3jfRvyvCk7l
         q07y1tPNPB9PVN3/RHaFSDXgjGyaPOqE7KL2vyQ/TIS/bfK8EFi9qa2sg2xoju6ms9aq
         p2hAfDBnJYWByczqPNbWvZu/gewKl35bepIJ+U2XV7olieobnjgT5d9DgnNdvRnXz1JR
         xoHGeki69Kitq6ucHHlGLGRATA35vmJqkv2aSezi+eztwZtK3P7erYQI267BIzY0k44e
         8hzUXYsYo8merZyfJsG6KhwDV5kFGfq6mENPig1WndiFQaIgyo1A1MYNCnD7AK4Dcg4y
         LH4w==
X-Gm-Message-State: ANoB5pkoz+driNgOtu5k6GZgdGESvbp6GednrIJo0Ug5nnfVzdPSDPZz
        Tbyd0Koliy6sBagFYDNnEDP0bA==
X-Google-Smtp-Source: AA0mqf5eiE3KSbJCRDLvM+KkM9HyqMO32IozmzWEX6a96+v4zJ+rNb9OcomTmXFxRzIrFkqdGIBt3A==
X-Received: by 2002:a05:6000:81a:b0:242:69f4:cb6f with SMTP id bt26-20020a056000081a00b0024269f4cb6fmr9084177wrb.32.1670796982926;
        Sun, 11 Dec 2022 14:16:22 -0800 (PST)
Received: from MacBook-Pro-5.lan ([2a0d:6fc2:218c:1a00:a91c:f8bf:c26f:4f15])
        by smtp.gmail.com with ESMTPSA id d7-20020adffd87000000b002422bc69111sm8605805wrr.9.2022.12.11.14.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 14:16:22 -0800 (PST)
From:   david.keisarschm@mail.huji.ac.il
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David <david.keisarschm@mail.huji.ac.il>, aksecurity@gmail.com,
        ilay.bahat1@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] Replace invocation of weak PRNG in kernel/bpf/core.c
Date:   Mon, 12 Dec 2022 00:16:05 +0200
Message-Id: <7c16cafe96c47ff5234fbb980df9d3e3d48a0296.1670778652.git.david.keisarschm@mail.huji.ac.il>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David <david.keisarschm@mail.huji.ac.il>

We changed the invocation of
 prandom_u32_state to get_random_u32.
 We deleted the maintained state,
 which was a CPU-variable,
 since get_random_u32 maintains its own CPU-variable.
 We also deleted the state initializer,
 since it is not needed anymore.

Signed-off-by: David <david.keisarschm@mail.huji.ac.il>
---
 include/linux/bpf.h   |  1 -
 kernel/bpf/core.c     | 13 +------------
 kernel/bpf/verifier.c |  2 --
 net/core/filter.c     |  1 -
 4 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c1bd1bd10..0689520b9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2572,7 +2572,6 @@ const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
 
 /* Shared helpers among cBPF and eBPF. */
-void bpf_user_rnd_init_once(void);
 u64 bpf_user_rnd_u32(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 u64 bpf_get_raw_cpu_id(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4cb5421d9..a6f06894e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2579,13 +2579,6 @@ void bpf_prog_free(struct bpf_prog *fp)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_free);
 
-/* RNG for unpriviledged user space with separated state from prandom_u32(). */
-static DEFINE_PER_CPU(struct rnd_state, bpf_user_rnd_state);
-
-void bpf_user_rnd_init_once(void)
-{
-	prandom_init_once(&bpf_user_rnd_state);
-}
 
 BPF_CALL_0(bpf_user_rnd_u32)
 {
@@ -2595,12 +2588,8 @@ BPF_CALL_0(bpf_user_rnd_u32)
 	 * transformations. Register assignments from both sides are
 	 * different, f.e. classic always sets fn(ctx, A, X) here.
 	 */
-	struct rnd_state *state;
 	u32 res;
-
-	state = &get_cpu_var(bpf_user_rnd_state);
-	res = predictable_rng_prandom_u32_state(state);
-	put_cpu_var(bpf_user_rnd_state);
+	res = get_random_u32();
 
 	return res;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 264b3dc71..9f22fb3fa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14049,8 +14049,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 
 		if (insn->imm == BPF_FUNC_get_route_realm)
 			prog->dst_needed = 1;
-		if (insn->imm == BPF_FUNC_get_prandom_u32)
-			bpf_user_rnd_init_once();
 		if (insn->imm == BPF_FUNC_override_return)
 			prog->kprobe_override = 1;
 		if (insn->imm == BPF_FUNC_tail_call) {
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a..7a595ac00 100644
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
2.38.0

