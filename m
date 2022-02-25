Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825F84C3E48
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiBYGPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiBYGPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6321BBF5D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F43961A4F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E12C340E7;
        Fri, 25 Feb 2022 06:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645769689;
        bh=SnqDvWOZGiVjRgMTIPLenHCMpaXCWJQ1QvUVeWO7J3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SeuqE2ThDKlNXbvjIhLcJdJVFKX6dHIQk00vQE2ebUBRQTDF1v2YBEydz31toqeKh
         z1D5sueMcWU3oXdg4vd7aoLT1cWGwtW6Wc25wU6GbzOFf8RaqB1Tm06LYYtk1Hv7+R
         kzkZ75c091ykfWotoQ11G8TuV/fmEOV4/uIaPsB6l4oEzIwEp3r3ye8PK3emsGw5Y9
         SShktAFYLRWPIJUXy/k8ZWy/O6sasI5VHdqMkEpsa0jpGZikKPxR2v4eb+Bpcckk0H
         uub1vHj8n8t+xpFVflclfyiJ8L9su/XLWxUjKB9WAf/f3n6aWyCesg7SciczzTWlpn
         uJ24SXPbcdZkw==
Date:   Thu, 24 Feb 2022 22:14:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 03/14] net: rtnetlink: RTM_GETSTATS: Allow
 filtering inside nests
Message-ID: <20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220224133335.599529-4-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-4-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 15:33:24 +0200 Ido Schimmel wrote:
> From: Petr Machata <petrm@nvidia.com>
> 
> The filter_mask field of RTM_GETSTATS header determines which top-level
> attributes should be included in the netlink response. This saves
> processing time by only including the bits that the user cares about
> instead of always dumping everything. This is doubly important for
> HW-backed statistics that would typically require a trip to the device to
> fetch the stats.
> 
> So far there was only one HW-backed stat suite per attribute. However,
> IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest, and will gain a new stat suite in
> the following patches. It would therefore be advantageous to be able to
> filter within that nest, and select just one or the other HW-backed
> statistics suite.
> 
> Extend rtnetlink so that RTM_GETSTATS permits attributes in the payload.
> The scheme is as follows:
> 
>     - RTM_GETSTATS
> 	- struct if_stats_msg
> 	- attr nest IFLA_STATS_GET_FILTERS
> 	    - attr IFLA_STATS_LINK_OFFLOAD_XSTATS
> 		- struct nla_bitfield32 filter_mask
> 
> This scheme reuses the existing enumerators by nesting them in a dedicated
> context attribute. This is covered by policies as usual, therefore a
> gradual opt-in is possible. Currently only IFLA_STATS_LINK_OFFLOAD_XSTATS
> nest has filtering enabled, because for the SW counters the issue does not
> seem to be that important.
> 
> rtnl_offload_xstats_get_size() and _fill() are extended to observe the
> requested filters.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

> @@ -5319,8 +5339,12 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
>  		}
>  	}
>  
> -	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0))
> -		size += rtnl_offload_xstats_get_size(dev);
> +	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0)) {
> +		u32 off_filter_mask;
> +
> +		off_filter_mask = filters->mask[IFLA_STATS_LINK_OFFLOAD_XSTATS];
> +		size += rtnl_offload_xstats_get_size(dev, off_filter_mask);
> +	}
>  
>  	if (stats_attr_valid(filter_mask, IFLA_STATS_AF_SPEC, 0)) {
>  		struct rtnl_af_ops *af_ops;
> @@ -5344,6 +5368,75 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
>  	return size;
>  }
>  
> +static const struct nla_policy
> +rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
> +	[IFLA_STATS_GETSET_UNSPEC] = { .strict_start_type = 1 },

I don't think we need the .strict_start_type if the policy is not used
in parse calls with a _deprecated() suffix, no?

> +	[IFLA_STATS_GET_FILTERS] = { .type = NLA_NESTED },

NLA_POLICY_NESTED()? Maybe one day we'll have policy dumping 
for rtnetlink and it'll be useful to have policies linked up.

> +};
> +
> +#define RTNL_STATS_OFFLOAD_XSTATS_VALID ((1 << __IFLA_OFFLOAD_XSTATS_MAX) - 1)
> +
> +static const struct nla_policy
> +rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
> +	[IFLA_STATS_UNSPEC] = { .strict_start_type = 1 },
> +	[IFLA_STATS_LINK_OFFLOAD_XSTATS] =
> +			NLA_POLICY_BITFIELD32(RTNL_STATS_OFFLOAD_XSTATS_VALID),
> +};
> +
> +static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
> +					struct rtnl_stats_dump_filters *filters,
> +					struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_STATS_MAX + 1];
> +	int err;
> +	int at;
> +
> +	err = nla_parse_nested(tb, IFLA_STATS_MAX, ifla_filters,
> +			       rtnl_stats_get_policy_filters, extack);
> +	if (err < 0)
> +		return err;
> +
> +	for (at = 1; at <= IFLA_STATS_MAX; at++) {
> +		if (tb[at]) {
> +			if (!(filters->mask[0] & IFLA_STATS_FILTER_BIT(at))) {
> +				NL_SET_ERR_MSG(extack, "Filtered attribute not enabled in filter_mask");
> +				return -EINVAL;
> +			}
> +			filters->mask[at] = nla_get_bitfield32(tb[at]).value;

Why use bitfield if we only use the .value, a u32 would do?

> +		}
> +	}
