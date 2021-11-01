Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4304422E5
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhKAVsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 17:48:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:53518 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhKAVsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 17:48:45 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhf86-000Co0-JF; Mon, 01 Nov 2021 22:46:10 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhf86-0007xa-EU; Mon, 01 Nov 2021 22:46:10 +0100
Subject: Re: [PATCH] net: core: set skb useful vars in __bpf_tx_skb
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
References: <20211029015431.32516-1-xiangxia.m.yue@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9deda78a-a9a2-6b0b-634d-07c5b77282a8@iogearbox.net>
Date:   Mon, 1 Nov 2021 22:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211029015431.32516-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 3:54 AM, xiangxia.m.yue@gmail.com wrote:
[...]
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 4bace37a6a44..2dbff0944768 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
>   		return -ENETDOWN;
>   	}
>   
> -	skb->dev = dev;
> +	/* The target netdevice (e.g. ifb) may use the:
> +	 * - skb_iif
> +	 * - redirected
> +	 * - from_ingress
> +	 */
> +	skb->skb_iif = skb->dev->ifindex;

This doesn't look right to me to set it unconditionally in tx path, isn't ifb_ri_tasklet()
setting skb->skb_iif in this case (or __netif_receive_skb_core() in main rx path)?

Also, I would suggest to add a proper BPF selftest which outlines the issue you're solving
in here.

> +#ifdef CONFIG_NET_CLS_ACT
> +	skb_set_redirected(skb, skb->tc_at_ingress);
> +#else
>   	skb->tstamp = 0;
> +#endif
>   
> +	skb->dev = dev;
>   	dev_xmit_recursion_inc();
>   	ret = dev_queue_xmit(skb);
>   	dev_xmit_recursion_dec();
> 

