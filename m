Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3858F6069EE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 22:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJTU6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 16:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 16:57:58 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03119189C17;
        Thu, 20 Oct 2022 13:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666299477; x=1697835477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OZKg6jtGCge+9qLqauLNiWUYvp2C14rfhh1l9qcZBgE=;
  b=jMw47CoQaq28j3LWAEut8ZnjiX4QD3hSCBfnioXwvkFpMgHCeDLlKDVe
   jjqnPqlxZRpginHg2PYZYaBk5hDuLUVlUiqKk0h3H3QEE/zedpXjWmhZ8
   0/ttBzTagqFkdYI0fiHeBymDurty5cao9tb6w8e5jEdhPk3DMtvy3eVAK
   Q=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 20:57:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 75C93C3DC0;
        Thu, 20 Oct 2022 20:57:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 20:57:42 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 20 Oct 2022 20:57:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <luwei32@huawei.com>
CC:     <asml.silence@gmail.com>, <ast@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <imagedong@tencent.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <martin.lau@kernel.org>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH -next,v2] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date:   Thu, 20 Oct 2022 13:57:30 -0700
Message-ID: <20221020205730.10875-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221020143201.339599-1-luwei32@huawei.com>
References: <20221020143201.339599-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D45UWB004.ant.amazon.com (10.43.161.54) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The subject should be

  [PATCH net v2] tcp: ....

so that this patch will be backported to the stable tree.


From:   Lu Wei <luwei32@huawei.com>
Date:   Thu, 20 Oct 2022 22:32:01 +0800
> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> in tcp_add_backlog(), the variable limit is caculated by adding
> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> of int and overflow. This patch limits sk_rcvbuf and sk_sndbuf
> to 0x7fff000 and transfers them to u32 to avoid signed-integer
> overflow.
> 
> Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  include/net/sock.h  |  5 +++++
>  net/core/sock.c     | 10 ++++++----
>  net/ipv4/tcp_ipv4.c |  3 ++-
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9e464f6409a7..cc2d6c4047c2 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2529,6 +2529,11 @@ static inline void sk_wake_async(const struct sock *sk, int how, int band)
>  #define SOCK_MIN_SNDBUF		(TCP_SKB_MIN_TRUESIZE * 2)
>  #define SOCK_MIN_RCVBUF		 TCP_SKB_MIN_TRUESIZE
>  
> +/* limit sk_sndbuf and sk_rcvbuf to 0x7fff0000 to prevent overflow
> + * when adding sk_sndbuf, sk_rcvbuf and 64K in tcp_add_backlog()
> + */
> +#define SOCK_MAX_SNDRCVBUF		(INT_MAX - 0xFFFF)

Should we apply this limit in tcp_rcv_space_adjust() ?

	int rcvmem, rcvbuf;
	...
	rcvbuf = min_t(u64, rcvwin * rcvmem,
		       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
	if (rcvbuf > sk->sk_rcvbuf) {
		WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
	...
	}

We still have 64K space if sk_rcvbuf were INT_MAX here though.


> +
>  static inline void sk_stream_moderate_sndbuf(struct sock *sk)
>  {
>  	u32 val;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3ba0358c77c..33acc5e71100 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -950,7 +950,7 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
>  	/* Ensure val * 2 fits into an int, to prevent max_t() from treating it
>  	 * as a negative value.
>  	 */
> -	val = min_t(int, val, INT_MAX / 2);
> +	val = min_t(int, val, SOCK_MAX_SNDRCVBUF / 2);
>  	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>  
>  	/* We double it on the way in to account for "struct sk_buff" etc.
> @@ -1142,7 +1142,7 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  		/* Ensure val * 2 fits into an int, to prevent max_t()
>  		 * from treating it as a negative value.
>  		 */
> -		val = min_t(int, val, INT_MAX / 2);
> +		val = min_t(int, val, SOCK_MAX_SNDRCVBUF / 2);
>  		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
>  		WRITE_ONCE(sk->sk_sndbuf,
>  			   max_t(int, val * 2, SOCK_MIN_SNDBUF));
> @@ -3365,8 +3365,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
>  	timer_setup(&sk->sk_timer, NULL, 0);
>  
>  	sk->sk_allocation	=	GFP_KERNEL;
> -	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
> -	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
> +	sk->sk_rcvbuf		=	min_t(int, SOCK_MAX_SNDRCVBUF,
> +					      READ_ONCE(sysctl_rmem_default));
> +	sk->sk_sndbuf		=	min_t(int, SOCK_MAX_SNDRCVBUF,
> +					      READ_ONCE(sysctl_wmem_default));
>  	sk->sk_state		=	TCP_CLOSE;
>  	sk_set_socket(sk, sock);
>  
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7a250ef9d1b7..5340733336a6 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1878,7 +1878,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
>  	 * to reduce memory overhead, so add a little headroom here.
>  	 * Few sockets backlog are possibly concurrently non empty.
>  	 */
> -	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
> +	limit = (u32)READ_ONCE(sk->sk_rcvbuf) +
> +		(u32)READ_ONCE(sk->sk_sndbuf) + 64*1024;

nit: s/64*1024/64 * 1024/

$ git show --format=email | ./scripts/checkpatch.pl
CHECK: spaces preferred around that '*' (ctx:VxV)
#79: FILE: net/ipv4/tcp_ipv4.c:1882:
+		(u32)READ_ONCE(sk->sk_sndbuf) + 64*1024;
 		                                  ^


>  
>  	if (unlikely(sk_add_backlog(sk, skb, limit))) {
>  		bh_unlock_sock(sk);
> -- 
> 2.31.1
