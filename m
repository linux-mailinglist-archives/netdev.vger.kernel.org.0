Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9753A373A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFJWjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:39:37 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:58478 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJWjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623364660; x=1654900660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwa9iNCMYzaOFfi5zFCAhrxikXICuCtA5BrImYbauiw=;
  b=mQJ5+nEYuwgF2tKQrqkQLLLT+31SZWd3ljtJt4kuZKbJGHbOcSBqqmF0
   BkmOu1oObgiRVSHcR5Z7kpeIkEhoD9xunvvujUkPwmc8c53Vt7Nmm1X0r
   fqZqv/8VrnMTSdRRFShN5ppZEg4eS6PQqUfNyaoEVlJ6Wf4U4hfZz0c01
   k=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="6075798"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 10 Jun 2021 22:37:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 2F913A05BF;
        Thu, 10 Jun 2021 22:37:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:37:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.17) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:37:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Fri, 11 Jun 2021 07:37:30 +0900
Message-ID: <20210610223730.97716-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <c89d2cec-4cf2-1972-354b-5f5ca1330d82@gmail.com>
References: <c89d2cec-4cf2-1972-354b-5f5ca1330d82@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D46UWC004.ant.amazon.com (10.43.162.173) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 19:59:15 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > When we close a listening socket, to migrate its connections to another
> > listener in the same reuseport group, we have to handle two kinds of child
> > sockets. One is that a listening socket has a reference to, and the other
> > is not.
> > 
> > The former is the TCP_ESTABLISHED/TCP_SYN_RECV sockets, and they are in the
> > accept queue of their listening socket. So we can pop them out and push
> > them into another listener's queue at close() or shutdown() syscalls. On
> > the other hand, the latter, the TCP_NEW_SYN_RECV socket is during the
> > three-way handshake and not in the accept queue. Thus, we cannot access
> > such sockets at close() or shutdown() syscalls. Accordingly, we have to
> > migrate immature sockets after their listening socket has been closed.
> > 
> > Currently, if their listening socket has been closed, TCP_NEW_SYN_RECV
> > sockets are freed at receiving the final ACK or retransmitting SYN+ACKs. At
> > that time, if we could select a new listener from the same reuseport group,
> > no connection would be aborted. However, we cannot do that because
> > reuseport_detach_sock() sets NULL to sk_reuseport_cb and forbids access to
> > the reuseport group from closed sockets.
> > 
> > This patch allows TCP_CLOSE sockets to remain in the reuseport group and
> > access it while any child socket references them. The point is that
> > reuseport_detach_sock() was called twice from inet_unhash() and
> > sk_destruct(). This patch replaces the first reuseport_detach_sock() with
> > reuseport_stop_listen_sock(), which checks if the reuseport group is
> > capable of migration. If capable, it decrements num_socks, moves the socket
> > backwards in socks[] and increments num_closed_socks. When all connections
> > are migrated, sk_destruct() calls reuseport_detach_sock() to remove the
> > socket from socks[], decrement num_closed_socks, and set NULL to
> > sk_reuseport_cb.
> > 
> > By this change, closed or shutdowned sockets can keep sk_reuseport_cb.
> > Consequently, calling listen() after shutdown() can cause EADDRINUSE or
> > EBUSY in inet_csk_bind_conflict() or reuseport_add_sock() which expects
> > such sockets not to have the reuseport group. Therefore, this patch also
> > loosens such validation rules so that a socket can listen again if it has a
> > reuseport group with num_closed_socks more than 0.
> > 
> > When such sockets listen again, we handle them in reuseport_resurrect(). If
> > there is an existing reuseport group (reuseport_add_sock() path), we move
> > the socket from the old group to the new one and free the old one if
> > necessary. If there is no existing group (reuseport_alloc() path), we
> > allocate a new reuseport group, detach sk from the old one, and free it if
> > necessary, not to break the current shutdown behaviour:
> > 
> >   - we cannot carry over the eBPF prog of shutdowned sockets
> >   - we cannot attach/detach an eBPF prog to/from listening sockets via
> >     shutdowned sockets
> > 
> > Note that when the number of sockets gets over U16_MAX, we try to detach a
> > closed socket randomly to make room for the new listening socket in
> > reuseport_grow().
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/net/sock_reuseport.h    |   1 +
> >  net/core/sock_reuseport.c       | 184 ++++++++++++++++++++++++++++++--
> >  net/ipv4/inet_connection_sock.c |  12 ++-
> >  net/ipv4/inet_hashtables.c      |   2 +-
> >  4 files changed, 188 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > index 0e558ca7afbf..1333d0cddfbc 100644
> > --- a/include/net/sock_reuseport.h
> > +++ b/include/net/sock_reuseport.h
> > @@ -32,6 +32,7 @@ extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> >  			      bool bind_inany);
> >  extern void reuseport_detach_sock(struct sock *sk);
> > +void reuseport_stop_listen_sock(struct sock *sk);
> >  extern struct sock *reuseport_select_sock(struct sock *sk,
> >  					  u32 hash,
> >  					  struct sk_buff *skb,
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index 079bd1aca0e7..ea0e900d3e97 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -17,6 +17,8 @@
> >  DEFINE_SPINLOCK(reuseport_lock);
> >  
> >  static DEFINE_IDA(reuseport_ida);
> > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > +			       struct sock_reuseport *reuse, bool bind_inany);
> >  
> >  static int reuseport_sock_index(struct sock *sk,
> >  				struct sock_reuseport *reuse,
> > @@ -61,6 +63,29 @@ static bool __reuseport_detach_sock(struct sock *sk,
> >  	return true;
> >  }
> >  
> > +static void __reuseport_add_closed_sock(struct sock *sk,
> > +					struct sock_reuseport *reuse)
> > +{
> > +	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
> > +	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> > +	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
> > +}
> > +
> > +static bool __reuseport_detach_closed_sock(struct sock *sk,
> > +					   struct sock_reuseport *reuse)
> > +{
> > +	int i = reuseport_sock_index(sk, reuse, true);
> > +
> > +	if (i == -1)
> > +		return false;
> > +
> > +	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
> > +	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
> > +	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
> > +
> > +	return true;
> > +}
> > +
> >  static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
> >  {
> >  	unsigned int size = sizeof(struct sock_reuseport) +
> > @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> >  					  lockdep_is_held(&reuseport_lock));
> >  	if (reuse) {
> > +		if (reuse->num_closed_socks) {
> > +			/* sk was shutdown()ed before */
> > +			int err = reuseport_resurrect(sk, reuse, NULL, bind_inany);
> > +
> > +			spin_unlock_bh(&reuseport_lock);
> > +			return err;
> 
> It seems coding style in this function would rather do
> 			ret = reuseport_resurrect(sk, reuse, NULL, bind_inany);
> 			goto out;
> 
> Overall, changes in this commit are a bit scarry.

I will change the style with ret and goto.

Thank you.
