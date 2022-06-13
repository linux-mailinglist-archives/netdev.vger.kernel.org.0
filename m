Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126E054A1F2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 00:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiFMWMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 18:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiFMWMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 18:12:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F32BB30
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 15:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655158323; x=1686694323;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=iIOfypsh7+wY0SuY4vEhwe8lNo7zA5yZMcE/z5Kb7L4=;
  b=m03VJdG12jz0DrruHpFC3pEjwcju0XJVte7uPIzkbHn1DY/YPi30E8bM
   n/YNLhlOxdaT4Snhm3QqMbQlpUQHODiPlrzoXgNwezOTmR3OihBqx/DfT
   jXKMQX0Z/xL4MQ8Y51MmSuNCVg/za1GZesZcDYnerrBCZS9Rv0/W1QKUv
   qyqXs2Dk/67rz+GXSx5EpYTINktIjBZ0UxJ17RvaHGtHcpBTifAkJIxQh
   MIA/Qzlypc+mdwTn4+HzK2rsGimQ3+xFjv2+lGPMcSekMVQ20oC1076rw
   F2UfNy10gywmdzU75THGXe1OhnQWmdhnd3R979XezaBD4yxLX7moY0kZx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258872289"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="258872289"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 15:12:03 -0700
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="569511180"
Received: from jfgiesbe-mobl.amr.corp.intel.com ([10.209.95.28])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 15:12:03 -0700
Date:   Mon, 13 Jun 2022 15:12:03 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>
cc:     netdev@vger.kernel.org, edumazet@google.com, kafai@fb.com,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Subject: Re: [PATCH net-next v3 2/3] net: Add bhash2 hashbucket locks
In-Reply-To: <20220611021646.1578080-3-joannelkoong@gmail.com>
Message-ID: <5b6a4415-c4f-254c-3c54-7fa0dfde32e9@linux.intel.com>
References: <20220611021646.1578080-1-joannelkoong@gmail.com> <20220611021646.1578080-3-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022, Joanne Koong wrote:

