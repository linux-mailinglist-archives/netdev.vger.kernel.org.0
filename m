Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C193B39C3CD
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhFDXUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:20:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFDXUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qVV8qeSIgXZgYx6qo+sfC+ri7bZ6M6hZ5swJC0d7/1s=; b=jYz0XMOU+2IjXqq1h/OMvND2K2
        YqhABUP1u9GjhGB8/ntVj8S1zTa2WcRzPyo8aj0blaEpltsJcJC12XKDWcUGmRdj6yccRlZ50f/LD
        UNPq7KNZO5oKz4F4q0fbNQirEjtCsuqWabmfB6vXKp7ZjdatTVdnJXABJntQ5OoZZRYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpJ5d-007sJt-IP; Sat, 05 Jun 2021 01:18:57 +0200
Date:   Sat, 5 Jun 2021 01:18:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/7] net: usb: asix: ax88772: add phylib
 support
Message-ID: <YLq04ap4kjuPRKVe@lunn.ch>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604134244.2467-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 03:42:39PM +0200, Oleksij Rempel wrote:
> To be able to use ax88772 with external PHYs and use advantage of

s/use/take/

> +/* MDIO read and write wrappers for phylib */
> +int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
> +{
> +	return asix_mdio_read(((struct usbnet *)bus->priv)->net, phy_id,
> +			      regnum);
> +}

Please avoid this cast. priv should be a void *, so you can do

       struct usbnet *priv = bus->priv;

       return asix_mdio_read(priv->net, phy_id, regnum);

> +static int ax88772_init_phy(struct usbnet *dev)
> +{
> +	struct asix_common_private *priv = dev->driver_priv;
> +	int ret;
> +
> +	priv->phy_addr = asix_get_phy_addr(dev);
> +	/* asix_read_phy_addr() is using ret < 2 as error value */
> +	if (priv->phy_addr < 2)
> +		return -ENODEV;

Really?

ax88172a.c does not check. ax88172_bind() does not
check. ax88772_bind() does not check. As far as i can see, nothing
really cares.

So please add another cleanup patch and make asix_read_phy_addr()
return -ENODEV.

Otherwise, this looks O.K.
