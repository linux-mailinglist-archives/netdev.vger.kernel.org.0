Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5D7326A6F
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBZXgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:36:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:45844 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZXgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 18:36:46 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFmeR-0004hp-6i; Sat, 27 Feb 2021 00:36:03 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFmeR-0005nW-18; Sat, 27 Feb 2021 00:36:03 +0100
Subject: Re: [PATCH bpf-next V2 1/2] bpf: BPF-helper for MTU checking add
 length input
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        john.fastabend@gmail.com
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
 <161364899856.1250213.17435782167100828617.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e339303d-1d95-e8d4-565c-920eb1a3eca8@iogearbox.net>
Date:   Sat, 27 Feb 2021 00:36:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161364899856.1250213.17435782167100828617.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/21 12:49 PM, Jesper Dangaard Brouer wrote:
> The FIB lookup example[1] show how the IP-header field tot_len
> (iph->tot_len) is used as input to perform the MTU check.
> 
> This patch extend the BPF-helper bpf_check_mtu() with the same ability
> to provide the length as user parameter input, via mtu_len parameter.
> 
> [1] samples/bpf/xdp_fwd_kern.c
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   include/uapi/linux/bpf.h |   17 +++++++++++------
>   net/core/filter.c        |   12 ++++++++++--
>   2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4c24daa43bac..4ba4ef0ff63a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3850,8 +3850,7 @@ union bpf_attr {
>    *
>    * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>    *	Description
> -
> - *		Check ctx packet size against exceeding MTU of net device (based
> + *		Check packet size against exceeding MTU of net device (based
>    *		on *ifindex*).  This helper will likely be used in combination
>    *		with helpers that adjust/change the packet size.
>    *
> @@ -3868,6 +3867,14 @@ union bpf_attr {
>    *		against the current net device.  This is practical if this isn't
>    *		used prior to redirect.
>    *
> + *		On input *mtu_len* must be a valid pointer, else verifier will
> + *		reject BPF program.  If the value *mtu_len* is initialized to
> + *		zero then the ctx packet size is use.  When value *mtu_len* is
> + *		provided as input this specify the L3 length that the MTU check
> + *		is done against. Remember XDP and TC length operate at L2, but
> + *		this value is L3 as this correlate to MTU and IP-header tot_len
> + *		values which are L3 (similar behavior as bpf_fib_lookup).
> + *
>    *		The Linux kernel route table can configure MTUs on a more
>    *		specific per route level, which is not provided by this helper.
>    *		For route level MTU checks use the **bpf_fib_lookup**\ ()
> @@ -3892,11 +3899,9 @@ union bpf_attr {
>    *
>    *		On return *mtu_len* pointer contains the MTU value of the net
>    *		device.  Remember the net device configured MTU is the L3 size,
> - *		which is returned here and XDP and TX length operate at L2.
> + *		which is returned here and XDP and TC length operate at L2.
>    *		Helper take this into account for you, but remember when using
> - *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
> - *		pointer and be initialized (to zero), else verifier will reject
> - *		BPF program.
> + *		MTU value in your BPF-code.
>    *
>    *	Return
>    *		* 0 on success, and populate MTU value in *mtu_len* pointer.
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7059cf604d94..fcc3bda85960 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5660,7 +5660,7 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
>   	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
>   		return -EINVAL;
>   
> -	if (unlikely(flags & BPF_MTU_CHK_SEGS && len_diff))
> +	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len)))
>   		return -EINVAL;
>   
>   	dev = __dev_via_ifindex(dev, ifindex);
> @@ -5670,7 +5670,11 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
>   	mtu = READ_ONCE(dev->mtu);
>   
>   	dev_len = mtu + dev->hard_header_len;
> -	skb_len = skb->len + len_diff; /* minus result pass check */
> +
> +	/* If set use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
> +	skb_len = *mtu_len ? *mtu_len + dev->hard_header_len : skb->len;
> +
> +	skb_len += len_diff; /* minus result pass check */
>   	if (skb_len <= dev_len) {
>   		ret = BPF_MTU_CHK_RET_SUCCESS;
>   		goto out;
> @@ -5715,6 +5719,10 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
>   	/* Add L2-header as dev MTU is L3 size */
>   	dev_len = mtu + dev->hard_header_len;
>   
> +	/* Use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
> +	if (*mtu_len)
> +		xdp_len = *mtu_len + dev->hard_header_len;
> +
>   	xdp_len += len_diff; /* minus result pass check */
>   	if (xdp_len > dev_len)
>   		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> 

Btw, one more note on the whole bpf_*_check_mtu() helper... Last week I implemented
PMTU discovery support for clients for Cilium's XDP stand-alone LB in DSR mode, so I
was briefly considering whether to use the bpf_xdp_check_mtu() helper for retrieving
the device MTU, but then I thought to myself why having an unnecessary per-packet cost
for an extra helper call if I could just pass it in via constant instead. So I went
with the latter instead of the helper with the tradeoff to restart the Cilium agent
if someone actually changes MTU in prod which is a rare event anyway.

Looking at what bpf_xdp_check_mtu() for example really offers is retrieval of dev->mtu
as well as dev->hard_header_len and the rest can all be done inside the BPF prog itself
w/o the helper overhead. Why am I mentioning this.. because the above change is a similar
case of what could have been done /inside/ the BPF prog anyway (especially on XDP where
extra overhead should be cut where possible).

I think it got lost somewhere in the many versions of the original set where it was
mentioned before, but allowing to retrieve the dev object into BPF context and then
exposing it similarly to how we handle the case of struct bpf_tcp_sock would have been
much cleaner approach, e.g. the prog from XDP and tc context would be able to do:

   struct bpf_dev *dev = ctx->dev;

And we expose initially, for example:

   struct bpf_dev {
     __u32 mtu;
     __u32 hard_header_len;
     __u32 ifindex;
     __u32 rx_queues;
     __u32 tx_queues;
   };

And we could also have a BPF helper for XDP and tc that would fetch a /different/ dev
given we're under RCU context anyway, like ...

BPF_CALL_2(bpf_get_dev, struct xdp_buff *, xdp, u32, ifindex)
{
	return dev_get_by_index_rcu(dev_net(xdp->rxq->dev), index);
}

... returning a new dev_or_null type. With this flexibility everything else can be done
inside the prog, and later on it easily allows to expose more from dev side. Actually,
I'm inclined to code it up ...
