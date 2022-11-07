Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB5D6200EC
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiKGVVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiKGVU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:20:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3CC30566;
        Mon,  7 Nov 2022 13:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667855990; x=1699391990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FRTdg9xjwz8cG4SA9/Vt6ox5KYC/KKvPCdzA/NClggs=;
  b=I+SxKhir3yvUEVsYlla84Dfbp+ZFBSzsmyVJQXVSG6LlXRrJcklq/0E2
   3reG4eHbEEzNn+RlWlf5ytf7jqOrVFN4LciX2VCMN8BaZrW+1CiTGQGk8
   qeV0ephekzJGe4U6JmdVwihm01ISTlPR6RlmVt6f+iWcFz5eMXWJn+zw7
   XlO/toXKEh0pgNXWk6ffJfVvJaxWOOp5OeIn9uEZF4AszbLOFlQLVx0Y3
   DocqdZ05iJudeWG6bCcEcIoAaQudtfpXjjN4AXCf1DlQCU6jQDBr2/j64
   nFVq6Ft4spj1zcJIxJbR90JsfvnuOovVEqGfiVmx6zZy43rH0mziq/mgM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="182345186"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 14:19:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 14:19:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 14:19:30 -0700
Date:   Mon, 7 Nov 2022 22:24:15 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 2/4] net: lan966x: Split function
 lan966x_fdma_rx_get_frame
Message-ID: <20221107212415.pwkdyyrdlbndb7ob@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
 <20221106211154.3225784-3-horatiu.vultur@microchip.com>
 <20221107160656.556195-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221107160656.556195-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/07/2022 17:06, Alexander Lobakin wrote:

Hi Olek,

> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Sun, 6 Nov 2022 22:11:52 +0100
> 
> > The function lan966x_fdma_rx_get_frame was unmapping the frame from
> > device and check also if the frame was received on a valid port. And
> > only after that it tried to generate the skb.
> > Move this check in a different function, in preparation for xdp
> > support. Such that xdp to be added here and the
> > lan966x_fdma_rx_get_frame to be used only when giving the skb to upper
> > layers.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 85 +++++++++++++------
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
> >  2 files changed, 69 insertions(+), 25 deletions(-)
> 
> [...]
> 
> > -static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> > +static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
> >  {
> >       struct lan966x *lan966x = rx->lan966x;
> > -     u64 src_port, timestamp;
> >       struct lan966x_db *db;
> > -     struct sk_buff *skb;
> >       struct page *page;
> >
> > -     /* Get the received frame and unmap it */
> >       db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
> >       page = rx->page[rx->dcb_index][rx->db_index];
> > +     if (unlikely(!page))
> > +             return FDMA_ERROR;
> >
> >       dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
> >                               FDMA_DCB_STATUS_BLOCKL(db->status),
> >                               DMA_FROM_DEVICE);
> >
> > +     dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
> > +                            PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
> > +                            DMA_ATTR_SKIP_CPU_SYNC);
> > +
> > +     lan966x_ifh_get_src_port(page_address(page), src_port);
> > +     if (WARN_ON(*src_port >= lan966x->num_phys_ports))
> > +             return FDMA_ERROR;
> > +
> > +     return FDMA_PASS;
> 
> How about making this function return s64, which would be "src_port
> or negative error", and dropping the second argument @src_port (the
> example of calling it below)?

That was also my first thought.
But the thing is, I am also adding FDMA_DROP in the next patch of this
series(3/4). And I am planning to add also FDMA_TX and FDMA_REDIRECT in
a next patch series.
Should they(FDMA_DROP, FDMA_TX, FDMA_REDIRECT) also be some negative
numbers? And then have something like you proposed belowed:
---
src_port = lan966x_fdma_rx_check_frame(rx);
if (unlikely(src_port < 0)) {

        switch(src_port) {
        case FDMA_ERROR:
             ...
             goto allocate_new
        case FDMA_DROP:
             ...
             continue;
        case FDMA_TX:
        case FDMA_REDIRECT:
        }
}
---

> 
> > +}
> > +
> > +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
> > +                                              u64 src_port)
> > +{
> 
> [...]
> 
> > -             skb = lan966x_fdma_rx_get_frame(rx);
> > +             counter++;
> >
> > -             rx->page[rx->dcb_index][rx->db_index] = NULL;
> > -             rx->dcb_index++;
> > -             rx->dcb_index &= FDMA_DCB_MAX - 1;
> > +             switch (lan966x_fdma_rx_check_frame(rx, &src_port)) {
> > +             case FDMA_PASS:
> > +                     break;
> > +             case FDMA_ERROR:
> > +                     lan966x_fdma_rx_free_page(rx);
> > +                     lan966x_fdma_rx_advance_dcb(rx);
> > +                     goto allocate_new;
> > +             }
> 
> So, here you could do (if you want to keep the current flow)::
> 
>                 src_port = lan966x_fdma_rx_check_frame(rx);
>                 switch (src_port) {
>                 case 0 .. S64_MAX: // for example
>                         break;
>                 case FDMA_ERROR:   // must be < 0
>                         lan_966x_fdma_rx_free_page(rx);
>                         ...
>                 }
> 
> But given that the error path is very unlikely and cold, I would
> prefer if-else over switch case:
> 
>                 src_port = lan966x_fdma_rx_check_frame(rx);
>                 if (unlikely(src_port < 0)) {
>                         lan_966x_fdma_rx_free_page(rx);
>                         ...
>                         goto allocate_new;
>                 }
> 
> >
> > +             skb = lan966x_fdma_rx_get_frame(rx, src_port);
> > +             lan966x_fdma_rx_advance_dcb(rx);
> >               if (!skb)
> > -                     break;
> > +                     goto allocate_new;
> >
> >               napi_gro_receive(&lan966x->napi, skb);
> > -             counter++;
> >       }
> >
> > +allocate_new:
> >       /* Allocate new pages and map them */
> >       while (dcb_reload != rx->dcb_index) {
> >               db = &rx->dcbs[dcb_reload].db[rx->db_index];
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index 4ec33999e4df6..464fb5e4a8ff6 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -100,6 +100,15 @@ enum macaccess_entry_type {
> >       ENTRYTYPE_MACV6,
> >  };
> >
> > +/* FDMA return action codes for checking if the frame is valid
> > + * FDMA_PASS, frame is valid and can be used
> > + * FDMA_ERROR, something went wrong, stop getting more frames
> > + */
> > +enum lan966x_fdma_action {
> > +     FDMA_PASS = 0,
> > +     FDMA_ERROR,
> > +};
> > +
> >  struct lan966x_port;
> >
> >  struct lan966x_db {
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
