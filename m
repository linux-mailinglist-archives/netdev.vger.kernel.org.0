Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4A7487C72
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiAGSvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiAGSvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 13:51:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2896C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 10:51:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C85861F60
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 18:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F45EC36AED;
        Fri,  7 Jan 2022 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641581467;
        bh=uMg4ob9eDBa3FX/wyPGEJDMssaanifdwmWZn7+oXhp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CmzgHKVEJn4lCr2PvxtNBNlAA9Rz0tU50LVVfg/nCf6bc0T1q5mtTFMJwuT3toBvx
         7TkxFPYPZf50mXdDO+OENwKguX4SeCri5N0QEQvkTUJDhrQHDu4IIGPIZ1upTxLPZe
         xWhFpiCFovIT90twyy5S200IelebZWvqdlaeGveXAsOoSgwE5biyZdqZ2lLNz6V4Bg
         1JgpsGX1vvNmGKdhpmaFJucanJnuSRB/W89U4Abp2kYVT/4a4rNd2bVXWQF4i01PSH
         Ayhcz0Vvn45OT7mZIta0FvUjaF0YNKkLAEiS7s/sc8075FfJ9FkxO/Peerx/RaLAzk
         64DO0jteZtaaQ==
Date:   Fri, 7 Jan 2022 10:51:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS
 traffic
Message-ID: <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220102081253.9123-1-gal@nvidia.com>
References: <20220102081253.9123-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Jan 2022 10:12:53 +0200 Gal Pressman wrote:
> The cited Fixes commit introduced a memory leak when running kTLS
> traffic (with/without hardware offloads).
> I'm running nginx on the server side and wrk on the client side and get
> the following:
> 
>   unreferenced object 0xffff8881935e9b80 (size 224):
>   comm "softirq", pid 0, jiffies 4294903611 (age 43.204s)
>   hex dump (first 32 bytes):
>     80 9b d0 36 81 88 ff ff 00 00 00 00 00 00 00 00  ...6............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000efe2a999>] build_skb+0x1f/0x170
>     [<00000000ef521785>] mlx5e_skb_from_cqe_mpwrq_linear+0x2bc/0x610 [mlx5_core]
>     [<00000000945d0ffe>] mlx5e_handle_rx_cqe_mpwrq+0x264/0x9e0 [mlx5_core]
>     [<00000000cb675b06>] mlx5e_poll_rx_cq+0x3ad/0x17a0 [mlx5_core]
>     [<0000000018aac6a9>] mlx5e_napi_poll+0x28c/0x1b60 [mlx5_core]
>     [<000000001f3369d1>] __napi_poll+0x9f/0x560
>     [<00000000cfa11f72>] net_rx_action+0x357/0xa60
>     [<000000008653b8d7>] __do_softirq+0x282/0x94e
>     [<00000000644923c6>] __irq_exit_rcu+0x11f/0x170
>     [<00000000d4085f8f>] irq_exit_rcu+0xa/0x20
>     [<00000000d412fef4>] common_interrupt+0x7d/0xa0
>     [<00000000bfb0cebc>] asm_common_interrupt+0x1e/0x40
>     [<00000000d80d0890>] default_idle+0x53/0x70
>     [<00000000f2b9780e>] default_idle_call+0x8c/0xd0
>     [<00000000c7659e15>] do_idle+0x394/0x450
> 
> I'm not familiar with these areas of the code, but I've added this
> sk_defer_free_flush() to tls_sw_recvmsg() based on a hunch and it
> resolved the issue.
> 
> Eric, do you think this is the correct fix? Maybe we're missing a call
> to sk_defer_free_flush() in other places as well?

Any thoughts, Eric? Since the merge window is coming soon should 
we purge the defer free queue when socket is destroyed at least?
All the .read_sock callers will otherwise risk the leaks, it seems.

> Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  net/tls/tls_sw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 3f271e29812f..95e774f1b91f 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1990,6 +1990,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  
>  end:
>  	release_sock(sk);
> +	sk_defer_free_flush(sk);
>  	if (psock)
>  		sk_psock_put(sk, psock);
>  	return copied ? : err;

