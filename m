Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2D2AC742
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgKIVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:30:09 -0500
Received: from mg.ssi.bg ([178.16.128.9]:42344 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIVaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 16:30:08 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 884239745;
        Mon,  9 Nov 2020 23:30:04 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 3A723973F;
        Mon,  9 Nov 2020 23:30:02 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 17E043C09CF;
        Mon,  9 Nov 2020 23:29:58 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0A9LTt5d009651;
        Mon, 9 Nov 2020 23:29:56 +0200
Date:   Mon, 9 Nov 2020 23:29:55 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Cezar Sa Espinola <cezarsa@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH RFC v2] ipvs: add genetlink cmd to dump all services and
 destinations
In-Reply-To: <20201106154031.198437-1-cezarsa@gmail.com>
Message-ID: <d78c6889-721-f810-c7ad-d6d5e862c9e@ssi.bg>
References: <5b911129-e3de-f198-625a-8998cd6cdf0@ssi.bg> <20201106154031.198437-1-cezarsa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 6 Nov 2020, Cezar Sa Espinola wrote:

> A common operation for userspace applications managing ipvs is to dump all
> services and all destinations and then sort out what needs to be done.
> Previously this could only be accomplished by issuing 1 netlink
> IPVS_CMD_GET_SERVICE dump command followed by N IPVS_CMD_GET_DEST dump
> commands. For a dynamic system with a very large number of services this
> could be cause a performance impact.
> 
> This patch introduces a new way of dumping all services and destinations
> with the new IPVS_CMD_GET_SERVICE_DEST command. A dump call for this
> command will send the services as IPVS_CMD_NEW_SERVICE messages each
> containing a nested array of destinations with the new IPVS_SVC_ATTR_DESTS
> and IPVS_DESTS_ATTR_DEST attributes. Services may be repeated if their
> destinations do not fit in a single packet, user space should be
> responsible for merging the destinations from each repeated service.
> 
> It's also possible to dump a single service and its destinations by sending
> a IPVS_CMD_ATTR_SERVICE argument to the dump command.
> 
> Signed-off-by: Cezar Sa Espinola <cezarsa@gmail.com>
> ---
> Changes in v2:
> - Send destinations nested in a service.
> 
> This patch should be safer now as every packet starts with a service
> message. Also Julian's idea of adding more coordinates for tab and row
> showed a nice performance improvement. I think the same idea could also
> be applied to the existing ip_vs_genl_dump_services, I can send a patch
> for it later.
> 
> I also verified that each packet can fit somewhere around 50
> destinations on my system. So I was able to verify that it works as
> expected even when services are repeated including the additional
> destinations.
> 
> As before a patched ipvsadm for the message format in this commit is
> available in [1] and benchmarks in [2] were executed comparing runtime
> of "ipvsadm -Sn" using the new command vs the old command. Here are the
> benchmark summary:
> 
> tcp svcs  | fw svcs | dsts | run time
> --------- | ------- | ---- | --------
>      1000 |       0 |    4 | -62.12%
>      2000 |       0 |    2 | -72.97%
>      8000 |       0 |    2 | -73.47%
>     16000 |       0 |    1 | -81.79%
>       100 |       0 |  100 |  -9.09%
>      8000 |    8000 |    1 | -81.10%
> 
> [1] - https://github.com/cezarsa/ipvsadm/compare/master...dump-svc-ds
> [2] - https://github.com/cezarsa/ipvsadm-validate#benchmark-results
>  
>  include/uapi/linux/ip_vs.h     |  17 ++-
>  net/netfilter/ipvs/ip_vs_ctl.c | 188 ++++++++++++++++++++++++++++++---
>  2 files changed, 189 insertions(+), 16 deletions(-)
> 
> diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
> index 4102ddcb4e14..ce9bfa03b61b 100644
> --- a/include/uapi/linux/ip_vs.h
> +++ b/include/uapi/linux/ip_vs.h
> @@ -331,6 +331,8 @@ enum {
>  	IPVS_CMD_ZERO,			/* zero all counters and stats */
>  	IPVS_CMD_FLUSH,			/* flush services and dests */
>  
> +	IPVS_CMD_GET_SERVICE_DEST,	/* get service and destination info */
> +
>  	__IPVS_CMD_MAX,
>  };
>  
> @@ -374,15 +376,28 @@ enum {
>  
>  	IPVS_SVC_ATTR_STATS64,		/* nested attribute for service stats */
>  
> +	IPVS_SVC_ATTR_DESTS,		/* nested destinations */
> +
>  	__IPVS_SVC_ATTR_MAX,
>  };
>  
>  #define IPVS_SVC_ATTR_MAX (__IPVS_SVC_ATTR_MAX - 1)
>  
> +enum {
> +	IPVS_DESTS_ATTR_UNSPEC = 0,
> +
> +	IPVS_DESTS_ATTR_DEST,	/* nested destination */
> +
> +	__IPVS_DESTS_ATTR_MAX,
> +};
> +
> +#define IPVS_DESTS_ATTR_MAX (__IPVS_DESTS_ATTR_MAX - 1)
> +
>  /*
>   * Attributes used to describe a destination (real server)
>   *
> - * Used inside nested attribute IPVS_CMD_ATTR_DEST
> + * Used inside nested attribute IPVS_CMD_ATTR_DEST and
> + * IPVS_DESTS_ATTR_DEST
>   */
>  enum {
>  	IPVS_DEST_ATTR_UNSPEC = 0,
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index e279ded4e306..9f40627f74ef 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2981,6 +2981,7 @@ static const struct nla_policy ip_vs_svc_policy[IPVS_SVC_ATTR_MAX + 1] = {
>  	[IPVS_SVC_ATTR_TIMEOUT]		= { .type = NLA_U32 },
>  	[IPVS_SVC_ATTR_NETMASK]		= { .type = NLA_U32 },
>  	[IPVS_SVC_ATTR_STATS]		= { .type = NLA_NESTED },
> +	[IPVS_SVC_ATTR_DESTS]		= { .type = NLA_NESTED },
>  };
>  
>  /* Policy used for attributes in nested attribute IPVS_CMD_ATTR_DEST */
> @@ -3070,31 +3071,26 @@ static int ip_vs_genl_fill_stats64(struct sk_buff *skb, int container_type,
>  	return -EMSGSIZE;
>  }
>  
> -static int ip_vs_genl_fill_service(struct sk_buff *skb,
> -				   struct ip_vs_service *svc)
> +static int ip_vs_genl_put_service_attrs(struct sk_buff *skb,
> +					struct ip_vs_service *svc)
>  {
>  	struct ip_vs_scheduler *sched;
>  	struct ip_vs_pe *pe;
> -	struct nlattr *nl_service;
>  	struct ip_vs_flags flags = { .flags = svc->flags,
>  				     .mask = ~0 };
>  	struct ip_vs_kstats kstats;
>  	char *sched_name;
>  
> -	nl_service = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_SERVICE);
> -	if (!nl_service)
> -		return -EMSGSIZE;
> -
>  	if (nla_put_u16(skb, IPVS_SVC_ATTR_AF, svc->af))
> -		goto nla_put_failure;
> +		return -EMSGSIZE;
>  	if (svc->fwmark) {
>  		if (nla_put_u32(skb, IPVS_SVC_ATTR_FWMARK, svc->fwmark))
> -			goto nla_put_failure;
> +			return -EMSGSIZE;
>  	} else {
>  		if (nla_put_u16(skb, IPVS_SVC_ATTR_PROTOCOL, svc->protocol) ||
>  		    nla_put(skb, IPVS_SVC_ATTR_ADDR, sizeof(svc->addr), &svc->addr) ||
>  		    nla_put_be16(skb, IPVS_SVC_ATTR_PORT, svc->port))
> -			goto nla_put_failure;
> +			return -EMSGSIZE;
>  	}
>  
>  	sched = rcu_dereference_protected(svc->scheduler, 1);
> @@ -3105,11 +3101,26 @@ static int ip_vs_genl_fill_service(struct sk_buff *skb,
>  	    nla_put(skb, IPVS_SVC_ATTR_FLAGS, sizeof(flags), &flags) ||
>  	    nla_put_u32(skb, IPVS_SVC_ATTR_TIMEOUT, svc->timeout / HZ) ||
>  	    nla_put_be32(skb, IPVS_SVC_ATTR_NETMASK, svc->netmask))
> -		goto nla_put_failure;
> +		return -EMSGSIZE;
>  	ip_vs_copy_stats(&kstats, &svc->stats);
>  	if (ip_vs_genl_fill_stats(skb, IPVS_SVC_ATTR_STATS, &kstats))
> -		goto nla_put_failure;
> +		return -EMSGSIZE;
>  	if (ip_vs_genl_fill_stats64(skb, IPVS_SVC_ATTR_STATS64, &kstats))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +static int ip_vs_genl_fill_service(struct sk_buff *skb,
> +				   struct ip_vs_service *svc)
> +{
> +	struct nlattr *nl_service;
> +
> +	nl_service = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_SERVICE);
> +	if (!nl_service)
> +		return -EMSGSIZE;
> +
> +	if (ip_vs_genl_put_service_attrs(skb, svc))
>  		goto nla_put_failure;
>  
>  	nla_nest_end(skb, nl_service);
> @@ -3286,12 +3297,13 @@ static struct ip_vs_service *ip_vs_genl_find_service(struct netns_ipvs *ipvs,
>  	return ret ? ERR_PTR(ret) : svc;
>  }
>  
> -static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
> +static int ip_vs_genl_fill_dest(struct sk_buff *skb, int container_type,
> +				struct ip_vs_dest *dest)
>  {
>  	struct nlattr *nl_dest;
>  	struct ip_vs_kstats kstats;
>  
> -	nl_dest = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_DEST);
> +	nl_dest = nla_nest_start_noflag(skb, container_type);
>  	if (!nl_dest)
>  		return -EMSGSIZE;
>  
> @@ -3344,7 +3356,7 @@ static int ip_vs_genl_dump_dest(struct sk_buff *skb, struct ip_vs_dest *dest,
>  	if (!hdr)
>  		return -EMSGSIZE;
>  
> -	if (ip_vs_genl_fill_dest(skb, dest) < 0)
> +	if (ip_vs_genl_fill_dest(skb, IPVS_CMD_ATTR_DEST, dest) < 0)
>  		goto nla_put_failure;
>  
>  	genlmsg_end(skb, hdr);
> @@ -3396,6 +3408,146 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
>  	return skb->len;
>  }
>  
> +struct dump_services_dests_ctx {
> +	int	idx_svc;
> +	int	idx_dest;
> +	int	start_svc;
> +	int	start_dest;
> +};
> +
> +static int ip_vs_genl_dump_service_dests(struct sk_buff *skb,
> +					 struct netlink_callback *cb,
> +					 struct netns_ipvs *ipvs,
> +					 struct ip_vs_service *svc,
> +					 struct dump_services_dests_ctx *ctx)
> +{
> +	void *hdr;
> +	struct nlattr *nl_service;
> +	struct nlattr *nl_dests;
> +	struct ip_vs_dest *dest;
> +	int ret = 0;
> +
> +	if (svc->ipvs != ipvs)
> +		return 0;
> +
> +	if (++ctx->idx_svc <= ctx->start_svc)
> +		return 0;
> +
> +	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
> +			  cb->nlh->nlmsg_seq, &ip_vs_genl_family,
> +			  NLM_F_MULTI, IPVS_CMD_NEW_SERVICE);
> +	if (!hdr)
> +		goto out_err;
> +
> +	nl_service = nla_nest_start_noflag(skb, IPVS_CMD_ATTR_SERVICE);
> +	if (!nl_service)
> +		goto nla_put_failure;
> +
> +	if (ip_vs_genl_put_service_attrs(skb, svc))
> +		goto nla_nested_failure;
> +
> +	nl_dests = nla_nest_start_noflag(skb, IPVS_SVC_ATTR_DESTS);
> +	if (!nl_dests)
> +		goto nla_nested_failure;
> +
> +	list_for_each_entry(dest, &svc->destinations, n_list) {
> +		if (++ctx->idx_dest <= ctx->start_dest)
> +			continue;
> +		if (ip_vs_genl_fill_dest(skb, IPVS_DESTS_ATTR_DEST, dest) < 0) {
> +			ctx->idx_svc--;
> +			ctx->idx_dest--;
> +			ret = -EMSGSIZE;
> +			goto nla_nested_end;
> +		}
> +	}
> +	ctx->idx_dest = 0;
> +	ctx->start_dest = 0;
> +
> +nla_nested_end:
> +	nla_nest_end(skb, nl_dests);
> +	nla_nest_end(skb, nl_service);
> +	genlmsg_end(skb, hdr);
> +	return ret;
> +
> +nla_nested_failure:
> +	nla_nest_cancel(skb, nl_service);
> +
> +nla_put_failure:
> +	genlmsg_cancel(skb, hdr);
> +
> +out_err:
> +	ctx->idx_svc--;
> +	return -EMSGSIZE;
> +}
> +
> +static int ip_vs_genl_dump_services_destinations(struct sk_buff *skb,
> +						 struct netlink_callback *cb)
> +{
> +	struct dump_services_dests_ctx ctx = {
> +		.idx_svc = 0,
> +		.start_svc = cb->args[0],
> +		.idx_dest = 0,
> +		.start_dest = cb->args[1],
> +	};
> +	struct net *net = sock_net(skb->sk);
> +	struct netns_ipvs *ipvs = net_ipvs(net);
> +	struct ip_vs_service *svc = NULL;

	NULL not needed

> +	struct nlattr *attrs[IPVS_CMD_ATTR_MAX + 1];
> +	int tab = cb->args[2];
> +	int row = cb->args[3];
> +
> +	mutex_lock(&__ip_vs_mutex);
> +
> +	if (nlmsg_parse_deprecated(cb->nlh, GENL_HDRLEN, attrs,
> +				   IPVS_CMD_ATTR_MAX, ip_vs_cmd_policy,
> +				   cb->extack) == 0) {
> +		if (attrs[IPVS_CMD_ATTR_SERVICE]) {
> +			svc = ip_vs_genl_find_service(ipvs,
> +						      attrs[IPVS_CMD_ATTR_SERVICE]);
> +			if (IS_ERR_OR_NULL(svc))
> +				goto out_err;
> +			ip_vs_genl_dump_service_dests(skb, cb, ipvs, svc, &ctx);
> +			goto nla_put_failure;
> +		}
> +	}
> +

	To make it more readable and to avoid lookup when at EOF
we can start with the tab checks:

	if (tab >= 2)
		goto nla_put_failure;	# or done
	if (tab >= 1)
		goto tab_1;

	for (; row < IP_VS_SVC_TAB_SIZE; row++) {

> +	for (; tab == 0 && row < IP_VS_SVC_TAB_SIZE; row++) {
> +		hlist_for_each_entry(svc, &ip_vs_svc_table[row], s_list) {
> +			if (ip_vs_genl_dump_service_dests(skb, cb, ipvs,
> +							  svc, &ctx))
> +				goto nla_put_failure;
> +		}
> +		ctx.idx_svc = 0;
> +		ctx.start_svc = 0;

	If we were at the middle of dests for the previous packet
but now the svc and its dests are deleted, we have to reset the
dest ptr too, otherwise we will skip dests in next row:

		ctx->idx_dest = 0;
		ctx->start_dest = 0;

	But any kind of modifications will show wrong results,
so it does not matter much.

> +	}
> +
> +	if (tab == 0) {
> +		row = 0;
> +		tab++;
> +	}
> +

	row = 0;
	tab++;

tab_1:

> +	for (; row < IP_VS_SVC_TAB_SIZE; row++) {
> +		hlist_for_each_entry(svc, &ip_vs_svc_fwm_table[row], f_list) {
> +			if (ip_vs_genl_dump_service_dests(skb, cb, ipvs,
> +							  svc, &ctx))
> +				goto nla_put_failure;
> +		}
> +		ctx.idx_svc = 0;
> +		ctx.start_svc = 0;

		ctx->idx_dest = 0;
		ctx->start_dest = 0;

> +	}

	row = 0;	# Not needed
	tab++;		$ tab = 2 to indicate EOF

> +
> +nla_put_failure:
> +	cb->args[0] = ctx.idx_svc;
> +	cb->args[1] = ctx.idx_dest;
> +	cb->args[2] = tab;
> +	cb->args[3] = row;
> +
> +out_err:
> +	mutex_unlock(&__ip_vs_mutex);
> +
> +	return skb->len;
> +}
> +
>  static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
>  				 struct nlattr *nla, bool full_entry)
>  {
> @@ -3991,6 +4143,12 @@ static const struct genl_small_ops ip_vs_genl_ops[] = {
>  		.flags	= GENL_ADMIN_PERM,
>  		.doit	= ip_vs_genl_set_cmd,
>  	},
> +	{
> +		.cmd	= IPVS_CMD_GET_SERVICE_DEST,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.flags	= GENL_ADMIN_PERM,
> +		.dumpit	= ip_vs_genl_dump_services_destinations,
> +	},
>  };
>  
>  static struct genl_family ip_vs_genl_family __ro_after_init = {
> -- 
> 2.25.1

Regards

--
Julian Anastasov <ja@ssi.bg>

