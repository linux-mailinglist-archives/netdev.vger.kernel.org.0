Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE57D8966
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbfJPH2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:28:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48458 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJPH2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:28:42 -0400
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKdjU-0007KO-Cs; Wed, 16 Oct 2019 09:28:32 +0200
Date:   Wed, 16 Oct 2019 09:28:31 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
Message-ID: <alpine.DEB.2.21.1910160914230.2518@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com> <20191015104822.13890-4-jianyong.wu@arm.com> <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com> <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
 <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> On 15/10/19 22:13, Thomas Gleixner wrote:
> > On Tue, 15 Oct 2019, Paolo Bonzini wrote:
> >> On 15/10/19 12:48, Jianyong Wu wrote:
> >>>  
> >>>
> >>
> >> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > You're sure about having reviewed that in detail?
> 
> I did review the patch; the void* ugliness is not in this one, and I do
> have some other qualms on that one.
> 
> > This changelog is telling absolutely nothing WHY anything outside of the
> > timekeeping core code needs access to the current clocksource. Neither does
> > it tell why it is safe to provide the pointer to random callers.
> 
> Agreed on the changelog, but the pointer to a clocksource is already
> part of the timekeeping external API via struct system_counterval_t.
> get_device_system_crosststamp for example expects a clocksource pointer
> but provides no way to get such a pointer.

That's a completely different beast, really.

The clocksource pointer is handed in by the caller and the core code
validates if the clocksource is the same as the current system clocksource
and not the other way round.

So there is no need for getting that pointer from the core code because the
caller knows already which clocksource needs to be active to make.the whole
cross device timestamp correlation work. And in that case it's the callers
responsibility to ensure that the pointer is valid which is the case for
the current use cases.

From your other reply:

> Why add a global id?  ARM can add it to archdata similar to how x86 has
> vclock_mode.  But I still think the right thing to do is to include the
> full system_counterval_t in the result of ktime_get_snapshot.  (More in
> a second, feel free to reply to the other email only).

No, the clocksource pointer is not going to be exposed as there is no
guarantee that it will be still around after the call returns.

It's not even guaranteed to be correct when the store happens in Wu's patch
simply because the store is done outside of the seqcount protected region.

Vs. arch data: arch data is an opaque struct, so you'd need to store a
pointer which has the same issue as the clocksource pointer itself.

If we want to convey information then it has to be in the generic part
of struct clocksource.

In fact we could even simplify the existing get_device_system_crosststamp()
use case by using the ID field.

Thanks,

	tglx
