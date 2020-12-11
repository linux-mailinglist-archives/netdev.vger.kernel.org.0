Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40F72D73FE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390015AbgLKKev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:34:51 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:27592 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLKKeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607682853; x=1639218853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=jqZ59faDbIXpwsl1UnPr4tC2IPH3nBwtrcCgVpPvfl4=;
  b=QfYlgzJG7ekxmP2yZrV1hUxDRjCYd+RJB74nzUFVcuQccHJ8pyDVMPtC
   Q1eEC6jG0x9I493ku7TewB8yXBjkn0aO4PIiN5Zgfy37yS7sHBiZK15G2
   IHsVAcLda8YA4v2Gw3yC+zWlcbImywCGheneFmiNqYiuz/eD8JBnWpxvD
   k=;
X-IronPort-AV: E=Sophos;i="5.78,411,1599523200"; 
   d="scan'208";a="902251790"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 11 Dec 2020 10:33:26 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 84B79A1983;
        Fri, 11 Dec 2020 10:29:05 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.146) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 10:28:59 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, <rcu@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
Date:   Fri, 11 Dec 2020 11:28:44 +0100
Message-ID: <20201211102844.13120-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iJdPa-2FQS18p3d_YjZx_5OD=eZr_3+a6LPiAxpj=fowA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D06UWA001.ant.amazon.com (10.43.160.220) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 09:43:41 +0100 Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Dec 11, 2020 at 9:21 AM SeongJae Park <sjpark@amazon.com> wrote:
> >
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > For each 'fqdir_exit()' call, a work for destroy of the 'fqdir' is
> > enqueued.  The work function, 'fqdir_work_fn()', internally calls
> > 'rcu_barrier()'.  In case of intensive 'fqdir_exit()' (e.g., frequent
> > 'unshare()' systemcalls), this increased contention could result in
> > unacceptably high latency of 'rcu_barrier()'.  This commit avoids such
> > contention by doing the 'rcu_barrier()' and subsequent lightweight works
> > in a batched manner using a dedicated singlethread worker, as similar to
> > that of 'cleanup_net()'.
> 
> 
> Not sure why you submit a patch series with a single patch.
> 
> Your cover letter contains interesting info that would better be
> captured in this changelog IMO

I thought someone might think this is not a kernel issue but the reproducer is
insane or 'rcu_barrier()' needs modification.  I wanted to do such discussion
on the coverletter.  Seems I misjudged.  I will make this single patch and move
the detailed information here from the next version.

