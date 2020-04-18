Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51761AF164
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgDRPAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:00:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDRPAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 11:00:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3k2dnf2InJf5CY0m1dDSEfIyndBrROF/WgHcjwyBxz4=; b=KZEI8tMMhflTCK9sm+aYt1BQh5
        r0QGwzESr7kJXvksintdRLT/3sVUATQbUgfHf//Cv4Cf24va5mHEZd+9Unk7p33MfBJzdChpPBqwI
        ZzvR2BzA0fosErF5fON5HkgcP9thFH1bSG/lL3sbiM3NhEgkqJF1bTUWe24BwDKqlkoQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPoxJ-003TWR-36; Sat, 18 Apr 2020 17:00:29 +0200
Date:   Sat, 18 Apr 2020 17:00:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [RFC net-next PATCH v2 2/2] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20200418150029.GH804711@lunn.ch>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418105432.11233-3-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	if (is_of_node(dpmac_node))
> +		err = phylink_of_phy_connect(mac->phylink,
> +					     to_of_node(dpmac_node), 0);
> +	else if (is_acpi_node(dpmac_node)) {
> +		status = acpi_node_get_property_reference(dpmac_node,
> +							  "phy-handle",
> +							  0, &args);
> +		if (ACPI_FAILURE(status))
> +			goto err_phylink_destroy;
> +		phy_dev = fwnode_phy_find_device(args.fwnode);
> +		if (!phy_dev)
> +			goto err_phylink_destroy;
> +
> +		err = phylink_connect_phy(mac->phylink, phy_dev);
> +		if (err)
> +			phy_detach(phy_dev);

So it looks like you need to add a phylink_fwnode_phy_connect(). And
maybe on top of that you need a phylink_device_phy_connect()?

So please stop. Take a step back, look at how the of_, device_,
fwnode_, and acpi_ abstractions all stack on top of each other, then
propose phylib and phylink core changes to implement these
abstractions.

	Andrew
