Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2F1BC231
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgD1PFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 11:05:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:54336 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgD1PFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 11:05:17 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTRnE-0000Q5-F8; Tue, 28 Apr 2020 17:05:04 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTRnD-000RQz-UV; Tue, 28 Apr 2020 17:05:03 +0200
Subject: Re: [PATCH v4 bpf-next 09/15] net: Support xdp in the Tx path for
 packets as an skb
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
References: <20200427224633.15627-1-dsahern@kernel.org>
 <20200427224633.15627-10-dsahern@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4a4d21a-90b7-0f88-3f99-1961d264bafd@iogearbox.net>
Date:   Tue, 28 Apr 2020 17:05:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200427224633.15627-10-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25796/Tue Apr 28 14:00:48 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 12:46 AM, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> Add support to run Tx path program on packets about to hit the
> ndo_start_xmit function for a device. Only XDP_DROP and XDP_PASS
> are supported now. Conceptually, XDP_REDIRECT for this path can
> work the same as it does for the Rx path, but that support is left
> for a follow on series.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>   include/linux/netdevice.h | 11 +++++++++
>   net/core/dev.c            | 52 ++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2b552c29e188..33a09396444f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3717,6 +3717,7 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
>   
>   void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
>   int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb);
> +u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb);
>   int netif_rx(struct sk_buff *skb);
>   int netif_rx_ni(struct sk_buff *skb);
>   int netif_receive_skb(struct sk_buff *skb);
> @@ -4577,6 +4578,16 @@ static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
>   					      struct sk_buff *skb, struct net_device *dev,
>   					      bool more)
>   {
> +	if (static_branch_unlikely(&xdp_egress_needed_key)) {
> +		u32 act;
> +
> +		rcu_read_lock();
> +		act = do_xdp_egress_skb(dev, skb);
> +		rcu_read_unlock();
> +		if (act == XDP_DROP)
> +			return NET_XMIT_DROP;
> +	}
> +
>   	__this_cpu_write(softnet_data.xmit.more, more);
>   	return ops->ndo_start_xmit(skb, dev);

I didn't see anything in the patch series on this (unless I missed it), but
don't we need to force turning off GSO/TSO for the device where XDP egress is
attached? Otherwise how is this safe? E.g. generic XDP uses netif_elide_gro()
to bypass GRO once enabled. In this case on egress, if helpers like bpf_xdp_adjust_head()
or bpf_xdp_adjust_tail() adapt GSO skbs then drivers will operate on wrong GSO
info. Not sure if this goes into undefined behavior here?

Overall, for the regular stack, I expect the performance of XDP egress to be
worse than e.g. tc egress, for example, when TSO is disabled but not GSO then
you parse the same packet multiple times given post-GSO whereas with tc egress
it would operate just fine on a GSO skb. Plus all the limitations generic XDP
has with skb_cloned(skb), skb_is_nonlinear(skb), etc, where we need to linearize
so calling it 'XDP egress' might lead to false assumptions. Did you do a comparison
on that as well?

Also, I presume the XDP egress is intentionally not called when programs return
XDP_TX but only XDP_REDIRECT? Why such design decision?

>   }
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 14ce8e25e3d3..4d98189548c7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4620,7 +4620,6 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>   }
>   
>   static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
> -DEFINE_STATIC_KEY_FALSE(xdp_egress_needed_key);
>   
>   int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
>   {
> @@ -4671,6 +4670,57 @@ int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
>   }
>   EXPORT_SYMBOL_GPL(do_xdp_generic_rx);
>   
> +DEFINE_STATIC_KEY_FALSE(xdp_egress_needed_key);
> +EXPORT_SYMBOL_GPL(xdp_egress_needed_key);
> +
> +static u32 handle_xdp_egress_act(u32 act, struct net_device *dev,
> +				 struct bpf_prog *xdp_prog)
> +{
> +	switch (act) {
> +	case XDP_DROP:
> +		/* fall through */
> +	case XDP_PASS:
> +		break;
> +	case XDP_TX:
> +		/* fall through */
> +	case XDP_REDIRECT:
> +		/* fall through */
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(dev, xdp_prog, act);
> +		act = XDP_DROP;
> +		break;
> +	}
> +
> +	return act;
> +}
> +
> +u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
> +{
> +	struct bpf_prog *xdp_prog;
> +	u32 act = XDP_PASS;
> +
> +	xdp_prog = rcu_dereference(dev->xdp_egress_prog);
> +	if (xdp_prog) {
> +		struct xdp_txq_info txq = { .dev = dev };
> +		struct xdp_buff xdp;
> +
> +		xdp.txq = &txq;
> +		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
> +		act = handle_xdp_egress_act(act, dev, xdp_prog);
> +		if (act == XDP_DROP) {
> +			atomic_long_inc(&dev->tx_dropped);
> +			skb_tx_error(skb);
> +			kfree_skb(skb);
> +		}
> +	}
> +
> +	return act;
> +}
> +EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
> +
>   static int netif_rx_internal(struct sk_buff *skb)
>   {
>   	int ret;
> 

