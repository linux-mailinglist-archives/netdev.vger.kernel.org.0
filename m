Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2281E636AA6
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiKWUPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiKWUPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:15:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A3556EC8;
        Wed, 23 Nov 2022 12:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669234508; x=1700770508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eSntQzF4q26wzrEFVAJywooKAOI3AAj+06yfqsfV9sw=;
  b=WJgxBiNOlToKBNACKH2VOi1WzQFZOLv+G6el085K3U7OfMW63xXpbgJJ
   IeUgaX48GQo+A+AKzgzr7X/LZhU1d9m1jHt3n5X/QmoaLXZGPsplRyCQq
   qbJeFjfV4H8ClAL4P+JiNO9PsxvNcyO2Wzn5Ff4Cm0tYC7aA+fieVWsS6
   nrf4TYgTG41JMxaORfGOc4iDNibNEUomuf943E85Tc3KgjsKwCTGKNijD
   DxkEQ9MOI+z1e7yuewAh65dmy+J39jrTEJOvCV1XwfYKa/llolLi/4kOr
   5hm2/7Tm+EwKjrIxy1ocicganBjNkCmYk9yZ8Z/6e9X9EKaEymASihDj2
   g==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184920813"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:15:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:15:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 23 Nov 2022 13:15:04 -0700
Date:   Wed, 23 Nov 2022 21:19:55 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v4 6/7] net: lan966x: Add support for XDP_TX
Message-ID: <20221123201955.koaobohzf6kcm4ho@soft-dev3-1>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
 <20221122214413.3446006-7-horatiu.vultur@microchip.com>
 <Y31Mu/hAxrmbn7Ws@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y31Mu/hAxrmbn7Ws@boxer>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 23:27, Maciej Fijalkowski wrote:
> 
> On Tue, Nov 22, 2022 at 10:44:12PM +0100, Horatiu Vultur wrote:
> > Extend lan966x XDP support with the action XDP_TX. In this case when the
> > received buffer needs to execute XDP_TX, the buffer will be moved to the
> > TX buffers. So a new RX buffer will be allocated.
> > When the TX finish with the frame, it would give back the buffer to the
> > page pool.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
...
> >
> >  struct lan966x_port;
> > @@ -176,6 +178,7 @@ struct lan966x_tx_dcb_buf {
> >       dma_addr_t dma_addr;
> >       struct net_device *dev;
> >       struct sk_buff *skb;
> > +     struct xdp_frame *xdpf;
> 
> Couldn't you make an union out of skb and xdpf? I'd say these two are
> mutually exclusive, no? I believe this would simplify some things.

Yes, skb and xdpf are mutually exclusive.
Also Alexander Lobakin mention something similar and I was not sure.
Now that I have tried it I can see it that is more clear that skb and
xdpf are mutually exclusive and also reduce the size of the struct.
So I will update this in the next series.

> 
> >       u32 len;
> >       u32 used : 1;
> >       u32 ptp : 1;
> > @@ -360,6 +363,8 @@ bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
> >
> >  void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
> >  void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
> > +void lan966x_ifh_set_bypass(void *ifh, u64 bypass);
> > +void lan966x_ifh_set_port(void *ifh, u64 bypass);
> >
> >  void lan966x_stats_get(struct net_device *dev,
> >                      struct rtnl_link_stats64 *stats);
> > @@ -460,6 +465,9 @@ u32 lan966x_ptp_get_period_ps(void);
> >  int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
> >
> >  int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
> > +int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> > +                        struct xdp_frame *frame,
> > +                        struct page *page);
> >  int lan966x_fdma_change_mtu(struct lan966x *lan966x);
> >  void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
> >  void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > index a99657154cca4..e7998fef7048c 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > @@ -54,6 +54,7 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
> >  {
> >       struct bpf_prog *xdp_prog = port->xdp_prog;
> >       struct lan966x *lan966x = port->lan966x;
> > +     struct xdp_frame *xdpf;
> >       struct xdp_buff xdp;
> >       u32 act;
> >
> > @@ -66,6 +67,13 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
> >       switch (act) {
> >       case XDP_PASS:
> >               return FDMA_PASS;
> > +     case XDP_TX:
> > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > +             if (!xdpf)
> > +                     return FDMA_DROP;
> 
> I would generally challenge the need for xdp_frame in XDP_TX path. You
> probably would be good to go with calling directly
> page_pool_put_full_page() on cleaning side. This frame is not going to be
> redirected so I don't see the need for carrying additional info. I'm
> bringing this up as I was observing performance improvement on ice driver
> when I decided to operate directly on xdp_buff for XDP_TX.

Thanks for suggestion. I definetly see your point.
I would prefer for now to keep this like it is. Because I think in the
near future I should do a proper investigation to see where the
performance of the FDMA can be improved. And this will
definetly be on the TODO.
> 
> But it's of course up to you.

> 
> > +
> > +             return lan966x_fdma_xmit_xdpf(port, xdpf, page) ?
> > +                    FDMA_DROP : FDMA_TX;
> >       default:
> >               bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
> >               fallthrough;
> > --
> > 2.38.0
> >

-- 
/Horatiu
