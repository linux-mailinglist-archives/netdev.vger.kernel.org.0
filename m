Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0FD5A937
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfF2F6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:58:22 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38506 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfF2F6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:58:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so3645322ple.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KrEprMkFXe/No24Hn/x/PXNIoQCM6XIqjLi+nLjSkxE=;
        b=Wmgc+Q9dqbyfL0OyJL4d7h18KSWO5/t6Mi9bQlZ07E4Y7IQ9QzfLJSTYNBpodUyPqN
         HGWv5fxSlXLnd/FfGgDYZ4Ni5GTRjLlh1Iumi6zxdiTGbZhZBIq6Cnm/2stAHtgFltdm
         3hDOFM+Y9IFHF51Tvb3h1dkpMqG0cy+hBZWCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KrEprMkFXe/No24Hn/x/PXNIoQCM6XIqjLi+nLjSkxE=;
        b=iB+u1htsa47o3QbHFA5BXnI4IrqaKDqtMq0u2AzKYSu7Or90XPO3giAHyBcseML2Ca
         8QloyuT6k2gn15US8nLZseTSuK/ISiYm8FZa+yHuwyQwROVAMKkgz/EDELw6HidQc0MB
         2jp8zfdEQ23HieRAr2Tu/LBgXVVkrh9UdM7Y1/T0SYX7BLX7Cocmhy0kQ/o4YVQu2TTR
         0JstA6xk3bBQ2Hfx73HJam6HWH+81SL4pw2wAPUO7dHkxh8bM5iMD1uAf8OvBjuYqGsa
         Yf6/FYJZew1Fd1CVsp7KNdJWFpMN8nBntvsM+vrOYyMASQm9vxcZPM3Q9294jgkqXr9z
         qvFQ==
X-Gm-Message-State: APjAAAUkKsuhmdQDp+iJKEjfUq7QHHQ4jkEWshL17A/hhuwU73+4WT7E
        LLcN/3pi5fph17fI/csJqKKEGA==
X-Google-Smtp-Source: APXvYqzT6SU+vzGzeK1vMy1Q7YkD+QgvpjhtOfOe9fUDqkUROyHTX+TT5bjr8ZxKuYlw9TeUYytsug==
X-Received: by 2002:a17:902:44a4:: with SMTP id l33mr15864557pld.174.1561787901307;
        Fri, 28 Jun 2019 22:58:21 -0700 (PDT)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:717c:64f7:ecd0:38c2])
        by smtp.gmail.com with ESMTPSA id r3sm3272243pgp.51.2019.06.28.22.58.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 22:58:20 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/3] bpf, x32: Fix bug with ALU64 {LSH,RSH,ARSH} BPF_X shift by 0
Date:   Fri, 28 Jun 2019 22:57:49 -0700
Message-Id: <20190629055759.28365-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current x32 BPF JIT for shift operations is not correct when the
shift amount in a register is 0. The expected behavior is a no-op, whereas
the current implementation changes bits in the destination register.

The following example demonstrates the bug. The expected result of this
program is 1, but the current JITed code returns 2.

  r0 = 1
  r1 = 1
  r2 = 0
  r1 <<= r2
  if r1 == 1 goto end
  r0 = 2
end:
  exit

The bug is caused by an incorrect assumption by the JIT that a shift by
32 clear the register. On x32 however, shifts use the lower 5 bits of
the source, making a shift by 32 equivalent to a shift by 0.

This patch fixes the bug using double-precision shifts, which also
simplifies the code.

