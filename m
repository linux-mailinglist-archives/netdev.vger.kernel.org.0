Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EC95FB706
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 17:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiJKP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 11:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiJKP06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 11:26:58 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C67D38DD;
        Tue, 11 Oct 2022 08:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665501480; x=1697037480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2syQHHQ9eJJDt40xrL/6xtSPJwmCYRF97UNEmN5xHqU=;
  b=YgyuDiBIXoXFzr3si2f6Rh/BQhPtsD130/kM4f9FhzIKOcnOwg3kFora
   lrSd9p1bgXfmL0vYuxzpatrlFByQGuxB4XwXPDb9AtT/KkHgtnFDxxIh8
   WGWBw8b+AJVL6ccGJpIZ9VbidIN31pSVbW6FVsHTE6fFXuL7eJdXhEZy/
   o=;
X-IronPort-AV: E=Sophos;i="5.95,176,1661817600"; 
   d="scan'208";a="232394545"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 15:16:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id A5B8B8F8B3;
        Tue, 11 Oct 2022 15:16:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 11 Oct 2022 15:16:35 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.179) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 11 Oct 2022 15:16:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kraig@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <martin.lau@kernel.org>, <netdev@vger.kernel.org>,
        <willemb@google.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net 1/3] udp: Update reuse->has_conns under reuseport_lock.
Date:   Tue, 11 Oct 2022 08:16:18 -0700
Message-ID: <20221011151618.89550-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <468f01fc1dde6cf44fab51653eeb626fc8521db2.camel@redhat.com>
References: <468f01fc1dde6cf44fab51653eeb626fc8521db2.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Tue, 11 Oct 2022 12:50:52 +0200
> On Mon, 2022-10-10 at 10:43 -0700, Kuniyuki Iwashima wrote:
> > When we call connect() for a UDP socket in a reuseport group, we have
> > to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> > could select a unconnected socket wrongly for packets sent to the
> > connected socket.
> > 
> > However, the current way to set has_conns is illegal and possible to
> > trigger that problem.  reuseport_has_conns() changes has_conns under
> > rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> > it must do the update under the updater's lock, reuseport_lock, but
> > it doesn't for now.
> > 
> > For this reason, there is a race below where we fail to set has_conns
> > resulting in the wrong socket selection.  To avoid the race, let's split
> > the reader and updater with proper locking.
> > 
> >  cpu1                               cpu2
> > +----+                             +----+
> > 
> > __ip[46]_datagram_connect()        reuseport_grow()
> > .                                  .
> > > - reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
> > >  .                               |
> > >  |- rcu_read_lock()
> > >  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
> > >  |
> > >  |                               |  /* reuse->has_conns == 0 here */
> > >  |                               |- more_reuse->has_conns = reuse->has_conns
> > >  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
> > >  |                               |
> > >  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> > >  |                               |                     more_reuse)
> > >  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
> > > 
> > > - sk->sk_state = TCP_ESTABLISHED
> > 
> > Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/sock_reuseport.h | 23 +++++++++++++++++------
> >  net/ipv4/datagram.c          |  2 +-
> >  net/ipv4/udp.c               |  2 +-
> >  net/ipv6/datagram.c          |  2 +-
> >  net/ipv6/udp.c               |  2 +-
> >  5 files changed, 21 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > index 473b0b0fa4ab..fe9779e6d90f 100644
> > --- a/include/net/sock_reuseport.h
> > +++ b/include/net/sock_reuseport.h
> > @@ -43,21 +43,32 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
> >  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
> >  extern int reuseport_detach_prog(struct sock *sk);
> >  
> > -static inline bool reuseport_has_conns(struct sock *sk, bool set)
> > +static inline bool reuseport_has_conns(struct sock *sk)
> >  {
> >  	struct sock_reuseport *reuse;
> >  	bool ret = false;
> >  
> >  	rcu_read_lock();
> >  	reuse = rcu_dereference(sk->sk_reuseport_cb);
> > -	if (reuse) {
> > -		if (set)
> > -			reuse->has_conns = 1;
> > -		ret = reuse->has_conns;
> > -	}
> > +	if (reuse && reuse->has_conns)
> > +		ret = true;
> >  	rcu_read_unlock();
> >  
> >  	return ret;
> >  }
> >  
> > +static inline void reuseport_has_conns_set(struct sock *sk)
> > +{
> > +	struct sock_reuseport *reuse;
> > +
> > +	if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > +		return;
> > +
> > +	spin_lock(&reuseport_lock);
> > +	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > +					  lockdep_is_held(&reuseport_lock));
> > +	reuse->has_conns = 1;
> > +	spin_unlock(&reuseport_lock);
> > +}
> 
> Since the above is not super critical, it's probably better move it
> into  sock_reuseport.c file and export it (to fix the build issue)

I'll fix the CONFIG_IPV6=m build failure.
Thank you.
