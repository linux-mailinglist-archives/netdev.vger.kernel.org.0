Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9426A394E34
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhE2VHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhE2VHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 122D861131;
        Sat, 29 May 2021 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622322356;
        bh=N2Ppad4bXGRKCG3oMzAxAnN1H1ox+NwgaSvQP38wN8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZRm3denOAlp8QqsWZM7odcvGF4OoHIF1OgnNR1t1o4K+9XjXwioCiEsrUVZIPbgSs
         ECrQaPLz1yQ/3S0xMildCQa4whOtj9NudPHLuYE9kebTOvpL4pK7WmnTWONYzoOo1J
         pp1F+Xn1rmFpRw5sKaoHokUScoyyNN87JT/Hx5spOnZpC9viC+7x7hZKUG2hFqOkXX
         OseiR2YSQPTy8PW110Inp9SN1JLq3fSlTjNPLZrDZOzRuNB7Ki0usuQ1dU82OUNfgi
         Q4ITiVhgwyQUGS0YP5M1blR2hfkscpD2USnRdcVFxCkGdQe6BU5HwHj8Ac4DPd1yLy
         KZAKIgLs7DR5A==
Date:   Sat, 29 May 2021 14:05:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527151652.16074-3-justin.iurman@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-3-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:16:49 +0200 Justin Iurman wrote:
> Implement support for processing the IOAM Pre-allocated Trace with IPv6,
> see [1] and [2]. Introduce a new IPv6 Hop-by-Hop TLV option, see IANA [3].
> 
> A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
> headers. Default is ignore (= disabled). Another per-interface sysctl
> ioam6_id is provided to define the IOAM (unique) identifier of the
> interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
> define the IOAM (unique) identifier of the node. Default is 0.

Last two sentences are repeated.

Is 0 a valid interface ID? If not why not use id != 0 instead of
having a separate enabled field?

