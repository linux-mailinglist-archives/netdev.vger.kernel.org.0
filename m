Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6A22DAF38
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgLOOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:44:14 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39877 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbgLOOoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:44:13 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 39CC260002;
        Tue, 15 Dec 2020 14:43:26 +0000 (UTC)
Date:   Tue, 15 Dec 2020 15:43:25 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 02/16] net: mscc: ocelot: allow offloading
 of bridge on top of LAG
Message-ID: <20201215144325.GD1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:48+0200, Vladimir Oltean wrote:
> Commit 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for
> other netdevs") was too aggressive, and it made ocelot_netdevice_event
> react only to network interface events emitted for the ocelot switch
> ports.
> 
> In fact, only the PRECHANGEUPPER should have had that check.
> 
> When we ignore all events that are not for us, we miss the fact that the
> upper of the LAG changes, and the bonding interface gets enslaved to a
> bridge. This is an operation we could offload under certain conditions.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 93ecd5274156..6fb2a813e694 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1047,10 +1047,8 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
>  	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>  	int ret = 0;
>  
> -	if (!ocelot_netdevice_dev_check(dev))
> -		return 0;
> -
>  	if (event == NETDEV_PRECHANGEUPPER &&
> +	    ocelot_netdevice_dev_check(dev) &&
>  	    netif_is_lag_master(info->upper_dev)) {
>  		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
>  		struct netlink_ext_ack *extack;
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
