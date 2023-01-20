Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98958674CC8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjATFu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjATFuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:50:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11714193EA
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:50:45 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIkIU-0007Ki-6a; Fri, 20 Jan 2023 06:50:42 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIkIS-0000mw-1a; Fri, 20 Jan 2023 06:50:40 +0100
Date:   Fri, 20 Jan 2023 06:50:40 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Message-ID: <20230120055040.GH6162@pengutronix.de>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
 <Y8lO+2JojN8zOkkY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8lO+2JojN8zOkkY@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 03:08:59PM +0100, Andrew Lunn wrote:
> > +static int ksz9477_get_eee_caps(struct phy_device *phydev,
> > +				struct ethtool_eee *data)
> > +{
> > +	int val;
> > +
> > +	/* At least on KSZ8563 (which has same PHY_ID as KSZ9477), the
> > +	 * MDIO_PCS_EEE_ABLE register is a mirror of MDIO_AN_EEE_ADV register.
> > +	 * So, we need to provide this information by driver.
> > +	 */
> > +	data->supported = SUPPORTED_100baseT_Full;
> > +
> > +	/* KSZ8563 is able to advertise not supported MDIO_EEE_1000T.
> > +	 * We need to test if the PHY is 1Gbit capable.
> > +	 */
> > +	val = phy_read(phydev, MII_BMSR);
> > +	if (val < 0)
> > +		return val;
> > +
> > +	if (val & BMSR_ERCAP)
> > +		data->supported |= SUPPORTED_1000baseT_Full;
> 
> This works, but you could also look at phydev->supported and see if
> one of the 1G modes is listed. That should be faster, since there is
> no MDIO transaction involved. Not that this is on any sort of hot
> path.

ack. Sounds good.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
