Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BE63A3731
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFJWft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:35:49 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:22087 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhFJWft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623364432; x=1654900432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z8qDzryaSUenTxwIjslyQEuyJ+xmM2kVWafZLrXfwuo=;
  b=OCWTgwOQ+aO8ErxoW6Zqm4LB6/oB8+NtgRaPq9L1ZDp8yJCp8/0nHIuU
   NNr9uz0kN/j5PiigTCczUR6awUpX2YXVdQ6VIH3tMrI7rJBWlphGKJl65
   ZsxIY/aMozPFaLWurluGTlEUvtMUcYZYHr6gOI+F1wZbaBGL+vUm7UkVD
   A=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="113556069"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 10 Jun 2021 22:33:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 5346BA1C95;
        Thu, 10 Jun 2021 22:33:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:33:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.131) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:33:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 02/11] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Fri, 11 Jun 2021 07:33:39 +0900
Message-ID: <20210610223339.97487-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <942283cd-4b8a-5127-b047-0e26031adc6c@gmail.com>
References: <942283cd-4b8a-5127-b047-0e26031adc6c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.131]
X-ClientProxiedBy: EX13D28UWB002.ant.amazon.com (10.43.161.140) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 19:38:45 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > As noted in the following commit, a closed listener has to hold the
> > reference to the reuseport group for socket migration. This patch adds a
> > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > within the same reuseport group. Moreover, this and the following commits
> > introduce some helper functions to split socks[] into two sections and keep
> > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > sockets from the end.
> > 
> >   TCP_LISTEN---------->       <-------TCP_CLOSE
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > 
> >   i = num_socks - 1
> >   j = max_socks - num_closed_socks
> >   k = max_socks - 1
> > 
> > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > support num_closed_socks.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/net/sock_reuseport.h |  5 ++-
> >  net/core/sock_reuseport.c    | 76 +++++++++++++++++++++++++++---------
> >  2 files changed, 60 insertions(+), 21 deletions(-)
> > 
> > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > index 505f1e18e9bf..0e558ca7afbf 100644
> > --- a/include/net/sock_reuseport.h
> > +++ b/include/net/sock_reuseport.h
> > @@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
> >  struct sock_reuseport {
> >  	struct rcu_head		rcu;
> >  
> > -	u16			max_socks;	/* length of socks */
> > -	u16			num_socks;	/* elements in socks */
> > +	u16			max_socks;		/* length of socks */
> > +	u16			num_socks;		/* elements in socks */
> > +	u16			num_closed_socks;	/* closed elements in socks */
> >  	/* The last synq overflow event timestamp of this
> >  	 * reuse->socks[] group.
> >  	 */
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index b065f0a103ed..079bd1aca0e7 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -18,6 +18,49 @@ DEFINE_SPINLOCK(reuseport_lock);
> >  
> >  static DEFINE_IDA(reuseport_ida);
> >  
> > +static int reuseport_sock_index(struct sock *sk,
> > +				struct sock_reuseport *reuse,
> > +				bool closed)
> 
> 
> const struct sock_reuseport *reuse

I will add const to reuse.
Don't I need to make sk const?


> 
> 
> > +{
> > +	int left, right;
> > +
> > +	if (!closed) {
> > +		left = 0;
> > +		right = reuse->num_socks;
> > +	} else {
> > +		left = reuse->max_socks - reuse->num_closed_socks;
> > +		right = reuse->max_socks;
> > +	}
> 
> 
> 
> > +
> > +	for (; left < right; left++)
> > +		if (reuse->socks[left] == sk)
> > +			return left;
> 
> 
> Is this even possible (to return -1) ?
> 
> > +	return -1;

Yes.
In the next patch, reuseport_detach_sock() tries to detach a sock from the
closed section first.  So, if tcp_migrate_req is disabled, then -1 is
returned immediately because left == right.

===
        if (!__reuseport_detach_closed_sock(sk, reuse))
                __reuseport_detach_sock(sk, reuse);
===


> > +}
> > +
> > +static void __reuseport_add_sock(struct sock *sk,
> > +				 struct sock_reuseport *reuse)
> > +{
> > +	reuse->socks[reuse->num_socks] = sk;
> > +	/* paired with smp_rmb() in reuseport_select_sock() */
> > +	smp_wmb();
> > +	reuse->num_socks++;
> > +}
> > +
> > +static bool __reuseport_detach_sock(struct sock *sk,
> > +				    struct sock_reuseport *reuse)
> > +{
> > +	int i = reuseport_sock_index(sk, reuse, false);
> > +
> > +	if (i == -1)
> > +		return false;
> > +
> > +	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
> > +	reuse->num_socks--;
> > +
> > +	return true;
> > +}
> > +
> >  static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
> >  {
> >  	unsigned int size = sizeof(struct sock_reuseport) +
> > @@ -72,9 +115,8 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> >  	}
> >  
> >  	reuse->reuseport_id = id;
> > -	reuse->socks[0] = sk;
> > -	reuse->num_socks = 1;
> >  	reuse->bind_inany = bind_inany;
> > +	__reuseport_add_sock(sk, reuse);
> 
> Not sure why you changed this part, really no smp_wmb() is needed at this point ?

I have just reused the helper function, but exactly smp_wmb() is not
needed.  I will keep here as is.


> 
> >  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
> >  
> >  out:
> > @@ -98,6 +140,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
> >  		return NULL;
> >  
> >  	more_reuse->num_socks = reuse->num_socks;
> > +	more_reuse->num_closed_socks = reuse->num_closed_socks;
> >  	more_reuse->prog = reuse->prog;
> >  	more_reuse->reuseport_id = reuse->reuseport_id;
> >  	more_reuse->bind_inany = reuse->bind_inany;
> > @@ -105,9 +148,13 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
> >  
> >  	memcpy(more_reuse->socks, reuse->socks,
> >  	       reuse->num_socks * sizeof(struct sock *));
> > +	memcpy(more_reuse->socks +
> > +	       (more_reuse->max_socks - more_reuse->num_closed_socks),
> > +	       reuse->socks + reuse->num_socks,
> 
> The second memcpy() is to copy the closed sockets,
> they should start at reuse->socks + (reuse->max_socks - reuse->num_closed_socks) ?

num_socks == (reuse->max_socks - reuse->num_closed_socks) here, but I think
the latter is less error-prone so I will fix that.

Thank you.


> 
> 
> > +	       reuse->num_closed_socks * sizeof(struct sock *));
> >  	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
> >  
> > -	for (i = 0; i < reuse->num_socks; ++i)
> > +	for (i = 0; i < reuse->max_socks; ++i)
> >  		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> >  				   more_reuse);
> >  
> > @@ -158,7 +205,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> >  		return -EBUSY;
> >  	}
> >  
> > -	if (reuse->num_socks == reuse->max_socks) {
> > +	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
> >  		reuse = reuseport_grow(reuse);
> >  		if (!reuse) {
> >  			spin_unlock_bh(&reuseport_lock);
> > @@ -166,10 +213,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> >  		}
> >  	}
> >  
> > -	reuse->socks[reuse->num_socks] = sk;
> > -	/* paired with smp_rmb() in reuseport_select_sock() */
> > -	smp_wmb();
> > -	reuse->num_socks++;
> > +	__reuseport_add_sock(sk, reuse);
> >  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
> >  
> >  	spin_unlock_bh(&reuseport_lock);
> > @@ -183,7 +227,6 @@ EXPORT_SYMBOL(reuseport_add_sock);
> >  void reuseport_detach_sock(struct sock *sk)
> >  {
> >  	struct sock_reuseport *reuse;
> > -	int i;
> >  
> >  	spin_lock_bh(&reuseport_lock);
> >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > @@ -200,16 +243,11 @@ void reuseport_detach_sock(struct sock *sk)
> >  	bpf_sk_reuseport_detach(sk);
> >  
> >  	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
> > +	__reuseport_detach_sock(sk, reuse);
> > +
> > +	if (reuse->num_socks + reuse->num_closed_socks == 0)
> > +		call_rcu(&reuse->rcu, reuseport_free_rcu);
> >  
> > -	for (i = 0; i < reuse->num_socks; i++) {
> > -		if (reuse->socks[i] == sk) {
> > -			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
> > -			reuse->num_socks--;
> > -			if (reuse->num_socks == 0)
> > -				call_rcu(&reuse->rcu, reuseport_free_rcu);
> > -			break;
> > -		}
> > -	}
> >  	spin_unlock_bh(&reuseport_lock);
> >  }
> >  EXPORT_SYMBOL(reuseport_detach_sock);
> > @@ -274,7 +312,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
> >  	prog = rcu_dereference(reuse->prog);
> >  	socks = READ_ONCE(reuse->num_socks);
> >  	if (likely(socks)) {
> > -		/* paired with smp_wmb() in reuseport_add_sock() */
> > +		/* paired with smp_wmb() in __reuseport_add_sock() */
> >  		smp_rmb();
> >  
> >  		if (!prog || !skb)
> > 
