Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EC755DCAB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiF0Gm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 02:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiF0Gm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 02:42:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC73881;
        Sun, 26 Jun 2022 23:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656312142; x=1687848142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/B9jPCXoGr+s2dOSilHfB1A0vqJQl+HCS0EByBkjXms=;
  b=VbhPiumJkyxNlGQ91SmFinRUX4nQXV3UJ40YzXQFZs9CgQjw2I/u+b79
   Skrp5qbSuT87vrh8VFqZHpyumhcOjy9aPlahyGX0zGxeI8fh7e6A2PMmr
   WycljlJJ2E7Rq0ooZNz0Vhb6Xu3FVPdLvQ3yHMj/XNLwFGRsoMGVzbdQZ
   GI1xAmZWmCOZEPOIuCw8VErdhy5dOl53b9ShXS3J1H2HmKyEic8CAWzx+
   8iHL8ZHNkPvdLqJ8EgIZBz2klAOQ7SJUd6p5/kpflFZqfYaCMa7ZbC8J0
   Q2lUqUxa/9NjSpzDjfuu1g0aXVaQcfsr/j0bZbpfp8Fk92Ff/323ModPw
   g==;
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="179614170"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 23:42:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 23:42:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sun, 26 Jun 2022 23:42:21 -0700
Date:   Mon, 27 Jun 2022 08:46:12 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 5/8] net: lan966x: Add lag support for lan966x.
Message-ID: <20220627064612.vzz2sd7kxpxnprxc@soft-dev3-1.localhost>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
 <20220626130451.1079933-6-horatiu.vultur@microchip.com>
 <20220626141139.kbwhpgmwzp7rpxgy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220626141139.kbwhpgmwzp7rpxgy@skbuf>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/26/2022 17:11, Vladimir Oltean wrote:
> 
> Hi Horatiu,

Hi Vladimir,

> 
> Just casually browsing through the patches. A comment below.

> 
> On Sun, Jun 26, 2022 at 03:04:48PM +0200, Horatiu Vultur wrote:
> > Add link aggregation hardware offload support for lan966x
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
> >  .../ethernet/microchip/lan966x/lan966x_lag.c  | 296 ++++++++++++++++++
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  28 ++
> >  .../microchip/lan966x/lan966x_switchdev.c     |  78 ++++-
> >  4 files changed, 388 insertions(+), 16 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> > index fd2e0ebb2427..0c22c86bdaa9 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> > +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> > @@ -8,4 +8,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
> >  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
> >                       lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> >                       lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
> > -                     lan966x_ptp.o lan966x_fdma.o
> > +                     lan966x_ptp.o lan966x_fdma.o lan966x_lag.o
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> > new file mode 100644
> > index 000000000000..c721a05d44d2
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> > @@ -0,0 +1,296 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include "lan966x_main.h"
> > +
> > +static void lan966x_lag_set_aggr_pgids(struct lan966x *lan966x)
> > +{
> > +     u32 visited = GENMASK(lan966x->num_phys_ports - 1, 0);
> > +     int p, lag, i;
> > +
> > +     /* Reset destination and aggregation PGIDS */
> > +     for (p = 0; p < lan966x->num_phys_ports; ++p)
> > +             lan_wr(ANA_PGID_PGID_SET(BIT(p)),
> > +                    lan966x, ANA_PGID(p));
> > +
> > +     for (p = PGID_AGGR; p < PGID_SRC; ++p)
> > +             lan_wr(ANA_PGID_PGID_SET(visited),
> > +                    lan966x, ANA_PGID(p));
> > +
> > +     /* The visited ports bitmask holds the list of ports offloading any
> > +      * bonding interface. Initially we mark all these ports as unvisited,
> > +      * then every time we visit a port in this bitmask, we know that it is
> > +      * the lowest numbered port, i.e. the one whose logical ID == physical
> > +      * port ID == LAG ID. So we mark as visited all further ports in the
> > +      * bitmask that are offloading the same bonding interface. This way,
> > +      * we set up the aggregation PGIDs only once per bonding interface.
> > +      */
> > +     for (p = 0; p < lan966x->num_phys_ports; ++p) {
> > +             struct lan966x_port *port = lan966x->ports[p];
> > +
> > +             if (!port || !port->bond)
> > +                     continue;
> > +
> > +             visited &= ~BIT(p);
> > +     }
> > +
> > +     /* Now, set PGIDs for each active LAG */
> > +     for (lag = 0; lag < lan966x->num_phys_ports; ++lag) {
> > +             struct lan966x_port *port = lan966x->ports[lag];
> > +             int num_active_ports = 0;
> > +             struct net_device *bond;
> > +             unsigned long bond_mask;
> > +             u8 aggr_idx[16];
> > +
> > +             if (!port || !port->bond || (visited & BIT(lag)))
> > +                     continue;
> > +
> > +             bond = port->bond;
> > +             bond_mask = lan966x_lag_get_mask(lan966x, bond, true);
> > +
> > +             for_each_set_bit(p, &bond_mask, lan966x->num_phys_ports) {
> > +                     lan_wr(ANA_PGID_PGID_SET(bond_mask),
> > +                            lan966x, ANA_PGID(p));
> > +                     aggr_idx[num_active_ports++] = p;
> > +             }
> 
> This incorrect logic seems to have been copied from ocelot from before
> commit a14e6b69f393 ("net: mscc: ocelot: fix incorrect balancing with
> down LAG ports").
> 
> The issue is that you calculate bond_mask with only_active_ports=true.
> This means the for_each_set_bit() will not iterate through the inactive
> LAG ports, and won't set the bond_mask as the PGID destination for those
> ports.
> 
> That isn't what is desired; as explained in that commit, inactive LAG
> ports should be removed via the aggregation PGIDs and not via the
> destination PGIDs. Otherwise, an FDB entry targeted towards the
> LAG (effectively towards the "primary" LAG port, whose logical port ID
> gives the LAG ID) will not egress even the "secondary" LAG port if the
> primary's link is down.

Thanks for looking at this.
That is correct, ocelot was the source of inspiration. The issue that
you described in the mentioned commit is fixed in the last patch of this
series.
I will have a look at your commit and will try to integrated it. Thanks.

> 
> > +
> > +             for (i = PGID_AGGR; i < PGID_SRC; ++i) {
> > +                     u32 ac;
> > +
> > +                     ac = lan_rd(lan966x, ANA_PGID(i));
> > +                     ac &= ~bond_mask;
> > +                     /* Don't do division by zero if there was no active
> > +                      * port. Just make all aggregation codes zero.
> > +                      */
> > +                     if (num_active_ports)
> > +                             ac |= BIT(aggr_idx[i % num_active_ports]);
> > +                     lan_wr(ANA_PGID_PGID_SET(ac),
> > +                            lan966x, ANA_PGID(i));
> > +             }
> > +
> > +             /* Mark all ports in the same LAG as visited to avoid applying
> > +              * the same config again.
> > +              */
> > +             for (p = lag; p < lan966x->num_phys_ports; p++) {
> > +                     struct lan966x_port *port = lan966x->ports[p];
> > +
> > +                     if (!port)
> > +                             continue;
> > +
> > +                     if (port->bond == bond)
> > +                             visited |= BIT(p);
> > +             }
> > +     }
> > +}

-- 
/Horatiu
