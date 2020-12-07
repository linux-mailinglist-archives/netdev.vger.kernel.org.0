Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AFF2D1E59
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgLGX1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:27:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgLGX1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:27:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmPte-00AiHp-Ft; Tue, 08 Dec 2020 00:26:22 +0100
Date:   Tue, 8 Dec 2020 00:26:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201207232622.GA2475764@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201204022025.GC2414548@lunn.ch>
 <87v9dd5n64.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9dd5n64.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 10:19:47PM +0100, Tobias Waldekranz wrote:
> On Fri, Dec 04, 2020 at 03:20, Andrew Lunn <andrew@lunn.ch> wrote:
> >> +static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
> >> +{
> >> +	struct dsa_port *dp;
> >> +	unsigned int num;
> >> +
> >> +	list_for_each_entry(dp, &dst->ports, list)
> >> +		num = dp->ds->num_lags;
> >> +
> >> +	list_for_each_entry(dp, &dst->ports, list)
> >> +		num = min(num, dp->ds->num_lags);
> >
> > Do you really need to loop over the list twice? Cannot num be
> > initialised to UINT_MAX and then just do the second loop.
> 
> I was mostly paranoid about the case where, for some reason, the list of
> ports was empty due to an invalid DT or something. But I now see that
> since num is not initialized, that would not have helped.
> 
> So, is my paranoia valid, i.e. fix is `unsigned int num = 0`? Or can
> that never happen, i.e. fix is to initialize to UINT_MAX and remove
> first loop?

I would probably initialize to UINT_MAX, and do a WARN_ON(num ==
UINT_MAX) afterwards. I don't think the DT parsing code prevents a
setup with no ports, so it could happen.

> >> +static inline bool dsa_port_can_offload(struct dsa_port *dp,
> >> +					struct net_device *dev)
> >
> > That name is a bit generic. We have a number of different offloads.
> > The mv88E6060 cannot offload anything!
> 
> The name is intentionally generic as it answers the question "can this
> dp offload requests for this netdev?"

I think it is a bit more specific. Mirroring is an offload, but is not
taken into account here, and does mirroring setup call this to see if
mirroring can be offloaded? The hardware has rate control traffic
shaping which we might sometime add support for via TC. That again is
an offload.

> >> +{
> >> +	/* Switchdev offloading can be configured on: */
> >> +
> >> +	if (dev == dp->slave)
> >> +		/* DSA ports directly connected to a bridge. */
> >> +		return true;
> 
> This condition is the normal case of a bridged port, i.e. no LAG
> involved.
> 
> >> +	if (dp->lag && dev == rtnl_dereference(dp->lag->dev))
> >> +		/* DSA ports connected to a bridge via a LAG */
> >> +		return true;
> 
> And then the indirect case of a bridged port under a LAG.
> 
> I am happy to take requests for a better name though.

There probably needs to be lag in the name.

> 
> >> +	return false;
> >> +}
> >
> >> +static void dsa_lag_put(struct dsa_switch_tree *dst, struct dsa_lag *lag)
> >> +{
> >> +	if (!refcount_dec_and_test(&lag->refcount))
> >> +		return;
> >> +
> >> +	clear_bit(lag->id, dst->lags.busy);
> >> +	WRITE_ONCE(lag->dev, NULL);
> >> +	memset(lag, 0, sizeof(*lag));
> >> +}
> >
> > I don't know what the locking is here, but wouldn't it be safer to
> > clear the bit last, after the memset and WRITE_ONCE.
> 
> All writers of dst->lags.busy are serialized with respect to dsa_lag_put
> (on rtnl_lock), and concurrent readers (dsa_lag_dev_by_id) start by
> checking busy before reading lag->dev. To my understanding, WRITE_ONCE
> would insert the proper fence to make sure busy was cleared before
> clearing dev?

I was thinking about the lag being freed and then immediately
reused. So it sounds the RTNL allows the WRITE_ONCE and memset to
happen before the next user comes along. So this is O.K.  But maybe
you can document your locking design?

       Andrew
