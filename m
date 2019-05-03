Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A32A12BBB
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfECKoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52371 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbfECKoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:44:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id y26so1393400wma.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vUBe6gkkzQclPz2wvAflZLkcO050U9NleScwAGboJ7w=;
        b=RYxVDuDjtPjfquIluZSOUQoZIhXJAUBa0yFcpEZx2wXadtaW3NGQJgUwuzGWcATRYo
         88D70iN8vn/y3pXSFYb4lBoupeLC6AgojmRvcrQ4Sb66ngeBrnDlhMwgcBQfciWaegMg
         S7pZJtQ0afzIiCGYnv9mZzxL49MJcRUNY+yEb4Gyot/dcp24X1/rXaKPHsxOTbWLtBo9
         d5npPYp3ZWknxf8uOogcJwI/PEmcV+4IEmHqZtPvEHX3dXnBJ8/3fnLls4GFYUFWDgZ7
         1xixMvcEiRRiUzh5Zh+kRgyBPYCwxo8M6zcq5a9lL7EWNBvDanqQjeDgeWLkjFYt0R5F
         G24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vUBe6gkkzQclPz2wvAflZLkcO050U9NleScwAGboJ7w=;
        b=U//GSQuFlgVdJeZu7cph07iyKnDxgWatB08GSb2yh5/8o1OaUhJExHFB7pFLU4WWh6
         XQlaSu1hSmIt+SeL1aXI6/reN38/TWba12RUsCw7276XXUOWrKpyBJUK//rI1m/wnSOZ
         rknK7amAhyR+rPhnPpuQw9hK8aaWb/q+bxSjRGS3eR0iiTZN1LRLy/sNvE1v6G1qFwok
         7f7vvHCYyq2jFSL4DBrz01Kr+a3MJbJPLJILmFLXif4nfJ4XZHTRXCZ0tEw6hP1AO3dR
         SMpilWS4LC5Ga1aMkQNv2+i5ZI82PLdBVZH9Aey+aY5l2z01hQrO3TBcwZBk7t3GZmp7
         pdhw==
X-Gm-Message-State: APjAAAXTrSpH4ofAjLkSlhX71fi2PO7X6RgdrcwZP+/EoJVNxRONloSL
        3xDV6TbzjVaDzJO2VmDFJ5OrOzenaLk=
X-Google-Smtp-Source: APXvYqw7umtMkMtTfAqpBUISzCEhsJZd1aSA2TMkE8iGCQZFKV12Sg+9TUO/vMkLizW7I2CmGm/wxw==
X-Received: by 2002:a1c:1a50:: with SMTP id a77mr5635530wma.113.1556880239238;
        Fri, 03 May 2019 03:43:59 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:58 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH v6 bpf-next 15/17] x32: bpf: eliminate zero extension code-gen
Date:   Fri,  3 May 2019 11:42:42 +0100
Message-Id: <1556880164-10689-16-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/x86/net/bpf_jit_comp32.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 0d9cdff..16c4f4e 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -567,7 +567,7 @@ static inline void emit_ia32_alu_r(const bool is64, const bool hi, const u8 op,
 static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 				     const u8 dst[], const u8 src[],
 				     bool dstk,  bool sstk,
-				     u8 **pprog)
+				     u8 **pprog, const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 
@@ -575,7 +575,7 @@ static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 	if (is64)
 		emit_ia32_alu_r(is64, true, op, dst_hi, src_hi, dstk, sstk,
 				&prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 	*pprog = prog;
 }
@@ -666,7 +666,8 @@ static inline void emit_ia32_alu_i(const bool is64, const bool hi, const u8 op,
 /* ALU operation (64 bit) */
 static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 				     const u8 dst[], const u32 val,
-				     bool dstk, u8 **pprog)
+				     bool dstk, u8 **pprog,
+				     const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 	u32 hi = 0;
@@ -677,7 +678,7 @@ static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 	emit_ia32_alu_i(is64, false, op, dst_lo, val, dstk, &prog);
 	if (is64)
 		emit_ia32_alu_i(is64, true, op, dst_hi, hi, dstk, &prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 
 	*pprog = prog;
@@ -1642,6 +1643,10 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 		switch (code) {
 		/* ALU operations */
+		/* dst = (u32) dst */
+		case BPF_ALU | BPF_ZEXT:
+			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			break;
 		/* dst = src */
 		case BPF_ALU | BPF_MOV | BPF_K:
 		case BPF_ALU | BPF_MOV | BPF_X:
@@ -1690,11 +1695,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			switch (BPF_SRC(code)) {
 			case BPF_X:
 				emit_ia32_alu_r64(is64, BPF_OP(code), dst,
-						  src, dstk, sstk, &prog);
+						  src, dstk, sstk, &prog,
+						  bpf_prog->aux);
 				break;
 			case BPF_K:
 				emit_ia32_alu_i64(is64, BPF_OP(code), dst,
-						  imm32, dstk, &prog);
+						  imm32, dstk, &prog,
+						  bpf_prog->aux);
 				break;
 			}
 			break;
@@ -1713,7 +1720,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						false, &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU | BPF_LSH | BPF_X:
 		case BPF_ALU | BPF_RSH | BPF_X:
@@ -1733,7 +1741,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						  &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst / src(imm) */
 		/* dst = dst % src(imm) */
@@ -1755,7 +1764,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						    &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU64 | BPF_DIV | BPF_K:
 		case BPF_ALU64 | BPF_DIV | BPF_X:
@@ -1772,7 +1782,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_ECX), imm32);
 			emit_ia32_shift_r(BPF_OP(code), dst_lo, IA32_ECX, dstk,
 					  false, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst << imm */
 		case BPF_ALU64 | BPF_LSH | BPF_K:
@@ -1808,7 +1819,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU | BPF_NEG:
 			emit_ia32_alu_i(is64, false, BPF_OP(code),
 					dst_lo, 0, dstk, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = ~dst (64 bit) */
 		case BPF_ALU64 | BPF_NEG:
@@ -2367,6 +2379,11 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	return proglen;
 }
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header = NULL;
-- 
2.7.4

