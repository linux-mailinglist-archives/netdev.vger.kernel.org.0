Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DCD3C415B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhGLDDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:03:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLDDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:03:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GNT2y0BHBzcbP2;
        Mon, 12 Jul 2021 10:57:46 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 11:01:01 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 11:01:01 +0800
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint
 trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     <xiangxia.m.yue@gmail.com>, Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <40afda00-0737-d4cc-e801-85a7544fb26b@huawei.com>
Date:   Mon, 12 Jul 2021 11:01:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/12 3:03, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> the entrance of TC layer on TX side. This is kinda symmetric to
> trace_qdisc_dequeue(), and together they can be used to calculate
> the packet queueing latency. It is more accurate than
> trace_net_dev_queue(), because we already successfully enqueue
> the packet at that point.
> 
> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use %px to print a real kernel address here.
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
>  net/core/dev.c               |  9 +++++++++
>  2 files changed, 35 insertions(+)
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
> index c253c2aafe97..20b9376de301 100644
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
> @@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  			if (unlikely(!nolock_qdisc_is_empty(q))) {
>  				rc = q->enqueue(skb, q, &to_free) &
>  					NET_XMIT_MASK;
> +				if (rc == NET_XMIT_SUCCESS)

If NET_XMIT_CN is returned, the skb seems to be enqueued too?

Also instead of checking the rc before calling the trace_*, maybe
it make more sense to add the rc to the tracepoint, so that the checking
is avoided, and we are able to tell the enqueuing result of a specific skb
from that tracepoint too.

> +					trace_qdisc_enqueue(q, txq, skb);

Does it make sense to wrap the about to something like:

int sch_enqueue(....)
{
	rc = q->enqueue(skb, q, &to_free)..
	....
	trace_qdisc_enqueue(q, txq, skb);
}

So that the below code can reuse that wrapper too.

>  				__qdisc_run(q);
>  				qdisc_run_end(q);
>  
> @@ -3880,6 +3883,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  		}
>  
>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +		if (rc == NET_XMIT_SUCCESS)
> +			trace_qdisc_enqueue(q, txq, skb);
> +
>  		qdisc_run(q);
>  
>  no_lock_out:
> @@ -3924,6 +3930,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  		rc = NET_XMIT_SUCCESS;
>  	} else {
>  		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> +		if (rc == NET_XMIT_SUCCESS)
> +			trace_qdisc_enqueue(q, txq, skb);
> +
>  		if (qdisc_run_begin(q)) {
>  			if (unlikely(contended)) {
>  				spin_unlock(&q->busylock);
> 
