Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB751FF09B
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbfKPQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:06:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731755AbfKPQGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 11:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dDvq4hjwRLkHy9iSXQNS5lcXEmes4uzOMftkB6Mwr+c=; b=5bwICsIVqPkawy7/Z7/C/+1bQL
        1fogwvVD9YwYi6AjWODtH1/2gU6cDbeT+6bVNn16/sr1eOznTuLSOceKEEeTlbiNZvfsyUJEUZM1x
        wh0cC5MH9srBxefJctqD93PpK0990qm+S1VWBX/OonC8W4PMtcr1UYc4/YI0CSNfOScg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iW0ap-0005qI-8Y; Sat, 16 Nov 2019 17:06:35 +0100
Date:   Sat, 16 Nov 2019 17:06:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: add SFP+ support
Message-ID: <20191116160635.GB5653@lunn.ch>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
 <E1iVhiC-0007bG-Cm@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iVhiC-0007bG-Cm@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
> +{
> +	struct phy_device *phydev = upstream;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
> +	phy_interface_t iface;
> +
> +	sfp_parse_support(phydev->sfp_bus, id, support);
> +	iface = sfp_select_interface(phydev->sfp_bus, id, support);
> +
> +	if (iface != PHY_INTERFACE_MODE_10GKR) {
> +		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
> +		return -EINVAL;
> +	}

Hi Russell

Is it possible to put an SFP module into an SFP+ cage?
sfp_select_interface() would then say 1000Base-X or 2500Base-X. The
SFP+ cage has a single SERDES pair, so electrically, would it be
possible to do 1000Base-X? Should mv3310_sfp_insert() be reconfiguring
the PHY so the SFP side swaps to 1000Base-X?

    Andrew
