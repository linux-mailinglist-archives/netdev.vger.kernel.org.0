Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A2F6EB1AB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDUSdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDUSdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:33:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C119B1BCB;
        Fri, 21 Apr 2023 11:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682101987; x=1713637987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vUU6tG9KX3iUy8vtArJasd1+iOyl58okWHaGw2zYd4I=;
  b=UZ8AN2x35EUvclr64obBlaus8D87UiHyIvX4YBP47XmGMeWV6tcK+2o0
   Dhxdh8Ellb9bq8iYfbL7hi5jAL83lMftSoLoQw13+nGEvbBgssMK3jXve
   mqKmkQOb0GezUYjvIcyg/B5y3e7qof34bbDMJX0FqlBCYUJ99mlj9WO1i
   4ZzHkbVLiJWKsbfTrCdiWWjThYZWdQCvN7CG9urzkiA/tKSXMD/N4b9Yo
   zFU+ISLGOOenG5PbLQuQnkYi8tH0fOT2GdJEHiWS03bNlLl1APte2wDcX
   rA5crp8nv+L+L/F5x5bIBJiRW+76Y/l+YC1nQg4At1PxEfBhUEIWxiu4O
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,216,1677567600"; 
   d="scan'208";a="210644301"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 11:33:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 11:32:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 11:32:48 -0700
Date:   Fri, 21 Apr 2023 20:32:48 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net-next v2] lan966x: Don't use xdp_frame when action is
 XDP_TX
Message-ID: <20230421183248.n7a2c67umthlm3fg@soft-dev3-1>
References: <20230421131422.3530159-1-horatiu.vultur@microchip.com>
 <714b6bd0-014f-a5ab-af02-d4d9e4390454@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <714b6bd0-014f-a5ab-af02-d4d9e4390454@intel.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/21/2023 15:34, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Fri, 21 Apr 2023 15:14:22 +0200
> 
> [...]
> 
> > @@ -699,15 +701,14 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
> >       tx->last_in_use = next_to_use;
> >  }
> >
> > -int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> > -                        struct xdp_frame *xdpf,
> > -                        struct page *page,
> > -                        bool dma_map)
> > +int lan966x_fdma_xmit_xdpf(struct lan966x_port *port, void *ptr, u32 len)
> >  {
> >       struct lan966x *lan966x = port->lan966x;
> >       struct lan966x_tx_dcb_buf *next_dcb_buf;
> >       struct lan966x_tx *tx = &lan966x->tx;
> > +     struct xdp_frame *xdpf;
> >       dma_addr_t dma_addr;
> > +     struct page *page;
> >       int next_to_use;
> >       __be32 *ifh;
> >       int ret = 0;
> > @@ -722,8 +723,19 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> >               goto out;
> >       }
> >
> > +     /* Fill up the buffer */
> > +     next_dcb_buf = &tx->dcbs_buf[next_to_use];
> > +     next_dcb_buf->use_skb = false;
> > +     next_dcb_buf->xdp_ndo = !len;
> > +     next_dcb_buf->len = len + IFH_LEN_BYTES;
> 
> Is it intended that for .ndo_xdp_xmit cases this field will equal just
> %IFH_LEN_BYTES as @len is zero?

Argh, no it is a mistake. For that case it should be xdpf->len +
IFH_LEN_BYTES. As I focus on the XDP_TX, I fogot to test also
XDP_REDIRECT. :(
Thanks for the good catch!

I will fix this in the next version.

> 
> > +     next_dcb_buf->used = true;
> > +     next_dcb_buf->ptp = false;
> > +     next_dcb_buf->dev = port->dev;
> > +
> >       /* Generate new IFH */
> > -     if (dma_map) {
> > +     if (!len) {
> > +             xdpf = ptr;
> > +
> >               if (xdpf->headroom < IFH_LEN_BYTES) {
> >                       ret = NETDEV_TX_OK;
> >                       goto out;
> [...]
> 
> Thanks,
> Olek

-- 
/Horatiu
