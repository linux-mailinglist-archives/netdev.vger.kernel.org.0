Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB713DEA13
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhHCJyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhHCJyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:54:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7102C06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:54:26 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAr7t-0001sj-I7; Tue, 03 Aug 2021 11:54:21 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mAr7r-0004Cn-QD; Tue, 03 Aug 2021 11:54:19 +0200
Date:   Tue, 3 Aug 2021 11:54:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] net: dsa: qca: ar9331: make proper initial
 port defaults
Message-ID: <20210803095419.y6hly7euht7gsktu@pengutronix.de>
References: <20210803085320.23605-1-o.rempel@pengutronix.de>
 <20210803090605.bud4ocr4siz3jl7r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210803090605.bud4ocr4siz3jl7r@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:25:45 up 243 days, 23:32, 25 users,  load average: 0.16, 0.13,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:06:05PM +0300, Vladimir Oltean wrote:
> On Tue, Aug 03, 2021 at 10:53:20AM +0200, Oleksij Rempel wrote:
> > Make sure that all external port are actually isolated from each other,
> > so no packets are leaked.
> > 
> > Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> > changes v2:
> > - do not enable address learning by default
> > 
> >  drivers/net/dsa/qca/ar9331.c | 98 +++++++++++++++++++++++++++++++++++-
> >  1 file changed, 97 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> > index 6686192e1883..de7c06b6c85f 100644
> > --- a/drivers/net/dsa/qca/ar9331.c
> > +++ b/drivers/net/dsa/qca/ar9331.c
> > @@ -101,6 +101,46 @@
> >  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> >  	 AR9331_SW_PORT_STATUS_SPEED_M)
> >  
> > +#define AR9331_SW_REG_PORT_CTRL(_port)			(0x104 + (_port) * 0x100)
> > +#define AR9331_SW_PORT_CTRL_ING_MIRROR_EN		BIT(17)
> > +#define AR9331_SW_PORT_CTRL_LOCK_DROP_EN		BIT(5)
> 
> not used

ack, will remove

> 
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE			GENMASK(2, 0)
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED		0
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE_BLOCKING		1
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE_LISTENING	2
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE_LEARNING		3
> > +#define AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD		4

....
> >  
> > -static int ar9331_sw_setup(struct dsa_switch *ds)
> > +static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
> >  {
> >  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> >  	struct regmap *regmap = priv->regmap;
> > +	u32 port_mask, port_ctrl, val;
> >  	int ret;
> >  
> > +	/* Generate default port settings */
> > +	port_ctrl = FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
> > +			       AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED);
> 
> PORT_STATE_DISABLED? why? Can you ping over any interface after applying
> this patch?

grr... good point. My fault, sorry.

> > +
> > +	if (dsa_is_cpu_port(ds, port)) {
> > +		/* CPU port should be allowed to communicate with all user
> > +		 * ports.
> > +		 */
> > +		port_mask = dsa_user_ports(ds);
> > +		/* Enable Atheros header on CPU port. This will allow us
> > +		 * communicate with each port separately
> > +		 */
> > +		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
> > +	} else if (dsa_is_user_port(ds, port)) {
> > +		/* User ports should communicate only with the CPU port.
> > +		 */
> > +		port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);
> 
> You can use "port_mask = BIT(dsa_upstream_port(ds, port));", looks nicer
> at least to me.

ok. 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
