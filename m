Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72331BF5A3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3Kg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:36:57 -0400
Received: from foss.arm.com ([217.140.110.172]:52242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgD3Kg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 06:36:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B27C61063;
        Thu, 30 Apr 2020 03:36:53 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A03223F68F;
        Thu, 30 Apr 2020 03:36:49 -0700 (PDT)
Date:   Thu, 30 Apr 2020 11:36:46 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>, Haibo Xu <Haibo.Xu@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Message-ID: <20200430103646.GB39784@C02TD0UTHF1T.local>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
 <20200424103953.GD1167@C02TD0UTHF1T.local>
 <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b53b0a47-1fe6-ad92-05f4-80d50980c587@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 07:14:52AM +0100, Jianyong Wu wrote:
> On 2020/4/24 6:39 PM, Mark Rutland wrote:
> > On Fri, Apr 24, 2020 at 03:50:22AM +0100, Jianyong Wu wrote:
> >> On 2020/4/21 5:57 PM, Mark Rutland wrote:
> >>> On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
> >>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> >>>> index 550dfa3e53cd..a5309c28d4dc 100644
> >>>> --- a/virt/kvm/arm/hypercalls.c
> >>>> +++ b/virt/kvm/arm/hypercalls.c
> >>>> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>>>    if (gpa != GPA_INVALID)
> >>>>    val = gpa;
> >>>>    break;
> >>>> +/*
> >>>> + * This serves virtual kvm_ptp.
> >>>> + * Four values will be passed back.
> >>>> + * reg0 stores high 32-bit host ktime;
> >>>> + * reg1 stores low 32-bit host ktime;
> >>>> + * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >>>> + * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >>>> + */
> >>>> +case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> >>> Shouldn't the host opt-in to providing this to the guest, as with other
> >>> features?
> >> er, do you mean that "ARM_SMCCC_HV_PV_TIME_XXX" as "opt-in"? if so, I
> >> think this
> >>
> >> kvm_ptp doesn't need a buddy. the driver in guest will call this service
> >> in a definite way.
> > I mean that when creating the VM, userspace should be able to choose
> > whether the PTP service is provided to the guest. The host shouldn't
> > always provide it as there may be cases where doing so is undesireable.
> >
> I think I have implemented in patch 9/9 that userspace can get the info
> that if the host offers the kvm_ptp service. But for now, the host
> kernel will always offer the kvm_ptp capability in the current
> implementation. I think x86 follow the same behavior (see [1]). so I
> have not considered when and how to disable this kvm_ptp service in
> host. Do you think we should offer this opt-in?

I think taht should be opt-in, yes.

[...]

> > It's also not clear to me what notion of host time is being exposed to
> > the guest (and consequently how this would interact with time changes on
> > the host, time namespaces, etc). Having some description of that would
> > be very helpful.
> 
> sorry to have not made it clear.
> 
> Time will not change in host and only time in guest will change to sync
> with host. host time is the target that time in guest want to adjust to.
> guest need to get the host time then compute the different of the time
> in guest and host, so the guest can adjust the time base on the difference.

I understood that host time wouldn't change here, but what was not clear
is which notion of host time is being exposed to the guest.

e.g. is that a raw monotonic clock, or one subject to periodic adjument,
or wall time in the host? What is the epoch of the host time?

> I will add the base principle of time sync service in guest using
> kvm_ptp in commit message.

That would be great; thanks!

Mark.
