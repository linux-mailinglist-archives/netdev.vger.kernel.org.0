Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04B458852
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 04:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhKVDW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 22:22:27 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:48837 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhKVDW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 22:22:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UxbMwFb_1637551159;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxbMwFb_1637551159)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Nov 2021 11:19:20 +0800
Date:   Mon, 22 Nov 2021 11:19:18 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Daxing Guo <guodaxing@huawei.com>
Cc:     netdev@vger.kernel.org, chenzhe@huawei.com,
        linux-s390@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] net/smc: loop in smc_listen
Message-ID: <YZsMNsNJFYe2MUJs@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211120075451.16764-1-guodaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120075451.16764-1-guodaxing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 20, 2021 at 03:54:51PM +0800, Daxing Guo wrote:
> From: Guo DaXing <guodaxing@huawei.com>
> 
> The kernel_listen function in smc_listen will fail when all the available
> ports are occupied.  At this point smc->clcsock->sk->sk_data_ready has 
> been changed to smc_clcsock_data_ready.  When we call smc_listen again, 
> now both smc->clcsock->sk->sk_data_ready and smc->clcsk_data_ready point 
> to the smc_clcsock_data_ready function.
> 
> The smc_clcsock_data_ready() function calls lsmc->clcsk_data_ready which 
> now points to itself resulting in an infinite loop.
> 
> This patch restores smc->clcsock->sk->sk_data_ready with the old value.

Hi Guo,

This indeed seems to be an issue. When listen fails, the original
clcsock's sk_data_ready overwrites by smc_clcsock_data_ready and can't
be recovered. I will also test it in my environment, thanks.

Cheers,
Tony Lu

> 
> Signed-off-by: Guo DaXing <guodaxing@huawei.com>
> ---
>  net/smc/af_smc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 59284da9116d..078f5edf6d4d 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2120,8 +2120,10 @@ static int smc_listen(struct socket *sock, int backlog)
>  	smc->clcsock->sk->sk_user_data =
>  		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
>  	rc = kernel_listen(smc->clcsock, backlog);
> -	if (rc)
> +	if (rc) {
> +		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
>  		goto out;
> +	}
>  	sk->sk_max_ack_backlog = backlog;
>  	sk->sk_ack_backlog = 0;
>  	sk->sk_state = SMC_LISTEN;
> -- 
> 2.20.1
