Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CBE6E8020
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjDSRI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjDSRI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:08:56 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67344A247
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681924069; x=1713460069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIghVi7DSpnnR8kVK+iRLxGDPQRkzIFIplqL99xh65w=;
  b=a61llMJkzqsgidmAttkaVTvCv0haZ43vDRMqOe9Pjnud3cEhqvWJp5z4
   CKde9Xjp2YTEYl4ms8bMPvMlf1YkdkRnda0CpmDnjxABNh9TCyt+PvUhl
   9x168YDNG+i+1Yn1Qh6JBrS/dn2fmqLlwYzSz3nXi5h+Zt4l9WVtMt61L
   U=;
X-IronPort-AV: E=Sophos;i="5.99,208,1677542400"; 
   d="scan'208";a="320258658"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 17:07:45 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id EC110160A81;
        Wed, 19 Apr 2023 17:07:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 19 Apr 2023 17:07:39 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.33) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 17:07:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Wed, 19 Apr 2023 10:07:26 -0700
Message-ID: <20230419170727.29740-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <643ff7a7a551f_38347529475@willemb.c.googlers.com.notmuch>
References: <643ff7a7a551f_38347529475@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.170.33]
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
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
Date:   Wed, 19 Apr 2023 10:16:07 -0400
> Eric Dumazet wrote:
> > On Tue, Apr 18, 2023 at 9:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > > > On Tue, Apr 18, 2023 at 8:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > > > On Tue, Apr 18, 2023 at 8:09 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > > > > > skbs.  We can reproduce the problem with these sequences:
> > > > > > >
> > > > > > >   sk = socket(AF_INET, SOCK_DGRAM, 0)
> > > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
> > > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > > >   sk.close()
> > > > > > >
> > > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > > > > > the socket's error queue with the TX timestamp.
> > > > > > >
> > > > > > > When the original skb is received locally, skb_copy_ubufs() calls
> > > > > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> > > > > > > This additional count is decremented while freeing the skb, but struct
> > > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > > > > > not called.
> > > > > > >
> > > > > > > The last refcnt is not released unless we retrieve the TX timestamped
> > > > > > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > > > > > never call sock_put() and leak the count, skb, and sk.
> > > > > > >
> > > > > > > To avoid this problem, we must (i) call skb_queue_purge() after
> > > > > > > flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
> > > > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
> > > > > > > and TCP lacks (ii).
> > > > > > >
> > > > > > > Without (ii), a skb queued in a qdisc or device could be put into
> > > > > > > the error queue after skb_queue_purge().
> > > > > > >
> > > > > > >   sendmsg() /* return immediately, but packets
> > > > > > >              * are queued in a qdisc or device
> > > > > > >              */
> > > > > > >                                     close()
> > > > > > >                                       skb_queue_purge()
> > > > > > >   __skb_tstamp_tx()
> > > > > > >     __skb_complete_tx_timestamp()
> > > > > > >       sock_queue_err_skb()
> > > > > > >         skb_queue_tail()
> > > > > > >
> > > > > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> > > > > > > in sock_queue_err_skb() to avoid this race.
> > > > > > >
> > > > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > > > >                                     sock_set_flag(sk, SOCK_DEAD)
> > > > > > >                                     skb_queue_purge()
> > > > > > >
> > > > > > >     skb_queue_tail()
> > > > > > >
> > > > > > > [0]:
> > > > > >
> > > > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > ---
> > > > > > > v2:
> > > > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
> > > > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
> > > > > > >   * Add Fixes tag for TCP
> > > > > > >
> > > > > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
> > > > > > > ---
> > > > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > > > >  net/ipv4/udp.c    |  5 +++++
> > > > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > > > --- a/net/core/skbuff.c
> > > > > > > +++ b/net/core/skbuff.c
> > > > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
> > > > > > >   */
> > > > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > > > > >  {
> > > > > > > +       unsigned long flags;
> > > > > > > +
> > > > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
> > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > >                 return -ENOMEM;
> > > > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > > > > >         /* before exiting rcu section, make sure dst is refcounted */
> > > > > > >         skb_dst_force(skb);
> > > > > > >
> > > > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > -               sk_error_report(sk);
> > > > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > > > >
> > > > > > SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder why you
> > > > > > want to add a confusing construct.
> > > > > >
> > > > > > Just bail early ?
> > > > > >
> > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f8c5c05fba840a9d276abb
> > > > > > 100644
> > > > > > --- a/net/core/skbuff.c
> > > > > > +++ b/net/core/skbuff.c
> > > > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struct
> > > > > > sk_buff *skb)
> > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > >                 return -ENOMEM;
> > > > > >
> > > > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > >
> > > > > Isn't it possible that these sequences happen
> > > > >
> > > > >   close()
> > > > >     sock_set_flag(sk, SOCK_DEAD);
> > > > >     skb_queue_purge(&sk->sk_error_queue)
> > > > >
> > > > > between the skb_queue_tail() below ? (2nd race mentioned in changelog)
> > > > >
> > > > > I thought we can guarantee the ordering by taking the same lock.
> > > > >
> > > >
> > > > This is fragile.
> > >
> > > Yes, but I didn't have better idea to avoid the race...
> > >
> > > >
> > > > We could very well rewrite skb_queue_purge() to not acquire the lock
> > > > in the common case.
> > > > I had the following in my tree for a while, to avoid many atomic and
> > > > irq masking operations...
> > >
> > > Cool, and it still works with my patch, no ?
> > >
> > 
> > 
> > Really the only thing that ensures a race is not possible is the
> > typical sk_refcnt acquisition.
> > 
> > But I do not see why an skb stored in error_queue should keep the
> > refcnt on the socket.
> > This seems like a chicken and egg problem, and caused various issues
> > in the past,
> > see for instance [1]
> > 
> > We better make sure error queue is purged at socket dismantle (after
> > refcnt reached 0)
> 
> The problem here is that the timestamp queued on the error queue
> holds a reference on a ubuf if MSG_ZEROCOPY and that ubuf holds an
> sk_ref.
> 
> The timestamped packet may contain packet contents, so the ubuf
> ref is not superfluous.
> 
> Come to think of it, we've always maintained that zerocopy packets
> should not be looped to sockets where they can be queued indefinitely,
> including packet sockets.
> 
> If we enforce that for these tx timestamps too, then that also
> solves this issue.
> 
> A process that wants efficient MSG_ZEROCOPY will have to request
> timestamping with SOF_TIMESTAMPING_OPT_TSONLY to avoid returning the
> data along with the timestamp.

