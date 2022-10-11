Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F80F5FB745
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJKPbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 11:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiJKPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 11:31:23 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7077961C;
        Tue, 11 Oct 2022 08:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665501671; x=1697037671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DUxASPr3Gd/Buc38i9IZ/G847nfGC3rRVJ3NrbMbI9c=;
  b=Z0E5Uzetyka0DRJdCM3eK7ku2YtRH7rUpLh5f8qVqwV/vI9Ag8SfsKnC
   GwqyKPRdFSwzw0FgKazLHxMdeN3eowdz7rRHwy6gcowjPitkK1GHQg5nJ
   iet+cv2u48sjWK2OIrALvsDLY9nOg1tBIbuiRWO/iqIwWJeXqdOnrSEkd
   k=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 15:20:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 4023EC09E6;
        Tue, 11 Oct 2022 15:20:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 11 Oct 2022 15:19:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.179) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 11 Oct 2022 15:19:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kazuhooku@gmail.com>, <kraig@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <willemb@google.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net 2/3] soreuseport: Fix socket selection for SO_INCOMING_CPU.
Date:   Tue, 11 Oct 2022 08:19:37 -0700
Message-ID: <20221011151937.89656-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <a2e418db45228cdaf59e7679d81b2d0bcb657377.camel@redhat.com>
References: <a2e418db45228cdaf59e7679d81b2d0bcb657377.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Tue, 11 Oct 2022 13:28:11 +0200
> On Mon, 2022-10-10 at 10:43 -0700, Kuniyuki Iwashima wrote:
> > Kazuho Oku reported that setsockopt(SO_INCOMING_CPU) does not work
> > with setsockopt(SO_REUSEPORT) for TCP since v4.6.
> > 
> > With the combination of SO_REUSEPORT and SO_INCOMING_CPU, we could
> > build a highly efficient server application.
> > 
> > setsockopt(SO_INCOMING_CPU) associates a CPU with a TCP listener
> > or UDP socket, and then incoming packets processed on the CPU will
> > likely be distributed to the socket.  Technically, a socket could
> > even receive packets handled on another CPU if no sockets in the
> > reuseport group have the same CPU receiving the flow.
> > 
> > The logic exists in compute_score() so that a socket will get a higher
> > score if it has the same CPU with the flow.  However, the score gets
> > ignored after the cited two commits, which introduced a faster socket
> > selection algorithm for SO_REUSEPORT.
> > 
> > This patch introduces a counter of sockets with SO_INCOMING_CPU in
> > a reuseport group to check if we should iterate all sockets to find
> > a proper one.  We increment the counter when
> > 
> >   * calling listen() if the socket has SO_INCOMING_CPU and SO_REUSEPORT
> > 
> >   * enabling SO_INCOMING_CPU if the socket is in a reuseport group
> > 
> > Also, we decrement it when
> > 
> >   * detaching a socket out of the group to apply SO_INCOMING_CPU to
> >     migrated TCP requests
> > 
> >   * disabling SO_INCOMING_CPU if the socket is in a reuseport group
> > 
> > When the counter reaches 0, we can get back to the O(1) selection
> > algorithm.
> > 
> > The overall changes are negligible for the non-SO_INCOMING_CPU case,
> > and the only notable thing is that we have to update sk_incomnig_cpu
> > under reuseport_lock.  Otherwise, the race below traps us in the O(n)
> > algorithm even after disabling SO_INCOMING_CPU for all sockets in the
> > group.
> > 
> >  cpu1 (setsockopt)               cpu2 (listen)
> > +-----------------+             +-------------+
> > 
> > lock_sock(sk1)                  lock_sock(sk2)
> > 
> > reuseport_incoming_cpu_update(sk, val)
> > .
> > > - spin_lock_bh(&reuseport_lock)
> > > 
> > >   /* increment reuse->incoming_cpu, but
> > >    * sk1->sk_incoming_cpu is still -1.
> > >    */
> > > - __reuseport_incoming_cpu_inc(sk1, reuse)
> > > 
> > > - spin_unlock_bh(&reuseport_lock)
> > > 
> > >                               spin_lock_bh(&reuseport_lock)
> > >                               reuseport_grow(sk2, reuse)
> > >                               .
> > >                               | - more_socks_size = reuse->max_socks * 2U;
> > >                               | - if (more_socks_size > U16_MAX &&
> > >                               |       reuse->num_closed_socks)
> > >                               |   .
> > >                               |   `- __reuseport_detach_closed_sock(sk1, reuse)
> > >                               |      .
> > >                               |      ` - reuseport_incoming_cpu_dec(sk1, reuse)
> > >                                          .
> > >                                          `- if (sk1->sk_incoming_cpu >= 0)
> > >                                             /* read shutdown()ed sk1's sk_incoming_cpu
> > >                                              * without lock_sock(), and ... do nothing!
> > `- WRITE_ONCE(sk1->incoming_cpu, 0)            *
> >                                                * leak 1 count of reuse->incoming_cpu.
> >                                                */
> > 
> >                                 spin_unlock_bh(&reuseport_lock)
> > 
> > Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
> > Fixes: c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")
> > Reported-by: Kazuho Oku <kazuhooku@gmail.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/sock_reuseport.h |  2 +
> >  net/core/sock.c              |  5 +-
> >  net/core/sock_reuseport.c    | 88 ++++++++++++++++++++++++++++++++++--
> >  3 files changed, 89 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > index fe9779e6d90f..d69fbea3d6cb 100644
> > --- a/include/net/sock_reuseport.h
> > +++ b/include/net/sock_reuseport.h
> > @@ -16,6 +16,7 @@ struct sock_reuseport {
> >  	u16			max_socks;		/* length of socks */
> >  	u16			num_socks;		/* elements in socks */
> >  	u16			num_closed_socks;	/* closed elements in socks */
> > +	u16			incoming_cpu;
> >  	/* The last synq overflow event timestamp of this
> >  	 * reuse->socks[] group.
> >  	 */
> > @@ -28,6 +29,7 @@ struct sock_reuseport {
> >  	struct sock		*socks[];	/* array of sock pointers */
> >  };
> >  
> > +void reuseport_incoming_cpu_update(struct sock *sk, int val);
> >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> >  			      bool bind_inany);
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index eeb6cbac6f49..ad67aba947e1 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1436,7 +1436,10 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> >  		break;
> >  		}
> >  	case SO_INCOMING_CPU:
> > -		WRITE_ONCE(sk->sk_incoming_cpu, val);
> > +		if (rcu_access_pointer(sk->sk_reuseport_cb))
> > +			reuseport_incoming_cpu_update(sk, val);
> > +		else
> > +			WRITE_ONCE(sk->sk_incoming_cpu, val);
> 
> I woould call the helper regardless of sk->sk_reuseport_cb and let it
> do the correct thing, will make the code simpler and possibly safer.

