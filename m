Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7691D13F8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgEMNGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgEMNGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:06:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D2FC061A0C;
        Wed, 13 May 2020 06:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XRZP4coENPaEASSZzra9te94FAUGfjbaaParyYkAyXQ=; b=GbyxsXPvGLFQdWaSkIykDFNq+
        AOCEtd+CfIfUyXZojobQ0zAcq/Kll3RZTqtp0oiYwJF8ZmnBjEQ2XfZC6PqXOoioyPa9b/1uTqAge
        Yey49kjiUtD/0lpqpUc2yL+WFGKeJGhhIFQ1CPFBWj+lh/POB2uDKbGvsz3Y1qWn8PE/mGFgAcDxN
        +WAsh4Hpd+hvANtZ4QTGyGVL/Y/Gv0BYwTtMXDP9NOdQwYTt3kIHYOem1w1LTtRamfiGkH9Uf/wAm
        En2KUP9S4+fBwIkmGze60p24+YjDZg5HqSizJ34a7jcVxavGywWXBPzQrhR9bTLG1E7OzTCA6aNMi
        3EgpnDaGQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57492)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYr54-0004ZU-SY; Wed, 13 May 2020 14:05:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYr4q-0007nH-QV; Wed, 13 May 2020 14:05:36 +0100
Date:   Wed, 13 May 2020 14:05:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     nicolas.ferre@microchip.com
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 3/5] net: macb: fix macb_get/set_wol() when moving to
 phylink
Message-ID: <20200513130536.GI1551@shell.armlinux.org.uk>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <4aeebe901fde6db70a5ca12b10e793dd2ee6ce60.1588763703.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aeebe901fde6db70a5ca12b10e793dd2ee6ce60.1588763703.git.nicolas.ferre@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 01:37:39PM +0200, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Keep previous function goals and integrate phylink actions to them.
> 
> phylink_ethtool_get_wol() is not enough to figure out if Ethernet driver
> supports Wake-on-Lan.
> Initialization of "supported" and "wolopts" members is done in phylink
> function, no need to keep them in calling function.
> 
> phylink_ethtool_set_wol() return value is not enough to determine
> if WoL is enabled for the calling Ethernet driver. Call it first
> but don't rely on its return value as most of simple PHY drivers
> don't implement a set_wol() function.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 53e81ab048ae..24c044dc7fa0 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2817,21 +2817,23 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
>  {
>  	struct macb *bp = netdev_priv(netdev);
>  
> -	wol->supported = 0;
> -	wol->wolopts = 0;
> -
> -	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET)
> +	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
>  		phylink_ethtool_get_wol(bp->phylink, wol);
> +		wol->supported |= WAKE_MAGIC;
> +
> +		if (bp->wol & MACB_WOL_ENABLED)
> +			wol->wolopts |= WAKE_MAGIC;
> +	}
>  }
>  
>  static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
>  {
>  	struct macb *bp = netdev_priv(netdev);
> -	int ret;
>  
> -	ret = phylink_ethtool_set_wol(bp->phylink, wol);
> -	if (!ret)
> -		return 0;
> +	/* Pass the order to phylink layer.
> +	 * Don't test return value as set_wol() is often not supported.
> +	 */
> +	phylink_ethtool_set_wol(bp->phylink, wol);

If this returns an error, does that mean WOL works or does it not?

Note that if set_wol() is not supported, this will return -EOPNOTSUPP.
What about other errors?

If you want to just ignore the case where it's not supported, then
this looks like a sledge hammer to crack a nut.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
