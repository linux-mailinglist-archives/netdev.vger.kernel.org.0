Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66C0529A8E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiEQHJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiEQHJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:09:34 -0400
X-Greylist: delayed 913 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 00:09:14 PDT
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D306F48332;
        Tue, 17 May 2022 00:09:14 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8051A4000B;
        Tue, 17 May 2022 07:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652771353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uz66M6HKOhBBcFLOcI2X/Dc3dQ8CXRWUl8K+WprspY=;
        b=cxSTVJUfdqK5sCWJtLbD+UkKCzrUy+aXziA5PrVkA7TvObO+wasqxf2s7rtRjg84pkqa0g
        E3xICkblItbWMeOAeOhwDYp+Lnd/LylzPQbyTnQ0+V5snjqtjLswDInmtW5ZUWR2gVwr2v
        TtzfWKum36PG9gMOaKg/1skpGpQBTmBVQL09vx+q5l/tGF8NAh8XzmGLEc1Pueof//jrEo
        ZsTpt0ReJX7cvSf1zhLFMq7d/5+mmshE9DNuwgFUr5oPlKQGcdG7vTrS4K9osp0Mrn8NnA
        ZdmsLihzujnwLpOSnX0Ko2uq80GShHUMzwya0A3wiu7c55bLGoczSTF5huSwhg==
Date:   Tue, 17 May 2022 09:09:10 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <20220517090910.7e1344ca@pc-20.home>
In-Reply-To: <Yn/kWG7X1YCPk17F@shell.armlinux.org.uk>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-2-maxime.chevallier@bootlin.com>
        <Yn/kWG7X1YCPk17F@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

Thanks for the review.

On Sat, 14 May 2022 18:18:17 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Sat, May 14, 2022 at 05:06:52PM +0200, Maxime Chevallier wrote:
> > +static int ipqess_do_ioctl(struct net_device *netdev, struct ifreq
> > *ifr, int cmd) +{
> > +	struct ipqess *ess = netdev_priv(netdev);
> > +
> > +	switch (cmd) {
> > +	case SIOCGMIIPHY:
> > +	case SIOCGMIIREG:
> > +	case SIOCSMIIREG:
> > +		return phylink_mii_ioctl(ess->phylink, ifr, cmd);
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return -EOPNOTSUPP;
> > +}  
> 
> Is there a reason this isn't just:
> 
> 	return phylink_mii_ioctl(ess->phylink, ifr, cmd);

Not really, an oversight on my part, I'll address that in v3

> ?
> 
> > +static int ipqess_axi_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct net_device *netdev;
> > +	phy_interface_t phy_mode;
> > +	struct resource *res;
> > +	struct ipqess *ess;
> > +	int i, err = 0;
> > +
> > +	netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct
> > ipqess),
> > +					 IPQESS_NETDEV_QUEUES,
> > +					 IPQESS_NETDEV_QUEUES);
> > +	if (!netdev)
> > +		return -ENOMEM;
> > +
> > +	ess = netdev_priv(netdev);
> > +	ess->netdev = netdev;
> > +	ess->pdev = pdev;
> > +	spin_lock_init(&ess->stats_lock);
> > +	SET_NETDEV_DEV(netdev, &pdev->dev);
> > +	platform_set_drvdata(pdev, netdev);
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	ess->hw_addr = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(ess->hw_addr))
> > +		return PTR_ERR(ess->hw_addr);
> > +
> > +	err = of_get_phy_mode(np, &phy_mode);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "incorrect phy-mode\n");
> > +		return err;
> > +	}
> > +
> > +	ess->ess_clk = devm_clk_get(&pdev->dev, "ess");
> > +	if (!IS_ERR(ess->ess_clk))
> > +		clk_prepare_enable(ess->ess_clk);
> > +
> > +	ess->ess_rst = devm_reset_control_get(&pdev->dev, "ess");
> > +	if (IS_ERR(ess->ess_rst))
> > +		goto err_clk;
> > +
> > +	ipqess_reset(ess);
> > +
> > +	ess->phylink_config.dev = &netdev->dev;
> > +	ess->phylink_config.type = PHYLINK_NETDEV;
> > +
> > +	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> > +		  ess->phylink_config.supported_interfaces);  
> 
> No mac capabilities?

My bad too, I also missed that. I'll also address that in v3.

> > +
> > +	ess->phylink = phylink_create(&ess->phylink_config,
> > +				      of_fwnode_handle(np),
> > phy_mode,
> > +				      &ipqess_phylink_mac_ops);  
> 

Thanks,

Maxime
