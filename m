Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941482944F6
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410397AbgJTWKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:10:47 -0400
Received: from kernel.crashing.org ([76.164.61.194]:43522 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393563AbgJTWKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:10:47 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09KMA9S4006827
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 20 Oct 2020 17:10:14 -0500
Message-ID: <32bfb619bbb3cd6f52f9e5da205673702fed228f.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Joel Stanley <joel@jms.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Date:   Wed, 21 Oct 2020 09:10:02 +1100
In-Reply-To: <CAK8P3a2pEfbLDWTppVHmGxXduOWPCwBw-8bMY9h3EbEecsVfTA@mail.gmail.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
         <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
         <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
         <CAK8P3a2pEfbLDWTppVHmGxXduOWPCwBw-8bMY9h3EbEecsVfTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-20 at 21:49 +0200, Arnd Bergmann wrote:
> On Tue, Oct 20, 2020 at 11:37 AM Dylan Hung <dylan_hung@aspeedtech.com> wrote:
> > > +1 @first is system memory from dma_alloc_coherent(), right?
> > > 
> > > You shouldn't have to do this. Is coherent DMA memory broken on your
> > > platform?
> > 
> > It is about the arbitration on the DRAM controller.  There are two queues in the dram controller, one is for the CPU access and the other is for the HW engines.
> > When CPU issues a store command, the dram controller just acknowledges cpu's request and pushes the request into the queue.  Then CPU triggers the HW MAC engine, the HW engine starts to fetch the DMA memory.
> > But since the cpu's request may still stay in the queue, the HW engine may fetch the wrong data.

Actually, I take back what I said earlier, the above seems to imply
this is more generic.

Dylan, please confirm, does this affect *all* DMA capable devices ? If
yes, then it's a really really bad design bug in your chips
unfortunately and the proper fix is indeed to make dma_wmb() do a dummy
read of some sort (what address though ? would any dummy non-cachable
page do ?) to force the data out as *all* drivers will potentially be
affected.

I was under the impression that it was a specific timing issue in the
vhub and ethernet parts, but if it's more generic then it needs to be
fixed globally.

> There is still something missing in the explanation: The iowrite32()
> only tells the
> device that it should check the queue, but not where the data is. I would expect
> the device to either see the correct data that was marked valid by the
> 'dma_wmb();first->txdes0 = cpu_to_le32(f_ctl_stat);' operation, or it would see
> the old f_ctl_stat value telling it that the data is not yet valid and
> not look at
> the rest of the descriptor. In the second case you would see the data
> not getting sent out until the next start_xmit(), but the device should not
> fetch wrong data.
> 
> There are two possible scenarios in which your patch would still help:
> 
> a) the dma_wmb() does not serialize the stores as seen by DMA the
>     way it is supposed to, so the device can observe the new value of txdec0
>     before it observes the correct data.
> 
> b) The txdes0 field sometimes contains stale data that marks the
>     descriptor as valid before the correct data is written. This field
>     should have been set in ftgmac100_tx_complete_packet() earlier
> 
> If either of the two is the case, then the READ_ONCE() would just
> introduce a long delay before the iowrite32() that makes it more likely
> that the data is there, but the inconsistent state would still be observable
> by the device if it is still working on previous frames.

I think it just get stuck until we try another packet, ie, it doesn't
see the new descriptor valid bit. But Dylan can elaborate.

Cheers,
Ben.


