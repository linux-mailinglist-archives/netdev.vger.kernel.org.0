Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A284330296
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfE3TIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:08:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42481 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfE3TIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:08:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id r22so4538698pfh.9;
        Thu, 30 May 2019 12:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7H9dDYfkG5aoCexFiQp3mrYF6mxJsKXlL4736u8wxiY=;
        b=fZcXJqowIrB3tNk9j2Vs6zQMB9vhzOEhXiXoNOT3C2SZUI/keXl5CUnUzXEOmdSdM5
         w0m8w4++FRlx5nmKHK+bxr5j4dQ1EyWaji8MJy8dKDfUl8eRWdKqTHJF+z3qw0Uuwa7y
         +NbvRl8AteuHJDxgBDqv0Zf6NPBNpNTkiZsLXP2k5JvcBuAIEhXrVRuBbQ/F0RyvCI8m
         l6VmoKO/75H1hmPw7JgQ1D/eaTBD+HQrL1veyMvOgi0dNM70EPDRwjlxZtK/chMvzYvR
         b0E0jLCRFaga/bnV3BCHwDCKF5M+XHO7AhVYOpH+/n7qiSgMMKXYKhDESgGA5iDqp8H2
         goNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7H9dDYfkG5aoCexFiQp3mrYF6mxJsKXlL4736u8wxiY=;
        b=WFg2/ovv7iz0o5uVAHuxSEaPDn/mZ+GG8VkBYhuOKuf+2CEYGBPe3TJZSRFhAuanna
         84KJANMd7DCc6Gurn1Dj0xjFZdH0vdFzcxi71mCmEMdvYSjP5SodpdhAYKB1BTKioA1w
         jBVSe1opfHJUQMZYOj/fKlYigGrq6fXPwK4AV7NYiSj1Ruml1osCsC/6kiDNAwx3mGoA
         wS48Pgsfu1xePMLIvcsXnaxVI2Kedjl0NYWOH0QcYXLI3WHIara8736slKT4s+GMu4fo
         k6PNV0Xtpmr4rQ3v7Fi2BX8pGq1UjgfbcynGPkBfUjRqU2OqBqsuw91308kQRLiJdY51
         /SyQ==
X-Gm-Message-State: APjAAAW0gcUpEBeSFnuCfmosJ8HVexncGZjGzY2l81CAxCQEedHr+ANb
        tv72u/O2wY0uM+B2IqUE5kQxNqyF/X8=
X-Google-Smtp-Source: APXvYqzw9JIF9TxBbFnD1DrZeGTUNq7drJnRoJjCnUUex5bRISoa/9IXRlVtRwwyYFDC9m7+TUscDg==
X-Received: by 2002:a62:e718:: with SMTP id s24mr5189745pfh.247.1559243300157;
        Thu, 30 May 2019 12:08:20 -0700 (PDT)
Received: from kaby.cs.washington.edu ([2607:4000:200:15:61cb:56f1:2c08:844e])
        by smtp.gmail.com with ESMTPSA id a8sm3927617pfk.14.2019.05.30.12.08.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 12:08:17 -0700 (PDT)
From:   Luke Nelson <luke.r.nels@gmail.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bpf: test_bpf: add tests for upper bits of 32-bit operations
Date:   Thu, 30 May 2019 12:08:00 -0700
Message-Id: <20190530190800.7633-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190530190800.7633-1-luke.r.nels@gmail.com>
References: <20190530190800.7633-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces tests that validate the upper 32 bits
of the result of 32-bit BPF ALU operations.

The existing tests for 32-bit operations do not check the upper 32
bits of results because the exit instruction truncates the result.
These tests perform a 32-bit ALU operation followed by a right shift.
These tests can catch subtle bugs in the extension behavior of JITed
instructions, including several bugs in the RISC-V BPF JIT, fixed in
another patch.

