Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B92A0B29
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgJ3QcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3QcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:32:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE848C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ctuIpJCoM6fY4m/rIYrH+Z6YQgHC14twpAnWdFRV/94=; b=wluO3gKxik9gyPOowChVp70aT
        /PnIKOWKwMUHakgUPVPha57d4L1gjw4HkqtCZD1BcPhousIyJd/t7aGHgeRI9KoMnWMzKOawL+Tx1
        nWFHijNuhFBaZIF3S9KK5VVlecXH/v28Kpgk2TwQINeG5mzHEc+vpx2vnLiYT9w7Rz84QMcitmjXG
        min6f8HFyG677y/VBAxdWBjFEQ0j1x8F6bBSlOXDGAuM9kOAXpPxmrYqQR5YH6Eu7yYYsWjydKYcF
        8Sqv9jJebY5Dtv26cwCncweO+CAbvE4WEYcclgH0WODGPtgXOW4A9pF+nKFJmax2VYOIINXFqoFML
        2GxwZMw2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52956)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYXJm-0006MD-Mg; Fri, 30 Oct 2020 16:31:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYXJm-0007J9-Fm; Fri, 30 Oct 2020 16:31:58 +0000
Date:   Fri, 30 Oct 2020 16:31:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/5] net: sfp: create/destroy I2C mdiobus
 before PHY probe/after PHY release
Message-ID: <20201030163158.GE1551@shell.armlinux.org.uk>
References: <20201029222509.27201-1-kabel@kernel.org>
 <20201029222509.27201-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029222509.27201-4-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:25:07PM +0100, Marek Behún wrote:
> @@ -1936,8 +1950,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
>  			sfp_sm_link_down(sfp);
>  		if (sfp->sm_state > SFP_S_INIT)
>  			sfp_module_stop(sfp->sfp_bus);
> -		if (sfp->mod_phy)
> +		if (sfp->mod_phy) {
>  			sfp_sm_phy_detach(sfp);
> +			sfp_i2c_mdiobus_destroy(sfp);
> +		}

		if (sfp->mod_phy)
			sfp_sm_phy_detach(sfp);
		if (sfp->i2c_mii)
			sfp_i2c_mdiobus_destroy(sfp);

would be better IMHO, in case we end up with the MDIO bus registered
but don't discover a PHY. (which is entirely possible with Mikrotik
SFPs where the PHY is not accessible.)

Other than that, I don't see any obvious issues.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
