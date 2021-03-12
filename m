Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A033981E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhCLUTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:19:08 -0500
Received: from mga17.intel.com ([192.55.52.151]:47211 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234623AbhCLUSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 15:18:55 -0500
IronPort-SDR: FV16iL+YhB0c4h+dUXOjBIokr6tIlL/6o+sB51o7Smlicedq8n6XOXia+875pMFH2TQ0DpftLh
 lt+pJvDwDDKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168800949"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="168800949"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 12:18:55 -0800
IronPort-SDR: IpA2WVWUbJIXcmAIznvQ36CTmEYN7iH4NKsj/SOvWwSPdd0DsCu1aY/Nf1n4Pet/dEKUMk5k+L
 TsoDjC6Zl/pg==
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="411125141"
Received: from howardya-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.73.128])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 12:18:54 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH RFC net-next] taprio: Handle short intervals and large
 packets
In-Reply-To: <20210312092823.1429-1-kurt@linutronix.de>
References: <20210312092823.1429-1-kurt@linutronix.de>
Date:   Fri, 12 Mar 2021 12:18:54 -0800
Message-ID: <87wnucktw1.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kurt Kanzenbach <kurt@linutronix.de> writes:

> When using short intervals e.g. below one millisecond, large packets won't be
> transmitted at all. The software implementations checks whether the packet can
> be fit into the remaining interval. Therefore, it takes the packet length and
> the transmission speed into account. That is correct.
>
> However, for large packets it may be that the transmission time will be larger
> than the interval resulting in no packet transmission. The same situation works
> fine with hardware offloading applied.
>
> The problem has been observerd with the following schedule and iperf3:
>
> |tc qdisc replace dev lan1 parent root handle 100 taprio \
> |   num_tc 8 \
> |   map 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 \
> |   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> |   base-time $base \
> |   sched-entry S 0x40 500000 \
> |   sched-entry S 0xbf 500000 \
> |   clockid CLOCK_TAI \
> |   flags 0x00
>
> [...]
>
> |root@tsn:~# iperf3 -c 192.168.2.105
> |Connecting to host 192.168.2.105, port 5201
> |[  5] local 192.168.2.121 port 52610 connected to 192.168.2.105 port 5201
> |[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> |[  5]   0.00-1.00   sec  45.2 KBytes   370 Kbits/sec    0   1.41 KBytes
> |[  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
>
> After debugging, it seems that the packet length stored in the SKB is about
> 7000-8000 bytes. Using a 100 Mbit/s link the transmission time is about 600us
> which larger than the interval of 500us.
>
> Therefore, segment the SKB into smaller chunks if the packet is too big. This
> yields similar results than the hardware offload:
>
> |root@tsn:~# iperf3 -c 192.168.2.105
> |Connecting to host 192.168.2.105, port 5201
> |- - - - - - - - - - - - - - - - - - - - - - - - -
> |[ ID] Interval           Transfer     Bitrate         Retr
> |[  5]   0.00-10.00  sec  48.9 MBytes  41.0 Mbits/sec    0             sender
> |[  5]   0.00-10.02  sec  48.7 MBytes  40.7 Mbits/sec                  receiver
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  net/sched/sch_taprio.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8287894541e3..8434e87f79f7 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -411,6 +411,42 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
>  	return txtime;
>  }
>  
> +/* Similar to net/sched/sch_tbf.c::tbf_segment */
> +static int taprio_segment(struct sk_buff *skb, struct Qdisc *sch,
> +			  struct Qdisc *child, struct sk_buff **to_free)
> +{
> +	netdev_features_t features = netif_skb_features(skb);
> +	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
> +	struct sk_buff *segs, *nskb;
> +	int ret, nb;
> +
> +	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
> +
> +	if (IS_ERR_OR_NULL(segs))
> +		return qdisc_drop(skb, sch, to_free);
> +
> +	nb = 0;
> +	skb_list_walk_safe(segs, segs, nskb) {
> +		skb_mark_not_on_list(segs);
> +		qdisc_skb_cb(segs)->pkt_len = segs->len;
> +		len += segs->len;
> +		ret = qdisc_enqueue(segs, child, to_free);
> +		if (ret != NET_XMIT_SUCCESS) {
> +			if (net_xmit_drop_count(ret))
> +				qdisc_qstats_drop(sch);
> +		} else {
> +			nb++;
> +		}
> +	}
> +
> +	sch->q.qlen += nb;
> +	if (nb > 1)
> +		qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
> +	consume_skb(skb);
> +
> +	return nb > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
> +}
> +
>  static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  			  struct sk_buff **to_free)
>  {
> @@ -433,6 +469,9 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  			return qdisc_drop(skb, sch, to_free);
>  	}
>  
> +	if (skb_is_gso(skb))
> +		return taprio_segment(skb, sch, child, to_free);
> +

My first worry was whether the segments had the same tstamp as their
parent, and it seems that they do, so everything should just work with
etf or the txtime-assisted mode.

I just want to play with this patch a bit and see how it works in
practice. But it looks good.


Cheers,
-- 
Vinicius
