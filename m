Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5444BC7F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhKJIEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhKJIEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:04:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DF0C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 00:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HDnLy2ce+Is+RbY616jzj9RoiO3IHy5vfTh6QGQtcyA=; b=qpseWTWALrrMXc+KroScYDvaxw
        gxl1ZxDT9MEinFo5flGeFErpyD6UYsEGAoMYfZqdZlO9/zIkj1we5qIZn1nfTwFynMCL6r6VB6rJ+
        JGqqcuiH95Jp5tvW+c3MR325AwDkjtFSPC2C175sTIpS5aHvkLhd9xZHJfItp9Pj31SAQUDKhLA/R
        WtrCLVNcfCQcDNQF1CpBjkvR5M4NkSeGpg8jnKTjHAswxShzx5c4KUgsoXfCqyhUxsREx7aZTHVbb
        0lK96O1QEunQpr7+211cprdvcNo3OuUg5AatXVp9W0Vu7oOteMeneFcvBzHZ5qVHciZTNVrr4drDq
        602jqkmg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55564)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mkiYI-0002w4-0r; Wed, 10 Nov 2021 08:01:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mkiYG-0004YO-OY; Wed, 10 Nov 2021 08:01:48 +0000
Date:   Wed, 10 Nov 2021 08:01:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net 1/3] net: dsa: mv88e6xxx: Fix forcing speed & duplex
 when changing to 2500base-x mode
Message-ID: <YYt8bE3iA2Kmn5Mt@shell.armlinux.org.uk>
References: <20211110041010.2402-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211110041010.2402-1-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please wait before applying; I have comments on these patches, but I
won't have time to provide those comments for a couple of days.
Thanks.

On Wed, Nov 10, 2021 at 05:10:08AM +0100, Marek Behún wrote:
> Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
> in mac_config") removed forcing of speed and duplex from
> mv88e6xxx_mac_config(), where the link is forced down, and left it only
> in mv88e6xxx_mac_link_up(), by which time link is unforced.
> 
> It seems that in 2500base-x (at least on 88E6190), if the link is not
> forced down, the forcing of new settings for speed and duplex doesn't
> take.
> 
> Fix this by forcing link down.
> 
> Fixes: 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings in mac_config")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f00cbf5753b9..ddb13cecb3ac 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -785,12 +785,17 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
>  	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
>  	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
>  	    mode == MLO_AN_FIXED) {
> -		/* FIXME: for an automedia port, should we force the link
> -		 * down here - what if the link comes up due to "other" media
> -		 * while we're bringing the port up, how is the exclusivity
> -		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
> -		 * shared between internal PHY and Serdes.
> +		/* FIXME: we need to force the link down here, otherwise the
> +		 * forcing of link speed and duplex by .port_set_speed_duplex()
> +		 * doesn't work for some modes.
> +		 * But what if the link comes up due to "other" media while
> +		 * we're bringing the port up, how is the exclusivity handled in
> +		 * the Marvell hardware? E.g. port 2 on 88E6390 shared between
> +		 * internal PHY and Serdes.
>  		 */
> +		if (ops->port_sync_link)
> +			err = ops->port_sync_link(chip, port, mode, false);
> +
>  		err = mv88e6xxx_serdes_pcs_link_up(chip, port, mode, speed,
>  						   duplex);
>  		if (err)
> -- 
> 2.32.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
