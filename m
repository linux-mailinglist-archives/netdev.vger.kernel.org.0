Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51754E4922
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 23:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbiCVW1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 18:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237921AbiCVW1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 18:27:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA5E56217;
        Tue, 22 Mar 2022 15:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380DC60C8F;
        Tue, 22 Mar 2022 22:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA69C340ED;
        Tue, 22 Mar 2022 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647987937;
        bh=Ed0nMIb/RBckBNQpKd5NUVBf2jhmICvp28BlhuI3xbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nq+FuN1atoKl8SfjOIFNVqa0ZoNLbORB99O19R34+IQior+WudfejNM6YcD0Q3Zsx
         ksZlZGVWy3t1RvC2ByrjNCbS12rYTiS3snxtU5PcL2NTDQ8c6wnAaahCeBVkvURwE4
         92FSwL3ZuxZ5J3AYYx8eHjU6tDV66Zs1SCMCzj0QnP+c9c4f1iATceie+TJ7rLSTgF
         +PwQezeFUtPLImmynxffrx3tn60TO0sbtbeKx1oH7Tv7PnDwzvaMjKtuBXAJ3vPNij
         AMcj4ZQsMJaAVotPf5nLARjE7qs261QjktQYkbSGKSRQTIO0Sl3R5CatRi+pZi3o87
         Hh6Lq1Cpip7+Q==
Date:   Tue, 22 Mar 2022 15:25:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220322152536.4460aea2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322210402.ebr2zghcisrqz4ju@soft-dev3-1.localhost>
References: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
        <20220318204750.1864134-4-horatiu.vultur@microchip.com>
        <20220321230123.4d38ad5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220322210402.ebr2zghcisrqz4ju@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Mar 2022 22:04:02 +0100 Horatiu Vultur wrote:
> > > +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> > > +{
> > > +     struct lan966x *lan966x = rx->lan966x;
> > > +     u64 src_port, timestamp;
> > > +     struct sk_buff *new_skb;
> > > +     struct lan966x_db *db;
> > > +     struct sk_buff *skb;
> > > +
> > > +     /* Check if there is any data */
> > > +     db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
> > > +     if (unlikely(!(db->status & FDMA_DCB_STATUS_DONE)))
> > > +             return NULL;
> > > +
> > > +     /* Get the received frame and unmap it */
> > > +     skb = rx->skb[rx->dcb_index][rx->db_index];
> > > +     dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
> > > +                      FDMA_DCB_STATUS_BLOCKL(db->status),
> > > +                      DMA_FROM_DEVICE);
> > > +
> > > +     /* Allocate a new skb and map it */
> > > +     new_skb = lan966x_fdma_rx_alloc_skb(rx, db);
> > > +     if (unlikely(!new_skb))
> > > +             return NULL;  
> > 
> > So how is memory pressure handled, exactly? Looks like it's handled
> > the same as if the ring was empty, so the IRQ is going to get re-raise
> > immediately, or never raised again?  
> 
> That is correct, the IRQ is going to get re-raised.
> But I am not sure that this is correct approach. Do you have any
> suggestions how it should be?

In my experience it's better to let the ring drain and have a service
task kick in some form of refill. Usually when machine is out of memory
last thing it needs is getting stormed by network IRQs. Some form of
back off would be good, at least?

> > > +     return counter;
> > > +}
> > > +
> > > +irqreturn_t lan966x_fdma_irq_handler(int irq, void *args)
> > > +{
> > > +     struct lan966x *lan966x = args;
> > > +     u32 db, err, err_type;
> > > +
> > > +     db = lan_rd(lan966x, FDMA_INTR_DB);
> > > +     err = lan_rd(lan966x, FDMA_INTR_ERR);  
> > 
> > Hm, IIUC you request a threaded IRQ for this. Why?
> > The register accesses can't sleep because you poke
> > them from napi_poll as well...  
> 
> Good point. What about the WARN?

which one? Did something generate a warning without the threaded IRQ?

> > > +int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> > > +{
> > > +     struct lan966x_port *port = netdev_priv(dev);
> > > +     struct lan966x *lan966x = port->lan966x;
> > > +     struct lan966x_tx_dcb_buf *next_dcb_buf;
> > > +     struct lan966x_tx_dcb *next_dcb, *dcb;
> > > +     struct lan966x_tx *tx = &lan966x->tx;
> > > +     struct lan966x_db *next_db;
> > > +     int needed_headroom;
> > > +     int needed_tailroom;
> > > +     dma_addr_t dma_addr;
> > > +     int next_to_use;
> > > +     int err;
> > > +
> > > +     /* Get next index */
> > > +     next_to_use = lan966x_fdma_get_next_dcb(tx);
> > > +     if (next_to_use < 0) {
> > > +             netif_stop_queue(dev);
> > > +             err = NETDEV_TX_BUSY;
> > > +             goto out;
> > > +     }
> > > +
> > > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> > > +             dev->stats.tx_dropped++;  
> > 
> > It's preferred not to use the old dev->stats, but I guess you already
> > do so :( This is under some locks, right? No chance for another queue
> > or port to try to touch those stats at the same time?  
> 
> What is the preffered way of doing it?
> Yes, it is under a lock.

Drivers can put counters they need in their own structures and then
implement ndo_get_stats64 to copy it to the expected format.
If you have locks and there's no risk of races - I guess it's fine.
Unlikely we'll ever convert all the drivers, anyway.
