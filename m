Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29043A07C5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhFHXcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhFHXcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 19:32:04 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E543C061787;
        Tue,  8 Jun 2021 16:30:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3F7484D2DFB17;
        Tue,  8 Jun 2021 16:30:10 -0700 (PDT)
Date:   Tue, 08 Jun 2021 16:30:06 -0700 (PDT)
Message-Id: <20210608.163006.1251722799035175174.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ping: Check return value of function
 'ping_queue_rcv_skb'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210608064246.3153202-1-zhengyongjun3@huawei.com>
References: <20210608064246.3153202-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Jun 2021 16:30:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Jun 2021 14:42:46 +0800

> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -954,6 +954,7 @@ bool ping_rcv(struct sk_buff *skb)
>  	struct sock *sk;
>  	struct net *net = dev_net(skb->dev);
>  	struct icmphdr *icmph = icmp_hdr(skb);
> +	bool rc = false;
>  
>  	/* We assume the packet has already been checked by icmp_rcv */
>  
> @@ -968,14 +969,13 @@ bool ping_rcv(struct sk_buff *skb)
>  		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
>  
>  		pr_debug("rcv on socket %p\n", sk);
> -		if (skb2)
> -			ping_queue_rcv_skb(sk, skb2);
> +		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
> +			rc = true;
>  		sock_put(sk);
> -		return true;
>  	}
>  	pr_debug("no socket, dropping\n");
>  
> -	return false;
> +	return rc;

YOu have chsanged the control flowe in a way that this pr_debug() can be inaccurate.
It can print when we did find a socket.

Please fix this.

Thank you.
