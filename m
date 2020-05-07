Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE421C84A4
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgEGIT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGIT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 04:19:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 221B820753;
        Thu,  7 May 2020 08:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588839598;
        bh=3gbWMUd5CO+cTYDj/4z9OV5jX0t6dXsMaqIYbZgFlpY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lr7yTnWBq42d7rxJ0Gg4BdkKXNv6Fg/DgGgRnd3b42jDQGDShOtmC7lD2OobaaUU8
         RNP+Dy569psqAbJSuxu3H6OZ+NCqxM9pBPDRiOKYPimNF5oGDEUW64fdrozNhLPS6i
         QLyB/mQc66gTJWgMbSh8urRrtf24s35UG9G+HgHA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jWbl6-00ACFm-4L; Thu, 07 May 2020 09:19:56 +0100
Date:   Thu, 7 May 2020 09:19:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [RFC PATCH bpf-next 1/3] arm64: insn: Fix two bugs in encoding
 32-bit logical immediates
Message-ID: <20200507091953.70505638@why>
In-Reply-To: <20200507010504.26352-2-luke.r.nels@gmail.com>
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
        <20200507010504.26352-2-luke.r.nels@gmail.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: lukenels@cs.washington.edu, bpf@vger.kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com, catalin.marinas@arm.com, will@kernel.org, daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, mark.rutland@arm.com, gregkh@linuxfoundation.org, tglx@linutronix.de, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, clang-built-linux@googlegroups.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luke,

Thanks a lot for nailing these bugs.

On Wed,  6 May 2020 18:05:01 -0700
Luke Nelson <lukenels@cs.washington.edu> wrote:

> This patch fixes two issues present in the current function for encoding
> arm64 logical immediates when using the 32-bit variants of instructions.
> 
> First, the code does not correctly reject an all-ones 32-bit immediate
> and returns an undefined instruction encoding, which can crash the kernel.

You make it sound more dramatic than it needs to be! ;-) As you pointed
out below, nothing in the kernel calls this code to encode a 32bit
immediate, so triggering a crash is not possible (unless you manage to
exploit something else to call into this code). It definitely needs
fixing though!

> The fix is to add a check for this case.
> 
> Second, the code incorrectly rejects some 32-bit immediates that are
> actually encodable as logical immediates. The root cause is that the code
> uses a default mask of 64-bit all-ones, even for 32-bit immediates. This
> causes an issue later on when the mask is used to fill the top bits of
> the immediate with ones, shown here:
> 
>   /*
>    * Pattern: 0..01..10..01..1
>    *
>    * Fill the unused top bits with ones, and check if
>    * the result is a valid immediate (all ones with a
>    * contiguous ranges of zeroes).
>    */
>   imm |= ~mask;
>   if (!range_of_ones(~imm))
>           return AARCH64_BREAK_FAULT;
> 
> To see the problem, consider an immediate of the form 0..01..10..01..1,
> where the upper 32 bits are zero, such as 0x80000001. The code checks
> if ~(imm | ~mask) contains a range of ones: the incorrect mask yields
> 1..10..01..10..0, which fails the check; the correct mask yields
> 0..01..10..0, which succeeds.
> 
> The fix is to use a 32-bit all-ones default mask for 32-bit immediates.

Paging this thing back in is really hard (I only had one coffee, more
needed). Yes, I see what you mean. Duh! I think this only happens if
mask hasn't been adjusted by the "pattern spotting" code the first place
though.

> 
> Currently, the only user of this function is in
> arch/arm64/kvm/va_layout.c, which uses 64-bit immediates and won't
> trigger these bugs.
> 
> We tested the new code against llvm-mc with all 1,302 encodable 32-bit
> logical immediates and all 5,334 encodable 64-bit logical immediates.

That, on its own, is awesome information. Do you have any pointer on
how to set this up?

> 
> Fixes: ef3935eeebff ("arm64: insn: Add encoder for bitwise operations using literals")
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/arm64/kernel/insn.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 4a9e773a177f..42fad79546bb 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -1535,7 +1535,7 @@ static u32 aarch64_encode_immediate(u64 imm,
>  				    u32 insn)
>  {
>  	unsigned int immr, imms, n, ones, ror, esz, tmp;
> -	u64 mask = ~0UL;
> +	u64 mask;
>  
>  	/* Can't encode full zeroes or full ones */
>  	if (!imm || !~imm)
> @@ -1543,13 +1543,15 @@ static u32 aarch64_encode_immediate(u64 imm,
>  
>  	switch (variant) {
>  	case AARCH64_INSN_VARIANT_32BIT:
> -		if (upper_32_bits(imm))
> +		if (upper_32_bits(imm) || imm == 0xffffffffUL)

nit: I don't like the fact that this create a small dissymmetry in the
way we check things (we start by checking !~imm, which is not relevant
to 32bit constants).

>  			return AARCH64_BREAK_FAULT;
>  		esz = 32;
> +		mask = 0xffffffffUL;
>  		break;
>  	case AARCH64_INSN_VARIANT_64BIT:
>  		insn |= AARCH64_INSN_SF_BIT;
>  		esz = 64;
> +		mask = ~0UL;

I'd rather we generate the mask in a programmatic way, which is pretty
easy to do since we have the initial element size.

>  		break;
>  	default:
>  		pr_err("%s: unknown variant encoding %d\n", __func__, variant);

To account for the above remarks, I came up with the following patch:

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 4a9e773a177f..422bf9a79ed6 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -1535,11 +1535,7 @@ static u32 aarch64_encode_immediate(u64 imm,
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
@@ -1556,6 +1552,11 @@ static u32 aarch64_encode_immediate(u64 imm,
 		return AARCH64_BREAK_FAULT;
 	}
 
+	/* Can't encode full zeroes or full ones */
+	mask = GENMASK_ULL(esz - 1, 0);
+	if (!imm || !(~imm & mask))
+		return AARCH64_BREAK_FAULT;
+
 	/*
 	 * Inverse of Replicate(). Try to spot a repeating pattern
 	 * with a pow2 stride.

which is of course completely untested (it does compile though).

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