I'll move the condition/WRITE_ONCE() into the helper.


> >  		break;
> >  
> >  	case SO_CNX_ADVICE:
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index 5daa1fa54249..6f5cda58b2d4 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -21,6 +21,64 @@ static DEFINE_IDA(reuseport_ida);
> >  static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> >  			       struct sock_reuseport *reuse, bool bind_inany);
> >  
> > +static void __reuseport_incoming_cpu_inc(struct sock *sk, struct sock_reuseport *reuse)
> > +{
> > +	/* paired with READ_ONCE() in reuseport_select_sock_by_hash() */
> > +	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu + 1);
> > +}
> 
> I find this helper name confusing (and I'm also horrible at picking
> good names). Perhaps
> __reuseport_use_cpu_inc()/__reuseport_use_cpu_dev() ?!?

Yes, I'm bad at naming :)

Hmm... "use_cpu" sounds always true like "a socket uses a cpu", it would
be good if we can represent "we have a socket with a cpu specified", so
__reuseport_(get|put)_cpu_specified ...?

But we usually use get/put for refcounting, do you think it's a good
fit or confusing?


> > +
> > +static void __reuseport_incoming_cpu_dec(struct sock *sk, struct sock_reuseport *reuse)
> > +{
> > +	/* paired with READ_ONCE() in reuseport_select_sock_by_hash() */
> > +	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu - 1);
> > +}
> > +
> > +static void reuseport_incoming_cpu_inc(struct sock *sk, struct sock_reuseport *reuse)
> > +{
> > +	if (sk->sk_incoming_cpu >= 0)
> > +		__reuseport_incoming_cpu_inc(sk, reuse);
> > +}
> > +
> > +static void reuseport_incoming_cpu_dec(struct sock *sk, struct sock_reuseport *reuse)
> > +{
> > +	if (sk->sk_incoming_cpu >= 0)
> > +		__reuseport_incoming_cpu_dec(sk, reuse);
> > +}
> > +
> > +void reuseport_incoming_cpu_update(struct sock *sk, int val)
> > +{
> > +	struct sock_reuseport *reuse;
> > +
> > +	spin_lock_bh(&reuseport_lock);
> > +	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > +					  lockdep_is_held(&reuseport_lock));
> > +
> > +	if (!reuse) {
> > +		/* reuseport_grow() has detached a shutdown()ed
> > +		 * sk, and sk_state is TCP_CLOSE, so no one can
> > +		 * read this sk_incoming_cpu concurrently.
> > +		 */
> > +		sk->sk_incoming_cpu = val;
> > +		goto out;
> > +	}
> > +
> > +	/* This must be done under reuseport_lock to avoid a race with
> > +	 * reuseport_grow(), which accesses sk->sk_incoming_cpu without
> > +	 * lock_sock() when detaching a shutdown()ed sk.
> > +	 *
> > +	 * paired with READ_ONCE() in reuseport_select_sock_by_hash()
> > +	 */
> > +	WRITE_ONCE(sk->sk_incoming_cpu, val);
> > +
> > +	if (sk->sk_incoming_cpu < 0 && val >= 0)
> 
> I don't see how the above condition can be true given the previous
> statement ?!?

