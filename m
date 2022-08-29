Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19DF5A57AC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiH2XfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiH2XfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:35:19 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385F51CFC0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661816117; x=1693352117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q05xUxZuHumk+Su3QipY8VUPVliLI1XBsiMwMZ0tC9w=;
  b=bYPXbh6PMvQwRMmWxQOWA+BvqbIzImRsoJ0pKSjiuWIUJN3k6x9K8NQS
   0dNQtW2K1ifO8dZFnU0kPcvt+/z0XCKJHcp05Z5wa4PGGdcUINFWvQDFT
   bu+/bEVSVtpQ4FEXR8TZ3hq/ejGRdmpyDK7R4IBHFhZiwa5q1sDZpqSCK
   Q=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 23:35:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id ACA0B2014FF;
        Mon, 29 Aug 2022 23:35:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 23:35:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.52) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 29 Aug 2022 23:35:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 4/5] tcp: Save unnecessary inet_twsk_purge() calls.
Date:   Mon, 29 Aug 2022 16:34:53 -0700
Message-ID: <20220829233453.20921-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iKbG9njkZGEbL1xX45ErFWAv11oFUsXGF-dYsp8TJnhQA@mail.gmail.com>
References: <CANn89iKbG9njkZGEbL1xX45ErFWAv11oFUsXGF-dYsp8TJnhQA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D13UWA001.ant.amazon.com (10.43.160.136) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 16:11:57 -0700
> On Mon, Aug 29, 2022 at 9:21 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > While destroying netns, we call inet_twsk_purge() in tcp_sk_exit_batch()
> > and tcpv6_net_exit_batch() for AF_INET and AF_INET6.  These commands
> > trigger the kernel to walk through the potentially big ehash twice even
> > though the netns has no TIME_WAIT sockets.
> >
> >   # ip netns add test
> >   # ip netns del test
> >
> > AF_INET6 uses module_init() to be loaded after AF_INET which uses
> > fs_initcall(), so tcpv6_net_ops is always registered after tcp_sk_ops.
> > Also, we clean up netns in the reverse order, so tcpv6_net_exit_batch()
> > is always called before tcp_sk_exit_batch().
> >
> > The characteristic enables us to save such unneeded iterations.  This
> > change eliminates the tax by the additional unshare() described in the
> > next patch to guarantee the per-netns ehash size.
> 
> Patch seems wrong to me, or not complete at least...
> 
> It seems you missed an existing check in inet_twsk_purge():
> 
> if ((tw->tw_family != family) ||
>     refcount_read(&twsk_net(tw)->ns.count))
>     continue;
> 
> To get rid of both IPv6 and IPv6 tw sockets, we currently need to call
> inet_twsk_purge() twice,
> with AF_INET and AF_INET6.

For the first call of AF_INET6, if tw_refcount is 1, the count is what
is set by tcp_sk_init() and there is no tw socket at least in the netns.

And same for the AF_INET, if tw_refcount is 0 and death_row is NULL,
there is no tw socket in the netns.

If all netns in net_exit_list satify the condition, we need not call
inet_twsk_purge().

However, one of netns in the list doesn't satisfy it, we have to call
inet_twsk_purge() twice.  Then we need to check the ns.count because
another netns in the list may be freed in tcp_sk_exit().

So, the optimisation works only when all netns in the batch list do not
have tw sockets.


> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/tcp.h        |  1 +
> >  net/ipv4/tcp_ipv4.c      |  6 ++++--
> >  net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++++++
> >  net/ipv6/tcp_ipv6.c      |  2 +-
> >  4 files changed, 30 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index d10962b9f0d0..f60996c1d7b3 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -346,6 +346,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
> >  void tcp_rcv_space_adjust(struct sock *sk);
> >  int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
> >  void tcp_twsk_destructor(struct sock *sk);
> > +void tcp_twsk_purge(struct list_head *net_exit_list, int family);
> >  ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
> >                         struct pipe_inode_info *pipe, size_t len,
> >                         unsigned int flags);
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index b07930643b11..f4a502d57d45 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -3109,8 +3109,10 @@ static void __net_exit tcp_sk_exit(struct net *net)
> >         if (net->ipv4.tcp_congestion_control)
> >                 bpf_module_put(net->ipv4.tcp_congestion_control,
> >                                net->ipv4.tcp_congestion_control->owner);
> > -       if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
> > +       if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
> >                 kfree(tcp_death_row);
> > +               net->ipv4.tcp_death_row = NULL;
> > +       }
> >  }
> >
> >  static int __net_init tcp_sk_init(struct net *net)
> > @@ -3210,7 +3212,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
> >  {
> >         struct net *net;
> >
> > -       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> > +       tcp_twsk_purge(net_exit_list, AF_INET);
> >
> >         list_for_each_entry(net, net_exit_list, exit_list)
> >                 tcp_fastopen_ctx_destroy(net);
> > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > index 361aad67c6d6..9168c5a33344 100644
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -347,6 +347,30 @@ void tcp_twsk_destructor(struct sock *sk)
> >  }
> >  EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
> >
> > +void tcp_twsk_purge(struct list_head *net_exit_list, int family)
> > +{
> > +       struct net *net;
> > +
> > +       list_for_each_entry(net, net_exit_list, exit_list) {
> > +               if (!net->ipv4.tcp_death_row)
> > +                       continue;
> > +
> > +               /* AF_INET6 using module_init() is always registered after
> > +                * AF_INET using fs_initcall() and cleaned up in the reverse
> > +                * order.
> > +                *
> > +                * The last refcount is decremented later in tcp_sk_exit().
> > +                */
> > +               if (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6 &&
> > +                   refcount_read(&net->ipv4.tcp_death_row->tw_refcount) == 1)
> > +                       continue;
> > +
> > +               inet_twsk_purge(&tcp_hashinfo, family);
> > +               break;
> > +       }
> > +}
> > +EXPORT_SYMBOL_GPL(tcp_twsk_purge);
> > +
> >  /* Warning : This function is called without sk_listener being locked.
> >   * Be sure to read socket fields once, as their value could change under us.
> >   */
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 27b2fd98a2c4..9cbc7f0d7149 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -2229,7 +2229,7 @@ static void __net_exit tcpv6_net_exit(struct net *net)
> >
> >  static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
> >  {
> > -       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> > +       tcp_twsk_purge(net_exit_list, AF_INET6);
> >  }
> >
> >  static struct pernet_operations tcpv6_net_ops = {
> > --
> > 2.30.2
> >
