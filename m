Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8BA116C2E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLILRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:17:53 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60368 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfLILRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XjkK675LJFtaYhlzPVMRnNNjW81WA4APzKu+SB9Uw0M=; b=Imq/0MAl+4ic9wupAscxqljrs5
        QR1m4SntqP1yoy4jMwiWkUD2uIPFBtm+S8XUUiBn3dqH4khEqlC1ATYMe6Rxr3Ux0aPNziSgahxBp
        hP3MDmZp3FX5/hT4hLlnITR8TsImBOrxIeFERrQssdKmLXGNFTCgCzbeGW8eIZxYJrFnBltzxH9kW
        6FDCXb6iBkQpCXxfiNcCAN1bpIU/IciG/k3lqQk2QuDAUgQcXy323gJLnoX1mr/F8soBreh4PSUbT
        AuEquqXEUzpAwU5uTO5meQpP7fRRaNIsdBlOxn97uOguoB0lXr/FAGLwO5aRrKaNFHTmRGCWBTFhP
        0kjUO8sg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:49900 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieH2m-0002aj-Uk; Mon, 09 Dec 2019 11:17:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieH2l-0004io-VM; Mon, 09 Dec 2019 11:17:36 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Shubham Bansal <illusionist.neo@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: net: bpf: improve endian conversion
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieH2l-0004io-VM@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 11:17:35 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the endian conversion function easier to read by moving it out
of the big switch, and avoid doing anything if we're requested to
convert from a 64-bit LE value (we're LE anyway here.)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/net/bpf_jit_32.c | 91 +++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 41 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index cc29869d12a3..646ab5785ca4 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1245,6 +1245,55 @@ static inline void emit_rev32(const u8 rd, const u8 rn, struct jit_ctx *ctx)
 #endif
 }
 
+static void emit_a32_endian(const s8 dst[], u8 code, s32 bits,
+			    struct jit_ctx *ctx)
+{
+	const s8 *tmp = bpf2a32[TMP_REG_1];
+	const s8 *tmp2 = bpf2a32[TMP_REG_2];
+	const s8 *rd;
+
+	/* Converting from LE and 64-bit value is a no-op. */
+	if (code == BPF_FROM_LE && bits == 64)
+		return;
+
+	rd = arm_bpf_get_reg64(dst, tmp, ctx);
+
+	if (code != BPF_FROM_LE) {
+		/* endian swap */
+		switch (imm) {
+		case 16:
+			emit_rev16(rd[1], rd[1], ctx);
+			break;
+		case 32:
+			emit_rev32(rd[1], rd[1], ctx);
+			break;
+		case 64:
+			emit_rev32(ARM_LR, rd[1], ctx);
+			emit_rev32(rd[1], rd[0], ctx);
+			emit(ARM_MOV_R(rd[0], ARM_LR), ctx);
+			break;
+		}
+	}
+
+	/* zero-extend size to 64-bit */
+	switch (imm) {
+	case 16:
+#if __LINUX_ARM_ARCH__ < 6
+		emit_a32_mov_i(tmp2[1], 0xffff, ctx);
+		emit(ARM_AND_R(rd[1], rd[1], tmp2[1]), ctx);
+#else /* ARMv6+ */
+		emit(ARM_UXTH(rd[1], rd[1]), ctx);
+#endif
+		/* FALLTHROUGH */
+	case 32:
+		if (!ctx->prog->aux->verifier_zext)
+			emit(ARM_MOV_I(rd[0], 0), ctx);
+		break;
+	}
+
+	arm_bpf_put_reg64(dst, rd, ctx);
+}
+
 // push the scratch stack register on top of the stack
 static inline void emit_push_r64(const s8 src[], struct jit_ctx *ctx)
 {
@@ -1523,47 +1572,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	/* dst = htobe(dst) */
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
 	case BPF_ALU | BPF_END | BPF_FROM_BE:
-		rd = arm_bpf_get_reg64(dst, tmp, ctx);
-		if (BPF_SRC(code) == BPF_FROM_LE)
-			goto emit_bswap_uxt;
-		switch (imm) {
-		case 16:
-			emit_rev16(rd[1], rd[1], ctx);
-			goto emit_bswap_uxt;
-		case 32:
-			emit_rev32(rd[1], rd[1], ctx);
-			goto emit_bswap_uxt;
-		case 64:
-			emit_rev32(ARM_LR, rd[1], ctx);
-			emit_rev32(rd[1], rd[0], ctx);
-			emit(ARM_MOV_R(rd[0], ARM_LR), ctx);
-			break;
-		}
-		goto exit;
-emit_bswap_uxt:
-		switch (imm) {
-		case 16:
-			/* zero-extend 16 bits into 64 bits */
-#if __LINUX_ARM_ARCH__ < 6
-			emit_a32_mov_i(tmp2[1], 0xffff, ctx);
-			emit(ARM_AND_R(rd[1], rd[1], tmp2[1]), ctx);
-#else /* ARMv6+ */
-			emit(ARM_UXTH(rd[1], rd[1]), ctx);
-#endif
-			if (!ctx->prog->aux->verifier_zext)
-				emit(ARM_EOR_R(rd[0], rd[0], rd[0]), ctx);
-			break;
-		case 32:
-			/* zero-extend 32 bits into 64 bits */
-			if (!ctx->prog->aux->verifier_zext)
-				emit(ARM_EOR_R(rd[0], rd[0], rd[0]), ctx);
-			break;
-		case 64:
-			/* nop */
-			break;
-		}
-exit:
-		arm_bpf_put_reg64(dst, rd, ctx);
+		emit_a32_endian(dst, BPF_SRC(code), imm, ctx);
 		break;
 	/* dst = imm64 */
 	case BPF_LD | BPF_IMM | BPF_DW:
-- 
2.20.1

