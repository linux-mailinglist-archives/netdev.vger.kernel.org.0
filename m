Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3F344BBE
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhCVQiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:38:15 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:40420 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231610AbhCVQhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:37:50 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F40Xl3QDHz9txkQ;
        Mon, 22 Mar 2021 17:37:43 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id DydMdxa-iIWM; Mon, 22 Mar 2021 17:37:43 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F40Xl2b0Gz9txkL;
        Mon, 22 Mar 2021 17:37:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0D8CF8B7A3;
        Mon, 22 Mar 2021 17:37:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 0U9w0ynyvXqF; Mon, 22 Mar 2021 17:37:48 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A67708B79C;
        Mon, 22 Mar 2021 17:37:48 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 8A7AC675F4; Mon, 22 Mar 2021 16:37:48 +0000 (UTC)
Message-Id: <28e8d5a75e64807d7e9d39a4b52658755e259f8c.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 3/8] powerpc/bpf: Move common helpers into bpf_jit.h
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 22 Mar 2021 16:37:48 +0000 (UTC)
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
index 51b3f440288c..111451bc5cc0 100644
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

