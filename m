Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714EB41716B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbhIXMBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 08:01:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245069AbhIXMBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 08:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k62SIk6iB0ofAbWbmM8qVQP8XfyHSopwSGdFcY84pgw=; b=AwKgU7EVZ8cpWrCXUBmSdUPhBB
        vVSoFGbqEw5/Ibiij9dPryUqmJWXGR6X4VxT/wCAEZX0CFGyhdA0RWSMelRnLuTKSLD5Z23JK0aex
        rQKxapKf2tZBwrfvQ4TtrVKbcCFc7EZaVQ5wrlajpYRPgyJB53GSw3OZpHtDoB1Tb6K4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mTjru-0085OP-MB; Fri, 24 Sep 2021 13:59:54 +0200
Date:   Fri, 24 Sep 2021 13:59:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH] net: phy: enhance GPY115 loopback disable function
Message-ID: <YU29ulYZSlzKVtaE@lunn.ch>
References: <20210924090537.48972-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924090537.48972-1-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:05:37PM +0800, Xu Liang wrote:
> GPY115 need reset PHY when it comes out from loopback mode if the firmware
> version number (lower 8 bits) is equal to or below 0x76.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---
>  drivers/net/phy/mxl-gpy.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> index 2d5d5081c3b6..3ef62d5c4776 100644
> --- a/drivers/net/phy/mxl-gpy.c
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -493,6 +493,32 @@ static int gpy_loopback(struct phy_device *phydev, bool enable)
>  	return ret;
>  }
>  
> +static int gpy115_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int ret;
> +	int fw_minor;
> +
> +	if (enable)
> +		return gpy_loopback(phydev, enable);
> +
> +	/* Show GPY PHY FW version in dmesg */

You don't show anything.

> +	ret = phy_read(phydev, PHY_FWV);
> +	if (ret < 0)
> +		return ret;
> +
> +	fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, ret);
> +	if (fw_minor > 0x0076)
> +		return gpy_loopback(phydev, 0);
> +
> +	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, BMCR_RESET);
> +	if (!ret) {
> +		/* Some delay for the reset complete. */
> +		msleep(100);
> +	}

genphy_soft_reset() would be better. Does a soft reset clear the
BMCR_LOOPBACK bit? It should do, according to C22.

	      Andrew