Fixes: 03f5781be2c7 ("bpf, x86_32: add eBPF JIT compiler for ia32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 221 ++++------------------------------
 1 file changed, 23 insertions(+), 198 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index b29e82f190c7..f34ef513f4f9 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -724,9 +724,6 @@ static inline void emit_ia32_lsh_r64(const u8 dst[], const u8 src[],
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -745,79 +742,23 @@ static inline void emit_ia32_lsh_r64(const u8 dst[], const u8 src[],
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* shl dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xE0, dreg_hi));
-	/* mov ebx,dreg_lo */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_lo, IA32_EBX));
+	/* shld dreg_hi,dreg_lo,cl */
+	EMIT3(0x0F, 0xA5, add_2reg(0xC0, dreg_hi, dreg_lo));
 	/* shl dreg_lo,cl */
 	EMIT2(0xD3, add_1reg(0xE0, dreg_lo));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shr ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE8, IA32_EBX));
-	/* or dreg_hi,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_hi, IA32_EBX));
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
+	/* if ecx >= 32, mov dreg_lo into dreg_hi and clear dreg_lo */
 
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (4 bytes) when < 32 */
+	EMIT2(IA32_JB, 4);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* shl dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE0, dreg_lo));
 	/* mov dreg_hi,dreg_lo */
 	EMIT2(0x89, add_2reg(0xC0, dreg_hi, dreg_lo));
-
 	/* xor dreg_lo,dreg_lo */
 	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* xor dreg_lo,dreg_lo */
-	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
-	/* xor dreg_hi,dreg_hi */
-	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
-
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
 		EMIT3(0x89, add_2reg(0x40, IA32_EBP, dreg_lo),
@@ -836,9 +777,6 @@ static inline void emit_ia32_arsh_r64(const u8 dst[], const u8 src[],
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -857,78 +795,22 @@ static inline void emit_ia32_arsh_r64(const u8 dst[], const u8 src[],
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* lshr dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_lo));
-	/* mov ebx,dreg_hi */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
-	/* ashr dreg_hi,cl */
+	/* shrd dreg_lo,dreg_hi,cl */
+	EMIT3(0x0F, 0xAD, add_2reg(0xC0, dreg_lo, dreg_hi));
+	/* sar dreg_hi,cl */
 	EMIT2(0xD3, add_1reg(0xF8, dreg_hi));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shl ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-	/* or dreg_lo,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
+	/* if ecx >= 32, mov dreg_hi to dreg_lo and set/clear dreg_hi depending on sign */
 
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (5 bytes) when < 32 */
+	EMIT2(IA32_JB, 5);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* ashr dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xF8, dreg_hi));
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
-
-	/* ashr dreg_hi,imm8 */
-	EMIT3(0xC1, add_1reg(0xF8, dreg_hi), 31);
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* ashr dreg_hi,imm8 */
+	/* sar dreg_hi,31 */
 	EMIT3(0xC1, add_1reg(0xF8, dreg_hi), 31);
-	/* mov dreg_lo,dreg_hi */
-	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
 
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
@@ -948,9 +830,6 @@ static inline void emit_ia32_rsh_r64(const u8 dst[], const u8 src[], bool dstk,
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -969,77 +848,23 @@ static inline void emit_ia32_rsh_r64(const u8 dst[], const u8 src[], bool dstk,
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* lshr dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_lo));
-	/* mov ebx,dreg_hi */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+	/* shrd dreg_lo,dreg_hi,cl */
+	EMIT3(0x0F, 0xAD, add_2reg(0xC0, dreg_lo, dreg_hi));
 	/* shr dreg_hi,cl */
 	EMIT2(0xD3, add_1reg(0xE8, dreg_hi));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shl ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-	/* or dreg_lo,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
+	/* if ecx >= 32, mov dreg_hi to dreg_lo and clear dreg_hi */
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (4 bytes) when < 32 */
+	EMIT2(IA32_JB, 4);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* shr dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_hi));
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
 	/* xor dreg_hi,dreg_hi */
 	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* xor dreg_lo,dreg_lo */
-	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
-	/* xor dreg_hi,dreg_hi */
-	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
-
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
 		EMIT3(0x89, add_2reg(0x40, IA32_EBP, dreg_lo),
-- 
2.20.1

