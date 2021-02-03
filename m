Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAA930D0BC
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhBCBYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBCBYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:24:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E7864F4C;
        Wed,  3 Feb 2021 01:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612315413;
        bh=K9lx2f4vLnykhV/tfgE3cQZFAQd+Q2+xC0EWd/XNwhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RTzmnrlKEvWI8NnxsbofUMFSMxaoSuuZhng6C9KiA5Y5WKZ76CqdElQj4xB0fJb85
         +REXc5aMQ+OGqTNe/wk26mDe6Em0TRC+flFy6roqEZBs8LxrFh+lFX+FZDiHKYa+oL
         XgiTOBDEuHPy97IiRx04VhFICJ8KtRN8Q4TgrI4FLLETzKkrTR3kSJLv1nJAc6ssVc
         AwoH/HLpOddxOC1J2Mb2SdxjM+j3EbnNdq5BYWO/2YvA1+1gXT8mikNo+gDVxZ6Tzw
         MOYyBSBQLeNDWbikP5jzWm3KMYdiDwH9GRLe09o0A6dsThrm0epmQZKDGBaF47MJU2
         PHHEO+BxHg3Dg==
Date:   Tue, 2 Feb 2021 17:23:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Message-ID: <20210202172001.7609b76f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612098665-187767-7-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
        <1612098665-187767-7-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 18:41:04 +0530 Hariprasad Kelam wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> Register get_link_ksettings callback to get link status information
> from the driver. As virtual function (vf) shares same physical link
> same API is used for both the drivers and for loop back drivers
> simply returns the fixed values as its does not have physical link.
> 
> ethtool eth3
> Settings for eth3:
>         Supported ports: [ ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Half 1000baseT/Full
>                                 10000baseKR/Full
>                                 1000baseX/Full
>         Supports auto-negotiation: No
>         Supported FEC modes: BaseR RS
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: None
> 
> ethtool lbk0
> Settings for lbk0:
> 	Speed: 100000Mb/s
>         Duplex: Full
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 151 +++++++++++++++++++++
>  1 file changed, 151 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index e5b1a57..d637815 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -14,6 +14,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/log2.h>
>  #include <linux/net_tstamp.h>
> +#include <linux/linkmode.h>
>  
>  #include "otx2_common.h"
>  #include "otx2_ptp.h"
> @@ -32,6 +33,24 @@ struct otx2_stat {
>  	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
>  }
>  
> +/* Physical link config */
> +#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF //110001110001100110010111111
> +#define OTX2_RESERVED_ETHTOOL_LINK_MODE	0

Just use 0 directly in the code.

> +static const int otx2_sgmii_features_array[6] = {
> +	ETHTOOL_LINK_MODE_10baseT_Half_BIT,
> +	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> +	ETHTOOL_LINK_MODE_100baseT_Half_BIT,
> +	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +	ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
> +	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> +};

Why is this one up at the top of the file but other arrays are not?
It seems to be used only in once function.

> +enum link_mode {
> +	OTX2_MODE_SUPPORTED,
> +	OTX2_MODE_ADVERTISED
> +};
> +
>  static const struct otx2_stat otx2_dev_stats[] = {
>  	OTX2_DEV_STAT(rx_ucast_frames),
>  	OTX2_DEV_STAT(rx_bcast_frames),
> @@ -1034,6 +1053,123 @@ static int otx2_set_fecparam(struct net_device *netdev,
>  	return err;
>  }
>  
> +static void otx2_get_fec_info(u64 index, int req_mode,
> +			      struct ethtool_link_ksettings *link_ksettings)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_fec_modes) = { 0, };
> +
> +	switch (index) {
> +	case OTX2_FEC_NONE:
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, otx2_fec_modes);
> +		break;
> +	case OTX2_FEC_BASER:
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, otx2_fec_modes);
> +		break;
> +	case OTX2_FEC_RS:
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, otx2_fec_modes);
> +		break;
> +	case OTX2_FEC_BASER | OTX2_FEC_RS:
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, otx2_fec_modes);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, otx2_fec_modes);
> +		break;
> +	}
> +
> +	/* Add fec modes to existing modes */
> +	if (req_mode == OTX2_MODE_ADVERTISED)
> +		linkmode_or(link_ksettings->link_modes.advertising,
> +			    link_ksettings->link_modes.advertising,
> +			    otx2_fec_modes);
> +	else
> +		linkmode_or(link_ksettings->link_modes.supported,
> +			    link_ksettings->link_modes.supported,
> +			    otx2_fec_modes);
> +}
> +
> +static void otx2_get_link_mode_info(u64 link_mode_bmap,
> +				    bool req_mode,
> +				    struct ethtool_link_ksettings
> +				    *link_ksettings)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_link_modes) = { 0, };
> +	u8 bit;
> +

No empty lines in the middle of variable declarations.

> +	/* CGX link modes to Ethtool link mode mapping */
> +	const int cgx_link_mode[27] = {
> +		0, /* SGMII  Mode */
> +		ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> +		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> +		ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> +		ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
> +		ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> +		ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
> +		ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> +		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
> +		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
> +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> +		ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
> +		ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
> +	};
> +
> +	link_mode_bmap = link_mode_bmap & OTX2_ETHTOOL_SUPPORTED_MODES;
> +
> +	for_each_set_bit(bit, (unsigned long *)&link_mode_bmap, 27) {
> +		/* SGMII mode is set */
> +		if (bit  ==  0)

Double spaces x2

> +			linkmode_set_bit_array(otx2_sgmii_features_array,
> +					       ARRAY_SIZE(otx2_sgmii_features_array),
> +					       otx2_link_modes);
> +		else
> +			linkmode_set_bit(cgx_link_mode[bit], otx2_link_modes);
> +	}
> +
> +	if (req_mode == OTX2_MODE_ADVERTISED)
> +		linkmode_copy(link_ksettings->link_modes.advertising, otx2_link_modes);
> +	else
> +		linkmode_copy(link_ksettings->link_modes.supported, otx2_link_modes);
> +}

> +	otx2_get_link_mode_info(rsp->fwdata.advertised_link_modes, OTX2_MODE_ADVERTISED, cmd);
> +	otx2_get_fec_info(rsp->fwdata.advertised_fec, OTX2_MODE_ADVERTISED, cmd);
> +
> +	otx2_get_link_mode_info(rsp->fwdata.supported_link_modes, OTX2_MODE_SUPPORTED, cmd);
> +	otx2_get_fec_info(rsp->fwdata.supported_fec, OTX2_MODE_SUPPORTED, cmd);

Wrap those lines please.

> +	return 0;
> +}

> +static int otx2vf_get_link_ksettings(struct net_device *netdev,
> +				     struct ethtool_link_ksettings *cmd)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +
> +	if (is_otx2_lbkvf(pfvf->pdev)) {
> +		cmd->base.duplex = DUPLEX_FULL;
> +		cmd->base.speed = SPEED_100000;
> +	} else {
> +		return	otx2_get_link_ksettings(netdev, cmd);

Double space
