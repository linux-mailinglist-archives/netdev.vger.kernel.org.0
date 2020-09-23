Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26562761AE
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgIWUIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:08:06 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:23891 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWUID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600891683; x=1632427683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+VoZC8PxE1Abn6uyBGA6mI3e+ngaNEL1e7w0F0/o3Zk=;
  b=cyYuMjx0nxhcdaTf6nRUG8sYLSADSO8/8fC5kKi1vJbj0pX9CilRncSr
   w77Dp3H3F5cuUGDwji6Jc0VyEwK0We+hZpp60Ug80Q+TztajRZDlHTeoh
   Lnv3ltx+kLSG8irRDJUlkxVNNCHgzNhZZgpEFT+Xyt9y+LPqcTzikdzLY
   vz1lqiaKup70zUL5DHXMoZD2rDIyvRmCyu1jcm0mUJJSb50ktyeW+A6W0
   ZJ25Ts35GKpsQ+wy/QjTN9LbFOO/gubNEhzBOKHIfNKZBZiU029HAr2AT
   XpsFO6DJv4hPf+9BNUiUfghKGbRVl4y3tQtBDJR3F9II7bEHkvrYXsfSG
   Q==;
IronPort-SDR: xJcjQ19oX/gkyJFjR35L3NxGDQUd3VyJtcpzSdLQX46QQL7h5FyOzlKqjj7fiTrn/TSrEhwmpK
 TLPnxwpJ9Yh710L4FDvtCwRkCtWTBHXkT1rvt0R3ba/wjnvq5nT493AoeDjWXzeMwVtRhwmFjF
 CrMnbLkWrtYdFEZilpPhiHejvQHkSOyUR1APYV/5PurfcOYM6YykOFESv740bj9WjoYFShBUL9
 pIaqZpPYNqeWxKm6v824F2poQV9dUItkfY975xuUj2rCSGqELmJrchZGmeq3vQMN+n46TDJkHQ
 Gos=
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="92133414"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2020 13:08:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 13:07:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Sep 2020 13:07:41 -0700
Date:   Wed, 23 Sep 2020 22:08:00 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Message-ID: <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/23/2020 14:24, Vladimir Oltean wrote:
> 

Hi Vladimir,

I have just one question, please see bellow.

