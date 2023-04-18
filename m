Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC026E6CE9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjDRTZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDRTZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:25:28 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B1E10E2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681845927; x=1713381927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNijkR9wQIuH6LW1jzSRJ1IYqZy332VhSMO5uQJmubY=;
  b=o9BcNszWFg11vOMnDhXkXMrCxycj1WWTWvlbu0xSnkavk//CLKSkSP/E
   8rj2wT6JHjF6vnQPrJsVg9Sj/7xs4Z+75FVbrmBLoHB5ROmDTofq0qG5i
   QH8FbrR2osAn7Wkg4K5jvjLNFCjJ5J6S9EkcJMzwU/RpOAQzptLWVu1zy
   4=;
X-IronPort-AV: E=Sophos;i="5.99,207,1677542400"; 
   d="scan'208";a="278145411"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 19:25:21 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 788A280E08;
        Tue, 18 Apr 2023 19:25:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 18 Apr 2023 19:25:17 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.27) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 19:25:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Tue, 18 Apr 2023 12:25:04 -0700
Message-ID: <20230418192504.98991-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ3MhBYtU3vCNjLLo45tu3eyp4TbJBGP1t8yxarK2Sziw@mail.gmail.com>
References: <CANn89iJ3MhBYtU3vCNjLLo45tu3eyp4TbJBGP1t8yxarK2Sziw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.27]
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
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

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Apr 2023 21:04:32 +0200
> On Tue, Apr 18, 2023 at 8:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > On Tue, Apr 18, 2023 at 8:09 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > > skbs.  We can reproduce the problem with these sequences:
> > > >
> > > >   sk = socket(AF_INET, SOCK_DGRAM, 0)
> > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
> > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > >   sk.close()
> > > >
> > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > > the socket's error queue with the TX timestamp.
> > > >
> > > > When the original skb is received locally, skb_copy_ubufs() calls
> > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> > > > This additional count is decremented while freeing the skb, but struct
> > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > > not called.
> > > >
> > > > The last refcnt is not released unless we retrieve the TX timestamped
> > > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > > never call sock_put() and leak the count, skb, and sk.
> > > >
> > > > To avoid this problem, we must (i) call skb_queue_purge() after
> > > > flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
> > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
> > > > and TCP lacks (ii).
> > > >
> > > > Without (ii), a skb queued in a qdisc or device could be put into
> > > > the error queue after skb_queue_purge().
> > > >
> > > >   sendmsg() /* return immediately, but packets
> > > >              * are queued in a qdisc or device
> > > >              */
> > > >                                     close()
> > > >                                       skb_queue_purge()
> > > >   __skb_tstamp_tx()
> > > >     __skb_complete_tx_timestamp()
> > > >       sock_queue_err_skb()
> > > >         skb_queue_tail()
> > > >
> > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> > > > in sock_queue_err_skb() to avoid this race.
> > > >
> > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > >                                     sock_set_flag(sk, SOCK_DEAD)
> > > >                                     skb_queue_purge()
> > > >
> > > >     skb_queue_tail()
> > > >
> > > > [0]:
> > >
> > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > > v2:
> > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
> > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
> > > >   * Add Fixes tag for TCP
> > > >
> > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
> > > > ---
> > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > >  net/ipv4/udp.c    |  5 +++++
> > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index 4c0879798eb8..287b834df9c8 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
> > > >   */
> > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > >  {
> > > > +       unsigned long flags;
> > > > +
> > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
> > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > >                 return -ENOMEM;
> > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > >         /* before exiting rcu section, make sure dst is refcounted */
> > > >         skb_dst_force(skb);
> > > >
> > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > -               sk_error_report(sk);
> > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > >
> > > SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder why you
> > > want to add a confusing construct.
> > >
> > > Just bail early ?
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f8c5c05fba840a9d276abb
> > > 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struct
> > > sk_buff *skb)
> > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > >                 return -ENOMEM;
> > >
> > > +       if (sock_flag(sk, SOCK_DEAD))
> > > +               return -EINVAL;
> > > +
> >
> > Isn't it possible that these sequences happen
> >
> >   close()
> >     sock_set_flag(sk, SOCK_DEAD);
> >     skb_queue_purge(&sk->sk_error_queue)
> >
> > between the skb_queue_tail() below ? (2nd race mentioned in changelog)
> >
> > I thought we can guarantee the ordering by taking the same lock.
> >
> 
> This is fragile.

Yes, but I didn't have better idea to avoid the race...

> 
> We could very well rewrite skb_queue_purge() to not acquire the lock
> in the common case.
> I had the following in my tree for a while, to avoid many atomic and
> irq masking operations...

Cool, and it still works with my patch, no ?


> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ef81452759be3fd251faaf76d89cfd002ee79256..f570e7c89248e2d9d9ab50c2e86ac7019b837484
> 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3606,14 +3606,24 @@ EXPORT_SYMBOL(skb_dequeue_tail);
>   *     skb_queue_purge - empty a list
>   *     @list: list to empty
>   *
> - *     Delete all buffers on an &sk_buff list. Each buffer is removed from
> - *     the list and one reference dropped. This function takes the list
> - *     lock and is atomic with respect to other list locking functions.
> + *     Delete all buffers on an &sk_buff list.
>   */
>  void skb_queue_purge(struct sk_buff_head *list)
>  {
> +       struct sk_buff_head priv;
> +       unsigned long flags;
>         struct sk_buff *skb;
> -       while ((skb = skb_dequeue(list)) != NULL)
> +
> +       if (skb_queue_empty_lockless(list))
> +               return;
> +
> +       __skb_queue_head_init(&priv);
> +
> +       spin_lock_irqsave(&list->lock, flags);
> +       skb_queue_splice_init(list, &priv);
> +       spin_unlock_irqrestore(&list->lock, flags);
> +
> +       while ((skb = __skb_dequeue(&priv)) != NULL)
>                 kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(skb_queue_purge);
