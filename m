Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F6655314
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 18:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLWRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 12:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiLWRIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 12:08:42 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6FEC0E
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 09:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671815320; x=1703351320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+eUAvjBXRJxk4onGjVFOQ2En+fNUCro9OpESw+YrpeQ=;
  b=dQmaCp3GnXpKg2v5F/pd4KAuapuawKMKSgau/+S4dxAMLshSK6aLDJ74
   IXUW29UPNt7Cq2RYEbYeObQtoKD6yOelABVBTMFmYzQuuXqzLhVF50QY+
   uzdYJulxZxq91RSBO94De8xm4aT6jIgUYdZoj6/gPW2M5dfH4WCDJg4s6
   o=;
X-IronPort-AV: E=Sophos;i="5.96,269,1665446400"; 
   d="scan'208";a="1086519599"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2022 17:08:32 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 60F90A3A12;
        Fri, 23 Dec 2022 17:08:32 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 23 Dec 2022 17:08:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 23 Dec 2022 17:08:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <jirislaby@kernel.org>, <joannelkoong@gmail.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
Date:   Sat, 24 Dec 2022 02:08:18 +0900
Message-ID: <20221223170818.48784-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <99793af4ce55ba878bc201571c824a17a37ef81d.camel@redhat.com>
References: <99793af4ce55ba878bc201571c824a17a37ef81d.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D25UWB001.ant.amazon.com (10.43.161.245) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 23 Dec 2022 11:15:24 +0100
> On Fri, 2022-12-23 at 08:26 +0900, Kuniyuki Iwashima wrote:
> > From:   Joanne Koong <joannelkoong@gmail.com>
> > Date:   Thu, 22 Dec 2022 13:46:57 -0800
> > > On Thu, Dec 22, 2022 at 7:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > 
> > > > On Thu, 2022-12-22 at 00:12 +0900, Kuniyuki Iwashima wrote:
> > > > > Jiri Slaby reported regression of bind() with a simple repro. [0]
> > > > > 
> > > > > The repro creates a TIME_WAIT socket and tries to bind() a new socket
> > > > > with the same local address and port.  Before commit 28044fc1d495 ("net:
> > > > > Add a bhash2 table hashed by port and address"), the bind() failed with
> > > > > -EADDRINUSE, but now it succeeds.
> > > > > 
> > > > > The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> > > > > inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> > > > > requests if the address is not a wildcard one.
> > > 
> > > (resending my reply because it wasn't in plaintext mode)
> > > 
> > > Thanks for adding this! I hadn't realized TIME_WAIT sockets also are
> > > considered when checking against inet bind conflicts.
> > > 
> > > > 
> > > > How does keeping the timewait sockets inside bhash2 affect the bind
> > > > loopup performance? I fear that could defeat completely the goal of
> > > > 28044fc1d495, on quite busy server we could have quite a bit of tw with
> > > > the same address/port. If so, we could even consider reverting
> > > > 28044fc1d495.
> > 
> > It will slow down along the number of twsk, but I think it's still faster
> > than bhash if we listen() on multiple IP.  If we don't, bhash is always
> > faster because of bhash2's additional locking.  However, this is the
> > nature of bhash2 from the beginning.
> 
> I see. Before 28044fc1d495, todo a bind lookup, we had to traverse all
> the tw in bhash. After 28044fc1d495, tw were ignored (in some cases).
> My point is: if the number of tw sockets is >> the number of listeners
> on multiple IPs, the bhash2 traversal time after this patch will be
> comparable to the bhash traversal time before 28044fc1d495, with the
> added cost of the double spin lock.

Ah, I get your point.  I think it's possible.  At least bhash2
has still merit when adding new IP.  Let's say we have X.X.X.X:443
listeners and adding Y.Y.Y.Y:443 does not cause CPU soft lockup if
we have bhash2.  But yes, more tests would be helpful.


> 
> > > 
> > > Can you clarify what you mean by bind loopup?
> > 
> > I think it means just bhash2 traversal.  (s/loopup/lookup/)
> 
> Indeed, sorry for the typo!
> > 
> > > 
> > > > > [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> > > > > 
> > > > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > > > Reported-by: Jiri Slaby <jirislaby@kernel.org>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > ---
> > > > >  include/net/inet_timewait_sock.h |  2 ++
> > > > >  include/net/sock.h               |  5 +++--
> > > > >  net/ipv4/inet_hashtables.c       |  5 +++--
> > > > >  net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
> > > > >  4 files changed, 37 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> > > > > index 5b47545f22d3..c46ed239ad9a 100644
> > > > > --- a/include/net/inet_timewait_sock.h
> > > > > +++ b/include/net/inet_timewait_sock.h
> > > > > @@ -44,6 +44,7 @@ struct inet_timewait_sock {
> > > > >  #define tw_bound_dev_if              __tw_common.skc_bound_dev_if
> > > > >  #define tw_node                      __tw_common.skc_nulls_node
> > > > >  #define tw_bind_node         __tw_common.skc_bind_node
> > > > > +#define tw_bind2_node                __tw_common.skc_bind2_node
> > > > >  #define tw_refcnt            __tw_common.skc_refcnt
> > > > >  #define tw_hash                      __tw_common.skc_hash
> > > > >  #define tw_prot                      __tw_common.skc_prot
> > > > > @@ -73,6 +74,7 @@ struct inet_timewait_sock {
> > > > >       u32                     tw_priority;
> > > > >       struct timer_list       tw_timer;
> > > > >       struct inet_bind_bucket *tw_tb;
> > > > > +     struct inet_bind2_bucket        *tw_tb2;
> > > > >  };
> > > > >  #define tw_tclass tw_tos
> > > > > 
> > > > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > > > index dcd72e6285b2..aaec985c1b5b 100644
> > > > > --- a/include/net/sock.h
> > > > > +++ b/include/net/sock.h
> > > > > @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
> > > > >   *   @skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
> > > > >   *           [union with @skc_incoming_cpu]
> > > > >   *   @skc_refcnt: reference count
> > > > > + *   @skc_bind2_node: bind node in the bhash2 table
> > > > >   *
> > > > >   *   This is the minimal network layer representation of sockets, the header
> > > > >   *   for struct sock and struct inet_timewait_sock.
> > > > > @@ -241,6 +242,7 @@ struct sock_common {
> > > > >               u32             skc_window_clamp;
> > > > >               u32             skc_tw_snd_nxt; /* struct tcp_timewait_sock */
> > > > >       };
> > > > > +     struct hlist_node       skc_bind2_node;
> > > > 
> > > > I *think* it would be better adding a tw_bind2_node field to the
> > > > inet_timewait_sock struct, so that we leave unmodified the request
> > > > socket and we don't change the struct sock binary layout. That could
> > > > affect performances moving hot fields on different cachelines.
> > > > 
> > > +1. The rest of this patch LGTM.
> > 
> > Then we can't use sk_for_each_bound_bhash2(), or we have to guarantee this.
> > 
> >   BUILD_BUG_ON(offsetof(struct sock, sk_bind2_node),
> >                offsetof(struct inet_timewait_sock, tw_bind2_node))
> > 
> > Considering the number of members in struct sock, at least we have
> > to move sk_bind2_node forward.
> 
> You are right, I missed that point.
> 
> 
> > Another option is to have another TIME_WAIT list in inet_bind2_bucket like
> > tb2->deathrow or something.  sk_for_each_bound_bhash2() is used only in
> > inet_bhash2_conflict(), so I think this is feasible.
> 
> This will add some more memory cost. I hope it's not a big deal, and
> looks like the better option IMHO.

Thank you, I'll post a new version on Monday.

Marry Chirstmas!
