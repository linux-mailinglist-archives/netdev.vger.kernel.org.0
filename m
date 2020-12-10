Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943B12D537E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 06:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbgLJF7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 00:59:03 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19612 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgLJF7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 00:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607579941; x=1639115941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=e88f0EYXAPuCWe2U9u556iW2ACO8lHodme7oRq3H5MI=;
  b=USNSlZemp/lX1dueCGQ8qAFuxemU9YEKKS7UfyYSvIjb5Nm6GQdLu9A9
   cP3FjfzCTQRBdraSxm0K+tjE/owwMIXyXi/kalBLPyKxtFXEq5l+ddeVI
   I7iTwvqKw4d1hEa8TfBbFCQRwj6TUOA8buQLktfpFFRr3cM394wmHlpt9
   w=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="103127793"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2020 05:58:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id A57FBA05F8;
        Thu, 10 Dec 2020 05:58:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 05:58:18 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.21) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 05:58:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Thu, 10 Dec 2020 14:58:10 +0900
Message-ID: <20201210055810.60068-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201210015319.e6njlcwuhfpre3bn@kafai-mbp.dhcp.thefacebook.com>
References: <20201210015319.e6njlcwuhfpre3bn@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D25UWC003.ant.amazon.com (10.43.162.129) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 9 Dec 2020 17:53:19 -0800
> On Thu, Dec 10, 2020 at 01:57:19AM +0900, Kuniyuki Iwashima wrOAote:
> [ ... ]
> 
> > > > > I think it is a bit complex to pass the new listener from
> > > > > reuseport_detach_sock() to inet_csk_listen_stop().
> > > > > 
> > > > > __tcp_close/tcp_disconnect/tcp_abort
> > > > >  |-tcp_set_state
> > > > >  |  |-unhash
> > > > >  |     |-reuseport_detach_sock (return nsk)
> > > > >  |-inet_csk_listen_stop
> > > > Picking the new listener does not have to be done in
> > > > reuseport_detach_sock().
> > > > 
> > > > IIUC, it is done there only because it prefers to pick
> > > > the last sk from socks[] when bpf prog is not attached.
> > > > This seems to get into the way of exploring other potential
> > > > implementation options.
> > > 
> > > Yes.
> > > This is just idea, but we can reserve the last index of socks[] to hold the
> > > last 'moved' socket in reuseport_detach_sock() and use it in
> > > inet_csk_listen_stop().
> > > 
> > > 
> > > > Merging the discussion on the last socks[] pick from another thread:
> > > > >
> > > > > I think most applications start new listeners before closing listeners, in
> > > > > this case, selecting the moved socket as the new listener works well.
> > > > >
> > > > >
> > > > > > That said, if it is still desired to do a random pick by kernel when
> > > > > > there is no bpf prog, it probably makes sense to guard it in a sysctl as
> > > > > > suggested in another reply.  To keep it simple, I would also keep this
> > > > > > kernel-pick consistent instead of request socket is doing something
> > > > > > different from the unhash path.
> > > > >
> > > > > Then, is this way better to keep kernel-pick consistent?
> > > > >
> > > > >   1. call reuseport_select_migrated_sock() without sk_hash from any path
> > > > >   2. generate a random number in reuseport_select_migrated_sock()
> > > > >   3. pass it to __reuseport_select_sock() only for select-by-hash
> > > > >   (4. pass 0 as sk_hash to bpf_run_sk_reuseport not to use it)
> > > > >   5. do migration per queue in inet_csk_listen_stop() or per request in
> > > > >      receive path.
> > > > >
> > > > > I understand it is beautiful to keep consistensy, but also think
> > > > > the kernel-pick with heuristic performs better than random-pick.
> > > > I think discussing the best kernel pick without explicit user input
> > > > is going to be a dead end. There is always a case that
> > > > makes this heuristic (or guess) fail.  e.g. what if multiple
> > > > sk(s) being closed are always the last one in the socks[]?
> > > > all their child sk(s) will then be piled up at one listen sk
> > > > because the last socks[] is always picked?
> > > 
> > > There can be such a case, but it means the newly listened sockets are
> > > closed earlier than old ones.
> > > 
> > > 
> > > > Lets assume the last socks[] is indeed the best for all cases.  Then why
> > > > the in-progress req don't pick it this way?  I feel the implementation
> > > > is doing what is convenient at that point.  And that is fine, I think
> > > 
> > > In this patchset, I originally assumed four things:
> > > 
> > >   migration should be done
> > >     (i)   from old to new
> > >     (ii)  to redistribute requests evenly as possible
> > >     (iii) to keep the order of requests in the queue
> > >           (resulting in splicing queues)
> > >     (iv)  in O(1) for scalability
> > >           (resulting in fix-up rsk_listener approach)
> > > 
> > > I selected the last socket in unhash path to satisfy above four because the
> > > last socket changes at every close() syscall if application closes from
> > > older socket.
> > > 
> > > But in receiving ACK or retransmitting SYN+ACK, we cannot get the last
> > > 'moved' socket. Even if we reserve the last 'moved' socket in the last
> > > index by the idea above, we cannot sure the last socket is changed after
> > > close() for each req->listener. For example, we have listeners A, B, C, and
> > > D, and then call close(A) and close(B), and receive the final ACKs for A
> > > and B, then both of them are assigned to C. In this case, A for D and B for
> > > C is desired. So, selecting the last socket in socks[] for incoming
> > > requests cannnot realize (ii).
> > > 
> > > This is why I selected the last moved socket in unhash path and a random
> > > listener in receive path.
> > > 
> > > 
> > > > for kernel-pick, it should just go for simplicity and stay with
> > > > the random(/hash) pick instead of pretending the kernel knows the
> > > > application must operate in a certain way.  It is fine
> > > > that the pick was wrong, the kernel will eventually move the
> > > > childs/reqs to the survived listen sk.
> > > 
> > > Exactly. Also the heuristic way is not fair for every application.
> > > 
> > > After reading below idea (migrated_sk), I think random-pick is better
> > > at simplicity and passing each sk.
> > > 
> > > 
> > > > [ I still think the kernel should not even pick if
> > > >   there is no bpf prog to instruct how to pick
> > > >   but I am fine as long as there is a sysctl to
> > > >   guard this. ]
> > > 
> > > Unless different applications listen on the same port, random-pick can save
> > > connections which would be aborted. So, I would add a sysctl to do
> > > migration when no eBPF prog is attached.
> > > 
> > > 
> > > > I would rather focus on ensuring the bpf prog getting what it
> > > > needs to make the migration pick.  A few things
> > > > I would like to discuss and explore:
> > > > > If we splice requests like this, we do not need double lock?
> > > > > 
> > > > >   1. lock the accept queue of the old listener
> > > > >   2. unlink all requests and decrement refcount
> > > > >   3. unlock
> > > > >   4. update all requests with new listener
> > > > I guess updating rsk_listener can be done without acquiring
> > > > the lock in (5) below is because it is done under the
> > > > listening_hash's bucket lock (and also the global reuseport_lock) so
> > > > that the new listener will stay in TCP_LISTEN state?
> > > 
> > > If we do migration in inet_unhash(), the lock is held, but it is not held
> > > in inet_csk_listen_stop().
> > > 
> > > 
> > > > I am not sure iterating the queue under these
> > > > locks is a very good thing to do though.  The queue may not be
> > > > very long in usual setup but still let see
> > > > if that can be avoided.
> > > 
> > > I agree, lock should not be held long.
> > > 
> > > 
> > > > Do you think the iteration can be done without holding
> > > > bucket lock and the global reuseport_lock?  inet_csk_reqsk_queue_add()
> > > > is taking the rskq_lock and then check for TCP_LISTEN.  May be
> > > > something similar can be done also?
> > > 
> > > I think either one is necessary at least, so if the sk_state of selected
> > > listener is TCP_CLOSE (this is mostly by random-pick of kernel), then we
> > > have to fall back to call inet_child_forget().
> > > 
> > > 
> > > > While doing BPF_SK_REUSEPORT_MIGRATE_REQUEST,
> > > > the bpf prog can pick per req and have the sk_hash.
> > > > However, while doing BPF_SK_REUSEPORT_MIGRATE_QUEUE,
> > > > the bpf prog currently does not have a chance to
> > > > pick individually for each req/child on the queue.
> > > > Since it is iterating the queue anyway, does it make
> > > > sense to also call the bpf to pick for each req/child
> > > > in the queue?  It then can pass sk_hash (from child->sk_hash?)
> > > > to the bpf prog also instead of current 0.  The cost of calling
> > > > bpf prog is not really that much / signficant at the
> > > > migration code path.  If the queue is somehow
> > > > unusally long, there is already an existing
> > > > cond_resched() in inet_csk_listen_stop().
> > > > 
> > > > Then, instead of adding sk_reuseport_md->migration,
> > > > it can then add sk_reuseport_md->migrate_sk.
> > > > "migrate_sk = req" for in-progress req and "migrate_sk = child"
> > > > for iterating acceptq.  The bpf_prog can then tell what sk (req or child)
> > > > it is migrating by reading migrate_sk->state.  It can then also
> > > > learn the 4 tuples src/dst ip/port while skb is missing.
> > > > The sk_reuseport_md->sk can still point to the closed sk
> > > > such that the bpf prog can learn the cookie.
> > > > 
> > > > I suspect a few things between BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > > > and BPF_SK_REUSEPORT_MIGRATE_QUEUE can be folded together
> > > > by doing the above.  It also gives a more consistent
> > > > interface for the bpf prog, no more MIGRATE_QUEUE vs MIGRATE_REQUEST.
> > > 
> > > I think this is really nice idea. Also, I tried to implement random-pick
> > > one by one in inet_csk_listen_stop() yesterday, I found a concern about how
> > > to handle requests in TFO queue.
> > > 
> > > The request can be already accepted, so passing it to eBPF prog is
> > > confusing? But, redistributing randomly can affect all listeners
> > > unnecessary. How should we handle such requests?
> > 
> > I've implemented one-by-one migration only for the accept queue for now.
> > In addition to the concern about TFO queue,
> You meant this queue:  queue->fastopenq.rskq_rst_head?

