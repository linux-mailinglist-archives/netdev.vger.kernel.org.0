Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA9116C2C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLILRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:17:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60364 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfLILRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zNwAfgbihveYX3iyZDtyodrTjs/LbblnpjaNpvYxvPg=; b=I7xKYWN7FPjXEFzNKAb3meLHIP
        aOSCH8Mvloi4ruOFfZg4DQHgrvcAMweNE2bonxIsf20LJc0JY516so1k/6TJK7mucTRLI083k9oX/
        xfSpDkrmNXK/Y9qRGii5Tte8/Go8SgJbIvuvQGhW1GQD7lKjOcgFgP3w0utEXEAkxPGJNW/eDtZww
        kuZz8NY/HZBRd+9vPmljKCwyUArjVdUj1Jw4PhH/8chm/jyIQ+GhlW0fdyWUJsZOhb/GinOdqOiVu
        Zn2b4xkTiMqvXrVdhQoXsWknuoxbI+VSxWvcyI+ljEkNQi5azuSZ/8hQ7q2d3nI7n67zxkV9jMIUU
        XojUyQ2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37710 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieH2h-0002ab-EY; Mon, 09 Dec 2019 11:17:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieH2g-0004ih-Rb; Mon, 09 Dec 2019 11:17:30 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Shubham Bansal <illusionist.neo@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: net: bpf: improve prologue code sequence
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieH2g-0004ih-Rb@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 11:17:30 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the prologue code sequence to be able to take advantage of
64-bit stores, changing the code from:

  push    {r4, r5, r6, r7, r8, r9, fp, lr}
  mov     fp, sp
  sub     ip, sp, #80     ; 0x50
  sub     sp, sp, #600    ; 0x258
  str     ip, [fp, #-100] ; 0xffffff9c
  mov     r6, #0
  str     r6, [fp, #-96]  ; 0xffffffa0
  mov     r4, #0
  mov     r3, r4
  mov     r2, r0
  str     r4, [fp, #-104] ; 0xffffff98
  str     r4, [fp, #-108] ; 0xffffff94

to the tighter:

  push    {r4, r5, r6, r7, r8, r9, fp, lr}
  mov     fp, sp
  mov     r3, #0
  sub     r2, sp, #80     ; 0x50
  sub     sp, sp, #600    ; 0x258
  strd    r2, [fp, #-100] ; 0xffffff9c
  mov     r2, #0
  strd    r2, [fp, #-108] ; 0xffffff94
  mov     r2, r0

resulting in a saving of three instructions.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/net/bpf_jit_32.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 97dc386e3cb8..cc29869d12a3 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1260,12 +1260,9 @@ static inline void emit_push_r64(const s8 src[], struct jit_ctx *ctx)
 
 static void build_prologue(struct jit_ctx *ctx)
 {
-	const s8 r0 = bpf2a32[BPF_REG_0][1];
-	const s8 r2 = bpf2a32[BPF_REG_1][1];
-	const s8 r3 = bpf2a32[BPF_REG_1][0];
-	const s8 r4 = bpf2a32[BPF_REG_6][1];
-	const s8 fplo = bpf2a32[BPF_REG_FP][1];
-	const s8 fphi = bpf2a32[BPF_REG_FP][0];
+	const s8 arm_r0 = bpf2a32[BPF_REG_0][1];
+	const s8 *bpf_r1 = bpf2a32[BPF_REG_1];
+	const s8 *bpf_fp = bpf2a32[BPF_REG_FP];
 	const s8 *tcc = bpf2a32[TCALL_CNT];
 
 	/* Save callee saved registers. */
@@ -1278,8 +1275,10 @@ static void build_prologue(struct jit_ctx *ctx)
 	emit(ARM_PUSH(CALLEE_PUSH_MASK), ctx);
 	emit(ARM_MOV_R(ARM_FP, ARM_SP), ctx);
 #endif
-	/* Save frame pointer for later */
-	emit(ARM_SUB_I(ARM_IP, ARM_SP, SCRATCH_SIZE), ctx);
+	/* mov r3, #0 */
+	/* sub r2, sp, #SCRATCH_SIZE */
+	emit(ARM_MOV_I(bpf_r1[0], 0), ctx);
+	emit(ARM_SUB_I(bpf_r1[1], ARM_SP, SCRATCH_SIZE), ctx);
 
 	ctx->stack_size = imm8m(STACK_SIZE);
 
@@ -1287,18 +1286,15 @@ static void build_prologue(struct jit_ctx *ctx)
 	emit(ARM_SUB_I(ARM_SP, ARM_SP, ctx->stack_size), ctx);
 
 	/* Set up BPF prog stack base register */
-	emit_a32_mov_r(fplo, ARM_IP, ctx);
-	emit_a32_mov_i(fphi, 0, ctx);
+	emit_a32_mov_r64(true, bpf_fp, bpf_r1, ctx);
 
-	/* mov r4, 0 */
-	emit(ARM_MOV_I(r4, 0), ctx);
+	/* Initialize Tail Count */
+	emit(ARM_MOV_I(bpf_r1[1], 0), ctx);
+	emit_a32_mov_r64(true, tcc, bpf_r1, ctx);
 
 	/* Move BPF_CTX to BPF_R1 */
-	emit(ARM_MOV_R(r3, r4), ctx);
-	emit(ARM_MOV_R(r2, r0), ctx);
-	/* Initialize Tail Count */
-	emit(ARM_STR_I(r4, ARM_FP, EBPF_SCRATCH_TO_ARM_FP(tcc[0])), ctx);
-	emit(ARM_STR_I(r4, ARM_FP, EBPF_SCRATCH_TO_ARM_FP(tcc[1])), ctx);
+	emit(ARM_MOV_R(bpf_r1[1], arm_r0), ctx);
+
 	/* end of prologue */
 }
 
-- 
2.20.1

