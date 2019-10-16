Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445CAD8DD3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392390AbfJPKXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:23:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49609 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfJPKXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 06:23:49 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKgSw-0002ga-0Y; Wed, 16 Oct 2019 12:23:38 +0200
Date:   Wed, 16 Oct 2019 12:23:37 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <HE1PR0801MB1676EC775B7BFA5FC7E4F9D5F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <alpine.DEB.2.21.1910161218020.2046@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com> <20191015104822.13890-4-jianyong.wu@arm.com> <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com> <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de> <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
 <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de> <HE1PR0801MB1676EC775B7BFA5FC7E4F9D5F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianyong,

On Wed, 16 Oct 2019, Jianyong Wu (Arm Technology China) wrote:

Please fix your mail client not to copy the full headers into the reply.

> > On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> > > On 15/10/19 22:13, Thomas Gleixner wrote:
> > That's a completely different beast, really.
> > 
> > The clocksource pointer is handed in by the caller and the core code validates
> > if the clocksource is the same as the current system clocksource and not the
> > other way round.
> > 
> > So there is no need for getting that pointer from the core code because the
> > caller knows already which clocksource needs to be active to make.the whole
> > cross device timestamp correlation work. And in that case it's the callers
> > responsibility to ensure that the pointer is valid which is the case for the
> > current use cases.
> > 
> I thinks there is something misunderstanding of my patch. See patch 4/6,
> the reason why I add clocksource is that I want to check if the current
> clocksouce is arm_arch_counter in virt/kvm/arm/psci.c and nothing to do
> with get_device_system_crosststamp.

There is no misunderstanding at all. Your patch is broken in several ways
as I explained in detail.

> So I really need a mechanism to do that check.
> 
> Thanks
> Jianyong

So just by chance I scrolled further down and found more replies from
you. Please trim the reply properly and add your 'Thanks Jianyong' to the
end of the mail.
 
> > From your other reply:
> > 
> > > Why add a global id?  ARM can add it to archdata similar to how x86
> > > has vclock_mode.  But I still think the right thing to do is to
> > > include the full system_counterval_t in the result of
> > > ktime_get_snapshot.  (More in a second, feel free to reply to the other
> > email only).
> > 
> > No, the clocksource pointer is not going to be exposed as there is no
> > guarantee that it will be still around after the call returns.
> > 
> > It's not even guaranteed to be correct when the store happens in Wu's patch
> > simply because the store is done outside of the seqcount protected region.
> 
> Yeah, all of the elements in system_time_snapshot should be captured in
> consistency. So I think the consistency will be guaranteed if the store
> ops added in the seqcount region.

Again. While it is consistent in terms of storage, it's still wrong to
expose a pointer to something which has no life time guarantee. Even if
your use case is just to compare the pointer it's a bad idea to do that
especially without any comment about the pointer validity at all.

Thanks,

	tglx
