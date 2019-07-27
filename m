Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0161977B3C
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbfG0SxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:53:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42398 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbfG0SxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=covUQ5YlTMmZ1d1AuGCbTv+DxOfUBDuShOI19nDbUYM=; b=FcPe5PAuEocrke1UDZ/bKtZ+a
        yFBzp7z0k/jxWa1lFJMtXNhgSYSS3fqiRhWB7+Z8dIP8FjTDkAuSog96+DW/VoBr91PE5BcRZQ1UH
        awzF24JVk59ES15JNTXL26QEKwRrmNqgBkzYCqreDfEqAcd7Ez2nWkivF3/wmDpWdv231F3OHNdzs
        uXVIOYz8i8rYQc2AKul6RdbFFOl633TWuYCRVJMtyrD30dygGXOiVxS6OUkAn04Od/iaqet9FgTrK
        h+psXs9/MTdxSJk50v5qPc/GZ2w/j2jOSPnwJUHk1OyhtfootyggzmOdd7B33m557vR8m6sfqyy7k
        9R8mNvSRg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49416)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hrRok-000565-CC; Sat, 27 Jul 2019 19:53:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hrRoh-0007yD-S7; Sat, 27 Jul 2019 19:53:15 +0100
Date:   Sat, 27 Jul 2019 19:53:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mt7530: Add support for port 5
Message-ID: <20190727185315.GU1330@shell.armlinux.org.uk>
References: <20190724192549.24615-1-opensource@vdorst.com>
 <20190724192549.24615-4-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190724192549.24615-4-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 09:25:49PM +0200, René van Dorst wrote:
> Adding support for port 5.
> 
> Port 5 can muxed/interface to:
> - internal 5th GMAC of the switch; can be used as 2nd CPU port or as
>   extra port with an external phy for a 6th ethernet port.
> - internal PHY of port 0 or 4; Used in most applications so that port 0
>   or 4 is the WAN port and interfaces with the 2nd GMAC of the SOC.

...

> @@ -1381,15 +1506,19 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  
> -	if (state->interface != PHY_INTERFACE_MODE_TRGMII) {
> +	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +	} else {
>  		phylink_set(mask, 10baseT_Half);
>  		phylink_set(mask, 10baseT_Full);
>  		phylink_set(mask, 100baseT_Half);
>  		phylink_set(mask, 100baseT_Full);
> -		phylink_set(mask, 1000baseT_Half);
> -	}
>  
> -	phylink_set(mask, 1000baseT_Full);
> +		if (state->interface != PHY_INTERFACE_MODE_MII) {
> +			phylink_set(mask, 1000baseT_Half);
> +			phylink_set(mask, 1000baseT_Full);
> +		}
> +	}

As port 5 could use an external PHY, and it supports gigabit speeds,
consider that the PHY may provide not only copper but also fiber
connectivity, so port 5 should probably also have 1000baseX modes
too, which would allow such a PHY to bridge the switch to fiber.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
