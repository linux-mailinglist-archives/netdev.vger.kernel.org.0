Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77AD2C0C70
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388803AbgKWNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:53:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:60006 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388791AbgKWNxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:53:09 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khCHB-0007wF-Ho; Mon, 23 Nov 2020 14:53:05 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khCHB-0007fL-A7; Mon, 23 Nov 2020 14:53:05 +0100
Subject: Re: [PATCH bpf] net, xsk: Avoid taking multiple skbuff references
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        jonathan.lemon@gmail.com, yhs@fb.com, weqaar.janjua@gmail.com,
        magnus.karlsson@intel.com, weqaar.a.janjua@intel.com
References: <20201123131215.136131-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <12b970c5-6b44-5288-0c79-2df5178d1165@iogearbox.net>
Date:   Mon, 23 Nov 2020 14:53:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201123131215.136131-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25996/Sun Nov 22 14:25:48 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 2:12 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Commit 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
> addressed the problem that packets were discarded from the Tx AF_XDP
> ring, when the driver returned NETDEV_TX_BUSY. Part of the fix was
> bumping the skbuff reference count, so that the buffer would not be
> freed by dev_direct_xmit(). A reference count larger than one means
> that the skbuff is "shared", which is not the case.
> 
> If the "shared" skbuff is sent to the generic XDP receive path,
> netif_receive_generic_xdp(), and pskb_expand_head() is entered the
> BUG_ON(skb_shared(skb)) will trigger.
> 
> This patch adds a variant to dev_direct_xmit(), __dev_direct_xmit(),
> where a user can select the skbuff free policy. This allows AF_XDP to
> avoid bumping the reference count, but still keep the NETDEV_TX_BUSY
> behavior.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>   include/linux/netdevice.h | 1 +
>   net/core/dev.c            | 9 +++++++--
>   net/xdp/xsk.c             | 8 +-------
>   3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 964b494b0e8d..e7402fca7752 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2815,6 +2815,7 @@ u16 dev_pick_tx_cpu_id(struct net_device *dev, struct sk_buff *skb,
>   		       struct net_device *sb_dev);
>   int dev_queue_xmit(struct sk_buff *skb);
>   int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev);
> +int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id, bool free_on_busy);
>   int dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
>   int register_netdevice(struct net_device *dev);
>   void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..2af79a4253bb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4180,7 +4180,7 @@ int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev)
>   }
>   EXPORT_SYMBOL(dev_queue_xmit_accel);
>   
> -int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
> +int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id, bool free_on_busy)
>   {
>   	struct net_device *dev = skb->dev;
>   	struct sk_buff *orig_skb = skb;
> @@ -4211,7 +4211,7 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
>   
>   	local_bh_enable();
>   
> -	if (!dev_xmit_complete(ret))
> +	if (free_on_busy && !dev_xmit_complete(ret))
>   		kfree_skb(skb);
>   
>   	return ret;

Hm, but this way free_on_busy, even though constant, cannot be optimized away?
Can't you just move the dev_xmit_complete() check out into dev_direct_xmit()
instead? That way you can just drop the bool, and the below dev_direct_xmit()
should probably just become an __always_line function in netdevice.h so you
avoid the double call.

> @@ -4220,6 +4220,11 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
>   	kfree_skb_list(skb);
>   	return NET_XMIT_DROP;
>   }
> +
> +int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
> +{
> +	return __dev_direct_xmit(skb, queue_id, true);
> +}
>   EXPORT_SYMBOL(dev_direct_xmit);
>   
>   /*************************************************************************
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 5a6cdf7b320d..c6ad31b374b7 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -411,11 +411,7 @@ static int xsk_generic_xmit(struct sock *sk)
>   		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>   		skb->destructor = xsk_destruct_skb;
>   
> -		/* Hinder dev_direct_xmit from freeing the packet and
> -		 * therefore completing it in the destructor
> -		 */
> -		refcount_inc(&skb->users);
> -		err = dev_direct_xmit(skb, xs->queue_id);
> +		err = __dev_direct_xmit(skb, xs->queue_id, false);
>   		if  (err == NETDEV_TX_BUSY) {
>   			/* Tell user-space to retry the send */
>   			skb->destructor = sock_wfree;
> @@ -429,12 +425,10 @@ static int xsk_generic_xmit(struct sock *sk)
>   		/* Ignore NET_XMIT_CN as packet might have been sent */
>   		if (err == NET_XMIT_DROP) {
>   			/* SKB completed but not sent */
> -			kfree_skb(skb);
>   			err = -EBUSY;
>   			goto out;
>   		}
>   
> -		consume_skb(skb);
>   		sent_frame = true;
>   	}
>   
> 
> base-commit: 178648916e73e00de83150eb0c90c0d3a977a46a
> 

