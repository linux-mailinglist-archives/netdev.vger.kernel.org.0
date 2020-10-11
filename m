Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC8A28A69C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgJKJWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:22:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgJKJWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 05:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602408148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jKK5N6PrgxsOU8SQj7Scj0vZnD5482zpkcpJ2wJ4hZA=;
        b=QJvtGVW0LRsX0ZnMyZLHoPFgE62Cine+g6IQWDFgv65rG1HFP0QHl787fFFVfLHjDKvio5
        0IAZvIPc32GxcKnugWrKRq38hzT6qcjljwrlzcPHABmCk5vKwvLmNovn8plzqAjdtB8cqM
        J2TMTFSXU/JaM8oWiCyXqktFdgqVU3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-VlH4jTA0PIW89n__ZAlHEg-1; Sun, 11 Oct 2020 05:22:24 -0400
X-MC-Unique: VlH4jTA0PIW89n__ZAlHEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7593425D5;
        Sun, 11 Oct 2020 09:22:22 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EE7510013C4;
        Sun, 11 Oct 2020 09:22:14 +0000 (UTC)
Date:   Sun, 11 Oct 2020 11:22:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     brouer@redhat.com, ast@kernel.org, john.fastabend@gmail.com,
        yhs@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 2/6] bpf: add redirect_peer helper
Message-ID: <20201011112213.7e542de7@carbon>
In-Reply-To: <20201010234006.7075-3-daniel@iogearbox.net>
References: <20201010234006.7075-1-daniel@iogearbox.net>
        <20201010234006.7075-3-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 01:40:02 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> Add an efficient ingress to ingress netns switch that can be used out of tc BPF
> programs in order to redirect traffic from host ns ingress into a container
> veth device ingress without having to go via CPU backlog queue [0]. For local
> containers this can also be utilized and path via CPU backlog queue only needs
> to be taken once, not twice. On a high level this borrows from ipvlan which does
> similar switch in __netif_receive_skb_core() and then iterates via another_round.
> This helps to reduce latency for mentioned use cases.
> 
> Pod to remote pod with redirect(), TCP_RR [1]:
> 
>   # percpu_netperf 10.217.1.33
>           RT_LATENCY:         122.450         (per CPU:         122.666         122.401         122.333         122.401 )
>         MEAN_LATENCY:         121.210         (per CPU:         121.100         121.260         121.320         121.160 )
>       STDDEV_LATENCY:         120.040         (per CPU:         119.420         119.910         125.460         115.370 )
>          MIN_LATENCY:          46.500         (per CPU:          47.000          47.000          47.000          45.000 )
>          P50_LATENCY:         118.500         (per CPU:         118.000         119.000         118.000         119.000 )
>          P90_LATENCY:         127.500         (per CPU:         127.000         128.000         127.000         128.000 )
>          P99_LATENCY:         130.750         (per CPU:         131.000         131.000         129.000         132.000 )
> 
>     TRANSACTION_RATE:       32666.400         (per CPU:        8152.200        8169.842        8174.439        8169.897 )
> 
> Pod to remote pod with redirect_peer(), TCP_RR:
> 
>   # percpu_netperf 10.217.1.33
>           RT_LATENCY:          44.449         (per CPU:          43.767          43.127          45.279          45.622 )
>         MEAN_LATENCY:          45.065         (per CPU:          44.030          45.530          45.190          45.510 )
>       STDDEV_LATENCY:          84.823         (per CPU:          66.770          97.290          84.380          90.850 )
>          MIN_LATENCY:          33.500         (per CPU:          33.000          33.000          34.000          34.000 )
>          P50_LATENCY:          43.250         (per CPU:          43.000          43.000          43.000          44.000 )
>          P90_LATENCY:          46.750         (per CPU:          46.000          47.000          47.000          47.000 )
>          P99_LATENCY:          52.750         (per CPU:          51.000          54.000          53.000          53.000 )
> 
>     TRANSACTION_RATE:       90039.500         (per CPU:       22848.186       23187.089       22085.077       21919.130 )

This is awesome results and great work Daniel! :-)

I wonder if we can also support this from XDP, which can also native
redirect into veth.  Originally I though we could add the peer netdev
in the devmap, but AFAIK Toke showed me that this was not possible.


