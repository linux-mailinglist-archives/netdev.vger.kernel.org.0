Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8EB1A582A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgDKX23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbgDKX21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:28:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9276720787;
        Sat, 11 Apr 2020 23:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586647706;
        bh=VJVMs1ty4aklYcknxXSyG4+HJQ94axF1UzhRTrFSIW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BNMeb6gh6oZRFmHIvDKwnglHNapVVyGPi3dcxR0Swnshxs6nODmwJMN02UuRHnVZL
         EJtXrd+uaB/rM7humfEMsBIefc4aJGdzX6/BdcdUNLsWJqxWWdn2T0IK/Ke379Xlp4
         7xouNBvYkutFYjAFMx/MbiTswjpVdlyUlo2Z+e2U=
Date:   Sat, 11 Apr 2020 16:28:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411162824.59791b84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200411165125.1091-1-clemens.gruber@pqgruber.com>
References: <20200411165125.1091-1-clemens.gruber@pqgruber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Apr 2020 18:51:25 +0200 Clemens Gruber wrote:
> The negotiation of flow control / pause frame modes was broken since
> commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> genphy_read_lpa()") moved the setting of phydev->duplex below the
> phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> function, phydev->pause was no longer set.
> 
> Fix it by moving the parsing of the status variable before the blocks
> dealing with the pause frames.
> 
> As the Marvell 88E1510 datasheet does not specify the timing between the
> link status and the "Speed and Duplex Resolved" bit, we have to force
> the link down as long as the resolved bit is not set, to avoid reporting
> link up before we even have valid Speed/Duplex.
> 
> Tested with a Marvell 88E1510 (RGMII to Copper/1000Base-T)
> 
> Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> ---
> Changes since v1:
> - Force link to 0 if resolved bit is not set as suggested by Russell King
> 
>  drivers/net/phy/marvell.c | 46 ++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 9a8badafea8a..561df5e33f65 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1278,6 +1278,30 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
>  	int lpa;
>  	int err;
>  
> +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
> +		phydev->link = 0;
> +		return 0;
> +	}

This doesn't address my comment, so was I wrong? What I was trying to
say is that the function updates the established link info as well as
autoneg advertising info. If the link is not resolved we can't read the
link info, but we should still report the advertising modes. No?
