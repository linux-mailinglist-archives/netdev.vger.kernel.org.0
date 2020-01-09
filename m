Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194C31363F1
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgAIXla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:41:30 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42406 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIXl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578613289; x=1610149289;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LiHQ8qEhETcU1o1tFdPT/fMQUvDHkHslEbbbNaaN0PY=;
  b=c6ABK6YOpTF7Dy10+d9dwICsX2f8AHcDH9A/isOYjkVWBcgCMAfD/4S8
   47wIbtr2fTo8DZRMsrmPLQWH+1rM61wHW8HzvesUo2VDxtMduw/E1kCSz
   uNfaA2i6nkMPLFXHvhgTTHG6k1xEE8IeO5ChyiXq77tBH/zBBXdtj2/+d
   w=;
IronPort-SDR: jHEDBPr9SL5BiUmabpwOch0UFlE9qQMViRBXLXTpTO7Wso2aBS5JvdybsjtJ66EqP5r/G+aUFy
 nldKxNLQgv5A==
X-IronPort-AV: E=Sophos;i="5.69,414,1571702400"; 
   d="scan'208";a="19232911"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 09 Jan 2020 23:41:17 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 2109CA2B10;
        Thu,  9 Jan 2020 23:41:09 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 9 Jan 2020 23:40:51 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 9 Jan 2020 23:40:51 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Thu, 9 Jan 2020 23:40:51 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id AF38540E7A; Thu,  9 Jan 2020 23:40:50 +0000 (UTC)
Date:   Thu, 9 Jan 2020 23:40:50 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.co>, <roger.pau@citrix.com>, <axboe@kernel.dk>,
        <davem@davemloft.net>, <rjw@rjwysocki.net>, <len.brown@intel.com>,
        <pavel@ucw.cz>, <peterz@infradead.org>, <eduval@amazon.com>,
        <sblbir@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <fllinden@amazon.com>, <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during
 shutdown PIRQs
Message-ID: <20200109234050.GA26381@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107234420.GA18738@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <877e22ezv6.fsf@nanos.tec.linutronix.de>
 <20200108212417.GA22381@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <874kx4omtc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <874kx4omtc.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 01:07:27PM +0100, Thomas Gleixner wrote:
> Anchal Agarwal <anchalag@amazon.com> writes:
> > On Wed, Jan 08, 2020 at 04:23:25PM +0100, Thomas Gleixner wrote:
> >> Anchal Agarwal <anchalag@amazon.com> writes:
> >> > +void irq_state_clr_started(struct irq_desc *desc)
> >> >  {
> >> >  	irqd_clear(&desc->irq_data, IRQD_IRQ_STARTED);
> >> >  }
> >> > +EXPORT_SYMBOL_GPL(irq_state_clr_started);
> >> 
> >> This is core internal state and not supposed to be fiddled with by
> >> drivers.
> >> 
> >> irq_chip has irq_suspend/resume/pm_shutdown callbacks for a reason.
> >>
> > I agree, as its mentioned in the previous patch {[RFC PATCH V2 08/11]} this is 
> > one way of explicitly shutting down legacy devices without introducing too much 
> > code for each of the legacy devices. . for eg. in case of floppy there 
> > is no suspend/freeze handler which should have done the needful.
> > .
> > Either we implement them for all the legacy devices that have them missing or
> > explicitly shutdown pirqs. I have choosen later for simplicity. I understand
> > that ideally we should enable/disable devices interrupts in suspend/resume 
> > devices but that requires adding code for doing that to few drivers[and I may
> > not know all of them either]
> >
> > Now I discovered during the flow in hibernation_platform_enter under resume 
> > devices that for such devices irq_startup is called which checks for 
> > IRQD_IRQ_STARTED flag and based on that it calls irq_enable or irq_startup.
> > They are only restarted if the flag is not set which is cleared during shutdown. 
> > shutdown_pirq does not do that. Only masking/unmasking of evtchn does not work 
> > as pirq needs to be restarted.
> > xen-pirq.enable_irq is called rather than stratup_pirq. On resume if these pirqs
> > are not restarted in this case ACPI SCI interrupts, I do not see receiving 
> > any interrupts under cat /proc/interrupts even though host keeps generating 
> > S4 ACPI events. 
> > Does that makes sense?
> 
> No. You still violate all abstraction boundaries. On one hand you use a
> XEN specific suspend function to shut down interrupts, but then you want
> the core code to reestablish them on resume. That's just bad hackery which
> abuses partial knowledge of core internals. The state flag is only one
> part of the core internal state and just clearing it does not make the
> rest consistent. It just works by chance and not by design and any
> change of the core code will break it in colourful ways.
> 
> So either you can handle it purely on the XEN side without touching any
> core state or you need to come up with some way of letting the core code
> know that it should invoke shutdown instead of disable.
> 
> Something like the completely untested patch below.
> 
> Thanks,
> 
>        tglx
Understandable. Really appreciate the patch suggestion below and i will test it
for sure and see if things can be fixed properly in irq core if thats the only
option. In the meanwhile, I tried to fix it on xen side unless it gives you the 
same feeling as above? MSI-x are just fine, just ioapic ones don't get any event
channel asssigned hence enable_dynirq does nothing. Those needs to be restarted.