> Documentation is provided at the end of this patchset.
> 
> Two relativistic hash tables: one for IOAM namespaces, the other for
> IOAM schemas. A namespace can only have a single active schema and a
> schema can only be attached to a single namespace (1:1 relationship).
> 
>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
>   [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

> +extern struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
> +extern void ioam6_fill_trace_data(struct sk_buff *skb,
> +				  struct ioam6_namespace *ns,
> +				  struct ioam6_trace_hdr *trace);
> +
> +extern int ioam6_init(void);
> +extern void ioam6_exit(void);

no need for externs in new headers

> +#endif /* _NET_IOAM6_H */
> diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
> index bde0b7adb4a3..a0d61a8fcfe1 100644
> --- a/include/net/netns/ipv6.h
> +++ b/include/net/netns/ipv6.h
> @@ -53,6 +53,7 @@ struct netns_sysctl_ipv6 {
>  	int seg6_flowlabel;
>  	bool skip_notify_on_dev_down;
>  	u8 fib_notify_on_flag_change;
> +	unsigned int ioam6_id;

Perhaps move it after seg6_flowlabel, better chance next person adding
a 1 byte type will not create a hole.

>  };
>  
>  struct netns_ipv6 {

> @@ -6932,6 +6938,20 @@ static const struct ctl_table addrconf_sysctl[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "ioam6_enabled",
> +		.data		= &ipv6_devconf.ioam6_enabled,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,

This one should be constrained to 0/1, right?
proc_dou8vec_minmax? no need for full u32.

> +	},
> +	{
> +		.procname	= "ioam6_id",
> +		.data		= &ipv6_devconf.ioam6_id,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,

uint?

> +	},
>  	{
>  		/* sentinel */
>  	}
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 2389ff702f51..aec9664ec909 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -62,6 +62,7 @@
>  #include <net/rpl.h>
>  #include <net/compat.h>
>  #include <net/xfrm.h>
> +#include <net/ioam6.h>
>  
>  #include <linux/uaccess.h>
>  #include <linux/mroute6.h>
> @@ -1191,6 +1192,10 @@ static int __init inet6_init(void)
>  	if (err)
>  		goto rpl_fail;
>  
> +	err = ioam6_init();
> +	if (err)
> +		goto ioam6_fail;
> +
>  	err = igmp6_late_init();
>  	if (err)
>  		goto igmp6_late_err;
> @@ -1214,6 +1219,8 @@ static int __init inet6_init(void)
>  #endif
>  igmp6_late_err:
>  	rpl_exit();
> +ioam6_fail:
> +	ioam6_exit();
>  rpl_fail:

This is out of order, ioam6_fail should now jump to rpl_exit()
and igmp6_late_err should point at ioam6_exit().

>  	seg6_exit();
>  seg6_fail:

> @@ -929,6 +932,50 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
>  	return false;
>  }
>  
> +/* IOAM */
> +
> +static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
> +{
> +	struct ioam6_trace_hdr *trace;
> +	struct ioam6_namespace *ns;
> +	struct ioam6_hdr *hdr;
> +
> +	/* Must be 4n-aligned */
> +	if (optoff & 3)
> +		goto drop;
> +
> +	/* Ignore if IOAM is not enabled on ingress */
> +	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
> +		goto ignore;
> +
> +	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
> +
> +	switch (hdr->type) {
> +	case IOAM6_TYPE_PREALLOC:
> +		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
> +		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);

Shouldn't there be validation that the header is not truncated or
malformed before we start poking into the fields?

> +		/* Ignore if the IOAM namespace is unknown */
> +		if (!ns)
> +			goto ignore;
> +
> +		if (!skb_valid_dst(skb))
> +			ip6_route_input(skb);
> +
> +		ioam6_fill_trace_data(skb, ns, trace);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +ignore:
> +	return true;
> +
> +drop:
> +	kfree_skb(skb);
> +	return false;
> +}
> +

> +void ioam6_fill_trace_data(struct sk_buff *skb,
> +			   struct ioam6_namespace *ns,
> +			   struct ioam6_trace_hdr *trace)
> +{
> +	u8 sclen = 0;
> +
> +	/* Skip if Overflow flag is set OR
> +	 * if an unknown type (bit 12-21) is set
> +	 */
> +	if (trace->overflow ||
> +	    (trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
> +	     trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
> +	     trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
> +	     trace->type.bit21)) {
> +		return;
> +	}

braces unnecessary

> +
> +	/* NodeLen does not include Opaque State Snapshot length. We need to
> +	 * take it into account if the corresponding bit is set (bit 22) and
> +	 * if the current IOAM namespace has an active schema attached to it
> +	 */
> +	if (trace->type.bit22) {
> +		sclen = sizeof_field(struct ioam6_schema, hdr) / 4;
> +
> +		if (ns->schema)
> +			sclen += ns->schema->len / 4;
> +	}
> +
> +	/* If there is no space remaining, we set the Overflow flag and we
> +	 * skip without filling the trace
> +	 */
> +	if (!trace->remlen || trace->remlen < (trace->nodelen + sclen)) {

brackets around sum unnecessary

> +		trace->overflow = 1;
> +		return;
> +	}
> +
> +	__ioam6_fill_trace_data(skb, ns, trace, sclen);
> +	trace->remlen -= trace->nodelen + sclen;
> +}

> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
> index d7cf26f730d7..b97aad7b6aca 100644
> --- a/net/ipv6/sysctl_net_ipv6.c
> +++ b/net/ipv6/sysctl_net_ipv6.c
> @@ -196,6 +196,13 @@ static struct ctl_table ipv6_table_template[] = {
>  		.extra1         = SYSCTL_ZERO,
>  		.extra2         = &two,
>  	},
> +	{
> +		.procname	= "ioam6_id",
> +		.data		= &init_net.ipv6.sysctl.ioam6_id,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec

uint?

> +	},
>  	{ }
>  };
>  