Ah... sorry, at first the WRITE_ONCE() above was put just before the
"out:" label below, but I moved it while writing the changelog so that
we won't publish the invalid state for the fast path:

  1. slow path set reuse->incoming_cpu before setting sk->sk_incoming_cpu

  2. fast path saw reuse->incoming_cpu >= 1, started iteration, but
     found no socket with sk->sk_incoming_cpu

  3. slow path do WRITE_ONCE(sk->sk_incoming_cpu, val)


> Possibly you can use something alike:
> 
> 	old_sk_incoming_cpu = sk->sk_incoming_cpu
> 	WRITE_ONCE(sk->sk_incoming_cpu, val);
> 	if (!reuse)
> 		goto out;
> 
> 	if (old_sk_incoming_cpu < 0)

Yes, we have to use the old value.

> 		reuseport_incoming_cpu_inc()
> 
> So that:
> - can additonal avoid the '__' helper variants

But, we still need '__' helper to decrement the count if the change
is 1 -> -1.


> - a single write statement, no need to optimize out the WRITE_ONCE in
> the !reuse corner case
> 
> > +		__reuseport_incoming_cpu_inc(sk, reuse);
> > +	else if (sk->sk_incoming_cpu >= 0 && val < 0)
> > +		__reuseport_incoming_cpu_dec(sk, reuse);
> > +
> > +out:
> > +	spin_unlock_bh(&reuseport_lock);
> > +}
> > +
> >  static int reuseport_sock_index(struct sock *sk,
> >  				const struct sock_reuseport *reuse,
> >  				bool closed)
> > @@ -48,6 +106,7 @@ static void __reuseport_add_sock(struct sock *sk,
> >  	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
> >  	smp_wmb();
> >  	reuse->num_socks++;
> > +	reuseport_incoming_cpu_inc(sk, reuse);
> >  }
> >  
> >  static bool __reuseport_detach_sock(struct sock *sk,
> > @@ -60,6 +119,7 @@ static bool __reuseport_detach_sock(struct sock *sk,
> >  
> >  	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
> >  	reuse->num_socks--;
> > +	reuseport_incoming_cpu_dec(sk, reuse);
> >  
> >  	return true;
> >  }
> > @@ -70,6 +130,7 @@ static void __reuseport_add_closed_sock(struct sock *sk,
> >  	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
> >  	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> >  	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
> > +	reuseport_incoming_cpu_inc(sk, reuse);
> >  }
> >  
> >  static bool __reuseport_detach_closed_sock(struct sock *sk,
> > @@ -83,6 +144,7 @@ static bool __reuseport_detach_closed_sock(struct sock *sk,
> >  	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
> >  	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> >  	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
> > +	reuseport_incoming_cpu_dec(sk, reuse);
> >  
> >  	return true;
> >  }
> > @@ -150,6 +212,7 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> >  	reuse->bind_inany = bind_inany;
> >  	reuse->socks[0] = sk;
> >  	reuse->num_socks = 1;
> > +	reuseport_incoming_cpu_inc(sk, reuse);
> >  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
> >  
> >  out:
> > @@ -193,6 +256,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
> >  	more_reuse->reuseport_id = reuse->reuseport_id;
> >  	more_reuse->bind_inany = reuse->bind_inany;
> >  	more_reuse->has_conns = reuse->has_conns;
> > +	more_reuse->incoming_cpu = reuse->incoming_cpu;
> >  
> >  	memcpy(more_reuse->socks, reuse->socks,
> >  	       reuse->num_socks * sizeof(struct sock *));
> > @@ -442,18 +506,32 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
> >  static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
> >  						  u32 hash, u16 num_socks)
> >  {
> > +	struct sock *first_valid_sk = NULL;
> >  	int i, j;
> >  
> >  	i = j = reciprocal_scale(hash, num_socks);
> > -	while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
> > +	do {
> > +		struct sock *sk = reuse->socks[i];
> > +
> > +		if (sk->sk_state != TCP_ESTABLISHED) {
> > +			/* paired with WRITE_ONCE() in __reuseport_incoming_cpu_(inc|dec)() */
> > +			if (!READ_ONCE(reuse->incoming_cpu))
> > +				return sk;
> > +
> > +			/* paired with WRITE_ONCE() in reuseport_incoming_cpu_update() */
> > +			if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
> > +				return sk;
> > +
> > +			if (!first_valid_sk)
> > +				first_valid_sk = sk;
> > +		}
> > +
> >  		i++;
> >  		if (i >= num_socks)
> >  			i = 0;
> > -		if (i == j)
> > -			return NULL;
> > -	}
> > +	} while (i != j);
> >  
> > -	return reuse->socks[i];
> > +	return first_valid_sk;
> >  }
> > 
> IMHO this looks a bit too complex and possibly dangerous for -net. Have
> you considered a net-next target?

I thought this was regression and targeted -net, but considering no one
noticed it so long, I'm ok with net-next.

Thank you!
