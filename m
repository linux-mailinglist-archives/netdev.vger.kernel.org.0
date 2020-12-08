Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D32D26D3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgLHJDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:03:34 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:33908 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbgLHJD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607418207; x=1638954207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Y5xpdhYe8tDwUSn2h3cGPmst8Ze3CvXueiWyz/+4As0=;
  b=ewnBjUDRX2WVOUECjZQLkpluWrT2APPOQ3YkFcQ55mrAUDfsTBJqPLrW
   7+EqebnSjoJehxbQbCujpUlFIPIroVdwKqrbeuRQFEajM1zsvcekzeOA3
   1HnYm7QZUIll479BxkzyqBTbsnpRLsS5B4vimHKjjtvIaDVj+XLNLRr0z
   g=;
X-IronPort-AV: E=Sophos;i="5.78,402,1599523200"; 
   d="scan'208";a="101249711"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Dec 2020 09:02:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id A899DA2230;
        Tue,  8 Dec 2020 09:02:45 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 09:02:44 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.125) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 09:02:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 8 Dec 2020 18:02:36 +0900
Message-ID: <20201208090236.86926-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201208081328.aspzklzmeznw3hob@kafai-mbp.dhcp.thefacebook.com>
References: <20201208081328.aspzklzmeznw3hob@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.125]
X-ClientProxiedBy: EX13D28UWC001.ant.amazon.com (10.43.162.166) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Tue, 8 Dec 2020 00:13:28 -0800
> On Tue, Dec 08, 2020 at 03:27:14PM +0900, Kuniyuki Iwashima wrote:
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Mon, 7 Dec 2020 12:14:38 -0800
> > > On Sun, Dec 06, 2020 at 01:03:07AM +0900, Kuniyuki Iwashima wrote:
> > > > From:   Martin KaFai Lau <kafai@fb.com>
> > > > Date:   Fri, 4 Dec 2020 17:42:41 -0800
> > > > > On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> > > > > [ ... ]
> > > > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > > > index fd133516ac0e..60d7c1f28809 100644
> > > > > > --- a/net/core/sock_reuseport.c
> > > > > > +++ b/net/core/sock_reuseport.c
> > > > > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(reuseport_add_sock);
> > > > > >  
> > > > > > -void reuseport_detach_sock(struct sock *sk)
> > > > > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > > > > >  {
> > > > > >  	struct sock_reuseport *reuse;
> > > > > > +	struct bpf_prog *prog;
> > > > > > +	struct sock *nsk = NULL;
> > > > > >  	int i;
> > > > > >  
> > > > > >  	spin_lock_bh(&reuseport_lock);
> > > > > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > > > > >  
> > > > > >  		reuse->num_socks--;
> > > > > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > > > > +		prog = rcu_dereference(reuse->prog);
> > > > > Is it under rcu_read_lock() here?
> > > > 
> > > > reuseport_lock is locked in this function, and we do not modify the prog,
> > > > but is rcu_dereference_protected() preferable?
> > > > 
> > > > ---8<---
> > > > prog = rcu_dereference_protected(reuse->prog,
> > > > 				 lockdep_is_held(&reuseport_lock));
> > > > ---8<---
> > > It is not only reuse->prog.  Other things also require rcu_read_lock(),
> > > e.g. please take a look at __htab_map_lookup_elem().
> > > 
> > > The TCP_LISTEN sk (selected by bpf to be the target of the migration)
> > > is also protected by rcu.
> > 
> > Thank you, I will use rcu_read_lock() and rcu_dereference() in v3 patchset.
> > 
> > 
> > > I am surprised there is no WARNING in the test.
> > > Do you have the needed DEBUG_LOCK* config enabled?
> > 
> > Yes, DEBUG_LOCK* was 'y', but rcu_dereference() without rcu_read_lock()
> > does not show warnings...
> I would at least expect the "WARN_ON_ONCE(!rcu_read_lock_held() ...)"
> from __htab_map_lookup_elem() should fire in your test
> example in the last patch.
> 
> It is better to check the config before sending v3.

It seems ok, but I will check it again.

---8<---
[ec2-user@ip-10-0-0-124 bpf-next]$ cat .config | grep DEBUG_LOCK
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
---8<---


> > > > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > > > index 1451aa9712b0..b27241ea96bd 100644
> > > > > > --- a/net/ipv4/inet_connection_sock.c
> > > > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > > > >  
> > > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > > > > +{
> > > > > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > > > > +
> > > > > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > > > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > > > +
> > > > > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > > > > +	spin_lock(&new_accept_queue->rskq_lock);
> > > > > I am also not very thrilled on this double spin_lock.
> > > > > Can this be done in (or like) inet_csk_listen_stop() instead?
> > > > 
> > > > It will be possible to migrate sockets in inet_csk_listen_stop(), but I
> > > > think it is better to do it just after reuseport_detach_sock() becuase we
> > > > can select a different listener (almost) every time at a lower cost by
> > > > selecting the moved socket and pass it to inet_csk_reqsk_queue_migrate()
> > > > easily.
> > > I don't see the "lower cost" point.  Please elaborate.
> > 
> > In reuseport_select_sock(), we pass sk_hash of the request socket to
> > reciprocal_scale() and generate a random index for socks[] to select
> > a different listener every time.
> > On the other hand, we do not have request sockets in unhash path and
> > sk_hash of the listener is always 0, so we have to generate a random number
> > in another way. In reuseport_detach_sock(), we can use the index of the
> > moved socket, but we do not have it in inet_csk_listen_stop(), so we have
> > to generate a random number in inet_csk_listen_stop().
> > I think it is at lower cost to use the index of the moved socket.
> Generate a random number is not a big deal for the migration code path.
> 
> Also, I really still failed to see a particular way that the kernel
> pick will help in the migration case.  The kernel has no clue
> on how to select the right process to migrate to without
> a proper policy signal from the user.  They are all as bad as
> a random pick.  I am not sure this migration feature is
> even useful if there is no bpf prog attached to define the policy.

I think most applications start new listeners before closing listeners, in
this case, selecting the moved socket as the new listener works well.


> That said, if it is still desired to do a random pick by kernel when
> there is no bpf prog, it probably makes sense to guard it in a sysctl as
> suggested in another reply.  To keep it simple, I would also keep this
> kernel-pick consistent instead of request socket is doing something
> different from the unhash path.

Then, is this way better to keep kernel-pick consistent?

  1. call reuseport_select_migrated_sock() without sk_hash from any path
  2. generate a random number in reuseport_select_migrated_sock()
  3. pass it to __reuseport_select_sock() only for select-by-hash
  (4. pass 0 as sk_hash to bpf_run_sk_reuseport not to use it)
  5. do migration per queue in inet_csk_listen_stop() or per request in
     receive path.

I understand it is beautiful to keep consistensy, but also think
the kernel-pick with heuristic performs better than random-pick.
