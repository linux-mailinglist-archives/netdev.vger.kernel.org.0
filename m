Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4570A2574B9
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 09:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgHaHxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 03:53:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728115AbgHaHvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 03:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598860267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYGPXCohwBE6lKDzDtC+rI4XDAHKSdS0UyWToHdUIRA=;
        b=al7zBL6sj02XKuKxd49DsFTC2053logOjII449vmrENgi5drjOJDD8oCDGCsEomu87Y3sL
        Hd8Hes8+pCZp6ZgmjMAcKDp+HlWCIEw7Zy9DQMnQxta5u4/ewYEZJROcm3pQv6rur0wVCV
        cPfm1gyXeTaP9E9wrlD0hChJzPyq7CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-9GO8QyI4NMKhWv7jH_VV_w-1; Mon, 31 Aug 2020 03:51:05 -0400
X-MC-Unique: 9GO8QyI4NMKhWv7jH_VV_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A93D4425CE;
        Mon, 31 Aug 2020 07:51:03 +0000 (UTC)
Received: from [10.36.112.162] (ovpn-112-162.ams2.redhat.com [10.36.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8108E5C225;
        Mon, 31 Aug 2020 07:51:01 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     trix@redhat.com
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: openvswitch: pass NULL for unused parameters
Date:   Mon, 31 Aug 2020 09:50:59 +0200
Message-ID: <398B5AF9-48CC-485C-A920-701649844719@redhat.com>
In-Reply-To: <20200830212630.32241-1-trix@redhat.com>
References: <20200830212630.32241-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Aug 2020, at 23:26, trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
>
> clang static analysis flags these problems
>
> flow_table.c:713:2: warning: The expression is an uninitialized
>   value. The computed value will also be garbage
>         (*n_mask_hit)++;
>         ^~~~~~~~~~~~~~~
> flow_table.c:748:5: warning: The expression is an uninitialized
>   value. The computed value will also be garbage
>                                 (*n_cache_hit)++;
>                                 ^~~~~~~~~~~~~~~~
>
> These are not problems because neither parameter is used
> by the calling function.
>
> Looking at all of the calling functions, there are many
> cases where the results are unused.  Passing unused
> parameters is a waste.
>
> In the case where the output mask index parameter of flow_lookup()
> is not used by the caller, it is always has a value of 0.
>
> To avoid passing unused parameters, rework the
> masked_flow_lookup() and flow_lookup() routines to check
> for NULL parameters and change the unused parameters to NULL.
>
> For the mask index parameter, use a local pointer to a value of
> 0 if user passed in NULL.


Some of this code is fast path, and some of it is not. So maybe the 
original author did this to avoid the null checks?

Can you do some performance runs and see if it impact the performance in 
a negative way?

> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
> v2
> - fix spelling
> - add mask index to NULL parameters
> ---
> net/openvswitch/flow_table.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c 
> b/net/openvswitch/flow_table.c
> index e2235849a57e..eac25596e4f4 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -710,7 +710,8 @@ static struct sw_flow *masked_flow_lookup(struct 
> table_instance *ti,
>  	ovs_flow_mask_key(&masked_key, unmasked, false, mask);
>  	hash = flow_hash(&masked_key, &mask->range);
>  	head = find_bucket(ti, hash);
> -	(*n_mask_hit)++;
> +	if (n_mask_hit)
> +		(*n_mask_hit)++;
>
>  	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
>  				lockdep_ovsl_is_held()) {
> @@ -730,12 +731,17 @@ static struct sw_flow *flow_lookup(struct 
> flow_table *tbl,
>  				   const struct sw_flow_key *key,
>  				   u32 *n_mask_hit,
>  				   u32 *n_cache_hit,
> -				   u32 *index)
> +				   u32 *in_index)
>  {
>  	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
>  	struct sw_flow *flow;
>  	struct sw_flow_mask *mask;
>  	int i;
> +	u32 idx = 0;
> +	u32 *index = &idx;
> +
> +	if (in_index)
> +		index = in_index;
>
>  	if (likely(*index < ma->max)) {
>  		mask = rcu_dereference_ovsl(ma->masks[*index]);
> @@ -745,7 +751,8 @@ static struct sw_flow *flow_lookup(struct 
> flow_table *tbl,
>  				u64_stats_update_begin(&ma->syncp);
>  				usage_counters[*index]++;
>  				u64_stats_update_end(&ma->syncp);
> -				(*n_cache_hit)++;
> +				if (n_cache_hit)
> +					(*n_cache_hit)++;
>  				return flow;
>  			}
>  		}
> @@ -796,13 +803,9 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct 
> flow_table *tbl,
>
>  	*n_mask_hit = 0;
>  	*n_cache_hit = 0;
> -	if (unlikely(!skb_hash || mc->cache_size == 0)) {
> -		u32 mask_index = 0;
> -		u32 cache = 0;
> -
> -		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
> -				   &mask_index);
> -	}
> +	if (unlikely(!skb_hash || mc->cache_size == 0))
> +		return flow_lookup(tbl, ti, ma, key, n_mask_hit, NULL,
> +				   NULL);
>
>  	/* Pre and post recirulation flows usually have the same skb_hash
>  	 * value. To avoid hash collisions, rehash the 'skb_hash' with
> @@ -849,11 +852,7 @@ struct sw_flow *ovs_flow_tbl_lookup(struct 
> flow_table *tbl,
>  {
>  	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
>  	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
> -	u32 __always_unused n_mask_hit;
> -	u32 __always_unused n_cache_hit;
> -	u32 index = 0;
> -
> -	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, 
> &index);
> +	return flow_lookup(tbl, ti, ma, key, NULL, NULL, NULL);
>  }
>
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
> @@ -865,7 +864,6 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct 
> flow_table *tbl,
>  	/* Always called under ovs-mutex. */
>  	for (i = 0; i < ma->max; i++) {
>  		struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
> -		u32 __always_unused n_mask_hit;
>  		struct sw_flow_mask *mask;
>  		struct sw_flow *flow;
>
> @@ -873,7 +871,7 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct 
> flow_table *tbl,
>  		if (!mask)
>  			continue;
>
> -		flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
> +		flow = masked_flow_lookup(ti, match->key, mask, NULL);
>  		if (flow && ovs_identifier_is_key(&flow->id) &&
>  		    ovs_flow_cmp_unmasked_key(flow, match)) {
>  			return flow;
> -- 
> 2.18.1

