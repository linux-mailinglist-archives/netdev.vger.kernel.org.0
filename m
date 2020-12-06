Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C892D0092
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLFEmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:42:06 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:37040 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLFEmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607229725; x=1638765725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=CQdDX6A9aiuRq5RVTy4sKV55mcRjaNgS1fqNjPVZs8s=;
  b=vrK60ZwXxVWXw/bfr5UP8fXQQms1vegPo+Q+a7fyAXCqSqlWvdXbzL4u
   1TyTlIlhGtp31ilN0Jmy8TMQ5rwmt7vhXvuLjua1pXc9jYU/b/+Ql8Bnc
   meJOd6DWKIlQaSc2OI1rJobARPaZose42vHWKBRKZZkFb1pzk+LDm0oyD
   w=;
X-IronPort-AV: E=Sophos;i="5.78,396,1599523200"; 
   d="scan'208";a="102023345"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Dec 2020 04:41:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id 84410C27E7;
        Sun,  6 Dec 2020 04:41:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:41:23 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.67) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:41:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Sun, 6 Dec 2020 13:41:17 +0900
Message-ID: <20201206044117.30859-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201205014241.afrcicgewlnyrzfu@kafai-mbp.dhcp.thefacebook.com>
References: <20201205014241.afrcicgewlnyrzfu@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D23UWC004.ant.amazon.com (10.43.162.219) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this mail just for logging because I failed to send mails only 
to LKML, netdev, and bpf yesterday.


From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 4 Dec 2020 17:42:41 -0800
> On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> [ ... ]
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index fd133516ac0e..60d7c1f28809 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> >  }
> >  EXPORT_SYMBOL(reuseport_add_sock);
> >  
> > -void reuseport_detach_sock(struct sock *sk)
> > +struct sock *reuseport_detach_sock(struct sock *sk)
> >  {
> >  	struct sock_reuseport *reuse;
> > +	struct bpf_prog *prog;
> > +	struct sock *nsk = NULL;
> >  	int i;
> >  
> >  	spin_lock_bh(&reuseport_lock);
> > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> >  
> >  		reuse->num_socks--;
> >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > +		prog = rcu_dereference(reuse->prog);
> Is it under rcu_read_lock() here?

reuseport_lock is locked in this function, and we do not modify the prog,
but is rcu_dereference_protected() preferable?

---8<---
prog = rcu_dereference_protected(reuse->prog,
				 lockdep_is_held(&reuseport_lock));
---8<---


> >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > +			if (reuse->num_socks && !prog)
> > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > +
> >  			reuse->num_closed_socks++;
> >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> >  		} else {
> > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> >  out:
> >  	spin_unlock_bh(&reuseport_lock);
> > +
> > +	return nsk;
> >  }
> >  EXPORT_SYMBOL(reuseport_detach_sock);
> >  
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 1451aa9712b0..b27241ea96bd 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> >  }
> >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> >  
> > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > +{
> > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > +
> > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > +
> > +	spin_lock(&old_accept_queue->rskq_lock);
> > +	spin_lock(&new_accept_queue->rskq_lock);
> I am also not very thrilled on this double spin_lock.
> Can this be done in (or like) inet_csk_listen_stop() instead?

It will be possible to migrate sockets in inet_csk_listen_stop(), but I
think it is better to do it just after reuseport_detach_sock() becuase we
can select a different listener (almost) every time at a lower cost by
selecting the moved socket and pass it to inet_csk_reqsk_queue_migrate()
easily.

sk_hash of the listener is 0, so we would have to generate a random number
in inet_csk_listen_stop().
