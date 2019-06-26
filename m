Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9CD57091
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfFZS3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:29:09 -0400
Received: from mail.us.es ([193.147.175.20]:43700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbfFZS3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 14:29:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0491CDA716
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 20:29:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E55AADA3F4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 20:29:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DAF0EDA7B6; Wed, 26 Jun 2019 20:29:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A89DADA801;
        Wed, 26 Jun 2019 20:29:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 20:29:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 59DF64265A2F;
        Wed, 26 Jun 2019 20:29:03 +0200 (CEST)
Date:   Wed, 26 Jun 2019 20:29:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3 nf-next] netfilter:nf_flow_table: Refactor
 flow_offload_tuple to support more offload method
Message-ID: <20190626182902.g62twklkhxvdmvnn@salvia>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 06:32:26PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>

Fix email subject, to:

netfilter: nf_flow_table: Refactor flow_offload_tuple to destination

> Add struct flow_offload_dst to support more offload method to replace
> dst_cache which only work for route offload.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/netfilter/nf_flow_table.h | 12 ++++++++++--
>  net/netfilter/nf_flow_table_core.c    | 22 +++++++++++-----------
>  net/netfilter/nf_flow_table_ip.c      |  4 ++--
>  net/netfilter/nft_flow_offload.c      | 10 +++++-----
>  4 files changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index d8c1879..968be64 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -33,6 +33,10 @@ enum flow_offload_tuple_dir {
>  	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
>  };
>  
> +struct flow_offload_dst {
> +	struct dst_entry		*dst_cache;
> +};
> +
>  struct flow_offload_tuple {
>  	union {
>  		struct in_addr		src_v4;
> @@ -55,7 +59,7 @@ struct flow_offload_tuple {
>  
>  	u16				mtu;
>  
> -	struct dst_entry		*dst_cache;
> +	struct flow_offload_dst		dst;
>  };
>  
>  struct flow_offload_tuple_rhash {
> @@ -85,8 +89,12 @@ struct nf_flow_route {
>  	} tuple[FLOW_OFFLOAD_DIR_MAX];
>  };
>  
> +struct nf_flow_data {

Please, call this:

struct nf_flow_dst

instead.

> +	struct nf_flow_route route;
> +};
> +
>  struct flow_offload *flow_offload_alloc(struct nf_conn *ct,
> -					struct nf_flow_route *route);
> +					struct nf_flow_data *data);
>  void flow_offload_free(struct flow_offload *flow);
>  
>  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index e3d7972..125ce1c 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -24,13 +24,13 @@ struct flow_offload_entry {
>  
>  static void
>  flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
> -		      struct nf_flow_route *route,
> +		      struct nf_flow_data *data,
>  		      enum flow_offload_tuple_dir dir)
>  {
>  	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
>  	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
> -	struct dst_entry *other_dst = route->tuple[!dir].dst;
> -	struct dst_entry *dst = route->tuple[dir].dst;
> +	struct dst_entry *other_dst = date->route.tuple[!dir].dst;
> +	struct dst_entry *dst = data->route.tuple[dir].dst;
>  
>  	ft->dir = dir;
>  
> @@ -57,7 +57,7 @@ struct flow_offload_entry {
>  }
>  
>  struct flow_offload *
> -flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
> +flow_offload_alloc(struct nf_conn *ct, struct nf_flow_data *data)
>  {
>  	struct flow_offload_entry *entry;
>  	struct flow_offload *flow;
> @@ -72,16 +72,16 @@ struct flow_offload *
>  
>  	flow = &entry->flow;
>  
> -	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
> +	if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
>  		goto err_dst_cache_original;
>  
> -	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
> +	if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
>  		goto err_dst_cache_reply;
>  
>  	entry->ct = ct;
>  
> -	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
> -	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
> +	flow_offload_fill_dir(flow, ct, data, FLOW_OFFLOAD_DIR_ORIGINAL);
> +	flow_offload_fill_dir(flow, ct, data, FLOW_OFFLOAD_DIR_REPLY);
>  
>  	if (ct->status & IPS_SRC_NAT)
>  		flow->flags |= FLOW_OFFLOAD_SNAT;
> @@ -91,7 +91,7 @@ struct flow_offload *
>  	return flow;
>  
>  err_dst_cache_reply:
> -	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
> +	dst_release(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
>  err_dst_cache_original:
>  	kfree(entry);
>  err_ct_refcnt:
> @@ -139,8 +139,8 @@ void flow_offload_free(struct flow_offload *flow)
>  {
>  	struct flow_offload_entry *e;
>  
> -	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
> -	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
> +	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
> +	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
>  	e = container_of(flow, struct flow_offload_entry, flow);
>  	if (flow->flags & FLOW_OFFLOAD_DYING)
>  		nf_ct_delete(e->ct, 0, 0);
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 2413174..0016bb8 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -241,7 +241,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
>  
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> -	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
> +	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
>  	outdev = rt->dst.dev;
>  
>  	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
> @@ -457,7 +457,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>  
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> -	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
> +	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst.dst_cache;
>  	outdev = rt->dst.dev;
>  
>  	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index aa5f571..cdb7c46 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -73,7 +73,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	struct nft_flow_offload *priv = nft_expr_priv(expr);
>  	struct nf_flowtable *flowtable = &priv->flowtable->data;
>  	enum ip_conntrack_info ctinfo;
> -	struct nf_flow_route route;
> +	struct nf_flow_data data;

Please, reverse xmas tree for variable definition, from longest line
to shortest one.

>  	struct flow_offload *flow;
>  	enum ip_conntrack_dir dir;
>  	bool is_tcp = false;
> @@ -108,10 +108,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  		goto out;
>  
>  	dir = CTINFO2DIR(ctinfo);
> -	if (nft_flow_route(pkt, ct, &route, dir) < 0)
> +	if (nft_flow_route(pkt, ct, &data.route, dir) < 0)
>  		goto err_flow_route;
>  
> -	flow = flow_offload_alloc(ct, &route);
> +	flow = flow_offload_alloc(ct, &data);
>  	if (!flow)
>  		goto err_flow_alloc;
>  
> @@ -124,13 +124,13 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	if (ret < 0)
>  		goto err_flow_add;
>  
> -	dst_release(route.tuple[!dir].dst);
> +	dst_release(data.route.tuple[!dir].dst);
>  	return;
>  
>  err_flow_add:
>  	flow_offload_free(flow);
>  err_flow_alloc:
> -	dst_release(route.tuple[!dir].dst);
> +	dst_release(data.route.tuple[!dir].dst);
>  err_flow_route:
>  	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
>  out:
> -- 
> 1.8.3.1
> 
