Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D041A4CF9
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgDKAnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgDKAnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 20:43:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E7F20769;
        Sat, 11 Apr 2020 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586565787;
        bh=pK/hEpQ3ocfQm9eoETGX0U+EnLUpz3/wOy/mYdwDFc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ark+FA4qSe+dBCUDQE6KWvZRp747L8gQHoQGY6teQyw/rZoyAa1rlcpY8pLka54qm
         68ehq6CJkDxflniVmqHwuxHtfuFqDc85IjBkgUDFjjFzm3JU46phmvCdZMvLntQCt9
         T3Y8Rf/V4eWAeCArmzfHbAz6MejiwufZluIVsMLs=
Date:   Fri, 10 Apr 2020 17:43:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
References: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Apr 2020 23:43:26 +0200 Clemens Gruber wrote:
> The negotiation of flow control / pause frame modes was broken since
> commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> genphy_read_lpa()") moved the setting of phydev->duplex below the
> phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> function, phydev->pause was no longer set.
> 
> Fix it by moving the parsing of the status variable before the blocks
> dealing with the pause frames.
> 
> Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> Cc: stable@vger.kernel.org # v5.6+

nit: please don't CC stable on networking patches

> Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> ---
>  drivers/net/phy/marvell.c | 44 +++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4714ca0e0d4b..02cde4c0668c 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1263,6 +1263,28 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
>  	int lpa;
>  	int err;
>  
> +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
> +		return 0;

If we return early here won't we miss updating the advertising bits?
We will no longer call e.g. fiber_lpa_mod_linkmode_lpa_t().

Perhaps extracting info from status should be moved to a helper so we
can return early without affecting the rest of the flow?

Is my understanding correct?  Russell?

> +	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
> +		phydev->duplex = DUPLEX_FULL;
> +	else
> +		phydev->duplex = DUPLEX_HALF;
> +
> +	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
> +	case MII_M1011_PHY_STATUS_1000:
> +		phydev->speed = SPEED_1000;
> +		break;
> +
> +	case MII_M1011_PHY_STATUS_100:
> +		phydev->speed = SPEED_100;
> +		break;
> +
> +	default:
> +		phydev->speed = SPEED_10;
> +		break;
> +	}
> +
>  	if (!fiber) {
>  		err = genphy_read_lpa(phydev);
>  		if (err < 0)
> @@ -1291,28 +1313,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
>  		}
>  	}
>  
> -	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
> -		return 0;
> -
> -	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
> -		phydev->duplex = DUPLEX_FULL;
> -	else
> -		phydev->duplex = DUPLEX_HALF;
> -
> -	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
> -	case MII_M1011_PHY_STATUS_1000:
> -		phydev->speed = SPEED_1000;
> -		break;
> -
> -	case MII_M1011_PHY_STATUS_100:
> -		phydev->speed = SPEED_100;
> -		break;
> -
> -	default:
> -		phydev->speed = SPEED_10;
> -		break;
> -	}
> -
>  	return 0;
>  }
>  

