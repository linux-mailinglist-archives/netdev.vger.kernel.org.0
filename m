Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6873457E4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 07:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCWGjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 02:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhCWGic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 02:38:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CAC061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 23:38:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1lOag2-0007ur-BO; Tue, 23 Mar 2021 07:38:06 +0100
Subject: Re: [RFC v3] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <5bef912e-aa7d-8a27-4d18-ac8cf4f7afdf@pengutronix.de>
Date:   Tue, 23 Mar 2021 07:37:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 22.03.21 10:09, Yunsheng Lin wrote:
> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
> flag set, but queue discipline by-pass does not work for lockless
> qdisc because skb is always enqueued to qdisc even when the qdisc
> is empty, see __dev_xmit_skb().
> 
> This patch calls sch_direct_xmit() to transmit the skb directly
> to the driver for empty lockless qdisc too, which aviod enqueuing
> and dequeuing operation. qdisc->empty is set to false whenever a
> skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
> skb dequeuing return NULL, see pfifo_fast_dequeue().
> 
> There is a data race between enqueue/dequeue and qdisc->empty
> setting, qdisc->empty is only used as a hint, so we need to call
> sch_may_need_requeuing() to see if the queue is really empty and if
> there is requeued skb, which has higher priority than the current
> skb.
> 
> The performance for ip_forward test increases about 10% with this
> patch.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> Hi, Vladimir and Ahmad
> 	Please give it a test to see if there is any out of order
> packet for this patch, which has removed the priv->lock added in
> RFC v2.

Overnight test (10h, 64 mil frames) didn't see any out-of-order frames
between 2 FlexCANs on a dual core machine:

Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

No performance measurements taken.

> 
> There is a data race as below:
> 
>       CPU1                                   CPU2
> qdisc_run_begin(q)                            .
>         .                                q->enqueue()
> sch_may_need_requeuing()                      .
>     return true                               .
>         .                                     .
>         .                                     .
>     q->enqueue()                              .
> 
> When above happen, the skb enqueued by CPU1 is dequeued after the
> skb enqueued by CPU2 because sch_may_need_requeuing() return true.
> If there is not qdisc bypass, the CPU1 has better chance to queue
> the skb quicker than CPU2.
> 
> This patch does not take care of the above data race, because I
> view this as similar as below:
> 
> Even at the same time CPU1 and CPU2 write the skb to two socket
> which both heading to the same qdisc, there is no guarantee that
> which skb will hit the qdisc first, becuase there is a lot of
> factor like interrupt/softirq/cache miss/scheduling afffecting
> that.
> 
> So I hope the above data race will not cause problem for Vladimir
> and Ahmad.
> ---
>  include/net/pkt_sched.h   |  1 +
>  include/net/sch_generic.h |  1 -
>  net/core/dev.c            | 22 ++++++++++++++++++++++
>  net/sched/sch_generic.c   | 11 +++++++++++
>  4 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index f5c1bee..5715ddf 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -122,6 +122,7 @@ void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
>  bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
>  		     struct net_device *dev, struct netdev_queue *txq,
>  		     spinlock_t *root_lock, bool validate);
> +bool sch_may_need_requeuing(struct Qdisc *q);
>  
>  void __qdisc_run(struct Qdisc *q);
>  
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index f7a6e14..e08cc77 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -161,7 +161,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		if (!spin_trylock(&qdisc->seqlock))
>  			return false;
> -		WRITE_ONCE(qdisc->empty, false);
>  	} else if (qdisc_is_running(qdisc)) {
>  		return false;
>  	}
> diff --git a/net/core/dev.c b/net/core/dev.c
> index be941ed..317180a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3796,9 +3796,31 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  	qdisc_calculate_pkt_len(skb, q);
>  
>  	if (q->flags & TCQ_F_NOLOCK) {
> +		if (q->flags & TCQ_F_CAN_BYPASS && READ_ONCE(q->empty) &&
> +		    qdisc_run_begin(q)) {
> +			if (sch_may_need_requeuing(q)) {
> +				rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +				__qdisc_run(q);
> +				qdisc_run_end(q);
> +
> +				goto no_lock_out;
> +			}
> +
> +			qdisc_bstats_cpu_update(q, skb);
> +
> +			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
> +			    !READ_ONCE(q->empty))
> +				__qdisc_run(q);
> +
> +			qdisc_run_end(q);
> +			return NET_XMIT_SUCCESS;
> +		}
> +
>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +		WRITE_ONCE(q->empty, false);
>  		qdisc_run(q);
>  
> +no_lock_out:
>  		if (unlikely(to_free))
>  			kfree_skb_list(to_free);
>  		return rc;
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 44991ea..2145fdad 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -146,6 +146,8 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
>  	}
>  	if (lock)
>  		spin_unlock(lock);
> +
> +	WRITE_ONCE(q->empty, false);
>  	__netif_schedule(q);
>  }
>  
> @@ -273,6 +275,15 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
>  	return skb;
>  }
>  
> +bool sch_may_need_requeuing(struct Qdisc *q)
> +{
> +	if (likely(skb_queue_empty(&q->gso_skb) &&
> +		   !q->ops->peek(q)))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Transmit possibly several skbs, and handle the return status as
>   * required. Owning running seqcount bit guarantees that
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
