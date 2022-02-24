Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB44C3187
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiBXQfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiBXQf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:35:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B461E503E;
        Thu, 24 Feb 2022 08:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645720496; x=1677256496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sZo1dKoT1ZvTnpA6N1vZm61Emhx8fsuWyOHmngWIuy8=;
  b=AsP2Bz+11Nuq3XtdQp8nidHo78ha0KUrN3zAkNZLRtwjXULbohdRDPyY
   8WpI+HcL+fuCxm5hpVmQ37jOJNLoXQxmwuC3MaiD311Yh6QFkiRsok+K8
   YEiwcJe+rIToBMg3mhvQP5J+f690noVKA6lfu4WYuwvPVtSu3MOZiNK4y
   AAxpTiunlwNn5X6wQdXTJPhjEVuiVzJkAQssMDIq7UcKNPEpZz9dU710f
   F+t+pjHPB0NSvraCTs3h7R8fshMz/BKRLe51MbD/EY3SL932Kw/q3RAkj
   5iiRd1qzjJ30BFnHEd0RVOgllfLnwZOO+1hZyoBfyKPNVoIE/5m9xJlYf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252468272"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="252468272"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 08:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="506373453"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 24 Feb 2022 08:27:33 -0800
Date:   Thu, 24 Feb 2022 17:27:32 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Elza Mathew <elza.mathew@intel.com>
Subject: Re: [PATCH bpf] xsk: fix race at socket teardown
Message-ID: <Yhex9EuXMVS+wZhq@boxer>
References: <20220222094347.6010-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222094347.6010-1-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:43:47AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a race in the xsk socket teardown code that can lead to a null
> pointer dereference splat. The current xsk unbind code in
> xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> xs->dev to NULL and then waits for any NAPI processing to terminate
> using synchronize_net(). After that, the release code starts to tear
> down the socket state and free allocated memory.
> 
> BUG: kernel NULL pointer dereference, address: 00000000000000c0
> PGD 8000000932469067 P4D 8000000932469067 PUD 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 25 PID: 69132 Comm: grpcpp_sync_ser Tainted: G          I       5.16.0+ #2
> Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2.10 03/09/2015
> RIP: 0010:__xsk_sendmsg+0x2c/0x690
> Code: 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 38 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 48 8b 87 08 03 00 00 <f6> 80 c0 00 00 00 01 >
> RSP: 0018:ffffa2348bd13d50 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000040 RCX: ffff8d5fc632d258
> RDX: 0000000000400000 RSI: ffffa2348bd13e10 RDI: ffff8d5fc5489800
> RBP: ffffa2348bd13db0 R08: 0000000000000000 R09: 00007ffffffff000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8d5fc5489800
> R13: ffff8d5fcb0f5140 R14: ffff8d5fcb0f5140 R15: 0000000000000000
> FS:  00007f991cff9400(0000) GS:ffff8d6f1f700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000000c0 CR3: 0000000114888005 CR4: 00000000001706e0
> Call Trace:
> <TASK>
> ? aa_sk_perm+0x43/0x1b0
> xsk_sendmsg+0xf0/0x110
> sock_sendmsg+0x65/0x70
> __sys_sendto+0x113/0x190
> ? debug_smp_processor_id+0x17/0x20
> ? fpregs_assert_state_consistent+0x23/0x50
> ? exit_to_user_mode_prepare+0xa5/0x1d0
> __x64_sys_sendto+0x29/0x30
> do_syscall_64+0x3b/0xc0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> There are two problems with the current code. First, setting xs->dev
> to NULL before waiting for all users to stop using the socket is not
> correct. The entry to the data plane functions xsk_poll(),
> xsk_sendmsg(), and xsk_recvmsg() are all guarded by a test that
> xs->state is in the state XSK_BOUND and if not, it returns right
> away. But one process might have passed this test but still have not
> gotten to the point in which it uses xs->dev in the code. In this
> interim, a second process executing xsk_unbind_dev() might have set
> xs->dev to NULL which will lead to a crash for the first process. The
> solution here is just to get rid of this NULL assignment since it is
> not used anymore. Before commit 42fddcc7c64b ("xsk: use state member
> for socket synchronization"), xs->dev was the gatekeeper to admit
> processes into the data plane functions, but it was replaced with the
> state variable xs->state in the aforementioned commit.
> 
> The second problem is that synchronize_net() does not wait for any
> process in xsk_poll(), xsk_sendmsg(), or xsk_recvmsg() to complete,
> which means that the state they rely on might be cleaned up
> prematurely. This can happen when the notifier gets called (at driver
> unload for example) as it uses xsk_unbind_dev(). Solve this by
> extending the RCU critical region from just the ndo_xsk_wakeup to the
> whole functions mentioned above, so that both the test of xs->state ==
> XSK_BOUND and the last use of any member of xs is covered by the RCU
> critical section. This will guarantee that when synchronize_net()
> completes, there will be no processes left executing xsk_poll(),
> xsk_sendmsg(), or xsk_recvmsg() and state can be cleaned up
> safely. Note that we need to drop the RCU lock for the SKB xmit path
> as it uses functions that might sleep. Due to this, we have to retest
> the xs->state after we grab the mutex that protects the SKB xmit code
> from, among a number of things, an xsk_unbind_dev() being executed
> from the notifier at the same time.
> 
> Fixes: 42fddcc7c64b ("xsk: use state member for socket synchronization")
> Reported-by: Elza Mathew <elza.mathew@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk.c | 75 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 53 insertions(+), 22 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 28ef3f4465ae..e506635b1981 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -400,21 +400,11 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
>  }
>  EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
>  
> -static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
> +static int xsk_zc_xmit(struct xdp_sock *xs, u8 flags)
>  {
>  	struct net_device *dev = xs->dev;
> -	int err;
> -
> -	rcu_read_lock();
> -	err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
> -	rcu_read_unlock();
> -
> -	return err;
> -}
>  
> -static int xsk_zc_xmit(struct xdp_sock *xs)
> -{
> -	return xsk_wakeup(xs, XDP_WAKEUP_TX);
> +	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
>  }
>  
>  static void xsk_destruct_skb(struct sk_buff *skb)
> @@ -533,6 +523,12 @@ static int xsk_generic_xmit(struct sock *sk)
>  
>  	mutex_lock(&xs->mutex);
>  
> +	/* Since we dropped the RCU read lock, the socket state might have changed. */
> +	if (unlikely(!xsk_is_bound(xs))) {
> +		err = -ENXIO;
> +		goto out;
> +	}
> +
>  	if (xs->queue_id >= xs->dev->real_num_tx_queues)
>  		goto out;
>  
> @@ -596,16 +592,26 @@ static int xsk_generic_xmit(struct sock *sk)
>  	return err;
>  }
>  
> -static int __xsk_sendmsg(struct sock *sk)
> +static int xsk_xmit(struct sock *sk)
>  {
>  	struct xdp_sock *xs = xdp_sk(sk);
> +	int ret;
>  
>  	if (unlikely(!(xs->dev->flags & IFF_UP)))
>  		return -ENETDOWN;
>  	if (unlikely(!xs->tx))
>  		return -ENOBUFS;
>  
> -	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
> +	if (xs->zc)
> +		return xsk_zc_xmit(xs, XDP_WAKEUP_TX);
> +
> +	/* Drop the RCU lock since the SKB path might sleep. */
> +	rcu_read_unlock();
> +	ret = xsk_generic_xmit(sk);
> +	/* Reaquire RCU lock before going into common code. */
> +	rcu_read_lock();
> +
> +	return ret;
>  }
>  
>  static bool xsk_no_wakeup(struct sock *sk)
> @@ -619,7 +625,7 @@ static bool xsk_no_wakeup(struct sock *sk)
>  #endif
>  }
>  
> -static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> +static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  {
>  	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
>  	struct sock *sk = sock->sk;
> @@ -639,11 +645,22 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  
>  	pool = xs->pool;
>  	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
> -		return __xsk_sendmsg(sk);
> +		return xsk_xmit(sk);
>  	return 0;
>  }
>  
> -static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
> +static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = __xsk_sendmsg(sock, m, total_len);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
> +static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
>  {
>  	bool need_wait = !(flags & MSG_DONTWAIT);
>  	struct sock *sk = sock->sk;
> @@ -665,10 +682,21 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
>  		return 0;
>  
>  	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
> -		return xsk_wakeup(xs, XDP_WAKEUP_RX);
> +		return xsk_zc_xmit(xs, XDP_WAKEUP_RX);

Feels a bit contradictory to have xmit func with rx flag, no?
Could we keep it as xsk_wakeup instead?

>  	return 0;
>  }
>  
> +static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = __xsk_recvmsg(sock, m, len, flags);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  static __poll_t xsk_poll(struct file *file, struct socket *sock,
>  			     struct poll_table_struct *wait)
>  {
> @@ -679,17 +707,20 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>  
>  	sock_poll_wait(file, sock, wait);
>  
> -	if (unlikely(!xsk_is_bound(xs)))
> +	rcu_read_lock();
> +	if (unlikely(!xsk_is_bound(xs))) {
> +		rcu_read_unlock();
>  		return mask;
> +	}
>  
>  	pool = xs->pool;
>  
>  	if (pool->cached_need_wakeup) {
>  		if (xs->zc)
> -			xsk_wakeup(xs, pool->cached_need_wakeup);
> +			xsk_zc_xmit(xs, pool->cached_need_wakeup);
>  		else
>  			/* Poll needs to drive Tx also in copy mode */
> -			__xsk_sendmsg(sk);
> +			xsk_xmit(sk);
>  	}
>  
>  	if (xs->rx && !xskq_prod_is_empty(xs->rx))
> @@ -697,6 +728,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
>  	if (xs->tx && xsk_tx_writeable(xs))
>  		mask |= EPOLLOUT | EPOLLWRNORM;
>  
> +	rcu_read_unlock();
>  	return mask;
>  }
>  
> @@ -728,7 +760,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>  
>  	/* Wait for driver to stop using the xdp socket. */
>  	xp_del_xsk(xs->pool, xs);
> -	xs->dev = NULL;
>  	synchronize_net();
>  	dev_put(dev);
>  }
> 
> base-commit: 8940e6b669ca1196ce0a0549c819078096390f76
> -- 
> 2.34.1
> 
