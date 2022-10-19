Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82386604E3F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJSRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 13:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJSRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 13:10:05 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281389E687
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666199398; x=1697735398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aesB2E4oSmdpE76uFG06CvtcMC1RAAsyRuAB9b9WWVI=;
  b=Ic/TviNE1uxZVu2WORTi5JFFhdhqye0WWvdgh6kzj2B2/7QX9aMmjSBB
   kOlLBG/5F+ztZ1AvvXw15zw5UKjjcP23axNUV15B1tcF8CyXEdhEDgzYE
   Guj3jCnFBWJxrbmLF7Bl80ULzPDIwgoUnZlhtgwB1jz0n5G3SqfaQBIT5
   4=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="141929083"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 17:09:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id DF57981AB7;
        Wed, 19 Oct 2022 17:09:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 17:09:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.213) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 17:09:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] udp: track the forward memory release threshold in an hot cacheline
Date:   Wed, 19 Oct 2022 10:09:40 -0700
Message-ID: <20221019170940.72412-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <48dc93489465e75a0f37c4b02f4711598cb1ed4d.camel@redhat.com>
References: <48dc93489465e75a0f37c4b02f4711598cb1ed4d.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
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
Date:   Wed, 19 Oct 2022 18:58:33 +0200
> On Wed, 2022-10-19 at 09:33 -0700, Kuniyuki Iwashima wrote:
> > From:   Paolo Abeni <pabeni@redhat.com>
> > Date:   Wed, 19 Oct 2022 12:02:01 +0200
> > > When the receiver process and the BH runs on different cores,
> > > udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
> > > as the latter shares the same cacheline with sk_forward_alloc, written
> > > by the BH.
> > > 
> > > With this patch, UDP tracks the rcvbuf value and its update via custom
> > > SOL_SOCKET socket options, and copies the forward memory threshold value
> > > used by udp_rmem_release() in a different cacheline, already accessed by
> > > the above function and uncontended.
> > > 
> > > Overall the above give a 10% peek throughput increase under UDP flood.
> > > 
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  include/linux/udp.h |  3 +++
> > >  net/ipv4/udp.c      | 22 +++++++++++++++++++---
> > >  net/ipv6/udp.c      |  8 ++++++--
> > >  3 files changed, 28 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/include/linux/udp.h b/include/linux/udp.h
> > > index e96da4157d04..5cdba00a904a 100644
> > > --- a/include/linux/udp.h
> > > +++ b/include/linux/udp.h
> > > @@ -87,6 +87,9 @@ struct udp_sock {
> > >  
> > >  	/* This field is dirtied by udp_recvmsg() */
> > >  	int		forward_deficit;
> > > +
> > > +	/* This fields follows rcvbuf value, and is touched by udp_recvmsg */
> > > +	int		forward_threshold;
> > >  };
> > >  
> > >  #define UDP_MAX_SEGMENTS	(1 << 6UL)
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 8126f67d18b3..915f573587fa 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -1448,7 +1448,7 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
> > >  	if (likely(partial)) {
> > >  		up->forward_deficit += size;
> > >  		size = up->forward_deficit;
> > > -		if (size < (sk->sk_rcvbuf >> 2) &&
> > > +		if (size < READ_ONCE(up->forward_threshold) &&
> > >  		    !skb_queue_empty(&up->reader_queue))
> > >  			return;
> > >  	} else {
> > > @@ -1622,8 +1622,12 @@ static void udp_destruct_sock(struct sock *sk)
> > >  
> > >  int udp_init_sock(struct sock *sk)
> > >  {
> > > -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> > > +	struct udp_sock *up = udp_sk(sk);
> > > +
> > > +	skb_queue_head_init(&up->reader_queue);
> > > +	up->forward_threshold = sk->sk_rcvbuf >> 2;
> > >  	sk->sk_destruct = udp_destruct_sock;
> > > +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> > >  	return 0;
> > >  }
> > >  
> > > @@ -2671,6 +2675,18 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
> > >  	int err = 0;
> > >  	int is_udplite = IS_UDPLITE(sk);
> > >  
> > > +	if (level == SOL_SOCKET) {
> > > +		err = sk_setsockopt(sk, level, optname, optval, optlen);
> > > +
> > > +		if (optname == SO_RCVBUF || optname == SO_RCVBUFFORCE) {
> > > +			sockopt_lock_sock(sk);
> > 
> > Can we drop this lock by adding READ_ONCE() to sk->sk_rcvbuf below ?
> 
> I think we can't. If there are racing thread updating rcvbuf, we could
> end-up with mismatching value in forward_threshold. Not a likely
> scenario, but still... This is control path, acquiring the lock once
> more should not be a problem.

I see.
Thank you!


> > > +			/* paired with READ_ONCE in udp_rmem_release() */
> > > +			WRITE_ONCE(up->forward_threshold, sk->sk_rcvbuf >> 2);
> > > +			sockopt_release_sock(sk);
> > > +		}
> > > +		return err;
> > > +	}
> > > +
> > >  	if (optlen < sizeof(int))
> > >  		return -EINVAL;
> > >  
> > > @@ -2784,7 +2800,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
> > >  int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> > >  		   unsigned int optlen)
> > >  {
> > > -	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
> > > +	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
> > >  		return udp_lib_setsockopt(sk, level, optname,
> > >  					  optval, optlen,
> > >  					  udp_push_pending_frames);
> > > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > > index 8d09f0ea5b8c..1ed20bcfd7a0 100644
> > > --- a/net/ipv6/udp.c
> > > +++ b/net/ipv6/udp.c
> > > @@ -64,8 +64,12 @@ static void udpv6_destruct_sock(struct sock *sk)
> > >  
> > >  int udpv6_init_sock(struct sock *sk)
> > >  {
> > > -	skb_queue_head_init(&udp_sk(sk)->reader_queue);
> > > +	struct udp_sock *up = udp_sk(sk);
> > > +
> > > +	skb_queue_head_init(&up->reader_queue);
> > > +	up->forward_threshold = sk->sk_rcvbuf >> 2;
> > >  	sk->sk_destruct = udpv6_destruct_sock;
> > > +	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
> > >  	return 0;
> > >  }
> > 
> > It's time to factorise this part like udp_destruct_common() ?
> 
> I guess it makes sense. Possibly 'udp_lib_destruct()' just to follow
> others helper style?

Ah, I should have named it so :)


> 
> > 
> Thanks,
> 
> Paolo
