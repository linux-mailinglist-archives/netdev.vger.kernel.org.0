Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F002F24FA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405430AbhALAZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404144AbhAKXjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:39:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F3F22D0B;
        Mon, 11 Jan 2021 23:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408332;
        bh=lRbinhY3PN7BxhvNLR0X+P0hdH51gSvDHp+eHlne3KA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cz7cxy1P/db8GqEEZxqh7TkC7VWV177YLM5quYgC5mW64XpWAvwaIxKcPWPMDRlEG
         6qRsBenPj2adQ1bjhOD24YMxWjskKOAp9i8rUa6pXpA/FLt8DDW5ASPWdc7QRHb/pN
         jQRPx2VoWSuBKh6uKrbzWk1S2i+sXPN9Yhw2EDWGNMu8ouYTuM/+TpPFIoBtEUpzVp
         CqTEmU4qKvSU/zZPF//FFLtKqlXtdcQDRHcnutrOlMhoW/dTQgCMAS0A+IhgF3REh5
         6cB2fznF8Y6enbUlezLLkcX+5mejO2jiW+8qdRhlueDYa4lwkapa+osAdrCLoPjB6h
         cOeX2EurakQeg==
Message-ID: <cbead0479ef0b601bada5ae2ad0f8c28e5b242c9.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 14/15] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Mon, 11 Jan 2021 15:38:49 -0800
In-Reply-To: <20210109172624.2028156-15-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-15-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is an effort to convert .ndo_get_stats64 to sleepable context,
> and
> for that to work, we need to prevent callers of dev_get_stats from
> using
> atomic locking.
> 
> The bonding driver retrieves its statistics recursively from its
> lower
> interfaces, with additional care to only count packets sent/received
> while those lowers were actually enslaved to the bond - see commit
> 5f0c5f73e5ef ("bonding: make global bonding stats more reliable").
> 
> Since commit 87163ef9cda7 ("bonding: remove last users of bond->lock
> and
> bond->lock itself"), the bonding driver uses the following protection
> for its array of slaves: RCU for readers and rtnl_mutex for updaters.
> 
> The aforementioned commit removed an interesting comment:
> 
> 	/* [...] we can't hold bond->lock [...] because we'll
> 	 * deadlock. The only solution is to rely on the fact
> 	 * that we're under rtnl_lock here, and the slaves
> 	 * list won't change. This doesn't solve the problem
> 	 * of setting the slave's MTU while it is
> 	 * transmitting, but the assumption is that the base
> 	 * driver can handle that.
> 	 *
> 	 * TODO: figure out a way to safely iterate the slaves
> 	 * list, but without holding a lock around the actual
> 	 * call to the base driver.
> 	 */
> 
> The above summarizes pretty well the challenges we have with nested
> bonding interfaces (bond over bond over bond over...) and locking for
> their slaves.
> 
> To solve the nesting problem, the simple way is to not hold any locks
> when recursing into the slave netdev operation. We can "cheat" and
> use
> dev_hold to take a reference on the slave net_device, which is enough
> to
> ensure that netdev_wait_allrefs() waits until we finish, and the
> kernel
> won't fault.
> 
> However, the slave structure might no longer be valid, just its
> associated net_device. So we need to do some more work to ensure that
> the slave exists after we took the statistics, and if it still does,
> reapply the logic from Andy's commit 5f0c5f73e5ef.
> 
> Tested using the following two scripts running in parallel:
> 
> 	#!/bin/bash
> 
> 	while :; do
> 		ip link del bond0
> 		ip link del bond1
> 		ip link add bond0 type bond mode 802.3ad
> 		ip link add bond1 type bond mode 802.3ad
> 		ip link set sw0p1 down && ip link set sw0p1 master
> bond0 && ip link set sw0p1 up
> 		ip link set sw0p2 down && ip link set sw0p2 master
> bond0 && ip link set sw0p2 up
> 		ip link set sw0p3 down && ip link set sw0p3 master
> bond0 && ip link set sw0p3 up
> 		ip link set bond0 down && ip link set bond0 master
> bond1 && ip link set bond0 up
> 		ip link set sw1p1 down && ip link set sw1p1 master
> bond1 && ip link set sw1p1 up
> 		ip link set bond1 up
> 		ip -s -s link show
> 		cat /sys/class/net/bond1/statistics/*
> 	done
> 
> 	#!/bin/bash
> 
> 	while :; do
> 		echo spi2.0 > /sys/bus/spi/drivers/sja1105/unbind
> 		echo spi2.0 > /sys/bus/spi/drivers/sja1105/bind
> 		sleep 30
> 	done
> 
> where the sja1105 driver was explicitly modified for the purpose of
> this
> test to have a msleep(500) in its .ndo_get_stats64 method, to catch
> some
> more potential races.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> 
[...]
>  
> +/* Helpers for reference counting the struct net_device behind the
> bond slaves.
> + * These can be used to propagate the net_device_ops from the bond
> to the
> + * slaves while not holding rcu_read_lock() or the rtnl_mutex.
> + */
> +struct bonding_slave_dev {
> +	struct net_device *ndev;
> +	struct list_head list;
> +};
> +
> +static inline void bond_put_slaves(struct list_head *slaves)
> +{
> +	struct bonding_slave_dev *s, *tmp;
> +
> +	list_for_each_entry_safe(s, tmp, slaves, list) {
> +		dev_put(s->ndev);
> +		list_del(&s->list);
> +		kfree(s);
> +	}
> +}
> +
> +static inline int bond_get_slaves(struct bonding *bond,
> +				  struct list_head *slaves,
> +				  int *num_slaves)
> +{
> +	struct list_head *iter;
> +	struct slave *slave;
> +
> +	INIT_LIST_HEAD(slaves);
> +	*num_slaves = 0;
> +
> +	rcu_read_lock();
> +
> +	bond_for_each_slave_rcu(bond, slave, iter) {
> +		struct bonding_slave_dev *s;
> +
> +		s = kzalloc(sizeof(*s), GFP_ATOMIC);

GFP_ATOMIC is a little bit aggressive especially when user daemons are
periodically reading stats. This can be avoided.

You can pre-allocate with GFP_KERNEL an array with an "approximate"
size.
then fill the array up with whatever slaves the the bond has at that
moment, num_of_slaves  can be less, equal or more than the array you
just allocated but we shouldn't care .. 

something like:
rcu_read_lock()
nslaves = bond_get_num_slaves();
rcu_read_unlock()
sarray = kcalloc(nslaves, sizeof(struct bonding_slave_dev),
GFP_KERNEL);
rcu_read_lock();
bond_fill_slaves_array(bond, sarray); // also do: dev_hold()
rcu_read_unlock();


bond_get_slaves_array_stats(sarray);

bond_put_slaves_array(sarray);


> +		if (!s) {
> +			rcu_read_unlock();
> +			bond_put_slaves(slaves);
> +			return -ENOMEM;
> +		}
> +
> +		s->ndev = slave->dev;
> +		dev_hold(s->ndev);
> +		list_add_tail(&s->list, slaves);
> +		(*num_slaves)++;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return 0;
> +}
> +
>  #define BOND_PRI_RESELECT_ALWAYS	0
>  #define BOND_PRI_RESELECT_BETTER	1
>  #define BOND_PRI_RESELECT_FAILURE	2

