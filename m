Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99AD2974D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbfEXLgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:36:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39354 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391133AbfEXLgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:36:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id e2so894850wrv.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hs3aOXFP5cwZuVX8rZkOSW6so6CJzEV3XFJOjgmDQIk=;
        b=JfR08xnGQN1FQyI+w6ZCR2gOvdk8JwEliYQYO8VMDhQpV7ABRVY/JToXhJBBz+QQxt
         7ncYGAdjGnrCu68PYIc4I0FE/9r3e/+yuqfKUAL+XoKIIGKkCeSons/mhqoRuqw2y2ml
         t4VyUofMIqxRqLoquA+WTrLOkYnG4sFB5WpJRfph8Wb6cer++2pREaKYcPWVne4EuBgJ
         cVdabmjrTyVULpYlrUOF6eH7LEQW1k3vnFm0H40ri2pPKKvY808ykaEpinGgMlB8SD9Z
         UMH93CruytdoyKeVAPsAvBETuyD9Uva0fS+hoJthaqBoA4FVC9mkfost8O8fO/nQQAJi
         gdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hs3aOXFP5cwZuVX8rZkOSW6so6CJzEV3XFJOjgmDQIk=;
        b=qh+TrrRWC7XhJGDNjq7vLl5kRUHtu2GaZy/7PzQ1Kn9TSLX1s5wfvA0LDvW2FX1jSl
         bKwR4IoJ3qm+jNsMYJPNi9ZHCsQe5lAp3fZ6ej4ZczrPr8Z6ftlcUcV7kulO7PPJErut
         Ucea6XZhRAD7K7hZ1TyNPfHj2+pX2ggPGbZBLJFwFTjbZp/KS6zApFBGE9VSFJBfqUf2
         YNYGX62JGv2tLUhR57i8tWNZBw2DbxEj390it0/r1l6ZSgHbOw5dMmb7Pq09xF2dGpYJ
         7/a8FVaUDu9/HPWTAzFD4c+kv4yJLqaaMFMksaq/9MA3YIeIwf7OMcpfL3+UY0XFcL9B
         llvQ==
X-Gm-Message-State: APjAAAXC2Bls3BgkOe5ANlDPBZjS6jVjEmpgVOouQU3SjpQy5+1a+MqJ
        w7izztCI6yiygtpb7SWIE30g/Q==
X-Google-Smtp-Source: APXvYqyuJB0RM/7oxZv41QUHSVZVjNtr//eGjI4EBkn1vECE39f4CsWYYI4qOQi8hvMF+TKZcipFCQ==
X-Received: by 2002:adf:d4c8:: with SMTP id w8mr5023502wrk.2.1558697762006;
        Fri, 24 May 2019 04:36:02 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.36.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:36:00 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 13/16] sparc: bpf: eliminate zero extension code-gen
Date:   Fri, 24 May 2019 12:35:23 +0100
Message-Id: <1558697726-4058-14-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/sparc/net/bpf_jit_comp_64.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 65428e7..3364e2a 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -908,6 +908,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
 		emit_alu3_K(SRL, src, 0, dst, ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_ALU64 | BPF_MOV | BPF_X:
 		emit_reg_move(src, dst, ctx);
@@ -942,6 +944,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	case BPF_ALU | BPF_DIV | BPF_X:
 		emit_write_y(G0, ctx);
 		emit_alu(DIV, src, dst, ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_ALU64 | BPF_DIV | BPF_X:
 		emit_alu(UDIVX, src, dst, ctx);
@@ -975,6 +979,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		break;
 	case BPF_ALU | BPF_RSH | BPF_X:
 		emit_alu(SRL, src, dst, ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_ALU64 | BPF_RSH | BPF_X:
 		emit_alu(SRLX, src, dst, ctx);
@@ -997,9 +1003,12 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		case 16:
 			emit_alu_K(SLL, dst, 16, ctx);
 			emit_alu_K(SRL, dst, 16, ctx);
+			if (insn_is_zext(&insn[1]))
+				return 1;
 			break;
 		case 32:
-			emit_alu_K(SRL, dst, 0, ctx);
+			if (!ctx->prog->aux->verifier_zext)
+				emit_alu_K(SRL, dst, 0, ctx);
 			break;
 		case 64:
 			/* nop */
@@ -1021,6 +1030,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 			emit_alu3_K(AND, dst, 0xff, dst, ctx);
 			emit_alu3_K(SLL, tmp, 8, tmp, ctx);
 			emit_alu(OR, tmp, dst, ctx);
+			if (insn_is_zext(&insn[1]))
+				return 1;
 			break;
 
 		case 32:
@@ -1037,6 +1048,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 			emit_alu3_K(AND, dst, 0xff, dst, ctx);	/* dst	= dst & 0xff */
 			emit_alu3_K(SLL, dst, 24, dst, ctx);	/* dst  = dst << 24 */
 			emit_alu(OR, tmp, dst, ctx);		/* dst  = dst | tmp */
+			if (insn_is_zext(&insn[1]))
+				return 1;
 			break;
 
 		case 64:
@@ -1050,6 +1063,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	/* dst = imm */
 	case BPF_ALU | BPF_MOV | BPF_K:
 		emit_loadimm32(imm, dst, ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_ALU64 | BPF_MOV | BPF_K:
 		emit_loadimm_sext(imm, dst, ctx);
@@ -1132,6 +1147,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K:
 		emit_alu_K(SRL, dst, imm, ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_ALU64 | BPF_RSH | BPF_K:
 		emit_alu_K(SRLX, dst, imm, ctx);
@@ -1144,7 +1161,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		break;
 
 	do_alu32_trunc:
-		if (BPF_CLASS(code) == BPF_ALU)
+		if (BPF_CLASS(code) == BPF_ALU &&
+		    !ctx->prog->aux->verifier_zext)
 			emit_alu_K(SRL, dst, 0, ctx);
 		break;
 
@@ -1265,6 +1283,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 			rs2 = RS2(tmp);
 		}
 		emit(opcode | RS1(src) | rs2 | RD(dst), ctx);
+		if (opcode != LD64 && insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	}
 	/* ST: *(size *)(dst + off) = imm */
@@ -1432,6 +1452,11 @@ static void jit_fill_hole(void *area, unsigned int size)
 		*ptr++ = 0x91d02005; /* ta 5 */
 }
 
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
 struct sparc64_jit_data {
 	struct bpf_binary_header *header;
 	u8 *image;
-- 
2.7.4

