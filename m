Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F73C9DB5
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbhGOL1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:27:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11424 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhGOL1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:27:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQX4M4x42zcbjT;
        Thu, 15 Jul 2021 19:21:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 19:24:25 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 19:24:25 +0800
Subject: Re: [Patch net-next v3] net_sched: introduce tracepoint
 trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
References: <20210715060324.43337-1-xiyou.wangcong@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <484a5342-c66f-f04d-c7b2-c24246e53c83@huawei.com>
Date:   Thu, 15 Jul 2021 19:24:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210715060324.43337-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/15 14:03, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> the entrance of TC layer on TX side. This is similar to
> trace_qdisc_dequeue():
> 
> 1. For both we only trace successful cases. The failure cases
>    can be traced via trace_kfree_skb().
> 
> 2. They are called at entrance or exit of TC layer, not for each
>    ->enqueue() or ->dequeue(). This is intentional, because
>    we want to make trace_qdisc_enqueue() symmetric to
>    trace_qdisc_dequeue(), which is easier to use.
> 
> The return value of qdisc_enqueue() is not interesting here,
> we have Qdisc's drop packets in ->dequeue(), it is impossible to
> trace them even if we have the return value, the only way to trace
> them is tracing kfree_skb().
> 
> We only add information we need to trace ring buffer. If any other
> information is needed, it is easy to extend it without breaking ABI,
> see commit 3dd344ea84e1 ("net: tracepoint: exposing sk_family in all
> tcp:tracepoints").
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
> v3: expand changelog
>     add helper dev_qdisc_enqueue()
> 
> v2: improve changelog
> 
>  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
>  net/core/dev.c               | 20 ++++++++++++++++----
>  2 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index 58209557cb3a..c3006c6b4a87 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
>  		  __entry->txq_state, __entry->packets, __entry->skbaddr )
>  );
>  
> +TRACE_EVENT(qdisc_enqueue,
> +
> +	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> +
> +	TP_ARGS(qdisc, txq, skb),
> +
> +	TP_STRUCT__entry(
> +		__field(struct Qdisc *, qdisc)
> +		__field(void *,	skbaddr)
> +		__field(int, ifindex)
> +		__field(u32, handle)
> +		__field(u32, parent)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->qdisc = qdisc;
> +		__entry->skbaddr = skb;
> +		__entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> +		__entry->handle	 = qdisc->handle;
> +		__entry->parent	 = qdisc->parent;
> +	),
> +
> +	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
> +		  __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
> +);
> +
>  TRACE_EVENT(qdisc_reset,
>  
>  	TP_PROTO(struct Qdisc *q),
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..0dcddd077d60 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -131,6 +131,7 @@
>  #include <trace/events/napi.h>
>  #include <trace/events/net.h>
>  #include <trace/events/skb.h>
> +#include <trace/events/qdisc.h>
>  #include <linux/inetdevice.h>
>  #include <linux/cpu_rmap.h>
>  #include <linux/static_key.h>
> @@ -3844,6 +3845,18 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
>  	}
>  }
>  
> +static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
> +			     struct sk_buff **to_free,
> +			     struct netdev_queue *txq)
> +{
> +	int rc;
> +
> +	rc = q->enqueue(skb, q, to_free) & NET_XMIT_MASK;
> +	if (rc == NET_XMIT_SUCCESS)

I do not really understand the usecase you metioned previously,
but tracepointing the rc in trace_qdisc_enqueue() will avoid the
above checking, which is in the fast path.

If there is no extra checking overhead when this tracepoint is
disabled, then ignore my comment.

> +		trace_qdisc_enqueue(q, txq, skb);
> +	return rc;
> +}
> +
>  static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  				 struct net_device *dev,
>  				 struct netdev_queue *txq)
> @@ -3862,8 +3875,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  			 * of q->seqlock to protect from racing with requeuing.
>  			 */
>  			if (unlikely(!nolock_qdisc_is_empty(q))) {
> -				rc = q->enqueue(skb, q, &to_free) &
> -					NET_XMIT_MASK;
> +				rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
>  				__qdisc_run(q);
>  				qdisc_run_end(q);
>  
> @@ -3879,7 +3891,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  			return NET_XMIT_SUCCESS;
>  		}
>  
> -		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
>  		qdisc_run(q);
>  
>  no_lock_out:
> @@ -3923,7 +3935,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  		qdisc_run_end(q);
>  		rc = NET_XMIT_SUCCESS;
>  	} else {
> -		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
>  		if (qdisc_run_begin(q)) {
>  			if (unlikely(contended)) {
>  				spin_unlock(&q->busylock);
> 
