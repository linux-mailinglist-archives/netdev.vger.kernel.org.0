Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4039D28A879
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgJKRQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 13:16:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:47754 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgJKRQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 13:16:28 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kRexG-0005Cf-9M; Sun, 11 Oct 2020 19:16:18 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kRexG-000VwX-1q; Sun, 11 Oct 2020 19:16:18 +0200
Subject: Re: [PATCH bpf-next v6 2/6] bpf: add redirect_peer helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201010234006.7075-1-daniel@iogearbox.net>
 <20201010234006.7075-3-daniel@iogearbox.net> <20201011112213.7e542de7@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aadbb662-bb42-05be-0943-d59ba0d3f60c@iogearbox.net>
Date:   Sun, 11 Oct 2020 19:16:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201011112213.7e542de7@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25954/Sun Oct 11 15:58:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/20 11:22 AM, Jesper Dangaard Brouer wrote:
> On Sun, 11 Oct 2020 01:40:02 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>> Add an efficient ingress to ingress netns switch that can be used out of tc BPF
>> programs in order to redirect traffic from host ns ingress into a container
>> veth device ingress without having to go via CPU backlog queue [0]. For local
>> containers this can also be utilized and path via CPU backlog queue only needs
>> to be taken once, not twice. On a high level this borrows from ipvlan which does
>> similar switch in __netif_receive_skb_core() and then iterates via another_round.
>> This helps to reduce latency for mentioned use cases.
>>
>> Pod to remote pod with redirect(), TCP_RR [1]:
>>
>>    # percpu_netperf 10.217.1.33
>>            RT_LATENCY:         122.450         (per CPU:         122.666         122.401         122.333         122.401 )
>>          MEAN_LATENCY:         121.210         (per CPU:         121.100         121.260         121.320         121.160 )
>>        STDDEV_LATENCY:         120.040         (per CPU:         119.420         119.910         125.460         115.370 )
>>           MIN_LATENCY:          46.500         (per CPU:          47.000          47.000          47.000          45.000 )
>>           P50_LATENCY:         118.500         (per CPU:         118.000         119.000         118.000         119.000 )
>>           P90_LATENCY:         127.500         (per CPU:         127.000         128.000         127.000         128.000 )
>>           P99_LATENCY:         130.750         (per CPU:         131.000         131.000         129.000         132.000 )
>>
>>      TRANSACTION_RATE:       32666.400         (per CPU:        8152.200        8169.842        8174.439        8169.897 )
>>
>> Pod to remote pod with redirect_peer(), TCP_RR:
>>
>>    # percpu_netperf 10.217.1.33
>>            RT_LATENCY:          44.449         (per CPU:          43.767          43.127          45.279          45.622 )
>>          MEAN_LATENCY:          45.065         (per CPU:          44.030          45.530          45.190          45.510 )
>>        STDDEV_LATENCY:          84.823         (per CPU:          66.770          97.290          84.380          90.850 )
>>           MIN_LATENCY:          33.500         (per CPU:          33.000          33.000          34.000          34.000 )
>>           P50_LATENCY:          43.250         (per CPU:          43.000          43.000          43.000          44.000 )
>>           P90_LATENCY:          46.750         (per CPU:          46.000          47.000          47.000          47.000 )
>>           P99_LATENCY:          52.750         (per CPU:          51.000          54.000          53.000          53.000 )
>>
>>      TRANSACTION_RATE:       90039.500         (per CPU:       22848.186       23187.089       22085.077       21919.130 )
> 
> This is awesome results and great work Daniel! :-)
> 
> I wonder if we can also support this from XDP, which can also native
> redirect into veth.  Originally I though we could add the peer netdev
> in the devmap, but AFAIK Toke showed me that this was not possible.

I think it should be possible with similar principle. What was the limitation
that you ran into with devmap for XDP?

