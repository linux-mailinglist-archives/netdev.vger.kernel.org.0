Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A2C67D38D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjAZRxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAZRxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:53:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28FCEB5C;
        Thu, 26 Jan 2023 09:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65E4BB81EB7;
        Thu, 26 Jan 2023 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD70C433D2;
        Thu, 26 Jan 2023 17:53:46 +0000 (UTC)
Date:   Thu, 26 Jan 2023 12:53:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/16] net: bridge: Add a tracepoint for MDB
 overflows
Message-ID: <20230126125344.1b7b34e2@gandalf.local.home>
In-Reply-To: <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
        <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 18:01:14 +0100
Petr Machata <petrm@nvidia.com> wrote:

> The following patch will add two more maximum MDB allowances to the global
> one, mcast_hash_max, that exists today. In all these cases, attempts to add
> MDB entries above the configured maximums through netlink, fail noisily and
> obviously. Such visibility is missing when adding entries through the
> control plane traffic, by IGMP or MLD packets.
> 
> To improve visibility in those cases, add a trace point that reports the
> violation, including the relevant netdevice (be it a slave or the bridge
> itself), and the MDB entry parameters:
> 
> 	# perf record -e bridge:br_mdb_full &
> 	# [...]
> 	# perf script | cut -d: -f4-
> 	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 0
> 	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 0
> 	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 10
> 	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 10
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: linux-trace-kernel@vger.kernel.org
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/trace/events/bridge.h | 67 +++++++++++++++++++++++++++++++++++
>  net/core/net-traces.c         |  1 +
>  2 files changed, 68 insertions(+)
> 
> diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
> index 6b200059c2c5..00d5e2dcb3ad 100644
> --- a/include/trace/events/bridge.h
> +++ b/include/trace/events/bridge.h
> @@ -122,6 +122,73 @@ TRACE_EVENT(br_fdb_update,
>  		  __entry->flags)
>  );
>  
> +TRACE_EVENT(br_mdb_full,
> +
> +	TP_PROTO(const struct net_device *dev,
> +		 const struct br_ip *group),
> +
> +	TP_ARGS(dev, group),
> +
> +	TP_STRUCT__entry(
> +		__string(dev, dev->name)
> +		__field(int, af)
> +		__field(u16, vid)
> +		__array(__u8, src4, 4)
> +		__array(__u8, src6, 16)
> +		__array(__u8, grp4, 4)
> +		__array(__u8, grp6, 16)
> +		__array(__u8, grpmac, ETH_ALEN) /* For af == 0. */

Instead of wasting ring buffer space, why not just have:

		__array(__u8, src, 16)
		__array(__u8, grp, 16)


> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev, dev->name);
> +		__entry->vid = group->vid;
> +
> +		if (!group->proto) {
> +			__entry->af = 0;
> +
> +			memset(__entry->src4, 0, sizeof(__entry->src4));
> +			memset(__entry->src6, 0, sizeof(__entry->src6));
> +			memset(__entry->grp4, 0, sizeof(__entry->grp4));
> +			memset(__entry->grp6, 0, sizeof(__entry->grp6));
> +			memcpy(__entry->grpmac, group->dst.mac_addr, ETH_ALEN);
> +		} else if (group->proto == htons(ETH_P_IP)) {
> +			__be32 *p32;
> +
> +			__entry->af = AF_INET;
> +
> +			p32 = (__be32 *) __entry->src4;
> +			*p32 = group->src.ip4;
> +
> +			p32 = (__be32 *) __entry->grp4;
> +			*p32 = group->dst.ip4;

			struct in6_addr *in6;

			in6 = (struct in6_addr *)__entry->src;
			ipv6_addr_set_v4mapped(group->src.ip4, in6);

			in6 = (struct in6_addr *)__entry->grp;
			ipv6_addr_set_v4mapped(group->grp.ip4, in6);

> +
> +			memset(__entry->src6, 0, sizeof(__entry->src6));
> +			memset(__entry->grp6, 0, sizeof(__entry->grp6));
> +			memset(__entry->grpmac, 0, ETH_ALEN);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		} else {
> +			struct in6_addr *in6;
> +
> +			__entry->af = AF_INET6;
> +
> +			in6 = (struct in6_addr *)__entry->src6;
> +			*in6 = group->src.ip6;
> +
> +			in6 = (struct in6_addr *)__entry->grp6;
> +			*in6 = group->dst.ip6;
> +
> +			memset(__entry->src4, 0, sizeof(__entry->src4));
> +			memset(__entry->grp4, 0, sizeof(__entry->grp4));
> +			memset(__entry->grpmac, 0, ETH_ALEN);
> +#endif
> +		}
> +	),
> +
> +	TP_printk("dev %s af %u src %pI4/%pI6c grp %pI4/%pI6c/%pM vid %u",
> +		  __get_str(dev), __entry->af, __entry->src4, __entry->src6,
> +		  __entry->grp4, __entry->grp6, __entry->grpmac, __entry->vid)

And just have: 

	TP_printk("dev %s af %u src %pI6c grp %pI6c/%pM vid %u",
		  __get_str(dev), __entry->af, __entry->src, __entry->grp,
		  __entry->grpmac, __entry->vid)

As the %pI6c should detect that it's a ipv4 address and show that.

-- Steve


> +);
>  
>  #endif /* _TRACE_BRIDGE_H */
>  
> diff --git a/net/core/net-traces.c b/net/core/net-traces.c
> index ee7006bbe49b..805b7385dd8d 100644
> --- a/net/core/net-traces.c
> +++ b/net/core/net-traces.c
> @@ -41,6 +41,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_external_learn_add);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(fdb_delete);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_update);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(br_mdb_full);
>  #endif
>  
>  #if IS_ENABLED(CONFIG_PAGE_POOL)

