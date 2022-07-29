Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79454584CA8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiG2HdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiG2HdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:01 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F597C1B4;
        Fri, 29 Jul 2022 00:32:59 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ED1271C000D;
        Fri, 29 Jul 2022 07:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659079978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr9dBtRHpEsZnY4WwAGh3TdMzUoTMBzq+LV/3YLwXZc=;
        b=X2aEFCq12Cd3VqkHThYBrZGJKoeYCB29lOCN6l1FKfrPKFfgmf8d2jGeBok/AgqU7LwszH
        1TmrFcfbqn4eYwSCoY08CR/FcrC+OrSQH/BF9s7jUGsJKuhZjrSYQU6PNPxb1IHyWW/W5E
        /DkybKlTUjBy+7aBrfRIVwJS681owU9kOlTNXCY9b22+jDBvFBW9cFZKcfXvk7i894pmnO
        pJm9kXfZjbF9jdWAu5cTO0M0VbvMhzBLVGzHsbgFqvwf8rQGUxXRQ6Y8kil5O946VIfTS+
        uuNmsJPIApRj1LuLoH4UfOdajD44yRUFGmhQjWR6oOyxCrxIImT9a5wNq7C2gw==
Date:   Fri, 29 Jul 2022 09:32:52 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/4] net: phy: Add helper to derive the number
 of ports from a phy mode
Message-ID: <20220729093252.50977d5c@pc-10.home>
In-Reply-To: <YuMAdACnRKsL8/xD@lunn.ch>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
        <20220728145252.439201-4-maxime.chevallier@bootlin.com>
        <YuMAdACnRKsL8/xD@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 23:32:36 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +int phy_interface_num_ports(phy_interface_t interface)
> > +{
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_NA:
> > +	case PHY_INTERFACE_MODE_INTERNAL:
> > +		return 0;  
> 
> I've not yet looked at how this is used. Returning 0 could have
> interesting effects i guess? INTERNAL clearly does have some sort of
> path between the MAC and the PHY, so i think 1 would be a better
> value. NA is less clear, it generally means Don't touch. But again,
> there still needs to be a path between the MAC and PHY, otherwise
> there would not be any to touch.
> 
> Why did you pick 0?
> 
> > +
> > +	case PHY_INTERFACE_MODE_MII:
> > +	case PHY_INTERFACE_MODE_GMII:
> > +	case PHY_INTERFACE_MODE_TBI:
> > +	case PHY_INTERFACE_MODE_REVMII:
> > +	case PHY_INTERFACE_MODE_RMII:
> > +	case PHY_INTERFACE_MODE_REVRMII:
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +	case PHY_INTERFACE_MODE_RTBI:
> > +	case PHY_INTERFACE_MODE_XGMII:
> > +	case PHY_INTERFACE_MODE_XLGMII:
> > +	case PHY_INTERFACE_MODE_MOCA:
> > +	case PHY_INTERFACE_MODE_TRGMII:
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_SMII:
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +	case PHY_INTERFACE_MODE_2500BASEX:
> > +	case PHY_INTERFACE_MODE_5GBASER:
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +	case PHY_INTERFACE_MODE_25GBASER:
> > +	case PHY_INTERFACE_MODE_10GKR:
> > +	case PHY_INTERFACE_MODE_100BASEX:
> > +	case PHY_INTERFACE_MODE_RXAUI:
> > +	case PHY_INTERFACE_MODE_XAUI:
> > +		return 1;
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +	case PHY_INTERFACE_MODE_QUSGMII:
> > +		return 4;
> > +
> > +	default:
> > +		return 0;
> > +	}
> > +}  
> 
> Have you tried without a default: ? I _think_ gcc will then warn about
> missing enum values, which will help future developers when they add
> further values to the enum.

Without the default clause, I get an error about the missing
PHY_INTERFACE_MODE_MAX case, which I don't think belongs here...

Too bad :/

> 	Andrew

