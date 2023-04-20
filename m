Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9886E88C3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjDTDah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjDTDac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:30:32 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA740D4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 20:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681961431; x=1713497431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qnlhNfQD67yagxhtpdwnqtsh8YA4vw2SdZcU8Er9pVU=;
  b=G0pYeWxp1tYdd5obhSH1mme3ZHEvNqESxV6Dd5mgZlP2zXGTgt1YDvwe
   LSt0A2PrTBya6asEwbnYVun0mrAfAt80+jGHl0Cx62aj14aUC5mAXKd58
   BO9rC7DdXOkKC1nitJ3FJms3fITd9UyUE/g7/UkzRqm+okKBZGiejQZIC
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,211,1677542400"; 
   d="scan'208";a="320473140"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:30:27 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id D245580EF5;
        Thu, 20 Apr 2023 03:30:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 20 Apr 2023 03:30:25 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.17) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 20 Apr 2023 03:30:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Wed, 19 Apr 2023 20:30:13 -0700
Message-ID: <20230420033013.45693-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <6440a157b6113_128322942d@willemb.c.googlers.com.notmuch>
References: <6440a157b6113_128322942d@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.17]
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 19 Apr 2023 22:20:07 -0400
> Kuniyuki Iwashima wrote:
> > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Date:   Wed, 19 Apr 2023 13:50:47 -0400
> > > Kuniyuki Iwashima wrote:
> > > > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > Date:   Wed, 19 Apr 2023 10:16:07 -0400
> > > > > Eric Dumazet wrote:
> > > > > > On Tue, Apr 18, 2023 at 9:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > > Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > > > > > > > On Tue, Apr 18, 2023 at 8:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > > >
> > > > > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > > > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > > > > > > > On Tue, Apr 18, 2023 at 8:09 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > > > > > > > > > skbs.  We can reproduce the problem with these sequences:
> > > > > > > > > > >
> > > > > > > > > > >   sk = socket(AF_INET, SOCK_DGRAM, 0)
> > > > > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
> > > > > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > > > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > > > > > > >   sk.close()
> > > > > > > > > > >
> > > > > > > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > > > > > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > > > > > > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > > > > > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > > > > > > > > > the socket's error queue with the TX timestamp.
> > > > > > > > > > >
> > > > > > > > > > > When the original skb is received locally, skb_copy_ubufs() calls
> > > > > > > > > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> > > > > > > > > > > This additional count is decremented while freeing the skb, but struct
> > > > > > > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > > > > > > > > > not called.
> > > > > > > > > > >
> > > > > > > > > > > The last refcnt is not released unless we retrieve the TX timestamped
> > > > > > > > > > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > > > > > > > > > never call sock_put() and leak the count, skb, and sk.
> > > > > > > > > > >
> > > > > > > > > > > To avoid this problem, we must (i) call skb_queue_purge() after
> > > > > > > > > > > flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
> > > > > > > > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
> > > > > > > > > > > and TCP lacks (ii).
> > > > > > > > > > >
> > > > > > > > > > > Without (ii), a skb queued in a qdisc or device could be put into
> > > > > > > > > > > the error queue after skb_queue_purge().
> > > > > > > > > > >
> > > > > > > > > > >   sendmsg() /* return immediately, but packets
> > > > > > > > > > >              * are queued in a qdisc or device
> > > > > > > > > > >              */
> > > > > > > > > > >                                     close()
> > > > > > > > > > >                                       skb_queue_purge()
> > > > > > > > > > >   __skb_tstamp_tx()
> > > > > > > > > > >     __skb_complete_tx_timestamp()
> > > > > > > > > > >       sock_queue_err_skb()
> > > > > > > > > > >         skb_queue_tail()
> > > > > > > > > > >
> > > > > > > > > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> > > > > > > > > > > in sock_queue_err_skb() to avoid this race.
> > > > > > > > > > >
> > > > > > > > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > > > > >                                     sock_set_flag(sk, SOCK_DEAD)
> > > > > > > > > > >                                     skb_queue_purge()
> > > > > > > > > > >
> > > > > > > > > > >     skb_queue_tail()
> > > > > > > > > > >
> > > > > > > > > > > [0]:
> > > > > > > > > >
> > > > > > > > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > > > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > > > > ---
> > > > > > > > > > > v2:
> > > > > > > > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
> > > > > > > > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
> > > > > > > > > > >   * Add Fixes tag for TCP
> > > > > > > > > > >
> > > > > > > > > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
> > > > > > > > > > > ---
> > > > > > > > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > > > > > > > >  net/ipv4/udp.c    |  5 +++++
> > > > > > > > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > > > > > > > --- a/net/core/skbuff.c
> > > > > > > > > > > +++ b/net/core/skbuff.c
> > > > > > > > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
> > > > > > > > > > >   */
> > > > > > > > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > > > > > > > > >  {
> > > > > > > > > > > +       unsigned long flags;
> > > > > > > > > > > +
> > > > > > > > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
> > > > > > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > > > > > > > > >         /* before exiting rcu section, make sure dst is refcounted */
> > > > > > > > > > >         skb_dst_force(skb);
> > > > > > > > > > >
> > > > > > > > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > > > > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > > > > > -               sk_error_report(sk);
> > > > > > > > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > > > > > > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > > > > > > > >
> > > > > > > > > > SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder why you
> > > > > > > > > > want to add a confusing construct.
> > > > > > > > > >
> > > > > > > > > > Just bail early ?
> > > > > > > > > >
> > > > > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f8c5c05fba840a9d276abb
> > > > > > > > > > 100644
> > > > > > > > > > --- a/net/core/skbuff.c
> > > > > > > > > > +++ b/net/core/skbuff.c
> > > > > > > > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struct
> > > > > > > > > > sk_buff *skb)
> > > > > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > >
> > > > > > > > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > > > > > > > +               return -EINVAL;
> > > > > > > > > > +
> > > > > > > > >
> > > > > > > > > Isn't it possible that these sequences happen
> > > > > > > > >
> > > > > > > > >   close()
> > > > > > > > >     sock_set_flag(sk, SOCK_DEAD);
> > > > > > > > >     skb_queue_purge(&sk->sk_error_queue)
> > > > > > > > >
> > > > > > > > > between the skb_queue_tail() below ? (2nd race mentioned in changelog)
> > > > > > > > >
> > > > > > > > > I thought we can guarantee the ordering by taking the same lock.
> > > > > > > > >
> > > > > > > >
> > > > > > > > This is fragile.
> > > > > > >
> > > > > > > Yes, but I didn't have better idea to avoid the race...
> > > > > > >
> > > > > > > >
> > > > > > > > We could very well rewrite skb_queue_purge() to not acquire the lock
> > > > > > > > in the common case.
> > > > > > > > I had the following in my tree for a while, to avoid many atomic and
> > > > > > > > irq masking operations...
> > > > > > >
> > > > > > > Cool, and it still works with my patch, no ?
> > > > > > >
> > > > > > 
> > > > > > 
> > > > > > Really the only thing that ensures a race is not possible is the
> > > > > > typical sk_refcnt acquisition.
> > > > > > 
> > > > > > But I do not see why an skb stored in error_queue should keep the
> > > > > > refcnt on the socket.
> > > > > > This seems like a chicken and egg problem, and caused various issues
> > > > > > in the past,
> > > > > > see for instance [1]
> > > > > > 
> > > > > > We better make sure error queue is purged at socket dismantle (after
> > > > > > refcnt reached 0)
> > > > > 
> > > > > The problem here is that the timestamp queued on the error queue
> > > > > holds a reference on a ubuf if MSG_ZEROCOPY and that ubuf holds an
> > > > > sk_ref.
> > > > > 
> > > > > The timestamped packet may contain packet contents, so the ubuf
> > > > > ref is not superfluous.
> > > > > 
> > > > > Come to think of it, we've always maintained that zerocopy packets
> > > > > should not be looped to sockets where they can be queued indefinitely,
> > > > > including packet sockets.
> > > > > 
> > > > > If we enforce that for these tx timestamps too, then that also
> > > > > solves this issue.
> > > > > 
> > > > > A process that wants efficient MSG_ZEROCOPY will have to request
> > > > > timestamping with SOF_TIMESTAMPING_OPT_TSONLY to avoid returning the
> > > > > data along with the timestamp.
> > > > 
> > > > Actually, my first attempt was similar to this that avoids skb_clone()
> > > > silently if MSG_ZEROCOPY, but this kind of way could break users who
> > > > were using tstamp and just added MSG_ZEROCOPY logic to their app, so
> > > > I placed skb_queue_purge() during close().
> > > > 
> > > > ---8<---
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index eb7d33b41e71..9318b438888e 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -5135,7 +5149,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> > > >  	if (!skb_may_tx_timestamp(sk, tsonly))
> > > >  		return;
> > > >  
> > > > -	if (tsonly) {
> > > > +	if (tsonly || skb_zcopy(orig_skb)) {
> > > >  #ifdef CONFIG_INET
> > > >  		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
> > > >  		    sk_is_tcp(sk)) {
> > > > ---8<---
> > > 
> > > Actually, the skb_clone in __skb_tstamp_tx should already release
> > > the reference on the ubuf.
> > > 
> > > With the same mechanism that we rely on for packet sockets, e.g.,
> > > in dev_queue_xmit_nit.
> > > 
> > > skb_clone calls skb_orphan_frags calls skb_copy_ubufs for zerocopy
> > > skbs. Which creates a copy of the data and calls skb_zcopy_clear.
> > > 
> > > The skb that gets queued onto the error queue should not have a
> > > reference on an ubuf: skb_zcopy(skb) should return NULL.
> > 
> > Exactly, so how about this ?
> > 
> > ---8<---
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 768f9d04911f..0fa0b2ac7071 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5166,6 +5166,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> >  	if (!skb)
> >  		return;
> >  
> > +	if (skb_zcopy(skb) && skb_copy_ubufs(skb, GFP_ATOMIC))
> > +		return;
> > +
> >  	if (tsonly) {
> >  		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
> >  					     SKBTX_ANY_TSTAMP;
> > ---8<---
> > 
> 
> What I meant was that given this I don't understand how a packet
> with ubuf references gets queued at all.
> 
> __skb_tstamp_tx does not queue orig_skb. It either allocates a new
> skb or calls skb = skb_clone(orig_skb).
> 
> That existing call internally calls skb_orphan_frags and
> skb_copy_ubufs.

No, skb_orphan_frags() does not call skb_copy_ubufs() here because
msg_zerocopy_alloc() sets SKBFL_DONT_ORPHAN for orig_skb.

So, we need to call skb_copy_ubufs() explicitly if skb_zcopy(skb).

> 
> So the extra test should not be needed. Indeed I would be surprised if
> this triggers:

And this actually triggers.

> 
> @@ -5164,6 +5164,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>         if (!skb)
>                 return;
>  
> +       WARN_ON_ONCE(skb_zcopy(sbk));
> +
> 
>         if (tsonly) {
>                 skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
>                                              SKBTX_ANY_TSTAMP;
