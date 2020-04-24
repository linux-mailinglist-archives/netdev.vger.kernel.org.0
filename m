Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15231B7229
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgDXKkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:40:03 -0400
Received: from foss.arm.com ([217.140.110.172]:59494 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgDXKkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 06:40:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ABDC1FB;
        Fri, 24 Apr 2020 03:40:00 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E0C53F6CF;
        Fri, 24 Apr 2020 03:39:56 -0700 (PDT)
Date:   Fri, 24 Apr 2020 11:39:53 +0100
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
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Message-ID: <20200424103953.GD1167@C02TD0UTHF1T.local>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
 <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:50:22AM +0100, Jianyong Wu wrote:
> On 2020/4/21 5:57 PM, Mark Rutland wrote:
> > On Tue, Apr 21, 2020 at 11:23:00AM +0800, Jianyong Wu wrote:
> >> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> >> index 550dfa3e53cd..a5309c28d4dc 100644
> >> --- a/virt/kvm/arm/hypercalls.c
> >> +++ b/virt/kvm/arm/hypercalls.c

> >> @@ -62,6 +66,44 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >>   if (gpa != GPA_INVALID)
> >>   val = gpa;
> >>   break;
> >> +/*
> >> + * This serves virtual kvm_ptp.
> >> + * Four values will be passed back.
> >> + * reg0 stores high 32-bit host ktime;
> >> + * reg1 stores low 32-bit host ktime;
> >> + * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >> + * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >> + */
> >> +case ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> > Shouldn't the host opt-in to providing this to the guest, as with other
> > features?
> 
> er, do you mean that "ARM_SMCCC_HV_PV_TIME_XXX" as "opt-in"? if so, I
> think this
> 
> kvm_ptp doesn't need a buddy. the driver in guest will call this service
> in a definite way.

I mean that when creating the VM, userspace should be able to choose
whether the PTP service is provided to the guest. The host shouldn't
always provide it as there may be cases where doing so is undesireable.

> >> +/*
> >> + * system time and counter value must captured in the same
> >> + * time to keep consistency and precision.
> >> + */
> >> +ktime_get_snapshot(&systime_snapshot);
> >> +if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
> >> +break;
> >> +arg[0] = upper_32_bits(systime_snapshot.real);
> >> +arg[1] = lower_32_bits(systime_snapshot.real);
> > Why exactly does the guest need the host's real time? Neither the cover
> > letter nor this commit message have explained that, and for those of us
> > unfamliar with PTP it would be very helpful to know that to understand
> > what's going on.
> 
> oh, sorry, I should have added more background knowledge here.
> 
> just give some hints here:
> 
> the kvm_ptp targets to sync guest time with host. some services in user
> space
> 
> like chrony can do time sync by inputing time(in kvm_ptp also clock
> counter sometimes) from
> 
> remote clocksource(often network clocksource). This kvm_ptp driver can
> offer a interface for
> 
> those user space service in guest to get the host time to do time sync
> in guest.

I think it would be very helpful for the commit message and/or cover
letter to have a high-level desctiption of what PTP is meant to do, and
an outline of the algorithmm (clearly splitting the host and guest
bits).

It's also not clear to me what notion of host time is being exposed to
the guest (and consequently how this would interact with time changes on
the host, time namespaces, etc). Having some description of that would
be very helpful.

Thanks,
Mark.
