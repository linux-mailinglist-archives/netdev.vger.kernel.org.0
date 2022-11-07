Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1FE62012B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiKGVam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiKGVal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:30:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4EB24080;
        Mon,  7 Nov 2022 13:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667856640; x=1699392640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5mwth8Oh6VIfKvyEAU72IMW2k6Gv5C4k5dwfeNL+sLk=;
  b=z7ENwfq8KrCMK40g/NAEC98rH/U+rLWV1CT01ntb3nub2EOwHElpDVRb
   JBATH2Khft3dwT4JPqwZ5IauKv6MwaJg0ARwk5GY/01cosBkq2NlIZiiV
   KVNNH8mLeKg6mmg6wbJiTljkFvlH3oovuCv+Yy55BXAEEMGYEUwLxoV1e
   kBIxe5nwEGck6Zk0jUaKUHr+ItEK4s4GmrRWsgXkuAtMsL6+ivEZA3/sE
   q8FQ9uIHpQN0+T42r6/Fr4+5Idy1kF0co9YdHyRhukhGC/HIprIOsBw1w
   EbIVc6o+8W+0sH4iYD526lSsZBynuK1ux+eCq6y/sWIMg9nLjL3dvSvw+
   A==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="185787954"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 14:30:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 14:30:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 14:30:36 -0700
Date:   Mon, 7 Nov 2022 22:35:21 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 4/4] net: lan96x: Use page_pool API
Message-ID: <20221107213521.i6qmjut5hdxrrmcs@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
 <20221106211154.3225784-5-horatiu.vultur@microchip.com>
 <20221107164056.557894-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221107164056.557894-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/07/2022 17:40, Alexander Lobakin wrote:

Hi Olek,

> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Sun, 6 Nov 2022 22:11:54 +0100
> 
> > Use the page_pool API for allocation, freeing and DMA handling instead
> > of dev_alloc_pages, __free_pages and dma_map_page.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Kconfig    |  1 +
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 72 ++++++++++---------
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
> >  3 files changed, 43 insertions(+), 33 deletions(-)
> 
> [...]
> 
> > @@ -84,6 +62,27 @@ static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
> >       rx->last_entry = dcb;
> >  }
> >
> > +static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
> > +{
> > +     struct lan966x *lan966x = rx->lan966x;
> > +     struct page_pool_params pp_params = {
> > +             .order = rx->page_order,
> > +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > +             .pool_size = FDMA_DCB_MAX,
> > +             .nid = NUMA_NO_NODE,
> > +             .dev = lan966x->dev,
> > +             .dma_dir = DMA_FROM_DEVICE,
> > +             .offset = 0,
> > +             .max_len = PAGE_SIZE << rx->page_order,
> 
> ::max_len's primary purpose is to save time on DMA syncs.
> First of all, you can substract
> `SKB_DATA_ALIGN(sizeof(struct skb_shared_info))`, your HW never
> writes to those last couple hundred bytes.
> But I suggest calculating ::max_len basing on your current MTU
> value. Let's say you have 16k pages and MTU of 1500, that is a huge
> difference (except your DMA is always coherent, but I assume that's
> not the case).
> 
> In lan966x_fdma_change_mtu() you do:
> 
>         max_mtu = lan966x_fdma_get_max_mtu(lan966x);
>         max_mtu += IFH_LEN_BYTES;
>         max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>         max_mtu += VLAN_HLEN * 2;
> 
> `lan966x_fdma_get_max_mtu(lan966x) + IFH_LEN_BYTES + VLAN_HLEN * 2`
> (ie 1536 for the MTU of 1500) is your max_len value actually, given
> that you don't reserve any headroom (which is unfortunate, but I
> guess you're working on this already, since XDP requires
> %XDP_PACKET_HEADROOM).

Thanks for the suggestion. I will try it.
Regarding XDP_PACKET_HEADROOM, for the XDP_DROP, I didn't see it to be
needed. Once the support for XDP_TX or XDP_REDIRECT is added, then yes I
need to reserve also the headroom.

> 
> > +     };
> > +
> > +     rx->page_pool = page_pool_create(&pp_params);
> > +     if (IS_ERR(rx->page_pool))
> > +             return PTR_ERR(rx->page_pool);
> > +
> > +     return 0;
> 
>         return PTR_ERR_OR_ZERO(rx->page_pool);

Yes, I will use this.

> 
> > +}
> > +
> >  static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
> >  {
> >       struct lan966x *lan966x = rx->lan966x;
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
