Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B62E29773
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391204AbfEXLkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:40:55 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:53618 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390743AbfEXLky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:40:54 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,506,1549954800"; 
   d="scan'208";a="34319525"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 May 2019 04:40:53 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch02.mchp-main.com
 (10.10.76.38) with Microsoft SMTP Server id 14.3.352.0; Fri, 24 May 2019
 04:40:53 -0700
Date:   Fri, 24 May 2019 13:40:52 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/1] net: mscc: ocelot: Implement port
 policers via tc command
Message-ID: <20190524114050.rznhisqcgdm5c2e6@soft-dev16>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190523104939.2721-1-joergen.andreasen@microchip.com>
 <20190523104939.2721-2-joergen.andreasen@microchip.com>
 <20190523115630.7710cc49@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190523115630.7710cc49@cakuba.netronome.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

The 05/23/2019 11:56, Jakub Kicinski wrote:
> External E-Mail
> 
> 
> On Thu, 23 May 2019 12:49:39 +0200, Joergen Andreasen wrote:
> > Hardware offload of matchall classifier and police action are now
> > supported via the tc command.
> > Supported police parameters are: rate and burst.
> > 
> > Example:
> > 
> > Add:
> > tc qdisc add dev eth3 handle ffff: ingress
> > tc filter add dev eth3 parent ffff: prio 1 handle 2	\
> > 	matchall skip_sw				\
> > 	action police rate 100Mbit burst 10000
> > 
> > Show:
> > tc -s -d qdisc show dev eth3
> > tc -s -d filter show dev eth3 ingress
> > 
> > Delete:
> > tc filter del dev eth3 parent ffff: prio 1
> > tc qdisc del dev eth3 handle ffff: ingress
> > 
> > Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>
> 
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index d715ef4fc92f..3ec7864d9dc8 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -943,6 +943,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
> >  	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
> >  	.ndo_set_features		= ocelot_set_features,
> >  	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
> > +	.ndo_setup_tc			= ocelot_setup_tc,
> >  };
> >  
> >  static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
> > @@ -1663,8 +1664,9 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
> >  	dev->netdev_ops = &ocelot_port_netdev_ops;
> >  	dev->ethtool_ops = &ocelot_ethtool_ops;
> >  
> > -	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS;
> > -	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> > +	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
> > +		NETIF_F_HW_TC;
> > +	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
> >  
> >  	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
> >  	dev->dev_addr[ETH_ALEN - 1] += port;
> 
> You need to add a check in set_features to make sure nobody clears the
> NETIF_F_TC flag while something is offloaded, otherwise you will miss
> the REMOVE callback (it will bounce from the
> tc_cls_can_offload_and_chain0() check).

I will add this check in v3

> 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
> > new file mode 100644
> > index 000000000000..2412e0dbc267
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_tc.c
> > @@ -0,0 +1,164 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/* Microsemi Ocelot Switch TC driver
> > + *
> > + * Copyright (c) 2019 Microsemi Corporation
> > + */
> > +
> > +#include "ocelot_tc.h"
> > +#include "ocelot_police.h"
> > +#include <net/pkt_cls.h>
> > +
> > +static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
> > +					struct tc_cls_matchall_offload *f,
> > +					bool ingress)
> > +{
> > +	struct netlink_ext_ack *extack = f->common.extack;
> > +	struct ocelot_policer pol = { 0 };
> > +	struct flow_action_entry *action;
> > +	int err;
> > +
> > +	netdev_dbg(port->dev, "%s: port %u command %d cookie %lu\n",
> > +		   __func__, port->chip_port, f->command, f->cookie);
> > +
> > +	if (!ingress) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	switch (f->command) {
> > +	case TC_CLSMATCHALL_REPLACE:
> > +		if (!flow_offload_has_one_action(&f->rule->action)) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Only one action is supported");
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		action = &f->rule->action.entries[0];
> > +
> > +		if (action->id != FLOW_ACTION_POLICE) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
> > +			return -EOPNOTSUPP;
> > +		}
> 
> Please also reject the offload if block is shared, as HW policer state
> cannot be shared between ports, the way it is in SW.  You have to save
> whether the block is shared or not at bind time, see:
> 
> d6787147e15d ("net/sched: remove block pointer from common offload structure")

I will fix this in v3.

> 
> > +		if (port->tc.police_id && port->tc.police_id != f->cookie) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Only one policer per port is supported\n");
> > +			return -EEXIST;
> > +		}
> > +
> > +		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
> > +		pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
> > +					 PSCHED_NS2TICKS(action->police.burst),
> > +					 PSCHED_TICKS_PER_SEC);
> > +
> > +		err = ocelot_port_policer_add(port, &pol);
> > +		if (err) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Could not add policer\n");
> > +			return err;
> > +		}
> > +
> > +		port->tc.police_id = f->cookie;
> > +		return 0;
> > +	case TC_CLSMATCHALL_DESTROY:
> > +		if (port->tc.police_id != f->cookie)
> > +			return -ENOENT;
> > +
> > +		err = ocelot_port_policer_del(port);
> > +		if (err) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Could not delete policer\n");
> > +			return err;
> > +		}
> > +		port->tc.police_id = 0;
> > +		return 0;
> > +	case TC_CLSMATCHALL_STATS: /* fall through */
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +}
> 

-- 
Joergen Andreasen, Microchip
