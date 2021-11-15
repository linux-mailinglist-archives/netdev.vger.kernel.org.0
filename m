Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E088450238
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhKOKUc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 05:20:32 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38329 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhKOKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:20:29 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8942660010;
        Mon, 15 Nov 2021 10:17:31 +0000 (UTC)
Date:   Mon, 15 Nov 2021 11:13:44 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Message-ID: <20211115111344.03376026@fixe.home>
In-Reply-To: <20211103145351.793538c3@fixe.home>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-4-clement.leger@bootlin.com>
        <20211103123811.im5ua7kirogoltm7@skbuf>
        <20211103145351.793538c3@fixe.home>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 3 Nov 2021 14:53:51 +0100,
Clément Léger <clement.leger@bootlin.com> a écrit :

> Le Wed, 3 Nov 2021 12:38:12 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :
> 
> > On Wed, Nov 03, 2021 at 10:19:40AM +0100, Clément Léger wrote:  
> > > IFH preparation can take quite some time on slow processors (up to
> > > 5% in a iperf3 test for instance). In order to reduce the cost of
> > > this preparation, pre-compute IFH since most of the parameters are
> > > fixed per port. Only rew_op and vlan tag will be set when sending
> > > if different than 0. This allows to remove entirely the calls to
> > > packing() with basic usage. In the same time, export this function
> > > that will be used by FDMA.
> > > 
> > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > > ---    
> > 
> > Honestly, this feels a bit cheap/gimmicky, and not really the
> > fundamental thing to address. In my testing of a similar idea (see
> > commits 67c2404922c2 ("net: dsa: felix: create a template for the DSA
> > tags on xmit") and then 7c4bb540e917 ("net: dsa: tag_ocelot: create
> > separate tagger for Seville"), the net difference is not that stark,
> > considering that now you need to access one more memory region which
> > you did not need before, do a memcpy, and then patch the IFH anyway
> > for the non-constant stuff.  
> 
> The memcpy is neglectable and the patching happens only in a few
> cases (at least vs the packing function call). The VSC7514 CPU is really
> slow and lead to 2.5% up to 5% time spent in packing() when using iperf3
> and depending on the use case (according to ftrace).
> 
> > 
> > Certainly, for the calls to ocelot_port_inject_frame() from DSA, I
> > would prefer not having this pre-computed IFH.
> > 
> > Could you provide some before/after performance numbers and perf
> > counters?  
> 
> I will make another round of measure to confirm my previous number and
> check the impact on the injection rate on ocelot.

I checked again my bandwith numbers (obtained with iperf3) with and
without the pre-computed header:

Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
- With pre-computed header: UDP TX: 	33Mbit/s
- Without UDP TX: 			31Mbit/s
-> 6.5% improvement

Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
- With pre-computed header: UDP TX: 	15.8Mbit/s
- Without UDP TX: 			16.4Mbit/s
-> 4.3% improvement

The improvement might not be huge but also not negligible at all.
Please tell me if you want me to drop it or not based on those numbers.

> 
> >   
> > >  drivers/net/ethernet/mscc/ocelot.c | 23 ++++++++++++++++++-----
> > >  include/soc/mscc/ocelot.h          |  5 +++++
> > >  2 files changed, 23 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mscc/ocelot.c
> > > b/drivers/net/ethernet/mscc/ocelot.c index
> > > e6c18b598d5c..97693772595b 100644 ---
> > > a/drivers/net/ethernet/mscc/ocelot.c +++
> > > b/drivers/net/ethernet/mscc/ocelot.c @@ -1076,20 +1076,29 @@ bool
> > > ocelot_can_inject(struct ocelot *ocelot, int grp) }
> > >  EXPORT_SYMBOL(ocelot_can_inject);
> > >  
> > > +void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32
> > > rew_op,
> > > +			 u32 vlan_tag)
> > > +{
> > > +	memcpy(ifh, port->ifh, OCELOT_TAG_LEN);
> > > +
> > > +	if (vlan_tag)
> > > +		ocelot_ifh_set_vlan_tci(ifh, vlan_tag);
> > > +	if (rew_op)
> > > +		ocelot_ifh_set_rew_op(ifh, rew_op);
> > > +}
> > > +EXPORT_SYMBOL(ocelot_ifh_port_set);
> > > +
> > >  void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int
> > > grp, u32 rew_op, struct sk_buff *skb)
> > >  {
> > > +	struct ocelot_port *port_s = ocelot->ports[port];
> > >  	u32 ifh[OCELOT_TAG_LEN / 4] = {0};
> > >  	unsigned int i, count, last;
> > >  
> > >  	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
> > >  			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
> > >  
> > > -	ocelot_ifh_set_bypass(ifh, 1);
> > > -	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
> > > -	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
> > > -	ocelot_ifh_set_vlan_tci(ifh, skb_vlan_tag_get(skb));
> > > -	ocelot_ifh_set_rew_op(ifh, rew_op);
> > > +	ocelot_ifh_port_set(ifh, port_s, rew_op,
> > > skb_vlan_tag_get(skb)); 
> > >  	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
> > >  		ocelot_write_rix(ocelot, ifh[i], QS_INJ_WR, grp);
> > > @@ -2128,6 +2137,10 @@ void ocelot_init_port(struct ocelot *ocelot,
> > > int port) 
> > >  	skb_queue_head_init(&ocelot_port->tx_skbs);
> > >  
> > > +	ocelot_ifh_set_bypass(ocelot_port->ifh, 1);
> > > +	ocelot_ifh_set_dest(ocelot_port->ifh, BIT_ULL(port));
> > > +	ocelot_ifh_set_tag_type(ocelot_port->ifh, IFH_TAG_TYPE_C);
> > > +
> > >  	/* Basic L2 initialization */
> > >  
> > >  	/* Set MAC IFG Gaps
> > > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > > index fef3a36b0210..b3381c90ff3e 100644
> > > --- a/include/soc/mscc/ocelot.h
> > > +++ b/include/soc/mscc/ocelot.h
> > > @@ -6,6 +6,7 @@
> > >  #define _SOC_MSCC_OCELOT_H
> > >  
> > >  #include <linux/ptp_clock_kernel.h>
> > > +#include <linux/dsa/ocelot.h>
> > >  #include <linux/net_tstamp.h>
> > >  #include <linux/if_vlan.h>
> > >  #include <linux/regmap.h>
> > > @@ -623,6 +624,8 @@ struct ocelot_port {
> > >  
> > >  	struct net_device		*bridge;
> > >  	u8				stp_state;
> > > +
> > > +	u8				ifh[OCELOT_TAG_LEN];
> > >  };
> > >  
> > >  struct ocelot {
> > > @@ -754,6 +757,8 @@ void __ocelot_target_write_ix(struct ocelot
> > > *ocelot, enum ocelot_target target, bool ocelot_can_inject(struct
> > > ocelot *ocelot, int grp); void ocelot_port_inject_frame(struct
> > > ocelot *ocelot, int port, int grp, u32 rew_op, struct sk_buff *skb);
> > > +void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32
> > > rew_op,
> > > +			 u32 vlan_tag);
> > >  int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct
> > > sk_buff **skb); void ocelot_drain_cpu_queue(struct ocelot *ocelot,
> > > int grp); 
> > > -- 
> > > 2.33.0  
> >     
> 
> 
> 



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
