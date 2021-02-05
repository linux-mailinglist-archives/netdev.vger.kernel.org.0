Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7510F310A2E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 12:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBELXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 06:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhBELUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 06:20:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA91164DB2;
        Fri,  5 Feb 2021 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612523969;
        bh=rm+DO8jRG9vXb505ghtG8o6BLLgA2frdzJnefVazWtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVK/pTsxIGKrL2Rz+z/51yT19TZeajQ+aLcfVitT1Fqz5q/iMvcQQyu8ESXGfjgqv
         ecxqDKAe9VHSgFoSOogOoqySVc3g5WUTu3Qhngd0P66a/4eroS5CiS96qn6Oi+cPTh
         xOCpwNInjgkQ7Hp5XTXsjGwD342+UMQAslRNTx1KKkaygNZo41zS1uC8vi2AWUKgma
         S3jfqQyd6pu4wKBjeOInrk/2Rs+sygNeh6Dvv7Bqb/Enq8GsotJX3pCY5Cclr8JC0d
         y/E8Mp1XhsE0lqRnqolLBbGfazddNLImalbB55ElDEW1Dd7AQMsvtO07TCKBsRBruz
         /9qyn1GHLifpw==
Date:   Fri, 5 Feb 2021 11:19:22 +0000
From:   Will Deacon <will@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, kernel-team@android.com
Subject: Re: [PATCH v17 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
Message-ID: <20210205111921.GA22109@willie-the-truck>
References: <20210202141204.3134855-1-maz@kernel.org>
 <20210202141204.3134855-2-maz@kernel.org>
 <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5765ade-7199-2d1e-6d59-d3de6a52c6ce@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 09:11:00AM +0000, Steven Price wrote:
> On 02/02/2021 14:11, Marc Zyngier wrote:
> > diff --git a/drivers/firmware/smccc/kvm_guest.c b/drivers/firmware/smccc/kvm_guest.c
> > new file mode 100644
> > index 000000000000..23ce1ded88b4
> > --- /dev/null
> > +++ b/drivers/firmware/smccc/kvm_guest.c
> > @@ -0,0 +1,51 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#define pr_fmt(fmt) "smccc: KVM: " fmt
> > +
> > +#include <linux/init.h>
> > +#include <linux/arm-smccc.h>
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +
> > +static DECLARE_BITMAP(__kvm_arm_hyp_services, ARM_SMCCC_KVM_NUM_FUNCS) __ro_after_init = { };
> > +
> > +void __init kvm_init_hyp_services(void)
> > +{
> > +	int i;
> > +	struct arm_smccc_res res;
> > +
> > +	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_HVC)
> > +		return;
> > +
> > +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, &res);
> > +	if (res.a0 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 ||
> > +	    res.a1 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 ||
> > +	    res.a2 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 ||
> > +	    res.a3 != ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3)
> > +		return;
> > +
> > +	memset(&res, 0, sizeof(res));
> > +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID, &res);
> > +	for (i = 0; i < 32; ++i) {
> > +		if (res.a0 & (i))
> > +			set_bit(i + (32 * 0), __kvm_arm_hyp_services);
> > +		if (res.a1 & (i))
> > +			set_bit(i + (32 * 1), __kvm_arm_hyp_services);
> > +		if (res.a2 & (i))
> > +			set_bit(i + (32 * 2), __kvm_arm_hyp_services);
> > +		if (res.a3 & (i))
> > +			set_bit(i + (32 * 3), __kvm_arm_hyp_services);
> 
> The bit shifts are missing, the tests should be of the form:
> 
> 	if (res.a0 & (1 << i))
> 
> Or indeed using a BIT() macro.

Maybe even test_bit()?

Will
