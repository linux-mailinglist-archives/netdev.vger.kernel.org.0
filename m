Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFAB2D23A1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLHGcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:32:01 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50209 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHGcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 01:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607409120; x=1638945120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=C7ZcFehcUqocuA0ly3mDDSJkojj8ex1hoAIe5Cghb3k=;
  b=smJ6QThqSxLSmTlqsMBqat3ijNLpO0uizbNPcaZoF0p6eL6b7TB9kgTE
   QYEf2j4wJ76IVRYEX83aInGz1TzsmOroDEEFeFpWyuRLmxprOgmnMTOVm
   HtxKUpA+DeQd+IBpAm1zm1IAmISI5ZJAEIYT9CZOwue4AB0ai+pvRUBiT
   0=;
X-IronPort-AV: E=Sophos;i="5.78,401,1599523200"; 
   d="scan'208";a="101224695"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Dec 2020 06:31:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id CA131A1C72;
        Tue,  8 Dec 2020 06:27:23 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 06:27:23 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 06:27:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 8 Dec 2020 15:27:14 +0900
Message-ID: <20201208062714.96230-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207201438.kdlfdspusadadfvi@kafai-mbp.dhcp.thefacebook.com>
References: <20201207201438.kdlfdspusadadfvi@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D08UWC003.ant.amazon.com (10.43.162.21) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Mon, 7 Dec 2020 12:14:38 -0800
> On Sun, Dec 06, 2020 at 01:03:07AM +0900, Kuniyuki Iwashima wrote:
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Fri, 4 Dec 2020 17:42:41 -0800
> > > On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> > > [ ... ]
> > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > index fd133516ac0e..60d7c1f28809 100644
> > > > --- a/net/core/sock_reuseport.c
> > > > +++ b/net/core/sock_reuseport.c
> > > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > > >  }
> > > >  EXPORT_SYMBOL(reuseport_add_sock);
> > > >  
> > > > -void reuseport_detach_sock(struct sock *sk)
> > > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > > >  {
> > > >  	struct sock_reuseport *reuse;
> > > > +	struct bpf_prog *prog;
> > > > +	struct sock *nsk = NULL;
> > > >  	int i;
> > > >  
> > > >  	spin_lock_bh(&reuseport_lock);
> > > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > > >  
> > > >  		reuse->num_socks--;
> > > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > > +		prog = rcu_dereference(reuse->prog);
> > > Is it under rcu_read_lock() here?
> > 
> > reuseport_lock is locked in this function, and we do not modify the prog,
> > but is rcu_dereference_protected() preferable?
> > 
> > ---8<---
> > prog = rcu_dereference_protected(reuse->prog,
> > 				 lockdep_is_held(&reuseport_lock));
> > ---8<---
> It is not only reuse->prog.  Other things also require rcu_read_lock(),
> e.g. please take a look at __htab_map_lookup_elem().
> 
> The TCP_LISTEN sk (selected by bpf to be the target of the migration)
> is also protected by rcu.

Thank you, I will use rcu_read_lock() and rcu_dereference() in v3 patchset.


> I am surprised there is no WARNING in the test.
> Do you have the needed DEBUG_LOCK* config enabled?

Yes, DEBUG_LOCK* was 'y', but rcu_dereference() without rcu_read_lock()
does not show warnings...


> > > >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > > > +			if (reuse->num_socks && !prog)
> > > > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > > +
> > > >  			reuse->num_closed_socks++;
> > > >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > > >  		} else {
> > > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > > >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> > > >  out:
> > > >  	spin_unlock_bh(&reuseport_lock);
> > > > +
> > > > +	return nsk;
> > > >  }
> > > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > > >  
> > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > index 1451aa9712b0..b27241ea96bd 100644
> > > > --- a/net/ipv4/inet_connection_sock.c
> > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > >  }
> > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > >  
> > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > > +{
> > > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > > +
> > > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > +
> > > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > > +	spin_lock(&new_accept_queue->rskq_lock);
> > > I am also not very thrilled on this double spin_lock.
> > > Can this be done in (or like) inet_csk_listen_stop() instead?
> > 
> > It will be possible to migrate sockets in inet_csk_listen_stop(), but I
> > think it is better to do it just after reuseport_detach_sock() becuase we
> > can select a different listener (almost) every time at a lower cost by
> > selecting the moved socket and pass it to inet_csk_reqsk_queue_migrate()
> > easily.
> I don't see the "lower cost" point.  Please elaborate.

In reuseport_select_sock(), we pass sk_hash of the request socket to
reciprocal_scale() and generate a random index for socks[] to select
a different listener every time.
On the other hand, we do not have request sockets in unhash path and
sk_hash of the listener is always 0, so we have to generate a random number
in another way. In reuseport_detach_sock(), we can use the index of the
moved socket, but we do not have it in inet_csk_listen_stop(), so we have
to generate a random number in inet_csk_listen_stop().
I think it is at lower cost to use the index of the moved socket.


> > sk_hash of the listener is 0, so we would have to generate a random number
> > in inet_csk_listen_stop().
> If I read it correctly, it is also passing 0 as the sk_hash to
> bpf_run_sk_reuseport() from reuseport_detach_sock().
> 
> Also, how is the sk_hash expected to be used?  I don't see
> it in the test.

I expected it should not be used in unhash path.
We do not have the request socket in unhash path and cannot pass a proper
sk_hash to bpf_run_sk_reuseport(). So, if u8 migration is
BPF_SK_REUSEPORT_MIGRATE_QUEUE, we cannot use sk_hash.
