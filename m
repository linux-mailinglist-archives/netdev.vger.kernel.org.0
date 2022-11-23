Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79B3636A35
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiKWTzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiKWTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:55:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8131478D43;
        Wed, 23 Nov 2022 11:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669233258; x=1700769258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9IaGz3nksRi+gF01rW+BvME2pa7n+X6zBZlnddfrqbk=;
  b=KWMeqo2FiDHbxNJlvSOWdDrNO+l2jgknDLNwXOeL5DvU/qsFDWrO99jt
   sVOSo2eySRQpgnbFtNPC8Y/7AbEmQ9u3Y6NagIGibHUnNU02EIbj+XVTL
   FXUvXA4Wq+uxd5MkOnc6BDQP4IKfY7NctImiJYIL9CknMQWJKjPI+pl1N
   mrLs0YWYM8F8/MMOM5SfqWEm2CO6rUBxGfNOW921JTcXGw7bOjrAH3hq6
   +w4bMIrVFYJ3JGL2xo+DsZZFigqLxsMVgcCmbKR9Qa2mo6w7gtyX0wy9y
   SJdeDhNyoyoBQNlHOw59jZ3CU1iwxcHYNBPt1iDl7JsfACRBjJZI8FXJO
   A==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184915519"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 12:54:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 12:54:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 23 Nov 2022 12:54:09 -0700
Date:   Wed, 23 Nov 2022 20:59:00 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v4 4/7] net: lan966x: Update rxq memory model
Message-ID: <20221123195900.wvql3v3mnmtixccs@soft-dev3-1>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
 <20221122214413.3446006-5-horatiu.vultur@microchip.com>
 <Y31GsPEhDOsCB70i@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y31GsPEhDOsCB70i@boxer>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 23:01, Maciej Fijalkowski wrote:
> 
> On Tue, Nov 22, 2022 at 10:44:10PM +0100, Horatiu Vultur wrote:
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
> 
> port can be scoped only for the loop below?

Yes, I will change this.

> 
> > +     int i;
> >
> >       rx->page_pool = page_pool_create(&pp_params);
> > +
> > +     for (i = 0; i < lan966x->num_phys_ports; ++i) {
> 
> Quoting Alex from some other thread:
> 
> "Since we're on -std=gnu11 for a bunch of releases already, all new
> loops are expected to go with the iterator declarations inside them."
> 
> TBH I wasn't aware of that personally :)

Me neither, I will update this and all the other lops introduced in this
series.

> 
> > +             if (!lan966x->ports[i])
> > +                     continue;
> > +
> > +             port = lan966x->ports[i];
> > +
> > +             xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);
> > +             xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
> > +                                        rx->page_pool);
> > +     }
> > +
> >       return PTR_ERR_OR_ZERO(rx->page_pool);
> >  }
> >
> > --
> > 2.38.0
> >

-- 
/Horatiu
