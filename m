Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADEE306A6C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhA1Bc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhA1Bb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DBA64DD9;
        Thu, 28 Jan 2021 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611797446;
        bh=NeoIf9bJRcR+JL4y3Sr8OXqKF5XIzlCzEI9t1spISbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FK5P9qtZn+/U33l81PqVvXXd5lXM7MAM1JJxcILfVz3soBad+4e5iCcGl+Eb84Du4
         Ug6WX/eSiCSrlhCQzzFajL6iVu3vePihzyoveoWmSXt4TKxw1PENWE+BRewmVpVqIo
         2pJdHPb31nz1WcSRk9aNQzvtP9EnkngijmIkvwUAykVJtnNZTRt8zHXu0jXHjhSgMz
         mo1oyKZZhgIXaQWagTKCklfTKJ2PMeC8pM0x/oaPkR+p8QtyaR0sypvVKmqDS9nGVw
         ZhXXI1wPJ8gqvQ96OhvWJ86ofn8zB004YkkVM8E9jgXLuk643+XMtt7cHmMdP770BP
         CVDbdSQcLWvSg==
Date:   Wed, 27 Jan 2021 17:30:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v7 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125220333.1004365-9-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
        <20210125220333.1004365-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 00:03:30 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently DSA exposes the following sysfs:
> $ cat /sys/class/net/eno2/dsa/tagging
> ocelot
> 
> which is a read-only device attribute, introduced in the kernel as
> commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
> and used by libpcap since its commit 993db3800d7d ("Add support for DSA
> link-layer types").
> 
> It would be nice if we could extend this device attribute by making it
> writable:
> $ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> 
> This is useful with DSA switches that can make use of more than one
> tagging protocol. It may be useful in dsa_loop in the future too, to
> perform offline testing of various taggers, or for changing between dsa
> and edsa on Marvell switches, if that is desirable.
> 
> In terms of implementation, drivers can now move their tagging protocol
> configuration outside of .setup/.teardown, and into .set_tag_protocol
> and .del_tag_protocol. The calling order is:
> 
> .setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown
> 
> There was one more contract between the DSA framework and drivers, which
> is that if a CPU port needs to account for the tagger overhead in its
> MTU configuration, it must do that privately. Which means it needs the
> information about what tagger it uses before we call its MTU
> configuration function. That promise is still held.
> 
> Writing to the tagging sysfs will first tear down the tagging protocol
> for all switches in the tree attached to that DSA master, then will
> attempt setup with the new tagger.
> 
> Writing will fail quickly with -EOPNOTSUPP for drivers that don't
> support .set_tag_protocol, since that is checked during the deletion
> phase. It is assumed that all switches within the same DSA tree use the
> same driver, and therefore either all have .set_tag_protocol implemented,
> or none do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> +const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
> +{
> +	const struct dsa_device_ops *ops = NULL;
> +	struct dsa_tag_driver *dsa_tag_driver;
> +
> +	mutex_lock(&dsa_tag_drivers_lock);
> +	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
> +		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
> +
> +		if (!sysfs_streq(buf, tmp->name))
> +			continue;
> +
> +		ops = tmp;
> +		break;
> +	}
> +	mutex_unlock(&dsa_tag_drivers_lock);

What's protecting from the tag driver unloading at this very moment?

Some nit picks below if you need to respin.

> +	return ops;
> +}
> +

> +/* Since the dsa/tagging sysfs device attribute is per master, the assumption
> + * is that all DSA switches within a tree share the same tagger, otherwise
> + * they would have formed disjoint trees (different "dsa,member" values).
> + */
> +int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
> +			      struct net_device *master,
> +			      const struct dsa_device_ops *tag_ops,
> +			      const struct dsa_device_ops *old_tag_ops)
> +{
> +	struct dsa_notifier_tag_proto_info info;
> +	struct dsa_port *dp;
> +	int err = -EBUSY;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +
> +	/* At the moment we don't allow changing the tag protocol under
> +	 * traffic. The rtnl_mutex also happens to serialize concurrent
> +	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
> +	 * restriction, there needs to be another mutex which serializes this.
> +	 */
> +	if (master->flags & IFF_UP)
> +		goto out_unlock;
> +
> +	list_for_each_entry(dp, &dst->ports, list) {
> +		if (!dsa_is_user_port(dp->ds, dp->index))
> +			continue;
> +
> +		if (dp->slave->flags & IFF_UP)
> +			goto out_unlock;
> +	}
> +
> +	info.tag_ops = old_tag_ops;
> +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DEL, &info);
> +	if (err)
> +		goto out_unlock;
> +
> +	info.tag_ops = tag_ops;
> +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);

Not sure I should bother you about this or not, but it looks like
Ocelot does allocations on SET, so there is a chance of not being 
able to return to the previous config, leaving things broken.

There's quite a few examples where we use REPLACE instead of set, 
so that a careful driver can prep its resources before it kills 
the previous config. Although that's not perfect either because 
we'd rather have as much of that logic in the core as possible.

What are your thoughts?

> +	if (err)
> +		goto out_unwind_tagger;
> +
> +	dst->tag_ops = tag_ops;
> +
> +	rtnl_unlock();
> +
> +	return 0;
> +
> +out_unwind_tagger:
> +	info.tag_ops = old_tag_ops;
> +	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
> +out_unlock:
> +	rtnl_unlock();
> +	return err;
> +}

> +static bool dsa_switch_tag_proto_match(struct dsa_switch *ds, int port,
> +				       struct dsa_notifier_tag_proto_info *info)
> +{
> +	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +		return true;
> +
> +	return false;

return dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port) ?

> +}
> +
> +static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
> +				    struct dsa_notifier_tag_proto_info *info)
> +{
> +	int port;
> +
> +	/* Check early if we can replace it, so we don't delete it
> +	 * for nothing and leave the switch dangling.
> +	 */
> +	if (!ds->ops->set_tag_protocol)
> +		return -EOPNOTSUPP;
> +
> +	/* The delete method is optional, just the setter is mandatory */
> +	if (!ds->ops->del_tag_protocol)
> +		return 0;
> +
> +	ASSERT_RTNL();
> +
> +	for (port = 0; port < ds->num_ports; port++) {
> +		if (dsa_switch_tag_proto_match(ds, port, info)) {
> +			ds->ops->del_tag_protocol(ds, port,
> +						  info->tag_ops->proto);

invert condition, save indentation

> +		}
> +	}
> +
> +	return 0;
> +}
