Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4769229ED0C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgJ2NiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2NiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:38:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C89C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 06:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dXOtKQHwECEu9wMcj/wsw6RzSt3hpYwLG8aCjam7mdA=; b=Ht+HQOErtPm6xeu4Z7RK7VI9Q
        N1P0dBcDuBqBiYJ5uy45nCaAPglSogmtI4Hga2+tgGAQhiTqcQUYN2U4tsIBvhvebJvYrzk2pJi85
        Bcib8vbUrjdvvH7pLs4FYTktj/iumjsXwYX/McRrDYHZ4Jr7J9+q1hjmJ/6TI1day9Mj9936HGK7L
        AoZ4GmjrDHqvxHFP9OrO48NWb1sWY/FmykBGVOdG8b1KiZZeshgvJ74kTLCeC+Isaf0QNJbZ8pGBM
        cPwcWTKTPWTndY3Tcl5kv5tGxHP+mTprejOVWO23vPsX6T1t4ImbwrpNmgh/OpUBIVLm5g52of6Rd
        /lMTuR2Cw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52476)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY87t-0004QB-5L; Thu, 29 Oct 2020 13:38:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY87s-00069B-Ps; Thu, 29 Oct 2020 13:38:00 +0000
Date:   Thu, 29 Oct 2020 13:38:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 5/5] net: sfp: add support for multigig RollBall
 transceivers
Message-ID: <20201029133800.GU1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028221427.22968-6-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:14:27PM +0100, Marek Behún wrote:
> This adds support for multigig copper SFP modules from RollBall/Hilink.
> These modules have a specific way to access clause 45 registers of the
> internal PHY.
> 
> We also need to wait at least 25 seconds after deasserting TX disable
> before accessing the PHY. The code waits for 30 seconds just to be sure.

Any ideas why it takes 25 seconds for the module to initialise - the
88x3310 startup is pretty fast in itself. However, it never amazes me
how broken SFP modules can be.

Extending T_WAIT is one way around this, and luckily I already catered
for the case where T_WAIT is extended beyond module_t_start_up.

Usual comment about line lengths...

> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/sfp.c | 72 ++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 65 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index a392d5fc6ab4..379358f194ee 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -165,6 +165,7 @@ static const enum gpiod_flags gpio_flags[] = {
>   * on board (for a copper SFP) time to initialise.
>   */
>  #define T_WAIT			msecs_to_jiffies(50)
> +#define T_WAIT_LONG_PHY		msecs_to_jiffies(30000)

I think call this T_WAIT_ROLLBALL.

> @@ -1675,12 +1681,40 @@ static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
>  	return 0;
>  }
>  
> +static int sfp_rollball_init_mdio(struct sfp *sfp)
> +{
> +	u8 page, password[4];
> +	int err;
> +
> +	page = 3;
> +
> +	err = sfp_write(sfp, true, SFP_PAGE, &page, 1);
> +	if (err != 1) {
> +		dev_err(sfp->dev, "Failed to set SFP page for RollBall MDIO access: %d\n", err);
> +		return err;
> +	}
> +
> +	password[0] = 0xff;
> +	password[1] = 0xff;
> +	password[2] = 0xff;
> +	password[3] = 0xff;
> +
> +	err = sfp_write(sfp, true, 0x7b, password, 4);
> +	if (err != 4) {
> +		dev_err(sfp->dev, "Failed to write password for RollBall MDIO access: %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}

I think this needs to be done in the MDIO driver - if we have userspace
or otherwise expand what we're doing, relying on page 3 remaining
selected will be very fragile.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
