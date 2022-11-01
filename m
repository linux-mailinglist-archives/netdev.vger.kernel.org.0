Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94924614FC3
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiKAQym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiKAQyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:54:40 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA80F1CFD9
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 09:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667321679; x=1698857679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Ce/J5Ld/9IT6HX0MBV7wDVUjmBLwF0wdO+demX40RA=;
  b=SPmVKbrgk5wnJDZlAIX+rnvOV+iKV5YP5tVIFL302CsOV3gwIzqBBVjA
   8XzbadmU2kufmil57T0s650RKr8ql4YVyUf+cgCAq6Ow5qToTfsD6ibOT
   C1G+39IW9Y5ms5PlaUmj+oaGURtpYdm9CkXakxSpuFSmW227qXL9XJMQO
   g=;
X-IronPort-AV: E=Sophos;i="5.95,231,1661817600"; 
   d="scan'208";a="258569350"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 16:54:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id F3476418F4;
        Tue,  1 Nov 2022 16:54:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 1 Nov 2022 16:54:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 1 Nov 2022 16:54:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <soheil@google.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] tcp: refine tcp_prune_ofo_queue() logic
Date:   Tue, 1 Nov 2022 09:54:12 -0700
Message-ID: <20221101165412.25234-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101035234.3910189-1-edumazet@google.com>
References: <20221101035234.3910189-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue,  1 Nov 2022 03:52:34 +0000
> After commits 36a6503fedda ("tcp: refine tcp_prune_ofo_queue()
> to not drop all packets") and 72cd43ba64fc1
> ("tcp: free batches of packets in tcp_prune_ofo_queue()")
> tcp_prune_ofo_queue() drops a fraction of ooo queue,
> to make room for incoming packet.
> 
> However it makes no sense to drop packets that are
> before the incoming packet, in sequence space.
> 
> In order to recover from packet losses faster,
> it makes more sense to only drop ooo packets
> which are after the incoming packet.
> 
> Tested:
> packetdrill test:
>    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [3800], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
>    +0 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 0>
>   +.1 < . 1:1(0) ack 1 win 1024
>    +0 accept(3, ..., ...) = 4
> 
>  +.01 < . 200:300(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 200:300>
> 
>  +.01 < . 400:500(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 400:500 200:300>
> 
>  +.01 < . 600:700(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 600:700 400:500 200:300>
> 
>  +.01 < . 800:900(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 800:900 600:700 400:500 200:300>
> 
>  +.01 < . 1000:1100(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 1000:1100 800:900 600:700 400:500>
> 
>  +.01 < . 1200:1300(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
> 
> // this packet is dropped because we have no room left.
>  +.01 < . 1400:1500(100) ack 1 win 1024
> 
>  +.01 < . 1:200(199) ack 1 win 1024
> // Make sure kernel did not drop 200:300 sequence
>    +0 > . 1:1(0) ack 300 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
> // Make room, since our RCVBUF is very small
>    +0 read(4, ..., 299) = 299
> 
>  +.01 < . 300:400(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 500 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
> 
>  +.01 < . 500:600(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 700 <nop,nop, sack 1200:1300 1000:1100 800:900>
> 
>    +0 read(4, ..., 400) = 400
> 
>  +.01 < . 700:800(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 900 <nop,nop, sack 1200:1300 1000:1100>
> 
>  +.01 < . 900:1000(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1100 <nop,nop, sack 1200:1300>
> 
>  +.01 < . 1100:1200(100) ack 1 win 1024
> // This checks that 1200:1300 has not been removed from ooo queue
>    +0 > . 1:1(0) ack 1300
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Sounds good!

Thank you.


> ---
>  net/ipv4/tcp_input.c | 51 +++++++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 20 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 0640453fce54b6daae0861d948f3db075830daf6..d764b5854dfcc865207b5eb749c29013ef18bdbc 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4764,8 +4764,8 @@ static void tcp_ofo_queue(struct sock *sk)
>  	}
>  }
>  
> -static bool tcp_prune_ofo_queue(struct sock *sk);
> -static int tcp_prune_queue(struct sock *sk);
> +static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb);
> +static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
>  
>  static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
>  				 unsigned int size)
> @@ -4773,11 +4773,11 @@ static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
>  	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
>  	    !sk_rmem_schedule(sk, skb, size)) {
>  
> -		if (tcp_prune_queue(sk) < 0)
> +		if (tcp_prune_queue(sk, skb) < 0)
>  			return -1;
>  
>  		while (!sk_rmem_schedule(sk, skb, size)) {
> -			if (!tcp_prune_ofo_queue(sk))
> +			if (!tcp_prune_ofo_queue(sk, skb))
>  				return -1;
>  		}
>  	}
> @@ -5329,6 +5329,8 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
>   * Clean the out-of-order queue to make room.
>   * We drop high sequences packets to :
>   * 1) Let a chance for holes to be filled.
> + *    This means we do not drop packets from ooo queue if their sequence
> + *    is before incoming packet sequence.
>   * 2) not add too big latencies if thousands of packets sit there.
>   *    (But if application shrinks SO_RCVBUF, we could still end up
>   *     freeing whole queue here)
> @@ -5336,24 +5338,31 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
>   *
>   * Return true if queue has shrunk.
>   */
> -static bool tcp_prune_ofo_queue(struct sock *sk)
> +static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct rb_node *node, *prev;
> +	bool pruned = false;
>  	int goal;
>  
>  	if (RB_EMPTY_ROOT(&tp->out_of_order_queue))
>  		return false;
>  
> -	NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
>  	goal = sk->sk_rcvbuf >> 3;
>  	node = &tp->ooo_last_skb->rbnode;
> +
>  	do {
> +		struct sk_buff *skb = rb_to_skb(node);
> +
> +		/* If incoming skb would land last in ofo queue, stop pruning. */
> +		if (after(TCP_SKB_CB(in_skb)->seq, TCP_SKB_CB(skb)->seq))
> +			break;
> +		pruned = true;
>  		prev = rb_prev(node);
>  		rb_erase(node, &tp->out_of_order_queue);
> -		goal -= rb_to_skb(node)->truesize;
> -		tcp_drop_reason(sk, rb_to_skb(node),
> -				SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
> +		goal -= skb->truesize;
> +		tcp_drop_reason(sk, skb, SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
> +		tp->ooo_last_skb = rb_to_skb(prev);
>  		if (!prev || goal <= 0) {
>  			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
>  			    !tcp_under_memory_pressure(sk))
> @@ -5362,16 +5371,18 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
>  		}
>  		node = prev;
>  	} while (node);
> -	tp->ooo_last_skb = rb_to_skb(prev);
>  
> -	/* Reset SACK state.  A conforming SACK implementation will
> -	 * do the same at a timeout based retransmit.  When a connection
> -	 * is in a sad state like this, we care only about integrity
> -	 * of the connection not performance.
> -	 */
> -	if (tp->rx_opt.sack_ok)
> -		tcp_sack_reset(&tp->rx_opt);
> -	return true;
> +	if (pruned) {
> +		NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
> +		/* Reset SACK state.  A conforming SACK implementation will
> +		 * do the same at a timeout based retransmit.  When a connection
> +		 * is in a sad state like this, we care only about integrity
> +		 * of the connection not performance.
> +		 */
> +		if (tp->rx_opt.sack_ok)
> +			tcp_sack_reset(&tp->rx_opt);
> +	}
> +	return pruned;
>  }
>  
>  /* Reduce allocated memory if we can, trying to get
> @@ -5381,7 +5392,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
>   * until the socket owning process reads some of the data
>   * to stabilize the situation.
>   */
> -static int tcp_prune_queue(struct sock *sk)
> +static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  
> @@ -5408,7 +5419,7 @@ static int tcp_prune_queue(struct sock *sk)
>  	/* Collapsing did not help, destructive actions follow.
>  	 * This must not ever occur. */
>  
> -	tcp_prune_ofo_queue(sk);
> +	tcp_prune_ofo_queue(sk, in_skb);
>  
>  	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
>  		return 0;
> -- 
> 2.38.1.273.g43a17bfeac-goog
