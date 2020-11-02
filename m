Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB552A35A1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKBU6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:58:08 -0500
Received: from mg.ssi.bg ([178.16.128.9]:34610 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKBU41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 15:56:27 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 986C4226C7;
        Mon,  2 Nov 2020 22:56:23 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id EEE4C226C6;
        Mon,  2 Nov 2020 22:56:21 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C774E3C09BA;
        Mon,  2 Nov 2020 22:56:18 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0A2KuEs6007809;
        Mon, 2 Nov 2020 22:56:16 +0200
Date:   Mon, 2 Nov 2020 22:56:14 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Cezar Sa Espinola <cezarsa@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH RFC] ipvs: add genetlink cmd to dump all services and
 destinations
In-Reply-To: <20201030202727.1053534-1-cezarsa@gmail.com>
Message-ID: <9140ef65-f76d-4bf1-b211-e88c101a5461@ssi.bg>
References: <20201030202727.1053534-1-cezarsa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 30 Oct 2020, Cezar Sa Espinola wrote:

> A common operation for userspace applications managing ipvs is to dump
> all services and all destinations and then sort out what needs to be
> done. Previously this could only be accomplished by issuing 1 netlink
> IPVS_CMD_GET_SERVICE dump command followed by N IPVS_CMD_GET_DEST dump
> commands. For a dynamic system with a very large number of services this
> could be cause a performance impact.
> 
> This patch introduces a new way of dumping all services and destinations
> with the new IPVS_CMD_GET_SERVICE_DEST command. A dump call for this
> command will send the services as IPVS_CMD_NEW_SERVICE messages
> imediatelly followed by its destinations as multiple IPVS_CMD_NEW_DEST
> messages. It's also possible to dump a single service and its
> destinations by sending a IPVS_CMD_ATTR_SERVICE argument to the dump
> command.
> 
> Signed-off-by: Cezar Sa Espinola <cezarsa@gmail.com>
> ---
> 
> To ensure that this patch improves performance I decided to also patch
> ipvsadm in order to run some benchmarks comparing 'ipvsadm -Sn' with the
> unpatched version. The ipvsadm patch is available on github in [1] for
> now but I intend to submit it if this RFC goes forward.
> 
> The benchmarks look nice and detailed results and some scripts to allow
> reproducing then are available in another github repository [2]. The
> summary of the benchmarks is:
> 
> svcs  | dsts | run time compared to unpatched
> ----- | ---- | ------------------------------
>  1000 |    4 | -60.63%
>  2000 |    2 | -71.10%
>  8000 |    2 | -52.83%
> 16000 |    1 | -54.13%
>   100 |  100 |  -4.76%
> 
> [1] - https://github.com/cezarsa/ipvsadm/compare/master...dump-svc-ds
> [2] - https://github.com/cezarsa/ipvsadm-validate#benchmark-results
> 
>  include/uapi/linux/ip_vs.h     |   2 +
>  net/netfilter/ipvs/ip_vs_ctl.c | 109 +++++++++++++++++++++++++++++++++
>  2 files changed, 111 insertions(+)
> 
> diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
> index 4102ddcb4e14..353548cb7b81 100644
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
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index e279ded4e306..09a7dd823dc0 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -3396,6 +3396,109 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
>  	return skb->len;
>  }
>  
> +struct dump_services_dests_ctx {
> +	struct ip_vs_service	*last_svc;
> +	int			idx_svc;
> +	int			idx_dest;
> +	int			start_svc;
> +	int			start_dest;
> +};
> +
> +static int ip_vs_genl_dump_service_destinations(struct sk_buff *skb,
> +						struct netlink_callback *cb,
> +						struct ip_vs_service *svc,
> +						struct dump_services_dests_ctx *ctx)
> +{
> +	struct ip_vs_dest *dest;
> +
> +	if (++ctx->idx_svc < ctx->start_svc)
> +		return 0;
> +
> +	if (ctx->idx_svc == ctx->start_svc && ctx->last_svc != svc)
> +		return 0;
> +
> +	if (ctx->idx_svc > ctx->start_svc) {
> +		if (ip_vs_genl_dump_service(skb, svc, cb) < 0) {
> +			ctx->idx_svc--;
> +			return -EMSGSIZE;
> +		}
> +		ctx->last_svc = svc;
> +		ctx->start_dest = 0;
> +	}
> +
> +	ctx->idx_dest = 0;
> +	list_for_each_entry(dest, &svc->destinations, n_list) {
> +		if (++ctx->idx_dest <= ctx->start_dest)
> +			continue;
> +		if (ip_vs_genl_dump_dest(skb, dest, cb) < 0) {
> +			ctx->idx_dest--;

	At this point idx_svc is incremented and we
stop at the middle of dest list, so we need ctx->idx_svc-- too.

	And now what happens if all dests can not fit in a packet?
We should start next packet with the same svc? And then
user space should merge the dests when multiple packets
start with same service?

	The main points are:

- the virtual services are in hash table, their order is
not important, user space can sort them

- order of dests in a service is important for the schedulers

- every packet should contain info for svc, so that we can
properly add dests to the right svc

> +			return -EMSGSIZE;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ip_vs_genl_dump_services_destinations(struct sk_buff *skb,
> +						 struct netlink_callback *cb)
> +{
> +	/* Besides usual index based counters, saving a pointer to the last
> +	 * dumped service is useful to ensure we only dump destinations that
> +	 * belong to it, even when services are removed while the dump is still
> +	 * running causing indexes to shift.
> +	 */
> +	struct dump_services_dests_ctx ctx = {
> +		.idx_svc = 0,
> +		.idx_dest = 0,
> +		.start_svc = cb->args[0],
> +		.start_dest = cb->args[1],
> +		.last_svc = (struct ip_vs_service *)(cb->args[2]),
> +	};
> +	struct net *net = sock_net(skb->sk);
> +	struct netns_ipvs *ipvs = net_ipvs(net);
> +	struct ip_vs_service *svc = NULL;
> +	struct nlattr *attrs[IPVS_CMD_ATTR_MAX + 1];
> +	int i;
> +
> +	mutex_lock(&__ip_vs_mutex);
> +
> +	if (nlmsg_parse_deprecated(cb->nlh, GENL_HDRLEN, attrs, IPVS_CMD_ATTR_MAX,
> +				   ip_vs_cmd_policy, cb->extack) == 0) {
> +		svc = ip_vs_genl_find_service(ipvs, attrs[IPVS_CMD_ATTR_SERVICE]);
> +
> +		if (!IS_ERR_OR_NULL(svc)) {
> +			ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx);
> +			goto nla_put_failure;
> +		}
> +	}
> +
> +	for (i = 0; i < IP_VS_SVC_TAB_SIZE; i++) {
> +		hlist_for_each_entry(svc, &ip_vs_svc_table[i], s_list) {
> +			if (svc->ipvs != ipvs)
> +				continue;
> +			if (ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx) < 0)
> +				goto nla_put_failure;
> +		}
> +	}
> +
> +	for (i = 0; i < IP_VS_SVC_TAB_SIZE; i++) {
> +		hlist_for_each_entry(svc, &ip_vs_svc_fwm_table[i], s_list) {
> +			if (svc->ipvs != ipvs)
> +				continue;
> +			if (ip_vs_genl_dump_service_destinations(skb, cb, svc, &ctx) < 0)
> +				goto nla_put_failure;
> +		}
> +	}
> +
> +nla_put_failure:
> +	mutex_unlock(&__ip_vs_mutex);
> +	cb->args[0] = ctx.idx_svc;
> +	cb->args[1] = ctx.idx_dest;
> +	cb->args[2] = (long)ctx.last_svc;

	last_svc is used out of __ip_vs_mutex region,
so it is not safe. We can get a reference count but this
is bad if user space blocks.

	But even if we use just indexes it should be ok.
If multiple agents are used in parallel it is not our
problem. What can happen is that we can send duplicates
or to skip entries (both svcs and dests). It is impossible
to keep any kind of references to current entries or even
keys to lookup them if another agent can remove them.

> +
> +	return skb->len;
> +}
> +
>  static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
>  				 struct nlattr *nla, bool full_entry)
>  {
> @@ -3991,6 +4094,12 @@ static const struct genl_small_ops ip_vs_genl_ops[] = {
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

Regards

--
Julian Anastasov <ja@ssi.bg>

