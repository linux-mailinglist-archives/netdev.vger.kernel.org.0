Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF62D42D4
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgLINKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732053AbgLINKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:10:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17C6C061794
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 05:09:34 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kmzDf-00063F-7e; Wed, 09 Dec 2020 14:09:23 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kmzDd-0001av-0w; Wed, 09 Dec 2020 14:09:21 +0100
Date:   Wed, 9 Dec 2020 14:09:21 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: qca: ar9331: fix sleeping function
 called from invalid context bug
Message-ID: <20201209130920.hjjnfh2ioc33yd2y@pengutronix.de>
References: <20201204145751.13166-1-o.rempel@pengutronix.de>
 <8f44d5cb-fa99-b004-078e-078241f265a0@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f44d5cb-fa99-b004-078e-078241f265a0@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:08:43 up 7 days,  3:15, 25 users,  load average: 0.01, 0.05, 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 04:00:35PM +0100, Marc Kleine-Budde wrote:
> On 12/4/20 3:57 PM, Oleksij Rempel wrote:
> [...]
> 
> 
> > +static void ar9331_sw_irq_bus_sync_unlock(struct irq_data *d)
> >  {
> >  	struct ar9331_sw_priv *priv = irq_data_get_irq_chip_data(d);
> >  	struct regmap *regmap = priv->regmap;
> >  	int ret;
> >  
> >  	ret = regmap_update_bits(regmap, AR9331_SW_REG_GINT_MASK,
> > -				 AR9331_SW_GINT_PHY_INT,
> > -				 AR9331_SW_GINT_PHY_INT);
> > +				 AR9331_SW_GINT_PHY_INT, priv->irq_mask);
> >  	if (ret)
> > -		dev_err(priv->dev, "could not unmask IRQ\n");
> > +		dev_err(priv->dev, "could not mask IRQ\n");
> 
> Technically this could be a mask or unmask operation. What about changing the
> error message to: "faild to change IRQ mask"?

OK, it make sense. I'll fix it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
