Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA63B13894D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 02:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbgAMBgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 20:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730100AbgAMBgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 20:36:35 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F9621556;
        Mon, 13 Jan 2020 01:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578879393;
        bh=vL+SkXNCHhkbJ89KflcmycNh+OaAa5IulZHN29QmjEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tUvA+tlYJKYSlJsQMzrJoLyhf8GmwfheIGHjLLTpoIgbXeobtUQW/JnfSbqCaYtss
         3TYsP+cTTYichWr+aAC8aApTQB1yB3tWrp6hb86q1PygJQctwWobO2CLrE84suhSMB
         6LbXO41ng0Gg+fjE10SH0lrsHqKQTimsFm01ByL4=
Date:   Sun, 12 Jan 2020 17:36:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: sched: add Flow Queue PIE packet
 scheduler
Message-ID: <20200112173624.5f7b754b@cakuba>
In-Reply-To: <20200110062657.7217-3-gautamramk@gmail.com>
References: <20200110062657.7217-1-gautamramk@gmail.com>
        <20200110062657.7217-3-gautamramk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 11:56:57 +0530, gautamramk@gmail.com wrote:
> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>=20
> Principles:
>   - Packets are classified on flows.
>   - This is a Stochastic model (as we use a hash, several flows might
>                                 be hashed on the same slot)
>   - Each flow has a PIE managed queue.
>   - Flows are linked onto two (Round Robin) lists,
>     so that new flows have priority on old ones.
>   - For a given flow, packets are not reordered.
>   - Drops during enqueue only.
>   - ECN capability is off by default.
>   - ECN threshold is at 10% by default.
>   - Uses timestamps to calculate queue delay by default.
>=20
> Usage:
> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
>                     [ alpha NUMBER ] [ beta NUMBER ]
>                     [ target TIME us ] [ tupdate TIME us ]
>                     [ memory_limit BYTES ] [ quantum BYTES ]
>                     [ ecnprob PERCENTAGE ] [ [no]ecn ]
>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
>=20
> defaults:
>   limit: 10240 packets, flows: 1024
>   alpha: 1/8, beta : 5/4
>   target: 15 ms, tupdate: 15 ms (in jiffies)
>   memory_limit: 32 Mb, quantum: device MTU
>   ecnprob: 10%, ecn: off
>   bytemode: off, dq_rate_estimator: off

Some reviews below, but hopefully someone who knows more about qdiscs
will still review :)

> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index b1e7ec726958..93e480069a52 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -366,6 +366,18 @@ config NET_SCH_PIE
> =20
>  	  If unsure, say N.
> =20
> +config NET_SCH_FQ_PIE
> +	depends on NET_SCH_PIE
> +	tristate "Flow Queue Proportional Integral controller Enhanced (FQ-PIE)"
> +	help
> +	  Say Y here if you want to use the Flow Queue Proportional Integral
> +	  controller Enhanced (FQ-PIE) packet scheduling algorithm.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called sch_fq_pie.

Worth mentioning the RFC here?

> +	  If unsure, say N.
> +
>  config NET_SCH_INGRESS
>  	tristate "Ingress/classifier-action Qdisc"
>  	depends on NET_CLS_ACT

> +/* Flow Queue PIE
> + *
> + * Principles:
> + *   - Packets are classified on flows.
> + *   - This is a Stochastic model (as we use a hash, several flows might
> + *                                 be hashed on the same slot)

s/on/to/ ?

> + *   - Each flow has a PIE managed queue.
> + *   - Flows are linked onto two (Round Robin) lists,
> + *     so that new flows have priority on old ones.
> + *   - For a given flow, packets are not reordered.
> + *   - Drops during enqueue only.
> + *   - ECN capability is off by default.
> + *   - ECN threshold is at 10% by default.
> + *   - Uses timestamps to calculate queue delay by default.
> + */

> +static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct fq_pie_sched_data *q =3D qdisc_priv(sch);
> +	struct nlattr *tb[TCA_FQ_PIE_MAX + 1];
> +	unsigned int len_dropped =3D 0;
> +	unsigned int num_dropped =3D 0;
> +	unsigned int qlen;

net/sched/sch_fq_pie.c:275:15: warning: variable =E2=80=98qlen=E2=80=99 set=
 but not used [-Wunused-but-set-variable]
  275 |  unsigned int qlen;
      |               ^~~~

