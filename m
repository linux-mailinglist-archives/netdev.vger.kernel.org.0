Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A543050ED
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhA0Eah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhA0Csq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:48:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF1A206C1;
        Wed, 27 Jan 2021 02:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611715093;
        bh=ssCNf48aPJYg7kS8gSlf12J2DkuMVOTPQXJFaO8sdmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ewBzLFzdxeDg0wi0zU6EI5imPhGUtaHOj2QENIPgwRoBv7WrkncYWABx2kTd0dEp5
         YMIuN8wqRmeRDZK18iRobZBF1S18VgkY0CHo6B7cBhq3mMDMFdzYTWQ9GIfkr27DnP
         4mDP4ZodXfr3dDHdKIlXA9m0C1NkVnY7VkTLQiQD08v9YuPTK/Dfojl7hi2Ws4QWDr
         E3kogXpmkyC5/bzBkAUt8t1x2QhA+YxiLKU75uGZd852QGS+jIGw87owyXBdiwV9kn
         gD3+MKFwd907bHWKwm72TOJQyrpNEU+uqNNgtIT5ofilyqcisS56n6buJbg9H5BIpt
         UY/TOHh5P220A==
Date:   Tue, 26 Jan 2021 18:38:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210126183812.180d0d61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125151819.8313-1-simon.horman@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 16:18:19 +0100 Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow a policer action to enforce a rate-limit based on packets-per-second,
> configurable using a packet-per-second rate and burst parameters. This may
> be used in conjunction with existing byte-per-second rate limiting in the
> same policer action.
> 
> e.g.
> tc filter add dev tap1 parent ffff: u32 match \
>               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> 
> Testing was unable to uncover a performance impact of this change on
> existing features.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

> diff --git a/net/sched/act_police.c b/net/sched/act_police.c
> index 8d8452b1cdd4..d700b2105535 100644
> --- a/net/sched/act_police.c
> +++ b/net/sched/act_police.c
> @@ -42,6 +42,8 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
>  	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
>  	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
>  	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
> +	[TCA_POLICE_PKTRATE64]  = { .type = NLA_U64 },
> +	[TCA_POLICE_PKTBURST64] = { .type = NLA_U64 },

Should we set the policy so that .min = 1?

>  };
>  
>  static int tcf_police_init(struct net *net, struct nlattr *nla,
> @@ -61,6 +63,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
>  	bool exists = false;
>  	u32 index;
>  	u64 rate64, prate64;
> +	u64 pps, ppsburst;
>  
>  	if (nla == NULL)
>  		return -EINVAL;
> @@ -183,6 +186,16 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
>  	if (tb[TCA_POLICE_AVRATE])
>  		new->tcfp_ewma_rate = nla_get_u32(tb[TCA_POLICE_AVRATE]);
>  
> +	if (tb[TCA_POLICE_PKTRATE64] && tb[TCA_POLICE_PKTBURST64]) {

Should we reject if only one is present?

> +		pps = nla_get_u64(tb[TCA_POLICE_PKTRATE64]);
> +		ppsburst = nla_get_u64(tb[TCA_POLICE_PKTBURST64]);
> +		if (pps) {
> +			new->pps_present = true;
> +			new->tcfp_pkt_burst = PSCHED_TICKS2NS(ppsburst);
> +			psched_ppscfg_precompute(&new->ppsrate, pps);
> +		}
> +	}
> +
>  	spin_lock_bh(&police->tcf_lock);
>  	spin_lock_bh(&police->tcfp_lock);
>  	police->tcfp_t_c = ktime_get_ns();

> +void psched_ppscfg_precompute(struct psched_pktrate *r,
> +			      u64 pktrate64)
> +{
> +	memset(r, 0, sizeof(*r));
> +	r->rate_pkts_ps = pktrate64;
> +	r->mult = 1;
> +	/* The deal here is to replace a divide by a reciprocal one
> +	 * in fast path (a reciprocal divide is a multiply and a shift)
> +	 *
> +	 * Normal formula would be :
> +	 *  time_in_ns = (NSEC_PER_SEC * pkt_num) / pktrate64
> +	 *
> +	 * We compute mult/shift to use instead :
> +	 *  time_in_ns = (len * mult) >> shift;
> +	 *
> +	 * We try to get the highest possible mult value for accuracy,
> +	 * but have to make sure no overflows will ever happen.
> +	 */
> +	if (r->rate_pkts_ps > 0) {
> +		u64 factor = NSEC_PER_SEC;
> +
> +		for (;;) {
> +			r->mult = div64_u64(factor, r->rate_pkts_ps);
> +			if (r->mult & (1U << 31) || factor & (1ULL << 63))
> +				break;
> +			factor <<= 1;
> +			r->shift++;

Aren't there helpers somewhere for the reciprocal divide
pre-calculation?

> +		}
> +	}
> +}
> +EXPORT_SYMBOL(psched_ppscfg_precompute);


