Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E483634902
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiKVVQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiKVVQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:16:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457277ECAC;
        Tue, 22 Nov 2022 13:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669151804; x=1700687804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AoSk1LdnIylG0DPSz7XZuAL8ZEvRhiDb7mlPOtg7dIE=;
  b=2oYRZjyoCApteHQqs0zNQlkF78ZCGMbqfRhvlKF348HnVmMlJ9oWFtmz
   BbD5NIqVx8nBwJi9tOf1AKKuQV08u16Q2o3Ma7QdhDInHR/l4+6d7G87q
   /RehgW4+RiRf8lnu0okw+SMF52WvwkO1m9p06UwMAL+Ke/dTbOieZA26K
   v5gd5ZrUTQHBSGK/V4SKfdXSE17UhqcG/DZ0C/neT4RbSErjBvqf5nPsr
   mrHggxbAQor8g7k+iclxBc86zpMOQ8CL5f3vU45zzmrX+wHYI91NmtsDC
   Oenmbl+wmp1JOZN95Iwo1Ka1/IeShAyNO5zb2FE66SbXTWMDyKc1orzA3
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="184745596"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:16:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:16:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 22 Nov 2022 14:16:33 -0700
Date:   Tue, 22 Nov 2022 22:21:24 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 3/7] net: lan966x: Add len field to
 lan966x_tx_dcb_buf
Message-ID: <20221122212124.zzf7nthbkzjdnssb@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
 <20221121212850.3212649-4-horatiu.vultur@microchip.com>
 <20221122113022.418632-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221122113022.418632-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 12:30, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 21 Nov 2022 22:28:46 +0100
> 
> > Currently when a frame was transmitted, it is required to unamp the
> > frame that was transmitted. The length of the frame was taken from the
> > transmitted skb. In the future we might not have an skb, therefore store
> > the length skb directly in the lan966x_tx_dcb_buf and use this one to
> > unamp the frame.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 +++--
> >  drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > index 94c720e59caee..384ed34197d58 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > @@ -391,12 +391,12 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
> >                       continue;
> >
> >               dcb_buf->dev->stats.tx_packets++;
> > -             dcb_buf->dev->stats.tx_bytes += dcb_buf->skb->len;
> > +             dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
> >
> >               dcb_buf->used = false;
> >               dma_unmap_single(lan966x->dev,
> >                                dcb_buf->dma_addr,
> > -                              dcb_buf->skb->len,
> > +                              dcb_buf->len,
> >                                DMA_TO_DEVICE);
> >               if (!dcb_buf->ptp)
> >                       dev_kfree_skb_any(dcb_buf->skb);
> > @@ -709,6 +709,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> >       /* Fill up the buffer */
> >       next_dcb_buf = &tx->dcbs_buf[next_to_use];
> >       next_dcb_buf->skb = skb;
> > +     next_dcb_buf->len = skb->len;
> >       next_dcb_buf->dma_addr = dma_addr;
> >       next_dcb_buf->used = true;
> >       next_dcb_buf->ptp = false;
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index bc93051aa0798..7bb9098496f60 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -175,6 +175,7 @@ struct lan966x_rx {
> >  struct lan966x_tx_dcb_buf {
> >       struct net_device *dev;
> >       struct sk_buff *skb;
> > +     int len;
> 
> Nit: perhaps you can define it as `u32` since fram length can't be
> negative?

The length is always positive. I will update this in the next version.

> 
> >       dma_addr_t dma_addr;
> 
> Oh, also, on platforms with 64-bit addressing, `int len` placed in
> between ::skb and ::dma_addr would create a 4-byte hole in the
> structure. Placing `len` after ::dma_addr would make it holeless on
> any architercture.

Thanks for the suggestion.
I will make sure that lan966x_tx_dcb_buf will not have any holes. In
this patch I will arrange the members and in the next patches where
I will modify the struct, I will add them at the right place.

> 
> >       bool used;
> >       bool ptp;
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
