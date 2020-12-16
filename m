Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53D52DBE47
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgLPKIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:08:21 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:42527 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPKIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 05:08:20 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CwrQr5WgPz9tycC;
        Wed, 16 Dec 2020 11:07:32 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ahhypLKUQxfW; Wed, 16 Dec 2020 11:07:32 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CwrQr4SrQz9tysx;
        Wed, 16 Dec 2020 11:07:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BF3D88B7CA;
        Wed, 16 Dec 2020 11:07:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 0-T9wf0Snr0z; Wed, 16 Dec 2020 11:07:33 +0100 (CET)
Received: from localhost.localdomain (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4A49E8B7BA;
        Wed, 16 Dec 2020 11:07:33 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 1F7CA6681D; Wed, 16 Dec 2020 10:07:33 +0000 (UTC)
Message-Id: <9532c3463dc2ced22615f92b19739996b2939f09.1608112797.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1608112796.git.christophe.leroy@csgroup.eu>
References: <cover.1608112796.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [RFC PATCH v1 3/7] powerpc/bpf: Move common helpers into bpf_jit.h
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 16 Dec 2020 10:07:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move functions bpf_flush_icache(), bpf_is_seen_register() and
bpf_set_seen_register() in order to reuse them in future
bpf_jit_comp32.c

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit.h        | 35 +++++++++++++++++++++++++++++++
 arch/powerpc/net/bpf_jit64.h      | 19 -----------------
 arch/powerpc/net/bpf_jit_comp64.c | 16 --------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index d0a67a1bbaf1..b8fa6908fc5e 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -108,6 +108,41 @@ static inline bool is_nearbranch(int offset)
 #define COND_LT		(CR0_LT | COND_CMP_TRUE)
 #define COND_LE		(CR0_GT | COND_CMP_FALSE)
 
+#define SEEN_FUNC	0x1000 /* might call external helpers */
+#define SEEN_STACK	0x2000 /* uses BPF stack */
+#define SEEN_TAILCALL	0x4000 /* uses tail calls */
+
+struct codegen_context {
+	/*
+	 * This is used to track register usage as well
+	 * as calls to external helpers.
+	 * - register usage is tracked with corresponding
+	 *   bits (r3-r10 and r27-r31)
+	 * - rest of the bits can be used to track other
+	 *   things -- for now, we use bits 16 to 23
+	 *   encoded in SEEN_* macros above
+	 */
+	unsigned int seen;
+	unsigned int idx;
+	unsigned int stack_size;
+};
+
+static inline void bpf_flush_icache(void *start, void *end)
+{
+	smp_wmb();	/* smp write barrier */
+	flush_icache_range((unsigned long)start, (unsigned long)end);
+}
+
+static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
+{
+	return ctx->seen & (1 << (31 - i));
+}
+
+static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
+{
+	ctx->seen |= 1 << (31 - i);
+}
+
 #endif
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit64.h b/arch/powerpc/net/bpf_jit64.h
index 2e33c6673ff9..b05f2e67bba1 100644
--- a/arch/powerpc/net/bpf_jit64.h
+++ b/arch/powerpc/net/bpf_jit64.h
@@ -86,25 +86,6 @@ static const int b2p[] = {
 				} while(0)
 #define PPC_BPF_STLU(r, base, i) do { EMIT(PPC_RAW_STDU(r, base, i)); } while(0)
 
-#define SEEN_FUNC	0x1000 /* might call external helpers */
-#define SEEN_STACK	0x2000 /* uses BPF stack */
-#define SEEN_TAILCALL	0x4000 /* uses tail calls */
-
-struct codegen_context {
-	/*
-	 * This is used to track register usage as well
-	 * as calls to external helpers.
-	 * - register usage is tracked with corresponding
-	 *   bits (r3-r10 and r27-r31)
-	 * - rest of the bits can be used to track other
-	 *   things -- for now, we use bits 16 to 23
-	 *   encoded in SEEN_* macros above
-	 */
-	unsigned int seen;
-	unsigned int idx;
-	unsigned int stack_size;
-};
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 26a836a904f5..89599e75028c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -23,22 +23,6 @@ static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
 	memset32(area, BREAKPOINT_INSTRUCTION, size/4);
 }
 
-static inline void bpf_flush_icache(void *start, void *end)
-{
-	smp_wmb();
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
-static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
-{
-	return ctx->seen & (1 << (31 - i));
-}
-
-static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
-{
-	ctx->seen |= 1 << (31 - i);
-}
-
 static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
 {
 	/*
-- 
2.25.0

