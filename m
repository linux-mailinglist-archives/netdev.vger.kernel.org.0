Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260011CB6DD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgEHSQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHSQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:16:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA71C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 11:16:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so1085938plo.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+grFk/1b6m5GXQB6Do7/JZsbw7ECp6r+S8upQGe4+gI=;
        b=I6sVrCyeN1Al9+YXglL0XwffqWho/yTDT1r7S/K6Apz4jUPalQFiMfGpHSI54ALlc+
         V6dIZM6i+WLjQlh5ywJ5byFfTeg9EfIH49M7i84H/uOfLRN+vZzIfo59Q3OEXEIJQEsx
         7x2tnn1OPyog3FsuhfzlEBVIKdmsUugJfu5W4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+grFk/1b6m5GXQB6Do7/JZsbw7ECp6r+S8upQGe4+gI=;
        b=UQRZLb1F+Nukb5xXj/dyAADq7Ww4gqwIAV1dsTGSGtthHbctlHzNH7rh86SR4ntWI8
         u4bjsj1U/Eh5mGV0Q64nPpBxmMnFUItYaKM0jgTnkVpRxyL96HDtM9mxrJgnXAxWfK3U
         4rVHkcIGeM/gy4qqgaYrlYQYy3rBUtkJxX9v/LRXv3HHKVvQhnB1VkBcaVuuMgpk002Q
         Zpz+4jqzOm/SNjXRXYQ0qTdSkghEdLy8krf9yzympsNV2v5CIV6JVb2u0DfBqwFuUMSn
         79BXW0BY9iIY+c/NRQIDHzCUw1jeTEUgzhHWAH4uLELcCY0VszLd1IhFm8QSx6f8ES+N
         U5fA==
X-Gm-Message-State: AGi0PuYsnaN7PiiD6PYaMl9M95i3cXHgX0mO9qJ1pZvfJIv+SPBTZv0u
        5OC5EOXNm6eMdex3FOkyIxz4DA==
X-Google-Smtp-Source: APiQypKtbeWNjjqucMJ+BC3YWrrXzqesmFdn18zvEh3fztWZsGRRr05NnDcv2TODGa7UTSA8QZCmwg==
X-Received: by 2002:a17:902:6114:: with SMTP id t20mr3762825plj.324.1588961760860;
        Fri, 08 May 2020 11:16:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id e11sm2349463pfl.85.2020.05.08.11.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 11:16:00 -0700 (PDT)
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
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH bpf-next v2 1/3] arm64: insn: Fix two bugs in encoding 32-bit logical immediates
Date:   Fri,  8 May 2020 11:15:44 -0700
Message-Id: <20200508181547.24783-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508181547.24783-1-luke.r.nels@gmail.com>
References: <20200508181547.24783-1-luke.r.nels@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two issues present in the current function for encoding
arm64 logical immediates when using the 32-bit variants of instructions.

First, the code does not correctly reject an all-ones 32-bit immediate,
and returns an undefined instruction encoding.

Second, the code incorrectly rejects some 32-bit immediates that are
actually encodable as logical immediates. The root cause is that the code
uses a default mask of 64-bit all-ones, even for 32-bit immediates.
This causes an issue later on when the default mask is used to fill the
top bits of the immediate with ones, shown here:

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

The fix for both issues is to generate a correct mask based on the
instruction immediate size, and use the mask to check for all-ones,
all-zeroes, and values wider than the mask.

Currently, arch/arm64/kvm/va_layout.c is the only user of this function,
which uses 64-bit immediates and therefore won't trigger these bugs.

We tested the new code against llvm-mc with all 1,302 encodable 32-bit
logical immediates and all 5,334 encodable 64-bit logical immediates.

Fixes: ef3935eeebff ("arm64: insn: Add encoder for bitwise operations using literals")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/insn.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 4a9e773a177f..cc2f3d901c91 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1535,16 +1535,10 @@ static u32 aarch64_encode_immediate(u64 imm,
 				    u32 insn)
 {
 	unsigned int immr, imms, n, ones, ror, esz, tmp;
-	u64 mask = ~0UL;
-
-	/* Can't encode full zeroes or full ones */
-	if (!imm || !~imm)
-		return AARCH64_BREAK_FAULT;
+	u64 mask;
 
 	switch (variant) {
 	case AARCH64_INSN_VARIANT_32BIT:
-		if (upper_32_bits(imm))
-			return AARCH64_BREAK_FAULT;
 		esz = 32;
 		break;
 	case AARCH64_INSN_VARIANT_64BIT:
@@ -1556,6 +1550,12 @@ static u32 aarch64_encode_immediate(u64 imm,
 		return AARCH64_BREAK_FAULT;
 	}
 
+	mask = GENMASK(esz - 1, 0);
+
+	/* Can't encode full zeroes, full ones, or value wider than the mask */
+	if (!imm || imm == mask || imm & ~mask)
+		return AARCH64_BREAK_FAULT;
+
 	/*
 	 * Inverse of Replicate(). Try to spot a repeating pattern
 	 * with a pow2 stride.
-- 
2.17.1

