Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4074A138855
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 22:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgALV3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 16:29:20 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42675 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732914AbgALV3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 16:29:19 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1iqknO-0003Lx-11; Sun, 12 Jan 2020 22:29:18 +0100
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
To:     Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel@pengutronix.de
References: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
 <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
 <779d3346-0344-9064-15d5-4d565647a556@pengutronix.de>
 <1b70f56b72943bf5dfd2813565373e8c1b639c31.camel@redhat.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <53ce1ab4-3346-2367-8aa5-85a89f6897ec@pengutronix.de>
Date:   Sun, 12 Jan 2020 22:29:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1b70f56b72943bf5dfd2813565373e8c1b639c31.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

On 1/10/20 5:31 PM, Paolo Abeni wrote:
> On Thu, 2020-01-09 at 18:39 +0100, Ahmad Fatoum wrote:
>> Hello Paolo,
>>
>> On 1/9/20 1:51 PM, Paolo Abeni wrote:
>>> On Wed, 2020-01-08 at 15:55 +0100, Ahmad Fatoum wrote:
>>>> I've run into an issue of CAN frames being sent out-of-order on an i.MX6 Dual
>>>> with Linux v5.5-rc5. Bisecting has lead me down to this commit:
>>>
>>> Thank you for the report.
>>
>> Thanks for the prompt patch. :-)
>>
>>> The code is only build-tested, could you please try it in your setup?
>>
>> Issue still persists, albeit appears to have become much less frequent. Took 2 million
>> frames till first two were swapped. What I usually saw was a swap every few thousand
>> frames at least and quite often more frequent than that. Might just be noise though.
> 
> Thank you for testing. Even with the proposed patch there is still a
> possible race condition: the CPU holding the seqlock can clear the
> 'empty' flag after that the CPU xmitting the packet enqueue it and set
> the 'empty' flag.
> 
> The only option I can think of - beyond plain revert - is updating the
> 'empty' flag in a even a more coarse way, as in the following patch.
> 
> Again, the code only build tested and very rough, but it would be
> helpful if you could give it a spin.

Issue still reproducible despite the new patch.

Thanks
Ahmad

> 
> Thank you!
> 
> Paolo
> 
> ---
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 6a70845bd9ab..fb365fbf65f8 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -113,7 +113,7 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
>  		     struct net_device *dev, struct netdev_queue *txq,
>  		     spinlock_t *root_lock, bool validate);
>  
> -void __qdisc_run(struct Qdisc *q);
> +int __qdisc_run(struct Qdisc *q);
>  
>  static inline void qdisc_run(struct Qdisc *q)
>  {
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index fceddf89592a..df460fe0773a 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -158,7 +158,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		if (!spin_trylock(&qdisc->seqlock))
>  			return false;
> -		WRITE_ONCE(qdisc->empty, false);
>  	} else if (qdisc_is_running(qdisc)) {
>  		return false;
>  	}
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0ad39c87b7fd..b6378bb7b64a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3624,10 +3624,22 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  end_run:
>  			qdisc_run_end(q);
>  		} else {
> +			int quota = 0;
> +
>  			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> -			qdisc_run(q);
> +			if (!qdisc_run_begin(q))
> +				goto out;
> +
> +			WRITE_ONCE(q->empty, false);
> +			if (likely(!test_bit(__QDISC_STATE_DEACTIVATED,
> +					     &q->state)))
> +				quota = __qdisc_run(q);
> +			if (quota > 0)
> +				WRITE_ONCE(q->empty, true);
> +			qdisc_run_end(q);
>  		}
>  
> +out:
>  		if (unlikely(to_free))
>  			kfree_skb_list(to_free);
>  		return rc;
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 5ab696efca95..1bd2c4e9c4c2 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -376,7 +376,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
>  	return sch_direct_xmit(skb, q, dev, txq, root_lock, validate);
>  }
>  
> -void __qdisc_run(struct Qdisc *q)
> +int __qdisc_run(struct Qdisc *q)
>  {
>  	int quota = dev_tx_weight;
>  	int packets;
> @@ -388,6 +388,7 @@ void __qdisc_run(struct Qdisc *q)
>  			break;
>  		}
>  	}
> +	return quota;
>  }
>  
>  unsigned long dev_trans_start(struct net_device *dev)
> @@ -649,12 +650,9 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  
>  		skb = __skb_array_consume(q);
>  	}
> -	if (likely(skb)) {
> -		qdisc_update_stats_at_dequeue(qdisc, skb);
> -	} else {
> -		WRITE_ONCE(qdisc->empty, true);
> -	}
>  
> +	if (likely(skb))
> +		qdisc_update_stats_at_dequeue(qdisc, skb);
>  	return skb;
>  }
>  
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