Thanks,
Anchal

<-----------------------

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 1bb0b522d004..2ed152f35816 100644
--- a/drivers/xen/events/events_base.c
    +++ b/drivers/xen/events/events_base.c
@@ -575,6 +575,11 @@ static void shutdown_pirq(struct irq_data *data)

static void enable_pirq(struct irq_data *data)
{
    +/*ioapic interrupts don't get event channel assigned
       + * after being explicitly shutdown during guest
       + * hibernation. They need to be restarted*/
        +       if(!evtchn_from_irq(data->irq))
        +               startup_pirq(data);
    enable_dynirq(data);
 }

> 
> 8<----------------
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 7853eb9301f2..50f2057bc339 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -511,6 +511,7 @@ struct irq_chip {
>   * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
>   * IRQCHIP_SUPPORTS_LEVEL_MSI	Chip can provide two doorbells for Level MSIs
>   * IRQCHIP_SUPPORTS_NMI:	Chip can deliver NMIs, only for root irqchips
> + * IRQCHIP_SHUTDOWN_ON_SUSPEND:	Shutdown non wake irqs in the suspend path
>   */
>  enum {
>  	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
> @@ -522,6 +523,7 @@ enum {
>  	IRQCHIP_EOI_THREADED		= (1 <<  6),
>  	IRQCHIP_SUPPORTS_LEVEL_MSI	= (1 <<  7),
>  	IRQCHIP_SUPPORTS_NMI		= (1 <<  8),
> +	IRQCHIP_SHUTDOWN_ON_SUSPEND	= (1 <<  9),
>  };
>  
>  #include <linux/irqdesc.h>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index b3fa2d87d2f3..0fe355f72a15 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -233,7 +233,7 @@ __irq_startup_managed(struct irq_desc *desc, struct cpumask *aff, bool force)
>  }
>  #endif
>  
> -static int __irq_startup(struct irq_desc *desc)
> +int __irq_startup(struct irq_desc *desc)
>  {
>  	struct irq_data *d = irq_desc_get_irq_data(desc);
>  	int ret = 0;
> diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
> index 3924fbe829d4..11c7c55bda63 100644
> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -80,6 +80,7 @@ extern void __enable_irq(struct irq_desc *desc);
>  extern int irq_activate(struct irq_desc *desc);
>  extern int irq_activate_and_startup(struct irq_desc *desc, bool resend);
>  extern int irq_startup(struct irq_desc *desc, bool resend, bool force);
> +extern int __irq_startup(struct irq_desc *desc);
>  
>  extern void irq_shutdown(struct irq_desc *desc);
>  extern void irq_shutdown_and_deactivate(struct irq_desc *desc);
> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index 8f557fa1f4fe..597f0602510a 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -85,16 +85,22 @@ static bool suspend_device_irq(struct irq_desc *desc)
>  	}
>  
>  	desc->istate |= IRQS_SUSPENDED;
> -	__disable_irq(desc);
> -
> -	/*
> -	 * Hardware which has no wakeup source configuration facility
> -	 * requires that the non wakeup interrupts are masked at the
> -	 * chip level. The chip implementation indicates that with
> -	 * IRQCHIP_MASK_ON_SUSPEND.
> -	 */
> -	if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
> -		mask_irq(desc);
> +
> +	/* Some irq chips (e.g. XEN PIRQ) require a full shutdown on suspend */
> +	if (irq_desc_get_chip(desc)->flags & IRQCHIP_SHUTDOWN_ON_SUSPEND) {
> +		irq_shutdown(desc);
> +	} else {
> +		__disable_irq(desc);
> +
> +		/*
> +		 * Hardware which has no wakeup source configuration facility
> +		 * requires that the non wakeup interrupts are masked at the
> +		 * chip level. The chip implementation indicates that with
> +		 * IRQCHIP_MASK_ON_SUSPEND.
> +		 */
> +		if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
> +			mask_irq(desc);
> +	}
>  	return true;
>  }
>  
> @@ -152,7 +158,10 @@ static void resume_irq(struct irq_desc *desc)
>  	irq_state_set_masked(desc);
>  resume:
>  	desc->istate &= ~IRQS_SUSPENDED;
> -	__enable_irq(desc);
> +	if (irq_desc_get_chip(desc)->flags & IRQCHIP_SHUTDOWN_ON_SUSPEND)
> +		__irq_startup(desc);
> +	else
> +		__enable_irq(desc);
>  }
>  
>  static void resume_irqs(bool want_early)
