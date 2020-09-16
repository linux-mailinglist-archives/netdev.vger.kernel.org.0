Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889C626CA59
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgIPT4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:56:23 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:41664 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbgIPRfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:35:32 -0400
Received: from relay8-d.mail.gandi.net (unknown [217.70.183.201])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 697FC3A3AB1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 11:17:29 +0000 (UTC)
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 954621BF20D;
        Wed, 16 Sep 2020 11:12:04 +0000 (UTC)
Date:   Wed, 16 Sep 2020 13:12:04 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net 2/7] net: mscc: ocelot: add locking for the port TX
 timestamp ID
Message-ID: <20200916111204.GJ9675@piout.net>
References: <20200915182229.69529-1-olteanv@gmail.com>
 <20200915182229.69529-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915182229.69529-3-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2020 21:22:24+0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot_port->ts_id is used to:
> - populate skb->cb[0] for matching the TX timestamp in the PTP IRQ with
>   an skb.
> - populate the REW_OP from the injection header of the ongoing skb.
> Only then is ocelot_port->ts_id incremented.
> 
> This is a problem because, at least theoretically, another timestampable
> skb might use the same ocelot_port->ts_id before that is incremented. So
> the logic of using and incrementing the timestamp id should be atomic
> per port.
> 
> The solution is to use the global ocelot_port->ts_id only while
> protected by the associated ocelot_port->ts_id_lock. That's where we
> populate skb->cb[0]. Note that for ocelot,
> ocelot_port_add_txtstamp_skb() is called for the actual skb, but for
> felix, it is called for the skb's clone. That is something which will
> also be changed.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 13 ++++++++++++-
>  drivers/net/ethernet/mscc/ocelot_net.c |  6 ++----
>  include/soc/mscc/ocelot.h              |  1 +
>  net/dsa/tag_ocelot.c                   | 11 +++++++----
>  4 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 5abb7d2b0a9e..8caf3afd464d 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -421,10 +421,15 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
>  
>  	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
>  	    ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> +		spin_lock(&ocelot_port->ts_id_lock);
> +
>  		shinfo->tx_flags |= SKBTX_IN_PROGRESS;
>  		/* Store timestamp ID in cb[0] of sk_buff */
> -		skb->cb[0] = ocelot_port->ts_id % 4;
> +		skb->cb[0] = ocelot_port->ts_id;
> +		ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
>  		skb_queue_tail(&ocelot_port->tx_skbs, skb);
> +
> +		spin_unlock(&ocelot_port->ts_id_lock);
>  		return 0;
>  	}
>  	return -ENODATA;
> @@ -1443,6 +1448,12 @@ int ocelot_init(struct ocelot *ocelot)
>  	if (!ocelot->stats_queue)
>  		return -ENOMEM;
>  
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +

At this point, ocelot_port is NULL because ocelot_init is called before
the port structures are allocated in mscc_ocelot_probe

> +		spin_lock_init(&ocelot_port->ts_id_lock);
> +	}
> +
>  	INIT_LIST_HEAD(&ocelot->multicast);
>  	ocelot_mact_init(ocelot);
>  	ocelot_vlan_init(ocelot);
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index cacabc23215a..8490e42e9e2d 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -349,10 +349,8 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
>  		info.rew_op = ocelot_port->ptp_cmd;
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
> -			ocelot_port->ts_id++;
> -		}
> +		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> +			info.rew_op |= skb->cb[0] << 3;
>  	}
>  
>  	ocelot_gen_ifh(ifh, &info);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index da369b12005f..4521dd602ddc 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -566,6 +566,7 @@ struct ocelot_port {
>  	u8				ptp_cmd;
>  	struct sk_buff_head		tx_skbs;
>  	u8				ts_id;
> +	spinlock_t			ts_id_lock;
>  
>  	phy_interface_t			phy_mode;
>  
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index 42f327c06dca..b4fc05cafaa6 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -160,11 +160,14 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>  	packing(injection, &qos_class, 19,  17, OCELOT_TAG_LEN, PACK, 0);
>  
>  	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
> +		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +
>  		rew_op = ocelot_port->ptp_cmd;
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -			rew_op |= (ocelot_port->ts_id  % 4) << 3;
> -			ocelot_port->ts_id++;
> -		}
> +		/* Retrieve timestamp ID populated inside skb->cb[0] of the
> +		 * clone by ocelot_port_add_txtstamp_skb
> +		 */
> +		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> +			rew_op |= clone->cb[0] << 3;
>  
>  		packing(injection, &rew_op, 125, 117, OCELOT_TAG_LEN, PACK, 0);
>  	}
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
