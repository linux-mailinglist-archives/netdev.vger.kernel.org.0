Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90902DB0BA
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgLOP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:57:26 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45699 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgLOP5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:57:05 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id DB137C0017;
        Tue, 15 Dec 2020 15:56:17 +0000 (UTC)
Date:   Tue, 15 Dec 2020 16:56:17 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 04/16] net: mscc: ocelot: use a switch-case
 statement in ocelot_netdevice_event
Message-ID: <20201215155617.GH1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-5-vladimir.oltean@nxp.com>
 <20201215155225.GG1781038@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215155225.GG1781038@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2020 16:52:26+0100, Alexandre Belloni wrote:
> On 08/12/2020 14:07:50+0200, Vladimir Oltean wrote:
> > Make ocelot's net device event handler more streamlined by structuring
> > it in a similar way with others. The inspiration here was
> > dsa_slave_netdevice_event.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_net.c | 68 +++++++++++++++++---------
> >  1 file changed, 45 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index 50765a3b1c44..47b620967156 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -1030,49 +1030,71 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
> >  					      info->upper_dev);
> >  	}
> >  
> > -	return err;
> > +	return notifier_from_errno(err);
> > +}
> > +
> > +static int
> > +ocelot_netdevice_lag_changeupper(struct net_device *dev,
> > +				 struct netdev_notifier_changeupper_info *info)
> > +{
> > +	struct net_device *lower;
> > +	struct list_head *iter;
> > +	int err = NOTIFY_DONE;
> > +
> > +	netdev_for_each_lower_dev(dev, lower, iter) {
> > +		err = ocelot_netdevice_changeupper(lower, info);
> > +		if (err)
> > +			return notifier_from_errno(err);
> > +	}
> > +
> > +	return NOTIFY_DONE;
> >  }
> >  
> >  static int ocelot_netdevice_event(struct notifier_block *unused,
> >  				  unsigned long event, void *ptr)
> >  {
> > -	struct netdev_notifier_changeupper_info *info = ptr;
> >  	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> > -	int ret = 0;
> >  
> > -	if (event == NETDEV_PRECHANGEUPPER &&
> > -	    ocelot_netdevice_dev_check(dev) &&
> > -	    netif_is_lag_master(info->upper_dev)) {
> > -		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
> > +	switch (event) {
> > +	case NETDEV_PRECHANGEUPPER: {
> > +		struct netdev_notifier_changeupper_info *info = ptr;
> > +		struct netdev_lag_upper_info *lag_upper_info;
> >  		struct netlink_ext_ack *extack;
> >  
> > +		if (!ocelot_netdevice_dev_check(dev))
> > +			break;
> > +
> > +		if (!netif_is_lag_master(info->upper_dev))
> > +			break;
> > +
> > +		lag_upper_info = info->upper_info;
> > +
> >  		if (lag_upper_info &&
> >  		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
> >  			extack = netdev_notifier_info_to_extack(&info->info);
> >  			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
> >  
> > -			ret = -EINVAL;
> > -			goto notify;
> > +			return NOTIFY_BAD;
> 
> This changes the return value in case of error, I'm not sure how
> important this is.
> 

Ok, this is removed anyway, so

Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>


> >  		}
> > +
> > +		break;
> >  	}
> > +	case NETDEV_CHANGEUPPER: {
> > +		struct netdev_notifier_changeupper_info *info = ptr;
> >  
> > -	if (event == NETDEV_CHANGEUPPER) {
> > -		if (netif_is_lag_master(dev)) {
> > -			struct net_device *slave;
> > -			struct list_head *iter;
> > +		if (ocelot_netdevice_dev_check(dev))
> > +			return ocelot_netdevice_changeupper(dev, info);
> >  
> > -			netdev_for_each_lower_dev(dev, slave, iter) {
> > -				ret = ocelot_netdevice_changeupper(slave, event, info);
> > -				if (ret)
> > -					goto notify;
> > -			}
> > -		} else {
> > -			ret = ocelot_netdevice_changeupper(dev, event, info);
> > -		}
> > +		if (netif_is_lag_master(dev))
> > +			return ocelot_netdevice_lag_changeupper(dev, info);
> > +
> > +		break;
> > +	}
> > +	default:
> > +		break;
> >  	}
> >  
> > -notify:
> > -	return notifier_from_errno(ret);
> > +	return NOTIFY_DONE;
> 
> This changes the return value from NOTIFY_OK to NOTIFY_DONE but this is
> probably what we want.
> 
> >  }
> >  
> >  struct notifier_block ocelot_netdevice_nb __read_mostly = {
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
