Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A362E2CE5A0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgLDCVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:21:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgLDCVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:21:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kl0ht-00A8dd-G8; Fri, 04 Dec 2020 03:20:25 +0100
Date:   Fri, 4 Dec 2020 03:20:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201204022025.GC2414548@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
> +{
> +	struct dsa_port *dp;
> +	unsigned int num;
> +
> +	list_for_each_entry(dp, &dst->ports, list)
> +		num = dp->ds->num_lags;
> +
> +	list_for_each_entry(dp, &dst->ports, list)
> +		num = min(num, dp->ds->num_lags);

Do you really need to loop over the list twice? Cannot num be
initialised to UINT_MAX and then just do the second loop.

> +static inline bool dsa_port_can_offload(struct dsa_port *dp,
> +					struct net_device *dev)

That name is a bit generic. We have a number of different offloads.
The mv88E6060 cannot offload anything!

> +{
> +	/* Switchdev offloading can be configured on: */
> +
> +	if (dev == dp->slave)
> +		/* DSA ports directly connected to a bridge. */
> +		return true;
> +
> +	if (dp->lag && dev == rtnl_dereference(dp->lag->dev))
> +		/* DSA ports connected to a bridge via a LAG */
> +		return true;
> +
> +	return false;
> +}

> +static void dsa_lag_put(struct dsa_switch_tree *dst, struct dsa_lag *lag)
> +{
> +	if (!refcount_dec_and_test(&lag->refcount))
> +		return;
> +
> +	clear_bit(lag->id, dst->lags.busy);
> +	WRITE_ONCE(lag->dev, NULL);
> +	memset(lag, 0, sizeof(*lag));
> +}

I don't know what the locking is here, but wouldn't it be safer to
clear the bit last, after the memset and WRITE_ONCE.

    Andrew
