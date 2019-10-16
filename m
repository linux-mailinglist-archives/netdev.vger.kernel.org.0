Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9301D8978
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389093AbfJPHcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:32:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48478 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389039AbfJPHcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:32:12 -0400
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKdmp-0007Pm-FE; Wed, 16 Oct 2019 09:31:59 +0200
Date:   Wed, 16 Oct 2019 09:31:58 +0200 (CEST)
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
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
In-Reply-To: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Message-ID: <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com> <20191015104822.13890-5-jianyong.wu@arm.com> <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
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
> On 15/10/19 12:48, Jianyong Wu wrote:
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index 07e57a49d1e8..3597f1f27b10 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
> >  }
> >  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
> >  #endif
> > +
> > +bool is_arm_arch_counter(void *cs)
> > +{
> > +	return (struct clocksource *)cs == &clocksource_counter;
> > +}
> 
> As Thomas pointed out, any reason to have a void * here?
> 
> However, since he didn't like modifying the struct, here is an
> alternative idea:
> 
> 1) add a "struct clocksource*" argument to ktime_get_snapshot
> 
> 2) return -ENODEV if the argument is not NULL and is not the current
> clocksource
> 
> 3) move the implementation of the hypercall to
> drivers/clocksource/arm_arch_timer.c, so that it can call
> ktime_get_snapshot(&systime_snapshot, &clocksource_counter);

And then you implement a gazillion of those functions for every
arch/subarch which has a similar requirement. Pointless exercise.

Having the ID is trivial enough and the storage space is not really a
concern.

Thanks,

	tglx
