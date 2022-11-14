Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDB628977
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiKNTfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiKNTe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:34:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E34DF33;
        Mon, 14 Nov 2022 11:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668454496; x=1699990496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M4spZxWuVGAaDdIiMUL3VsbQbP6I906OMxravsBj+GQ=;
  b=O4adOtiDuLT0wwpmJX0EhxVBtMpW6DlGoknASlty6S5kfqHrjoogbqSz
   d69OlCZRLa7SL0U5VmVlhAd2tqH9a9Hg61trPoB52hRJc6Tz11cERBW4z
   +XetR8djoLxukvhzAbymn0qzl1P9lLtv+S5vvRmsST0FyR/9OrkftPH3s
   Ol7PT0CoFd49EII6UYzC0meGA+KcADw+WEhhGyH0CtyN91S2t6HcT/8qX
   TeMuVTP3e9DeVLtLCTwGw1fC8AJz5you5kO2BXV3nd2pZOfrYA+XBwh3E
   5//xJdSQiVak2G77njJLVUTW9HKG6ieois7HC0O5nZHWZSsXOJAftwldP
   w==;
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="183462616"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2022 12:34:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 14 Nov 2022 12:34:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 14 Nov 2022 12:34:52 -0700
Date:   Mon, 14 Nov 2022 20:39:40 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Message-ID: <20221114193940.whiwpojrwast7tnl@soft-dev3-1>
References: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
 <20221113111559.1028030-2-horatiu.vultur@microchip.com>
 <20221114141633.699268-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221114141633.699268-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/14/2022 15:16, Alexander Lobakin wrote:
> [Some people who received this message don't often get email from alexandr.lobakin@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Sun, 13 Nov 2022 12:15:55 +0100

Hi Olek,

> 
> > Update the page_pool params to allocate XDP_PACKET_HEADROOM space as
> > headroom for all received frames.
> > This is needed for when the XDP_TX and XDP_REDIRECT are implemented.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> 
> [...]
> 
> > @@ -466,7 +472,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
> >
> >       skb_mark_for_recycle(skb);
> >
> > -     skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> > +     skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status) + XDP_PACKET_HEADROOM);
> > +     skb_pull(skb, XDP_PACKET_HEADROOM);
> 
> These two must be:
> 
> +       skb_reserve(skb, XDP_PACKET_HEADROOM);
>         skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> 
> i.e. you only need to add reserve, and that's it. It's not only
> faster, but also moves ::tail, which is essential.

Thanks for the suggestion. I will do that in the next version.

> 
> >
> >       lan966x_ifh_get_timestamp(skb->data, &timestamp);
> >
> 
> [...]
> 
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > @@ -44,8 +44,9 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
> >
> >       xdp_init_buff(&xdp, PAGE_SIZE << lan966x->rx.page_order,
> >                     &port->xdp_rxq);
> > -     xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
> > -                      data_len - IFH_LEN_BYTES, false);
> > +     xdp_prepare_buff(&xdp, page_address(page),
> > +                      IFH_LEN_BYTES + XDP_PACKET_HEADROOM,
> > +                      data_len - IFH_LEN_BYTES - XDP_PACKET_HEADROOM, false);
> 
> Are you sure you need to substract %XDP_PACKET_HEADROOM from
> @data_len? I think @data_len is the frame length, so headroom is not
> included?

Actually @data_len contains also the XDP_PACKET_HEADROOM. I am calling
lan966x_xdp_run like this:

---
return lan966x_xdp_run(port, page,
		       FDMA_DCB_STATUS_BLOCKL(db->status) + XDP_PACKET_HEADROOM);
---

But from what I can see, that doesn't make too much sense.
Because I am adding here the XDP_PACKET_HEADROOM and then remove it in
xdp_prepare_buff. So it would be better not to add it at all.

> 
> >       act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >       switch (act) {
> >       case XDP_PASS:
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
