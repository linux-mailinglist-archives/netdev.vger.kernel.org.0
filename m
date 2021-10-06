Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93942494E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbhJFV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:59:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53006 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239767AbhJFV7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 17:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UVB0rr2MhmRujdJsYsVtjny4rHM/yKL9HVbtaS/T3I4=; b=fJnFhD7SgBUJdS9gYooapFSuVz
        pBL8NFaC7x7gw5E/11Z9hjB67C4hAKE8n7YrNzVoOwfjABIvES9f6RYbUJrs1rJIEUDYjdiuSHyag
        tvX6ZheNf650nJyviGWtY4McPnJALldBf0JiVr/549RGX51DCaL5w+YbgnNnNABRzjRo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYEv3-009sdt-Gb; Wed, 06 Oct 2021 23:57:45 +0200
Date:   Wed, 6 Oct 2021 23:57:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        philippe.schenker@toradex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: ksz9131 led errata workaround
Message-ID: <YV4b2QRZu0yL4Ss0@lunn.ch>
References: <20211006073755.429469-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006073755.429469-1-francesco.dolcini@toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 09:37:55AM +0200, Francesco Dolcini wrote:
> Micrel KSZ9131 PHY LED behavior is not correct when configured in
> Individual Mode, LED1 (Activity LED) is in the ON state when there is
> no-link.
> 
> Workaround this by setting bit 9 of register 0x1e after verifying that
> the LED configuration is Individual Mode.
> 
> This issue is described in KSZ9131RNX Silicon Errata DS80000693B
> (http://ww1.microchip.com/downloads/en/DeviceDoc/80000863A.pdf) and
> according to that it will not be corrected in a future silicon revision.
> 
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/net/phy/micrel.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index c330a5a9f665..661dedec84c4 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1003,6 +1003,23 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
>  			      txcdll_val);
>  }
>  
> +/* Silicon Errata DS80000693B
> + *
> + * When LEDs are configured in Individual Mode, LED1 is ON in a no-link
> + * condition. Workaround is to set register 0x1e, bit 9, this way LED1 behaves
> + * according to the datasheet (off if there is no link).
> + */
> +
> +static int ksz9131_led_errata(struct phy_device *phydev)
> +{
> +	int ret = 0;
> +
> +	if (phy_read_mmd(phydev, 2, 0) & BIT(4))

It would be good to check the return code here. If there is an error,
you are going to set bit 9.

Otherwise this looks O.K.

	  Andrew
