Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6003D3CA7
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhGWPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhGWPDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB88760C51;
        Fri, 23 Jul 2021 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627055044;
        bh=vhxORIpUlFOlz7p1YyAS/UfRmjF+Aiod9z/B9WU45dc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d17zTnCr9JLhnCtYCuiVILkQ+lwK4yTgpCMDm+HZhgUL/mnqy2h8bjllIojs4vPaJ
         eUGtkl3ObvGBORX+NHbXDO6EhN+HGiITJHk0hCN9WT+tLMWofcaWDTx3YAmyBCz32o
         jgYXraP9rkJtQeGvsXTw+nvcah7BUyv901yQ4JiN3F9sRnZ8cd3y2kjP0kz7LvCHs0
         4O6Hmar785mEng8Serdnu6IW52cjza1755PERDNLtNqd1rtW8RfijvMO7MjPzPZLVk
         bbNidAUrC5hFS3euLftq0POnCYn/9kEdqKaq8dLw9no3Od/9gJBt1ldDhBKCiidOXi
         6+1MdARmX0JHw==
Date:   Fri, 23 Jul 2021 21:13:50 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, xiyou.wangcong@gmail.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: qrtr: fix memory leaks
Message-ID: <20210723154350.GB3739@thinkpad>
References: <20210723122753.GA3739@thinkpad>
 <20210723153132.6159-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723153132.6159-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 06:31:32PM +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in qrtr. The problem was in unputted
> struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
> which takes sock reference if port was found. Then there is the following
> check:
> 
> if (!ipc || &ipc->sk == skb->sk) {
> 	...
> 	return -ENODEV;
> }
> 
> Since we should drop the reference before returning from this function and
> ipc can be non-NULL inside this if, we should add qrtr_port_put() inside
> this if.
> 
> The similar corner case is in qrtr_endpoint_post() as Manivannan
> reported. In case of sock_queue_rcv_skb() failure we need to put
> port reference to avoid leaking struct sock pointer.
> 
> Fixes: e04df98adf7d ("net: qrtr: Remove receive worker")
> Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> Reported-and-tested-by: syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
> 
> Changes in v2:
> 	Added missing qrtr_port_put() in qrtr_endpoint_post() as Manivannan
> 	reported.
> 
> ---
>  net/qrtr/qrtr.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index b34358282f37..a8b2c9b21a8d 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -514,8 +514,10 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>  		if (!ipc)
>  			goto err;
>  
> -		if (sock_queue_rcv_skb(&ipc->sk, skb))
> +		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
> +			qrtr_port_put(ipc);
>  			goto err;
> +		}
>  
>  		qrtr_port_put(ipc);
>  	}
> @@ -850,6 +852,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  
>  	ipc = qrtr_port_lookup(to->sq_port);
>  	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
> +		if (ipc)
> +			qrtr_port_put(ipc);
>  		kfree_skb(skb);
>  		return -ENODEV;
>  	}
> -- 
> 2.32.0
> 
