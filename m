Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6A429A57
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhJLAUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhJLAUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 20:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE96860E8B;
        Tue, 12 Oct 2021 00:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633997880;
        bh=/+YQX/PAg66PdHIQG7aq8FOBYXrltg9dfRZfIiBh3Pg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAawOUUOTT/FW9q0+tpS+bxRJV4J/0zq45fyVHi8hXPyIZrrvaYr55FY90NbrKIET
         ReCCU+tuJ3jBPsFTyYadeAejShFFcAVTkyDR+9xPTfMpbZJkbDZN70D5OuXf61f+Bn
         CymmLrkHT/UOowp38Biy82NQQrOIbkRFkQSP3sPHOgRN75D2K6zXdmIx7+umBamS0u
         i87wJ+NeJjy+u0dnvV+CV1UU+wPBwV6jshuWJ3g/cNHg5/mE/II97AYk0mLLvsuoF/
         LJNr6zGw+eMUXW29mUqmzDDAWVqOMMjZlZlywfxonpdOfFwPX8819TneOZ9sQkc2/O
         VQ+QMHJDrkpSg==
Date:   Mon, 11 Oct 2021 17:17:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 2/2] net: macb: Allow SGMII only if we are a GEM in
 mac_validate
Message-ID: <20211011171759.2b59eb29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011165517.2857893-2-sean.anderson@seco.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
        <20211011165517.2857893-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 12:55:17 -0400 Sean Anderson wrote:
> This aligns mac_validate with mac_config. In mac_config, SGMII is only
> enabled if macb_is_gem. Validate should care if the mac is a gem as
> well. This also simplifies the logic now that all gigabit modes depend
> on the mac being a GEM.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Please make sure you CC the author of the original patch, they tend to
be a good person to review the change. Or at the very least validate
the Fixes tag. Adding Antoine.

>  drivers/net/ethernet/cadence/macb_main.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a9105ec1b885..ae8c969a609c 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -534,22 +534,18 @@ static void macb_validate(struct phylink_config *config,
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		if (!macb_is_gem(bp)) {
> -			if (one)
> -				goto none;
> -			else
> -				goto mii;
> -		}
> -		fallthrough;
>  	case PHY_INTERFACE_MODE_SGMII:
> -		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> -			phylink_set(mask, 1000baseT_Full);
> -			phylink_set(mask, 1000baseX_Full);
> -			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> -				phylink_set(mask, 1000baseT_Half);
> +		if (macb_is_gem(bp)) {
> +			if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +				phylink_set(mask, 1000baseT_Full);
> +				phylink_set(mask, 1000baseX_Full);
> +				if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> +					phylink_set(mask, 1000baseT_Half);
> +			}
> +		} else if (one) {
> +			goto none;
>  		}
>  		fallthrough;
> -	mii:
>  	case PHY_INTERFACE_MODE_MII:
>  	case PHY_INTERFACE_MODE_RMII:
>  		phylink_set(mask, 10baseT_Half);

