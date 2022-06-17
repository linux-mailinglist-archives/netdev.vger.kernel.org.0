Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC1E54F268
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380807AbiFQIAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380806AbiFQIAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:00:41 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF7967D3F
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:00:38 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id w6so6029422ybl.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4b+fCL1XgJq+2hqLGxCDgV8Om0paCyod86H/i9W738w=;
        b=Zz04qTaoISISu/bTP8bDV16+NR3IpHp6y5c76vbPv7NzRPGAxCcZrgq36qj1D2nXMj
         YZhCSwkTHqmxD0iPlZVQbqEeFW+zbP/hrzlqj5b/0Nro2tGmmuOE1fQzZ5ddZCEid1ja
         iGsUY50GgZmZ+AZW3kWZ/GbMSQTD/udwoeAmNLD4ZO9Mt30FhJi0UnVKcBXDdxt4PV54
         LTULdHJaF5Y9In9LokCikXd9g1F49sojuPP1KvCrefJpCxFVsD4YIFSCKMzyVA7bSdAt
         vH/1EflMFGdWR0iRVgu5zCEhQermP5v/Bu43c4UwpbGCFY76zpBGrpdxP+Hd/Dn0N/FR
         LJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4b+fCL1XgJq+2hqLGxCDgV8Om0paCyod86H/i9W738w=;
        b=OiaYhe1GNWUkLn8hUAXzrw6CDPwhiSGVT78Tca2AzTS4D+qrW/b94Ik9JGv38scj54
         rRn4rkLJJXT/hD8/hOzlZ5tgbOWN0B/13eEhsQdmMOi97yEdxYHYDPZX4meP9Y4l59R/
         8qJG8ckiiWFkbIwpiArNjKa04lIsRjERq0Hb5IaU51E4JhvxIqf3pBrw2h2Hk9TgklCR
         WaNfa6wDx8AhQ6JA1L0ZdtzaSGSWb/F0ThTDc+nQwf08dQtSgsVtmb1W1WvDAcejCCDp
         oOs7bl4NJ9sRvAoRt1KDXWqbsLlDUklvCRiOLYuComiC4sf6M6HdM7ECBaurOUg1kvPM
         Sy4w==
X-Gm-Message-State: AJIora81wPdbAMeZmMOuO1FQpbt3bCGgqE1UMfznCO4g7TcP+9a71kTd
        BwSJa0GyV0T+gMrmdsfs5obTWJyDgwfRgyWaPIt9H1yCNqQdrA==
X-Google-Smtp-Source: AGRyM1tDfOxIFSNjqK/bohkF6fsP8RMlUpQIi3rE3yeCM6pXQZBMR2ZMfbFIq4cxrbDkTXG1AhvmKrUgQHMDlinmXHE=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr9607179ybh.36.1655452837151; Fri, 17
 Jun 2022 01:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLVxO5aqx16azNU7p7Z-nz5NrnM5QTqOzueVxEnkVTxyg@mail.gmail.com>
 <20220617065716.84113-1-kuniyu@amazon.com>
In-Reply-To: <20220617065716.84113-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Jun 2022 10:00:25 +0200
Message-ID: <CANn89iJGh452phb9Z9tsOTmesqCaX7LJdTWXbBPF1Ynz-AJMww@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Amit Shah <aams@amazon.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 8:57 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Fri, 17 Jun 2022 08:08:32 +0200
> > On Fri, Jun 17, 2022 at 7:34 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Fri, 17 Jun 2022 06:23:37 +0200
> > > > On Fri, Jun 17, 2022 at 1:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > This commit adds a per netns hash table for AF_UNIX.
> > > > >
> > > > > Note that its size is fixed as UNIX_HASH_SIZE for now.
> > > > >
> > > >
> > > > Note: Please include memory costs for this table, including when LOCKDEP is on.
> > >
> > > I'm sorry but I'm not quite sure.
> > > Do you mean the table should have the size as member of its struct?
> > > Could you elaborate on memory costs and LOCKDEP?
> >
> > I am saying that instead of two separate arrays, you are now using one
> > array, with holes in the structure
> >
> > Without LOCKDEP, sizeof(spinlock_t) is 4.
> > With LOCKDEP, sizeof(spinlock_t) is bigger.
> >
> > So we are trading some costs of having two shared dense arrays, and
> > having per-netns hash tables.
> >
> > It would be nice to mention this trade off in the changelog, because
> > some hosts have thousands of netns and few af_unix sockets :/
>
> Thank you for explanation in detail!
> I'm on the same page.
> How about having separate arrays like this in per-netns struct?
>
> struct unix_table {
>        spinlock_t *locks;
>        list_head  *buckets;
> }

Are we sure we need per-netns locks ?

I would think that sharing 256 spinlocks would be just fine, even on
hosts with more than 256 cpus.


