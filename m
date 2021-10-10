Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC5428240
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhJJPUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 11:20:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhJJPUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 11:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H1FlB6h8c3CqipFaPQqaP8QMAtjkuQBI+zm5aKB+zwU=; b=U2p1M6eCNWOhrLXdNiPMtKWI7Q
        Gh3LwOluONq6NWP10EbXZ8hnUqJEEuVlQleBVqNLSJwQGOSYcJzdd9Yb7rUjJYGj326XZxztqh/eW
        0uum/+DWMl+oLNMvmElSCfpGrZHgJ9E/VOGWXwcvtPX5PGcNcocXkoIXKoXAoWmNkfaE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZaae-00AF1d-8j; Sun, 10 Oct 2021 17:18:16 +0200
Date:   Sun, 10 Oct 2021 17:18:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay
 detection to phylink mac_config
Message-ID: <YWMEOLueatMCTS2Z@lunn.ch>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-7-ansuelsmth@gmail.com>
 <20211010124732.fageoraoweqqfoew@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010124732.fageoraoweqqfoew@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -{
> > -	struct device_node *port_dn;
> > -	phy_interface_t mode;
> > -	struct dsa_port *dp;
> > -	u32 val;
> > -
> > -	/* CPU port is already checked */
> > -	dp = dsa_to_port(priv->ds, 0);
> > -
> > -	port_dn = dp->dn;
> > -
> > -	/* Check if port 0 is set to the correct type */
> > -	of_get_phy_mode(port_dn, &mode);
> > -	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
> > -	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
> > -	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
> > -		return 0;
> > -	}
> > -
> > -	switch (mode) {
> > -	case PHY_INTERFACE_MODE_RGMII_ID:
> > -	case PHY_INTERFACE_MODE_RGMII_RXID:
> 
> Also, since you touch this area.
> There have been tons of discussions on this topic, but I believe that
> your interpretation of the RGMII delays is wrong.
> Basically a MAC should not apply delays based on the phy-mode string (so
> it should treat "rgmii" same as "rgmii-id"), but based on the value of
> "rx-internal-delay-ps" and "tx-internal-delay-ps".
> The phy-mode is for a PHY to use.

There is one exception to this, when the MAC is taking the place of a
PHY, i.e. CPU port. You need delays added somewhere, and the mv88e6xxx
driver will look at the phy-mode in this case. And i think in general,
a DSA driver needs this for the CPU port.

       Andrew
