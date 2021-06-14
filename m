Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23B23A5BE4
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 05:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFNDx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 23:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhFNDx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 23:53:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E783C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 20:51:56 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lsddd-0006mA-89; Mon, 14 Jun 2021 05:51:49 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lsddc-0006qM-6G; Mon, 14 Jun 2021 05:51:48 +0200
Date:   Mon, 14 Jun 2021 05:51:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 9/9] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20210614035148.w742cyk52m3w56zh@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-10-o.rempel@pengutronix.de>
 <YMT7uSNXBA8/2r8C@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YMT7uSNXBA8/2r8C@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:51:09 up 193 days, 17:57, 48 users,  load average: 0.09, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 08:23:53PM +0200, Andrew Lunn wrote:
> > +static int ksz886x_cable_test_get_status(struct phy_device *phydev,
> > +					 bool *finished)
> > +{
> > +	unsigned long pair_mask = 0x3;
> > +	int retries = 20;
> > +	int pair, ret;
> > +
> > +	*finished = false;
> > +
> > +	/* Try harder if link partner is active */
> > +	while (pair_mask && retries--) {
> > +		for_each_set_bit(pair, &pair_mask, 4) {
> > +			ret = ksz886x_cable_test_one_pair(phydev, pair);
> > +			if (ret == -EAGAIN)
> > +				continue;
> > +			if (ret < 0)
> > +				return ret;
> > +			clear_bit(pair, &pair_mask);
> > +		}
> > +		/* If link partner is in autonegotiation mode it will send 2ms
> > +		 * of FLPs with at least 6ms of silence.
> > +		 * Add 2ms sleep to have better chances to hit this silence.
> > +		 */
> > +		if (pair_mask)
> > +			msleep(2);
> > +	}
> > +
> > +	*finished = true;
> > +
> > +	return 0;
> 
> If ksz886x_cable_test_one_pair() returns -EAGAIN 20x and it gives up,
> you end up returning 0. Maybe it would be better to return ret?

Good point. Fixed.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
