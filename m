Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268FA5A831B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiHaQZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiHaQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:24:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDD1B4B0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 09:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=LZNB626UwmuzbNhucYaYdWbkevcI435CJoyMikA1Zx8=; b=Z3
        yQ1WRFe86gX1Oz/dRnDaIDoOfKzi9tJVUBhfwJLuUjgUOzk194saOve20fpej7CeBmKVtjCDxSwmz
        Tah36xznzA2VSV6MJKG99kIAy56/GoQYE+ahBj35k8y7ccqRDz/zhVCbhcawMNrrNQkbOsAZaS5D/
        qaaBnok03n7wDto=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTQWJ-00FDWo-0I; Wed, 31 Aug 2022 18:24:51 +0200
Date:   Wed, 31 Aug 2022 18:24:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <Yw+LUq3dii2q1FKQ@lunn.ch>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <Yw9qO+3WqqTUAsIG@lunn.ch>
 <79e46d59-436c-ca82-cad4-15c3cb13b1cf@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79e46d59-436c-ca82-cad4-15c3cb13b1cf@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 04:21:47PM +0200, Csókás Bence wrote:
> 
> On 2022. 08. 31. 16:03, Andrew Lunn wrote:
> > > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > > index b0d60f898249..98d8f8d6034e 100644
> > > --- a/drivers/net/ethernet/freescale/fec_main.c
> > > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > > @@ -2029,6 +2029,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
> > >   {
> > >   	struct fec_enet_private *fep = netdev_priv(ndev);
> > >   	int ret;
> > > +	unsigned long flags;
> > 
> > Please keep to reverse christmas tree
> 
> checkpatch didn't tell me that was a requirement... Easy to fix though.

checkpatch does not have the smarts to detect this. And it is a netdev
only thing.

> 
> > >   	if (enable) {
> > >   		ret = clk_prepare_enable(fep->clk_enet_out);
> > > @@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
> > >   			return ret;
> > >   		if (fep->clk_ptp) {
> > > -			mutex_lock(&fep->ptp_clk_mutex);
> > > +			spin_lock_irqsave(&fep->ptp_clk_lock, flags);
> > 
> > Is the ptp hardware accessed in interrupt context? If not, you can use
> > a plain spinlock, not _irqsave..
> 
> `fec_suspend()` calls `fec_enet_clk_enable()`, which may be a
> non-preemptible context, I'm not sure how the PM subsystem's internals
> work...
> Besides, with the way this driver is built, function call dependencies all
> over the place, I think it's better safe than sorry. I don't think there is
> any disadvantage (besides maybe a few lost cycles) of using _irqsave in
> regular process context anyways.

Those using real time will probably disagree.

There is also a different between not being able to sleep, and not
being able to process an interrupt for some other hardware. You got a
report about taking a mutex in atomic context. That just means you
cannot sleep, probably because a spinlock is held. That is very
different to not being able to handle interrupts. You only need
spin_lock_irqsave() if the interrupt handler also needs the same spin
lock to protect it from a thread using the spin lock.

     Andrew
