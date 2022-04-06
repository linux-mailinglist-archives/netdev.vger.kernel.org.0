Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3024F6A25
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiDFTne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiDFTmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97981C406E;
        Wed,  6 Apr 2022 10:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0795861796;
        Wed,  6 Apr 2022 17:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A300C385A3;
        Wed,  6 Apr 2022 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649266659;
        bh=bpDgwVWgqWxQmXWwc8z4sIx4n3bXklA9WQn3ToGtua0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qJ0OPgYz2en16Cb6KjTTO1vcQakxQVom/xBJn6/4fTGmrzYNSaSDNAu/uMGKlXDYe
         rOZ2LWqIgdDdv8EugIw/di9g+0s8Dzt/BZC92UBokEnSqSoJn6aWiNqrp2WUyOywnX
         ve0RJLb/MmLHq2pyj5hWblthjBaIfDxuFKRFgwq9T57QsN+qUOf5rELD1SBZ47CZ5e
         +Y03v9+HA7Wgt5B+YIRO++B5e1Q3xWvtu8UXdZAQnKVdJM3qr5sthboNUQMnhdfgmD
         nqiecUyUa9w8BKv/uR6UVv+HU/QKKli1Ldm89rjWL4E4TKe8pvV2AsOUlEjHYXBGFm
         IOuyuUWFdCHew==
Date:   Wed, 6 Apr 2022 10:37:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <michael@walle.cc>
Subject: Re: [PATCH net-next v3 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220406103738.42a37033@kernel.org>
In-Reply-To: <20220406112115.6kira24azizz6z2b@soft-dev3-1.localhost>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
        <20220404130655.4004204-4-horatiu.vultur@microchip.com>
        <20220405211230.4a1a868d@kernel.org>
        <20220406112115.6kira24azizz6z2b@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 13:21:15 +0200 Horatiu Vultur wrote:
> > > +static int lan966x_fdma_tx_alloc(struct lan966x_tx *tx)
> > > +{
> > > +     struct lan966x *lan966x = tx->lan966x;
> > > +     struct lan966x_tx_dcb *dcb;
> > > +     struct lan966x_db *db;
> > > +     int size;
> > > +     int i, j;
> > > +
> > > +     tx->dcbs_buf = kcalloc(FDMA_DCB_MAX, sizeof(struct lan966x_tx_dcb_buf),
> > > +                            GFP_ATOMIC);
> > > +     if (!tx->dcbs_buf)
> > > +             return -ENOMEM;
> > > +
> > > +     /* calculate how many pages are needed to allocate the dcbs */
> > > +     size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
> > > +     size = ALIGN(size, PAGE_SIZE);
> > > +     tx->dcbs = dma_alloc_coherent(lan966x->dev, size, &tx->dma, GFP_ATOMIC);  
> > 
> > This functions seems to only be called from probe, so GFP_KERNEL
> > is better.  
> 
> But in the next patch of this series will be called while holding
> the lan966x->tx_lock. Should I still change it to GFP_KERNEL and then
> in the next one will change to GFP_ATOMIC?

Ah, I missed that. You can keep the GFP_ATOMIC then.

But I think the reconfig path may be racy. You disable Rx, but don't
disable napi. NAPI may still be running and doing Rx while you're
trying to free the rx skbs, no?

Once napi is disabled you can disable Tx and then you have full
ownership of the Tx side, no need to hold the lock during
lan966x_fdma_tx_alloc(), I'd think.

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
> > > +             return NETDEV_TX_BUSY;
> > > +     }
> > > +
> > > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> > > +             dev->stats.tx_dropped++;
> > > +             return NETDEV_TX_OK;
> > > +     }
> > > +
> > > +     /* skb processing */
> > > +     needed_headroom = max_t(int, IFH_LEN * sizeof(u32) - skb_headroom(skb), 0);
> > > +     needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
> > > +     if (needed_headroom || needed_tailroom || skb_header_cloned(skb)) {
> > > +             err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
> > > +                                    GFP_ATOMIC);
> > > +             if (unlikely(err)) {
> > > +                     dev->stats.tx_dropped++;
> > > +                     err = NETDEV_TX_OK;
> > > +                     goto release;
> > > +             }
> > > +     }
> > > +
> > > +     skb_tx_timestamp(skb);  
> > 
> > This could move down after the dma mapping, so it's closer to when
> > the devices gets ownership.  
> 
> The problem is that, if I move this lower, then the SKB is changed
> because the IFH is added to the frame. So now if we do timestamping in
> the PHY then when we call classify inside 'skb_clone_tx_timestamp'
> will always return PTP_CLASS_NONE so the PHY will never get the frame.
> That is the reason why I have move it back.

Oh, I see, makes sense!
