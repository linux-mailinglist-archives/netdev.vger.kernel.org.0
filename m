Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335762C20DF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgKXJFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731020AbgKXJFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 04:05:00 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27A82075A;
        Tue, 24 Nov 2020 09:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606208699;
        bh=4dd2MKJS6YNqUDm2WfT0Eu4BA+fK0d9nlPFSmVAq7GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VXXFrd6sYgV0FGjunKo/ajZ40yGekO24Gi7WxGW9SzG9TnexvSCBR/WMuglY2+msF
         MMltO5oe/o8yrwATRTrpb6cskzP2RWV9wFzKZAjVD1peSe7W/gW3iTjgb4bTVqmUNR
         YmMs8gsuNfPW+1Ktf/0rTBtKM2RXdF8dhvsQn3zM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khUFt-00DC9a-CY; Tue, 24 Nov 2020 09:04:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 09:04:57 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
In-Reply-To: <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
 <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Andre.Przywara@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianyong,

On 2020-11-24 05:37, Jianyong Wu wrote:
> Hi Marc,

[...]

>> > +
>> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
>> NC_ID,
>> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
>> 
>> I really don't see the need to use a non-architectural counter ID.
>> Using the virtual counter ID should just be fine, and shouldn't lead 
>> to any
>> issue.
>> 
> 
>> Am I missing something?
> 
> In this function, no counter data is needed. If virtual counter ID is
> used here, user may be confused with why we get virtual counter
> data and do nothing with it. So I explicitly add a new "NONE" counter
> ID to make it clear.
> 
> WDYT?

ITIABI (I Think It's A Bad Idea). There are two counters, and the API
allows to retrieve the data for any of these two. If the "user" doesn't
want to do anything with the data, that's their problem.

Here, you can just sue the virtual counter, and that will give you the
exact same semantic, without inventing non-architectural state.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
