Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C096AFB87
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCHAuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHAuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:50:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3259E6F;
        Tue,  7 Mar 2023 16:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q/T5ljm8LN7eH6ch+WyNNJmPboB5wqEu8gteW0WXaZ8=; b=hrq9G/3aEx0wPH6foCxe+34nsf
        0CL6VymPt/TYQLT+ama4FVUlSwYYEblBtgvVDh5hT/BvuRdseiVYyfQkYMErGR5gRUZPI/w/qWulO
        z0KVzZduP48fNSviq0EOp1aiCBfrCoJjMSYZxGHgeYndYu7mjGMZVx7YaSCRPiLRvsZI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZi0B-006iqV-JE; Wed, 08 Mar 2023 01:49:55 +0100
Date:   Wed, 8 Mar 2023 01:49:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
Message-ID: <d1226e21-8150-4959-95b0-e9df2c460b81@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-2-ansuelsmth@gmail.com>
 <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
 <6407c6ea.050a0220.7c931.824f@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6407c6ea.050a0220.7c931.824f@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:57:10PM +0100, Christian Marangi wrote:
> On Wed, Mar 08, 2023 at 12:16:13AM +0100, Andrew Lunn wrote:
> > > +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > > +{
> > > +	struct fwnode_handle *ports, *port;
> > > +	int port_num;
> > > +	int ret;
> > > +
> > > +	ports = device_get_named_child_node(priv->dev, "ports");
> > > +	if (!ports) {
> > > +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> > > +		return 0;
> > > +	}
> > > +
> > > +	fwnode_for_each_child_node(ports, port) {
> > > +		struct fwnode_handle *phy_node, *reg_port_node = port;
> > > +
> > > +		phy_node = fwnode_find_reference(port, "phy-handle", 0);
> > > +		if (!IS_ERR(phy_node))
> > > +			reg_port_node = phy_node;
> > 
> > I don't understand this bit. Why are you looking at the phy-handle?
> > 
> > > +
> > > +		if (fwnode_property_read_u32(reg_port_node, "reg", &port_num))
> > > +			continue;
> > 
> > I would of expect port, not reg_port_node. I'm missing something
> > here....
> > 
> 
> It's really not to implement ugly things like "reg - 1"
> 
> On qca8k the port index goes from 0 to 6.
> 0 is cpu port 1
> 1 is port0 at mdio reg 0
> 2 is port1 at mdio reg 1
> ...
> 6 is cpu port 2
> 
> Each port have a phy-handle that refer to a phy node with the correct
> reg and that reflect the correct port index.
> 
> Tell me if this looks wrong, for qca8k we have qca8k_port_to_phy() and
> at times we introduced the mdio thing to describe the port - 1 directly
> in DT. If needed I can drop the additional fwnode and use this function
> but I would love to use what is defined in DT thatn a simple - 1.

This comes back to the off list discussion earlier today. What you
actually have here are MAC LEDs, not PHY LEDs. They are implemented in
the MAC, not the PHY. To the end user, it should not matter, they
blink when you would expect.

So your addressing should be based around the MAC port number, not the
PHY.

Also, at the moment, all we are adding are a bunch of LEDs. There is
no link to a netdev at this point. At least, i don't see one. Be once
we start using ledtrig-netdev we will need that link to a netdev. Take
a look in my git tree at the last four patch. They add an additional
call to get the device an LED is attached to.

     Andrew
