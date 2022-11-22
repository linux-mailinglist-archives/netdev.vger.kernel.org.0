Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D33634955
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiKVVdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiKVVde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:33:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6627563C8;
        Tue, 22 Nov 2022 13:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669152810; x=1700688810;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gQLYFE9yrtCRIlwnJaL8HjMOwsIq8XHj+3zGHKQH5T4=;
  b=yavj+fca+TO7K3GC3RwC3CEwcYcNGZd7I2ld+bb+9gQqHQfwxQNJBXQk
   aUmqSf3WuFzUMN9EyKd/c5lL6TugjLg7ooONy/eMU6saeFFmySK76o5Nx
   VkHxioqNwnCQIidespof6JarfprpTrPOCxsOfb42FIpRZ0suPO/wApZbx
   +HLdnA+swEItJ063id9c7ndjgRO6fEeIJBdsxCv/tOY6VCGiJ7v6DPZ8K
   HCdwQOicIQMtvf4u2YE+S5eKYh0SUOoL0DgDapaLLvX/AJV2bxQPXsvFQ
   /XD65VNDrnhi3LibkXUqLDSBqRb03Fm0QRldDk3ShY3fVZxpXQWHPnf9W
   A==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="201007222"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:33:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:33:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 22 Nov 2022 14:33:29 -0700
Date:   Tue, 22 Nov 2022 22:38:20 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 6/7] net: lan966x: Add support for XDP_TX
Message-ID: <20221122213820.zf5iy6shjekpvzeu@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
 <20221121212850.3212649-7-horatiu.vultur@microchip.com>
 <20221122165646.428674-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221122165646.428674-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 17:56, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 21 Nov 2022 22:28:49 +0100
> 
> > Extend lan966x XDP support with the action XDP_TX. In this case when the
> > received buffer needs to execute XDP_TX, the buffer will be moved to the
> > TX buffers. So a new RX buffer will be allocated.
> > When the TX finish with the frame, it would give back the buffer to the
> > page pool.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 78 +++++++++++++++++--
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  4 +-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  8 ++
> >  .../ethernet/microchip/lan966x/lan966x_xdp.c  |  8 ++
> >  4 files changed, 90 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > index f8287a6a86ed5..b14fdb8e15e22 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > @@ -411,12 +411,18 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
> >               dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
> >
> >               dcb_buf->used = false;
> > -             dma_unmap_single(lan966x->dev,
> > -                              dcb_buf->dma_addr,
> > -                              dcb_buf->len,
> > -                              DMA_TO_DEVICE);
> > -             if (!dcb_buf->ptp)
> > -                     dev_kfree_skb_any(dcb_buf->skb);
> > +             if (dcb_buf->skb) {
> > +                     dma_unmap_single(lan966x->dev,
> > +                                      dcb_buf->dma_addr,
> > +                                      dcb_buf->len,
> > +                                      DMA_TO_DEVICE);
> > +
> > +                     if (!dcb_buf->ptp)
> > +                             dev_kfree_skb_any(dcb_buf->skb);
> 
> Damn, forgot to remind you you wanted to switch to
> napi_consume_skb() :s

Correct, I forgot to update this. Will do in the next series.

> 
> > +             }
> > +
> > +             if (dcb_buf->xdpf)
> > +                     xdp_return_frame_rx_napi(dcb_buf->xdpf);
> >
> >               clear = true;
> >       }
> 
> [...]
> 
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
