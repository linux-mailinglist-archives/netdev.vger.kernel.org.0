Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47336B30B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhDZM0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbhDZM0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 08:26:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03283C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 05:25:50 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lb0J4-0007LM-Iu; Mon, 26 Apr 2021 14:25:42 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lb0J2-0003Z9-Jw; Mon, 26 Apr 2021 14:25:40 +0200
Date:   Mon, 26 Apr 2021 14:25:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 08/10] net: dsa: microchip: Add Microchip
 KSZ8863 SMI based driver support
Message-ID: <20210426122540.xzanhcel7gv4dfsh@pengutronix.de>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-9-o.rempel@pengutronix.de>
 <YIRAwY+5yLJf1+CH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YIRAwY+5yLJf1+CH@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:23:30 up 145 days,  2:29, 45 users,  load average: 0.26, 0.10,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 06:01:05PM +0200, Andrew Lunn wrote:
> > +static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> > +			     void *val_buf, size_t val_len)
> > +{
> > +	struct ksz_device *dev = ctx;
> > +	struct ksz8 *ksz8 = dev->priv;
> > +	struct mdio_device *mdev = ksz8->priv;
> > +	u8 reg = *(u8 *)reg_buf;
> > +	u8 *val = val_buf;
> > +	int ret = 0;
> > +	int i;
> 
> ...
> 
> 
> > +
> > +	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	for (i = 0; i < val_len; i++) {
> > +		int tmp = reg + i;
> > +
> > +		ret = __mdiobus_read(mdev->bus, ((tmp & 0xE0) >> 5) |
> > +				     SMI_KSZ88XX_READ_PHY, tmp);
> > +		if (ret < 0)
> > +			goto out;
> > +
> > +		val[i] = ret;
> > +	}
> > +	ret = 0;
> > +
> > + out:
> > +	mutex_unlock(&mdev->bus->mdio_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
> > +{
> > +	struct ksz_device *dev = ctx;
> > +	struct ksz8 *ksz8 = dev->priv;
> > +	struct mdio_device *mdev = ksz8->priv;
> > +	u8 *val = (u8 *)(data + 4);
> > +	u32 reg = *(u32 *)data;
> > +	int ret = 0;
> > +	int i;
> 
> ...
> 
> 
> > +static const struct of_device_id ksz8863_dt_ids[] = {
> > +	{ .compatible = "microchip,ksz8863" },
> > +	{ .compatible = "microchip,ksz8873" },
> > +	{ },
> > +};
> 
> Is there code somewhere which verifies that what has been found really
> does match what is in device tree? We don't want errors in the device
> tree to be ignored.
> 
>      Andrew

Hm, it makes sense. But it is not regression of this patches, is it OK
to mainline it separately?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
