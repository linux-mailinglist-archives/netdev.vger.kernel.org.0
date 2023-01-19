Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F75673B5E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 15:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjASOLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 09:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjASOKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 09:10:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9654CE50;
        Thu, 19 Jan 2023 06:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nhR/k9DW9kXSzNpwAtuxVVbCeGJmwMg8MjsoC/QOJkE=; b=Q2OnfJvG4Xbl6i3pJkLjSvmhmC
        lzMoINnlWCG6iNiFXnAIJEo/G6fNuEQhBymp1b1pkY7viYRqclqGpEZxiQx9+iLW5GDjFB2hu6flv
        0RRBdmyGOidQ2kD4SRZXG6M/bRiWzNiQ90gyJrhv7mp33bBiwtzz8BX9oqCCnfcEeRVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIVb9-002ZtK-TV; Thu, 19 Jan 2023 15:08:59 +0100
Date:   Thu, 19 Jan 2023 15:08:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Message-ID: <Y8lO+2JojN8zOkkY@lunn.ch>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119131821.3832456-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ksz9477_get_eee_caps(struct phy_device *phydev,
> +				struct ethtool_eee *data)
> +{
> +	int val;
> +
> +	/* At least on KSZ8563 (which has same PHY_ID as KSZ9477), the
> +	 * MDIO_PCS_EEE_ABLE register is a mirror of MDIO_AN_EEE_ADV register.
> +	 * So, we need to provide this information by driver.
> +	 */
> +	data->supported = SUPPORTED_100baseT_Full;
> +
> +	/* KSZ8563 is able to advertise not supported MDIO_EEE_1000T.
> +	 * We need to test if the PHY is 1Gbit capable.
> +	 */
> +	val = phy_read(phydev, MII_BMSR);
> +	if (val < 0)
> +		return val;
> +
> +	if (val & BMSR_ERCAP)
> +		data->supported |= SUPPORTED_1000baseT_Full;

This works, but you could also look at phydev->supported and see if
one of the 1G modes is listed. That should be faster, since there is
no MDIO transaction involved. Not that this is on any sort of hot
path.

	Andrew
