Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD3E606819
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJTSUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJTSU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:20:26 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDAB107A9D
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666290025; x=1697826025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z+Y/NHNM5uoVzm+rHVda3yco3ULp47GHC5LXxgQtcSM=;
  b=R24GdvH5j8GOf8O/BZAT3BPZjoxV0kLJ46YrDOQkjMKfSB1Tg+al6aLv
   TrsCsuX6Tcu0miL2meZm4+9C869aoIsgNNcSRqlWpKODS3sLDTHsp7Zjt
   exEUtd1iJPI56/1ptrMEYR3aH92A0kdbQSed/u7ZKFgsuHyruhHpZpp/L
   k=;
X-IronPort-AV: E=Sophos;i="5.95,199,1661817600"; 
   d="scan'208";a="142447769"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 18:20:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id D6ED6610CB;
        Thu, 20 Oct 2022 18:20:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 18:20:20 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.208) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 20 Oct 2022 18:20:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] udp: track the forward memory release threshold in an hot cacheline
Date:   Thu, 20 Oct 2022 11:20:08 -0700
Message-ID: <20221020182008.293-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2dede94e742d8096d6ac5e0f1979054ee158d9a8.1666287924.git.pabeni@redhat.com>
References: <2dede94e742d8096d6ac5e0f1979054ee158d9a8.1666287924.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.208]
X-ClientProxiedBy: EX13D42UWA001.ant.amazon.com (10.43.160.153) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Thu, 20 Oct 2022 19:48:52 +0200
> When the receiver process and the BH runs on different cores,
> udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
> as the latter shares the same cacheline with sk_forward_alloc, written
> by the BH.
> 
> With this patch, UDP tracks the rcvbuf value and its update via custom
> SOL_SOCKET socket options, and copies the forward memory threshold value
> used by udp_rmem_release() in a different cacheline, already accessed by
> the above function and uncontended.
> 
> Since the UDP socket init operation grown a bit, factor out the common
> code between v4 and v6 in a shared helper.
> 
> Overall the above give a 10% peek throughput increase under UDP flood.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thank you!


> ---
> v1 -> v2:
>  - factor out common init helper for udp && udpv6 sock (Kuniyuki)
> ---
>  include/linux/udp.h |  3 +++
>  include/net/udp.h   |  9 +++++++++
>  net/ipv4/udp.c      | 18 +++++++++++++++---
>  net/ipv6/udp.c      |  4 ++--
>  4 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index e96da4157d04..5cdba00a904a 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -87,6 +87,9 @@ struct udp_sock {
>  
>  	/* This field is dirtied by udp_recvmsg() */
>  	int		forward_deficit;
> +
> +	/* This fields follows rcvbuf value, and is touched by udp_recvmsg */
> +	int		forward_threshold;
>  };
>  
>  #define UDP_MAX_SEGMENTS	(1 << 6UL)
> diff --git a/include/net/udp.h b/include/net/udp.h
> index fee053bcd17c..de4b528522bb 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -174,6 +174,15 @@ INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>  				  netdev_features_t features, bool is_ipv6);
>  
> +static inline void udp_lib_init_sock(struct sock *sk)
> +{
> +	struct udp_sock *up = udp_sk(sk);
> +
> +	skb_queue_head_init(&up->reader_queue);
> +	up->forward_threshold = sk->sk_rcvbuf >> 2;
> +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> +}
> +
>  /* hash routines shared between UDPv4/6 and UDP-Litev4/6 */
>  static inline int udp_lib_hash(struct sock *sk)
>  {
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8126f67d18b3..e361ad93999e 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1448,7 +1448,7 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
>  	if (likely(partial)) {
>  		up->forward_deficit += size;
>  		size = up->forward_deficit;
> -		if (size < (sk->sk_rcvbuf >> 2) &&
> +		if (size < READ_ONCE(up->forward_threshold) &&
>  		    !skb_queue_empty(&up->reader_queue))
>  			return;
>  	} else {
> @@ -1622,7 +1622,7 @@ static void udp_destruct_sock(struct sock *sk)
>  
>  int udp_init_sock(struct sock *sk)
>  {
> -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> +	udp_lib_init_sock(sk);
>  	sk->sk_destruct = udp_destruct_sock;
>  	return 0;
>  }
> @@ -2671,6 +2671,18 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
>  	int err = 0;
>  	int is_udplite = IS_UDPLITE(sk);
>  
> +	if (level == SOL_SOCKET) {
> +		err = sk_setsockopt(sk, level, optname, optval, optlen);
> +
> +		if (optname == SO_RCVBUF || optname == SO_RCVBUFFORCE) {
> +			sockopt_lock_sock(sk);
> +			/* paired with READ_ONCE in udp_rmem_release() */
> +			WRITE_ONCE(up->forward_threshold, sk->sk_rcvbuf >> 2);
> +			sockopt_release_sock(sk);
> +		}
> +		return err;
> +	}
> +
>  	if (optlen < sizeof(int))
>  		return -EINVAL;
>  
> @@ -2784,7 +2796,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
>  int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>  		   unsigned int optlen)
>  {
> -	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
> +	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
>  		return udp_lib_setsockopt(sk, level, optname,
>  					  optval, optlen,
>  					  udp_push_pending_frames);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 8d09f0ea5b8c..b0bc4e27ec2f 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -64,7 +64,7 @@ static void udpv6_destruct_sock(struct sock *sk)
>  
>  int udpv6_init_sock(struct sock *sk)
>  {
> -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> +	udp_lib_init_sock(sk);
>  	sk->sk_destruct = udpv6_destruct_sock;
>  	return 0;
>  }
> @@ -1671,7 +1671,7 @@ void udpv6_destroy_sock(struct sock *sk)
>  int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>  		     unsigned int optlen)
>  {
> -	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
> +	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
>  		return udp_lib_setsockopt(sk, level, optname,
>  					  optval, optlen,
>  					  udp_v6_push_pending_frames);
> -- 
> 2.37.3
