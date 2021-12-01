Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74333464AA9
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 10:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242392AbhLAJdJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Dec 2021 04:33:09 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47979 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbhLAJdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:33:08 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id D017E1C0008;
        Wed,  1 Dec 2021 09:29:42 +0000 (UTC)
Date:   Wed, 1 Dec 2021 10:29:26 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Message-ID: <20211201102926.3eacd95e@fixe.home>
In-Reply-To: <20211129174038.gptbivgmbqzrrgtz@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-5-clement.leger@bootlin.com>
 <20211127145805.75qh2vim7c5m5hjd@skbuf>
 <20211129091902.0112eb17@fixe.home>
 <20211129174038.gptbivgmbqzrrgtz@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 29 Nov 2021 17:40:39 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Mon, Nov 29, 2021 at 09:19:02AM +0100, Clément Léger wrote:
> > > I'm not sure why you're letting the hardware grind to a halt first,
> > > before refilling? I think since the CPU is the bottleneck anyway, you
> > > can stop the extraction channel at any time you want to refill.
> > > A constant stream of less data might be better than a bursty one.
> > > Or maybe I'm misunderstanding some of the details of the hardware.  
> > 
> > Indeed, I can stop the extraction channel but that does not seems a
> > good idea to stop the channel in a steady state. At least that's what I
> > thought since it will make the receive "window" non predictable. Not
> > sure how well it will play with various protocol but I will try
> > implementing the refill we talked previously (ie when there an
> > available threshold is reached).  
> (...)
> > > I don't understand why you restart the injection channel from the TX
> > > confirmation interrupt. It raised the interrupt to tell you that it hit
> > > a NULL LLP because there's nothing left to send. If you restart it now and
> > > no other transmission has happened in the meantime, won't it stop again?  
> > 
> > Actually, it is only restarted if there is some pending packets to
> > send. With this hardware, packets can't be added while the FDMA is
> > running and it must be stopped everytime we want to add a packet to the
> > list. To avoid that, in the TX path, if the FDMA is stopped, we set the
> > llp of the packet to NULL and start the chan. However, if the FDMA TX
> > channel is running, we don't stop it, we simply add the next packets to
> > the ring. However, the FDMA will stop on the previous NULL LLP. So when
> > we hit a LLP, we might not be at the end of the list. This is why the
> > next check verifies if we hit a NULL LLP and if there is still some
> > packet to send.   
> 
> Oh, is that so? That would be pretty odd if the hardware is so dumb that
> it doesn't detect changes made to an LLP on the go.
> 
> The manual has this to say, and I'm not sure how to interpret it:
> 
> | It is possible to update an active channels LLP pointer and pointers in
> | the DCB chains. Before changing pointers software must schedule the
> | channel for disabling (by writing FDMA_CH_DISABLE.CH_DISABLE[ch]) and
> | then wait for the channel to set FDMA_CH_SAFE.CH_SAFE[ch]. When the
> | pointer update is complete, soft must re-activate the channel by setting
> | FDMA_CH_ACTIVATE.CH_ACTIVATE[ch]. Setting activate will cancel the
> | deactivate-request, or if the channel has disabled itself in the
> | meantime, it will re activate the channel.
> 
> So it is possible to update an active channel's LLP pointer, but not
> while it's active? Thank you very much!

In the manual, this is also stated that:

| The FDMA does not reload the current DCB when re- activated,
| so if the LLP-field of the current DCB is modified, then software must
| also modify FDMA_DCB_LLP[ch].

The FDMA present on the next generation (sparx5) is *almost* the same
but a new RELOAD register has been added and allows adding a DCB at the
end of the linked list without stopping the FDMA, and then simply hit
the RELOAD register to restart it if needed. Unfortunately, this is not
the case for the ocelot one. 

> 
> If true, this will severely limit the termination performance one is
> able to obtain with this switch, even with a faster CPU and PCIe.
> 
> > > > +void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_device *dev)
> > > > +{
> > > > +	dev->needed_headroom = OCELOT_TAG_LEN;
> > > > +	dev->needed_tailroom = ETH_FCS_LEN;    
> > > 
> > > The needed_headroom is in no way specific to FDMA, right? Why aren't you
> > > doing it for manual register-based injection too? (in a separate patch ofc)  
> > 
> > Actually, If I switch to page based ring, This won't be useful anymore
> > because the header will be written directly in the page and not anymore
> > directly in the skb header.  
> 
> I don't understand this comment. You set up the needed headroom and
> tailroom netdev variables to avoid reallocation on TX, not for RX.
> And you use half page buffers for RX, not for TX.

Ok, so indeed, I don't think it is needed for the register-based
injection since the IFH is computed on the stack and pushed word by
word into the fifo separately from the skb data. In the case of the
FDMA, it is read from the start of the DCB DATAL adress so this is why
this is needed. I could also put the IFH in a separate DCB and then
split the data in a next DCB using SOF/EOF flags but I'm not sure it
will be beneficial from a performance point of view. I could try that
since the CPU is slow, it might be better in some case to let the FDMA
handle this instead of usign the CPU to increase the SKB size and
linearize it.

> 
> > > I can't help but think how painful it is that with a CPU as slow as
> > > yours, insult over injury, you also need to check for each packet
> > > whether the device tree had defined the "fdma" region or not, because
> > > you practically keep two traffic I/O implementations due to that sole
> > > reason. I think for the ocelot switchdev driver, which is strictly for
> > > MIPS CPUs embedded within the device, it should be fine to introduce a
> > > static key here (search for static_branch_likely in the kernel).  
> > 
> > I thinked about it *but* did not wanted to add a key since it would be
> > global. However, we could consider that there is always only one
> > instance of the driver and indeed a static key is an option.
> > Unfortunately, I'm not sure this will yield any noticeable performance
> > improvement.  
> 
> What is the concern with a static key in this driver, exactly?

Only that the static key will be global but this driver does not have
anything global. If you have no concern about that, I'm ok to add one.


-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
