Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B6577150
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 22:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiGPUGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiGPUGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 16:06:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF2D1EAE3;
        Sat, 16 Jul 2022 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3tjU9WNGMpz4TkxXbjj59cMkF1yuGZho2LASpfrLqgQ=; b=OiUSEr5KOQSHXV/kQbwIZBjy5u
        mqz/iKuq49zwHh83IIeNWKuHJ2DmD6tasGdEn0EbCInPrD0/QCGnKlppmkJuHXJY0U7639eJrGCyZ
        B9PYkmxkPNJ6PJnMqWwXJcYE71tYZvyh9ZrN0xK/dsUKMpM2yjN6+4aybih9VQtyZ7Tc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCo37-00AZSi-7B; Sat, 16 Jul 2022 22:06:01 +0200
Date:   Sat, 16 Jul 2022 22:06:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
Message-ID: <YtMaKWZyC/lgAQ0i@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-9-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * phy_interface_speed() - get the speed of a phy interface
> + * @interface: phy interface mode defined by &typedef phy_interface_t
> + * @link_speed: the speed of the link
> + *
> + * Some phy interfaces modes adapt to the speed of the underlying link (such as
> + * by duplicating data or changing the clock rate). Others, however, are fixed
> + * at a particular rate. Determine the speed of a phy interface mode for a
> + * particular link speed.
> + *
> + * Return: The speed of @interface
> + */
> +static int phy_interface_speed(phy_interface_t interface, int link_speed)
> +{
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_100BASEX:
> +		return SPEED_100;
> +
> +	case PHY_INTERFACE_MODE_TBI:
> +	case PHY_INTERFACE_MODE_MOCA:
> +	case PHY_INTERFACE_MODE_RTBI:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_1000BASEKX:
> +	case PHY_INTERFACE_MODE_TRGMII:
> +		return SPEED_1000;
> +
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		return SPEED_2500;
> +
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		return SPEED_5000;
> +
> +	case PHY_INTERFACE_MODE_XGMII:
> +	case PHY_INTERFACE_MODE_RXAUI:
> +	case PHY_INTERFACE_MODE_XAUI:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_10GKR:
> +		return SPEED_10000;
> +
> +	case PHY_INTERFACE_MODE_25GBASER:
> +		return SPEED_25000;
> +
> +	case PHY_INTERFACE_MODE_XLGMII:
> +		return SPEED_40000;
> +
> +	case PHY_INTERFACE_MODE_USXGMII:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_REVRMII:
> +	case PHY_INTERFACE_MODE_RMII:
> +	case PHY_INTERFACE_MODE_SMII:
> +	case PHY_INTERFACE_MODE_REVMII:
> +	case PHY_INTERFACE_MODE_MII:
> +	case PHY_INTERFACE_MODE_INTERNAL:
> +		return link_speed;
> +
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_MAX:
> +		break;
> +	}
> +
> +	return SPEED_UNKNOWN;

This seem error prone when new PHY_INTERFACE_MODES are added. I would
prefer a WARN_ON_ONCE() in the default: so we get to know about such
problems.

I'm also wondering if we need a sanity check here. I've seen quite a
few boards a Fast Ethernet MAC, but a 1G PHY because they are
cheap. In such cases, the MAC is supposed to call phy_set_max_speed()
to indicate it can only do 100Mbs. PHY_INTERFACE_MODE_MII but a
link_speed of 1G is clearly wrong. Are there other cases where we
could have a link speed faster than what the interface mode allows?

Bike shedding a bit, but would it be better to use host_side_speed and
line_side_speed? When you say link_speed, which link are your
referring to? Since we are talking about the different sides of the
PHY doing different speeds, the naming does need to be clear.

	  Andrew
