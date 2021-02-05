Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8303E3111D8
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 21:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhBESUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233066AbhBEPTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 10:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A7564F2C;
        Fri,  5 Feb 2021 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612544413;
        bh=bYsyypHJHkCDMPq/yGSFgDLzazYUpF+GyWHhaLu3g4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1jCslKGu5syM6wrgfzO+JQED3kse4raQl0d6FfhlQitKk+PIqGWsucshvT5xTTDT
         pFgPhLBLy0lnyOoljOXKrQtVRJRYMQY0OAWwFJk+4+Fp8+fCoMCCz8RiNq/7A8GvwT
         scyQNLe4GsQOdJx6RRmimhK+Iv6oHqD20IyhZq7qoah7ToC4DQ5H24blnfQCoo6qxA
         zJ3fFY25tCWmIi2HnxEzY5JqdsQbVmqld1lGesBnu1pP5ENmCt4t4tE0NUWf9f2GbF
         qS492rMyHch6HYBMm9czMXIuew2DqXpXu5d/HH0b2PJ6rjESiv0gM/XUS4YUwFRLvT
         9NXR0ve6CzKgw==
Date:   Fri, 5 Feb 2021 17:00:06 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Steven Price <steven.price@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, kernel-team@android.com
Subject: Re: [PATCH v17 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
Message-ID: <20210205170005.GC22665@willie-the-truck>
References: <20210202141204.3134855-1-maz@kernel.org>
 <20210202141204.3134855-2-maz@kernel.org>
 <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
 <20210205111921.GA22109@willie-the-truck>
 <e2eefee823f6a8e448f6d477cef315d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2eefee823f6a8e448f6d477cef315d4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 04:50:27PM +0000, Marc Zyngier wrote:
> On 2021-02-05 11:19, Will Deacon wrote:
> > On Fri, Feb 05, 2021 at 09:11:00AM +0000, Steven Price wrote:
> > > On 02/02/2021 14:11, Marc Zyngier wrote:
> > > > +	for (i = 0; i < 32; ++i) {
> > > > +		if (res.a0 & (i))
> > > > +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> > > > +		if (res.a1 & (i))
> > > > +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> > > > +		if (res.a2 & (i))
> > > > +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> > > > +		if (res.a3 & (i))
> > > > +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> > > 
> > > The bit shifts are missing, the tests should be of the form:
> > > 
> > > 	if (res.a0 & (1 << i))
> > > 
> > > Or indeed using a BIT() macro.
> > 
> > Maybe even test_bit()?
> 
> Actually, maybe not doing things a-bit-at-a-time is less error prone.
> See below what I intend to fold in.
> 
> Thanks,
> 
>         M.
> 
> diff --git a/drivers/firmware/smccc/kvm_guest.c
> b/drivers/firmware/smccc/kvm_guest.c
> index 00bf3c7969fc..08836f2f39ee 100644
> --- a/drivers/firmware/smccc/kvm_guest.c
> +++ b/drivers/firmware/smccc/kvm_guest.c
> @@ -2,8 +2,8 @@
> 
>  #define pr_fmt(fmt) "smccc: KVM: " fmt
> 
> -#include <linux/init.h>
>  #include <linux/arm-smccc.h>
> +#include <linux/bitmap.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> 
> @@ -13,8 +13,8 @@ static DECLARE_BITMAP(__kvm_arm_hyp_services,
> ARM_SMCCC_KVM_NUM_FUNCS) __ro_afte
> 
>  void __init kvm_init_hyp_services(void)
>  {
> -	int i;
>  	struct arm_smccc_res res;
> +	u32 val[4];
> 
>  	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
>  		return;
> @@ -28,16 +28,13 @@ void __init kvm_init_hyp_services(void)
> 
>  	memset(&res, 0, sizeof(res));
>  	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
> -	for (i = 0; i < 32; ++i) {
> -		if (res.a0 & (i))
> -			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> -		if (res.a1 & (i))
> -			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> -		if (res.a2 & (i))
> -			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> -		if (res.a3 & (i))
> -			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> -	}
> +
> +	val[0] = lower_32_bits(res.a0);
> +	val[1] = lower_32_bits(res.a1);
> +	val[2] = lower_32_bits(res.a2);
> +	val[3] = lower_32_bits(res.a3);
> +
> +	bitmap_from_arr32(__kvm_arm_hyp_services, val, ARM_SMCCC_KVM_NUM_FUNCS);

Nice! That's loads better.

Will
