Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CA541EE32
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354500AbhJANG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354213AbhJANGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D84C0613EB
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:04 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g7so33802625edv.1
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jpHHECyJBSuDzV8sQEpnKqzKuSA0gHWMInU+P2sJMM=;
        b=L5/YvycX993FGYGpJAohPhtyp1IoH+ZofMEQx+8C7sgxQSekL4wFyP31hjA2QBgWfv
         EV+gdzbHEx73OO3Ld4PwEm+10WM2GhGTnQKUtneQqbpGZuz67uZ4NpC5qnT/bigGoOFO
         fFySZP8o7fA/N4bQGX08jVTDbxVJCFHM69U/o0OwW48cAmoubPMReXFi2Y5pOW/FLap7
         P0ci01MagBRYw/+99RvDAEjK7vG44nj2EhVVpY5XwGZADmM9euYk+ya4iE6xmIypgHY6
         IFKtyek8lsU2M3IUleLIjGtgUEGkxA37HBTU22GMQza9h8Lr0rUoy+Es8ICOg+lAvaRc
         iBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jpHHECyJBSuDzV8sQEpnKqzKuSA0gHWMInU+P2sJMM=;
        b=c1gWWtr3wJDpXcxYBuHhir2dpcOD/IejhMpPh4LmNSuZaovZY88yQlhuCsSHWNhfbq
         xZlqPl88/9TDW7ZEydip5zHKj8XvlSPBi7HMocAttBO0kuotH4t11r3sX0I+njFgNDvi
         3y2aq/4ianVur5QeHUje6j9ZmYFT0rZOlFMstX06cvotUSLhE1MvWIOFxMUrRojwo91D
         yp8E6Y7pzMoUKJikTwueM7TUE1DqaoXMlkblhYE6nI6saQMb+0ramOZxy5nIQDXYtO/I
         8YNDq8ySY2STDAgsHhMFKkyahvHqVgILuYZNpcOSeb+lXVPXRZSS3Vzh1VlRGUHAvbmy
         Yd7A==
X-Gm-Message-State: AOAM531HbRZh9OkywjQyFK5TYZfxwPV1bI89dAjhf6rBhDFDibj8zM+w
        jLYLcdfyMFGwaXGtaBSBs4oOqA==
X-Google-Smtp-Source: ABdhPJxP1recQuvCaOvbZrc5X2GV9hImHVScvrvBzFLUbGU3S9GFk9xHcoujT8qJsDVi7wLsmygxhw==
X-Received: by 2002:a50:e1cf:: with SMTP id m15mr13988643edl.181.1633093438864;
        Fri, 01 Oct 2021 06:03:58 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:03:58 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 01/10] bpf/tests: Add tests of BPF_LDX and BPF_STX with small sizes
Date:   Fri,  1 Oct 2021 15:03:39 +0200
Message-Id: <20211001130348.3670534-2-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a series of tests to verify the behavior of BPF_LDX and
BPF_STX with BPF_B//W sizes in isolation. In particular, it checks that
BPF_LDX zero-extendeds the result, and that BPF_STX does not overwrite
adjacent bytes in memory.

BPF_ST and operations on BPF_DW size are deemed to be sufficiently
tested by existing tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 254 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 254 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 21ea1ab253a1..a838a6179ca4 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6907,6 +6907,260 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, (u32) (cpu_to_le64(0xfedcba9876543210ULL) >> 32) } },
 	},
+	/* BPF_LDX_MEM B/H/W/DW */
+	{
+		"BPF_LDX_MEM | BPF_B",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R2, 0x0000000000000008ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_B, R0, R10, -1),
+#else
+			BPF_LDX_MEM(BPF_B, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_LDX_MEM | BPF_B, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R2, 0x0000000000000088ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_B, R0, R10, -1),
+#else
+			BPF_LDX_MEM(BPF_B, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_LDX_MEM | BPF_H",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R2, 0x0000000000000708ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_H, R0, R10, -2),
+#else
+			BPF_LDX_MEM(BPF_H, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_LDX_MEM | BPF_H, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R2, 0x0000000000008788ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_H, R0, R10, -2),
+#else
+			BPF_LDX_MEM(BPF_H, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_LDX_MEM | BPF_W",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R2, 0x0000000005060708ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_W, R0, R10, -4),
+#else
+			BPF_LDX_MEM(BPF_W, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_LDX_MEM | BPF_W, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R2, 0x0000000085868788ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_LDX_MEM(BPF_W, R0, R10, -4),
+#else
+			BPF_LDX_MEM(BPF_W, R0, R10, -8),
+#endif
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	/* BPF_STX_MEM B/H/W/DW */
+	{
+		"BPF_STX_MEM | BPF_B",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b0c0d0e008ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_B, R10, R2, -1),
+#else
+			BPF_STX_MEM(BPF_B, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_STX_MEM | BPF_B, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b0c0d0e088ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_B, R10, R2, -1),
+#else
+			BPF_STX_MEM(BPF_B, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_STX_MEM | BPF_H",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b0c0d00708ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_H, R10, R2, -2),
+#else
+			BPF_STX_MEM(BPF_H, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_STX_MEM | BPF_H, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b0c0d08788ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_H, R10, R2, -2),
+#else
+			BPF_STX_MEM(BPF_H, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_STX_MEM | BPF_W",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x0102030405060708ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b005060708ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_W, R10, R2, -4),
+#else
+			BPF_STX_MEM(BPF_W, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
+	{
+		"BPF_STX_MEM | BPF_W, MSB set",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x8090a0b0c0d0e0f0ULL),
+			BPF_LD_IMM64(R2, 0x8182838485868788ULL),
+			BPF_LD_IMM64(R3, 0x8090a0b085868788ULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+#ifdef __BIG_ENDIAN
+			BPF_STX_MEM(BPF_W, R10, R2, -4),
+#else
+			BPF_STX_MEM(BPF_W, R10, R2, -8),
+#endif
+			BPF_LDX_MEM(BPF_DW, R0, R10, -8),
+			BPF_JMP_REG(BPF_JNE, R0, R3, 1),
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
 	/* BPF_ST(X) | BPF_MEM | BPF_B/H/W/DW */
 	{
 		"ST_MEM_B: Store/Load byte: max negative",
-- 
2.30.2

