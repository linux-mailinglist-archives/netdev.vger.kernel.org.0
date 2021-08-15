Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0698E3ECBC0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 01:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhHOXPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 19:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhHOXPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 19:15:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEE0C061764;
        Sun, 15 Aug 2021 16:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ukcf6pC3mCMR6ssxvgr9l5C10OoYxo/bOI2Y+cVxSPc=; b=NRK5DJdHct6yBXSiXXHCn15Yz
        4GGctlcWGriHC3qV9doHHx2alzYLSZ8lgz6tX75tjCb0zR1F0WBUuRnOdUIqA55IqjpI/daSgxZzV
        36h3xQRLIMvW0ev8FynGXsMoO++dcYboCZqfp54jkeNJea2KMlHj0xHN8ifQECbReXFNRpMl2Pb/Y
        Zx9UgZF8p1kil6JWdi7AoFxY46OxtyLR7agONAeuHtkqb5uz5MoiizKaAD0gpSxvnbLi3Vjsv+ZHM
        vxOH8RuciNaAjixub3ZyRbAr2NtJkBtlP+iRCMBsSK7P3XUx8XxF2sSm3KXfAknEV6IgPAyO2upHN
        GYoVHSqGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47338)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFPLE-0006tj-Ej; Mon, 16 Aug 2021 00:14:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFPLC-0007OV-Gl; Mon, 16 Aug 2021 00:14:54 +0100
Date:   Mon, 16 Aug 2021 00:14:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210815231454.GD22278@shell.armlinux.org.uk>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
 <20210815204149.GB3328995@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815204149.GB3328995@euler>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 01:41:49PM -0700, Colin Foster wrote:
> I also came across some curious code in Seville where it is callocing a
> struct phy_device * array instead of struct lynx_pcs *. I'm not sure if
> that's technically a bug or if the thought is "a pointer array is a 
> pointer array."

I won't comment on that, but a few things I spotted in the patch:

> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index a84129d18007..d0b3f6be360f 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1046,7 +1046,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>  	int rc;
>  
>  	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
> -				  sizeof(struct lynx_pcs *),
> +				  sizeof(struct phylink_pcs *),
>  				  GFP_KERNEL);
>  	if (!felix->pcs) {
>  		dev_err(dev, "failed to allocate array for PCS PHYs\n");
> @@ -1095,8 +1095,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>  
>  	for (port = 0; port < felix->info->num_ports; port++) {
>  		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +		struct phylink_pcs *phylink;
>  		struct mdio_device *pcs;
> -		struct lynx_pcs *lynx;

Normally, "phylink" is used to refer to the main phylink data
structure, so I'm not too thrilled to see it getting re-used for the
PCS. However, as you have a variable called "pcs" already, I suppose
you don't have much choice.

That said, it would be nice to have consistent naming through at
least a single file, and you do have "pcs" below to refer to this
same thing.

Maybe using plpcs or ppcs would suffice? Or maybe use the "long name"
of phylink_pcs ?

>  
>  		if (dsa_is_unused_port(felix->ds, port))
>  			continue;
> @@ -1108,13 +1108,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>  		if (IS_ERR(pcs))
>  			continue;
>  
> -		lynx = lynx_pcs_create(pcs);
> +		phylink = lynx_pcs_create(pcs);
>  		if (!lynx) {

I think you want to change this test.

>  			mdio_device_free(pcs);
>  			continue;
>  		}
>  
> -		felix->pcs[port] = lynx;
> +		felix->pcs[port] = phylink;
>  
>  		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
>  	}
> @@ -1128,7 +1128,7 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
>  	int port;
>  
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		struct lynx_pcs *pcs = felix->pcs[port];
> +		struct phylink_pcs *pcs = felix->pcs[port];
>  
>  		if (!pcs)
>  			continue;
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 540cf5bc9c54..8200cc5dd24d 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1007,7 +1007,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>  	int rc;
>  
>  	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
> -				  sizeof(struct phy_device *),
> +				  sizeof(struct phylink_pcs *),
>  				  GFP_KERNEL);
>  	if (!felix->pcs) {
>  		dev_err(dev, "failed to allocate array for PCS PHYs\n");
> @@ -1029,8 +1029,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>  	for (port = 0; port < felix->info->num_ports; port++) {
>  		struct ocelot_port *ocelot_port = ocelot->ports[port];
>  		int addr = port + 4;
> +		struct phylink_pcs *phylink;
>  		struct mdio_device *pcs;
> -		struct lynx_pcs *lynx;
>  
>  		if (dsa_is_unused_port(felix->ds, port))
>  			continue;
> @@ -1042,13 +1042,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>  		if (IS_ERR(pcs))
>  			continue;
>  
> -		lynx = lynx_pcs_create(pcs);
> +		phylink = lynx_pcs_create(pcs);
>  		if (!lynx) {

Same here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
