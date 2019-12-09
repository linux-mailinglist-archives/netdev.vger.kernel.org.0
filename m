Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5487B116C45
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLIL0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:26:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60494 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfLIL0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:26:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=akxLL3oKZDIODtU4VaGq10g2omBsTahFa+R881Y8Vxk=; b=cHa1zJrSDM8jCsFEqJZZS1zc9
        fSSyVrt5QBMYMHprM3+HcLnRmCAABT6+Lz++QkBu3MonINXQ5f1jdK8WG5xdelxgRzfSXzkEcxDNA
        ZxbIb3Dh+c991zK3J46SFKMLWndRpDSYrqclEbKYGyfu43TWzrTfx8okAu/S9xBN9qh5Sps1w58zT
        y7zTr94vM2V53ApHnYW5ikyTm1/CSbg8bjAbVPzfGsjhHc1w5VlHSPn/BoNyACBPj/Ns19+orGzym
        GNQRlaXLITgJ0vjrhkMGGKjhj5HB9JeOR4X6FyiVTyoaQtpUgGJsmDTykiRIKxHFOKaaywN0jjK+T
        puBIc4uMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50572)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieHBF-0002dl-Ab; Mon, 09 Dec 2019 11:26:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieHB9-0003aj-GO; Mon, 09 Dec 2019 11:26:15 +0000
Date:   Mon, 9 Dec 2019 11:26:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     nicolas.nerre@microchip.com, andrew@lunn.ch,
        antoine.tenart@bootlin.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        a.fatoum@pengutronix.de, brad.mouring@ni.com, pthombar@cadence.com
Subject: Re: [PATCH 1/3] net: macb: fix for fixed-link mode
Message-ID: <20191209112615.GE25745@shell.armlinux.org.uk>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890061-24250-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575890061-24250-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 11:14:21AM +0000, Milind Parab wrote:
> This patch fix the issue with fixed link. With fixed-link
> device opening fails due to macb_phylink_connect not
> handling fixed-link mode, in which case no MAC-PHY connection
> is needed and phylink_connect return success (0), however
> in current driver attempt is made to search and connect to
> PHY even for fixed-link.
> 
> Signed-off-by: Milind Parab <mparab@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 9c767ee252ac..6b68ef34ab19 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -615,17 +615,13 @@ static int macb_phylink_connect(struct macb *bp)
>  {
>  	struct net_device *dev = bp->dev;
>  	struct phy_device *phydev;
> +	struct device_node *dn = bp->pdev->dev.of_node;
>  	int ret;
>  
> -	if (bp->pdev->dev.of_node &&
> -	    of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
> -		ret = phylink_of_phy_connect(bp->phylink, bp->pdev->dev.of_node,
> -					     0);
> -		if (ret) {
> -			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> -			return ret;
> -		}
> -	} else {
> +	if (dn)
> +		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
> +
> +	if (!dn || (ret && !of_parse_phandle(dn, "phy-handle", 0))) {

Hi,

If of_parse_phandle() returns non-null, the device_node it returns will
have its reference count increased by one.  That reference needs to be
put.

I assume you're trying to determine whether phylink_of_phy_connect()
failed because of a missing phy-handle rather than of_phy_attach()
failing?  Maybe those two failures ought to be distinguished by errno
return value?

of_phy_attach() may fail due to of_phy_find_device() failing to find
the PHY, or phy_attach_direct() failing.  We could switch from using
of_phy_attach(), to using of_phy_find_device() directly so we can then
propagate phy_attach_direct()'s error code back, rather than losing it.
That would then leave the case of of_phy_find_device() failure to be
considered in terms of errno return value.

>  		phydev = phy_find_first(bp->mii_bus);
>  		if (!phydev) {
>  			netdev_err(dev, "no PHY found\n");
> @@ -638,6 +634,9 @@ static int macb_phylink_connect(struct macb *bp)
>  			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
>  			return ret;
>  		}
> +	} else if (ret) {
> +		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> +		return ret;
>  	}
>  
>  	phylink_start(bp->phylink);
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
