Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A482DB0A8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgLOP5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:57:55 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36025 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730435AbgLOP5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:57:44 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 31CD16000E;
        Tue, 15 Dec 2020 15:56:59 +0000 (UTC)
Date:   Tue, 15 Dec 2020 16:56:58 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 05/16] net: mscc: ocelot: don't refuse
 bonding interfaces we can't offload
Message-ID: <20201215155658.GI1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-6-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:51+0200, Vladimir Oltean wrote:
> Since switchdev/DSA exposes network interfaces that fulfill many of the
> same user space expectations that dedicated NICs do, it makes sense to
> not deny bonding interfaces with a bonding policy that we cannot offload,
> but instead allow the bonding driver to select the egress interface in
> software.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 38 ++++++++++----------------
>  1 file changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 47b620967156..77957328722a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1022,6 +1022,15 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
>  		}
>  	}
>  	if (netif_is_lag_master(info->upper_dev)) {
> +		struct netdev_lag_upper_info *lag_upper_info;
> +
> +		lag_upper_info = info->upper_info;
> +
> +		/* Only offload what we can */
> +		if (lag_upper_info &&
> +		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
> +			return NOTIFY_DONE;
> +
>  		if (info->linking)
>  			err = ocelot_port_lag_join(ocelot, port,
>  						   info->upper_dev);
> @@ -1037,10 +1046,16 @@ static int
>  ocelot_netdevice_lag_changeupper(struct net_device *dev,
>  				 struct netdev_notifier_changeupper_info *info)
>  {
> +	struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
>  	struct net_device *lower;
>  	struct list_head *iter;
>  	int err = NOTIFY_DONE;
>  
> +	/* Can't offload LAG => also do bridging in software */
> +	if (lag_upper_info &&
> +	    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
> +		return NOTIFY_DONE;
> +
>  	netdev_for_each_lower_dev(dev, lower, iter) {
>  		err = ocelot_netdevice_changeupper(lower, info);
>  		if (err)
> @@ -1056,29 +1071,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
>  	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>  
>  	switch (event) {
> -	case NETDEV_PRECHANGEUPPER: {
> -		struct netdev_notifier_changeupper_info *info = ptr;
> -		struct netdev_lag_upper_info *lag_upper_info;
> -		struct netlink_ext_ack *extack;
> -
> -		if (!ocelot_netdevice_dev_check(dev))
> -			break;
> -
> -		if (!netif_is_lag_master(info->upper_dev))
> -			break;
> -
> -		lag_upper_info = info->upper_info;
> -
> -		if (lag_upper_info &&
> -		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
> -			extack = netdev_notifier_info_to_extack(&info->info);
> -			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
> -
> -			return NOTIFY_BAD;
> -		}
> -
> -		break;
> -	}
>  	case NETDEV_CHANGEUPPER: {
>  		struct netdev_notifier_changeupper_info *info = ptr;
>  
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
