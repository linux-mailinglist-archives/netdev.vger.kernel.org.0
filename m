Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76492816D3
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbgJBPje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBPj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:39:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CF52074B;
        Fri,  2 Oct 2020 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601653168;
        bh=IxNP8RKF+70uXKFP01tUfgoiyhvgj4nOkiXHQzcg1Is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N/Cwq9gYKzedp6AUE0ZyDvK0Vr53mXvoJ8RYVE250PaUiLUa4RLirm5R2mYjqOCC4
         4KMUJpKItqrf0PTGG25Dq1+Zy73l8HLdgCUJDPk/Sj/Pv27SpkHsweuB4mpjvDGRCx
         LQAJvFwM2ds12YUcw9zalQ9FaOpvGk6Csd7GRjmk=
Date:   Fri, 2 Oct 2020 08:39:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
Message-ID: <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 11:09:42 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Rework the policy dump code a bit to support adding multiple
> policies to a single dump, in order to e.g. support per-op
> policies in generic netlink.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

with a side of nits..

> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 4be0ad237e57..a929759a03f5 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -1937,12 +1937,68 @@ void nla_get_range_signed(const struct nla_policy *pt,
>  
>  struct netlink_policy_dump_state;
>  
> -struct netlink_policy_dump_state *
> -netlink_policy_dump_start(const struct nla_policy *policy,
> -			  unsigned int maxtype);
> +/**
> + * netlink_policy_dump_add_policy - add a policy to the dump
> + * @pstate: state to add to, may be reallocated, must be %NULL the first time
> + * @policy: the new policy to add to the dump
> + * @maxtype: the new policy's max attr type
> + *
> + * Returns: 0 on success, a negative error code otherwise.
> + *
> + * Call this to allocate a policy dump state, and to add policies to it. This
> + * should be called from the dump start() callback.
> + *
> + * Note: on failures, any previously allocated state is freed.
> + */
> +int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
> +				   const struct nla_policy *policy,
> +				   unsigned int maxtype);

Personal preference perhaps, but I prefer kdoc with the definition.

> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 537472342781..42777749d4d8 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1164,10 +1164,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  	if (!op.policy)
>  		return -ENODATA;
>  
> -	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
> -	if (IS_ERR(ctx->state))
> -		return PTR_ERR(ctx->state);
> -	return 0;
> +	return netlink_policy_dump_add_policy(&ctx->state, op.policy,
> +					      op.maxattr);

Looks like we flip-flopped between int and pointer return between
patches 1 and this one?

>  }

> +int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
> +				       const struct nla_policy *policy,
> +				       unsigned int maxtype)
> +{
> +	unsigned int i;
> +
> +	if (WARN_ON(!policy || !maxtype))
> +                return 0;

Would this warning make sense in add() (if not already there)?
If null/0 is never added it can't match and we'd just hit the
warning below.

> +	for (i = 0; i < state->n_alloc; i++) {
> +		if (state->policies[i].policy == policy &&
> +		    state->policies[i].maxtype == maxtype)
> +			return i;
> +	}
> +
> +	WARN_ON(1);
> +	return 0;
>  }
>  
>  static bool

