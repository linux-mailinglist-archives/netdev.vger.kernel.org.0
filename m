Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16861AFBCA
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgDSPtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:49:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgDSPtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9MvkBXmiEdANg+HoZVypf5aaCZQcXxBtGb3cmIo49e4=; b=oOU/p5eBY6McgT+ZdYrf2lGtEp
        8xEBF8J9m8asiWfs8rSVsrIX3a97REZg/9Oa4w0hk4fT8jI/O4BtNjN8PhVIAHSfGp87zgx4ZbOQC
        +wKpRD8ugKNiZ+Xq2WVMXxvtr+C/MSPbLeWEUIH9NK+Va9/Q6+/c8e5BqPg5WcmpYeXM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQCCV-003eaj-5k; Sun, 19 Apr 2020 17:49:43 +0200
Date:   Sun, 19 Apr 2020 17:49:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 2/3] net: phy: add Broadcom BCM54140 support
Message-ID: <20200419154943.GJ836632@lunn.ch>
References: <20200419101249.28991-1-michael@walle.cc>
 <20200419101249.28991-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419101249.28991-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 12:12:48PM +0200, Michael Walle wrote:

Hi Michael

> +static int bcm54140_b0_workaround(struct phy_device *phydev)
> +{
> +	int spare3;
> +	int ret;

Could you add a comment about what this is working around?

> +static int bcm54140_phy_probe(struct phy_device *phydev)
> +{
> +	struct bcm54140_phy_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	phydev->priv = priv;
> +
> +	ret = bcm54140_get_base_addr_and_port(phydev);
> +	if (ret)
> +		return ret;
> +
> +	dev_info(&phydev->mdio.dev,
> +		 "probed (port %d, base PHY address %d)\n",
> +		 priv->port, priv->base_addr);

phydev_dbg() ? Do we need to see this message four times?

> +
> +	return 0;
> +}
> +
> +static int bcm54140_config_init(struct phy_device *phydev)
> +{
> +	u16 reg = 0xffff;
> +	int ret;
> +
> +	/* Apply hardware errata */
> +	ret = bcm54140_b0_workaround(phydev);
> +	if (ret)
> +		return ret;
> +
> +	/* Unmask events we are interested in. */
> +	reg &= ~(BCM54140_RDB_INT_DUPLEX |
> +		 BCM54140_RDB_INT_SPEED |
> +		 BCM54140_RDB_INT_LINK);
> +	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_IMR, reg);
> +	if (ret)
> +		return ret;
> +
> +	/* LED1=LINKSPD[1], LED2=LINKSPD[2], LED3=ACTIVITY */
> +	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE1,
> +				 0, BCM54140_RDB_SPARE1_LSLM);
> +	if (ret)
> +		return ret;

What are the reset default for LEDs? Can the LEDs be configured via
strapping pins? There is currently no good solution for this. Whatever
you pick will be wrong for somebody else. At minimum, strapping pins,
if they exist, should not be overridden.

