Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A366E729
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAQTkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbjAQThj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:37:39 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EF04B76A;
        Tue, 17 Jan 2023 10:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673980951; x=1705516951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cA4HYuEGUOIYFtTMnUv0jIRa3mM2Uph77RshWkkciWg=;
  b=R3dQvc4Vx8PdiSPjJeryXYAeUYQvKoWWPSEwSas2wsVfWyqwO2Q0gnak
   fk47NGlFvlHJtpK39KbQ7tVic0PEpMnezVHb9p8FOUhtovT9elQQ+0myi
   sruHa+eCnR5lxsrIV8O32w21hxywLXrunh2GE4yH77WFC2cF/wkaexn1W
   E=;
X-IronPort-AV: E=Sophos;i="5.97,224,1669075200"; 
   d="scan'208";a="255801131"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 18:41:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 172858111D;
        Tue, 17 Jan 2023 18:41:52 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 17 Jan 2023 18:41:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 17 Jan 2023 18:41:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kerneljasonxing@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kernelxing@tencent.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v6 net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Tue, 17 Jan 2023 10:41:40 -0800
Message-ID: <20230117184140.7010-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117175340.91712-1-kerneljasonxing@gmail.com>
References: <20230117175340.91712-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D44UWC001.ant.amazon.com (10.43.162.26) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 18 Jan 2023 01:53:40 +0800
> From: Jason Xing <kernelxing@tencent.com>
> 
> While one cpu is working on looking up the right socket from ehash
> table, another cpu is done deleting the request socket and is about
> to add (or is adding) the big socket from the table. It means that
> we could miss both of them, even though it has little chance.
> 
> Let me draw a call trace map of the server side.
>    CPU 0                           CPU 1
>    -----                           -----
> tcp_v4_rcv()                  syn_recv_sock()
>                             inet_ehash_insert()
>                             -> sk_nulls_del_node_init_rcu(osk)
> __inet_lookup_established()
>                             -> __sk_nulls_add_node_rcu(sk, list)
> 
> Notice that the CPU 0 is receiving the data after the final ack
> during 3-way shakehands and CPU 1 is still handling the final ack.
> 
> Why could this be a real problem?
> This case is happening only when the final ack and the first data
> receiving by different CPUs. Then the server receiving data with
> ACK flag tries to search one proper established socket from ehash
> table, but apparently it fails as my map shows above. After that,
> the server fetches a listener socket and then sends a RST because
> it finds a ACK flag in the skb (data), which obeys RST definition
> in RFC 793.
> 
> Besides, Eric pointed out there's one more race condition where it
> handles tw socket hashdance. Only by adding to the tail of the list
> before deleting the old one can we avoid the race if the reader has
> already begun the bucket traversal and it would possibly miss the head.
> 
> Many thanks to Eric for great help from beginning to end.
> 
> Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> ---
> v3,4,5,6:
> 1) nit: adjust the coding style.
> 
> v2:
> 1) add the sk node into the tail of list to prevent the race.
> 2) fix the race condition when handling time-wait socket hashdance.
> ---
>  net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
>  net/ipv4/inet_timewait_sock.c | 12 ++++++------
>  2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9..f58d73888638 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -650,8 +650,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
>  	spin_lock(lock);
>  	if (osk) {
>  		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> -		ret = sk_nulls_del_node_init_rcu(osk);
> -	} else if (found_dup_sk) {
> +		ret = sk_hashed(osk);
> +		if (ret) {
> +			/* Before deleting the node, we insert a new one to make
> +			 * sure that the look-up-sk process would not miss either
> +			 * of them and that at least one node would exist in ehash
> +			 * table all the time. Otherwise there's a tiny chance
> +			 * that lookup process could find nothing in ehash table.
> +			 */
> +			__sk_nulls_add_node_tail_rcu(sk, list);
> +			sk_nulls_del_node_init_rcu(osk);
> +		}
> +		goto unlock;
> +	}
> +	if (found_dup_sk) {
>  		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
>  		if (*found_dup_sk)
>  			ret = false;
> @@ -660,6 +672,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
>  	if (ret)
>  		__sk_nulls_add_node_rcu(sk, list);
>  
> +unlock:
>  	spin_unlock(lock);
>  
>  	return ret;
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 1d77d992e6e7..b66f2dea5a78 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -91,20 +91,20 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
>  }
>  EXPORT_SYMBOL_GPL(inet_twsk_put);
>  
> -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> -				   struct hlist_nulls_head *list)
> +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
> +					struct hlist_nulls_head *list)
>  {
> -	hlist_nulls_add_head_rcu(&tw->tw_node, list);
> +	hlist_nulls_add_tail_rcu(&tw->tw_node, list);
>  }
>  
>  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> -				    struct hlist_head *list)
> +					struct hlist_head *list)
>  {
>  	hlist_add_head(&tw->tw_bind_node, list);
>  }
>  
>  static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
> -				     struct hlist_head *list)
> +					struct hlist_head *list)
>  {
>  	hlist_add_head(&tw->tw_bind2_node, list);
>  }

You need not change inet_twsk_add_bind_node() and
inet_twsk_add_bind2_node().

Thanks,
Kuniyuki


> @@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
>  
>  	spin_lock(lock);
>  
> -	inet_twsk_add_node_rcu(tw, &ehead->chain);
> +	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
>  
>  	/* Step 3: Remove SK from hash chain */
>  	if (__sk_nulls_del_node_init_rcu(sk))
> -- 
> 2.37.3