>
>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > ---
> > > > >  include/net/af_unix.h    |  5 +++++
> > > > >  include/net/netns/unix.h |  2 ++
> > > > >  net/unix/af_unix.c       | 40 ++++++++++++++++++++++++++++++++++------
> > > > >  3 files changed, 41 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> > > > > index acb56e463db1..0a17e49af0c9 100644
> > > > > --- a/include/net/af_unix.h
> > > > > +++ b/include/net/af_unix.h
> > > > > @@ -24,6 +24,11 @@ extern unsigned int unix_tot_inflight;
> > > > >  extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
> > > > >  extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
> > > > >
> > > > > +struct unix_hashbucket {
> > > > > +       spinlock_t              lock;
> > > > > +       struct hlist_head       head;
> > > > > +};
> > > > > +
> > > > >  struct unix_address {
> > > > >         refcount_t      refcnt;
> > > > >         int             len;
> > > > > diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
> > > > > index 91a3d7e39198..975c4e3f8a5b 100644
> > > > > --- a/include/net/netns/unix.h
> > > > > +++ b/include/net/netns/unix.h
> > > > > @@ -5,8 +5,10 @@
> > > > >  #ifndef __NETNS_UNIX_H__
> > > > >  #define __NETNS_UNIX_H__
> > > > >
> > > > > +struct unix_hashbucket;
> > > > >  struct ctl_table_header;
> > > > >  struct netns_unix {
> > > > > +       struct unix_hashbucket  *hash;
> > > > >         int                     sysctl_max_dgram_qlen;
> > > > >         struct ctl_table_header *ctl;
> > > > >  };
> > > > > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > > > > index c0804ae9c96a..3c07702e2349 100644
> > > > > --- a/net/unix/af_unix.c
> > > > > +++ b/net/unix/af_unix.c
> > > > > @@ -3559,7 +3559,7 @@ static const struct net_proto_family unix_family_ops = {
> > > > >
> > > > >  static int __net_init unix_net_init(struct net *net)
> > > > >  {
> > > > > -       int error = -ENOMEM;
> > > > > +       int i;
> > > > >
> > > > >         net->unx.sysctl_max_dgram_qlen = 10;
> > > > >         if (unix_sysctl_register(net))
> > > > > @@ -3567,18 +3567,35 @@ static int __net_init unix_net_init(struct net *net)
> > > > >
> > > > >  #ifdef CONFIG_PROC_FS
> > > > >         if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
> > > > > -                       sizeof(struct seq_net_private))) {
> > > > > -               unix_sysctl_unregister(net);
> > > > > -               goto out;
> > > > > +                            sizeof(struct seq_net_private)))
> > > > > +               goto err_sysctl;
> > > > > +#endif
> > > > > +
> > > > > +       net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> > > > > +                               GFP_KERNEL);
> > > >
> > > > This will fail under memory pressure.
> > > >
> > > > Prefer kvmalloc_array()
> > >
> > > Thank you for feedback!
> > > I will use it in v2.
> > >
> > >
> > > > > +       if (!net->unx.hash)
> > > > > +               goto err_proc;
> > > > > +
> > > > > +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> > > > > +               INIT_HLIST_HEAD(&net->unx.hash[i].head);
> > > > > +               spin_lock_init(&net->unx.hash[i].lock);
> > > > >         }
> > > > > +
> > > > > +       return 0;
> > > > > +
> > > > > +err_proc:
> > > > > +#ifdef CONFIG_PROC_FS
> > > > > +       remove_proc_entry("unix", net->proc_net);
> > > > >  #endif
> > > > > -       error = 0;
> > > > > +err_sysctl:
> > > > > +       unix_sysctl_unregister(net);
> > > > >  out:
> > > > > -       return error;
> > > > > +       return -ENOMEM;
> > > > >  }
> > > > >
> > > > >  static void __net_exit unix_net_exit(struct net *net)
> > > > >  {
> > > > > +       kfree(net->unx.hash);
> > > >
> > > > kvfree()
> > > >
> > > > >         unix_sysctl_unregister(net);
> > > > >         remove_proc_entry("unix", net->proc_net);
> > > > >  }
> > > > > @@ -3666,6 +3683,16 @@ static int __init af_unix_init(void)
> > > > >
> > > > >         BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
> > > > >
> > > > > +       init_net.unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> > > > > +                                   GFP_KERNEL);
> > > >
> > > > Why are you allocating the hash table twice ? It should be done
> > > > already in  unix_net_init() ?
> > >
> > > Ah sorry, just my mistake.
> > > I'll remove this alloc/free part.
> > >
> > >
> > > > > +       if (!init_net.unx.hash)
> > > > > +               goto out;
> > > > > +
> > > > > +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> > > > > +               INIT_HLIST_HEAD(&init_net.unx.hash[i].head);
> > > > > +               spin_lock_init(&init_net.unx.hash[i].lock);
> > > > > +       }
> > > > > +
> > > > >         for (i = 0; i < UNIX_HASH_SIZE; i++)
> > > > >                 spin_lock_init(&unix_table_locks[i]);
> > > > >
> > > > > @@ -3699,6 +3726,7 @@ static void __exit af_unix_exit(void)
> > > > >         proto_unregister(&unix_dgram_proto);
> > > > >         proto_unregister(&unix_stream_proto);
> > > > >         unregister_pernet_subsys(&unix_net_ops);
> > > > > +       kfree(init_net.unx.hash);
> > > >
> > > >    Not needed.
> > > >
> > > > >  }
> > > > >
> > > > >  /* Earlier than device_initcall() so that other drivers invoking
> > > > > --
> > > > > 2.30.2
> > > > >
> > >
> > >
> > > Best regards,
> > > Kuniyuki
