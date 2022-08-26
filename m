Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7210E5A2D10
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbiHZRDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiHZRDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:03:31 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3FEC7428;
        Fri, 26 Aug 2022 10:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661533409; x=1693069409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BB7nL/yCEd54alWW1ys6NzmFrOBd4yqtaVc4m/MMWic=;
  b=sdeeWjVmycV/+kmkfDUKF5+iUhTqle9WCUvZLr2liJ3Zw9O3nMiX1Yhn
   m2NJa5vambH9+j5RxV+X9ioGUyEROJJFx9x8dWRQwX8cHnwETjg3SaAOi
   n28IXmWNJKtgpShjXPvXFQr8xX6WzQFReAFjFECFPzDEssBY7lq5y0tYZ
   8=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="253273497"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 17:03:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id EA9FB81FF9;
        Fri, 26 Aug 2022 17:03:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 17:03:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 17:03:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-fsdevel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net-next 04/13] net: Introduce init2() for pernet_operations.
Date:   Fri, 26 Aug 2022 10:03:15 -0700
Message-ID: <20220826170315.96700-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+7dwkOnKRhiK6-bNi-aK9n885muc4u_RnTCUt-AxyoQg@mail.gmail.com>
References: <CANn89i+7dwkOnKRhiK6-bNi-aK9n885muc4u_RnTCUt-AxyoQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D05UWB004.ant.amazon.com (10.43.161.208) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:20:06 -0700
> On Thu, Aug 25, 2022 at 5:06 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > This patch adds a new init function for pernet_operations, init2().
> 
> Why ?
> 
> This seems not really needed...
> 
> TCP ops->init can trivially reach the parent net_ns if needed,
> because the current process is the one doing the creation of a new net_ns.

Yes, it's true because IPv4 TCP/UDP are both unloadable.

At first, I was thinking of a general interface, but I'm fine
to drop this patch and access current->nsproxy->net_ns like
sysctl_devconf_inherit_init_net does.


> 
> >
> > We call each init2() during clone() or unshare() only, where we can
> > access the parent netns for a child netns creation.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/net_namespace.h |  3 +++
> >  net/core/net_namespace.c    | 18 +++++++++++-------
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> > index 8c3587d5c308..3ca426649756 100644
> > --- a/include/net/net_namespace.h
> > +++ b/include/net/net_namespace.h
> > @@ -410,6 +410,8 @@ struct pernet_operations {
> >          * from register_pernet_subsys(), unregister_pernet_subsys()
> >          * register_pernet_device() and unregister_pernet_device().
> >          *
> > +        * init2() is called during clone() or unshare() only.
> > +        *
> >          * Exit methods using blocking RCU primitives, such as
> >          * synchronize_rcu(), should be implemented via exit_batch.
> >          * Then, destruction of a group of net requires single
> > @@ -422,6 +424,7 @@ struct pernet_operations {
> >          * the calls.
> >          */
> >         int (*init)(struct net *net);
> > +       int (*init2)(struct net *net, struct net *old_net);
> >         void (*pre_exit)(struct net *net);
> >         void (*exit)(struct net *net);
> >         void (*exit_batch)(struct list_head *net_exit_list);
> > diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> > index 6b9f19122ec1..b120ff97d9f5 100644
> > --- a/net/core/net_namespace.c
> > +++ b/net/core/net_namespace.c
> > @@ -116,7 +116,8 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
> >         return 0;
> >  }
> >
> > -static int ops_init(const struct pernet_operations *ops, struct net *net)
> > +static int ops_init(const struct pernet_operations *ops,
> > +                   struct net *net, struct net *old_net)
> >  {
> >         int err = -ENOMEM;
> >         void *data = NULL;
> > @@ -133,6 +134,8 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
> >         err = 0;
> >         if (ops->init)
> >                 err = ops->init(net);
> > +       if (!err && ops->init2 && old_net)
> > +               err = ops->init2(net, old_net);
> 
> If an error comes here, while ops->init() was a success, we probably
> leave things in a bad state (memory leak ?)

Somehow I thought .exit() should handle the case, yes, it's really bad
design... at least I should have added .exit2().

I'll drop this in v2.

Thank you!


> 
> >         if (!err)
> >                 return 0;
> >
> > @@ -301,7 +304,8 @@ EXPORT_SYMBOL_GPL(get_net_ns_by_id);
> >  /*
> >   * setup_net runs the initializers for the network namespace object.
> >   */
> > -static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
> > +static __net_init int setup_net(struct net *net, struct net *old_net,
> > +                               struct user_namespace *user_ns)
> >  {
> >         /* Must be called with pernet_ops_rwsem held */
> >         const struct pernet_operations *ops, *saved_ops;
> > @@ -323,7 +327,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
> >         mutex_init(&net->ipv4.ra_mutex);
> >
> >         list_for_each_entry(ops, &pernet_list, list) {
> > -               error = ops_init(ops, net);
> > +               error = ops_init(ops, net, old_net);
> >                 if (error < 0)
> >                         goto out_undo;
> >         }
> > @@ -469,7 +473,7 @@ struct net *copy_net_ns(unsigned long flags,
> >         if (rv < 0)
> >                 goto put_userns;
> >
> > -       rv = setup_net(net, user_ns);
> > +       rv = setup_net(net, old_net, user_ns);
> >
> >         up_read(&pernet_ops_rwsem);
> >
> > @@ -1107,7 +1111,7 @@ void __init net_ns_init(void)
> >         init_net.key_domain = &init_net_key_domain;
> >  #endif
> >         down_write(&pernet_ops_rwsem);
> > -       if (setup_net(&init_net, &init_user_ns))
> > +       if (setup_net(&init_net, NULL, &init_user_ns))
> >                 panic("Could not setup the initial network namespace");
> >
> >         init_net_initialized = true;
> > @@ -1148,7 +1152,7 @@ static int __register_pernet_operations(struct list_head *list,
> >
> >                         memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
> >                         old = set_active_memcg(memcg);
> > -                       error = ops_init(ops, net);
> > +                       error = ops_init(ops, net, NULL);
> >                         set_active_memcg(old);
> >                         mem_cgroup_put(memcg);
> >                         if (error)
> > @@ -1188,7 +1192,7 @@ static int __register_pernet_operations(struct list_head *list,
> >                 return 0;
> >         }
> >
> > -       return ops_init(ops, &init_net);
> > +       return ops_init(ops, &init_net, NULL);
> >  }
> >
> >  static void __unregister_pernet_operations(struct pernet_operations *ops)
> > --
> > 2.30.2
> >
