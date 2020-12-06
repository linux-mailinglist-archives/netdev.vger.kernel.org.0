Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE602D008D
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLFEjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:39:12 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:6153 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLFEjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607229551; x=1638765551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=U0hzxwsqhi3SS2M94+g8S94NnU3oqs54NmYqE8jqm0E=;
  b=Ov3KDB6wsCPNkw4SpOYrViZHgq2Kb8kb3yf5/GlRAzppsabke4wChcQD
   LcR8uY2Cjyq9QH+FROACAnQVBCa5tU/L4h+ELwz+gklMIlxpGoqf68kIe
   CFvAVnGDiJtNiUGsHRCuBysKiEyuDXQIU2xm/H70oay+nRxQmDaxzqHVA
   4=;
X-IronPort-AV: E=Sophos;i="5.78,396,1599523200"; 
   d="scan'208";a="100758268"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Dec 2020 04:38:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 03E15A2123;
        Sun,  6 Dec 2020 04:38:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:38:29 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:38:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 01/11] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Sun, 6 Dec 2020 13:38:23 +0900
Message-ID: <20201206043823.27524-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201205013103.eo5chfx57kf25pz3@kafai-mbp.dhcp.thefacebook.com>
References: <20201205013103.eo5chfx57kf25pz3@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this mail just for logging because I failed to send mails only 
to LKML, netdev, and bpf yesterday.


From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 4 Dec 2020 17:31:03 -0800
> On Tue, Dec 01, 2020 at 11:44:08PM +0900, Kuniyuki Iwashima wrote:
> > This patch is a preparation patch to migrate incoming connections in the
> > later commits and adds a field (num_closed_socks) to the struct
> > sock_reuseport to keep TCP_CLOSE sockets in the reuseport group.
> > 
> > When we close a listening socket, to migrate its connections to another
> > listener in the same reuseport group, we have to handle two kinds of child
> > sockets. One is that a listening socket has a reference to, and the other
> > is not.
> > 
> > The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
> > accept queue of their listening socket. So, we can pop them out and push
> > them into another listener's queue at close() or shutdown() syscalls. On
> > the other hand, the latter, the TCP_NEW_SYN_RECV socket is during the
> > three-way handshake and not in the accept queue. Thus, we cannot access
> > such sockets at close() or shutdown() syscalls. Accordingly, we have to
> > migrate immature sockets after their listening socket has been closed.
> > 
> > Currently, if their listening socket has been closed, TCP_NEW_SYN_RECV
> > sockets are freed at receiving the final ACK or retransmitting SYN+ACKs. At
> > that time, if we could select a new listener from the same reuseport group,
> > no connection would be aborted. However, it is impossible because
> > reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
> > the reuseport group from closed sockets.
> > 
> > This patch allows TCP_CLOSE sockets to remain in the reuseport group and to
> > have access to it while any child socket references to them. The point is
> > that reuseport_detach_sock() is called twice from inet_unhash() and
> > sk_destruct(). At first, it moves the socket backwards in socks[] and
> > increments num_closed_socks. Later, when all migrated connections are
> > accepted, it removes the socket from socks[], decrements num_closed_socks,
> > and sets NULL to sk_reuseport_cb.
> > 
> > By this change, closed sockets can keep sk_reuseport_cb until all child
> > requests have been freed or accepted. Consequently calling listen() after
> > shutdown() can cause EADDRINUSE or EBUSY in reuseport_add_sock() or
> > inet_csk_bind_conflict() which expect that such sockets should not have the
> > reuseport group. Therefore, this patch also loosens such validation rules
> > so that the socket can listen again if it has the same reuseport group with
> > other listening sockets.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/net/sock_reuseport.h    |  5 ++-
> >  net/core/sock_reuseport.c       | 79 +++++++++++++++++++++++++++------
> >  net/ipv4/inet_connection_sock.c |  7 ++-
> >  3 files changed, 74 insertions(+), 17 deletions(-)
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
> > index bbdd3c7b6cb5..fd133516ac0e 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -98,16 +98,21 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
> >  		return NULL;
> >  
> >  	more_reuse->num_socks = reuse->num_socks;
> > +	more_reuse->num_closed_socks = reuse->num_closed_socks;
> >  	more_reuse->prog = reuse->prog;
> >  	more_reuse->reuseport_id = reuse->reuseport_id;
> >  	more_reuse->bind_inany = reuse->bind_inany;
> >  	more_reuse->has_conns = reuse->has_conns;
> > +	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
> >  
> >  	memcpy(more_reuse->socks, reuse->socks,
> >  	       reuse->num_socks * sizeof(struct sock *));
> > -	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
> > +	memcpy(more_reuse->socks +
> > +	       (more_reuse->max_socks - more_reuse->num_closed_socks),
> > +	       reuse->socks + reuse->num_socks,
> > +	       reuse->num_closed_socks * sizeof(struct sock *));
> >  
> > -	for (i = 0; i < reuse->num_socks; ++i)
> > +	for (i = 0; i < reuse->max_socks; ++i)
> >  		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> >  				   more_reuse);
> >  
> > @@ -129,6 +134,25 @@ static void reuseport_free_rcu(struct rcu_head *head)
> >  	kfree(reuse);
> >  }
> >  
> > +static int reuseport_sock_index(struct sock_reuseport *reuse, struct sock *sk,
> > +				bool closed)
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
> > +
> > +	for (; left < right; left++)
> > +		if (reuse->socks[left] == sk)
> > +			return left;
> > +	return -1;
> > +}
> > +
> >  /**
> >   *  reuseport_add_sock - Add a socket to the reuseport group of another.
> >   *  @sk:  New socket to add to the group.
> > @@ -153,12 +177,23 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> >  					  lockdep_is_held(&reuseport_lock));
> >  	old_reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> >  					     lockdep_is_held(&reuseport_lock));
> > -	if (old_reuse && old_reuse->num_socks != 1) {
> > +
> > +	if (old_reuse == reuse) {
> > +		int i = reuseport_sock_index(reuse, sk, true);
> > +
> > +		if (i == -1) {
> When will this happen?

I understood the original code did nothing if the sk was not found in
socks[], so I rewrote it this way, but I also think `i` will never be -1.

If I rewrite, it will be like:

---8<---
for (; left < right; left++)
    if (reuse->socks[left] == sk)
        break;
return left;
---8<---


> I found the new logic in the closed sk shuffling within socks[] quite
> complicated to read.  I can see why the closed sk wants to keep its
> sk->sk_reuseport_cb.  However, does it need to stay
> in socks[]?

Currently, I do not use closed sockets in socks[], so the only thing I need
to do seems to be to count num_closed_socks to free struct sock_reuseport.
I will change the code only to keep sk_reuseport_cb and count
num_closed_socks.

(As a side note, I wrote the code while thinking of stack and heap to share
the same array, but I also feel a bit difficult to read.)
