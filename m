Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F663490E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbiKVVSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiKVVSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:18:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457BC8F3C5;
        Tue, 22 Nov 2022 13:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669151914; x=1700687914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LThJ1ttg1CyFpkPz/PkEmhwyOX/XhzArLbbxws3J7f8=;
  b=ipvmtCfbksG9BdcFrqBr1cgBp+4ILfjMqcDkkBZfFqziFfb+nQXiaCa+
   YRkLo/2b8sUJ+E/Cjgz8R5aSVGqENoFsjwRILt8//9emwr412sj3NW9GL
   Ad5VGMpcyt6oq7V89fxEA7JCDsn67SfpONUeWBnEdpo/hI8iLtiY3eNNO
   UqTc4LFZEY/z0Wysy8e0vT3gnH1GSuSbpMPwnP/r7Nh2dwm//jjGPrFHn
   CX9TfMuMH5Ip1q8/rb6gn1FzJmqcfWLwIYYbnPAfsj678tVValtjGwqc8
   QgelXwhE80jJT8KJelQvcV4P44sKibJ2v+9fbtsKUSHI66NfBIZ5vA9vZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="190169312"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:18:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:18:25 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 22 Nov 2022 14:18:25 -0700
Date:   Tue, 22 Nov 2022 22:23:16 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 4/7] net: lan966x: Update rxq memory model
Message-ID: <20221122212316.vqsynpwkrghxewi3@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
 <20221121212850.3212649-5-horatiu.vultur@microchip.com>
 <20221122113851.418993-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221122113851.418993-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 12:38, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 21 Nov 2022 22:28:47 +0100
> 
> > By default the rxq memory model is MEM_TYPE_PAGE_SHARED but to be able
> > to reuse pages on the TX side, when the XDP action XDP_TX it is required
> > to update the memory model to PAGE_POOL.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/lan966x_fdma.c  | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > index 384ed34197d58..483d1470c8362 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > @@ -78,8 +78,22 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
> >               .max_len = rx->max_mtu -
> >                          SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
> >       };
> > +     struct lan966x_port *port;
> > +     int i;
> >
> >       rx->page_pool = page_pool_create(&pp_params);
> > +
> > +     for (i = 0; i < lan966x->num_phys_ports; ++i) {
> > +             if (!lan966x->ports[i])
> > +                     continue;
> > +
> > +             port = lan966x->ports[i];
> > +
> > +             xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);
> 
> xdp_rxq_info_unreg_mem_model() can emit a splat if currently the
> corresponding xdp_rxq_info is not registered[0]. Can't we face it
> here if called from lan966x_fdma_init()?

We will not face that issue here because before lan966x_fdma_init is
called, we call lan966x_xdp_port_init which registers xdp_rxq_info.

> 
> > +             xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
> > +                                        rx->page_pool);
> > +     }
> > +
> >       return PTR_ERR_OR_ZERO(rx->page_pool);
> >  }
> >
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
