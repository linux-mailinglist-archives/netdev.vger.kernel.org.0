Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32C20A60B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406838AbgFYTmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:42:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406069AbgFYTmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:42:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joXlD-002FVk-Eb; Thu, 25 Jun 2020 21:42:11 +0200
Date:   Thu, 25 Jun 2020 21:42:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Message-ID: <20200625194211.GA535869@lunn.ch>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 10:05:38AM +0530, Calvin Johnson wrote:

> +static struct phy_device *dpaa2_find_phy_device(struct fwnode_handle *fwnode)
> +{
> +	struct fwnode_reference_args args;
> +	struct platform_device *pdev;
> +	struct mii_bus *mdio;
> +	struct device *dev;
> +	acpi_status status;
> +	int addr;
> +	int err;
> +
> +	status = acpi_node_get_property_reference(fwnode, "mdio-handle",
> +						  0, &args);
> +
> +	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> +		return NULL;
> +
> +	dev = bus_find_device_by_fwnode(&platform_bus_type, args.fwnode);
> +	if (IS_ERR_OR_NULL(dev))
> +		return NULL;
> +	pdev =  to_platform_device(dev);
> +	mdio = platform_get_drvdata(pdev);
> +
> +	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +	if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
> +		return NULL;
> +
> +	return mdiobus_get_phy(mdio, addr);
> +}

Hi Calvin

I think this needs putting somewhere global, since you are effectively
defines how all ACPI MACs will find their PHY. This becomes the
defacto standard until the ACPI standards committee comes along and
tells you, you are doing it wrong, it should be like....

Does Linux have a location to document all its defacto standard ACPI
stuff? It would be good to document this somewhere.

       Andrew