Yes.


> Can "req" be passed?
> I did not look up the lock/race in details for that though.

I think if we rewrite freeing TFO requests part like one of accept queue
using reqsk_queue_remove(), we can also migrate them.

In this patchset, selecting a listener for accept queue, the TFO queue of
the same listener is also migrated to another listener in order to prevent
TFO spoofing attack.

If the request in the accept queue is migrated one by one, I am wondering
which should the request in TFO queue be migrated to prevent attack or
freed.

I think user need not know about keeping such requests in kernel to prevent
attacks, so passing them to eBPF prog is confusing. But, redistributing
them randomly without user's intention can make some irrelevant listeners
unnecessarily drop new TFO requests, so this is also bad. Moreover, freeing
such requests seems not so good in the point of security.


> > I want to discuss which should
> > we pass NULL or request_sock to eBPF program as migrate_sk when selecting a
> > listener for SYN ?
> hmmm... not sure I understand your question.
> 
> You meant the existing lookup listener case from inet_lhash2_lookup()?

Yes.


> There is nothing to migrate at that point, so NULL makes sense to me.
> migrate_sk's type should be PTR_TO_SOCK_COMMON_OR_NULL.

Thank you, I will set PTR_TO_SOCK_COMMON_OR_NULL and pass NULL in
inet_lhash2_lookup().


