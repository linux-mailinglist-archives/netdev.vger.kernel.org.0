Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99096578C1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfF0Ay6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfF0Aa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:58 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD310217D8;
        Thu, 27 Jun 2019 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595457;
        bh=twBwnosR6QbQtSbolAgpDnfbS9aPjP6N+mM0O1dqyMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR2axxBCCwWOhn/ZNsqegTxVCy83jwPU34pV36pDKs+OvoyF/jaFtwZtXsxT1o8nJ
         h1XvuE29+2Riaqv1vsvuRnx7fCC+9fbnAD/juVo5qHJ5GOrng7Cr2xBvSwkhkW00m3
         tY3CZ1GR7FgiTh1iHDtzpx16WsHOhMvMt5IR2F90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 11/95] bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32
Date:   Wed, 26 Jun 2019 20:28:56 -0400
Message-Id: <20190627003021.19867-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>

[ Upstream commit fe121ee531d1362810bfd30f38a1b88b1d3d376c ]

When using 32-bit subregisters (ALU32), the RISC-V JIT would not clear
the high 32-bits of the target register and therefore generate
incorrect code.

E.g., in the following code:

  $ cat test.c
  unsigned int f(unsigned long long a,
  	       unsigned int b)
  {
  	return (unsigned int)a & b;
  }

  $ clang-9 -target bpf -O2 -emit-llvm -S test.c -o - | \
  	llc-9 -mattr=+alu32 -mcpu=v3
  	.text
  	.file	"test.c"
  	.globl	f
  	.p2align	3
  	.type	f,@function
  f:
  	r0 = r1
  	w0 &= w2
  	exit
  .Lfunc_end0:
  	.size	f, .Lfunc_end0-f

The JIT would not clear the high 32-bits of r0 after the
and-operation, which in this case might give an incorrect return
value.

After this patch, that is not the case, and the upper 32-bits are
cleared.

Reported-by: Jiong Wang <jiong.wang@netronome.com>
Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 80b12aa5e10d..e5c8d675bd6e 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -759,14 +759,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_AND | BPF_X:
 	case BPF_ALU64 | BPF_AND | BPF_X:
 		emit(rv_and(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_X:
 	case BPF_ALU64 | BPF_OR | BPF_X:
 		emit(rv_or(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_X:
 	case BPF_ALU64 | BPF_XOR | BPF_X:
 		emit(rv_xor(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_X:
 	case BPF_ALU64 | BPF_MUL | BPF_X:
-- 
2.20.1

