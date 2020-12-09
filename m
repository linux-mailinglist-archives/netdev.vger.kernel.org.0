Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E452D474B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732183AbgLIQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:58:45 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61924 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgLIQ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607533107; x=1639069107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Qr3/C+oEbyhVIz3LQ53xBVVpc0Qr9xHZTMEAN60Y1Mw=;
  b=W7yJyXgVlfKLXwAps2RBe0S5vj2vNUQWQdvX8RiJ4GQRpA5XClSCzFoQ
   jCQZbfscjQ2GZJtHlBeTGZVjRmaBgkjXL06IO7b8dwd3dxW1bJ1UBvQnZ
   YCsxfGi6BfiVC11+zOPLWSbXIw0ZhYU+3VsR3USKURHDYxi61Jx+x2Zxs
   0=;
X-IronPort-AV: E=Sophos;i="5.78,405,1599523200"; 
   d="scan'208";a="94697173"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 09 Dec 2020 16:57:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id E4C66A1E0C;
        Wed,  9 Dec 2020 16:57:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Dec 2020 16:57:27 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.27) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Dec 2020 16:57:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <kuniyu@amazon.co.jp>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <eric.dumazet@gmail.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Thu, 10 Dec 2020 01:57:19 +0900
Message-ID: <20201209165719.73652-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201209080509.66504-1-kuniyu@amazon.co.jp>
References: <20201209080509.66504-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D29UWC004.ant.amazon.com (10.43.162.25) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Wed, 9 Dec 2020 17:05:09 +0900
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Tue, 8 Dec 2020 19:09:03 -0800
> > On Tue, Dec 08, 2020 at 05:17:48PM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Mon, 7 Dec 2020 23:34:41 -0800
> > > > On Tue, Dec 08, 2020 at 03:31:34PM +0900, Kuniyuki Iwashima wrote:
> > > > > From:   Martin KaFai Lau <kafai@fb.com>
> > > > > Date:   Mon, 7 Dec 2020 12:33:15 -0800
> > > > > > On Thu, Dec 03, 2020 at 11:14:24PM +0900, Kuniyuki Iwashima wrote:
> > > > > > > From:   Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > > Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > > > > > > > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > > > > > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > > > > > > which is used only by inet_unhash(). If it is not NULL,
> > > > > > > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > > > > > > sockets from the closing listener to the selected one.
> > > > > > > > > 
> > > > > > > > > Listening sockets hold incoming connections as a linked list of struct
> > > > > > > > > request_sock in the accept queue, and each request has reference to a full
> > > > > > > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > > > > > > > the requests from the closing listener's queue and relink them to the head
> > > > > > > > > of the new listener's queue. We do not process each request and its
> > > > > > > > > reference to the listener, so the migration completes in O(1) time
> > > > > > > > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > > > > > > > care in the next commit.
> > > > > > > > > 
> > > > > > > > > By default, the kernel selects a new listener randomly. In order to pick
> > > > > > > > > out a different socket every time, we select the last element of socks[] as
> > > > > > > > > the new listener. This behaviour is based on how the kernel moves sockets
> > > > > > > > > in socks[]. (See also [1])
> > > > > > > > > 
> > > > > > > > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > > > > > > > program called in the later commit, but as the side effect of such default
> > > > > > > > > selection, the kernel can redistribute old requests evenly to new listeners
> > > > > > > > > for a specific case where the application replaces listeners by
> > > > > > > > > generations.
> > > > > > > > > 
> > > > > > > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > > > > > > first two by turns. The sockets move in socks[] like below.
> > > > > > > > > 
> > > > > > > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > > > > > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > > > > > > >   socks[2] : C   |      socks[2] : C --'
> > > > > > > > >   socks[3] : D --'
> > > > > > > > > 
> > > > > > > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > > > > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > > > > > > requests evenly to new listeners.
> > > > > > > > > 
> > > > > > > > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > > > > > > > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > > > > > > > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > > > > > > > >   socks[3] : D (d) --'
> > > > > > > > > 
> > > > > > > > > Here, (A, D) or (B, C) can have different application settings, but they
> > > > > > > > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > > > > > > > error may happen. For instance, if only the new listeners have
> > > > > > > > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > > > > > > > face inconsistency and cause an error.
> > > > > > > > > 
> > > > > > > > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > > > > > > > program described in later commits.
> > > > > > > > > 
> > > > > > > > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > > > > > > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > > > > ---
> > > > > > > > >  include/net/inet_connection_sock.h |  1 +
> > > > > > > > >  include/net/sock_reuseport.h       |  2 +-
> > > > > > > > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > > > > > > > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > > > > > > > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > > > > > > > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > > > > > > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > > > > > > > --- a/include/net/inet_connection_sock.h
> > > > > > > > > +++ b/include/net/inet_connection_sock.h
> > > > > > > > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > > > > > > > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > > > > > >  				      struct request_sock *req,
> > > > > > > > >  				      struct sock *child);
> > > > > > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > > > > > > > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > > > > > > > >  				   unsigned long timeout);
> > > > > > > > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > > > > > > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > > > > > > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > > > > > > > --- a/include/net/sock_reuseport.h
> > > > > > > > > +++ b/include/net/sock_reuseport.h
> > > > > > > > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > > > > > > > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > > > > > > > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > > > > > > > >  			      bool bind_inany);
> > > > > > > > > -extern void reuseport_detach_sock(struct sock *sk);
> > > > > > > > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > > > > > > > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > > > > > > > >  					  u32 hash,
> > > > > > > > >  					  struct sk_buff *skb,
> > > > > > > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > > > > > > index fd133516ac0e..60d7c1f28809 100644
> > > > > > > > > --- a/net/core/sock_reuseport.c
> > > > > > > > > +++ b/net/core/sock_reuseport.c
> > > > > > > > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > > > > > > > >  }
> > > > > > > > >  EXPORT_SYMBOL(reuseport_add_sock);
> > > > > > > > >  
> > > > > > > > > -void reuseport_detach_sock(struct sock *sk)
> > > > > > > > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > > > > > > > >  {
> > > > > > > > >  	struct sock_reuseport *reuse;
> > > > > > > > > +	struct bpf_prog *prog;
> > > > > > > > > +	struct sock *nsk = NULL;
> > > > > > > > >  	int i;
> > > > > > > > >  
> > > > > > > > >  	spin_lock_bh(&reuseport_lock);
> > > > > > > > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > > > > > > > >  
> > > > > > > > >  		reuse->num_socks--;
> > > > > > > > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > > > > > > > +		prog = rcu_dereference(reuse->prog);
> > > > > > > > >  
> > > > > > > > >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > > > > > > > > +			if (reuse->num_socks && !prog)
> > > > > > > > > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > > > > > > > +
> > > > > > > > >  			reuse->num_closed_socks++;
> > > > > > > > >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > > > > > > > >  		} else {
> > > > > > > > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > > > > > > > >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> > > > > > > > >  out:
> > > > > > > > >  	spin_unlock_bh(&reuseport_lock);
> > > > > > > > > +
> > > > > > > > > +	return nsk;
> > > > > > > > >  }
> > > > > > > > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > > > > > > > >  
> > > > > > > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > > > > > > index 1451aa9712b0..b27241ea96bd 100644
> > > > > > > > > --- a/net/ipv4/inet_connection_sock.c
> > > > > > > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > > > > > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > > > > > >  }
> > > > > > > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > > > > > > >  
> > > > > > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > > > > > > > +{
> > > > > > > > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > > > > > > > +
> > > > > > > > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > > > > > > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > > > > > > +
> > > > > > > > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > > > > > > > +	spin_lock(&new_accept_queue->rskq_lock);
> > > > > > > > 
> > > > > > > > Are you sure lockdep is happy with this ?
> > > > > > > > 
> > > > > > > > I would guess it should complain, because :
> > > > > > > > 
> > > > > > > > lock(A);
> > > > > > > > lock(B);
> > > > > > > > ...
> > > > > > > > unlock(B);
> > > > > > > > unlock(A);
> > > > > > > > 
> > > > > > > > will fail when the opposite action happens eventually
> > > > > > > > 
> > > > > > > > lock(B);
> > > > > > > > lock(A);
> > > > > > > > ...
> > > > > > > > unlock(A);
> > > > > > > > unlock(B);
> > > > > > > 
> > > > > > > I enabled lockdep and did not see warnings of lockdep.
> > > > > > > 
> > > > > > > Also, the inversion deadlock does not happen in this case.
> > > > > > > In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> > > > > > > from the eBPF map, so the old listener will not be selected as the new
> > > > > > > listener.
> > > > > > > 
> > > > > > > 
> > > > > > > > > +
> > > > > > > > > +	if (old_accept_queue->rskq_accept_head) {
> > > > > > > > > +		if (new_accept_queue->rskq_accept_head)
> > > > > > > > > +			old_accept_queue->rskq_accept_tail->dl_next =
> > > > > > > > > +				new_accept_queue->rskq_accept_head;
> > > > > > > > > +		else
> > > > > > > > > +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> > > > > > > > > +
> > > > > > > > > +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> > > > > > > > > +		old_accept_queue->rskq_accept_head = NULL;
> > > > > > > > > +		old_accept_queue->rskq_accept_tail = NULL;
> > > > > > > > > +
> > > > > > > > > +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> > > > > > > > > +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> > > > > > > > > +	}
> > > > > > > > > +
> > > > > > > > > +	spin_unlock(&new_accept_queue->rskq_lock);
> > > > > > > > > +	spin_unlock(&old_accept_queue->rskq_lock);
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> > > > > > > > 
> > > > > > > > I fail to understand how the kernel can run fine right after this patch, before following patches are merged.
> > > > > > > 
> > > > > > > I will squash the two or reorganize them into definition part and migration
> > > > > > > part.
> > > > > > > 
> > > > > > > 
> > > > > > > > All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
> > > > > > > > this is how we designed things (each request socket has a reference taken on the listener)
> > > > > > > > 
> > > > > > > > We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.
> > > > > > > > 
> > > > > > > > Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.
> > > > > > I also have similar concern on the inconsistency in req->rsk_listener.
> > > > > > 
> > > > > > The fix-up in req->rsk_listener for the TFO req in patch 4
> > > > > > makes it clear that req->rsk_listener should be updated during
> > > > > > the migration instead of asking a much later code path
> > > > > > to accommodate this inconsistent req->rsk_listener pointer.
> > > > > 
> > > > > When I started this patchset, I read this thread and misunderstood that I
> > > > > had to migrate sockets in O(1) for scalability. So, I selected the fix-up
> > > > > approach and checked rsk_listener is not used except for TFO.
> > > > > 
> > > > > ---8<---
> > > > > Whole point of BPF was to avoid iterate through all sockets [1],
> > > > > and let user space use whatever selection logic it needs.
> > > > > 
> > > > > [1] This was okay with up to 16 sockets. But with 128 it does not scale.
> > > > > ---&<---
> > > > > https://lore.kernel.org/netdev/1458837191.12033.4.camel@edumazet-glaptop3.roam.corp.google.com/
> > > > > 
> > > > > 
> > > > > However, I've read it again, and this was about iterating over listeners
> > > > > to select a new listener, not about iterating over requests...
> > > > > In this patchset, we can select a listener in O(1) and it is enough.
> > > > > 
> > > > > 
> > > > > > The current inet_csk_listen_stop() is already iterating
> > > > > > the icsk_accept_queue and fastopenq.  The extra cost
> > > > > > in updating rsk_listener may be just noise?
> > > > > 
> > > > > Exactly.
> > > > > If we end up iterating requests, it is better to migrate than close. I will
> > > > > update each rsk_listener in inet_csk_reqsk_queue_migrate() in v3 patchset.
> > > > To be clear, I meant to do migration in inet_csk_listen_stop() instead
> > > > of doing it in the new inet_csk_reqsk_queue_migrate() which reqires a
> > > > double lock and then need to re-bring in the whole spin_lock_bh_nested
> > > > patch in the patch 3 of v2.
> > > > 
> > > > e.g. in the first while loop in inet_csk_listen_stop(),
> > > > if there is a target to migrate to,  it can do
> > > > something similar to inet_csk_reqsk_queue_add(target_sk, ...)
> > > > instead of doing the current inet_child_forget().
> > > > It probably needs something different from
> > > > inet_csk_reqsk_queue_add(), e.g. also update rsk_listener,
> > > > but the idea should be similar.
> > > > 
> > > > Since the rsk_listener has to be updated one by one, there is
> > > > really no point to do the list splicing which requires
> > > > the double lock.
> > > 
> > > I think it is a bit complex to pass the new listener from
> > > reuseport_detach_sock() to inet_csk_listen_stop().
> > > 
> > > __tcp_close/tcp_disconnect/tcp_abort
> > >  |-tcp_set_state
> > >  |  |-unhash
> > >  |     |-reuseport_detach_sock (return nsk)
> > >  |-inet_csk_listen_stop
> > Picking the new listener does not have to be done in
> > reuseport_detach_sock().
> > 
> > IIUC, it is done there only because it prefers to pick
> > the last sk from socks[] when bpf prog is not attached.
> > This seems to get into the way of exploring other potential
> > implementation options.
> 
> Yes.
> This is just idea, but we can reserve the last index of socks[] to hold the
> last 'moved' socket in reuseport_detach_sock() and use it in
> inet_csk_listen_stop().
> 
> 
> > Merging the discussion on the last socks[] pick from another thread:
> > >
> > > I think most applications start new listeners before closing listeners, in
> > > this case, selecting the moved socket as the new listener works well.
> > >
> > >
> > > > That said, if it is still desired to do a random pick by kernel when
> > > > there is no bpf prog, it probably makes sense to guard it in a sysctl as
> > > > suggested in another reply.  To keep it simple, I would also keep this
> > > > kernel-pick consistent instead of request socket is doing something
> > > > different from the unhash path.
> > >
> > > Then, is this way better to keep kernel-pick consistent?
> > >
> > >   1. call reuseport_select_migrated_sock() without sk_hash from any path
> > >   2. generate a random number in reuseport_select_migrated_sock()
> > >   3. pass it to __reuseport_select_sock() only for select-by-hash
> > >   (4. pass 0 as sk_hash to bpf_run_sk_reuseport not to use it)
> > >   5. do migration per queue in inet_csk_listen_stop() or per request in
> > >      receive path.
> > >
> > > I understand it is beautiful to keep consistensy, but also think
> > > the kernel-pick with heuristic performs better than random-pick.
> > I think discussing the best kernel pick without explicit user input
> > is going to be a dead end. There is always a case that
> > makes this heuristic (or guess) fail.  e.g. what if multiple
> > sk(s) being closed are always the last one in the socks[]?
> > all their child sk(s) will then be piled up at one listen sk
> > because the last socks[] is always picked?
> 
> There can be such a case, but it means the newly listened sockets are
> closed earlier than old ones.
> 
> 
> > Lets assume the last socks[] is indeed the best for all cases.  Then why
> > the in-progress req don't pick it this way?  I feel the implementation
> > is doing what is convenient at that point.  And that is fine, I think
> 
> In this patchset, I originally assumed four things:
> 
>   migration should be done
>     (i)   from old to new
>     (ii)  to redistribute requests evenly as possible
>     (iii) to keep the order of requests in the queue
>           (resulting in splicing queues)
>     (iv)  in O(1) for scalability
>           (resulting in fix-up rsk_listener approach)
> 
> I selected the last socket in unhash path to satisfy above four because the
> last socket changes at every close() syscall if application closes from
> older socket.
> 
> But in receiving ACK or retransmitting SYN+ACK, we cannot get the last
> 'moved' socket. Even if we reserve the last 'moved' socket in the last
> index by the idea above, we cannot sure the last socket is changed after
> close() for each req->listener. For example, we have listeners A, B, C, and
> D, and then call close(A) and close(B), and receive the final ACKs for A
> and B, then both of them are assigned to C. In this case, A for D and B for
> C is desired. So, selecting the last socket in socks[] for incoming
> requests cannnot realize (ii).
> 
> This is why I selected the last moved socket in unhash path and a random
> listener in receive path.
> 
> 
> > for kernel-pick, it should just go for simplicity and stay with
> > the random(/hash) pick instead of pretending the kernel knows the
> > application must operate in a certain way.  It is fine
> > that the pick was wrong, the kernel will eventually move the
> > childs/reqs to the survived listen sk.
> 
> Exactly. Also the heuristic way is not fair for every application.
> 
> After reading below idea (migrated_sk), I think random-pick is better
> at simplicity and passing each sk.
> 
> 
> > [ I still think the kernel should not even pick if
> >   there is no bpf prog to instruct how to pick
> >   but I am fine as long as there is a sysctl to
> >   guard this. ]
> 
> Unless different applications listen on the same port, random-pick can save
> connections which would be aborted. So, I would add a sysctl to do
> migration when no eBPF prog is attached.
> 
> 
> > I would rather focus on ensuring the bpf prog getting what it
> > needs to make the migration pick.  A few things
> > I would like to discuss and explore:
> > > If we splice requests like this, we do not need double lock?
> > > 
> > >   1. lock the accept queue of the old listener
> > >   2. unlink all requests and decrement refcount
> > >   3. unlock
> > >   4. update all requests with new listener
> > I guess updating rsk_listener can be done without acquiring
> > the lock in (5) below is because it is done under the
> > listening_hash's bucket lock (and also the global reuseport_lock) so
> > that the new listener will stay in TCP_LISTEN state?
> 
> If we do migration in inet_unhash(), the lock is held, but it is not held
> in inet_csk_listen_stop().
> 
> 
> > I am not sure iterating the queue under these
> > locks is a very good thing to do though.  The queue may not be
> > very long in usual setup but still let see
> > if that can be avoided.
> 
> I agree, lock should not be held long.
> 
> 
> > Do you think the iteration can be done without holding
> > bucket lock and the global reuseport_lock?  inet_csk_reqsk_queue_add()
> > is taking the rskq_lock and then check for TCP_LISTEN.  May be
> > something similar can be done also?
> 
> I think either one is necessary at least, so if the sk_state of selected
> listener is TCP_CLOSE (this is mostly by random-pick of kernel), then we
> have to fall back to call inet_child_forget().
> 
> 
> > While doing BPF_SK_REUSEPORT_MIGRATE_REQUEST,
> > the bpf prog can pick per req and have the sk_hash.
> > However, while doing BPF_SK_REUSEPORT_MIGRATE_QUEUE,
> > the bpf prog currently does not have a chance to
> > pick individually for each req/child on the queue.
> > Since it is iterating the queue anyway, does it make
> > sense to also call the bpf to pick for each req/child
> > in the queue?  It then can pass sk_hash (from child->sk_hash?)
> > to the bpf prog also instead of current 0.  The cost of calling
> > bpf prog is not really that much / signficant at the
> > migration code path.  If the queue is somehow
> > unusally long, there is already an existing
> > cond_resched() in inet_csk_listen_stop().
> > 
> > Then, instead of adding sk_reuseport_md->migration,
> > it can then add sk_reuseport_md->migrate_sk.
> > "migrate_sk = req" for in-progress req and "migrate_sk = child"
> > for iterating acceptq.  The bpf_prog can then tell what sk (req or child)
> > it is migrating by reading migrate_sk->state.  It can then also
> > learn the 4 tuples src/dst ip/port while skb is missing.
> > The sk_reuseport_md->sk can still point to the closed sk
> > such that the bpf prog can learn the cookie.
> > 
> > I suspect a few things between BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > and BPF_SK_REUSEPORT_MIGRATE_QUEUE can be folded together
> > by doing the above.  It also gives a more consistent
> > interface for the bpf prog, no more MIGRATE_QUEUE vs MIGRATE_REQUEST.
> 
> I think this is really nice idea. Also, I tried to implement random-pick
> one by one in inet_csk_listen_stop() yesterday, I found a concern about how
> to handle requests in TFO queue.
> 
> The request can be already accepted, so passing it to eBPF prog is
> confusing? But, redistributing randomly can affect all listeners
> unnecessary. How should we handle such requests?

I've implemented one-by-one migration only for the accept queue for now.
In addition to the concern about TFO queue, I want to discuss which should
we pass NULL or request_sock to eBPF program as migrate_sk when selecting a
listener for SYN ?

---8<---
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a82fd4c912be..d0ddd3cb988b 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1001,6 +1001,29 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
 
+static bool inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk, struct request_sock *req)
+{
+       struct request_sock_queue *queue = &inet_csk(nsk)->icsk_accept_queue;
+       bool migrated = false;
+
+       spin_lock(&queue->rskq_lock);
+       if (likely(nsk->sk_state == TCP_LISTEN)) {
+               migrated = true;
+
+               req->dl_next = NULL;
+               if (queue->rskq_accept_head == NULL)
+                       WRITE_ONCE(queue->rskq_accept_head, req);
+               else
+                       queue->rskq_accept_tail->dl_next = req;
+               queue->rskq_accept_tail = req;
+               sk_acceptq_added(nsk);
+               inet_csk_reqsk_queue_migrated(sk, nsk, req);
+       }
+       spin_unlock(&queue->rskq_lock);
+
+       return migrated;
+}
+
 struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
                                         struct request_sock *req, bool own_req)
 {
@@ -1023,9 +1046,11 @@ EXPORT_SYMBOL(inet_csk_complete_hashdance);
  */
 void inet_csk_listen_stop(struct sock *sk)
 {
+       struct sock_reuseport *reuseport_cb = rcu_access_pointer(sk->sk_reuseport_cb);
        struct inet_connection_sock *icsk = inet_csk(sk);
        struct request_sock_queue *queue = &icsk->icsk_accept_queue;
        struct request_sock *next, *req;
+       struct sock *nsk;
 
        /* Following specs, it would be better either to send FIN
         * (and enter FIN-WAIT-1, it is normal close)
@@ -1043,8 +1068,19 @@ void inet_csk_listen_stop(struct sock *sk)
                WARN_ON(sock_owned_by_user(child));
                sock_hold(child);
 
+               if (reuseport_cb) {
+                       nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, NULL);
+                       if (nsk) {
+                               if (inet_csk_reqsk_queue_migrate(sk, nsk, req))
+                                       goto unlock_sock;
+                               else
+                                       sock_put(nsk);
+                       }
+               }
+
                inet_child_forget(sk, req, child);
                reqsk_put(req);
+unlock_sock:
                bh_unlock_sock(child);
                local_bh_enable();
                sock_put(child);
---8<---


> > >   5. lock the accept queue of the new listener
> > >   6. splice requests and increment refcount
> > >   7. unlock
> > > 
> > > Also, I think splicing is better to keep the order of requests. Adding one
> > > by one reverses it.
> > It can keep the order but I think it is orthogonal here.
