Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A7310455
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhBEFHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhBEFHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68D6A64E24;
        Fri,  5 Feb 2021 05:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612501587;
        bh=+iHve7ZuhGC08LCG+2DlGv166rTnOpTteCl4wHOU9Zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePTniRWVmCf/OJPzp3BVgYjoQznM1dtD7tyHnTUCuzcV86MuianhJsBrbfwW2CRHJ
         WBhiJsoLfFkrnhtaGrx//nzFsFchpOiN938EXJuA5fPEPcGEu51gCSqblq6FdmtKV4
         rrT737I5vD93M1IkwJLxmzk/23HIsPfD3rgZffxiuqKSlXd9p9W2GqNyFIGCwHSGWa
         slPq/tEdRAvF2nauQtvfpZ54ZhGPttmJlthVF7P+LW/CL2g8+vxm3G7IRoJxwP3Nmf
         WUoQ/45b8zilzhY1xwKpFpMoUV7CbrAxkhqlvUeO17rNISyzzbHgFH+uYSdIspdebb
         Hyv6TipOOYrvg==
Date:   Thu, 4 Feb 2021 21:06:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: automatically bring user
 ports down when master goes down
Message-ID: <20210204210626.5e90c766@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203160823.2163194-3-olteanv@gmail.com>
References: <20210203160823.2163194-1-olteanv@gmail.com>
        <20210203160823.2163194-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 18:08:21 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is not fixing any actual bug that I know of, but having a DSA
> interface that is up even when its lower (master) interface is down is
> one of those things that just do not sound right.
> 
> Yes, DSA checks if the master is up before actually bringing the
> user interface up, but nobody prevents bringing the master interface
> down immediately afterwards... Then the user ports would attempt
> dev_queue_xmit on an interface that is down, and wonder what's wrong.
> 
> This patch prevents that from happening. NETDEV_GOING_DOWN is the
> notification emitted _before_ the master actually goes down, and we are
> protected by the rtnl_mutex, so all is well.
> 
> $ ip link set eno2 down
> [  763.672211] mscc_felix 0000:00:00.5 swp0: Link is Down
> [  763.880137] mscc_felix 0000:00:00.5 swp1: Link is Down
> [  764.078773] mscc_felix 0000:00:00.5 swp2: Link is Down
> [  764.197106] mscc_felix 0000:00:00.5 swp3: Link is Down
> [  764.299384] fsl_enetc 0000:00:00.2 eno2: Link is Down
> 
> For those of you reading this because you were doing switch testing
> such as latency measurements for autonomously forwarded traffic, and you
> needed a controlled environment with no extra packets sent by the
> network stack, this patch breaks that, because now the user ports go
> down too, which may shut down the PHY etc. But please don't do it like
> that, just do instead:
> 
> tc qdisc add dev eno2 clsact
> tc filter add dev eno2 egress flower action drop
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> Fix typo: !dsa_is_user_port -> dsa_is_user_port.
> 
>  net/dsa/slave.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 4616bd7c8684..aa7bd223073c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2084,6 +2084,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  		err = dsa_port_lag_change(dp, info->lower_state_info);
>  		return notifier_from_errno(err);
>  	}
> +	case NETDEV_GOING_DOWN: {
> +		struct dsa_port *dp, *cpu_dp;
> +		struct dsa_switch_tree *dst;
> +		int err = 0;
> +
> +		if (!netdev_uses_dsa(dev))
> +			return NOTIFY_DONE;
> +
> +		cpu_dp = dev->dsa_ptr;
> +		dst = cpu_dp->ds->dst;
> +
> +		list_for_each_entry(dp, &dst->ports, list) {
> +			if (dsa_is_user_port(dp->ds, dp->index)) {
> +				struct net_device *slave = dp->slave;
> +
> +				if (!(slave->flags & IFF_UP))
> +					continue;
> +
> +				err = dev_change_flags(slave,
> +						       slave->flags & ~IFF_UP,
> +						       NULL);
> +				if (err)
> +					break;
> +			}
> +		}

Perhaps:

		LIST_HEAD(close_list);

		list_for_each_entry(dp, &dst->ports, list)
			list_add(&slave->close_list, &close_list);

		dev_close_many(&close_list, true);

		return NOTIFY_OK;

But we can keep as is if you prefer.

> +		return notifier_from_errno(err);
> +	}
> +	default:
> +		break;
>  	}
>  
>  	return NOTIFY_DONE;