> 
> >
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  include/net/inet_frag.h  |  1 +
> >  net/ipv4/inet_fragment.c | 45 +++++++++++++++++++++++++++++++++-------
> >  2 files changed, 39 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> > index bac79e817776..48cc5795ceda 100644
> > --- a/include/net/inet_frag.h
> > +++ b/include/net/inet_frag.h
> > @@ -21,6 +21,7 @@ struct fqdir {
> >         /* Keep atomic mem on separate cachelines in structs that include it */
> >         atomic_long_t           mem ____cacheline_aligned_in_smp;
> >         struct work_struct      destroy_work;
> > +       struct llist_node       free_list;
> >  };
> >
> >  /**
> > diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> > index 10d31733297d..a6fc4afcc323 100644
> > --- a/net/ipv4/inet_fragment.c
> > +++ b/net/ipv4/inet_fragment.c
> > @@ -145,12 +145,17 @@ static void inet_frags_free_cb(void *ptr, void *arg)
> >                 inet_frag_destroy(fq);
> >  }
> >
> > -static void fqdir_work_fn(struct work_struct *work)
> > +static struct workqueue_struct *fqdir_wq;
> > +static LLIST_HEAD(free_list);
> > +
> > +static void fqdir_free_fn(struct work_struct *work)
> >  {
> > -       struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > -       struct inet_frags *f = fqdir->f;
> > +       struct llist_node *kill_list;
> > +       struct fqdir *fqdir, *tmp;
> > +       struct inet_frags *f;
> >
> > -       rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > +       /* Atomically snapshot the list of fqdirs to free */
> > +       kill_list = llist_del_all(&free_list);
> >
> >         /* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
> >          * have completed, since they need to dereference fqdir.
> > @@ -158,12 +163,38 @@ static void fqdir_work_fn(struct work_struct *work)
> >          */
> >         rcu_barrier();
> >
> > -       if (refcount_dec_and_test(&f->refcnt))
> > -               complete(&f->completion);
> > +       llist_for_each_entry_safe(fqdir, tmp, kill_list, free_list) {
> > +               f = fqdir->f;
> > +               if (refcount_dec_and_test(&f->refcnt))
> > +                       complete(&f->completion);
> >
> > -       kfree(fqdir);
> > +               kfree(fqdir);
> > +       }
> >  }
> >
> > +static DECLARE_WORK(fqdir_free_work, fqdir_free_fn);
> > +
> > +static void fqdir_work_fn(struct work_struct *work)
> > +{
> > +       struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > +
> > +       rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > +
> > +       if (llist_add(&fqdir->free_list, &free_list))
> > +               queue_work(fqdir_wq, &fqdir_free_work);
> 
> I think you misunderstood me.
> 
> Since this fqdir_free_work will have at most one instance, you can use
> system_wq here, there is no risk of abuse.
> 
> My suggestion was to not use system_wq for fqdir_exit(), to better
> control the number
>  of threads in rhashtable cleanups.
> 
> void fqdir_exit(struct fqdir *fqdir)
> {
>         INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
> -       queue_work(system_wq, &fqdir->destroy_work);
> +      queue_work(fqdir_wq, &fqdir->destroy_work);
> }

Oh, got it.  I definitely misunderstood.  My fault, sorry.

> 
> 
> 
> > +}
> > +
> > +static int __init fqdir_wq_init(void)
> > +{
> > +       fqdir_wq = create_singlethread_workqueue("fqdir");
> 
> 
> And here, I suggest to use a non ordered work queue, allowing one
> thread per cpu, to allow concurrent rhashtable cleanups
> 
> Also "fqdir" name is rather vague, this is an implementation detail ?
> 
> fqdir_wq =create_workqueue("inet_frag_wq");

So, what you are suggesting is to use a dedicated non-ordered work queue
(fqdir_wq) for rhashtable cleanup and do the remaining works with system_wq in
the batched manner, right?  IOW, doing below change on top of this patch.

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,7 +145,7 @@ static void inet_frags_free_cb(void *ptr, void *arg)
                inet_frag_destroy(fq);
 }

-static struct workqueue_struct *fqdir_wq;
+static struct workqueue_struct *inet_frag_wq;
 static LLIST_HEAD(free_list);

 static void fqdir_free_fn(struct work_struct *work)
@@ -181,14 +181,14 @@ static void fqdir_work_fn(struct work_struct *work)
        rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);

        if (llist_add(&fqdir->free_list, &free_list))
-               queue_work(fqdir_wq, &fqdir_free_work);
+               queue_work(system_wq, &fqdir_free_work);
 }

 static int __init fqdir_wq_init(void)
 {
-       fqdir_wq = create_singlethread_workqueue("fqdir");
-       if (!fqdir_wq)
-               panic("Could not create fqdir workq");
+       inet_frag_wq = create_workqueue("inet_frag_wq");
+       if (!inet_frag_wq)
+               panic("Could not create inet frag workq");
        return 0;
 }

@@ -218,7 +218,7 @@ EXPORT_SYMBOL(fqdir_init);
 void fqdir_exit(struct fqdir *fqdir)
 {
        INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
-       queue_work(system_wq, &fqdir->destroy_work);
+       queue_work(inet_frag_wq, &fqdir->destroy_work);
 }
 EXPORT_SYMBOL(fqdir_exit);

If I'm still misunderstanding, please let me know.


Thanks,
SeongJae Park
