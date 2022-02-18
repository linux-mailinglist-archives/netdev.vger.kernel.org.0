Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82EC4BB9D1
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 14:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiBRNIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 08:08:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiBRNIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 08:08:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0C26AE0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:07:58 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nL2zF-0000dh-Qy; Fri, 18 Feb 2022 14:07:49 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nL2zE-000435-RH; Fri, 18 Feb 2022 14:07:48 +0100
Date:   Fri, 18 Feb 2022 14:07:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Svenning =?utf-8?B?U8O4cmVuc2Vu?= <sss@secomea.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: fix bridging with more than two
 member ports
Message-ID: <20220218130748.GA3144@pengutronix.de>
References: <DB7PR08MB3867F92FD096A79EAD736021B5379@DB7PR08MB3867.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB7PR08MB3867F92FD096A79EAD736021B5379@DB7PR08MB3867.eurprd08.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:04:07 up 69 days, 21:49, 85 users,  load average: 0.26, 0.33,
 0.27
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 11:27:01AM +0000, Svenning Sørensen wrote:
> Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> plugged a packet leak between ports that were members of different bridges.
> Unfortunately, this broke another use case, namely that of more than two
> ports that are members of the same bridge.
> 
> After that commit, when a port is added to a bridge, hardware bridging
> between other member ports of that bridge will be cleared, preventing
> packet exchange between them.
> 
> Fix by ensuring that the Port VLAN Membership bitmap includes any existing
> ports in the bridge, not just the port being added.
> 
> Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
> Signed-off-by: Svenning Sørensen <sss@secomea.com>

Thank you for your patch. You are right. I'm able to reproduce this issue on
ksz9477.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 55dbda04ea62..243f8ad6d06e 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
>  	struct dsa_switch *ds = dev->ds;
>  	u8 port_member = 0, cpu_port;
>  	const struct dsa_port *dp;
> -	int i;
> +	int i, j;
>  
>  	if (!dsa_is_user_port(ds, port))
>  		return;
> @@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
>  			continue;
>  		if (!dsa_port_bridge_same(dp, other_dp))
>  			continue;
> +		if (other_p->stp_state != BR_STATE_FORWARDING)
> +			continue;
>  
> -		if (other_p->stp_state == BR_STATE_FORWARDING &&
> -		    p->stp_state == BR_STATE_FORWARDING) {
> +		if (p->stp_state == BR_STATE_FORWARDING) {
>  			val |= BIT(port);
>  			port_member |= BIT(i);
>  		}
>  
> +		/* Retain port [i]'s relationship to other ports than [port] */
> +		for (j = 0; j < ds->num_ports; j++) {
> +			const struct dsa_port *third_dp;
> +			struct ksz_port *third_p;
> +
> +			if (j == i)
> +				continue;
> +			if (j == port)
> +				continue;
> +			if (!dsa_is_user_port(ds, j))
> +				continue;
> +			third_p = &dev->ports[j];
> +			if (third_p->stp_state != BR_STATE_FORWARDING)
> +				continue;
> +			third_dp = dsa_to_port(ds, j);
> +			if (dsa_port_bridge_same(other_dp, third_dp))
> +				val |= BIT(j);
> +		}
> +
>  		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
>  	}
>  
> -- 
> 2.20.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
