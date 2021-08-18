Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D1C3F0757
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhHRPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:04:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238799AbhHRPEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 11:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HIuZCEBQnpQVamjQq3pe2v5AHETPvUj/i5Efc0vIzrk=; b=VYB4304Yn2yNgUiRH736gCw1M2
        aVtv5WWsr02GBcPlq7Yt/mQRRdC93WV+hyORMe32knHOw+aa8Of5x/0oH64qTNJgFca3Ke3D3eGY/
        XWP8Kx3+evAgnuL8t88myAOZgjof8z5v9PsTNngHovSGpDS9IGGYHwm8z+qoICmHz9X4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGN6J-000nm4-TB; Wed, 18 Aug 2021 17:03:31 +0200
Date:   Wed, 18 Aug 2021 17:03:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: Support set_loopback override
Message-ID: <YR0hQ6UmtmGNg2AW@lunn.ch>
References: <20210818122736.4877-1-gerhard@engleder-embedded.com>
 <20210818122736.4877-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818122736.4877-2-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:27:35PM +0200, Gerhard Engleder wrote:
> phy_read_status and various other PHY functions support PHY specific
> overriding of driver functions by using a PHY specific pointer to the
> PHY driver. Add support of PHY specific override to phy_loopback too.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/phy/phy_device.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 107aa6d7bc6b..ba5ad86ec826 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1821,11 +1821,10 @@ EXPORT_SYMBOL(phy_resume);
>  
>  int phy_loopback(struct phy_device *phydev, bool enable)
>  {
> -	struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
>  	int ret = 0;
>  
> -	if (!phydrv)
> -		return -ENODEV;
> +	if (!phydev->drv)
> +		return -EIO;

Humm, we need to take a closer look at what uses to_phy_driver() and
what uses phydev->drv. Do they need to be different? Can we make it
uniform?

	Andrew
