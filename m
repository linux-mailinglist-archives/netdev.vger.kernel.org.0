Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FFC3CBD94
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhGPUTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:19:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58962 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhGPUTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 16:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PyvzVP3Cux1vqLtXKfjwOB4L5eKxtn/scqVI7PAstz0=; b=GDkUQDbWBOx8sVFgFJRMSmTREw
        GLiFdE9B9lGm78cxxMZfLt7S+/P+rcjy1Su8hYx4DbLa+zjjeXfL8mbXtQXiygrYtrGPbC2PxuekG
        O6dbecl9RLTjMCR5gnYri98T22jIbHMKCRKVzf2HtbuaNfzae4epKpjq7mouG852Q4Kc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4UG8-00Df8l-Dw; Fri, 16 Jul 2021 22:16:32 +0200
Date:   Fri, 16 Jul 2021 22:16:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: Add RGMII_ID/TXID/RXID handling to the DP83822
 driver
Message-ID: <YPHpILw+p2l6cKR9@lunn.ch>
References: <20210716182328.218768-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182328.218768-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 08:23:28PM +0200, Marek Vasut wrote:
> Add support for setting the internal clock shift of the PHY based on
> the interface requirements. RX/TX/both is supported for RGMII.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Dan Murphy <dmurphy@ti.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/phy/dp83822.c | 37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> index f7a2ec150e54..971c8d6b85d2 100644
> --- a/drivers/net/phy/dp83822.c
> +++ b/drivers/net/phy/dp83822.c
> @@ -72,6 +72,10 @@
>  #define DP83822_ANEG_ERR_INT_EN		BIT(6)
>  #define DP83822_EEE_ERROR_CHANGE_INT_EN	BIT(7)
>  
> +/* RCSR bits */
> +#define DP83822_RGMII_RX_CLOCK_SHIFT	BIT(12)
> +#define DP83822_RGMII_TX_CLOCK_SHIFT	BIT(11)
> +
>  /* INT_STAT1 bits */
>  #define DP83822_WOL_INT_EN	BIT(4)
>  #define DP83822_WOL_INT_STAT	BIT(12)
> @@ -326,11 +330,36 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
>  
>  static int dp8382x_disable_wol(struct phy_device *phydev)
>  {
> -	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
> -		    DP83822_WOL_SECURE_ON;
> +	u16 val = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON;
> +
> +	ret = phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
> +				 MII_DP83822_WOL_CFG, val);
> +	if (ret < 0)
> +		return ret;
> +
  
> -	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
> -				  MII_DP83822_WOL_CFG, value);
> +	return ret;
>  }

This change seems to have nothing to do with RGMII delays.  Please
split it out, so it does not distract from reviewing the real change
here.

It also seems odd you are changing RGMII delays when disabling WOL?
Rebase gone wrong?

	Andrew
