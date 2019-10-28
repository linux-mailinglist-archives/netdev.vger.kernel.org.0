Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB92E7D40
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbfJ1XuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:50:06 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9052 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbfJ1XuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:50:05 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: p+87fJkNFCesIfj4T17W8DIUiIkYEhN5SQmq14bPFs64DX6DD2Dcc0WNkoE+LVm+0rGTjzVhgT
 RmJE2Y+lUKrUI07mKANoYL41vey2zgs/utbDj4P2qULalz/hoVyHhprKZ+kEBz8tH9fCYD3kRq
 2VbKvgDY72bbVZQNFvdogMgbuYHo1mo7sMEZwQFvuMfd0iFVxvHW4oYt2tX5tX2za/0ycdjELm
 IdAZOgeYQMnzEDKrqwmgty8pBHdAJVq9+3jG7xEKqHMCchm05wukZwhwJPnEpaPUWjrQFSTIqQ
 T0U=
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="scan'208";a="54734498"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2019 16:50:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 28 Oct 2019 16:50:01 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 28 Oct 2019 16:50:02 -0700
Date:   Tue, 29 Oct 2019 00:48:58 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <joergen.andreasen@microchip.com>, <allan.nielsen@microchip.com>,
        <antoine.tenart@bootlin.com>, <alexandre.belloni@bootlin.com>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>
Subject: Re: [PATCH net 1/2] net: mscc: ocelot: fix vlan_filtering when
 enslaving to bridge before link is up
Message-ID: <20191028234856.ay7fmoctcqmv7vpn@soft-dev3.microsemi.net>
References: <20191026180427.14039-1-olteanv@gmail.com>
 <20191026180427.14039-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191026180427.14039-2-olteanv@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/26/2019 21:04, Vladimir Oltean wrote:
> Background information: the driver operates the hardware in a mode where
> a single VLAN can be transmitted as untagged on a particular egress
> port. That is the "native VLAN on trunk port" use case. Its value is
> held in port->vid.
> 
> Consider the following command sequence (no network manager, all
> interfaces are down, debugging prints added by me):
> 
> $ ip link add dev br0 type bridge vlan_filtering 1
> $ ip link set dev swp0 master br0
> 
> Kernel code path during last command:
> 
> br_add_slave -> ocelot_netdevice_port_event (NETDEV_CHANGEUPPER):
> [   21.401901] ocelot_vlan_port_apply: port 0 vlan aware 0 pvid 0 vid 0
> 
> br_add_slave -> nbp_vlan_init -> switchdev_port_attr_set -> ocelot_port_attr_set (SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING):
> [   21.413335] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 0 vid 0
> 
> br_add_slave -> nbp_vlan_init -> nbp_vlan_add -> br_switchdev_port_vlan_add -> switchdev_port_obj_add -> ocelot_port_obj_add -> ocelot_vlan_vid_add
> [   21.667421] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 1
> 
> So far so good. The bridge has replaced the driver's default pvid used
> in standalone mode (0) with its own default_pvid (1). The port's vid
> (native VLAN) has also changed from 0 to 1.
> 
> $ ip link set dev swp0 up
> 
> [   31.722956] 8021q: adding VLAN 0 to HW filter on device swp0
> do_setlink -> dev_change_flags -> vlan_vid_add -> ocelot_vlan_rx_add_vid -> ocelot_vlan_vid_add:
> [   31.728700] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 0
> 
> The 8021q module uses the .ndo_vlan_rx_add_vid API on .ndo_open to make
> ports be able to transmit and receive 802.1p-tagged traffic by default.
> This API is supposed to offload a VLAN sub-interface, which for a switch
> port means to add a VLAN that is not a pvid, and tagged on egress.
> 
> But the driver implementation of .ndo_vlan_rx_add_vid is wrong: it adds
> back vid 0 as "egress untagged". Now back to the initial paragraph:
> there is a single untagged VID that the driver keeps track of, and that
> has just changed from 1 (the pvid) to 0. So this breaks the bridge
> core's expectation, because it has changed vid 1 from untagged to
> tagged, when what the user sees is.
> 
> $ bridge vlan
> port    vlan ids
> swp0     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> 
> But curiously, instead of manifesting itself as "untagged and
> pvid-tagged traffic gets sent as tagged on egress", the bug:
> 
> - is hidden when vlan_filtering=0
> - manifests as dropped traffic when vlan_filtering=1, due to this setting:
> 
> 	if (port->vlan_aware && !port->vid)
> 		/* If port is vlan-aware and tagged, drop untagged and priority
> 		 * tagged frames.
> 		 */
> 		val |= ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
> 		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
> 		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
> 
> which would have made sense if it weren't for this bug. The setting's
> intention was "this is a trunk port with no native VLAN, so don't accept
> untagged traffic". So the driver was never expecting to set VLAN 0 as
> the value of the native VLAN, 0 was just encoding for "invalid".
> 
> So the fix is to not send 802.1p traffic as untagged, because that would
> change the port's native vlan to 0, unbeknownst to the bridge, and
> trigger unexpected code paths in the driver.
> 
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 7190fe4c1095..552252331e55 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -915,7 +915,7 @@ static int ocelot_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
>  static int ocelot_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  				  u16 vid)
>  {
> -	return ocelot_vlan_vid_add(dev, vid, false, true);
> +	return ocelot_vlan_vid_add(dev, vid, false, false);
>  }
>  
>  static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> -- 
> 2.17.1
> 

-- 
/Horatiu
