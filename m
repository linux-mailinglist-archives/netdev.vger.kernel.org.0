Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515D93B34B2
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhFXR0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:26:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhFXR0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 13:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NvvH96cmBXX2ORbFg1zoZQfm53jYn0pocb07kbwjspY=; b=x7kDFmdDvs/LcJbvQ8hU3IoRLq
        QmSxiR9iBWL2MlrARpdXxmf1Sj3mDhneiRo6FkjHXRS+nvkmieoI0bF54fTTBj6O5j2LZpfDeiyWo
        u0h3IOilrfvJXdIySuWE4S9PMfDfeTGGUr5xKzMbOAl57gjCUlze8onHhnl3y/7y5hn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwT4l-00B0Vd-OJ; Thu, 24 Jun 2021 19:23:39 +0200
Date:   Thu, 24 Jun 2021 19:23:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH 1/4] net: phy: adin1100: Add initial support for ADIN1100
 industrial PHY
Message-ID: <YNS/mwLfM0M1ZOoQ@lunn.ch>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
 <20210624145353.6910-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624145353.6910-2-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin_config_init(struct phy_device *phydev)
> +{
> +	struct adin_priv *priv = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, ADIN_B10L_PMA_STAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* This depends on the voltage level from the power source */
> +	priv->tx_level_24v = !!(ret & ADIN_PMA_STAT_B10L_TX_LVL_HI_ABLE);
> +
> +	phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
> +		   priv->tx_level_24v ? "yes" : "no");
> +
> +	if (priv->tx_level_24v &&
> +	    device_property_present(dev, "adi,disable-2-4-v-tx-level")) {
> +		phydev_info(phydev,
> +			    "PHY supports 2.4V TX level, but disabled via config\n");
> +		priv->tx_level_24v = 0;

Please document this in the device tree binding. I also suspect Rob
will prefer something like adi,disable-2400mv-tx-level

       Andrew
