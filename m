Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7D2D89B2
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406715AbgLLT2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:28:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390486AbgLLT2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:28:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koAYq-00BfG6-48; Sat, 12 Dec 2020 20:28:08 +0100
Date:   Sat, 12 Dec 2020 20:28:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next] net: dsa: reference count the host mdb
 addresses
Message-ID: <20201212192808.GA2779451@lunn.ch>
References: <20201212190352.214642-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212190352.214642-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* DSA can directly translate this to a normal MDB add, but on the CPU port.
> + * But because multiple user ports can join the same multicast group and the
> + * bridge will emit a notification for each port, we need to add/delete the
> + * entry towards the host only once, so we reference count it.
> + */
> +static int dsa_host_mdb_add(struct dsa_port *dp,
> +			    const struct switchdev_obj_port_mdb *mdb,
> +			    struct switchdev_trans *trans)
> +{
> +	struct dsa_port *cpu_dp = dp->cpu_dp;
> +	struct dsa_switch *ds = dp->ds;
> +	struct dsa_host_addr *a;
> +	int err;
> +
> +	a = dsa_host_addr_find(&ds->host_mdb, mdb);
> +	if (a) {
> +		/* Only the commit phase is refcounted */
> +		if (switchdev_trans_ph_commit(trans))
> +			refcount_inc(&a->refcount);
> +		return 0;
> +	}
> +
> +	err = dsa_port_mdb_add(cpu_dp, mdb, trans);
> +	if (err)
> +		return err;
> +
> +	/* Only the commit phase is refcounted, so don't save this just yet */
> +	if (switchdev_trans_ph_prepare(trans))
> +		return 0;
> +
> +	a = kzalloc(sizeof(*a), GFP_KERNEL);
> +	if (!a)
> +		return -ENOMEM;

Hi Vladimir

This allocation should be done in the prepare phase, since it can
fail. You should only return catastrophic errors during the commit
phase.

So i think you can allocate it in the prepare phase, but leave the
reference count as 0. Then increment it in the commit phase.

And then make the dsa_host_mdb_del() decrement the specific refcount,
and then do a generic garbage collect for all entries with refcount of
0, to cleanup any left over failures.

   Andrew

