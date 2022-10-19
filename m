Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0F604D7A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJSQdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJSQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:33:23 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F806C101
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666197202; x=1697733202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bIXhfKh+mZ1iKq1/YrB97dCDXK0xJ/LGBj0e3seZSfE=;
  b=IH03iW/Xtgq4rhVvth0XO2E6ULZcvM8t1MfhgX4optllCDA1sPy34GcW
   /Vt8lzhXkVv4+bgcR49yGTpqO0EKbwuXtUpHDkm+FzKlR3wXXLgU/NtXK
   F1scUw0FQorZT40ZDEZJVLkx2eVJnpB3tIqeadfq9SQ74LAbciAL9Uhdq
   o=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 16:33:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id 83E8D610E8;
        Wed, 19 Oct 2022 16:33:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 16:33:16 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.128) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 16:33:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] udp: track the forward memory release threshold in an hot cacheline
Date:   Wed, 19 Oct 2022 09:33:06 -0700
Message-ID: <20221019163306.70984-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <dafe09ca2e14c4ab45f3d9db56b768e06750e382.1666173045.git.pabeni@redhat.com>
References: <dafe09ca2e14c4ab45f3d9db56b768e06750e382.1666173045.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.128]
X-ClientProxiedBy: EX13D49UWC003.ant.amazon.com (10.43.162.10) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Wed, 19 Oct 2022 12:02:01 +0200
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
> Overall the above give a 10% peek throughput increase under UDP flood.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/udp.h |  3 +++
>  net/ipv4/udp.c      | 22 +++++++++++++++++++---
>  net/ipv6/udp.c      |  8 ++++++--
>  3 files changed, 28 insertions(+), 5 deletions(-)
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
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8126f67d18b3..915f573587fa 100644
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
> @@ -1622,8 +1622,12 @@ static void udp_destruct_sock(struct sock *sk)
>  
>  int udp_init_sock(struct sock *sk)
>  {
> -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> +	struct udp_sock *up = udp_sk(sk);
> +
> +	skb_queue_head_init(&up->reader_queue);
> +	up->forward_threshold = sk->sk_rcvbuf >> 2;
>  	sk->sk_destruct = udp_destruct_sock;
> +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
>  	return 0;
>  }
>  
> @@ -2671,6 +2675,18 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
>  	int err = 0;
>  	int is_udplite = IS_UDPLITE(sk);
>  
> +	if (level == SOL_SOCKET) {
> +		err = sk_setsockopt(sk, level, optname, optval, optlen);
> +
> +		if (optname == SO_RCVBUF || optname == SO_RCVBUFFORCE) {
> +			sockopt_lock_sock(sk);

Can we drop this lock by adding READ_ONCE() to sk->sk_rcvbuf below ?


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
> @@ -2784,7 +2800,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
>  int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>  		   unsigned int optlen)
>  {
> -	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
> +	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
>  		return udp_lib_setsockopt(sk, level, optname,
>  					  optval, optlen,
>  					  udp_push_pending_frames);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 8d09f0ea5b8c..1ed20bcfd7a0 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -64,8 +64,12 @@ static void udpv6_destruct_sock(struct sock *sk)
>  
>  int udpv6_init_sock(struct sock *sk)
>  {
> -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> +	struct udp_sock *up = udp_sk(sk);
> +
> +	skb_queue_head_init(&up->reader_queue);
> +	up->forward_threshold = sk->sk_rcvbuf >> 2;
>  	sk->sk_destruct = udpv6_destruct_sock;
> +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
>  	return 0;
>  }

It's time to factorise this part like udp_destruct_common() ?


>  
> @@ -1671,7 +1675,7 @@ void udpv6_destroy_sock(struct sock *sk)
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
