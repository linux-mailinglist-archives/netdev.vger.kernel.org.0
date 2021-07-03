Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A33BA7F0
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 10:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhGCI7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 04:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhGCI7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 04:59:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC23C061762
        for <netdev@vger.kernel.org>; Sat,  3 Jul 2021 01:56:58 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzbSA-0006qM-PW; Sat, 03 Jul 2021 10:56:46 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lzbS8-0002kJ-Ut; Sat, 03 Jul 2021 10:56:44 +0200
Date:   Sat, 3 Jul 2021 10:56:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     '@lunn.ch, Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: dsa: qca: ar9331: add forwarding
 database support'
Message-ID: <20210703085644.dg5faj74ijg7orw6@pengutronix.de>
References: <20210702101751.13168-1-o.rempel@pengutronix.de>
 <20210702101751.13168-4-o.rempel@pengutronix.de>
 <YN8tWtqfRRO7kAlb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YN8tWtqfRRO7kAlb@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:55:21 up 212 days, 23:01, 44 users,  load average: 0.00, 0.01,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 05:14:34PM +0200, Andrew Lunn wrote:
> On Fri, Jul 02, 2021 at 12:17:48PM +0200, Oleksij Rempel wrote:
> > This switch provides simple address resolution table, without VLAN or
> > multicast specific information.
> > With this patch we are able now to read, modify unicast and mulicast
> 
> mul_t_icast.

done

> > addresses.
> > +static int ar9331_sw_port_fdb_dump(struct dsa_switch *ds, int port,
> > +				   dsa_fdb_dump_cb_t *cb, void *data)
> > +{
> > +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +	int cnt = AR9331_SW_NUM_ARL_RECORDS;
> > +	struct ar9331_sw_fdb _fdb = { 0 };
> 
> Why use _fdb? There does not appear to be an fdb?

old artifact, renamed.

> > +static int ar9331_sw_port_fdb_rmw(struct ar9331_sw_priv *priv,
> > +				  const unsigned char *mac,
> > +				  u8 port_mask_set,
> > +				  u8 port_mask_clr)
> > +{
> > +	struct regmap *regmap = priv->regmap;
> > +	u32 f0, f1, f2 = 0;
> > +	u8 port_mask, port_mask_new, status, func;
> > +	int ret;
> 
> Reverse Christmas tree.

done

> > +static int ar9331_sw_port_fdb_add(struct dsa_switch *ds, int port,
> > +				  const unsigned char *mac, u16 vid)
> > +{
> > +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +	u16 port_mask = BIT(port);
> > +
> > +	dev_info(priv->dev, "%s(%pM, %x)\n", __func__, mac, port);
> 
> dev_dbg()?

removed.

Thank you!
Can I have your Reviewed-by with this changes?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
