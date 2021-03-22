Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CE9344BBA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhCVQiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:38:08 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54162 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhCVQht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:37:49 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F40Xk3KZLz9txkP;
        Mon, 22 Mar 2021 17:37:42 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id kXWr-QFZSY8s; Mon, 22 Mar 2021 17:37:42 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F40Xk2Rr1z9txkL;
        Mon, 22 Mar 2021 17:37:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EAE848B79C;
        Mon, 22 Mar 2021 17:37:47 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id mTjpfe10-yXY; Mon, 22 Mar 2021 17:37:47 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9F33C8B7A4;
        Mon, 22 Mar 2021 17:37:47 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 83678675FC; Mon, 22 Mar 2021 16:37:47 +0000 (UTC)
Message-Id: <0cd2506f598e7095ea43e62dca1f472de5474a0d.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 2/8] powerpc/bpf: Change register numbering for
 bpf_set/is_seen_register()
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 22 Mar 2021 16:37:47 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using BPF register number as input in functions
bpf_set_seen_register() and bpf_is_seen_register(), use
CPU register number directly.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit_comp64.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index aaf1a887f653..51b3f440288c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -31,12 +31,12 @@ static inline void bpf_flush_icache(void *start, void *end)
 
 static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
 {
-	return (ctx->seen & (1 << (31 - b2p[i])));
+	return ctx->seen & (1 << (31 - i));
 }
 
 static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
 {
-	ctx->seen |= (1 << (31 - b2p[i]));
+	ctx->seen |= 1 << (31 - i);
 }
 
 static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
@@ -47,7 +47,7 @@ static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
 	 * - the bpf program uses its stack area
 	 * The latter condition is deduced from the usage of BPF_REG_FP
 	 */
-	return ctx->seen & SEEN_FUNC || bpf_is_seen_register(ctx, BPF_REG_FP);
+	return ctx->seen & SEEN_FUNC || bpf_is_seen_register(ctx, b2p[BPF_REG_FP]);
 }
 
 /*
@@ -124,11 +124,11 @@ static void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 	 * in the protected zone below the previous stack frame
 	 */
 	for (i = BPF_REG_6; i <= BPF_REG_10; i++)
-		if (bpf_is_seen_register(ctx, i))
+		if (bpf_is_seen_register(ctx, b2p[i]))
 			PPC_BPF_STL(b2p[i], 1, bpf_jit_stack_offsetof(ctx, b2p[i]));
 
 	/* Setup frame pointer to point to the bpf stack area */
-	if (bpf_is_seen_register(ctx, BPF_REG_FP))
+	if (bpf_is_seen_register(ctx, b2p[BPF_REG_FP]))
 		EMIT(PPC_RAW_ADDI(b2p[BPF_REG_FP], 1,
 				STACK_FRAME_MIN_SIZE + ctx->stack_size));
 }
@@ -139,7 +139,7 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 
 	/* Restore NVRs */
 	for (i = BPF_REG_6; i <= BPF_REG_10; i++)
-		if (bpf_is_seen_register(ctx, i))
+		if (bpf_is_seen_register(ctx, b2p[i]))
 			PPC_BPF_LL(b2p[i], 1, bpf_jit_stack_offsetof(ctx, b2p[i]));
 
 	/* Tear down our stack frame */
@@ -330,9 +330,9 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 * any issues.
 		 */
 		if (dst_reg >= BPF_PPC_NVR_MIN && dst_reg < 32)
-			bpf_set_seen_register(ctx, insn[i].dst_reg);
+			bpf_set_seen_register(ctx, dst_reg);
 		if (src_reg >= BPF_PPC_NVR_MIN && src_reg < 32)
-			bpf_set_seen_register(ctx, insn[i].src_reg);
+			bpf_set_seen_register(ctx, src_reg);
 
 		switch (code) {
 		/*
-- 
2.25.0

