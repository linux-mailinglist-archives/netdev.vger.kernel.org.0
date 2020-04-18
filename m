Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73741AF5DB
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDRX1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 19:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgDRX1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 19:27:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A75C061A0F
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 16:27:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h11so2488280plr.11
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 16:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=V1iSNi3FjSbFymrjsWR16L5sHfocV0iKd0ObfqLdCDE=;
        b=E94FC9JeOPlEtesZY7pnic5oqXC1UEm6VlEGtC1YgAScMnSkB2LJY+O5H4diMpuWHL
         d/no2M6eNI/dQY9j/v6SSyhcGs+aK1ScSuDvksCyuVmfHcNTBZoPi8j55p0j3j3YBUoZ
         Dp5qeYnqs74jXMUqZHwc0BsGZWmWM+mqnvNTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V1iSNi3FjSbFymrjsWR16L5sHfocV0iKd0ObfqLdCDE=;
        b=lQuE/4BoiWVxohDDmwk1omfv829CLQ5dTRA1Mluh13LUZSVNuPTAdxQRwDbIy7n2+T
         NFEGTCPrPDHYrxAxgDTqBP5/v7W0NuF2EDllB+i4LkAeT8MvpO5VElCSFln4mTOWBzcs
         ErKJugpkc2lsvDpr/xMQWrSKcFGHdBjGPB+fttXzV/CugV8z1/EAfBzpnKlFhMrmcNa3
         gSQuiy8o0IIRt9Ud8pOocqEDwHGuzIsFvkvyDz4jUtc0xxIUWyJcW0xlzA0192KI25T+
         fPvOttCs3f340EDrY7hKEjPnL/wm7utIOPcO5+plUR1nDyWJ+fdry4C1A+1oyoN/cc3m
         rmhQ==
X-Gm-Message-State: AGi0PuZMUtdXyLASSZxzIiTfm5QoI22uQsBQZkxdx+ieIXo6pnCki9db
        pSLMSbWYcxDL2tgDL0GKZJqYsg==
X-Google-Smtp-Source: APiQypJUg540AgQ0gfERSdqKG3/UO/88BFVywKnBq0ADggzskh4vKGlmvKwDR8ejYqwi3brMfHgq9Q==
X-Received: by 2002:a17:902:a511:: with SMTP id s17mr10176108plq.33.1587252420747;
        Sat, 18 Apr 2020 16:27:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id u7sm21429323pfu.90.2020.04.18.16.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 16:27:00 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
Date:   Sat, 18 Apr 2020 16:26:53 -0700
Message-Id: <20200418232655.23870-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 arch/x86/net/bpf_jit_comp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 5ea7c2cf7ab4..42b6709e6dc7 100644
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
2.17.1

