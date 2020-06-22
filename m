Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0100203ACC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgFVP0M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 11:26:12 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:48863 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgFVP0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 11:26:11 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 7C089240008;
        Mon, 22 Jun 2020 15:26:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <f7b8b3fe41ba9e395eb0bb6bee9a020c@0leil.net>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-6-antoine.tenart@bootlin.com> <f7b8b3fe41ba9e395eb0bb6bee9a020c@0leil.net>
Subject: Re: [PATCH net-next v3 5/8] net: phy: mscc: 1588 block initialization
To:     Quentin Schulz <foss@0leil.net>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Message-ID: <159283956449.1456598.3334254941386336677@kwain>
Date:   Mon, 22 Jun 2020 17:26:04 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

Quoting Quentin Schulz (2020-06-21 18:57:14)
> 
> Feels weird to review my own patches a year later having written them,
> almost nostalgic :)

:)

> On 2020-06-19 14:22, Antoine Tenart wrote:
> [...]
> > @@ -373,6 +374,21 @@ struct vsc8531_private {
> >       unsigned long ingr_flows;
> >       unsigned long egr_flows;
> >  #endif
> > +
> > +     bool input_clk_init;
> > +     struct vsc85xx_ptp *ptp;
> > +
> > +     /* For multiple port PHYs; the MDIO address of the base PHY in the
> > +      * pair of two PHYs that share a 1588 engine. PHY0 and PHY2 are 
> > coupled.
> > +      * PHY1 and PHY3 as well. PHY0 and PHY1 are base PHYs for their
> > +      * respective pair.
> > +      */
> > +     unsigned int ts_base_addr;
> > +     u8 ts_base_phy;
> > +
> 
> I hate myself now for this bad naming. After reading the code, 
> ts_base_addr is the address
> of the base PHY (of a pair) on the MDIO bus and ts_base_phy is the 
> "internal" (package)
> address of the base PHy (of a pair). This is not very explicit.
> 
> Would ts_base_phy renamed into a ts_base_pkg_addr work better?
> 
> > +     /* ts_lock: used for per-PHY timestamping operations.
> > +      */
> 
> I don't remember exactly the comment best practices in net anymore, but 
> one line
> comment instead?

If you look at next patches, you'll see the comment is then multi-lines,
as other members are added to the structure. I'll fix it anyway.

> [...]
> 
> >  #endif /* _MSCC_PHY_H_ */
> > diff --git a/drivers/net/phy/mscc/mscc_main.c 
> > b/drivers/net/phy/mscc/mscc_main.c
> > index 052a0def6e83..87ddae514627 100644
> > --- a/drivers/net/phy/mscc/mscc_main.c
> > +++ b/drivers/net/phy/mscc/mscc_main.c
> > @@ -1299,11 +1299,29 @@ static void vsc8584_get_base_addr(struct
> > phy_device *phydev)
> >       __phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
> >       mutex_unlock(&phydev->mdio.bus->mdio_lock);
> > 
> > -     if (val & PHY_ADDR_REVERSED)
> > +     /* In the package, there are two pairs of PHYs (PHY0 + PHY2 and
> > +      * PHY1 + PHY3). The first PHY of each pair (PHY0 and PHY1) is
> > +      * the base PHY for timestamping operations.
> > +      */
> > +     if (val & PHY_ADDR_REVERSED) {
> >               vsc8531->base_addr = phydev->mdio.addr + addr;
> > -     else
> > +             vsc8531->ts_base_addr = phydev->mdio.addr;
> > +             vsc8531->ts_base_phy = addr;
> > +             if (addr > 1) {
> > +                     vsc8531->ts_base_addr += 2;
> > +                     vsc8531->ts_base_phy += 2;
> > +             }
> > +     } else {
> >               vsc8531->base_addr = phydev->mdio.addr - addr;
> > 
> > +             vsc8531->ts_base_addr = phydev->mdio.addr;
> > +             vsc8531->ts_base_phy = addr;
> 
> The two lines above are identical in both conditions, what about moving
> them just before the if (val & PHY_ADDR_REVERSED) line?

That's right, I'll fix it for v4.

> [...]
> 
> > +static const u32 vsc85xx_egr_latency[] = {
> > +     /* Copper Egress */
> > +     1272, /* 1000Mbps */
> > +     12516, /* 100Mbps */
> > +     125444, /* 10Mbps */
> > +     /* Fiber Egress */
> > +     1277, /* 1000Mbps */
> > +     12537, /* 100Mbps */
> > +     /* Copper Egress when MACsec ON */
> > +     3496, /* 1000Mbps */
> > +     34760, /* 100Mbps */
> > +     347844, /* 10Mbps */
> > +     /* Fiber Egress when MACsec ON */
> > +     3502, /* 1000Mbps */
> > +     34780, /* 100Mbps */
> > +};
> > +
> > +static const u32 vsc85xx_ingr_latency[] = {
> > +     /* Copper Ingress */
> > +     208, /* 1000Mbps */
> > +     304, /* 100Mbps */
> > +     2023, /* 10Mbps */
> > +     /* Fiber Ingress */
> > +     98, /* 1000Mbps */
> > +     197, /* 100Mbps */
> > +     /* Copper Ingress when MACsec ON */
> > +     2408, /* 1000Mbps */
> > +     22300, /* 100Mbps */
> > +     222009, /* 10Mbps */
> > +     /* Fiber Ingress when MACsec ON */
> > +     2299, /* 1000Mbps */
> > +     22192, /* 100Mbps */
> > +};
> > +
> 
> Wouldn't it make more sense to separate the latencies into two different
> arrays? One for non-MACsec and one with? No idx "hack" later in the 
> function that way.

Removing the "idx += 5" means having an added logic on the struct to
used to retrieve the delay (I'll use two extra variables). But I do
agree because that will improve the latency definition, and that alone
is better.

> [...]
> 
> > +static int vsc85xx_eth1_conf(struct phy_device *phydev, enum ts_blk 
> > blk,
> > +                          bool enable)
> > +{
> > +     struct vsc8531_private *vsc8531 = phydev->priv;
> > +     u32 val = ANA_ETH1_FLOW_ADDR_MATCH2_DEST;
> > +
> > +     if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_PTP_V2_L2_EVENT) {
> > +             /* PTP over Ethernet multicast address for SYNC and DELAY msg */
> > +             u8 ptp_multicast[6] = {0x01, 0x1b, 0x19, 0x00, 0x00, 0x00};
> > +
> 
> I think this is actually part of "the" standard:
> https://en.wikipedia.org/wiki/Precision_Time_Protocol#Message_transport
> 
> So would it make sense to make it available to all drivers via one of 
> the
> include/linux/ptp_*.h?

That's right. I had a look and only two drivers (including this one)
seems to be using the PTP over Ethernet multicast address. Also that
would mean adding a new header (there are none, to my knowledge, where
this would fit) for a single line definition.

I don't know, I believe this is a good idea, but maybe a bit to early?

> [...]
> 
> > +static bool vsc8584_is_1588_input_clk_configured(struct phy_device 
> > *phydev)
> > +{
> > +     struct vsc8531_private *vsc8531 = phydev->priv;
> > +
> > +     if (vsc8531->ts_base_addr != phydev->mdio.addr) {
> > +             struct mdio_device *dev;
> > +
> > +             dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
> > +             phydev = container_of(dev, struct phy_device, mdio);
> > +             vsc8531 = phydev->priv;
> > +     }
> > +
> > +     return vsc8531->input_clk_init;
> > +}
> > +
> > +static void vsc8584_set_input_clk_configured(struct phy_device 
> > *phydev)
> > +{
> > +     struct vsc8531_private *vsc8531 = phydev->priv;
> > +
> > +     if (vsc8531->ts_base_addr != phydev->mdio.addr) {
> > +             struct mdio_device *dev;
> > +
> > +             dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
> > +             phydev = container_of(dev, struct phy_device, mdio);
> > +             vsc8531 = phydev->priv;
> > +     }
> > +
> > +     vsc8531->input_clk_init = true;
> > +}
> 
> Duplicated code here.
> Maybe:
> 
> static struct vsc8531_private * vsc8584_get_ts_base_phydev(struct 
> phy_device *phydev)
> {
>         struct vsc8531_private *vsc8531 = phydev->priv;
>         if (vsc8531->ts_base_addr != phydev->mdio.addr) {
>                 struct mdio_device *dev;
> 
>                 dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
>                 phydev = container_of(dev, struct phy_device, mdio);
>                 vsc8531 = phydev->priv;
>         }
>         return vsc8531;
> }

I'll do something of the like for v4. I'll still keep the is_configured
and set_configured helpers as I don't want to expose the base PHY
private structure outside of those helpers.

> [...]
> 
> > diff --git a/drivers/net/phy/mscc/mscc_ptp.h 
> > b/drivers/net/phy/mscc/mscc_ptp.h
> [...]
> > +
> > +struct vsc85xx_ptphdr {
> > +     u8 tsmt; /* transportSpecific | messageType */
> > +     u8 ver;  /* reserved0 | versionPTP */
> > +     __be16 msglen;
> > +     u8 domain;
> > +     u8 rsrvd1;
> > +     __be16 flags;
> > +     __be64 correction;
> > +     __be32 rsrvd2;
> > +     __be64 clk_identity;
> > +     __be16 src_port_id;
> > +     __be16 seq_id;
> > +     u8 ctrl;
> > +     u8 log_interval;
> > +} __attribute__((__packed__));
> > +
> 
> AFAICT, this is also part of "the" standard:
> http://wiki.hevs.ch/uit/index.php5/Standards/Ethernet_PTP/frames#PTP_Header
> Would maybe be better to have it in one of the header files in include/?

Having common definitions when multiple drivers do use the same struct,
or defined values is good. However if like here it is used in a single
driver, and especially for this kind of representation, I don't believe
that would add any value.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
