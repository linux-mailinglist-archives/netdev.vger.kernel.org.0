Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6727EF4B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgI3Qeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:34:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:34:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNf3w-00GvXT-6Z; Wed, 30 Sep 2020 18:34:40 +0200
Date:   Wed, 30 Sep 2020 18:34:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200930163440.GR3996795@lunn.ch>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Extract the phy ID from the compatible string of the form
> + * ethernet-phy-idAAAA.BBBB.
> + */
> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +	unsigned int upper, lower;
> +	const char *cp;
> +	int ret;
> +
> +	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> +	if (ret)
> +		return ret;
> +
> +	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> +		*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(fwnode_get_phy_id);

Hi Calvin

Do you really need this? Do you have a board with a broken PHY ID?

>  /**
>   * get_phy_device - reads the specified PHY device and returns its @phy_device
>   *		    struct
> @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
>   */
>  struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
>  {
> -	return fwnode_find_reference(fwnode, "phy-handle", 0);
> +	struct fwnode_handle *phy_node;
> +
> +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> +		return phy_node;
> +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
> +	if (IS_ERR(phy_node))
> +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> +	return phy_node;

Why do you have three different ways to reference a PHY?

    Andrew