The added tests pass the JIT and interpreter on x86, as well as the
JIT and interpreter of RISC-V once the zero extension bugs were fixed.

Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 lib/test_bpf.c | 164 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 0845f635f404..4580dc0220f1 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -2461,6 +2461,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{
+		"ALU_ADD_X: (1 + 4294967294) >> 32 + 4294967294 = 4294967294",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 1U),
+			BPF_ALU32_IMM(BPF_MOV, R1, 4294967294U),
+			BPF_ALU32_REG(BPF_ADD, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_REG(BPF_ADD, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 4294967294U } },
+	},
 	{
 		"ALU64_ADD_X: 1 + 2 = 3",
 		.u.insns_int = {
@@ -2812,6 +2826,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{
+		"ALU_SUB_X: (4294967295 - 1) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 4294967295U),
+			BPF_ALU32_IMM(BPF_MOV, R1, 1U),
+			BPF_ALU32_REG(BPF_SUB, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_REG(BPF_ADD, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_SUB_X: 3 - 1 = 2",
 		.u.insns_int = {
@@ -3391,6 +3419,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffffffff } },
 	},
+	{
+		"ALU_AND_X: (-1 & -1) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, -1UL),
+			BPF_LD_IMM64(R1, -1UL),
+			BPF_ALU32_REG(BPF_AND, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1U),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_AND_X: 3 & 2 = 2",
 		.u.insns_int = {
@@ -3533,6 +3575,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffffffff } },
 	},
+	{
+		"ALU_OR_X: (0 & -1) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0),
+			BPF_LD_IMM64(R1, -1UL),
+			BPF_ALU32_REG(BPF_OR, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1U),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_OR_X: 1 | 2 = 3",
 		.u.insns_int = {
@@ -3675,6 +3731,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xfffffffe } },
 	},
+	{
+		"ALU_XOR_X: (0 ^ -1) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0),
+			BPF_LD_IMM64(R1, -1UL),
+			BPF_ALU32_REG(BPF_XOR, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1U),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_XOR_X: 5 ^ 6 = 3",
 		.u.insns_int = {
@@ -3817,6 +3887,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0x80000000 } },
 	},
+	{
+		"ALU_LSH_X: (1 << 31) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 1),
+			BPF_ALU32_IMM(BPF_MOV, R1, 31),
+			BPF_ALU32_REG(BPF_LSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_LSH_X: 1 << 1 = 2",
 		.u.insns_int = {
@@ -3842,6 +3926,19 @@ static struct bpf_test tests[] = {
 		{ { 0, 0x80000000 } },
 	},
 	/* BPF_ALU | BPF_LSH | BPF_K */
+	{
+		"ALU_LSH_K: (1 << 31) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 1),
+			BPF_ALU32_IMM(BPF_LSH, R0, 31),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU_LSH_K: 1 << 1 = 2",
 		.u.insns_int = {
@@ -3911,6 +4008,20 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{
+		"ALU_RSH_X: (0x80000000 >> 0) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x80000000),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU32_REG(BPF_RSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_RSH_X: 2 >> 1 = 1",
 		.u.insns_int = {
@@ -3936,6 +4047,19 @@ static struct bpf_test tests[] = {
 		{ { 0, 1 } },
 	},
 	/* BPF_ALU | BPF_RSH | BPF_K */
+	{
+		"ALU_RSH_K: (0x80000000 >> 0) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x80000000),
+			BPF_ALU32_IMM(BPF_RSH, R0, 0),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU_RSH_K: 2 >> 1 = 1",
 		.u.insns_int = {
@@ -3993,7 +4117,34 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0xffff00ff } },
 	},
+	{
+		"ALU_ARSH_X: (0x80000000 >> 0) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x80000000),
+			BPF_ALU32_IMM(BPF_MOV, R1, 0),
+			BPF_ALU32_REG(BPF_ARSH, R0, R1),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	/* BPF_ALU | BPF_ARSH | BPF_K */
+	{
+		"ALU_ARSH_K: (0x80000000 >> 0) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0x80000000),
+			BPF_ALU32_IMM(BPF_ARSH, R0, 0),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff",
 		.u.insns_int = {
@@ -4028,6 +4179,19 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 3 } },
 	},
+	{
+		"ALU_NEG: -(1) >> 32 + 1 = 1",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 1),
+			BPF_ALU32_IMM(BPF_NEG, R0, 0),
+			BPF_ALU64_IMM(BPF_RSH, R0, 32),
+			BPF_ALU64_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+	},
 	{
 		"ALU64_NEG: -(3) = -3",
 		.u.insns_int = {
-- 
2.19.1

