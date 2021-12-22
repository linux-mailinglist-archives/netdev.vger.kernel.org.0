Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935AA47D959
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 23:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhLVWk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 17:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLVWkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 17:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACEBC061574;
        Wed, 22 Dec 2021 14:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E491B81D5D;
        Wed, 22 Dec 2021 22:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8DFC36AE5;
        Wed, 22 Dec 2021 22:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640212851;
        bh=6qEeLk/xTHymkuihoqv0pZtoehNFIves0KC6j1qFxEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VJ0wdbt7AYpuQtYBwxqxeFOyX+c/ogRCeMFAzMNjfGl+7w8AJn6d4fw0ZWbwQ88f2
         zcFFw0oT1gzzi0imwIqtZszh5mDWqgJD+MzKi2FcR7aWyzOPHgf6WdwbU0YcU4w8jv
         59N5FeHNQF88paiNqBJrPeyPPt+w1hIPJcKjmL7awrOveoMlMZCnp09wF/A+hiHXhD
         04wMeyA6DRT7p7+o6i/VyhMEGaCfYgj74E2Vm5U9gK49EczEc/1K1cc5YKoqt2pOGR
         Ou6mgQoYhtJ/wNWrogczudraJr920nkPG+VKQKmigU/eODX0tIK9C8MsmQ3EWBfJyx
         eyJ+1b1/QCOvg==
Date:   Wed, 22 Dec 2021 14:40:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH net] sctp: use call_rcu to free endpoint
Message-ID: <20211222144050.6a13ac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fc90434665ed92ac9e02cd6e5a9d7e64816b0847.1640116312.git.lucien.xin@gmail.com>
References: <fc90434665ed92ac9e02cd6e5a9d7e64816b0847.1640116312.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 14:51:52 -0500 Xin Long wrote:
> This patch is to delay the endpoint free by calling call_rcu() to fix
> another use-after-free issue in sctp_sock_dump():
> 
>   BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
>   Call Trace:
>     __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
>     lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>     _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
>     spin_lock_bh include/linux/spinlock.h:334 [inline]
>     __lock_sock+0x203/0x350 net/core/sock.c:2253
>     lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
>     lock_sock include/net/sock.h:1492 [inline]
>     sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
>     sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
>     sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
>     __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
>     inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
>     netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
>     __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
>     netlink_dump_start include/linux/netlink.h:216 [inline]
>     inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
>     __sock_diag_cmd net/core/sock_diag.c:232 [inline]
>     sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
>     netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
>     sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
> 
> This issue occurs when asoc is peeled off and the old sk is freed after
> getting sk by asoc->base.sk and before calling lock_sock(sk).
> 
> To prevent the ep/sk free, this patch is to call call_rcu to free the ep
> and hold it under rcu_read_lock to make sure that sk in sctp_sock_dump
> is still alive when calling lock_sock().

Could you clarify a little more where the RCU lock is held, it's not
obvious.

> Note that delaying endpint free won't delay the port release, as the port
> release happens in sctp_endpoint_destroy() before calling call_rcu().
> Also, freeing endpoint by call_rcu() makes it safe to access the sk by
> asoc->base.sk in sctp_assocs_seq_show() and sctp_rcv().
> 
> Thanks Jones to bring this issue up.
> 
> Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index 48c9c2c7602f..81fb97d382d7 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -184,6 +184,17 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
>  }
>  
>  /* Final destructor for endpoint.  */
> +static void sctp_endpoint_destroy_rcu(struct rcu_head *head)
> +{
> +	struct sctp_endpoint *ep = container_of(head, struct sctp_endpoint, rcu);
> +	struct sock *sk = ep->base.sk;
> +
> +	sctp_sk(sk)->ep = NULL;
> +	sock_put(sk);
> +
> +	SCTP_DBG_OBJCNT_DEC(ep);
> +}
> +
>  static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
>  {
>  	struct sock *sk;
> @@ -213,18 +224,13 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
>  	if (sctp_sk(sk)->bind_hash)
>  		sctp_put_port(sk);
>  
> -	sctp_sk(sk)->ep = NULL;
> -	/* Give up our hold on the sock */
> -	sock_put(sk);
> -
> -	kfree(ep);

where does this kfree() go after the change?

> -	SCTP_DBG_OBJCNT_DEC(ep);
> +	call_rcu(&ep->rcu, sctp_endpoint_destroy_rcu);
>  }
