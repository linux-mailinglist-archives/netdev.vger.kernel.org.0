Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D47149781
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 20:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgAYTkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 14:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAYTkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 14:40:39 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4169420708;
        Sat, 25 Jan 2020 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579981238;
        bh=M/rbLv2cwxH5tCcUMkLEGQCU3S99/Hdl1lMqjgHMNmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THxE6aS9TeHMLNgvy2vV0VFEKeAeA7loCWlz/mphUXflvQIH+/mlcTx+TZ7tR+dK6
         sgWkx904ylv0SnBPVKA6igfDhdkYlelhlVOfM0FUOSQLi+3kQsdU6ZX3qyBcTOGZtz
         ruZhYsR+0fZxM1UdnZpkDeWG3Yha9p14QC4Xb324=
Date:   Sat, 25 Jan 2020 11:40:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Message-ID: <20200125114037.203e63ca@cakuba>
In-Reply-To: <20200125051039.59165-12-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
        <20200125051039.59165-12-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 05:11:52 +0000, Saeed Mahameed wrote:
> From: Aya Levin <ayal@mellanox.com>
> 
> Add support for low latency Reed Solomon FEC as LLRS.
> 
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

This is kind of buried in the midst of the driver patches.
It'd preferably be a small series of its own. 
Let's at least try to CC PHY folk now.

Is this from some standard?

> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index a4d2d59fceca..e083e7a76ada 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -8,7 +8,7 @@
>  
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 74,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 75,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 116bcbf09c74..e0c4383ea952 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1326,6 +1326,7 @@ enum ethtool_fec_config_bits {
>  	ETHTOOL_FEC_OFF_BIT,
>  	ETHTOOL_FEC_RS_BIT,
>  	ETHTOOL_FEC_BASER_BIT,
> +	ETHTOOL_FEC_LLRS_BIT,
>  };
>  
>  #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
> @@ -1333,6 +1334,7 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
>  #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
>  #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
> +#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
>  
>  /* CMDs currently supported */
>  #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
> @@ -1517,7 +1519,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
>  	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
>  	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
> -
> +	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index e621b1694d2f..8e4e809340f0 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -167,6 +167,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
>  	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
>  	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
> +	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index 96f20be64553..f049b97072fe 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -237,6 +237,7 @@ static const struct link_mode_info link_mode_params[] = {
>  	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
>  	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
>  	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
>  };
>  
>  static const struct nla_policy

