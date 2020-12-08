Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9CB2D23A4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgLHGcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:32:19 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50209 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHGcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 01:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607409136; x=1638945136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=7pwyuLLLuZqptOe9MDUKmSBlE5PscyioEMKK+ZnoHRY=;
  b=eEEqT/PNxAeOTlxt6A0SMOLoF3yOxoV2WT2s3JZXe4dF/cStXh0WHchN
   nX0/gfUqIyK732FdkmSPodcw1/prSe0u716yBkRl7z86Fd5FPVW26Me2m
   8eTkK1/U4XwcWJUivYC4YNEfWbVgsVJUWFg8ptpPugE2xt/jEj9H2DBf6
   E=;
X-IronPort-AV: E=Sophos;i="5.78,401,1599523200"; 
   d="scan'208";a="101224758"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Dec 2020 06:31:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id ADD62A257E;
        Tue,  8 Dec 2020 06:31:43 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 06:31:42 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.68) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 06:31:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 8 Dec 2020 15:31:34 +0900
Message-ID: <20201208063134.97189-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207203227.lcwdihxfwral3uz7@kafai-mbp.dhcp.thefacebook.com>
References: <20201207203227.lcwdihxfwral3uz7@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D36UWA002.ant.amazon.com (10.43.160.24) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Mon, 7 Dec 2020 12:33:15 -0800
> On Thu, Dec 03, 2020 at 11:14:24PM +0900, Kuniyuki Iwashima wrote:
> > From:   Eric Dumazet <eric.dumazet@gmail.com>
> > Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > which is used only by inet_unhash(). If it is not NULL,
> > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > sockets from the closing listener to the selected one.
> > > > 
> > > > Listening sockets hold incoming connections as a linked list of struct
> > > > request_sock in the accept queue, and each request has reference to a full
> > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > > the requests from the closing listener's queue and relink them to the head
> > > > of the new listener's queue. We do not process each request and its
> > > > reference to the listener, so the migration completes in O(1) time
> > > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > > care in the next commit.
> > > > 
> > > > By default, the kernel selects a new listener randomly. In order to pick
> > > > out a different socket every time, we select the last element of socks[] as
> > > > the new listener. This behaviour is based on how the kernel moves sockets
> > > > in socks[]. (See also [1])
> > > > 
> > > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > > program called in the later commit, but as the side effect of such default
> > > > selection, the kernel can redistribute old requests evenly to new listeners
> > > > for a specific case where the application replaces listeners by
> > > > generations.
> > > > 
> > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > first two by turns. The sockets move in socks[] like below.
> > > > 
> > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > >   socks[2] : C   |      socks[2] : C --'
> > > >   socks[3] : D --'
> > > > 
> > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > requests evenly to new listeners.
> > > > 
> > > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > > >   socks[3] : D (d) --'
> > > > 
> > > > Here, (A, D) or (B, C) can have different application settings, but they
> > > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > > error may happen. For instance, if only the new listeners have
> > > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > > face inconsistency and cause an error.
> > > > 
> > > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > > program described in later commits.
> > > > 
> > > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > ---
> > > >  include/net/inet_connection_sock.h |  1 +
> > > >  include/net/sock_reuseport.h       |  2 +-
> > > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > > --- a/include/net/inet_connection_sock.h
> > > > +++ b/include/net/inet_connection_sock.h
> > > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > >  				      struct request_sock *req,
> > > >  				      struct sock *child);
> > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > > >  				   unsigned long timeout);
> > > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > > --- a/include/net/sock_reuseport.h
> > > > +++ b/include/net/sock_reuseport.h
> > > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > > >  			      bool bind_inany);
> > > > -extern void reuseport_detach_sock(struct sock *sk);
> > > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > > >  					  u32 hash,
> > > >  					  struct sk_buff *skb,
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
> > > >  
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
> > > 
> > > Are you sure lockdep is happy with this ?
> > > 
> > > I would guess it should complain, because :
> > > 
> > > lock(A);
> > > lock(B);
> > > ...
> > > unlock(B);
> > > unlock(A);
> > > 
> > > will fail when the opposite action happens eventually
> > > 
> > > lock(B);
> > > lock(A);
> > > ...
> > > unlock(A);
> > > unlock(B);
> > 
> > I enabled lockdep and did not see warnings of lockdep.
> > 
> > Also, the inversion deadlock does not happen in this case.
> > In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> > from the eBPF map, so the old listener will not be selected as the new
> > listener.
> > 
> > 
> > > > +
> > > > +	if (old_accept_queue->rskq_accept_head) {
> > > > +		if (new_accept_queue->rskq_accept_head)
> > > > +			old_accept_queue->rskq_accept_tail->dl_next =
> > > > +				new_accept_queue->rskq_accept_head;
> > > > +		else
> > > > +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> > > > +
> > > > +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> > > > +		old_accept_queue->rskq_accept_head = NULL;
> > > > +		old_accept_queue->rskq_accept_tail = NULL;
> > > > +
> > > > +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> > > > +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> > > > +	}
> > > > +
> > > > +	spin_unlock(&new_accept_queue->rskq_lock);
> > > > +	spin_unlock(&old_accept_queue->rskq_lock);
> > > > +}
> > > > +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> > > 
> > > I fail to understand how the kernel can run fine right after this patch, before following patches are merged.
> > 
> > I will squash the two or reorganize them into definition part and migration
> > part.
> > 
> > 
> > > All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
> > > this is how we designed things (each request socket has a reference taken on the listener)
> > > 
> > > We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.
> > > 
> > > Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.
> I also have similar concern on the inconsistency in req->rsk_listener.
> 
> The fix-up in req->rsk_listener for the TFO req in patch 4
> makes it clear that req->rsk_listener should be updated during
> the migration instead of asking a much later code path
> to accommodate this inconsistent req->rsk_listener pointer.

When I started this patchset, I read this thread and misunderstood that I
had to migrate sockets in O(1) for scalability. So, I selected the fix-up
approach and checked rsk_listener is not used except for TFO.

---8<---
Whole point of BPF was to avoid iterate through all sockets [1],
and let user space use whatever selection logic it needs.

[1] This was okay with up to 16 sockets. But with 128 it does not scale.
---&<---
https://lore.kernel.org/netdev/1458837191.12033.4.camel@edumazet-glaptop3.roam.corp.google.com/


However, I've read it again, and this was about iterating over listeners
to select a new listener, not about iterating over requests...
In this patchset, we can select a listener in O(1) and it is enough.


> The current inet_csk_listen_stop() is already iterating
> the icsk_accept_queue and fastopenq.  The extra cost
> in updating rsk_listener may be just noise?

Exactly.
If we end up iterating requests, it is better to migrate than close. I will
update each rsk_listener in inet_csk_reqsk_queue_migrate() in v3 patchset.
Thank you!
