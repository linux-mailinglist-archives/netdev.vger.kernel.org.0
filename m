Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE470367C2E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhDVIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235216AbhDVIQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 04:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2079613DC;
        Thu, 22 Apr 2021 08:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619079375;
        bh=poQJR1pO5d3haclh9Pnw8hwLbFU79fJkKdVKmgVjTwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TfCp2hF3b5rwma1VIyd64845DC/YFDd9meDPC9Od2JNXxK7/mWKQ8+7OWFWouUbYP
         Mf1uYTrVdZYoFWPs3aHVTCQBVPhBsVsUgjdMyqD9tdahayOW6bOf0+tHZLa5VkBU82
         COKWDf5mQTFazB/PcPNJNKO1aYfRJ0MGLAA8PKCMHYg/Dr2vHRtNKceozySPYPxYxt
         mlPrzH1vXDCCV0Da8LB8jiT3ZwORXSF9CpBWmT7TzXjXjjan4lw8Q/2/oB1J9thmra
         QZ96lSW6Furg8uHUVN9mjh9JZezrXig4NaPpbIPDAOt7/0Bo9ITd3uSSIIymr2BaUo
         S3XsGdOGHPuvQ==
Date:   Thu, 22 Apr 2021 11:16:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     mohammad.athari.ismail@intel.com
Cc:     Jose Abreu <joabreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Message-ID: <YIEwy1VnPuOP7Wuz@unreal>
References: <20210422074851.17375-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422074851.17375-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:48:51PM +0800, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet for
> 10/100Mbps by default. This setting doesn`t impact pre-emption
> capability for other speeds.
> 
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> ---
>  drivers/net/pcs/pcs-xpcs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 944ba105cac1..2dbc1d46821e 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -66,6 +66,7 @@
>  
>  /* VR_MII_DIG_CTRL1 */
>  #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
> +#define DW_VR_MII_DIG_CTRL1_PRE_EMP		BIT(6)
>  
>  /* VR_MII_AN_CTRL */
>  #define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
> @@ -666,6 +667,10 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
>  	 *	 PHY about the link state change after C28 AN is completed
>  	 *	 between PHY and Link Partner. There is also no need to
>  	 *	 trigger AN restart for MAC-side SGMII.
> +	 *
> +	 * For pre-emption, the setting is :-
> +	 * 1) VR_MII_DIG_CTRL1 Bit(6) [PRE_EMP] = 1b (Enable pre-emption packet
> +	 *    for 10/100Mbps)
>  	 */
>  	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
>  	if (ret < 0)
> @@ -686,7 +691,7 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
>  	if (ret < 0)
>  		return ret;
>  
> -	ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> +	ret |= (DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW | DW_VR_MII_DIG_CTRL1_PRE_EMP);

() are useless here.

Thanks

>  
>  	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
>  }
> -- 
> 2.17.1
> 
