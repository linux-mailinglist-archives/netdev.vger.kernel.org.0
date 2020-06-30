Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4729420EACD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgF3BTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:19:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgF3BTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:19:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jq4va-002v3I-Tb; Tue, 30 Jun 2020 03:19:14 +0200
Date:   Tue, 30 Jun 2020 03:19:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next 3/8] smsc95xx: add PAL support to use external
 PHY drivers
Message-ID: <20200630011914.GE597495@lunn.ch>
References: <26c4eee749db5a5430fa9df9c12651dd34bdbaa6.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c4eee749db5a5430fa9df9c12651dd34bdbaa6.camel@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int smsc95xx_start_phy(struct usbnet *dev)
> +{
> +	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev-
> >data[0]);
> +	struct net_device *net = dev->net;
> +	int ret;
> +
> +	ret = smsc95xx_reset(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* attach the mac to the phy */
> +	ret = phy_connect_direct(net, pdata->phydev,
> +				 &smsc95xx_handle_link_change,
> +				 PHY_INTERFACE_MODE_MII);
> +	if (ret) {
> +		netdev_err(net, "can't attach PHY to %s\n", pdata-
> >mdiobus->id);
> +		return ret;
> +	}
> +
> +	phy_attached_info(net->phydev);
> +	phy_start(net->phydev);
> +	mii_nway_restart(&dev->mii);

Is mii_nway_restart() needed? phy_start will start auto-neg if needed.

It looks like after this patch you have a mixture of old MII and new
phylib. Does that work? If somebody doing a git bisect was to land on
one of these intermediary patches, so they have working Ethernet?

    Andrew
