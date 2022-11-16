Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0EC62BC7C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiKPLuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiKPLtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:49:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EB93134D
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 03:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668598594; x=1700134594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dyU2qAkrd5j8P9k8kXS52mWfnBNIchsNDHH1dozihug=;
  b=vBhygOiwH2n0ciADA6hfIGOrANj2T9x/IyESBxo5x6blLHXkcr9fFY3E
   +xuJb9Hl8vKLdlLEbv6cFaUAsvEe0hrH4I/FIO3bQxHbvWBbCxLk9qT9Y
   lqbh0bduGiUFuxqHlbLBDegVPNH/xSeo5AsQevaRoMllD9unELE8uvFxm
   mcZcKPUFcMOGZpiyGPLebvJnLfFEkae9KdesTljGsIsh8YcPOu7Eoe5El
   EA9atbq7xFTnEW02ICZPrx3AL+KKlUfK+xVAxwA4o+cLTs5GlGaqbBUxn
   Hc5K4rYNaDx4T3hKhZq/AcO/ksTGhK9LsufTKuUsdV2ldOnMtaaOCqEjq
   A==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="183770716"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 04:36:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 04:36:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 16 Nov 2022 04:36:27 -0700
Date:   Wed, 16 Nov 2022 12:41:15 +0100
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
Message-ID: <20221116114115.eojkihqplenjv6l3@soft-dev3-1>
References: <20221116095740.176286-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221116095740.176286-1-casper.casan@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/16/2022 10:57, Casper Andersson wrote:

Hi Casper,

> 
> consume_skb on transmitted, kfree_skb on dropped, do not free on TX_BUSY.
> 
> Previously the xmit function could return -EBUSY without freeing, which
> supposedly is interpreted as a drop. And was using kfree on successfully
> transmitted packets.
> https://lore.kernel.org/netdev/20220920072948.33c25dd2@kernel.org/t/#mdb821eb507a207dd5e27683239ffa7ec7199421a
> 
> Fixes: 10615907e9b5 ("net: sparx5: switchdev: adding frame DMA functionality")

Actually the fix shouldn't be:
70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping") ?
Because this commit introduced the function sparx5_ptp_txtstamp_request,
and it didn't free the skb on error path.

> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
> I am not entirely sure about the following construct which is present in
> both sparx5 and lan966x drivers and returns before consuming the skb. Is
> there any reason it does not free the skb?

Yes, this case will happen when the HW is configured to timestamp frames
and return the timestamp back to the SW. And in that case the frame is freed
once the timestamp is received. Have a look in the function
'sparx5_ptp_irq_handler'

> 
> if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
>     SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
>         return NETDEV_TX_OK;
> 
> 
> 
> 
>  .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
>  .../ethernet/microchip/sparx5/sparx5_main.h   |  2 +-
>  .../ethernet/microchip/sparx5/sparx5_packet.c | 47 ++++++++++---------
>  3 files changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> index 66360c8c5a38..302e7ff55585 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> @@ -306,7 +306,7 @@ static struct sparx5_tx_dcb_hw *sparx5_fdma_next_dcb(struct sparx5_tx *tx,
>         return next_dcb;
>  }
> 
> -int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
> +netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
>  {
>         struct sparx5_tx_dcb_hw *next_dcb_hw;
>         struct sparx5_tx *tx = &sparx5->tx;
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index 7a83222caa73..34b8d11f76df 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -312,7 +312,7 @@ void sparx5_port_inj_timer_setup(struct sparx5_port *port);
>  /* sparx5_fdma.c */
>  int sparx5_fdma_start(struct sparx5 *sparx5);
>  int sparx5_fdma_stop(struct sparx5 *sparx5);
> -int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
> +netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
>  irqreturn_t sparx5_fdma_handler(int irq, void *args);
> 
>  /* sparx5_mactable.c */
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> index 83c16ca5b30f..6fc1c1e410f6 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> @@ -159,10 +159,10 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
>         netif_rx(skb);
>  }
> 
> -static int sparx5_inject(struct sparx5 *sparx5,
> -                        u32 *ifh,
> -                        struct sk_buff *skb,
> -                        struct net_device *ndev)
> +static netdev_tx_t sparx5_inject(struct sparx5 *sparx5,
> +                                u32 *ifh,
> +                                struct sk_buff *skb,
> +                                struct net_device *ndev)
>  {
>         int grp = INJ_QUEUE;
>         u32 val, w, count;
> @@ -172,7 +172,7 @@ static int sparx5_inject(struct sparx5 *sparx5,
>         if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
>                 pr_err_ratelimited("Injection: Queue not ready: 0x%lx\n",
>                                    QS_INJ_STATUS_FIFO_RDY_GET(val));
> -               return -EBUSY;
> +               return NETDEV_TX_BUSY;
>         }
> 
>         /* Indicate SOF */
> @@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
>         sparx5_set_port_ifh(ifh, port->portno);
> 
>         if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> -               ret = sparx5_ptp_txtstamp_request(port, skb);
> -               if (ret)
> -                       return ret;
> +               if (sparx5_ptp_txtstamp_request(port, skb))
> +                       goto drop;

Is it not possible to return busy also here?
The reason why I ask this is because of the following case.
Imagine you need to send a frame and timestamp it, but the HW
currrently don't have enough slots to store the TX timestamp. In that
case is better to return BUSY because maybe in short time there will be
slots. Than just dropping the frame, because if the frame is dropped,
then there is no chance to get the TX timestamp, and who needs this will
stop working.

> 
>                 sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
>                 sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
> @@ -250,23 +249,27 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
>         else
>                 ret = sparx5_inject(sparx5, ifh, skb, dev);
> 
> -       if (ret == NETDEV_TX_OK) {
> -               stats->tx_bytes += skb->len;
> -               stats->tx_packets++;
> +       if (ret == NETDEV_TX_BUSY)
> +               goto busy;
> 
> -               if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> -                   SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> -                       return ret;
> +       stats->tx_bytes += skb->len;
> +       stats->tx_packets++;
> 
> -               dev_kfree_skb_any(skb);
> -       } else {
> -               stats->tx_dropped++;
> +       if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> +           SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> +               return NETDEV_TX_OK;
> 
> -               if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> -                   SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> -                       sparx5_ptp_txtstamp_release(port, skb);
> -       }
> -       return ret;
> +       dev_consume_skb_any(skb);
> +       return NETDEV_TX_OK;
> +drop:
> +       stats->tx_dropped++;
> +       dev_kfree_skb_any(skb);
> +       return NETDEV_TX_OK;
> +busy:
> +       if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> +           SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> +               sparx5_ptp_txtstamp_release(port, skb);
> +       return NETDEV_TX_BUSY;
>  }
> 
>  static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
> --
> 2.34.1
> 

-- 
/Horatiu
