Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2813AED0E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUQHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 12:07:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:54438 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhFUQHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 12:07:06 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvMPn-000H08-Kj; Mon, 21 Jun 2021 18:04:47 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvMPn-0007il-EJ; Mon, 21 Jun 2021 18:04:47 +0200
Subject: Re: [PATCH net] vxlan: add missing rcu_read_lock() in neigh_reduce()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>, paulmck@kernel.org,
        toke@redhat.com, ast@kernel.org
References: <20210621144417.694367-1-eric.dumazet@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0966495e-1d6c-66b2-8269-6181d36f2b44@iogearbox.net>
Date:   Mon, 21 Jun 2021 18:04:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210621144417.694367-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26208/Mon Jun 21 13:09:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 4:44 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot complained in neigh_reduce(), because rcu_read_lock_bh()
> is treated differently than rcu_read_lock()
> 
> WARNING: suspicious RCU usage
> 5.13.0-rc6-syzkaller #0 Not tainted
> -----------------------------
> include/net/addrconf.h:313 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 3 locks held by kworker/0:0/5:
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>   #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
>   #1: ffffc90000ca7da8 ((work_completion)(&port->wq)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
>   #2: ffffffff8bf795c0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3130 net/core/dev.c:4180
> 
> stack backtrace:
> CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.13.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events ipvlan_process_multicast
> Call Trace:
>   __dump_stack lib/dump_stack.c:79 [inline]
>   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>   __in6_dev_get include/net/addrconf.h:313 [inline]
>   __in6_dev_get include/net/addrconf.h:311 [inline]
>   neigh_reduce drivers/net/vxlan.c:2167 [inline]
>   vxlan_xmit+0x34d5/0x4c30 drivers/net/vxlan.c:2919
>   __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4958 [inline]
>   xmit_one net/core/dev.c:3654 [inline]
>   dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3670
>   __dev_queue_xmit+0x2133/0x3130 net/core/dev.c:4246
>   ipvlan_process_multicast+0xa99/0xd70 drivers/net/ipvlan/ipvlan_core.c:287
>   process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
>   worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
>   kthread+0x3b1/0x4a0 kernel/kthread.c:313
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

[ +Paul/Toke ]

Only a side comment on this fix given the series under [0] where we remove the
rcu_read_lock() given covered by rcu_read_lock_bh():

   [...] It seems [1] that back in the early days of XDP, local_bh_disable() did
   not provide RCU protection, which is why the rcu_read_lock() calls were added
   to drivers in the first place. But according to Paul [2], in recent kernels
   a local_bh_disable()/local_bh_enable() pair functions as one big RCU
   read-side section, so no further protection is needed. This even applies to
   -rt kernels, which has an explicit rcu_read_lock() in place as part of the
   local_bh_disable() [3]. [...]

Paul/Toke, with regards to related questions under [1], I presume there should
additionally be a fixup for lockdep /in general/ to silence warning like these ?

   [0] https://lore.kernel.org/bpf/20210617212748.32456-1-toke@redhat.com/
   [1] https://lore.kernel.org/bpf/1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net/

> ---
>   drivers/net/vxlan.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 02a14f1b938ad50fc28044b7670ba5f6bf924345..5a8df5a195cb5700c45b4785355ef8ed84866052 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2164,6 +2164,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
>   	struct neighbour *n;
>   	struct nd_msg *msg;
>   
> +	rcu_read_lock();
>   	in6_dev = __in6_dev_get(dev);
>   	if (!in6_dev)
>   		goto out;
> @@ -2215,6 +2216,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
>   	}
>   
>   out:
> +	rcu_read_unlock();
>   	consume_skb(skb);
>   	return NETDEV_TX_OK;
>   }
> 

