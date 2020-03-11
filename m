Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879D6182470
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgCKWJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgCKWJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:09:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88168206E7;
        Wed, 11 Mar 2020 22:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583964562;
        bh=NyvXVozLYcI0YL52ap2vKHzLgBCJIUrC8FHyEzc5sTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pyMtX8QrL2xBPRe8dnPN6SyxXAXW93fzd630pd/wg5svjMvJeyqmNm4h0dU7b3+vV
         Ne7/XtydAPo1nEpxu2ZkXu4Urg3jv/g+PJZxN1CGFcyamTxJUW9I/cdpwPHgvJskcs
         K1vKamWvbJ7btmUG/S1hYKKyQ094HxFIqoFsgV1g=
Date:   Wed, 11 Mar 2020 15:09:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 2/6] net: sched: Allow extending set of
 supported RED flags
Message-ID: <20200311150920.306de7c6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200311173356.38181-3-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
        <20200311173356.38181-3-petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 19:33:52 +0200 Petr Machata wrote:
> diff --git a/include/net/red.h b/include/net/red.h
> index 9665582c4687..5718d2b25637 100644
> --- a/include/net/red.h
> +++ b/include/net/red.h
> @@ -179,6 +179,31 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
>  	return true;
>  }
>  
> +static inline bool red_get_flags(unsigned char flags,
> +				 unsigned char historic_mask,
> +				 struct nlattr *flags_attr,
> +				 unsigned int supported_mask,
> +				 unsigned int *p_flags, unsigned char *p_userbits,
> +				 struct netlink_ext_ack *extack)
> +{
> +	if (flags && flags_attr) {
> +		NL_SET_ERR_MSG_MOD(extack, "flags should be passed either through qopt, or through a dedicated attribute");
> +		return false;
> +	}
> +
> +	*p_flags = flags & historic_mask;
> +	if (flags_attr)
> +		*p_flags |= nla_get_u32(flags_attr);

It's less error prone for callers not to modify the output parameters
until we're sure the call won't fail.

> +	if (*p_flags & ~supported_mask) {
> +		NL_SET_ERR_MSG_MOD(extack, "unsupported RED flags specified");
> +		return false;
> +	}
> +
> +	*p_userbits = flags & ~historic_mask;
> +	return true;
> +}
> +

> +#define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
> +
>  struct tc_red_xstats {
>  	__u32           early;          /* Early drops */
>  	__u32           pdrop;          /* Drops due to queue limits */
> diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
> index 1695421333e3..61d7c5a61279 100644
> --- a/net/sched/sch_red.c
> +++ b/net/sched/sch_red.c
> @@ -35,7 +35,11 @@
>  
>  struct red_sched_data {
>  	u32			limit;		/* HARD maximal queue length */
> -	unsigned char		flags;
> +
> +	u32			flags;

Can we stick to uchar until the number of flags grows?

> +	/* Non-flags in tc_red_qopt.flags. */
> +	unsigned char		userbits;
> +
>  	struct timer_list	adapt_timer;
>  	struct Qdisc		*sch;
>  	struct red_parms	parms;
> @@ -44,6 +48,8 @@ struct red_sched_data {
>  	struct Qdisc		*qdisc;
>  };
>  
> +#define RED_SUPPORTED_FLAGS TC_RED_HISTORIC_FLAGS
> +
>  static inline int red_use_ecn(struct red_sched_data *q)
>  {
>  	return q->flags & TC_RED_ECN;
> @@ -186,6 +192,7 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
>  	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
>  	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
>  	[TCA_RED_MAX_P] = { .type = NLA_U32 },
> +	[TCA_RED_FLAGS] = { .type = NLA_U32 },

BITFIELD32? And then perhaps turn the define into a const validation
data?

Also policy needs a .strict_start_type now.

>  };
>  
>  static int red_change(struct Qdisc *sch, struct nlattr *opt,

> @@ -302,7 +317,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
>  	struct nlattr *opts = NULL;
>  	struct tc_red_qopt opt = {
>  		.limit		= q->limit,
> -		.flags		= q->flags,
> +		.flags		= ((q->flags & TC_RED_HISTORIC_FLAGS) |
> +				   q->userbits),

nit: parens unnecessary

>  		.qth_min	= q->parms.qth_min >> q->parms.Wlog,
>  		.qth_max	= q->parms.qth_max >> q->parms.Wlog,
>  		.Wlog		= q->parms.Wlog,
> @@ -321,6 +337,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
>  	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
>  	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P))
>  		goto nla_put_failure;
> +	if (q->flags & ~TC_RED_HISTORIC_FLAGS)
> +		nla_put_u32(skb, TCA_RED_FLAGS, q->flags);

Not 100% sure if conditional is needed, but please check the return
code.

>  	return nla_nest_end(skb, opts);
>  
>  nla_put_failure:

