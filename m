Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE835C914
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhDLOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:44:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237806AbhDLOod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:44:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVxnP-00GHIZ-Vo; Mon, 12 Apr 2021 16:44:11 +0200
Date:   Mon, 12 Apr 2021 16:44:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YHRcu+dNKE7xC8EG@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412133447.fyqkavrs5r5wbino@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 03:34:47PM +0200, Pali Rohár wrote:
> On Monday 12 April 2021 15:15:07 Andrew Lunn wrote:
> > > +static u16 mv88e6xxx_physid_for_family(enum mv88e6xxx_family family);
> > > +
> > 
> > No forward declaration please. Move the code around. It is often best
> > to do that in a patch which just moves code, no other changes. It
> > makes it easier to review.
> 
> Avoiding forward declaration would mean to move about half of source
> code. mv88e6xxx_physid_for_family depends on mv88e6xxx_table which
> depends on all _ops structures which depends on all lot of other
> functions.

So this is basically what you are trying to do:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..ef4dbcb052b7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3026,6 +3026,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
        return err;
 }
 
+static const enum mv88e6xxx_model family_model_table[] = {
+       [MV88E6XXX_FAMILY_6095] = MV88E6XXX_PORT_SWITCH_ID_PROD_6095,
+       [MV88E6XXX_FAMILY_6097] = MV88E6XXX_PORT_SWITCH_ID_PROD_6097,
+       [MV88E6XXX_FAMILY_6185] = MV88E6XXX_PORT_SWITCH_ID_PROD_6185,
+       [MV88E6XXX_FAMILY_6250] = MV88E6XXX_PORT_SWITCH_ID_PROD_6250,
+       [MV88E6XXX_FAMILY_6320] = MV88E6XXX_PORT_SWITCH_ID_PROD_6320,
+       [MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
+       [MV88E6XXX_FAMILY_6351] = MV88E6XXX_PORT_SWITCH_ID_PROD_6351,
+       [MV88E6XXX_FAMILY_6352] = MV88E6XXX_PORT_SWITCH_ID_PROD_6352,
+       [MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
+};
+
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
        struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
@@ -3056,7 +3068,7 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
                         * a PHY,
                         */
                        if (!(val & 0x3f0))
-                               val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
+                               val |= family_model_table[chip->info->family] >> 4;
        }

and it compiles. No forward declarations needed. It is missing all the
error checking etc, but i don't see why that should change the
dependencies.

	Andrew
