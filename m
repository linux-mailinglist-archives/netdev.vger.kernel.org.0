Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84417491D
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 21:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgB2UO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 15:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbgB2UO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 15:14:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF31E24688;
        Sat, 29 Feb 2020 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583007295;
        bh=rm4Aq0v3w00Ar+ifPaGHDX2fUszoyPzb3lmKmYbIu7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cWSTVvhbrHTKjPmOc2BIk1nfcO1edg6qRBuxO8Jzit27I5HH4yMw1QLdlKfqopuDM
         gg8epG6U9Y7P/Nx8zGWcyqL2FV4CeZbo5hWWy2L6rDfoS+4nhwBdKsPIIbF8ZMAbo/
         JjtDIuEI5x7Pbdswtsu4z7bC4ABXp6z4h/vY6how=
Date:   Sat, 29 Feb 2020 12:14:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify
 type of HW stats for a filter
Message-ID: <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200229075209.GM26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-13-jiri@resnulli.us>
        <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200229075209.GM26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Feb 2020 08:52:09 +0100 Jiri Pirko wrote:
> Fri, Feb 28, 2020 at 08:59:23PM CET, kuba@kernel.org wrote:
> >On Fri, 28 Feb 2020 18:25:05 +0100 Jiri Pirko wrote:  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> +/* tca HW stats type */
> >> +enum tca_act_hw_stats_type {
> >> +	TCA_ACT_HW_STATS_TYPE_ANY, /* User does not care, it's default
> >> +				    * when user does not pass the attr.
> >> +				    * Instructs the driver that user does not
> >> +				    * care if the HW stats are "immediate"
> >> +				    * or "delayed".
> >> +				    */
> >> +	TCA_ACT_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
> >> +					  * the current HW stats state from
> >> +					  * the device queried at the dump time.
> >> +					  */
> >> +	TCA_ACT_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
> >> +					* HW stats that might be out of date
> >> +					* for some time, maybe couple of
> >> +					* seconds. This is the case when driver
> >> +					* polls stats updates periodically
> >> +					* or when it gets async stats update
> >> +					* from the device.
> >> +					*/
> >> +	TCA_ACT_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
> >> +					 * any HW statistics.
> >> +					 */
> >> +};  
> >
> >On the ABI I wonder if we can redefine it a little bit..
> >
> >Can we make the stat types into a bitfield?
> >
> >On request:
> > - no attr -> any stats allowed but some stats must be provided *
> > - 0       -> no stats requested / disabled
> > - 0x1     -> must be stat type0
> > - 0x6     -> stat type1 or stat type2 are both fine  
> 
> I was thinking about this of course. On the write side, this is ok
> however, this is very tricky on read side. See below.
> 
> >* no attr kinda doesn't work 'cause u32 offload has no stats and this
> >  is action-level now, not flower-level :S What about u32 and matchall?  
> 
> The fact that cls does not implement stats offloading is a lack of
> feature of the particular cls.

Yeah, I wonder how that squares with strict netlink parsing.

> >We can add a separate attribute with "active" stat types:
> > - no attr -> old kernel
> > - 0       -> no stats are provided / stats disabled
> > - 0x1     -> only stat type0 is used by drivers
> > - 0x6     -> at least one driver is using type1 and one type2  
> 
> There are 2 problems:
> 1) There is a mismatch between write and read. User might pass different
> value than it eventually gets from kernel. I guess this might be fine.

Separate attribute would work.

> 2) Much bigger problem is, that since the same action may be offloaded
> by multiple drivers, the read would have to provide an array of
> bitfields, each array item would represent one offloaded driver. That is
> why I decided for simple value instead of bitfield which is the same on
> write and read.

Why an array? The counter itself is added up from all the drivers.
If the value is a bitfield all drivers can just OR-in their type.

> >That assumes that we may one day add another stat type which would 
> >not be just based on the reporting time.
> >
> >If we only foresee time-based reporting would it make sense to turn 
> >the attribute into max acceptable delay in ms?
> >
> >0        -> only immediate / blocking stats
> >(0, MAX) -> given reporting delay in ms is acceptable
> >MAX      -> don't care about stats at all  
> 
> Interesting, is this "delayed" granularity something that has a usecase?
> It might turn into a guessing game between user and driver during action
> insertion :/

Yeah, I don't like the guessing part too, worst case refresh time may 
be system dependent.

With just "DELAYED" I'm worried users will think the delay may be too
long for OvS. Or simply poll the statistics more often than the HW
reports them, which would be pointless.

For the latter case I guess the best case refresh time is needed, 
while the former needs worst case. Hopefully the two are not too far
apart.

Maybe some day drivers may also tweak the refresh rate based on user
requests to save PCIe bandwidth and CPU..

Anyway.. maybe its not worth it today.

> >> +tcf_flow_action_hw_stats_type(enum tca_act_hw_stats_type hw_stats_type)
> >> +{
> >> +	switch (hw_stats_type) {
> >> +	default:
> >> +		WARN_ON(1);
> >> +		/* fall-through */  
> >
> >without the policy change this seems user-triggerable  
> 
> Nope. tcf_action_hw_stats_type_get() takes care of setting 
> TCA_ACT_HW_STATS_TYPE_ANY when no attr is passed.

I meant attribute is present but carries a large value.

> >> +	case TCA_ACT_HW_STATS_TYPE_ANY:
> >> +		return FLOW_ACTION_HW_STATS_TYPE_ANY;
> >> +	case TCA_ACT_HW_STATS_TYPE_IMMEDIATE:
> >> +		return FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE;
> >> +	case TCA_ACT_HW_STATS_TYPE_DELAYED:
> >> +		return FLOW_ACTION_HW_STATS_TYPE_DELAYED;
> >> +	case TCA_ACT_HW_STATS_TYPE_DISABLED:
> >> +		return FLOW_ACTION_HW_STATS_TYPE_DISABLED;

