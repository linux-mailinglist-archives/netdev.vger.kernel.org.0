Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29647D938D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393924AbfJPOTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:19:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbfJPOTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 10:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2gfBz9doyaXqlfWGuAYNroU7aTSAFE6JHtbYJe4Wvoo=; b=OflYA2g45TEOHaOj3PxZPb2irR
        iuDLs2iQqK9Toz8vWWSaccnAYSd83vMzaXLBjRPHsFegisJWmx7AzxLWb7lS/WrdEywG1gx5ONnN1
        ATUcuVRmDrEsyfswvfLPTKjnryIY5BgcIuYKYr41t+KwOvXwhw3IKlypFrZjW1RiQa8U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKk9W-0007pf-RD; Wed, 16 Oct 2019 16:19:50 +0200
Date:   Wed, 16 Oct 2019 16:19:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191016141950.GC17013@lunn.ch>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015224953.24199-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If all is well, we stop iterating over all possible RGMII combinations
> and offer the one that is deemed suitable which is what an user should
> be trying by configuring the platform appropriately.

Hi Florian

I like the idea, however...

I think it would be good to always iterate over all possible delay
modes, not until it works. We want to try to catch PHY drivers which
don't implement all four possible settings. If two or more delay modes
work, it suggests something is wrong in the implementation, not all
modes are supported correctly.

> +int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	unsigned char operstate = ndev->operstate;
> +	phy_interface_t rgmii_modes[4] = {
> +		PHY_INTERFACE_MODE_RGMII,
> +		PHY_INTERFACE_MODE_RGMII_ID,
> +		PHY_INTERFACE_MODE_RGMII_RXID,
> +		PHY_INTERFACE_MODE_RGMII_TXID
> +	};
> +	struct phy_rgmii_debug_priv *priv;
> +	unsigned int i, count;
> +	int ret;
> +
> +	ret = phy_rgmii_can_debug(phydev);
> +	if (ret <= 0)
> +		return ret;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (phy_rgmii_probes_type.af_packet_priv)
> +		return -EBUSY;
> +
> +	phy_rgmii_probes_type.af_packet_priv = priv;
> +	priv->phydev = phydev;
> +	INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
> +	init_completion(&priv->compl);
> +
> +	/* We are now testing this network device */
> +	ndev->operstate = IF_OPER_TESTING;

I should dig out and re-submit my patch set of doing this.

> +
> +	dev_add_pack(&phy_rgmii_probes_type);
> +
> +	/* Determine where to start */
> +	for (i = 0; i < ARRAY_SIZE(rgmii_modes); i++) {
> +		if (phydev->interface == rgmii_modes[i])
> +			break;
> +	}

I don't think that is a good idea. What if setting the RGMII delay is
a NOP, and relying on strapping? We will never know we have the wrong
mode in DT, because it works. I would much prefer we used all four
modes, all four modes pass, and then we know the driver is broken.

       Andrew
