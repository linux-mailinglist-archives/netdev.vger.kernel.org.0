Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CC3A293D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFJKWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFJKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:22:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED2FC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:20:19 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHnH-0002gI-Rw; Thu, 10 Jun 2021 12:20:11 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHnG-0002Ct-Jc; Thu, 10 Jun 2021 12:20:10 +0200
Date:   Thu, 10 Jun 2021 12:20:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3 2/9] net: dsa: microchip: ksz8795: add
 phylink support
Message-ID: <20210610102010.tncgt67qjn3x75iv@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-3-o.rempel@pengutronix.de>
 <20210526221304.5njeoa7plhn2i2gn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210526221304.5njeoa7plhn2i2gn@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:19:22 up 190 days, 25 min, 40 users,  load average: 0.03, 0.06,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 01:13:04AM +0300, Vladimir Oltean wrote:
> On Wed, May 26, 2021 at 06:30:30AM +0200, Oleksij Rempel wrote:
> > From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > 
> > This patch adds the phylink support to the ksz8795 driver to provide
> > configuration exceptions on quirky KSZ8863 and KSZ8873 ports.
> > 
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8795.c | 59 +++++++++++++++++++++++++++++
> >  1 file changed, 59 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> > index ba065003623f..cf81ae87544d 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/micrel_phy.h>
> >  #include <net/dsa.h>
> >  #include <net/switchdev.h>
> > +#include <linux/phylink.h>
> >  
> >  #include "ksz_common.h"
> >  #include "ksz8795_reg.h"
> > @@ -1420,11 +1421,69 @@ static int ksz8_setup(struct dsa_switch *ds)
> >  	return 0;
> >  }
> >  
> > +static void ksz8_validate(struct dsa_switch *ds, int port,
> > +			  unsigned long *supported,
> > +			  struct phylink_link_state *state)
> > +{
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +	struct ksz_device *dev = ds->priv;
> > +
> > +	if (port == dev->cpu_port) {
> > +		if (state->interface != PHY_INTERFACE_MODE_RMII &&
> > +		    state->interface != PHY_INTERFACE_MODE_MII &&
> > +		    state->interface != PHY_INTERFACE_MODE_NA)
> > +			goto unsupported;
> > +	} else if (port > dev->port_cnt) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> > +		return;
> 
> Is this possible or do we just like to invent things to check?
> Unless I'm missing something, ksz8_switch_init() does:
> 
> 	dev->ds->num_ports = dev->port_cnt;
> 
> and dsa_port_phylink_validate() does:
> 
> 	ds->ops->phylink_validate(ds, dp->index, supported, state);
> 
> where dp->index is set to @port by dsa_port_touch() in this loop:
> 
> 	for (port = 0; port < ds->num_ports; port++) {
> 		dp = dsa_port_touch(ds, port);
> 		if (!dp)
> 			return -ENOMEM;
> 	}
> 
> So, if 0 <= dp->index < ds->num_ports == dev->port_cnt, what is the point?

good point

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
