Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A631379E5
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgAJW5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:57:46 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:22294 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgAJW5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 17:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578697066; x=1610233066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0/XyXQpWFUZzSlB5MOZhzOIMG1mqXg6xXgJUXUnoc4g=;
  b=HpRg7L6kyY/tKCOEId024b+rJs8qBdmWTDPeKeajS6C+xVxJM0KM8g9w
   8wYn+RUQoEm00vlqTQy1qzKE9ly6VTRC7Lr0ybTjhY1zazIvqikAn1K7Z
   4pYQZ5gxdvjh5F834nEp6nXq1hj+6R1Qgf2EFH8jD+pTZhJABZHnCqICj
   Q=;
IronPort-SDR: 2zGeJmxU96KHcs6bmGOD93XlxOI4/U243ne6e0sIsBwLScQ5y97tciYM9GQN4g5euRqgKW5Nhv
 ZWFxOJ+lIK8Q==
X-IronPort-AV: E=Sophos;i="5.69,418,1571702400"; 
   d="scan'208";a="19431249"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 10 Jan 2020 22:57:35 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 351E7A2B10;
        Fri, 10 Jan 2020 22:57:33 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 22:57:18 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 22:57:18 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 10 Jan 2020 22:57:17 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 0FA4940E65; Fri, 10 Jan 2020 22:57:18 +0000 (UTC)
Date:   Fri, 10 Jan 2020 22:57:18 +0000
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
        <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during
 shutdown PIRQs
Message-ID: <20200110225718.GA13573@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200109234050.GA26381@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <87zhevrupf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87zhevrupf.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 08:13:16PM +0100, Thomas Gleixner wrote:
> Anchal,
> 
> Anchal Agarwal <anchalag@amazon.com> writes:
> > On Thu, Jan 09, 2020 at 01:07:27PM +0100, Thomas Gleixner wrote:
> >> Anchal Agarwal <anchalag@amazon.com> writes:
> >> So either you can handle it purely on the XEN side without touching any
> >> core state or you need to come up with some way of letting the core code
> >> know that it should invoke shutdown instead of disable.
> >> 
> >> Something like the completely untested patch below.
> >
> > Understandable. Really appreciate the patch suggestion below and i will test it
> > for sure and see if things can be fixed properly in irq core if thats the only
> > option. In the meanwhile, I tried to fix it on xen side unless it gives you the 
> > same feeling as above? MSI-x are just fine, just ioapic ones don't get any event
> > channel asssigned hence enable_dynirq does nothing. Those needs to be restarted.
> >
> > diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> > index 1bb0b522d004..2ed152f35816 100644
> > --- a/drivers/xen/events/events_base.c
> >     +++ b/drivers/xen/events/events_base.c
> > @@ -575,6 +575,11 @@ static void shutdown_pirq(struct irq_data *data)
> >
> > static void enable_pirq(struct irq_data *data)
> > {
> >     +/*ioapic interrupts don't get event channel assigned
> >        + * after being explicitly shutdown during guest
> >        + * hibernation. They need to be restarted*/
> >         +       if(!evtchn_from_irq(data->irq))
> >         +               startup_pirq(data);
> >     enable_dynirq(data);
> >  }
> 
> Interesting patch format :)
Apparently vim and me rushing through the email [did not format the patch]
were the culprit and I only caught it after sending an email
> 
> Doing the shutdown from syscore_ops and the startup conditionally in a
> totaly unrelated function is not really intuitive.
> 
I agree to the point that still the startup is not as synchronous 
to shutdown however, enable_pirq is still invoked during irq_startup
for xen specific code and I was trying to reuse the code path to fix 
within xen. Basically borrowing from what this commit [commit 020db9d3]
changed. Not sure if this could have broken under any other environment
though :(

But anyways I think the patch you suggested is much more clean and 
intuitive.

> So either you do it symmetrically in XEN via syscore_ops callbacks or
> you let the irq core code help you out with the patch I provided
> 
In my understanding, it may not be the right thing as syscore stuff runs
with one cpu online and disabled interrupts. Also I did try it in the past 
and failed horribly unless there is any smarter way of doing it.
It should correctly be done in suspend/resume devices as are other device 
interrupts.

I did test the patch you suggested and it works.
I haven't done large scale testing but it looks like it may just work fine.
I will send out an updated patch for shutdown/startup of pirq after I do some
more testing and will drop patches related to shutdown/startup of pirqs from 
the original series.

Thanks,

Anchal

> Thanks,
> 
>         tglx