>>    [0] https://linuxplumbersconf.org/event/7/contributions/674/attachments/568/1002/plumbers_2020_cilium_load_balancer.pdf
>>    [1] https://github.com/borkmann/netperf_scripts/blob/master/percpu_netperf
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   drivers/net/veth.c             |  9 ++++++
>>   include/linux/netdevice.h      |  4 +++
>>   include/uapi/linux/bpf.h       | 17 +++++++++++
>>   net/core/dev.c                 | 15 ++++++++--
>>   net/core/filter.c              | 54 +++++++++++++++++++++++++++++-----
>>   tools/include/uapi/linux/bpf.h | 17 +++++++++++
>>   6 files changed, 106 insertions(+), 10 deletions(-)
>>
> [...]
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 9d55bf5d1a65..7dd015823593 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4930,7 +4930,7 @@ EXPORT_SYMBOL_GPL(br_fdb_test_addr_hook);
>>   
>>   static inline struct sk_buff *
>>   sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>> -		   struct net_device *orig_dev)
>> +		   struct net_device *orig_dev, bool *another)
>>   {
>>   #ifdef CONFIG_NET_CLS_ACT
>>   	struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
>> @@ -4974,7 +4974,11 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>>   		 * redirecting to another netdev
>>   		 */
>>   		__skb_push(skb, skb->mac_len);
>> -		skb_do_redirect(skb);
>> +		if (skb_do_redirect(skb) == -EAGAIN) {
>> +			__skb_pull(skb, skb->mac_len);
>> +			*another = true;
>> +			break;
>> +		}
>>   		return NULL;
>>   	case TC_ACT_CONSUMED:
>>   		return NULL;
>> @@ -5163,7 +5167,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>>   skip_taps:
>>   #ifdef CONFIG_NET_INGRESS
>>   	if (static_branch_unlikely(&ingress_needed_key)) {
>> -		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
>> +		bool another = false;
>> +
>> +		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
>> +					 &another);
>> +		if (another)
>> +			goto another_round;
>>   		if (!skb)
>>   			goto out;
>>   
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 5da44b11e1ec..fab951c6be57 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -2380,8 +2380,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
>>   
>>   /* Internal, non-exposed redirect flags. */
>>   enum {
>> -	BPF_F_NEIGH = (1ULL << 1),
>> -#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH)
>> +	BPF_F_NEIGH	= (1ULL << 1),
>> +	BPF_F_PEER	= (1ULL << 2),
>> +#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH | BPF_F_PEER)
>>   };
>>   
>>   BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
>> @@ -2430,19 +2431,35 @@ EXPORT_PER_CPU_SYMBOL_GPL(bpf_redirect_info);
>>   int skb_do_redirect(struct sk_buff *skb)
>>   {
>>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>> +	struct net *net = dev_net(skb->dev);
>>   	struct net_device *dev;
>>   	u32 flags = ri->flags;
>>   
>> -	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
>> +	dev = dev_get_by_index_rcu(net, ri->tgt_index);
>>   	ri->tgt_index = 0;
>> -	if (unlikely(!dev)) {
>> -		kfree_skb(skb);
>> -		return -EINVAL;
>> +	ri->flags = 0;
>> +	if (unlikely(!dev))
>> +		goto out_drop;
>> +	if (flags & BPF_F_PEER) {
>> +		const struct net_device_ops *ops = dev->netdev_ops;
>> +
>> +		if (unlikely(!ops->ndo_get_peer_dev ||
>> +			     !skb_at_tc_ingress(skb)))
>> +			goto out_drop;
>> +		dev = ops->ndo_get_peer_dev(dev);
>> +		if (unlikely(!dev ||
>> +			     !is_skb_forwardable(dev, skb) ||
> 
> Again a MTU "transmissing" check on ingress "receive" path, but we can
> take that discussion after this is merged, as this keeps the current
> behavior.

Yep, agree; also it checks whether dev is up which we need here too.

>> +			     net_eq(net, dev_net(dev))))
>> +			goto out_drop;
>> +		skb->dev = dev;
> 
> Don't we need to clean some more state when this packet gets redirected
> into another namespace?
> 
> Like skb_scrub_packet(), or is that not needed?  (p.s. I would like to
> avoid it, as it e.g. clears the skb->mark.)

Not needed, the traffic egress path from a netns is scrubbing already, and
ingress traffic in hostns the BPF prog can do if needed given it has full
control, this is similar to how ipvlan does it for traffic into container.

>> +		return -EAGAIN;
>>   	}
>> -
>>   	return flags & BPF_F_NEIGH ?
>>   	       __bpf_redirect_neigh(skb, dev) :
>>   	       __bpf_redirect(skb, dev, flags);
>> +out_drop:
>> +	kfree_skb(skb);
>> +	return -EINVAL;
>>   }
> 
> 
> 

