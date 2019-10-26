Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B93E5FF9
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 01:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfJZXFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 19:05:37 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:51399 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfJZXFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 19:05:37 -0400
X-Originating-IP: 92.184.102.220
Received: from localhost (unknown [92.184.102.220])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 0AAA3240004;
        Sat, 26 Oct 2019 23:05:34 +0000 (UTC)
Date:   Sun, 27 Oct 2019 01:05:11 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        antoine.tenart@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net 2/2] net: mscc: ocelot: refuse to overwrite the
 port's native vlan
Message-ID: <20191026230511.GF3125@piout.net>
References: <20191026180427.14039-1-olteanv@gmail.com>
 <20191026180427.14039-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026180427.14039-3-olteanv@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2019 21:04:27+0300, Vladimir Oltean wrote:
> The switch driver keeps a "vid" variable per port, which signifies _the_
> VLAN ID that is stripped on that port's egress (aka the native VLAN on a
> trunk port).
> 
> That is the way the hardware is designed (mostly). The port->vid is
> programmed into REW:PORT:PORT_VLAN_CFG:PORT_VID and the rewriter is told
> to send all traffic as tagged except the one having port->vid.
> 
> There exists a possibility of finer-grained egress untagging decisions:
> using the VCAP IS1 engine, one rule can be added to match every
> VLAN-tagged frame whose VLAN should be untagged, and set POP_CNT=1 as
> action. However, the IS1 can hold at most 512 entries, and the VLANs are
> in the order of 6 * 4096.
> 
> So the code is fine for now. But this sequence of commands:
> 
> $ bridge vlan add dev swp0 vid 1 pvid untagged
> $ bridge vlan add dev swp0 vid 2 untagged
> 
> makes untagged and pvid-tagged traffic be sent out of swp0 as tagged
> with VID 1, despite user's request.
> 
> Prevent that from happening. The user should temporarily remove the
> existing untagged VLAN (1 in this case), add it back as tagged, and then
> add the new untagged VLAN (2 in this case).
> 
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 552252331e55..18d7ba033d05 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -262,8 +262,15 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
>  		port->pvid = vid;
>  
>  	/* Untagged egress vlan clasification */
> -	if (untagged)
> +	if (untagged && port->vid != vid) {
> +		if (port->vid) {
> +			dev_err(ocelot->dev,
> +				"Port already has a native VLAN: %d\n",
> +				port->vid);
> +			return -EBUSY;
> +		}
>  		port->vid = vid;
> +	}
>  
>  	ocelot_vlan_port_apply(ocelot, port);
>  
> -- 
> 2.17.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
