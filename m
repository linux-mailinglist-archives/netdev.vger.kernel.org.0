Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00FD12B663
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfL0RmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbfL0RmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 836E624656;
        Fri, 27 Dec 2019 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468542;
        bh=sA28e4/Vn28o0eBK2OtFILC07rU4A36VwG070Roqi1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiKHpEc6CjWZYqHnTSwrNT6baXTcn23/DRReuzfA9XS8TZUMxmDmnBH5smo1ha96M
         ehPvzrdCkn1N0u2vCUI6ia6pA8vZCNYLNODmvK+ehrpI7xlOCdF3zGXDsaubdsgEdu
         d+76EAmFFcvYvSbQs3m1aOdCaEKFlLWSLbIiE72Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Chaignon <paul.chaignon@orange.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 071/187] bpf, riscv: Limit to 33 tail calls
Date:   Fri, 27 Dec 2019 12:38:59 -0500
Message-Id: <20191227174055.4923-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Chaignon <paul.chaignon@orange.com>

[ Upstream commit 96bc4432f5ade1045521f3b247f516b1478166bd ]

All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
limit at runtime.  In addition, a test was recently added, in tailcalls2,
to check this limit.

This patch updates the tail call limit in RISC-V's JIT compiler to allow
33 tail calls.  I tested it using the above selftest on an emulated
RISCV64.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 5451ef3845f2..7fbf56aab661 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -631,14 +631,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 		return -1;
 	emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
 
-	/* if (--TCC < 0)
+	/* if (TCC-- < 0)
 	 *     goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
 	if (is_13b_check(off, insn))
 		return -1;
-	emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
+	emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
-- 
2.20.1