Actually, my first attempt was similar to this that avoids skb_clone()
silently if MSG_ZEROCOPY, but this kind of way could break users who
were using tstamp and just added MSG_ZEROCOPY logic to their app, so
I placed skb_queue_purge() during close().

---8<---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index eb7d33b41e71..9318b438888e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5135,7 +5149,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 	if (!skb_may_tx_timestamp(sk, tsonly))
 		return;
 
-	if (tsonly) {
+	if (tsonly || skb_zcopy(orig_skb)) {
 #ifdef CONFIG_INET
 		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
 		    sk_is_tcp(sk)) {
---8<---


> 
> > I suggest we generalize fix that went in this patch :
> > 
> > dd4f10722aeb10f4f582948839f066bebe44e5fb net: fix socket refcounting
> > in skb_complete_wifi_ack()
> > 
> > Instead of adding yet another rule about a queue lock, and a socket
> > flag, this would keep things tied to sk_refcnt.
> > 
> > Also I do not think TCP has an issue, please take a look at
> > 
> > [1]
> > commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3    net: stream: purge
> > sk_error_queue in sk_stream_kill_queues()
> > 
> > (A leak in TCP would be caught in a few hours by syzbot really)

I have tested TCP before posting v1 and found this skb_queue_purge()
was to prevent the same issue, but Willem's point sounds reasonable
that packets queued in qdisc or device could be put in the error queue
after close() completes.  That's why I mentioned TCP since v2.
