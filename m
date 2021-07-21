Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0843D07F6
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 06:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhGUENG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 00:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232111AbhGUEMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 00:12:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BAB660FEA;
        Wed, 21 Jul 2021 04:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626843203;
        bh=mDa1rDfrIXtro6deqjsDirToTVzuK/l7EiZ3+TqwAso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5Ul9FUS17/5PvN/tQ+Xwxel/pAGSVH99WSsdoehD3yHfMtazCk7byFEmb07ozMPU
         o5nUOcd3BVdbh+AaMHLGeMcBck5zpWNWnD4/YE0Wq7puiG3w//vUYNpU1HtuzYMvYZ
         mbaCH3Kh39+1E22oo+KGlEej+IEHXwEOK94ybCjI=
Date:   Wed, 21 Jul 2021 06:53:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, socketcan@hartkopp.net,
        mkl@pengutronix.de, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
Message-ID: <YPeoQG19PSh3B3Dc@kroah.com>
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721010937.670275-1-william.xuanziyang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 09:09:37AM +0800, Ziyang Xuan wrote:
> We get a bug during ltp can_filter test as following.
> 
> ===========================================
> [60919.264984] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [60919.265223] PGD 8000003dda726067 P4D 8000003dda726067 PUD 3dda727067 PMD 0
> [60919.265443] Oops: 0000 [#1] SMP PTI
> [60919.265550] CPU: 30 PID: 3638365 Comm: can_filter Kdump: loaded Tainted: G        W         4.19.90+ #1
> [60919.266068] RIP: 0010:selinux_socket_sock_rcv_skb+0x3e/0x200
> [60919.293289] RSP: 0018:ffff8d53bfc03cf8 EFLAGS: 00010246
> [60919.307140] RAX: 0000000000000000 RBX: 000000000000001d RCX: 0000000000000007
> [60919.320756] RDX: 0000000000000001 RSI: ffff8d5104a8ed00 RDI: ffff8d53bfc03d30
> [60919.334319] RBP: ffff8d9338056800 R08: ffff8d53bfc29d80 R09: 0000000000000001
> [60919.347969] R10: ffff8d53bfc03ec0 R11: ffffb8526ef47c98 R12: ffff8d53bfc03d30
> [60919.350320] perf: interrupt took too long (3063 > 2500), lowering kernel.perf_event_max_sample_rate to 65000
> [60919.361148] R13: 0000000000000001 R14: ffff8d53bcf90000 R15: 0000000000000000
> [60919.361151] FS:  00007fb78b6b3600(0000) GS:ffff8d53bfc00000(0000) knlGS:0000000000000000
> [60919.400812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [60919.413730] CR2: 0000000000000010 CR3: 0000003e3f784006 CR4: 00000000007606e0
> [60919.426479] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [60919.439339] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [60919.451608] PKRU: 55555554
> [60919.463622] Call Trace:
> [60919.475617]  <IRQ>
> [60919.487122]  ? update_load_avg+0x89/0x5d0
> [60919.498478]  ? update_load_avg+0x89/0x5d0
> [60919.509822]  ? account_entity_enqueue+0xc5/0xf0
> [60919.520709]  security_sock_rcv_skb+0x2a/0x40
> [60919.531413]  sk_filter_trim_cap+0x47/0x1b0
> [60919.542178]  ? kmem_cache_alloc+0x38/0x1b0
> [60919.552444]  sock_queue_rcv_skb+0x17/0x30
> [60919.562477]  raw_rcv+0x110/0x190 [can_raw]
> [60919.572539]  can_rcv_filter+0xbc/0x1b0 [can]
> [60919.582173]  can_receive+0x6b/0xb0 [can]
> [60919.591595]  can_rcv+0x31/0x70 [can]
> [60919.600783]  __netif_receive_skb_one_core+0x5a/0x80
> [60919.609864]  process_backlog+0x9b/0x150
> [60919.618691]  net_rx_action+0x156/0x400
> [60919.627310]  ? sched_clock_cpu+0xc/0xa0
> [60919.635714]  __do_softirq+0xe8/0x2e9
> [60919.644161]  do_softirq_own_stack+0x2a/0x40
> [60919.652154]  </IRQ>
> [60919.659899]  do_softirq.part.17+0x4f/0x60
> [60919.667475]  __local_bh_enable_ip+0x60/0x70
> [60919.675089]  __dev_queue_xmit+0x539/0x920
> [60919.682267]  ? finish_wait+0x80/0x80
> [60919.689218]  ? finish_wait+0x80/0x80
> [60919.695886]  ? sock_alloc_send_pskb+0x211/0x230
> [60919.702395]  ? can_send+0xe5/0x1f0 [can]
> [60919.708882]  can_send+0xe5/0x1f0 [can]
> [60919.715037]  raw_sendmsg+0x16d/0x268 [can_raw]
> 
> It's because raw_setsockopt() concurrently with
> unregister_netdevice_many(). Concurrent scenario as following.
> 
> 	cpu0						cpu1
> raw_bind
> raw_setsockopt					unregister_netdevice_many
> 						unlist_netdevice
> dev_get_by_index				raw_notifier
> raw_enable_filters				......
> can_rx_register
> can_rcv_list_find(..., net->can.rx_alldev_list)
> 
> ......
> 
> sock_close
> raw_release(sock_a)
> 
> ......
> 
> can_receive
> can_rcv_filter(net->can.rx_alldev_list, ...)
> raw_rcv(skb, sock_a)
> BUG
> 
> After unlist_netdevice(), dev_get_by_index() return NULL in
> raw_setsockopt(). Function raw_enable_filters() will add sock
> and can_filter to net->can.rx_alldev_list. Then the sock is closed.
> Followed by, we sock_sendmsg() to a new vcan device use the same
> can_filter. Protocol stack match the old receiver whose sock has
> been released on net->can.rx_alldev_list in can_rcv_filter().
> Function raw_rcv() uses the freed sock. UAF BUG is triggered.
> 
> We can find that the key issue is that net_device has not been
> protected in raw_setsockopt(). Use rtnl_lock to protect net_device
> in raw_setsockopt().
> 
> Fixes: c18ce101f2e4 ("[CAN]: Add raw protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/can/raw.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/can/raw.c b/net/can/raw.c
> index ed4fcb7ab0c3..a63e9915c66a 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -546,6 +546,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>  				return -EFAULT;
>  		}
>  
> +		rtnl_lock();
>  		lock_sock(sk);
>  
>  		if (ro->bound && ro->ifindex)
> @@ -588,6 +589,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>  			dev_put(dev);
>  
>  		release_sock(sk);
> +		rtnl_unlock();
>  
>  		break;
>  
> @@ -600,6 +602,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>  
>  		err_mask &= CAN_ERR_MASK;
>  
> +		rtnl_lock();
>  		lock_sock(sk);
>  
>  		if (ro->bound && ro->ifindex)
> @@ -627,6 +630,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>  			dev_put(dev);
>  
>  		release_sock(sk);
> +		rtnl_unlock();
>  
>  		break;
>  
> -- 
> 2.25.1
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
