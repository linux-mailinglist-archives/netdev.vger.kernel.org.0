Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14F1547801
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 02:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiFLAZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 20:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiFLAZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 20:25:06 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95F03D491
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 17:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1654993504; x=1686529504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ByoiAPjFG4rHEfUkeWyglZmfDjSdamPVnhIF86pzW7M=;
  b=TSLxaASNh6xnv5ni+9EHIGOLuRhBc34CUAA4uxAlnBoBXLL9FmlGmkWT
   fiAt/Y9hPs2NYvwUrHTHyUf9+ZgWbwOI/ilckREc3QUsUqIA1Gq2JZuqB
   1XsiCwqQVQpZN4CSHsq7P5s7dz1QXMr+HGgvIEkwxyrTDFNeLSt9xbTfe
   U=;
X-IronPort-AV: E=Sophos;i="5.91,294,1647302400"; 
   d="scan'208";a="201537076"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 12 Jun 2022 00:24:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id C5363813D7;
        Sun, 12 Jun 2022 00:24:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 12 Jun 2022 00:24:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.74) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 12 Jun 2022 00:24:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <joannelkoong@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <mathew.j.martineau@linux.intel.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com>
Subject: Re: [PATCH net-next v3 1/3] net: Update bhash2 when socket's rcv saddr changes
Date:   Sat, 11 Jun 2022 17:24:32 -0700
Message-ID: <20220612002432.38952-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220611021646.1578080-2-joannelkoong@gmail.com>
References: <20220611021646.1578080-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.74]
X-ClientProxiedBy: EX13D48UWB001.ant.amazon.com (10.43.163.80) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 10 Jun 2022 19:16:44 -0700
> Commit d5a42de8bdbe ("net: Add a second bind table hashed by port and
> address") added a second bind table, bhash2, that hashes by a socket's port
> and rcv address.
> 
> However, there are two cases where the socket's rcv saddr can change
> after it has been binded:
> 
> 1) The case where there is a bind() call on "::" (IPADDR_ANY) and then
> a connect() call. The kernel will assign the socket an address when it
> handles the connect()
> 
> 2) In inet_sk_reselect_saddr(), which is called when rerouting fails
> when rebuilding the sk header (invoked by inet_sk_rebuild_header)
> 
> In these two cases, we need to update the bhash2 table by removing the
> entry for the old address, and adding a new entry reflecting the updated
> address.
> 
> Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/inet_hashtables.h |  6 ++-
>  include/net/ipv6.h            |  2 +-
>  net/dccp/ipv4.c               | 10 +++--
>  net/dccp/ipv6.c               |  4 +-
>  net/ipv4/af_inet.c            |  7 +++-
>  net/ipv4/inet_hashtables.c    | 70 ++++++++++++++++++++++++++++++++---
>  net/ipv4/tcp_ipv4.c           |  8 +++-
>  net/ipv6/inet6_hashtables.c   |  4 +-
>  net/ipv6/tcp_ipv6.c           |  4 +-
>  9 files changed, 97 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index a0887b70967b..2c331ce6ca73 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -448,11 +448,13 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
>  }
>  
>  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> -			struct sock *sk, u64 port_offset,
> +			struct sock *sk, u64 port_offset, bool prev_inaddr_any,
>  			int (*check_established)(struct inet_timewait_death_row *,
>  						 struct sock *, __u16,
>  						 struct inet_timewait_sock **));
>  
>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		      struct sock *sk);
> +		      struct sock *sk, bool prev_inaddr_any);
> +
> +int inet_bhash2_update_saddr(struct sock *sk);
>  #endif /* _INET_HASHTABLES_H */
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index de9dcc5652c4..735f7b4d55dc 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1187,7 +1187,7 @@ int inet6_compat_ioctl(struct socket *sock, unsigned int cmd,
>  		unsigned long arg);
>  
>  int inet6_hash_connect(struct inet_timewait_death_row *death_row,
> -			      struct sock *sk);
> +		       struct sock *sk, bool prev_inaddr_any);
>  int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
>  int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  		  int flags);
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index da6e3b20cd75..37a8bc3ee49e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -47,12 +47,13 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct dccp_sock *dp = dccp_sk(sk);
> +	struct ip_options_rcu *inet_opt;
>  	__be16 orig_sport, orig_dport;
> +	bool prev_inaddr_any = false;
>  	__be32 daddr, nexthop;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	int err;
> -	struct ip_options_rcu *inet_opt;
>  
>  	dp->dccps_role = DCCP_ROLE_CLIENT;
>  
> @@ -89,8 +90,11 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	if (inet_opt == NULL || !inet_opt->opt.srr)
>  		daddr = fl4->daddr;
>  
> -	if (inet->inet_saddr == 0)
> +	if (inet->inet_saddr == 0) {
>  		inet->inet_saddr = fl4->saddr;
> +		prev_inaddr_any = true;
> +	}
> +
>  	sk_rcv_saddr_set(sk, inet->inet_saddr);
>  	inet->inet_dport = usin->sin_port;
>  	sk_daddr_set(sk, daddr);
> @@ -105,7 +109,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * complete initialization after this.
>  	 */
>  	dccp_set_state(sk, DCCP_REQUESTING);
> -	err = inet_hash_connect(&dccp_death_row, sk);
> +	err = inet_hash_connect(&dccp_death_row, sk, prev_inaddr_any);
>  	if (err != 0)
>  		goto failure;
>  
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index fd44638ec16b..03013522acab 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -824,6 +824,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	struct ipv6_pinfo *np = inet6_sk(sk);
>  	struct dccp_sock *dp = dccp_sk(sk);
>  	struct in6_addr *saddr = NULL, *final_p, final;
> +	bool prev_inaddr_any = false;
>  	struct ipv6_txoptions *opt;
>  	struct flowi6 fl6;
>  	struct dst_entry *dst;
> @@ -936,6 +937,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	if (saddr == NULL) {
>  		saddr = &fl6.saddr;
>  		sk->sk_v6_rcv_saddr = *saddr;
> +		prev_inaddr_any = true;
>  	}
>  
>  	/* set the source address */
> @@ -951,7 +953,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	inet->inet_dport = usin->sin6_port;
>  
>  	dccp_set_state(sk, DCCP_REQUESTING);
> -	err = inet6_hash_connect(&dccp_death_row, sk);
> +	err = inet6_hash_connect(&dccp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto late_failure;
>  
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 30e0e8992085..9785f8f428b0 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1221,10 +1221,11 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  	struct inet_sock *inet = inet_sk(sk);
>  	__be32 old_saddr = inet->inet_saddr;
>  	__be32 daddr = inet->inet_daddr;
> +	struct ip_options_rcu *inet_opt;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	__be32 new_saddr;
> -	struct ip_options_rcu *inet_opt;
> +	int err;
>  
>  	inet_opt = rcu_dereference_protected(inet->inet_opt,
>  					     lockdep_sock_is_held(sk));
> @@ -1253,6 +1254,10 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  
>  	inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
>  
> +	err = inet_bhash2_update_saddr(sk);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * XXX The only one ugly spot where we need to
>  	 * XXX really change the sockets identity after
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 545f91b6cb5e..73f18134b2d5 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -826,6 +826,55 @@ inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
>  	return bhash2;
>  }
>  
> +/* the lock for the socket's corresponding bhash entry must be held */
> +static int __inet_bhash2_update_saddr(struct sock *sk,
> +				      struct inet_hashinfo *hinfo,
> +				      struct net *net, int port, int l3mdev)
> +{
> +	struct inet_bind2_hashbucket *head2;
> +	struct inet_bind2_bucket *tb2;
> +
> +	tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
> +				     &head2);
> +	if (!tb2) {
> +		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
> +					       net, head2, port, l3mdev, sk);
> +		if (!tb2)
> +			return -ENOMEM;
> +	}
> +
> +	/* Remove the socket's old entry from bhash2 */
> +	__sk_del_bind2_node(sk);
> +
> +	sk_add_bind2_node(sk, &tb2->owners);
> +	inet_csk(sk)->icsk_bind2_hash = tb2;
> +
> +	return 0;
> +}
> +
> +/* This should be called if/when a socket's rcv saddr changes after it has
> + * been binded.
> + */
> +int inet_bhash2_update_saddr(struct sock *sk)
> +{
> +	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> +	int l3mdev = inet_sk_bound_l3mdev(sk);
> +	struct inet_bind_hashbucket *head;
> +	int port = inet_sk(sk)->inet_num;
> +	struct net *net = sock_net(sk);
> +	int err;
> +
> +	head = &hinfo->bhash[inet_bhashfn(net, port, hinfo->bhash_size)];
> +
> +	spin_lock_bh(&head->lock);

I think this patch should be 2nd one in the series because we know this lock
does not protect bhash2 and it makes diff smaller.

Also, the series should be applied to net instead of net-next.


> +
> +	err = __inet_bhash2_update_saddr(sk, hinfo, net, port, l3mdev);
> +
> +	spin_unlock_bh(&head->lock);
> +
> +	return err;
> +}
> +
>  /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
>   * Note that we use 32bit integers (vs RFC 'short integers')
>   * because 2^16 is not a multiple of num_ephemeral and this
> @@ -840,7 +889,7 @@ inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
>  static u32 *table_perturb;
>  
>  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		struct sock *sk, u64 port_offset,
> +		struct sock *sk, u64 port_offset, bool prev_inaddr_any,
>  		int (*check_established)(struct inet_timewait_death_row *,
>  			struct sock *, __u16, struct inet_timewait_sock **))
>  {
> @@ -858,11 +907,24 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	int l3mdev;
>  	u32 index;
>  
> +	l3mdev = inet_sk_bound_l3mdev(sk);

This add/remove dance can be saved.


> +
>  	if (port) {
>  		head = &hinfo->bhash[inet_bhashfn(net, port,
>  						  hinfo->bhash_size)];
>  		tb = inet_csk(sk)->icsk_bind_hash;
> +
>  		spin_lock_bh(&head->lock);
> +
> +		if (prev_inaddr_any) {
> +			ret = __inet_bhash2_update_saddr(sk, hinfo, net, port,
> +							 l3mdev);
> +			if (ret) {
> +				spin_unlock_bh(&head->lock);
> +				return ret;
> +			}
> +		}
> +
>  		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
>  			inet_ehash_nolisten(sk, NULL, NULL);
>  			spin_unlock_bh(&head->lock);
> @@ -875,8 +937,6 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  		return ret;
>  	}
>  
> -	l3mdev = inet_sk_bound_l3mdev(sk);
> -
>  	inet_get_local_port_range(net, &low, &high);
>  	high++; /* [32768, 60999] -> [32768, 61000[ */
>  	remaining = high - low;
> @@ -987,13 +1047,13 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>   * Bind a port for a connect operation and hash it.
>   */
>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		      struct sock *sk)
> +		      struct sock *sk, bool prev_inaddr_any)
>  {
>  	u64 port_offset = 0;
>  
>  	if (!inet_sk(sk)->inet_num)
>  		port_offset = inet_sk_port_offset(sk);
> -	return __inet_hash_connect(death_row, sk, port_offset,
> +	return __inet_hash_connect(death_row, sk, port_offset, prev_inaddr_any,
>  				   __inet_check_established);
>  }
>  EXPORT_SYMBOL_GPL(inet_hash_connect);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fe8f23b95d32..70c2182c780d 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -203,6 +203,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	__be16 orig_sport, orig_dport;
> +	bool prev_inaddr_any = false;
>  	__be32 daddr, nexthop;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
> @@ -246,8 +247,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	if (!inet_opt || !inet_opt->opt.srr)
>  		daddr = fl4->daddr;
>  
> -	if (!inet->inet_saddr)
> +	if (!inet->inet_saddr) {
>  		inet->inet_saddr = fl4->saddr;
> +		prev_inaddr_any = true;
> +	}
> +
>  	sk_rcv_saddr_set(sk, inet->inet_saddr);
>  
>  	if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
> @@ -273,7 +277,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * complete initialization after this.
>  	 */
>  	tcp_set_state(sk, TCP_SYN_SENT);
> -	err = inet_hash_connect(tcp_death_row, sk);
> +	err = inet_hash_connect(tcp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto failure;
>  
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index 7d53d62783b1..c87c5933f3be 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -317,13 +317,13 @@ static u64 inet6_sk_port_offset(const struct sock *sk)
>  }
>  
>  int inet6_hash_connect(struct inet_timewait_death_row *death_row,
> -		       struct sock *sk)
> +		       struct sock *sk, bool prev_inaddr_any)
>  {
>  	u64 port_offset = 0;
>  
>  	if (!inet_sk(sk)->inet_num)
>  		port_offset = inet6_sk_port_offset(sk);
> -	return __inet_hash_connect(death_row, sk, port_offset,
> +	return __inet_hash_connect(death_row, sk, port_offset, prev_inaddr_any,
>  				   __inet6_check_established);
>  }
>  EXPORT_SYMBOL_GPL(inet6_hash_connect);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index f37dd4aa91c6..81e3312c2a97 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -152,6 +152,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct in6_addr *saddr = NULL, *final_p, final;
> +	bool prev_inaddr_any = false;
>  	struct ipv6_txoptions *opt;
>  	struct flowi6 fl6;
>  	struct dst_entry *dst;
> @@ -289,6 +290,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	if (!saddr) {
>  		saddr = &fl6.saddr;
>  		sk->sk_v6_rcv_saddr = *saddr;
> +		prev_inaddr_any = true;
>  	}
>  
>  	/* set the source address */
> @@ -309,7 +311,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  	tcp_set_state(sk, TCP_SYN_SENT);
>  	tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
> -	err = inet6_hash_connect(tcp_death_row, sk);
> +	err = inet6_hash_connect(tcp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto late_failure;
>  
> -- 
> 2.30.2
