Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8E25F6D0
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgIGJrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgIGJrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 05:47:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EFA2078E;
        Mon,  7 Sep 2020 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599472023;
        bh=cFHskjvmHO3vzxD+eGBoRNZ+sFpiHGFme6jLOuWP8Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=19AbdD+EC1bO4XviCsVbOEsgKBlvuTcIcRwYpDXdAbiyDIC2ngljNeSByIj6g2WwR
         pwHlJAa2zca7ViqS+HXJHlbRqiyn/WpxFytm5SMsvxtaqOBqDi0a5jaudF1eVdGURu
         jTZbUs3gK3gLc/gZXJVqSV1JOAEE6FHqZ7nCuP54=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFDjp-009iuT-BE; Mon, 07 Sep 2020 10:47:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 07 Sep 2020 10:47:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
 <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <67f3381467d02c8d3f25682cd99898e9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-07 10:28, Jianyong Wu wrote:
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Monday, September 7, 2020 4:55 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>

[...]

>> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
>> >> ES_FUNC_ID,
>> >> > +			     &hvc_res);
>> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
>> >> > +		return -EOPNOTSUPP;
>> >> > +
>> >> > +	return 0;
>> >>
>> >> What happens if the
>> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
>> implemented
>> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour is
>> >> that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
>> >> The result is that this function always returns "supported". Not an
>> >> acceptable behaviour.
>> >>
>> > Oh!  it's really a stupid mistake, should be "&" not "|".
>> 
>> But even then. (-1 & whatever) is always true.
> 
> Yeah, what about checking if a0 is non-negative first? Like:
> if (hvc_res.a0 < 0 || !(hvc_res.a0 & BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> 	return -EOPNOTSUPP;

I don't get it. You already carry a patch from Will that gives
you a way to check for a service (kvm_arm_hyp_service_available()).

Why do you need to reinvent the wheel?

         M.
-- 
Jazz is not dead. It just smells funny...