> +	int err;
> +
> +	if (!opt)
> +		return -EINVAL;
> +
> +	err =3D nla_parse_nested_deprecated(tb, TCA_FQ_PIE_MAX, opt,
> +					  fq_pie_policy, NULL);

Please use the non-deprecated version, and pass extack in.

> +	if (err < 0)
> +		return err;
> +
> +	sch_tree_lock(sch);
> +	if (tb[TCA_FQ_PIE_LIMIT]) {
> +		u32 limit =3D nla_get_u32(tb[TCA_FQ_PIE_LIMIT]);
> +
> +		q->p_params.limit =3D limit;
> +		sch->limit =3D limit;
> +	}
> +	if (tb[TCA_FQ_PIE_FLOWS]) {
> +		if (q->flows)
> +			return -EINVAL;
> +		q->flows_cnt =3D nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
> +		if (!q->flows_cnt ||
> +		    q->flows_cnt > 65536)
> +			return -EINVAL;

Gotta release the tree lock here. Please also consider adding extack
messages for these error conditions so users understand what went wrong.

> +	}
> +
> +	if (tb[TCA_FQ_PIE_ALPHA])
> +		q->p_params.alpha =3D nla_get_u32(tb[TCA_FQ_PIE_ALPHA]);
> +
> +	if (tb[TCA_FQ_PIE_BETA])
> +		q->p_params.beta =3D nla_get_u32(tb[TCA_FQ_PIE_BETA]);
> +
> +	/* convert from microseconds to pschedtime */
> +	if (tb[TCA_FQ_PIE_TARGET]) {
> +		/* target is in us */
> +		u32 target =3D nla_get_u32(tb[TCA_FQ_PIE_TARGET]);
> +
> +		/* convert to pschedtime */
> +		q->p_params.target =3D
> +		PSCHED_NS2TICKS((u64)target * NSEC_PER_USEC);

looks misaligned

> +	}
> +
> +	/* tupdate is in jiffies */
> +	if (tb[TCA_FQ_PIE_TUPDATE])
> +		q->p_params.tupdate =3D
> +		usecs_to_jiffies(nla_get_u32(tb[TCA_FQ_PIE_TUPDATE]));

ditto, and in couple other places, the continuation line should be more
indented than the beginning one

