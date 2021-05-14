Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA93B380D2D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhENPdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 11:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhENPdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 11:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1255A613DF;
        Fri, 14 May 2021 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621006347;
        bh=ExrQtzQkISfEidR3m8lbeb2NO218wRvn24mHxRFR8wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VpA0g+ro9UEHzrm7+a9opXiZHeIJVfDzsGJXumHi6Yzcqteq0ErmWO/qGzyvk2bMs
         K4swTc5qPOQR9MTMuStOKvz6vBzoNmvwIBA8sLfpAHgvV8LXnk+KU6JBvZuy/vGgy0
         Z/fGU1UbZJdE7H0EAhts1r7G/ncwOufPYHb7Nk6WebihJY+44B48jg3qftM72wdIQt
         Jw/4zxON4MgmnfeOOSkQTAxRzSH9h+aEkSlHZPgr6htuPdjRa99TLUaFVcYA185kbv
         lG3hnvJ9X5tpgYflhmAFLdF7RQPf+GZQtMbJJoQ/BXECN6cLakNuzEd2qrHWpGMAYX
         5sOs/3kK2iNEQ==
Date:   Fri, 14 May 2021 08:32:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev
 queue mapping
Message-ID: <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021 19:18:29 +0200 Yannick Vignon wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> Even though the taprio qdisc is designed for multiqueue devices, all the
> queues still point to the same top-level taprio qdisc. This works and is
> probably required for software taprio, but at least with offload taprio,
> it has an undesirable side effect: because the whole qdisc is run when a
> packet has to be sent, it allows packets in a best-effort class to be
> processed in the context of a task sending higher priority traffic. If
> there are packets left in the qdisc after that first run, the NET_TX
> softirq is raised and gets executed immediately in the same process
> context. As with any other softirq, it runs up to 10 times and for up to
> 2ms, during which the calling process is waiting for the sendmsg call (or
> similar) to return. In my use case, that calling process is a real-time
> task scheduled to send a packet every 2ms, so the long sendmsg calls are
> leading to missed timeslots.
> 
> By attaching each netdev queue to its own qdisc, as it is done with
> the "classic" mq qdisc, each traffic class can be processed independently
> without touching the other classes. A high-priority process can then send
> packets without getting stuck in the sendmsg call anymore.
> 
> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> ---
> 
> This patch fixes an issue I observed while verifying the behavior of the
> taprio qdisc in a real-time networking situation.
> I am wondering if implementing separate taprio qdiscs for the software
> and accelerated cases wouldn't be a better solution, but that would
> require changes to the iproute2 package as well, and would break
> backwards compatibility.

You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
CCing them now. Comments, anyone?

This looks like a very drastic change. Are you expecting the qdisc will
always be bypassed?

After a 1 minute looks it seems like taprio is using device queues in
strict priority fashion. Maybe a different model is needed, but a qdisc
with:

enqueue()
{
	WARN_ONCE(1)
}

really doesn't look right to me.

Quoting the rest of the patch below for the benefit of those on CC.

> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 5c91df52b8c2..0bfb03052429 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -438,6 +438,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  	struct Qdisc *child;
>  	int queue;
>  
> +	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
> +		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
> +		return qdisc_drop(skb, sch, to_free);
> +	}
> +
>  	queue = skb_get_queue_mapping(skb);
>  
>  	child = q->qdiscs[queue];
> @@ -529,23 +534,7 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
>  
>  static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
>  {
> -	struct taprio_sched *q = qdisc_priv(sch);
> -	struct net_device *dev = qdisc_dev(sch);
> -	struct sk_buff *skb;
> -	int i;
> -
> -	for (i = 0; i < dev->num_tx_queues; i++) {
> -		struct Qdisc *child = q->qdiscs[i];
> -
> -		if (unlikely(!child))
> -			continue;
> -
> -		skb = child->ops->peek(child);
> -		if (!skb)
> -			continue;
> -
> -		return skb;
> -	}
> +	WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
>  
>  	return NULL;
>  }
> @@ -654,27 +643,7 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
>  
>  static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
>  {
> -	struct taprio_sched *q = qdisc_priv(sch);
> -	struct net_device *dev = qdisc_dev(sch);
> -	struct sk_buff *skb;
> -	int i;
> -
> -	for (i = 0; i < dev->num_tx_queues; i++) {
> -		struct Qdisc *child = q->qdiscs[i];
> -
> -		if (unlikely(!child))
> -			continue;
> -
> -		skb = child->ops->dequeue(child);
> -		if (unlikely(!skb))
> -			continue;
> -
> -		qdisc_bstats_update(sch, skb);
> -		qdisc_qstats_backlog_dec(sch, skb);
> -		sch->q.qlen--;
> -
> -		return skb;
> -	}
> +	WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
>  
>  	return NULL;
>  }
> @@ -1759,6 +1728,37 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
>  	return taprio_change(sch, opt, extack);
>  }
>  
> +static void taprio_attach(struct Qdisc *sch)
> +{
> +	struct taprio_sched *q = qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	unsigned int ntx;
> +
> +	/* Attach underlying qdisc */
> +	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
> +		struct Qdisc *qdisc = q->qdiscs[ntx];
> +		struct Qdisc *old;
> +
> +		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> +			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> +			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
> +			if (ntx < dev->real_num_tx_queues)
> +				qdisc_hash_add(qdisc, false);
> +		} else {
> +			old = dev_graft_qdisc(qdisc->dev_queue, sch);
> +			qdisc_refcount_inc(sch);
> +		}
> +		if (old)
> +			qdisc_put(old);
> +	}
> +
> +	/* access to the child qdiscs is not needed in offload mode */
> +	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> +		kfree(q->qdiscs);
> +		q->qdiscs = NULL;
> +	}
> +}
> +
>  static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
>  					     unsigned long cl)
>  {
> @@ -1785,8 +1785,12 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
>  	if (dev->flags & IFF_UP)
>  		dev_deactivate(dev);
>  
> -	*old = q->qdiscs[cl - 1];
> -	q->qdiscs[cl - 1] = new;
> +	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> +		*old = dev_graft_qdisc(dev_queue, new);
> +	} else {
> +		*old = q->qdiscs[cl - 1];
> +		q->qdiscs[cl - 1] = new;
> +	}
>  
>  	if (new)
>  		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> @@ -2020,6 +2024,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
>  	.change		= taprio_change,
>  	.destroy	= taprio_destroy,
>  	.reset		= taprio_reset,
> +	.attach		= taprio_attach,
>  	.peek		= taprio_peek,
>  	.dequeue	= taprio_dequeue,
>  	.enqueue	= taprio_enqueue,

