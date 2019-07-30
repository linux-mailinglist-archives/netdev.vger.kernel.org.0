Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1AE7B2C5
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388356AbfG3S55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfG3S55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 14:57:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 296A65AFF8;
        Tue, 30 Jul 2019 18:57:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33AA360625;
        Tue, 30 Jul 2019 18:57:55 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id F0470E161;
        Tue, 30 Jul 2019 18:57:51 +0000 (UTC)
Date:   Tue, 30 Jul 2019 14:57:51 -0400 (EDT)
From:   Xin Long <lxin@redhat.com>
To:     Jon Maloy <jon.maloy@ericsson.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        tung q nguyen <tung.q.nguyen@dektech.com.au>,
        hoang h le <hoang.h.le@dektech.com.au>, shuali@redhat.com,
        ying xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Message-ID: <1442944110.5765595.1564513071907.JavaMail.zimbra@redhat.com>
In-Reply-To: <1564510750-19531-1-git-send-email-jon.maloy@ericsson.com>
References: <1564510750-19531-1-git-send-email-jon.maloy@ericsson.com>
Subject: Re: [net  1/1] tipc: fix unitilized skb list crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.26]
Thread-Topic: tipc: fix unitilized skb list crash
Thread-Index: dq8OsEPjCMgc+wYGChFuimew4zf4cQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 30 Jul 2019 18:57:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> Our test suite somtimes provokes the following crash:
> 
> Description of problem:
> [ 1092.597234] BUG: unable to handle kernel NULL pointer dereference at
> 00000000000000e8
> [ 1092.605072] PGD 0 P4D 0
> [ 1092.607620] Oops: 0000 [#1] SMP PTI
> [ 1092.611118] CPU: 37 PID: 0 Comm: swapper/37 Kdump: loaded Not tainted
> 4.18.0-122.el8.x86_64 #1
> [ 1092.619724] Hardware name: Dell Inc. PowerEdge R740/08D89F, BIOS 1.3.7
> 02/08/2018
> [ 1092.627215] RIP: 0010:tipc_mcast_filter_msg+0x93/0x2d0 [tipc]
> [ 1092.632955] Code: 0f 84 aa 01 00 00 89 cf 4d 01 ca 4c 8b 26 c1 ef 19 83 e7
> 0f 83 ff 0c 4d 0f 45 d1 41 8b 6a 10 0f cd 4c 39 e6 0f 84 81 01 00 00 <4d> 8b
> 9c 24 e8 00 00 00 45 8b 13 41 0f ca 44 89 d7 c1 ef 13 83 e7
> [ 1092.651703] RSP: 0018:ffff929e5fa83a18 EFLAGS: 00010282
> [ 1092.656927] RAX: ffff929e3fb38100 RBX: 00000000069f29ee RCX:
> 00000000416c0045
> [ 1092.664058] RDX: ffff929e5fa83a88 RSI: ffff929e31a28420 RDI:
> 0000000000000000
> [ 1092.671209] RBP: 0000000029b11821 R08: 0000000000000000 R09:
> ffff929e39b4407a
> [ 1092.678343] R10: ffff929e39b4407a R11: 0000000000000007 R12:
> 0000000000000000
> [ 1092.685475] R13: 0000000000000001 R14: ffff929e3fb38100 R15:
> ffff929e39b4407a
> [ 1092.692614] FS:  0000000000000000(0000) GS:ffff929e5fa80000(0000)
> knlGS:0000000000000000
> [ 1092.700702] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1092.706447] CR2: 00000000000000e8 CR3: 000000031300a004 CR4:
> 00000000007606e0
> [ 1092.713579] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 1092.720712] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 1092.727843] PKRU: 55555554
> [ 1092.730556] Call Trace:
> [ 1092.733010]  <IRQ>
> [ 1092.735034]  tipc_sk_filter_rcv+0x7ca/0xb80 [tipc]
> [ 1092.739828]  ? __kmalloc_node_track_caller+0x1cb/0x290
> [ 1092.744974]  ? dev_hard_start_xmit+0xa5/0x210
> [ 1092.749332]  tipc_sk_rcv+0x389/0x640 [tipc]
> [ 1092.753519]  tipc_sk_mcast_rcv+0x23c/0x3a0 [tipc]
> [ 1092.758224]  tipc_rcv+0x57a/0xf20 [tipc]
> [ 1092.762154]  ? ktime_get_real_ts64+0x40/0xe0
> [ 1092.766432]  ? tpacket_rcv+0x50/0x9f0
> [ 1092.770098]  tipc_l2_rcv_msg+0x4a/0x70 [tipc]
> [ 1092.774452]  __netif_receive_skb_core+0xb62/0xbd0
> [ 1092.779164]  ? enqueue_entity+0xf6/0x630
> [ 1092.783084]  ? kmem_cache_alloc+0x158/0x1c0
> [ 1092.787272]  ? __build_skb+0x25/0xd0
> [ 1092.790849]  netif_receive_skb_internal+0x42/0xf0
> [ 1092.795557]  napi_gro_receive+0xba/0xe0
> [ 1092.799417]  mlx5e_handle_rx_cqe+0x83/0xd0 [mlx5_core]
> [ 1092.804564]  mlx5e_poll_rx_cq+0xd5/0x920 [mlx5_core]
> [ 1092.809536]  mlx5e_napi_poll+0xb2/0xce0 [mlx5_core]
> [ 1092.814415]  ? __wake_up_common_lock+0x89/0xc0
> [ 1092.818861]  net_rx_action+0x149/0x3b0
> [ 1092.822616]  __do_softirq+0xe3/0x30a
> [ 1092.826193]  irq_exit+0x100/0x110
> [ 1092.829512]  do_IRQ+0x85/0xd0
> [ 1092.832483]  common_interrupt+0xf/0xf
> [ 1092.836147]  </IRQ>
> [ 1092.838255] RIP: 0010:cpuidle_enter_state+0xb7/0x2a0
> [ 1092.843221] Code: e8 3e 79 a5 ff 80 7c 24 03 00 74 17 9c 58 0f 1f 44 00 00
> f6 c4 02 0f 85 d7 01 00 00 31 ff e8 a0 6b ab ff fb 66 0f 1f 44 00 00 <48> b8
> ff ff ff ff f3 01 00 00 4c 29 f3 ba ff ff ff 7f 48 39 c3 7f
> [ 1092.861967] RSP: 0018:ffffaa5ec6533e98 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffffdd
> [ 1092.869530] RAX: ffff929e5faa3100 RBX: 000000fe63dd2092 RCX:
> 000000000000001f
> [ 1092.876665] RDX: 000000fe63dd2092 RSI: 000000003a518aaa RDI:
> 0000000000000000
> [ 1092.883795] RBP: 0000000000000003 R08: 0000000000000004 R09:
> 0000000000022940
> [ 1092.890929] R10: 0000040cb0666b56 R11: ffff929e5faa20a8 R12:
> ffff929e5faade78
> [ 1092.898060] R13: ffffffffb59258f8 R14: 000000fe60f3228d R15:
> 0000000000000000
> [ 1092.905196]  ? cpuidle_enter_state+0x92/0x2a0
> [ 1092.909555]  do_idle+0x236/0x280
> [ 1092.912785]  cpu_startup_entry+0x6f/0x80
> [ 1092.916715]  start_secondary+0x1a7/0x200
> [ 1092.920642]  secondary_startup_64+0xb7/0xc0
> [...]
> 
> The reason is that the skb list tipc_socket::mc_method.deferredq only
> is initialized for connectionless sockets, while nothing stops arriving
> multicast messages from being filtered by connection oriented sockets,
> with subsequent access to the said list.
> 
> We fix this by initializing the list unconditionally at socket creation.
> This eliminates the crash, while the message still is dropped further
> down in tipc_sk_filter_rcv() as it should be.
> 
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
> ---
>  net/tipc/socket.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index dd8537f..83ae41d 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -485,9 +485,8 @@ static int tipc_sk_create(struct net *net, struct socket
> *sock,
>  		tsk_set_unreturnable(tsk, true);
>  		if (sock->type == SOCK_DGRAM)
>  			tsk_set_unreliable(tsk, true);
> -		__skb_queue_head_init(&tsk->mc_method.deferredq);
>  	}
> -
> +	__skb_queue_head_init(&tsk->mc_method.deferredq);
>  	trace_tipc_sk_create(sk, NULL, TIPC_DUMP_NONE, " ");
>  	return 0;
>  }
> --
> 2.1.4
> 
> 
Reviewed-by: Xin Long <lucien.xin@gmail.com>