> Currently, the bhash2 hashbucket uses its corresponding bhash
> hashbucket's lock for serializing concurrent accesses. There,
> however, can be the case where the bhash2 hashbucket is accessed
> concurrently by multiple processes that hash to different bhash
> hashbuckets but to the same bhash2 hashbucket.
>
> As such, each bhash2 hashbucket will need to have its own lock
> instead of using its corresponding bhash hashbucket's lock.
>
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> include/net/inet_hashtables.h   |  25 +++----
> net/dccp/proto.c                |   3 +-
> net/ipv4/inet_connection_sock.c |  60 +++++++++-------
> net/ipv4/inet_hashtables.c      | 119 +++++++++++++++-----------------
> net/ipv4/tcp.c                  |   7 +-
> 5 files changed, 107 insertions(+), 107 deletions(-)
>
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 2c331ce6ca73..c5b112f0938b 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -124,15 +124,6 @@ struct inet_bind_hashbucket {
> 	struct hlist_head	chain;
> };
>
> -/* This is synchronized using the inet_bind_hashbucket's spinlock.
> - * Instead of having separate spinlocks, the inet_bind2_hashbucket can share
> - * the inet_bind_hashbucket's given that in every case where the bhash2 table
> - * is useful, a lookup in the bhash table also occurs.
> - */
> -struct inet_bind2_hashbucket {
> -	struct hlist_head	chain;
> -};
> -
> /* Sockets can be hashed in established or listening table.
>  * We must use different 'nulls' end-of-chain value for all hash buckets :
>  * A socket might transition from ESTABLISH to LISTEN state without
> @@ -169,7 +160,7 @@ struct inet_hashinfo {
> 	 * conflicts.
> 	 */
> 	struct kmem_cache		*bind2_bucket_cachep;
> -	struct inet_bind2_hashbucket	*bhash2;
> +	struct inet_bind_hashbucket	*bhash2;
> 	unsigned int			bhash_size;
>
> 	/* The 2nd listener table hashed by local port and address */
> @@ -240,7 +231,7 @@ static inline bool check_bind_bucket_match(struct inet_bind_bucket *tb,
>
> struct inet_bind2_bucket *
> inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
> -			 struct inet_bind2_hashbucket *head,
> +			 struct inet_bind_hashbucket *head,
> 			 const unsigned short port, int l3mdev,
> 			 const struct sock *sk);
>
> @@ -248,12 +239,12 @@ void inet_bind2_bucket_destroy(struct kmem_cache *cachep,
> 			       struct inet_bind2_bucket *tb);
>
> struct inet_bind2_bucket *
> -inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
> +inet_bind2_bucket_find(struct inet_bind_hashbucket *head,
> +		       struct inet_hashinfo *hinfo, struct net *net,
> 		       const unsigned short port, int l3mdev,
> -		       struct sock *sk,
> -		       struct inet_bind2_hashbucket **head);
> +		       struct sock *sk);
>
> -bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb,
> +bool check_bind2_bucket_match_addr_any(struct inet_bind2_bucket *tb,
> 				       struct net *net,
> 				       const unsigned short port,
> 				       int l3mdev,
> @@ -265,6 +256,10 @@ static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
> 	return (lport + net_hash_mix(net)) & (bhash_size - 1);
> }
>
> +struct inet_bind_hashbucket *
> +inet_bhashfn_portaddr(struct inet_hashinfo *hinfo, const struct sock *sk,
> +		      const struct net *net, unsigned short port);
> +
> void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> 		    struct inet_bind2_bucket *tb2, const unsigned short snum);
>
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index 2e78458900f2..f4f2ad5f9c08 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -1182,7 +1182,7 @@ static int __init dccp_init(void)
> 		goto out_free_dccp_locks;
> 	}
>
> -	dccp_hashinfo.bhash2 = (struct inet_bind2_hashbucket *)
> +	dccp_hashinfo.bhash2 = (struct inet_bind_hashbucket *)
> 		__get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
>
> 	if (!dccp_hashinfo.bhash2) {
> @@ -1193,6 +1193,7 @@ static int __init dccp_init(void)
> 	for (i = 0; i < dccp_hashinfo.bhash_size; i++) {
> 		spin_lock_init(&dccp_hashinfo.bhash[i].lock);
> 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash[i].chain);
> +		spin_lock_init(&dccp_hashinfo.bhash2[i].lock);
> 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
> 	}
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index c0b7e6c21360..24a42e4d8234 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -131,14 +131,14 @@ static bool use_bhash2_on_bind(const struct sock *sk)
> 	return sk->sk_rcv_saddr != htonl(INADDR_ANY);
> }
>
> -static u32 get_bhash2_nulladdr_hash(const struct sock *sk, struct net *net,
> +static u32 get_bhash2_addr_any_hash(const struct sock *sk, struct net *net,
> 				    int port)
> {
> #if IS_ENABLED(CONFIG_IPV6)
> -	struct in6_addr nulladdr = {};
> +	struct in6_addr addr_any = {};
>
> 	if (sk->sk_family == AF_INET6)
> -		return ipv6_portaddr_hash(net, &nulladdr, port);
> +		return ipv6_portaddr_hash(net, &addr_any, port);
> #endif
> 	return ipv4_portaddr_hash(net, 0, port);
> }
> @@ -204,18 +204,18 @@ static bool check_bhash2_conflict(const struct sock *sk,
> 	return false;
> }
>
> -/* This should be called only when the corresponding inet_bind_bucket spinlock
> - * is held
> - */
> +/* This should be called only when the tb and tb2 hashbuckets' locks are held */
> static int inet_csk_bind_conflict(const struct sock *sk, int port,
> 				  struct inet_bind_bucket *tb,
> 				  struct inet_bind2_bucket *tb2, /* may be null */
> +				  struct inet_bind_hashbucket *head_tb2,
> 				  bool relax, bool reuseport_ok)
> {
> 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> 	kuid_t uid = sock_i_uid((struct sock *)sk);
> 	struct sock_reuseport *reuseport_cb;
> -	struct inet_bind2_hashbucket *head2;
> +	struct inet_bind_hashbucket *head_addr_any;
> +	bool addr_any_conflict = false;
> 	bool reuseport_cb_ok;
> 	struct sock *sk2;
> 	struct net *net;
> @@ -254,33 +254,39 @@ static int inet_csk_bind_conflict(const struct sock *sk, int port,
> 	/* check there's no conflict with an existing IPV6_ADDR_ANY (if ipv6) or
> 	 * INADDR_ANY (if ipv4) socket.
> 	 */
> -	hash = get_bhash2_nulladdr_hash(sk, net, port);
> -	head2 = &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> +	hash = get_bhash2_addr_any_hash(sk, net, port);
> +	head_addr_any = &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
>
> 	l3mdev = inet_sk_bound_l3mdev(sk);
> -	inet_bind_bucket_for_each(tb2, &head2->chain)
> -		if (check_bind2_bucket_match_nulladdr(tb2, net, port, l3mdev, sk))
> +
> +	if (head_addr_any != head_tb2)
> +		spin_lock_bh(&head_addr_any->lock);

Hi Joanne -

syzkaller is consistently hitting a warning here (about 10x per minute):

============================================
WARNING: possible recursive locking detected
5.19.0-rc1-00382-g78347e8e15bf #1 Not tainted
--------------------------------------------
sshd/352 is trying to acquire lock:
ffffc90000968640 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffffc90000968640 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: inet_csk_bind_conflict+0x4c4/0x8e0 net/ipv4/inet_connection_sock.c:263

but task is already holding lock:
ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: inet_csk_get_port+0x528/0xea0 net/ipv4/inet_connection_sock.c:497

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&tcp_hashinfo.bhash2[i].lock);
   lock(&tcp_hashinfo.bhash2[i].lock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

3 locks held by sshd/352:
  #0: ffff88810a500e70 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1679 [inline]
  #0: ffff88810a500e70 (sk_lock-AF_INET6){+.+.}-{0:0}, at: inet_listen+0x94/0x650 net/ipv4/af_inet.c:199
  #1: ffffc90000720060 (&tcp_hashinfo.bhash[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
  #1: ffffc90000720060 (&tcp_hashinfo.bhash[i].lock){+.-.}-{2:2}, at: inet_csk_get_port+0x3d7/0xea0 net/ipv4/inet_connection_sock.c:492
  #2: ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
  #2: ffffc90000883d28 (&tcp_hashinfo.bhash2[i].lock){+.-.}-{2:2}, at: inet_csk_get_port+0x528/0xea0 net/ipv4/inet_connection_sock.c:497

stack backtrace:
CPU: 0 PID: 352 Comm: sshd Not tainted 5.19.0-rc1-00382-g78347e8e15bf #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
  print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
  check_deadlock kernel/locking/lockdep.c:3031 [inline]
  validate_chain.cold+0x168/0x180 kernel/locking/lockdep.c:3816
  __lock_acquire+0xadb/0x17f0 kernel/locking/lockdep.c:5053
  lock_acquire kernel/locking/lockdep.c:5665 [inline]
  lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5630
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
  _raw_spin_lock_bh+0x34/0x40 kernel/locking/spinlock.c:178
  spin_lock_bh include/linux/spinlock.h:354 [inline]
  inet_csk_bind_conflict+0x4c4/0x8e0 net/ipv4/inet_connection_sock.c:263
  inet_csk_get_port+0x75d/0xea0 net/ipv4/inet_connection_sock.c:525
  inet_csk_listen_start+0x143/0x3d0 net/ipv4/inet_connection_sock.c:1188
  inet_listen+0x22f/0x650 net/ipv4/af_inet.c:228
  __sys_listen+0x189/0x260 net/socket.c:1810
  __do_sys_listen net/socket.c:1819 [inline]
  __se_sys_listen net/socket.c:1817 [inline]
  __x64_sys_listen+0x54/0x80 net/socket.c:1817
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f0d578c7027
Code: f0 ff ff 73 01 c3 48 8b 0d 66 fe 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 32 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 fe 0b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff6b837208 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f0d578c7027
RDX: 000000000000001c RSI: 0000000000000080 RDI: 0000000000000008
RBP: 0000000000000008 R08: 0000000000000004 R09: 0000000000000003
R10: 00007fff6b8371f4 R11: 0000000000000246 R12: 00007fff6b837280
R13: 00007fff6b837770 R14: 00007fff6b8372a0 R15: 000055d977b7b260
  </TASK>


CONFIG_LOCKDEP and CONFIG_PROVE_LOCKING will help reproduce this, it 
doesn't seem to be anything special that syzkaller is doing.


Regards,

Mat


> +
> +	inet_bind_bucket_for_each(tb2, &head_addr_any->chain)
> +		if (check_bind2_bucket_match_addr_any(tb2, net, port, l3mdev, sk))
> 			break;
>
> 	if (tb2 && check_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
> 					 reuseport_ok))
> -		return true;
> +		addr_any_conflict = true;
>
> -	return false;
> +	if (head_addr_any != head_tb2)
> +		spin_unlock_bh(&head_addr_any->lock);
> +
> +	return addr_any_conflict;
> }
>
> /*
>  * Find an open port number for the socket.  Returns with the
> - * inet_bind_hashbucket lock held.
> + * inet_bind_hashbucket locks held if successful.
>  */
> static struct inet_bind_hashbucket *
> inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret,
> 			struct inet_bind2_bucket **tb2_ret,
> -			struct inet_bind2_hashbucket **head2_ret, int *port_ret)
> +			struct inet_bind_hashbucket **head2_ret, int *port_ret)
> {
> 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> -	struct inet_bind2_hashbucket *head2;
> -	struct inet_bind_hashbucket *head;
> +	struct inet_bind_hashbucket *head, *head2;
> 	struct net *net = sock_net(sk);
> 	int i, low, high, attempt_half;
> 	struct inet_bind2_bucket *tb2;
> @@ -325,19 +331,22 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret,
> 			continue;
> 		head = &hinfo->bhash[inet_bhashfn(net, port,
> 						  hinfo->bhash_size)];
> +		head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> 		spin_lock_bh(&head->lock);
> -		tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
> -					     &head2);
> +		spin_lock_bh(&head2->lock);
> +
> +		tb2 = inet_bind2_bucket_find(head2, hinfo, net, port, l3mdev, sk);
> 		inet_bind_bucket_for_each(tb, &head->chain)
> 			if (check_bind_bucket_match(tb, net, port, l3mdev)) {
> 				if (!inet_csk_bind_conflict(sk, port, tb, tb2,
> -							    relax, false))
> +							    head2, relax, false))
> 					goto success;
> 				goto next_port;
> 			}
> 		tb = NULL;
> 		goto success;
> next_port:
> +		spin_unlock_bh(&head2->lock);
> 		spin_unlock_bh(&head->lock);
> 		cond_resched();
> 	}
> @@ -459,10 +468,9 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
> 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
> 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> 	bool bhash_created = false, bhash2_created = false;
> +	struct inet_bind_hashbucket *head, *head2;
> 	struct inet_bind2_bucket *tb2 = NULL;
> -	struct inet_bind2_hashbucket *head2;
> 	struct inet_bind_bucket *tb = NULL;
> -	struct inet_bind_hashbucket *head;
> 	struct net *net = sock_net(sk);
> 	int ret = 1, port = snum;
> 	bool found_port = false;
> @@ -480,13 +488,14 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
> 	} else {
> 		head = &hinfo->bhash[inet_bhashfn(net, port,
> 						  hinfo->bhash_size)];
> +		head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> 		spin_lock_bh(&head->lock);
> 		inet_bind_bucket_for_each(tb, &head->chain)
> 			if (check_bind_bucket_match(tb, net, port, l3mdev))
> 				break;
>
> -		tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
> -					     &head2);
> +		spin_lock_bh(&head2->lock);
> +		tb2 = inet_bind2_bucket_find(head2, hinfo, net, port, l3mdev, sk);
> 	}
>
> 	if (!tb) {
> @@ -513,7 +522,7 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
> 		if ((tb->fastreuse > 0 && reuse) ||
> 		    sk_reuseport_match(tb, sk))
> 			goto success;
> -		if (inet_csk_bind_conflict(sk, port, tb, tb2, true, true))
> +		if (inet_csk_bind_conflict(sk, port, tb, tb2, head2, true, true))
> 			goto fail_unlock;
> 	}
> success:
> @@ -533,6 +542,7 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
> 			inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep,
> 						  tb2);
> 	}
> +	spin_unlock_bh(&head2->lock);
> 	spin_unlock_bh(&head->lock);
> 	return ret;
> }
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 73f18134b2d5..8fe8010c1a00 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -83,7 +83,7 @@ struct inet_bind_bucket *inet_bind_bucket_create(struct kmem_cache *cachep,
>
> struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *cachep,
> 						   struct net *net,
> -						   struct inet_bind2_hashbucket *head,
> +						   struct inet_bind_hashbucket *head,
> 						   const unsigned short port,
> 						   int l3mdev,
> 						   const struct sock *sk)
> @@ -127,9 +127,7 @@ void inet_bind_bucket_destroy(struct kmem_cache *cachep, struct inet_bind_bucket
> 	}
> }
>
> -/* Caller must hold the lock for the corresponding hashbucket in the bhash table
> - * with local BH disabled
> - */
> +/* Caller must hold hashbucket lock for this tb with local BH disabled */
> void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb)
> {
> 	if (hlist_empty(&tb->owners)) {
> @@ -157,6 +155,9 @@ static void __inet_put_port(struct sock *sk)
> 	const int bhash = inet_bhashfn(sock_net(sk), inet_sk(sk)->inet_num,
> 			hashinfo->bhash_size);
> 	struct inet_bind_hashbucket *head = &hashinfo->bhash[bhash];
> +	struct inet_bind_hashbucket *head2 =
> +		inet_bhashfn_portaddr(hashinfo, sk, sock_net(sk),
> +				      inet_sk(sk)->inet_num);
> 	struct inet_bind2_bucket *tb2;
> 	struct inet_bind_bucket *tb;
>
> @@ -167,12 +168,15 @@ static void __inet_put_port(struct sock *sk)
> 	inet_sk(sk)->inet_num = 0;
> 	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
>
> +	spin_lock(&head2->lock);
> 	if (inet_csk(sk)->icsk_bind2_hash) {
> 		tb2 = inet_csk(sk)->icsk_bind2_hash;
> 		__sk_del_bind2_node(sk);
> 		inet_csk(sk)->icsk_bind2_hash = NULL;
> 		inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
> 	}
> +	spin_unlock(&head2->lock);
> +
> 	spin_unlock(&head->lock);
> }
>
> @@ -191,7 +195,9 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
> 	const int bhash = inet_bhashfn(sock_net(sk), port,
> 				       table->bhash_size);
> 	struct inet_bind_hashbucket *head = &table->bhash[bhash];
> -	struct inet_bind2_hashbucket *head_bhash2;
> +	struct inet_bind_hashbucket *head2 =
> +		inet_bhashfn_portaddr(table, child, sock_net(sk),
> +				      port);
> 	bool created_inet_bind_bucket = false;
> 	struct net *net = sock_net(sk);
> 	struct inet_bind2_bucket *tb2;
> @@ -199,9 +205,11 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
> 	int l3mdev;
>
> 	spin_lock(&head->lock);
> +	spin_lock(&head2->lock);
> 	tb = inet_csk(sk)->icsk_bind_hash;
> 	tb2 = inet_csk(sk)->icsk_bind2_hash;
> 	if (unlikely(!tb || !tb2)) {
> +		spin_unlock(&head2->lock);
> 		spin_unlock(&head->lock);
> 		return -ENOENT;
> 	}
> @@ -221,6 +229,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
> 			tb = inet_bind_bucket_create(table->bind_bucket_cachep,
> 						     net, head, port, l3mdev);
> 			if (!tb) {
> +				spin_unlock(&head2->lock);
> 				spin_unlock(&head->lock);
> 				return -ENOMEM;
> 			}
> @@ -233,17 +242,17 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
> 		l3mdev = inet_sk_bound_l3mdev(sk);
>
> bhash2_find:
> -		tb2 = inet_bind2_bucket_find(table, net, port, l3mdev, child,
> -					     &head_bhash2);
> +		tb2 = inet_bind2_bucket_find(head2, table, net, port, l3mdev, child);
> 		if (!tb2) {
> 			tb2 = inet_bind2_bucket_create(table->bind2_bucket_cachep,
> -						       net, head_bhash2, port,
> +						       net, head2, port,
> 						       l3mdev, child);
> 			if (!tb2)
> 				goto error;
> 		}
> 	}
> 	inet_bind_hash(child, tb, tb2, port);
> +	spin_unlock(&head2->lock);
> 	spin_unlock(&head->lock);
>
> 	return 0;
> @@ -251,6 +260,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
> error:
> 	if (created_inet_bind_bucket)
> 		inet_bind_bucket_destroy(table->bind_bucket_cachep, tb);
> +	spin_unlock(&head2->lock);
> 	spin_unlock(&head->lock);
> 	return -ENOMEM;
> }
> @@ -771,24 +781,24 @@ static bool check_bind2_bucket_match(struct inet_bind2_bucket *tb,
> 			tb->l3mdev == l3mdev && tb->rcv_saddr == sk->sk_rcv_saddr;
> }
>
> -bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb,
> +bool check_bind2_bucket_match_addr_any(struct inet_bind2_bucket *tb,
> 				       struct net *net, const unsigned short port,
> 				       int l3mdev, const struct sock *sk)
> {
> #if IS_ENABLED(CONFIG_IPV6)
> -	struct in6_addr nulladdr = {};
> +	struct in6_addr addr_any = {};
>
> 	if (sk->sk_family == AF_INET6)
> 		return net_eq(ib2_net(tb), net) && tb->port == port &&
> 			tb->l3mdev == l3mdev &&
> -			ipv6_addr_equal(&tb->v6_rcv_saddr, &nulladdr);
> +			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> 	else
> #endif
> 		return net_eq(ib2_net(tb), net) && tb->port == port &&
> 			tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
> }
>
> -static struct inet_bind2_hashbucket *
> +struct inet_bind_hashbucket *
> inet_bhashfn_portaddr(struct inet_hashinfo *hinfo, const struct sock *sk,
> 		      const struct net *net, unsigned short port)
> {
> @@ -803,55 +813,21 @@ inet_bhashfn_portaddr(struct inet_hashinfo *hinfo, const struct sock *sk,
> 	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> }
>
> -/* This should only be called when the spinlock for the socket's corresponding
> - * bind_hashbucket is held
> - */
> +/* The socket's bhash2 hashbucket spinlock must be held when this is called */
> struct inet_bind2_bucket *
> -inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
> -		       const unsigned short port, int l3mdev, struct sock *sk,
> -		       struct inet_bind2_hashbucket **head)
> +inet_bind2_bucket_find(struct inet_bind_hashbucket *head,
> +		       struct inet_hashinfo *hinfo, struct net *net,
> +		       const unsigned short port, int l3mdev, struct sock *sk)
> {
> 	struct inet_bind2_bucket *bhash2 = NULL;
> -	struct inet_bind2_hashbucket *h;
>
> -	h = inet_bhashfn_portaddr(hinfo, sk, net, port);
> -	inet_bind_bucket_for_each(bhash2, &h->chain) {
> +	inet_bind_bucket_for_each(bhash2, &head->chain)
> 		if (check_bind2_bucket_match(bhash2, net, port, l3mdev, sk))
> 			break;
> -	}
> -
> -	if (head)
> -		*head = h;
>
> 	return bhash2;
> }
>
> -/* the lock for the socket's corresponding bhash entry must be held */
> -static int __inet_bhash2_update_saddr(struct sock *sk,
> -				      struct inet_hashinfo *hinfo,
> -				      struct net *net, int port, int l3mdev)
> -{
> -	struct inet_bind2_hashbucket *head2;
> -	struct inet_bind2_bucket *tb2;
> -
> -	tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
> -				     &head2);
> -	if (!tb2) {
> -		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
> -					       net, head2, port, l3mdev, sk);
> -		if (!tb2)
> -			return -ENOMEM;
> -	}
> -
> -	/* Remove the socket's old entry from bhash2 */
> -	__sk_del_bind2_node(sk);
> -
> -	sk_add_bind2_node(sk, &tb2->owners);
> -	inet_csk(sk)->icsk_bind2_hash = tb2;
> -
> -	return 0;
> -}
> -
> /* This should be called if/when a socket's rcv saddr changes after it has
>  * been binded.
>  */
> @@ -862,17 +838,31 @@ int inet_bhash2_update_saddr(struct sock *sk)
> 	struct inet_bind_hashbucket *head;
> 	int port = inet_sk(sk)->inet_num;
> 	struct net *net = sock_net(sk);
> -	int err;
> +	struct inet_bind2_bucket *tb2;
>
> -	head = &hinfo->bhash[inet_bhashfn(net, port, hinfo->bhash_size)];
> +	head = inet_bhashfn_portaddr(hinfo, sk, net, port);
>
> 	spin_lock_bh(&head->lock);
>
> -	err = __inet_bhash2_update_saddr(sk, hinfo, net, port, l3mdev);
> +	tb2 = inet_bind2_bucket_find(head, hinfo, net, port, l3mdev, sk);
> +	if (!tb2) {
> +		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
> +					       net, head, port, l3mdev, sk);
> +		if (!tb2) {
> +			spin_unlock_bh(&head->lock);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	/* Remove the socket's old entry from bhash2 */
> +	__sk_del_bind2_node(sk);
> +
> +	sk_add_bind2_node(sk, &tb2->owners);
> +	inet_csk(sk)->icsk_bind2_hash = tb2;
>
> 	spin_unlock_bh(&head->lock);
>
> -	return err;
> +	return 0;
> }
>
> /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
> @@ -894,9 +884,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 			struct sock *, __u16, struct inet_timewait_sock **))
> {
> 	struct inet_hashinfo *hinfo = death_row->hashinfo;
> +	struct inet_bind_hashbucket *head, *head2;
> 	struct inet_timewait_sock *tw = NULL;
> -	struct inet_bind2_hashbucket *head2;
> -	struct inet_bind_hashbucket *head;
> 	int port = inet_sk(sk)->inet_num;
> 	struct net *net = sock_net(sk);
> 	struct inet_bind2_bucket *tb2;
> @@ -907,8 +896,6 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 	int l3mdev;
> 	u32 index;
>
> -	l3mdev = inet_sk_bound_l3mdev(sk);
> -
> 	if (port) {
> 		head = &hinfo->bhash[inet_bhashfn(net, port,
> 						  hinfo->bhash_size)];
> @@ -917,8 +904,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 		spin_lock_bh(&head->lock);
>
> 		if (prev_inaddr_any) {
> -			ret = __inet_bhash2_update_saddr(sk, hinfo, net, port,
> -							 l3mdev);
> +			ret = inet_bhash2_update_saddr(sk);
> 			if (ret) {
> 				spin_unlock_bh(&head->lock);
> 				return ret;
> @@ -937,6 +923,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 		return ret;
> 	}
>
> +	l3mdev = inet_sk_bound_l3mdev(sk);
> +
> 	inet_get_local_port_range(net, &low, &high);
> 	high++; /* [32768, 60999] -> [32768, 61000[ */
> 	remaining = high - low;
> @@ -1006,7 +994,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 	/* Find the corresponding tb2 bucket since we need to
> 	 * add the socket to the bhash2 table as well
> 	 */
> -	tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk, &head2);
> +	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> +	spin_lock(&head2->lock);
> +
> +	tb2 = inet_bind2_bucket_find(head2, hinfo, net, port, l3mdev, sk);
> 	if (!tb2) {
> 		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep, net,
> 					       head2, port, l3mdev, sk);
> @@ -1024,6 +1015,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>
> 	/* Head lock still held and bh's disabled */
> 	inet_bind_hash(sk, tb, tb2, port);
> +
> +	spin_unlock(&head2->lock);
> +
> 	if (sk_unhashed(sk)) {
> 		inet_sk(sk)->inet_sport = htons(port);
> 		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
> @@ -1037,6 +1031,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> 	return 0;
>
> error:
> +	spin_unlock_bh(&head2->lock);
> 	if (tb_created)
> 		inet_bind_bucket_destroy(hinfo->bind_bucket_cachep, tb);
> 	spin_unlock_bh(&head->lock);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9984d23a7f3e..1ebba8c27642 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4633,8 +4633,7 @@ void __init tcp_init(void)
> 		panic("TCP: failed to alloc ehash_locks");
> 	tcp_hashinfo.bhash =
> 		alloc_large_system_hash("TCP bind bhash tables",
> -					sizeof(struct inet_bind_hashbucket) +
> -					sizeof(struct inet_bind2_hashbucket),
> +					2 * sizeof(struct inet_bind_hashbucket),
> 					tcp_hashinfo.ehash_mask + 1,
> 					17, /* one slot per 128 KB of memory */
> 					0,
> @@ -4643,11 +4642,11 @@ void __init tcp_init(void)
> 					0,
> 					64 * 1024);
> 	tcp_hashinfo.bhash_size = 1U << tcp_hashinfo.bhash_size;
> -	tcp_hashinfo.bhash2 =
> -		(struct inet_bind2_hashbucket *)(tcp_hashinfo.bhash + tcp_hashinfo.bhash_size);
> +	tcp_hashinfo.bhash2 = tcp_hashinfo.bhash + tcp_hashinfo.bhash_size;
> 	for (i = 0; i < tcp_hashinfo.bhash_size; i++) {
> 		spin_lock_init(&tcp_hashinfo.bhash[i].lock);
> 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash[i].chain);
> +		spin_lock_init(&tcp_hashinfo.bhash2[i].lock);
> 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
> 	}
>
> -- 
> 2.30.2
>
>

--
Mat Martineau
Intel
