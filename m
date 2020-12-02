Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7342A2CCAAF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgLBXoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:44:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:57536 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgLBXoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:44:20 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkbmb-0006N9-Ba; Thu, 03 Dec 2020 00:43:37 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkbmb-000GPi-10; Thu, 03 Dec 2020 00:43:37 +0100
Subject: Re: [PATCH bpf-next V8 5/8] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
 <160650040292.2890576.17040975200628427127.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <af28e4e7-8089-b252-3927-a962b98ad7b8@iogearbox.net>
Date:   Thu, 3 Dec 2020 00:43:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160650040292.2890576.17040975200628427127.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26006/Wed Dec  2 14:14:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
> The use-case for dropping the MTU check when TC-BPF does redirect to
> ingress, is described by Eyal Birger in email[0]. The summary is the
> ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> ingress redirect packet and let normal netstack fragment packet as needed.
> 
> [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> 
> V4:
>   - Keep net_device "up" (IFF_UP) check.
>   - Adjustment to handle bpf_redirect_peer() helper
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
>   net/core/dev.c            |   19 ++-----------------
>   net/core/filter.c         |   14 +++++++++++---
>   3 files changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7ce648a564f7..4a854e09e918 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3917,11 +3917,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
>   bool is_skb_forwardable(const struct net_device *dev,
>   			const struct sk_buff *skb);
>   
> +static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
> +						 const struct sk_buff *skb,
> +						 const bool check_mtu)
> +{
> +	const u32 vlan_hdr_len = 4; /* VLAN_HLEN */
> +	unsigned int len;
> +
> +	if (!(dev->flags & IFF_UP))
> +		return false;
> +
> +	if (!check_mtu)
> +		return true;
> +
> +	len = dev->mtu + dev->hard_header_len + vlan_hdr_len;
> +	if (skb->len <= len)
> +		return true;
> +
> +	/* if TSO is enabled, we don't care about the length as the packet
> +	 * could be forwarded without being segmented before
> +	 */
> +	if (skb_is_gso(skb))
> +		return true;
> +
> +	return false;
> +}
> +
>   static __always_inline int ____dev_forward_skb(struct net_device *dev,
> -					       struct sk_buff *skb)
> +					       struct sk_buff *skb,
> +					       const bool check_mtu)
>   {
>   	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> -	    unlikely(!is_skb_forwardable(dev, skb))) {
> +	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
>   		atomic_long_inc(&dev->rx_dropped);
>   		kfree_skb(skb);
>   		return NET_RX_DROP;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 60d325bda0d7..6ceb6412ee97 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2189,28 +2189,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
>   
>   bool is_skb_forwardable(const struct net_device *dev, const struct sk_buff *skb)
>   {
> -	unsigned int len;
> -
> -	if (!(dev->flags & IFF_UP))
> -		return false;
> -
> -	len = dev->mtu + dev->hard_header_len + VLAN_HLEN;
> -	if (skb->len <= len)
> -		return true;
> -
> -	/* if TSO is enabled, we don't care about the length as the packet
> -	 * could be forwarded without being segmented before
> -	 */
> -	if (skb_is_gso(skb))
> -		return true;
> -
> -	return false;
> +	return __is_skb_forwardable(dev, skb, true);
>   }
>   EXPORT_SYMBOL_GPL(is_skb_forwardable);

Only user of is_skb_forwardable() that is left after this patch is bridge, maybe
the whole thing should be moved into the header?

>   int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
>   {
> -	int ret = ____dev_forward_skb(dev, skb);
> +	int ret = ____dev_forward_skb(dev, skb, true);
>   
>   	if (likely(!ret)) {
>   		skb->protocol = eth_type_trans(skb, dev);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index d6125cfc49c3..4673afe59533 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
>   
>   static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
>   {
> -	return dev_forward_skb(dev, skb);
> +	int ret = ____dev_forward_skb(dev, skb, false);
> +
> +	if (likely(!ret)) {
> +		skb->protocol = eth_type_trans(skb, dev);
> +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> +		ret = netif_rx(skb);

Why netif_rx() and not netif_rx_internal() as in dev_forward_skb() originally?
One extra call otherwise.

> +	}
> +
> +	return ret;
>   }
>   
>   static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
>   				      struct sk_buff *skb)
>   {
> -	int ret = ____dev_forward_skb(dev, skb);
> +	int ret = ____dev_forward_skb(dev, skb, false);
>   
>   	if (likely(!ret)) {
>   		skb->dev = dev;
> @@ -2480,7 +2488,7 @@ int skb_do_redirect(struct sk_buff *skb)
>   			goto out_drop;
>   		dev = ops->ndo_get_peer_dev(dev);
>   		if (unlikely(!dev ||
> -			     !is_skb_forwardable(dev, skb) ||
> +			     !__is_skb_forwardable(dev, skb, false) ||

If we only use __is_skb_forwardable() with false directly here, maybe then
lets just have the !(dev->flags & IFF_UP) test here instead..

>   			     net_eq(net, dev_net(dev))))
>   			goto out_drop;
>   		skb->dev = dev;
> 
> 

