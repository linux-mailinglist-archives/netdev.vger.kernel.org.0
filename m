Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6256480711
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 08:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhL1Hss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 02:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbhL1Hsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 02:48:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD34C061574;
        Mon, 27 Dec 2021 23:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE851B81186;
        Tue, 28 Dec 2021 07:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF51C36AE8;
        Tue, 28 Dec 2021 07:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640677724;
        bh=Ru/VX84qZ9i8SqAI0BDyiw6l+oMBXweHbnTM7nIfTHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r8yx6BLBVfjR6lhoKCobNissmorasFAxHnYxnuYWCEhy2opsWzlsVEMq8HT3V30pG
         uxd6AVbQQ5/QWEAyKWztDcjtO5DIHcgDb0G8SqOorSKi6BXrP3ez3ZGRfex5bldLy5
         KZVKV998UczS5n2lGH1FNYTZskvABpZaLANvSGug=
Date:   Tue, 28 Dec 2021 08:48:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        stable@vger.kernel.org, herbert@gondor.apana.org.au,
        roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, kuba@kernel.org
Subject: Re: [PATCH net 2/2] net: bridge: mcast: add and enforce startup
 query interval minimum
Message-ID: <YcrBVOqvlscLiJNi@kroah.com>
References: <20211227172116.320768-1-nikolay@nvidia.com>
 <20211227172116.320768-3-nikolay@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227172116.320768-3-nikolay@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 07:21:16PM +0200, Nikolay Aleksandrov wrote:
> As reported[1] if startup query interval is set too low in combination with
> large number of startup queries and we have multiple bridges or even a
> single bridge with multiple querier vlans configured we can crash the
> machine. Add a 1 second minimum which must be enforced by overwriting the
> value if set lower (i.e. without returning an error) to avoid breaking
> user-space. If that happens a log message is emitted to let the admin know
> that the startup interval has been set to the minimum. It doesn't make
> sense to make the startup interval lower than the normal query interval
> so use the same value of 1 second. The issue has been present since these
> intervals could be user-controlled.
> 
> [1] https://lore.kernel.org/netdev/e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com/
> 
> Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/bridge/br_multicast.c    | 16 ++++++++++++++++
>  net/bridge/br_netlink.c      |  2 +-
>  net/bridge/br_private.h      |  3 +++
>  net/bridge/br_sysfs_br.c     |  2 +-
>  net/bridge/br_vlan_options.c |  2 +-
>  5 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 998da4a2d209..de2409889489 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -4538,6 +4538,22 @@ void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
>  	brmctx->multicast_query_interval = intvl_jiffies;
>  }
>  
> +void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
> +					  unsigned long val)
> +{
> +	unsigned long intvl_jiffies = clock_t_to_jiffies(val);
> +
> +	if (intvl_jiffies < BR_MULTICAST_STARTUP_QUERY_INTVL_MIN) {
> +		br_info(brmctx->br,
> +			"trying to set multicast startup query interval below minimum, setting to %lu (%ums)\n",
> +			jiffies_to_clock_t(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN),
> +			jiffies_to_msecs(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN));
> +		intvl_jiffies = BR_MULTICAST_STARTUP_QUERY_INTVL_MIN;
> +	}
> +
> +	brmctx->multicast_startup_query_interval = intvl_jiffies;
> +}
> +
>  /**
>   * br_multicast_list_adjacent - Returns snooped multicast addresses
>   * @dev:	The bridge port adjacent to which to retrieve addresses
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 701dd8b8455e..2ff83d84230d 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1369,7 +1369,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>  	if (data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) {
>  		u64 val = nla_get_u64(data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]);
>  
> -		br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
> +		br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
>  	}
>  
>  	if (data[IFLA_BR_MCAST_STATS_ENABLED]) {
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 4ed7f11042e8..2187a0c3fd22 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -29,6 +29,7 @@
>  
>  #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
>  #define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
> +#define BR_MULTICAST_STARTUP_QUERY_INTVL_MIN BR_MULTICAST_QUERY_INTVL_MIN
>  
>  #define BR_HWDOM_MAX BITS_PER_LONG
>  
> @@ -966,6 +967,8 @@ size_t br_multicast_querier_state_size(void);
>  size_t br_rports_size(const struct net_bridge_mcast *brmctx);
>  void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
>  				  unsigned long val);
> +void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
> +					  unsigned long val);
>  
>  static inline bool br_group_is_l2(const struct br_ip *group)
>  {
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index f5bd1114a434..7b0c19772111 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -706,7 +706,7 @@ static ssize_t multicast_startup_query_interval_show(
>  static int set_startup_query_interval(struct net_bridge *br, unsigned long val,
>  				      struct netlink_ext_ack *extack)
>  {
> -	br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
> +	br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
>  	return 0;
>  }
>  
> diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
> index bf1ac0874279..a6382973b3e7 100644
> --- a/net/bridge/br_vlan_options.c
> +++ b/net/bridge/br_vlan_options.c
> @@ -535,7 +535,7 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
>  		u64 val;
>  
>  		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]);
> -		v->br_mcast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
> +		br_multicast_set_startup_query_intvl(&v->br_mcast_ctx, val);
>  		*changed = true;
>  	}
>  	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]) {
> -- 
> 2.33.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
