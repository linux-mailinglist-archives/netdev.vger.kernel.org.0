Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3757B1376C1
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgAJTNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:13:49 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59519 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgAJTNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:13:49 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ipzif-0003It-LL; Fri, 10 Jan 2020 20:13:17 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 067A6105BDB; Fri, 10 Jan 2020 20:13:16 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw@amazon.co.uk, fllinden@amazon.com, anchalag@amazon.com
Subject: Re: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during shutdown PIRQs
In-Reply-To: <20200109234050.GA26381@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Date:   Fri, 10 Jan 2020 20:13:16 +0100
Message-ID: <87zhevrupf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anchal,

Anchal Agarwal <anchalag@amazon.com> writes:
> On Thu, Jan 09, 2020 at 01:07:27PM +0100, Thomas Gleixner wrote:
>> Anchal Agarwal <anchalag@amazon.com> writes:
>> So either you can handle it purely on the XEN side without touching any
>> core state or you need to come up with some way of letting the core code
>> know that it should invoke shutdown instead of disable.
>> 
>> Something like the completely untested patch below.
>
> Understandable. Really appreciate the patch suggestion below and i will test it
> for sure and see if things can be fixed properly in irq core if thats the only
> option. In the meanwhile, I tried to fix it on xen side unless it gives you the 
> same feeling as above? MSI-x are just fine, just ioapic ones don't get any event
> channel asssigned hence enable_dynirq does nothing. Those needs to be restarted.
>
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index 1bb0b522d004..2ed152f35816 100644
> --- a/drivers/xen/events/events_base.c
>     +++ b/drivers/xen/events/events_base.c
> @@ -575,6 +575,11 @@ static void shutdown_pirq(struct irq_data *data)
>
> static void enable_pirq(struct irq_data *data)
> {
>     +/*ioapic interrupts don't get event channel assigned
>        + * after being explicitly shutdown during guest
>        + * hibernation. They need to be restarted*/
>         +       if(!evtchn_from_irq(data->irq))
>         +               startup_pirq(data);
>     enable_dynirq(data);
>  }

Interesting patch format :)

Doing the shutdown from syscore_ops and the startup conditionally in a
totaly unrelated function is not really intuitive.

So either you do it symmetrically in XEN via syscore_ops callbacks or
you let the irq core code help you out with the patch I provided

Thanks,

        tglx
