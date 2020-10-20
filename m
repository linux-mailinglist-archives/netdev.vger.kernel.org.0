Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EAB293233
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389188AbgJTAGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:06:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389182AbgJTAGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:06:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUfAe-002Zij-Id; Tue, 20 Oct 2020 02:06:32 +0200
Date:   Tue, 20 Oct 2020 02:06:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Message-ID: <20201020000632.GQ456889@lunn.ch>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015212711.724678-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:27:11AM +0300, Vladimir Oltean wrote:
> Currently any DSA switch that implements the multicast ops (properly,
> that is) gets these errors after just sitting for a while, with at least
> 2 ports bridged:
> 
> [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
> 
> The reason has to do with this piece of code:
> 
> 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
> 
> called from:
> 
> br_multicast_group_expired
> -> br_multicast_host_leave
>    -> br_mdb_notify
>       -> br_mdb_switchdev_host
> 
> Basically, that code is correct. It tells each switchdev port that the
> host can leave that multicast group. But in the case of DSA, all user
> ports are connected to the host through the same pipe. So, because DSA
> translates a host MDB to a normal MDB on the CPU port, this means that
> when all user ports leave a multicast group, DSA tries to remove it N
> times from the CPU port.

Hi Vladimir

I agree with the analysis. This is how i designed it!

As far as i remember, none of the switches at the time would report an
error when asked to delete an MDB which did not exist. They also would
not give an error when adding an MDB which already exists.

So i decided to keep it KISS and not bother with reference counting.

> +static int dsa_host_mdb_add(struct dsa_port *dp,
> +			    const struct switchdev_obj_port_mdb *mdb,
> +			    struct switchdev_trans *trans)
> +{
> +	struct dsa_port *cpu_dp = dp->cpu_dp;
> +	struct dsa_switch *ds = dp->ds;
> +	struct dsa_host_addr *a;
> +	int err;
> +
> +	/* Only the commit phase is refcounted, which means that for the
> +	 * second, third, etc port which is member of this host address,
> +	 * we'll call the prepare phase but never commit.
> +	 */
> +	if (switchdev_trans_ph_prepare(trans))
> +		return dsa_port_mdb_add(cpu_dp, mdb, trans);
> +
> +	a = dsa_host_mdb_find(ds, mdb);
> +	if (a) {
> +		refcount_inc(&a->refcount);
> +		return 0;
> +	}
> +
> +	a = kzalloc(sizeof(*a), GFP_KERNEL);
> +	if (!a)
> +		return -ENOMEM;
> +

The other part of the argument is that DSA is stateless, in that there
is no dynamic memory allocation. Drivers are also stateless in terms
of dynamically allocating memory.

So, what value do this code add? Why do we actually need reference
counting?

	Andrew
