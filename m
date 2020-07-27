Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED6D22EB53
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgG0Li3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgG0Li2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:38:28 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6C832072E;
        Mon, 27 Jul 2020 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595849908;
        bh=uLbTYAh07fv8JZO0YyeUya+9u16JNdr7tPp1pQ4gqYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zO7gFLOA17LlgroJllXmWm8YcqAdeP4NTG7mB9v4pP075cnGKv9titYleXePQiaVX
         J07HCyoLe7QeSH+D5suzf/uXPdQ2C3NMCIvMQrAaxR6HJ5ZPDGdBoOMgsRbYRd36lB
         AEEtX/k8I1IBrkr3UiqDsvAOjov2r23gFZO83WJw=
Date:   Mon, 27 Jul 2020 12:38:21 +0100
From:   Will Deacon <will@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Message-ID: <20200727113821.GB20437@willie-the-truck>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
 <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:45:37AM +0000, Jianyong Wu wrote:
> > From: Will Deacon <will@kernel.org>
> > 
> > We can advertise ourselves to guests as KVM and provide a basic features
> > bitmap for discoverability of future hypervisor services.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
> >  1 file changed, 19 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 550dfa3e53cd..db6dce3d0e23 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -12,13 +12,13 @@
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> >  	u32 func_id = smccc_get_function(vcpu);
> > -	long val = SMCCC_RET_NOT_SUPPORTED;
> > +	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> 
> There is a risk as this u32 value will return here and a u64 value will be
> obtained in guest. For example, The val[0] is initialized as -1 of
> 0xffffffff and the guest get 0xffffffff then it will be compared with -1
> of 0xffffffffffffffff Also this problem exists for the transfer of address
> in u64 type. So the following assignment to "val" should be split into two
> u32 value and assign to val[0] and val[1] respectively.
> WDYT?

Yes, I think you're right that this is a bug, but isn't the solution just
to make that an array of 'long'?

	long val [4];

That will sign-extend the negative error codes as required, while leaving
the explicitly unsigned UID constants alone.

Will
