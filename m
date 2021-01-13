Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D682F577E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbhANCAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:00:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39186 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729505AbhAMXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:37:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzpgh-000Qlq-Hn; Thu, 14 Jan 2021 00:36:27 +0100
Date:   Thu, 14 Jan 2021 00:36:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: felix: offload port priority
Message-ID: <X/+D+2AgnOqCxb2d@lunn.ch>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113154139.1803705-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 05:41:39PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Even though we should really share the implementation with the ocelot
> switchdev driver, that one needs a little bit of rework first, since its
> struct ocelot_port_tc only supports one tc matchall action at a time,
> which at the moment is used for port policers. Whereas DSA keeps a list
> of port-based actions in struct dsa_slave_priv::mall_tc_list, so it is
> much more easily extensible. It is too tempting to add the implementation
> for the port priority directly in Felix at the moment, which is what we
> do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 768a74dc462a..5cc42c3aaf0d 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -739,6 +739,20 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
>  	ocelot_port_policer_del(ocelot, port);
>  }
>  
> +static int felix_port_priority_set(struct dsa_switch *ds, int port,
> +				   struct dsa_mall_skbedit_tc_entry *skbedit)
> +{
> +	struct ocelot *ocelot = ds->priv;
> +
> +	ocelot_rmw_gix(ocelot,
> +		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL(skbedit->priority),

No range check? Seems like -ERANGE or similar would help avoid
surprises when somebody asks for an unsupported priority and it gets
masked to something much lower.

       Andrew
