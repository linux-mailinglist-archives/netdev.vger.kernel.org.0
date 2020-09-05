Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1451725EBCA
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 01:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgIEXrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 19:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEXrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 19:47:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D8020760;
        Sat,  5 Sep 2020 23:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599349624;
        bh=Jc4C4306EMKNApeBOPwe0aG1NL20wAkllgNlUjKDkF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1v6d2SUgIcy4tmkWlM8Km+S/gablUSqu8w/cx9InbPwTAQNPb4FWvt/4bJ0YpncB
         OFJFeKFWZtGltJ/Gjp9Uyhiq945U6JhIdfx13gYx/YtysNVHFN+Gw3tsYrQ26edzi8
         aUbaI5cAw5O3wuuFcZm9sHdaXZgHjDVRJ3tWrpVc=
Date:   Sat, 5 Sep 2020 16:47:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <frank-w@public-files.de>,
        <opensource@vdorst.com>, <dqfext@gmail.com>
Subject: Re: [PATCH net-next v3 2/6] net: dsa: mt7530: Extend device data
 ready for adding a new hardware
Message-ID: <20200905164702.72edf26c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3cf9909d7b06346b8aa339c346e19585cccf74c8.1599228079.git.landen.chao@mediatek.com>
References: <cover.1599228079.git.landen.chao@mediatek.com>
        <3cf9909d7b06346b8aa339c346e19585cccf74c8.1599228079.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 22:21:57 +0800 Landen Chao wrote:
> +static bool
> +mt7530_phy_mode_supported(struct dsa_switch *ds, int port,
> +			  const struct phylink_link_state *state)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> -	u32 mcr_cur, mcr_new;
>  
>  	switch (port) {
>  	case 0: /* Internal phy */
> @@ -1363,33 +1364,114 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
>  	case 3:
>  	case 4:
>  		if (state->interface != PHY_INTERFACE_MODE_GMII)
> -			return;
> +			goto unsupported;

return false;

Jumping to a label which does nothing but returns makes the code less
readable.

>  		break;
>  	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> -		if (priv->p5_interface == state->interface)
> -			break;
>  		if (!phy_interface_mode_is_rgmii(state->interface) &&
>  		    state->interface != PHY_INTERFACE_MODE_MII &&
>  		    state->interface != PHY_INTERFACE_MODE_GMII)
> -			return;
> +			goto unsupported;
> +		break;
> +	case 6: /* 1st cpu port */
> +		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> +		    state->interface != PHY_INTERFACE_MODE_TRGMII)
> +			goto unsupported;
> +		break;
> +	default:
> +		dev_err(priv->dev, "%s: unsupported port: %i\n", __func__,
> +			port);
> +		goto unsupported;
> +	}
> +
> +	return true;
> +
> +unsupported:
> +	return false;
> +}

> +static void
> +mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> +			  const struct phylink_link_state *state)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	u32 mcr_cur, mcr_new;
> +
> +	if (!mt753x_phy_mode_supported(ds, port, state))
> +		goto unsupported;
> +
> +	switch (port) {
> +	case 0: /* Internal phy */
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:

case 0 ... 4:

> +		if (state->interface != PHY_INTERFACE_MODE_GMII)
> +			goto unsupported;
> +		break;
> +	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +		if (priv->p5_interface == state->interface)
> +			break;

> +static void
> +mt753x_phylink_validate(struct dsa_switch *ds, int port,
> +			unsigned long *supported,
> +			struct phylink_link_state *state)
> +{
> +	struct mt7530_priv *priv = ds->priv;
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };

Please keep the variables longest to shortest (reverse xmas tree).
