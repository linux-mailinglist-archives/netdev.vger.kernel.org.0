Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD041C7FA8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 03:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEGBFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 21:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbgEGBFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 21:05:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A95FC061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 18:05:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f6so1881664pgm.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 18:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d68RkE5cUlQYJi4OtfTvAYhJJDA5HOgjSHowTSdBNCQ=;
        b=aNteDNbspIs9Glmh/mFjc8BOXg8S0Ca8B8LdGCTylILkDT1X53VNGpvY2sKmwEIt2D
         2LQFsRPQa2s0snapgqlU4uqdx9+VG+5989Tpp+AB7M4cM+rYd529iUL1uwx2M2i4qurd
         Bp2axaRstmpVUtZssFn9tvFE9GKV2jGGnUElY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d68RkE5cUlQYJi4OtfTvAYhJJDA5HOgjSHowTSdBNCQ=;
        b=bgJXyyBKDHFZ4b+om71Xz0xAcKc+3DSv+jOGcsmkPwj98vFp2Wi/TgIiZwQw9F1Q0W
         4wNwazltKViynYcUYyhNzRC4UAzCLzL7/cWvbK1kEp8mPp6bf0u13FdGEXYTzKADW7Sn
         DWz56AQx6wLPlzkHxVLksxjihZSrNBjjKukOosoZzHSV2p5n6zPxDtF8YuHwPImylIf0
         SUMkNPuHGgvm4/KD0OxxMXpcjoVpT3lnY9+QYBqQtAuQmP5bo/I6iKmFJNJwnJJlxMNm
         +3CCLxLD121sozsGn82IyE+lyXCKkj8GbLYhy6Lk3kQA5wDTGj5lkAo7FBEmdONUaAbt
         owGg==
X-Gm-Message-State: AGi0PuZlobjhJweFsaPXhp3dDRxCm1pYjraYQ6AugxhXmKVO3atUeDm0
        nbn7DSY5qaicS/jasDbCmuk3CQ==
X-Google-Smtp-Source: APiQypIZNgVmwLRidWuxLxiLH6PVWFdqH1ydpGuO62XWtWLjxZ1wcT+PjiOw7eW2Cl7EvdNoj9f9Sg==
X-Received: by 2002:aa7:955a:: with SMTP id w26mr11271899pfq.292.1588813512792;
        Wed, 06 May 2020 18:05:12 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id ev5sm6165250pjb.1.2020.05.06.18.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 18:05:12 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [RFC PATCH bpf-next 1/3] arm64: insn: Fix two bugs in encoding 32-bit logical immediates
Date:   Wed,  6 May 2020 18:05:01 -0700
Message-Id: <20200507010504.26352-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507010504.26352-1-luke.r.nels@gmail.com>
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two issues present in the current function for encoding
arm64 logical immediates when using the 32-bit variants of instructions.

First, the code does not correctly reject an all-ones 32-bit immediate
and returns an undefined instruction encoding, which can crash the kernel.
The fix is to add a check for this case.

Second, the code incorrectly rejects some 32-bit immediates that are
actually encodable as logical immediates. The root cause is that the code
uses a default mask of 64-bit all-ones, even for 32-bit immediates. This
causes an issue later on when the mask is used to fill the top bits of
the immediate with ones, shown here:

  /*
   * Pattern: 0..01..10..01..1
   *
   * Fill the unused top bits with ones, and check if
   * the result is a valid immediate (all ones with a
   * contiguous ranges of zeroes).
   */
  imm |= ~mask;
  if (!range_of_ones(~imm))
          return AARCH64_BREAK_FAULT;

To see the problem, consider an immediate of the form 0..01..10..01..1,
where the upper 32 bits are zero, such as 0x80000001. The code checks
if ~(imm | ~mask) contains a range of ones: the incorrect mask yields
1..10..01..10..0, which fails the check; the correct mask yields
0..01..10..0, which succeeds.

The fix is to use a 32-bit all-ones default mask for 32-bit immediates.

Currently, the only user of this function is in
arch/arm64/kvm/va_layout.c, which uses 64-bit immediates and won't
trigger these bugs.

We tested the new code against llvm-mc with all 1,302 encodable 32-bit
logical immediates and all 5,334 encodable 64-bit logical immediates.

Fixes: ef3935eeebff ("arm64: insn: Add encoder for bitwise operations using literals")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/arm64/kernel/insn.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 4a9e773a177f..42fad79546bb 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1535,7 +1535,7 @@ static u32 aarch64_encode_immediate(u64 imm,
 				    u32 insn)
 {
 	unsigned int immr, imms, n, ones, ror, esz, tmp;
-	u64 mask = ~0UL;
+	u64 mask;
 
 	/* Can't encode full zeroes or full ones */
 	if (!imm || !~imm)
@@ -1543,13 +1543,15 @@ static u32 aarch64_encode_immediate(u64 imm,
 
 	switch (variant) {
 	case AARCH64_INSN_VARIANT_32BIT:
-		if (upper_32_bits(imm))
+		if (upper_32_bits(imm) || imm == 0xffffffffUL)
 			return AARCH64_BREAK_FAULT;
 		esz = 32;
+		mask = 0xffffffffUL;
 		break;
 	case AARCH64_INSN_VARIANT_64BIT:
 		insn |= AARCH64_INSN_SF_BIT;
 		esz = 64;
+		mask = ~0UL;
 		break;
 	default:
 		pr_err("%s: unknown variant encoding %d\n", __func__, variant);
-- 
2.17.1

