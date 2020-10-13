Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A94E28CEC6
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgJMMxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgJMMxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:53:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055E4C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 05:53:11 -0700 (PDT)
Date:   Tue, 13 Oct 2020 14:53:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602593589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JHd6dTQlmRaQkFiHp7Be06MNHQn08Md9og+nFkmWEaQ=;
        b=UXVeGwFD9kxlCSfXMlGBMISsCCE4ok2MfB4SO1MitokMfcKl1VP+7k0eMutQoqfMZQ+Q9o
        ayaC3MPgNpDVUtiQe4uXOEdA3rG0OaSw3VXU3v4R7Z6Tiag7EpaOgrLV8R1io0aIl5bH2W
        RNtyJbkbyE5/hH6h83uaoJ05Kb8PvU84Hbrfn1xnIer6iriflkqfQDjV4rXpzoslEKcABH
        o2un8j169yb+AIVKlw//2l5Be36wXbpuvM9Fpum+afENY4n0pkMONIqP9oBZOgE3D/A/Gd
        bFc++/CzlI8ozrz+51tQHQ12GC6CnSX2UOkON7vxlEfqiH/yZVkVAu+EHkSUKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602593589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JHd6dTQlmRaQkFiHp7Be06MNHQn08Md9og+nFkmWEaQ=;
        b=KvzX53iQYGCLa0BQ1BtRWwpfMYKf/ckrItUeIxU3YghqQVXMVbnKx48iinCFag5gjz17z8
        8utidjMRVLOPSvDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com
Subject: Re: [PATCH net-next] net: openvswitch: fix to make sure
 flow_lookup() is not preempted
Message-ID: <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
References: <160259304349.181017.7492443293310262978.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160259304349.181017.7492443293310262978.stgit@ebuild>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-13 14:44:19 [+0200], Eelco Chaudron wrote:
> The flow_lookup() function uses per CPU variables, which must not be
> preempted. However, this is fine in the general napi use case where
> the local BH is disabled. But, it's also called in the netlink
> context, which is preemptible. The below patch makes sure that even
> in the netlink path, preemption is disabled.
> 
> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
> Reported-by: Juri Lelli <jlelli@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  net/openvswitch/flow_table.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 87c286ad660e..16289386632b 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -850,9 +850,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
>  	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
>  	u32 __always_unused n_mask_hit;
>  	u32 __always_unused n_cache_hit;
> +	struct sw_flow *flow;
>  	u32 index = 0;
>  
> -	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
> +	/* This function gets called trough the netlink interface and therefore
> +	 * is preemptible. However, flow_lookup() function needs to be called
> +	 * with preemption disabled due to CPU specific variables.
> +	 */

Once again. u64_stats_update_begin(). What protects you against
concurrent access.

> +	preempt_disable();
> +	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
> +	preempt_enable();
> +	return flow;
>  }
>  
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
> 

Sebastian
