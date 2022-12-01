Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A069963F2F4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiLAOd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLAOd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:33:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800B8201A2
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669905235; x=1701441235;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WvcS/fCfszDHAR26mWM0VymV6whAHM3HQ3x2TLjKvCM=;
  b=VR7Bqfed92/dBdkj1v0uUe52CsUQKQJRtvh2xbe+YyKJDw3Hg9oMgkoj
   pHxy2HPD5C7c+7mcKyY8hhKkW6UNQBPnN+rIhlQm2V/6ai5x7ieX0S3xQ
   xybT/FL/h6GhZK49Ie35LKmF5dRXAT7Ug/tu/K8+JbXhgXr/un81I2ONf
   aXndbqTh3xVCkq/RDuyMn7dlwirtQol5aOPkVQLvK0Pjleo0302ZjyTXb
   jf8fng9qAukKDEcHBfb2kfn7AfcotMgrAcoW9RwqdwZ8ak7NE0+osyA5I
   nZKOKBqOkEQPcOJuG1FhQsHkq+0ncejaApVVYvziFtPpEtHbiIsYQZUS8
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="202191518"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 07:33:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 07:33:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Dec 2022 07:33:54 -0700
Date:   Thu, 1 Dec 2022 15:38:58 +0100
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
Subject: Re: [PATCH v2 net] net: microchip: sparx5: correctly free skb in xmit
Message-ID: <20221201143858.isi7ceezsfubtazl@soft-dev3-1>
References: <20221129152635.15362-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221129152635.15362-1-casper.casan@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/29/2022 16:26, Casper Andersson wrote:
> 
> consume_skb on transmitted, kfree_skb on dropped, do not free on
> TX_BUSY.
> 
> Previously the xmit function could return -EBUSY without freeing, which
> supposedly is interpreted as a drop. And was using kfree on successfully
> transmitted packets.
> 
> sparx5_fdma_xmit and sparx5_inject returns error code, where -EBUSY
> indicates TX_BUSY and any other error code indicates dropped.
> 
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
>  .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
>  .../ethernet/microchip/sparx5/sparx5_packet.c | 41 +++++++++++--------
>  2 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> index 66360c8c5a38..141897dfe388 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
> @@ -317,7 +317,7 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
>         next_dcb_hw = sparx5_fdma_next_dcb(tx, tx->curr_entry);
>         db_hw = &next_dcb_hw->db[0];
>         if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
> -               tx->dropped++;
> +               return -EINVAL;
>         db = list_first_entry(&tx->db_list, struct sparx5_db, list);
>         list_move_tail(&db->list, &tx->db_list);
>         next_dcb_hw->nextptr = FDMA_DCB_INVALID_DATA;
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> index 83c16ca5b30f..6db6ac6a3bbc 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> @@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
>         sparx5_set_port_ifh(ifh, port->portno);
> 
>         if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> -               ret = sparx5_ptp_txtstamp_request(port, skb);
> -               if (ret)
> -                       return ret;
> +               if (sparx5_ptp_txtstamp_request(port, skb) < 0)
> +                       return NETDEV_TX_BUSY;
> 
>                 sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
>                 sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
> @@ -250,23 +249,31 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
>         else
>                 ret = sparx5_inject(sparx5, ifh, skb, dev);
> 
> -       if (ret == NETDEV_TX_OK) {
> -               stats->tx_bytes += skb->len;
> -               stats->tx_packets++;
> +       if (ret == -EBUSY)
> +               goto busy;
> +       if (ret < 0)
> +               goto drop;
> 
> -               if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
> -                   SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
> -                       return ret;
> +       stats->tx_bytes += skb->len;
> +       stats->tx_packets++;
> +       sparx5->tx.packets++;
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
> +       sparx5->tx.dropped++;
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
