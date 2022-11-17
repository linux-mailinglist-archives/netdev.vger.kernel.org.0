Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1839462DA85
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiKQMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbiKQMSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:18:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D40970A38
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668687478; x=1700223478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ydEj2Q+uMDTwX7o4flBR4EgodQ5AcTUWYlaTInRQA1k=;
  b=d82qAvJoen/IJOElKJ0rX82Asf0l9LJOBsOZBwRC6puYBkx9fPnp0exz
   L+1kY/Q4gD2+8HIT3sIdWij+DbKXf+R1f8QSaBsicz0KnYw/lDaleqsdh
   UffbnZJs1gdxelu9mHEUFLXD7eXGmcFBXeok5WqpjJZobZZErInXbdlfS
   8zt1guFlV1y2W1TEIAe/JkAji21vDVCBrhMknfxyuCoENzrH8jwzDyeEM
   f+cTieDByB8GxcrhYuOyfVNIBhwH0UmBImJwA0sMulzt2jN8JtP5bZrBP
   XXhBdvjvG3rLkwH6ZX3uqr321hE7fVicJOT+PRExeSTGOjp6UgF9CvJKK
   g==;
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="189362903"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 05:17:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 05:17:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 17 Nov 2022 05:17:55 -0700
Date:   Thu, 17 Nov 2022 13:22:44 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: microchip: sparx5: correctly free skb in xmit
Message-ID: <20221117122244.3ag5bonu3w7xwu4v@soft-dev3-1>
References: <20221116095740.176286-1-casper.casan@gmail.com>
 <20221116114115.eojkihqplenjv6l3@soft-dev3-1>
 <20221116123435.5o76prb33mpte5hf@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221116123435.5o76prb33mpte5hf@wse-c0155>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/16/2022 13:34, Casper Andersson wrote:
> 
> Hi Horatiu,
> 
> On 2022-11-16 12:41, Horatiu Vultur wrote:
> > The 11/16/2022 10:57, Casper Andersson wrote:
> >
> > Hi Casper,
> >
> > >
> > > consume_skb on transmitted, kfree_skb on dropped, do not free on TX_BUSY.
> > >
> > > Previously the xmit function could return -EBUSY without freeing, which
> > > supposedly is interpreted as a drop. And was using kfree on successfully
> > > transmitted packets.
> > > https://lore.kernel.org/netdev/20220920072948.33c25dd2@kernel.org/t/#mdb821eb507a207dd5e27683239ffa7ec7199421a
> > >
> > > Fixes: 10615907e9b5 ("net: sparx5: switchdev: adding frame DMA functionality")
> >
> > Actually the fix shouldn't be:
> > 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping") ?
> > Because this commit introduced the function sparx5_ptp_txtstamp_request,
> > and it didn't free the skb on error path.
> >
> 
> As I understood Jakub's comment (linked above) part of the issue was
> that sparx5_inject (and sparx5_ptp_txtstamp_request) returns -EBUSY
> instead of NETDEV_TX_BUSY (which then gets returned further). So maybe
> it should be separate patches for the two cases.

Ah.. I think now I understand it. It is up to you how to take this.

> 
> While on the topic, I noticed another possible issue with
> sparx5_fdma_xmit where it increments dropped, but keeps going with
> transmit. I assume it should return and indicate dropped here.
> 
>         if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
>                 tx->dropped++;
>         db = list_first_entry(&tx->db_list, struct sparx5_db, list);

You are correct, that looks wrong also to me.
It should return and drop the frame.

