Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CCB54FC87
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiFQRwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFQRwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:52:50 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1FEDEE9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655488369; x=1687024369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wYRmgwkf5v/OnfQXkZpjWot0NZtzxVDI3xyS0mw1zhM=;
  b=fDGCCvwaCEVBYIrg6RSPiEuN258II6xogx6ShSEBEX9TUcy3PIa5GH9e
   GjdfhLVtfOmUZmOP/jSETlXm4ugac+bJJTf7ntbCeKEZ+8zuFa8vi96Og
   BFut6+SBcNgRaNzMpVDZ3Ta12K7B/SNIygyG1Tbdq4HgQu2FHthXweRiu
   o=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="229294661"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 17 Jun 2022 17:52:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id A99A08284D;
        Fri, 17 Jun 2022 17:52:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 17 Jun 2022 17:52:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 17 Jun 2022 17:52:28 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <aams@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
Date:   Fri, 17 Jun 2022 10:52:15 -0700
Message-ID: <20220617175215.1769-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJGh452phb9Z9tsOTmesqCaX7LJdTWXbBPF1Ynz-AJMww@mail.gmail.com>
References: <CANn89iJGh452phb9Z9tsOTmesqCaX7LJdTWXbBPF1Ynz-AJMww@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Jun 2022 10:00:25 +0200
> On Fri, Jun 17, 2022 at 8:57 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Fri, 17 Jun 2022 08:08:32 +0200
> > > On Fri, Jun 17, 2022 at 7:34 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Fri, 17 Jun 2022 06:23:37 +0200
> > > > > On Fri, Jun 17, 2022 at 1:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > This commit adds a per netns hash table for AF_UNIX.
> > > > > >
> > > > > > Note that its size is fixed as UNIX_HASH_SIZE for now.
> > > > > >
> > > > >
> > > > > Note: Please include memory costs for this table, including when LOCKDEP is on.
> > > >
> > > > I'm sorry but I'm not quite sure.
> > > > Do you mean the table should have the size as member of its struct?
> > > > Could you elaborate on memory costs and LOCKDEP?
> > >
> > > I am saying that instead of two separate arrays, you are now using one
> > > array, with holes in the structure
> > >
> > > Without LOCKDEP, sizeof(spinlock_t) is 4.
> > > With LOCKDEP, sizeof(spinlock_t) is bigger.
> > >
> > > So we are trading some costs of having two shared dense arrays, and
> > > having per-netns hash tables.
> > >
> > > It would be nice to mention this trade off in the changelog, because
> > > some hosts have thousands of netns and few af_unix sockets :/
> >
> > Thank you for explanation in detail!
> > I'm on the same page.
> > How about having separate arrays like this in per-netns struct?
> >
> > struct unix_table {
> >        spinlock_t *locks;
> >        list_head  *buckets;
> > }
> 
> Are we sure we need per-netns locks ?
> 
> I would think that sharing 256 spinlocks would be just fine, even on
> hosts with more than 256 cpus.

I ran the test written on the last patch with three kernels 10 times
for each:

  1) global locks and hash table
     1m 38s ~ 1m 43s

  2) per-netns locks and hash tables (two dense arrays version)
     11s

  3) global locks and per-netns hash tables
     15s

As you thought, the length of list has larger impact than lock contention.
But on a host with 10 cpus per-netns, per-netns locks are faster than
shared one.

What do you think about this trade-off?


> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > ---
> > > > > >  include/net/af_unix.h    |  5 +++++
> > > > > >  include/net/netns/unix.h |  2 ++
> > > > > >  net/unix/af_unix.c       | 40 ++++++++++++++++++++++++++++++++++------
> > > > > >  3 files changed, 41 insertions(+), 6 deletions(-)
> > > > > >
> > > > > > diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> > > > > > index acb56e463db1..0a17e49af0c9 100644
> > > > > > --- a/include/net/af_unix.h
> > > > > > +++ b/include/net/af_unix.h
> > > > > > @@ -24,6 +24,11 @@ extern unsigned int unix_tot_inflight;
> > > > > >  extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
> > > > > >  extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
> > > > > >
> > > > > > +struct unix_hashbucket {
> > > > > > +       spinlock_t              lock;
> > > > > > +       struct hlist_head       head;
> > > > > > +};
> > > > > > +
> > > > > >  struct unix_address {
> > > > > >         refcount_t      refcnt;
> > > > > >         int             len;
> > > > > > diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
> > > > > > index 91a3d7e39198..975c4e3f8a5b 100644
> > > > > > --- a/include/net/netns/unix.h
> > > > > > +++ b/include/net/netns/unix.h
> > > > > > @@ -5,8 +5,10 @@
> > > > > >  #ifndef __NETNS_UNIX_H__
> > > > > >  #define __NETNS_UNIX_H__
> > > > > >
> > > > > > +struct unix_hashbucket;
> > > > > >  struct ctl_table_header;
> > > > > >  struct netns_unix {
> > > > > > +       struct unix_hashbucket  *hash;
> > > > > >         int                     sysctl_max_dgram_qlen;
> > > > > >         struct ctl_table_header *ctl;
> > > > > >  };
> > > > > > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > > > > > index c0804ae9c96a..3c07702e2349 100644
> > > > > > --- a/net/unix/af_unix.c
> > > > > > +++ b/net/unix/af_unix.c
> > > > > > @@ -3559,7 +3559,7 @@ static const struct net_proto_family unix_family_ops = {
> > > > > >
> > > > > >  static int __net_init unix_net_init(struct net *net)
> > > > > >  {
> > > > > > -       int error = -ENOMEM;
> > > > > > +       int i;
> > > > > >
> > > > > >         net->unx.sysctl_max_dgram_qlen = 10;
> > > > > >         if (unix_sysctl_register(net))
> > > > > > @@ -3567,18 +3567,35 @@ static int __net_init unix_net_init(struct net *net)
> > > > > >
> > > > > >  #ifdef CONFIG_PROC_FS
> > > > > >         if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
> > > > > > -                       sizeof(struct seq_net_private))) {
> > > > > > -               unix_sysctl_unregister(net);
> > > > > > -               goto out;
> > > > > > +                            sizeof(struct seq_net_private)))
> > > > > > +               goto err_sysctl;
> > > > > > +#endif
> > > > > > +
> > > > > > +       net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> > > > > > +                               GFP_KERNEL);
> > > > >
> > > > > This will fail under memory pressure.
> > > > >
> > > > > Prefer kvmalloc_array()
> > > >
> > > > Thank you for feedback!
> > > > I will use it in v2.
> > > >
> > > >
> > > > > > +       if (!net->unx.hash)
> > > > > > +               goto err_proc;
> > > > > > +
> > > > > > +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> > > > > > +               INIT_HLIST_HEAD(&net->unx.hash[i].head);
> > > > > > +               spin_lock_init(&net->unx.hash[i].lock);
> > > > > >         }
> > > > > > +
> > > > > > +       return 0;
> > > > > > +
> > > > > > +err_proc:
> > > > > > +#ifdef CONFIG_PROC_FS
> > > > > > +       remove_proc_entry("unix", net->proc_net);
> > > > > >  #endif
> > > > > > -       error = 0;
> > > > > > +err_sysctl:
> > > > > > +       unix_sysctl_unregister(net);
> > > > > >  out:
> > > > > > -       return error;
> > > > > > +       return -ENOMEM;
> > > > > >  }
> > > > > >
> > > > > >  static void __net_exit unix_net_exit(struct net *net)
> > > > > >  {
> > > > > > +       kfree(net->unx.hash);
> > > > >
> > > > > kvfree()
> > > > >
> > > > > >         unix_sysctl_unregister(net);
> > > > > >         remove_proc_entry("unix", net->proc_net);
> > > > > >  }
> > > > > > @@ -3666,6 +3683,16 @@ static int __init af_unix_init(void)
> > > > > >
> > > > > >         BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
> > > > > >
> > > > > > +       init_net.unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> > > > > > +                                   GFP_KERNEL);
> > > > >
> > > > > Why are you allocating the hash table twice ? It should be done
> > > > > already in  unix_net_init() ?
> > > >
> > > > Ah sorry, just my mistake.
> > > > I'll remove this alloc/free part.
> > > >
> > > >
> > > > > > +       if (!init_net.unx.hash)
> > > > > > +               goto out;
> > > > > > +
> > > > > > +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> > > > > > +               INIT_HLIST_HEAD(&init_net.unx.hash[i].head);
> > > > > > +               spin_lock_init(&init_net.unx.hash[i].lock);
> > > > > > +       }
> > > > > > +
> > > > > >         for (i = 0; i < UNIX_HASH_SIZE; i++)
> > > > > >                 spin_lock_init(&unix_table_locks[i]);
> > > > > >
> > > > > > @@ -3699,6 +3726,7 @@ static void __exit af_unix_exit(void)
> > > > > >         proto_unregister(&unix_dgram_proto);
> > > > > >         proto_unregister(&unix_stream_proto);
> > > > > >         unregister_pernet_subsys(&unix_net_ops);
> > > > > > +       kfree(init_net.unx.hash);
> > > > >
> > > > >    Not needed.
> > > > >
> > > > > >  }
> > > > > >
> > > > > >  /* Earlier than device_initcall() so that other drivers invoking
> > > > > > --
> > > > > > 2.30.2
> > > > > >
> > > >
> > > >
> > > > Best regards,
> > > > Kuniyuki
