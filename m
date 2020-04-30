Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F31BFA22
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgD3Nvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgD3Nvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32F424955;
        Thu, 30 Apr 2020 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254705;
        bh=f468jlNFiX3YwGHl5K6KTJqr77ApgBi8NgVXofCvmGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2hX2oFJ4ygCibk4w66ga2DcMsD6qY1Zgm89vyp2pvvSG22yxCrR2V8IV0di72siK
         V6KfhHWamLS/BX/t1uydZ2Wi6fE+IN/tjstJj3kXKq+U1jjktZF3+PqSVl5Q5Px7+P
         2LW4Hvwjfj9Q5tIs2EZpiciyurpDM8amrETxVPbc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 54/79] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
Date:   Thu, 30 Apr 2020 09:50:18 -0400
Message-Id: <20200430135043.19851-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

[ Upstream commit aee194b14dd2b2bde6252b3acf57d36dccfc743a ]

This patch fixes an encoding bug in emit_stx for BPF_B when the source
register is BPF_REG_FP.

The current implementation for BPF_STX BPF_B in emit_stx saves one REX
byte when the operands can be encoded using Mod-R/M alone. The lower 8
bits of registers %rax, %rbx, %rcx, and %rdx can be accessed without using
a REX prefix via %al, %bl, %cl, and %dl, respectively. Other registers,
(e.g., %rsi, %rdi, %rbp, %rsp) require a REX prefix to use their 8-bit
equivalents (%sil, %dil, %bpl, %spl).

The current code checks if the source for BPF_STX BPF_B is BPF_REG_1
or BPF_REG_2 (which map to %rdi and %rsi), in which case it emits the
required REX prefix. However, it misses the case when the source is
BPF_REG_FP (mapped to %rbp).

The result is that BPF_STX BPF_B with BPF_REG_FP as the source operand
will read from register %ch instead of the correct %bpl. This patch fixes
the problem by fixing and refactoring the check on which registers need
the extra REX byte. Since no BPF registers map to %rsp, there is no need
to handle %spl.

Fixes: 622582786c9e0 ("net: filter: x86: internal BPF JIT")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200418232655.23870-1-luke.r.nels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9ba08e9abc094..6aa53c33b4712 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -158,6 +158,19 @@ static bool is_ereg(u32 reg)
 			     BIT(BPF_REG_AX));
 }
 
+/*
+ * is_ereg_8l() == true if BPF register 'reg' is mapped to access x86-64
+ * lower 8-bit registers dil,sil,bpl,spl,r8b..r15b, which need extra byte
+ * of encoding. al,cl,dl,bl have simpler encoding.
+ */
+static bool is_ereg_8l(u32 reg)
+{
+	return is_ereg(reg) ||
+	    (1 << reg) & (BIT(BPF_REG_1) |
+			  BIT(BPF_REG_2) |
+			  BIT(BPF_REG_FP));
+}
+
 static bool is_axreg(u32 reg)
 {
 	return reg == BPF_REG_0;
@@ -598,9 +611,8 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 	switch (size) {
 	case BPF_B:
 		/* Emit 'mov byte ptr [rax + off], al' */
-		if (is_ereg(dst_reg) || is_ereg(src_reg) ||
-		    /* We have to add extra byte for x86 SIL, DIL regs */
-		    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
+		if (is_ereg(dst_reg) || is_ereg_8l(src_reg))
+			/* Add extra byte for eregs or SIL,DIL,BPL in src_reg */
 			EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
 		else
 			EMIT1(0x88);
-- 
2.20.1