> > ---8<---
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index a82fd4c912be..d0ddd3cb988b 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -1001,6 +1001,29 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> >  }
> >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> >  
> > +static bool inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk, struct request_sock *req)
> > +{
> > +       struct request_sock_queue *queue = &inet_csk(nsk)->icsk_accept_queue;
> > +       bool migrated = false;
> > +
> > +       spin_lock(&queue->rskq_lock);
> > +       if (likely(nsk->sk_state == TCP_LISTEN)) {
> > +               migrated = true;
> > +
> > +               req->dl_next = NULL;
> > +               if (queue->rskq_accept_head == NULL)
> > +                       WRITE_ONCE(queue->rskq_accept_head, req);
> > +               else
> > +                       queue->rskq_accept_tail->dl_next = req;
> > +               queue->rskq_accept_tail = req;
> > +               sk_acceptq_added(nsk);
> > +               inet_csk_reqsk_queue_migrated(sk, nsk, req);
> need to first resolve the question raised in patch 5 regarding
> to the update on req->rsk_listener though.

In the unhash path, it is also safe to call sock_put() for the old listner.

In inet_csk_listen_stop(), the sk_refcnt of the listener >= 1. If the
listener does not have immature requests, sk_refcnt is 1 and freed in
__tcp_close().

  sock_hold(sk) in __tcp_close()
  sock_put(sk) in inet_csk_destroy_sock()
  sock_put(sk) in __tcp_clsoe()


> > +       }
> > +       spin_unlock(&queue->rskq_lock);
> > +
> > +       return migrated;
> > +}
> > +
> >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> >                                          struct request_sock *req, bool own_req)
> >  {
> > @@ -1023,9 +1046,11 @@ EXPORT_SYMBOL(inet_csk_complete_hashdance);
> >   */
> >  void inet_csk_listen_stop(struct sock *sk)
> >  {
> > +       struct sock_reuseport *reuseport_cb = rcu_access_pointer(sk->sk_reuseport_cb);
> >         struct inet_connection_sock *icsk = inet_csk(sk);
> >         struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> >         struct request_sock *next, *req;
> > +       struct sock *nsk;
> >  
> >         /* Following specs, it would be better either to send FIN
> >          * (and enter FIN-WAIT-1, it is normal close)
> > @@ -1043,8 +1068,19 @@ void inet_csk_listen_stop(struct sock *sk)
> >                 WARN_ON(sock_owned_by_user(child));
> >                 sock_hold(child);
> >  
> > +               if (reuseport_cb) {
> > +                       nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, NULL);
> > +                       if (nsk) {
> > +                               if (inet_csk_reqsk_queue_migrate(sk, nsk, req))
> > +                                       goto unlock_sock;
> > +                               else
> > +                                       sock_put(nsk);
> > +                       }
> > +               }
> > +
> >                 inet_child_forget(sk, req, child);
> >                 reqsk_put(req);
> > +unlock_sock:
> >                 bh_unlock_sock(child);
> >                 local_bh_enable();
> >                 sock_put(child);
> > ---8<---
> > 
> > 
> > > > >   5. lock the accept queue of the new listener
> > > > >   6. splice requests and increment refcount
> > > > >   7. unlock
> > > > > 
> > > > > Also, I think splicing is better to keep the order of requests. Adding one
> > > > > by one reverses it.
> > > > It can keep the order but I think it is orthogonal here.