>   [0] https://linuxplumbersconf.org/event/7/contributions/674/attachments/568/1002/plumbers_2020_cilium_load_balancer.pdf
>   [1] https://github.com/borkmann/netperf_scripts/blob/master/percpu_netperf
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  drivers/net/veth.c             |  9 ++++++
>  include/linux/netdevice.h      |  4 +++
>  include/uapi/linux/bpf.h       | 17 +++++++++++
>  net/core/dev.c                 | 15 ++++++++--
>  net/core/filter.c              | 54 +++++++++++++++++++++++++++++-----
>  tools/include/uapi/linux/bpf.h | 17 +++++++++++
>  6 files changed, 106 insertions(+), 10 deletions(-)
> 
[...]
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9d55bf5d1a65..7dd015823593 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4930,7 +4930,7 @@ EXPORT_SYMBOL_GPL(br_fdb_test_addr_hook);
>  
>  static inline struct sk_buff *
>  sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> -		   struct net_device *orig_dev)
> +		   struct net_device *orig_dev, bool *another)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
>  	struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
> @@ -4974,7 +4974,11 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
>  		 * redirecting to another netdev
>  		 */
>  		__skb_push(skb, skb->mac_len);
> -		skb_do_redirect(skb);
> +		if (skb_do_redirect(skb) == -EAGAIN) {
> +			__skb_pull(skb, skb->mac_len);
> +			*another = true;
> +			break;
> +		}
>  		return NULL;
>  	case TC_ACT_CONSUMED:
>  		return NULL;
> @@ -5163,7 +5167,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>  skip_taps:
>  #ifdef CONFIG_NET_INGRESS
>  	if (static_branch_unlikely(&ingress_needed_key)) {
> -		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
> +		bool another = false;
> +
> +		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
> +					 &another);
> +		if (another)
> +			goto another_round;
>  		if (!skb)
>  			goto out;
>  
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5da44b11e1ec..fab951c6be57 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2380,8 +2380,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev)
>  
>  /* Internal, non-exposed redirect flags. */
>  enum {
> -	BPF_F_NEIGH = (1ULL << 1),
> -#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH)
> +	BPF_F_NEIGH	= (1ULL << 1),
> +	BPF_F_PEER	= (1ULL << 2),
> +#define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH | BPF_F_PEER)
>  };
>  
>  BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
> @@ -2430,19 +2431,35 @@ EXPORT_PER_CPU_SYMBOL_GPL(bpf_redirect_info);
>  int skb_do_redirect(struct sk_buff *skb)
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +	struct net *net = dev_net(skb->dev);
>  	struct net_device *dev;
>  	u32 flags = ri->flags;
>  
> -	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
> +	dev = dev_get_by_index_rcu(net, ri->tgt_index);
>  	ri->tgt_index = 0;
> -	if (unlikely(!dev)) {
> -		kfree_skb(skb);
> -		return -EINVAL;
> +	ri->flags = 0;
> +	if (unlikely(!dev))
> +		goto out_drop;
> +	if (flags & BPF_F_PEER) {
> +		const struct net_device_ops *ops = dev->netdev_ops;
> +
> +		if (unlikely(!ops->ndo_get_peer_dev ||
> +			     !skb_at_tc_ingress(skb)))
> +			goto out_drop;
> +		dev = ops->ndo_get_peer_dev(dev);
> +		if (unlikely(!dev ||
> +			     !is_skb_forwardable(dev, skb) ||

Again a MTU "transmissing" check on ingress "receive" path, but we can
take that discussion after this is merged, as this keeps the current
behavior.

> +			     net_eq(net, dev_net(dev))))
> +			goto out_drop;
> +		skb->dev = dev;

Don't we need to clean some more state when this packet gets redirected
into another namespace?

Like skb_scrub_packet(), or is that not needed?  (p.s. I would like to
avoid it, as it e.g. clears the skb->mark.)

> +		return -EAGAIN;
>  	}
> -
>  	return flags & BPF_F_NEIGH ?
>  	       __bpf_redirect_neigh(skb, dev) :
>  	       __bpf_redirect(skb, dev, flags);
> +out_drop:
> +	kfree_skb(skb);
> +	return -EINVAL;
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

