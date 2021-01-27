Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D21305D9E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhA0Nwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:52:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhA0NwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 08:52:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4lEL-002sH3-JO; Wed, 27 Jan 2021 14:51:33 +0100
Date:   Wed, 27 Jan 2021 14:51:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Message-ID: <YBFv5ZqTDMyhEIgP@lunn.ch>
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
 <1611733552-150419-7-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611733552-150419-7-git-send-email-hkelam@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void otx2_get_link_mode_info(u64 index, int mode,
> +				    struct ethtool_link_ksettings
> +				    *link_ksettings)
> +{
> +	u64 ethtool_link_mode = 0;
> +	int bit_position = 0;
> +	u64 link_modes = 0;
> +
> +	/* CGX link modes to Ethtool link mode mapping */
> +	const int cgx_link_mode[29] = {0, /* SGMII  Mode */
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
> +	link_modes = index & OTX2_ETHTOOL_SUPPORTED_MODES;
> +
> +	for (bit_position = 0; link_modes; bit_position++, link_modes >>= 1) {
> +		if (!(link_modes & 1))
> +			continue;
> +
> +		if (bit_position ==  0)
> +			ethtool_link_mode = 0x3F;
> +
> +		if (cgx_link_mode[bit_position])
> +			ethtool_link_mode |= 1ULL << cgx_link_mode[bit_position];
> +
> +		if (mode)
> +			*link_ksettings->link_modes.advertising |=
> +							ethtool_link_mode;
> +		else
> +			*link_ksettings->link_modes.supported |=
> +							ethtool_link_mode;

You should not be derefererncing these bitmask like this. Use the
helpers, ethtool_link_ksettings_add_link_mode(). You cannot assume
these a ULL, they are not.

Please review all the patches. There are too many levels of
obfustication for me to easily follow the code, bit it looks like you
have other bitwise operations which might be operating on kernel
bitmaps, and you are not using the helpers.


> +	}
> +}
> +
> +static int otx2_get_link_ksettings(struct net_device *netdev,
> +				   struct ethtool_link_ksettings *cmd)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct cgx_fw_data *rsp = NULL;
> +	u32 supported = 0;
> +
> +	cmd->base.duplex  = pfvf->linfo.full_duplex;
> +	cmd->base.speed   = pfvf->linfo.speed;
> +	cmd->base.autoneg = pfvf->linfo.an;
> +
> +	rsp = otx2_get_fwdata(pfvf);
> +	if (IS_ERR(rsp))
> +		return PTR_ERR(rsp);
> +
> +	if (rsp->fwdata.supported_an)
> +		supported |= SUPPORTED_Autoneg;
> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
> +						supported);

Why use the legacy stuff when you can directly set the bit using the
helpers. Don't the word legacy actually suggest you should not be
using it in new code?

	Andrew