> +	if (tb[TCA_FQ_PIE_MEMORY_LIMIT])
> +		q->memory_limit =3D nla_get_u32(tb[TCA_FQ_PIE_MEMORY_LIMIT]);
> +	if (tb[TCA_FQ_PIE_QUANTUM])
> +		q->quantum =3D nla_get_u32(tb[TCA_FQ_PIE_QUANTUM]);
> +
> +	if (tb[TCA_FQ_PIE_ECN_PROB])
> +		q->ecn_prob =3D nla_get_u32(tb[TCA_FQ_PIE_ECN_PROB]);
> +
> +	if (tb[TCA_FQ_PIE_ECN])
> +		q->p_params.ecn =3D nla_get_u32(tb[TCA_FQ_PIE_ECN]);
> +
> +	if (tb[TCA_FQ_PIE_BYTEMODE])
> +		q->p_params.bytemode =3D nla_get_u32(tb[TCA_FQ_PIE_BYTEMODE]);
> +
> +	if (tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR])
> +		q->p_params.dq_rate_estimator =3D
> +		nla_get_u32(tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR]);
> +
> +	/* Drop excess packets if new limit is lower */
> +	qlen =3D sch->q.qlen;
> +	while (sch->q.qlen > sch->limit) {
> +		struct sk_buff *skb =3D fq_pie_qdisc_dequeue(sch);
> +
> +		kfree_skb(skb);
> +		len_dropped +=3D qdisc_pkt_len(skb);
> +		num_dropped +=3D 1;
> +	}
> +	qdisc_tree_reduce_backlog(sch, num_dropped, len_dropped);
> +
> +	sch_tree_unlock(sch);
> +	return 0;
> +}
> +
> +static void fq_pie_timer(struct timer_list *t)
> +{
> +	struct fq_pie_sched_data *q =3D from_timer(q, t, adapt_timer);
> +	struct Qdisc *sch =3D q->sch;
> +	spinlock_t *root_lock =3D qdisc_lock(qdisc_root_sleeping(sch));
> +	u16 idx;

Could you order variable declaration lines longest to shortest,=20
if initialization depends on order and would break such order=20
please move it out to the body of the function (applies to all
functions).

> +	spin_lock(root_lock);
> +
> +	for (idx =3D 0; idx < q->flows_cnt; idx++)
> +		pie_calculate_probability(&q->p_params, &q->flows[idx].vars,
> +					  q->flows[idx].backlog);
> +
> +	/* reset the timer to fire after 'tupdate'. tupdate is in jiffies. */
> +	if (q->p_params.tupdate)
> +		mod_timer(&q->adapt_timer, jiffies + q->p_params.tupdate);
> +	spin_unlock(root_lock);
> +}
> +
> +static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
> +		       struct netlink_ext_ack *extack)
> +{
> +	struct fq_pie_sched_data *q =3D qdisc_priv(sch);
> +	int err;
> +	u16 idx;
> +
> +	pie_params_init(&q->p_params);
> +	sch->limit =3D 10 * 1024;
> +	q->p_params.limit =3D sch->limit;
> +	q->quantum =3D psched_mtu(qdisc_dev(sch));
> +	q->sch =3D sch;
> +	q->ecn_prob =3D 10;
> +	q->flows_cnt =3D 1024;
> +	q->memory_limit =3D 32 << 20;

SZ_32M ?

> +
> +	INIT_LIST_HEAD(&q->new_flows);
> +	INIT_LIST_HEAD(&q->old_flows);
> +
> +	timer_setup(&q->adapt_timer, fq_pie_timer, 0);
> +	mod_timer(&q->adapt_timer, jiffies + HZ / 2);

The timer should probably not be armed until flows are allocated

> +	if (opt) {
> +		int err =3D fq_pie_change(sch, opt, extack);

There is an err variable in outer scope already

> +		if (err)
> +			return err;
> +	}
> +
> +	err =3D tcf_block_get(&q->block, &q->filter_list, sch, extack);
> +	if (err)
> +		goto init_failure;
> +
> +	if (!q->flows) {

Can qdisc ->init really called multiple times for this to ever be
non-NULL?

> +		q->flows =3D kvcalloc(q->flows_cnt,
> +				    sizeof(struct fq_pie_flow),
> +				    GFP_KERNEL);
> +		if (!q->flows) {
> +			err =3D -ENOMEM;
> +			goto init_failure;
> +		}
> +		for (idx =3D 0; idx < q->flows_cnt; idx++) {
> +			struct fq_pie_flow *flow =3D q->flows + idx;
> +
> +			INIT_LIST_HEAD(&flow->flowchain);
> +			pie_vars_init(&flow->vars);
> +		}
> +	}
> +	return 0;
> +
> +init_failure:
> +	q->flows_cnt =3D 0;
> +
> +	return err;
> +}
> +
> +static int fq_pie_dump(struct Qdisc *sch, struct sk_buff *skb)
> +{
> +	struct fq_pie_sched_data *q =3D qdisc_priv(sch);
> +	struct nlattr *opts;
> +
> +	opts =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
> +	if (!opts)
> +		goto nla_put_failure;

return -EMSGSIZE;

> +
> +	/* convert target from pschedtime to us */
> +	if (nla_put_u32(skb, TCA_FQ_PIE_LIMIT, sch->limit) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_FLOWS, q->flows_cnt) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_ALPHA, q->p_params.alpha) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_BETA, q->p_params.beta) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_TARGET,
> +			((u32)PSCHED_TICKS2NS(q->p_params.target)) /
> +			NSEC_PER_USEC) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_TUPDATE,
> +			jiffies_to_usecs(q->p_params.tupdate)) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_MEMORY_LIMIT, q->memory_limit) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_QUANTUM, q->quantum) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_ECN_PROB, q->ecn_prob) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_ECN, q->p_params.ecn) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_BYTEMODE, q->p_params.bytemode) ||
> +	    nla_put_u32(skb, TCA_FQ_PIE_DQ_RATE_ESTIMATOR,
> +			q->p_params.dq_rate_estimator))
> +		goto nla_put_failure;
> +
> +	return nla_nest_end(skb, opts);
> +
> +nla_put_failure:

nla_nest_cancel(skb, opts);

> +	return -1;

return -EMSGSIZE;

> +}

> +static void fq_pie_destroy(struct Qdisc *sch)
> +{
> +	struct fq_pie_sched_data *q =3D qdisc_priv(sch);
> +
> +	kvfree(q->flows);
> +	del_timer_sync(&q->adapt_timer);

You probably want to del_timer_sync before freeing the flows

> +}