>         ...
> 
> > > Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> > > ---
> > > I am not entirely sure about the following construct which is present in
> > > both sparx5 and lan966x drivers and returns before consuming the skb. Is
> > > there any reason it does not free the skb?
> >
> > Yes, this case will happen when the HW is configured to timestamp frames
> > and return the timestamp back to the SW. And in that case the frame is freed
> > once the timestamp is received. Have a look in the function
> > 'sparx5_ptp_irq_handler'
> 
> Alright, that makes sense.
> 
> >
> > >
> > > if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > >     SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > >         return NETDEV_TX_OK;
> > >
> > >
> > >
> > >
> > >  .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
> > >  .../ethernet/microchip/sparx5/sparx5_main.h   |  2 +-
> > >  .../ethernet/microchip/sparx5/sparx5_packet.c | 47 ++++++++++---------
> > >  3 files changed, 27 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> > > index 66360c8c5a38..302e7ff55585 100644
> > > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> > > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> > > @@ -306,7 +306,7 @@ static struct sparx5_tx_dcb_hw *sparx5_fdma_next_dcb(struct sparx5_tx *tx,
> > >         return next_dcb;
> > >  }
> > >
> > > -int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
> > > +netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
> > >  {
> > >         struct sparx5_tx_dcb_hw *next_dcb_hw;
> > >         struct sparx5_tx *tx = &sparx5->tx;
> > > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> > > index 7a83222caa73..34b8d11f76df 100644
> > > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> > > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> > > @@ -312,7 +312,7 @@ void sparx5_port_inj_timer_setup(struct sparx5_port *port);
> > >  /* sparx5_fdma.c */
> > >  int sparx5_fdma_start(struct sparx5 *sparx5);
> > >  int sparx5_fdma_stop(struct sparx5 *sparx5);
> > > -int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
> > > +netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
> > >  irqreturn_t sparx5_fdma_handler(int irq, void *args);
> > >
> > >  /* sparx5_mactable.c */
> > > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > > index 83c16ca5b30f..6fc1c1e410f6 100644
> > > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > > @@ -159,10 +159,10 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
> > >         netif_rx(skb);
> > >  }
> > >
> > > -static int sparx5_inject(struct sparx5 *sparx5,
> > > -                        u32 *ifh,
> > > -                        struct sk_buff *skb,
> > > -                        struct net_device *ndev)
> > > +static netdev_tx_t sparx5_inject(struct sparx5 *sparx5,
> > > +                                u32 *ifh,
> > > +                                struct sk_buff *skb,
> > > +                                struct net_device *ndev)
> > >  {
> > >         int grp = INJ_QUEUE;
> > >         u32 val, w, count;
> > > @@ -172,7 +172,7 @@ static int sparx5_inject(struct sparx5 *sparx5,
> > >         if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
> > >                 pr_err_ratelimited("Injection: Queue not ready: 0x%lx\n",
> > >                                    QS_INJ_STATUS_FIFO_RDY_GET(val));
> > > -               return -EBUSY;
> > > +               return NETDEV_TX_BUSY;
> > >         }
> > >
> > >         /* Indicate SOF */
> > > @@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
> > >         sparx5_set_port_ifh(ifh, port->portno);
> > >
> > >         if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > > -               ret = sparx5_ptp_txtstamp_request(port, skb);
> > > -               if (ret)
> > > -                       return ret;
> > > +               if (sparx5_ptp_txtstamp_request(port, skb))
> > > +                       goto drop;
> >
> > Is it not possible to return busy also here?
> > The reason why I ask this is because of the following case.
> > Imagine you need to send a frame and timestamp it, but the HW
> > currrently don't have enough slots to store the TX timestamp. In that
> > case is better to return BUSY because maybe in short time there will be
> > slots. Than just dropping the frame, because if the frame is dropped,
> > then there is no chance to get the TX timestamp, and who needs this will
> > stop working.
> 
> Yes, we can do that. Thanks for clarifying, I hadn't quite understood
> the PTP parts of this.
> 
> >
> > >
> > >                 sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
> > >                 sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
> > > @@ -250,23 +249,27 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
> > >         else
> > >                 ret = sparx5_inject(sparx5, ifh, skb, dev);
> > >
> > > -       if (ret == NETDEV_TX_OK) {
> > > -               stats->tx_bytes += skb->len;
> > > -               stats->tx_packets++;
> > > +       if (ret == NETDEV_TX_BUSY)
> > > +               goto busy;
> > >
> > > -               if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > > -                   SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > > -                       return ret;
> > > +       stats->tx_bytes += skb->len;
> > > +       stats->tx_packets++;
> > >
> > > -               dev_kfree_skb_any(skb);
> > > -       } else {
> > > -               stats->tx_dropped++;
> > > +       if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > > +           SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > > +               return NETDEV_TX_OK;
> > >
> > > -               if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > > -                   SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > > -                       sparx5_ptp_txtstamp_release(port, skb);
> > > -       }
> > > -       return ret;
> > > +       dev_consume_skb_any(skb);
> > > +       return NETDEV_TX_OK;
> > > +drop:
> > > +       stats->tx_dropped++;
> > > +       dev_kfree_skb_any(skb);
> > > +       return NETDEV_TX_OK;
> > > +busy:
> > > +       if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> > > +           SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> > > +               sparx5_ptp_txtstamp_release(port, skb);
> > > +       return NETDEV_TX_BUSY;
> > >  }
> > >
> > >  static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
> > > --
> > > 2.34.1
> > >
> >
> > --
> > /Horatiu

-- 
/Horatiu