> Currently, ocelot switchdev passes the skb directly to the function that
> enqueues it to the list of skb's awaiting a TX timestamp. Whereas the
> felix DSA driver first clones the skb, then passes the clone to this
> queue.
> 
> This matters because in the case of felix, the common IRQ handler, which
> is ocelot_get_txtstamp(), currently clones the clone, and frees the
> original clone. This is useless and can be simplified by using
> skb_complete_tx_timestamp() instead of skb_tstamp_tx().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c         |  5 ++++-
>  drivers/net/ethernet/mscc/ocelot.c     | 30 ++++++++++----------------
>  drivers/net/ethernet/mscc/ocelot_net.c | 22 +++++++++++++++----
>  include/soc/mscc/ocelot.h              |  4 ++--
>  net/dsa/tag_ocelot.c                   |  6 +++---
>  5 files changed, 38 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 0b2bb8d7325c..1ec4fea5a546 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -668,8 +668,11 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
>         struct ocelot *ocelot = ds->priv;
>         struct ocelot_port *ocelot_port = ocelot->ports[port];
> 
> -       if (!ocelot_port_add_txtstamp_skb(ocelot_port, clone))
> +       if (ocelot->ptp && (skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP) &&
> +           ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +               ocelot_port_add_txtstamp_skb(ocelot, port, clone);
>                 return true;
> +       }
> 
>         return false;
>  }
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 977d2263cbe1..58b969b85643 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -413,26 +413,20 @@ void ocelot_port_disable(struct ocelot *ocelot, int port)
>  }
>  EXPORT_SYMBOL(ocelot_port_disable);
> 
> -int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
> -                                struct sk_buff *skb)
> +void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
> +                                 struct sk_buff *clone)
>  {
> -       struct skb_shared_info *shinfo = skb_shinfo(skb);
> -       struct ocelot *ocelot = ocelot_port->ocelot;
> +       struct ocelot_port *ocelot_port = ocelot->ports[port];
> 
> -       if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> -           ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -               spin_lock(&ocelot_port->ts_id_lock);
> +       spin_lock(&ocelot_port->ts_id_lock);
> 
> -               shinfo->tx_flags |= SKBTX_IN_PROGRESS;
> -               /* Store timestamp ID in cb[0] of sk_buff */
> -               skb->cb[0] = ocelot_port->ts_id;
> -               ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
> -               skb_queue_tail(&ocelot_port->tx_skbs, skb);
> +       skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
> +       /* Store timestamp ID in cb[0] of sk_buff */
> +       clone->cb[0] = ocelot_port->ts_id;
> +       ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
> +       skb_queue_tail(&ocelot_port->tx_skbs, clone);
> 
> -               spin_unlock(&ocelot_port->ts_id_lock);
> -               return 0;
> -       }
> -       return -ENODATA;
> +       spin_unlock(&ocelot_port->ts_id_lock);
>  }
>  EXPORT_SYMBOL(ocelot_port_add_txtstamp_skb);
> 
> @@ -511,9 +505,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
>                 /* Set the timestamp into the skb */
>                 memset(&shhwtstamps, 0, sizeof(shhwtstamps));
>                 shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
> -               skb_tstamp_tx(skb_match, &shhwtstamps);
> -
> -               dev_kfree_skb_any(skb_match);
> +               skb_complete_tx_timestamp(skb_match, &shhwtstamps);
> 
>                 /* Next ts */
>                 ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 8490e42e9e2d..028a0150f97d 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -330,7 +330,6 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>         u8 grp = 0; /* Send everything on CPU group 0 */
>         unsigned int i, count, last;
>         int port = priv->chip_port;
> -       bool do_tstamp;
> 
>         val = ocelot_read(ocelot, QS_INJ_STATUS);
>         if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
> @@ -345,7 +344,23 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>         info.vid = skb_vlan_tag_get(skb);
> 
>         /* Check if timestamping is needed */
> -       do_tstamp = (ocelot_port_add_txtstamp_skb(ocelot_port, skb) == 0);
> +       if (ocelot->ptp && (shinfo->tx_flags & SKBTX_HW_TSTAMP)) {
> +               info.rew_op = ocelot_port->ptp_cmd;
> +
> +               if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +                       struct sk_buff *clone;
> +
> +                       clone = skb_clone_sk(skb);
> +                       if (!clone) {
> +                               kfree_skb(skb);
> +                               return NETDEV_TX_OK;

Why do you return NETDEV_TX_OK?
Because the frame is not sent yet.

> +                       }
> +
> +                       ocelot_port_add_txtstamp_skb(ocelot, port, clone);
> +
> +                       info.rew_op |= clone->cb[0] << 3;
> +               }
> +       }
> 
>         if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
>                 info.rew_op = ocelot_port->ptp_cmd;
> @@ -383,8 +398,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>         dev->stats.tx_packets++;
>         dev->stats.tx_bytes += skb->len;
> 
> -       if (!do_tstamp)
> -               dev_kfree_skb_any(skb);
> +       kfree_skb(skb);
> 
>         return NETDEV_TX_OK;
>  }
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index df252c22f985..2ca7ba829c76 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -711,8 +711,8 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
>  int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
>  int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
>  int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
> -int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
> -                                struct sk_buff *skb);
> +void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
> +                                 struct sk_buff *clone);
>  void ocelot_get_txtstamp(struct ocelot *ocelot);
>  void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
>  int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index b4fc05cafaa6..d1a7e224adff 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -137,6 +137,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>                                    struct net_device *netdev)
>  {
>         struct dsa_port *dp = dsa_slave_to_port(netdev);
> +       struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
>         struct dsa_switch *ds = dp->ds;
>         struct ocelot *ocelot = ds->priv;
>         struct ocelot_port *ocelot_port;
> @@ -159,9 +160,8 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>         qos_class = skb->priority;
>         packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
> 
> -       if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
> -               struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> -
> +       /* TX timestamping was requested */
> +       if (clone) {
>                 rew_op = ocelot_port->ptp_cmd;
>                 /* Retrieve timestamp ID populated inside skb->cb[0] of the
>                  * clone by ocelot_port_add_txtstamp_skb
> --
> 2.25.1
> 

-- 
/Horatiu
