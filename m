Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E539EE87
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 08:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFHGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 02:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhFHGKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 02:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A334461249;
        Tue,  8 Jun 2021 06:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623132511;
        bh=V7y3KKYMOPORYcYQS09ka3uXcIRK/hHqR2xD33b5Acc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SVAjoRhbLddAc6mKbdByXnAfi3nJqv+lQ++D3LQOFOUOe9w7xGFeNfAtiuND1CrlU
         meO43xVzjIcjmHJWy8Vzx4Z4AxfPe46HlMRDwmNTMbHWj9iTjyzdlWfDViCCIksX/H
         e8xBKxP3N27vuKKyizTX5z+w5x+TRB8PLiISBXvalDqFt2DaXYJSR8LMM/XJPGDA5J
         13iEVnZLCxaa18/MUlWkIiVQi4t0FvzCJI4RouTRfumE8unX0lHmP+XrIXC1f9s0ho
         TXqKUvtUdjJy4nEMVBh/2uyxEl3r95mIqTWF69R8u5fws5AVQ9mTeqSynyxQcJyQN5
         +b59VY81wHmyg==
Date:   Tue, 8 Jun 2021 09:08:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ping: Check return value of function
 'ping_queue_rcv_skb'
Message-ID: <YL8JWqVbhMtfPJbb@unreal>
References: <20210608020853.3091939-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608020853.3091939-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:08:53AM +0800, Zheng Yongjun wrote:
> Function 'ping_queue_rcv_skb' not always return success, which will
> also return fail. If not check the wrong return value of it, lead
> to function `ping_rcv` return success.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
> v2:
> - use rc as return value to make code look cleaner
> v3:
> - delete unnecessary braces {}
>  net/ipv4/ping.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 1c9f71a37258..af9da2f7dc85 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -963,19 +963,19 @@ bool ping_rcv(struct sk_buff *skb)
>  	/* Push ICMP header back */
>  	skb_push(skb, skb->data - (u8 *)icmph);
>  
> +	bool rc = false;

Declaration of new variables in the middle of function is C++, while the
kernel is written in C. Please put variable declaration at the beginning
of function.

Thanks

>  	sk = ping_lookup(net, skb, ntohs(icmph->un.echo.id));
>  	if (sk) {
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
>  }
>  EXPORT_SYMBOL_GPL(ping_rcv);
>  
> -- 
> 2.25.1
> 
