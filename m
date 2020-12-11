Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212B62D741B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392591AbgLKKmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389428AbgLKKm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:42:29 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36AC0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:41:48 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id z136so9022082iof.3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gLNjygVT9zPDI8y5SVkCNef9e9uyFYeqq082/T6qSo=;
        b=vo4TER9Wk1zb4HozmOtFaX1mB/6GU89rzzMknrhE1fUvT55aKrum/HowDHvhwzT5gF
         m9YTfAu2YJs+0RgPfG2uC0pkO0omXIUNn6P4YAWdGP6l/aBF+8IL6PIGh2nX2ANMs3LK
         mESvLtfKBkEGiPaWkJ+h0xswwFIh01vdJscyfuln/SklZ2iipnts8RP4JCDvSZsiHJ9z
         +/n1TpYLWuO8aKH3SmHTketSjLF2VScEWVI8ATH7eGNXcOWIX3fLbeaGOmrSISNV2g+Z
         ujYBHjojECTTU6IwMa5Cr1rVESF0jFSX9AdT988iwqNb9xyL9OpBab+gKCuW6rGq/nir
         BwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gLNjygVT9zPDI8y5SVkCNef9e9uyFYeqq082/T6qSo=;
        b=SjRx2chX5r+QxizjOlgEzr4YYQTZqgxXB6geQVuYD4cY0pqUG2Y5bNDY0dli9Q25z5
         CMvZ95ttsHnwBd7ynoZl5fEYZMOJ9IpdKi1MIiClBLJjfZHKfWjn5UiqDlBf3/KpuTr3
         3Uu6IYEO0syYTbooUzL2dEsFVSTDaQ+CbZDr+LEnza+3NjJl0Q6x2s802ExFCDMeR+FK
         b9YqEVqQc7Ac/rrgxHtwRIzG7NaUbbi36+EZa3/trGaxjMteVijnz1ePBFUiAGjDI712
         2YxviOYv/PiSxP/wagwVHMSk/OkrDWkpQinaFrRKFZ+8Kw4XmkPRw6Ooum/L2j1hs7mi
         rR0Q==
X-Gm-Message-State: AOAM533hqGqdgluPrKA7AqmzAf3TuRSfh+MiAN4QBOJO0x+nJTR62U+U
        rM7vPbmS9KwVxdvlp1xNbVYhXe6c6Pkc1jmGGnKmog==
X-Google-Smtp-Source: ABdhPJw7kmPMx80LhKU5P2hNwPxm/NOdLPxRYPyvGZEDy99ZRj/BB875tL9m5B73g1xqYEyLrVaHqnZANoweZ8vil/g=
X-Received: by 2002:a02:7821:: with SMTP id p33mr15231786jac.53.1607683308007;
 Fri, 11 Dec 2020 02:41:48 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iJdPa-2FQS18p3d_YjZx_5OD=eZr_3+a6LPiAxpj=fowA@mail.gmail.com>
 <20201211102844.13120-1-sjpark@amazon.com>
In-Reply-To: <20201211102844.13120-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Dec 2020 11:41:36 +0100
Message-ID: <CANn89i+P8d8Ok8k1o3_ADW4iWLKU=qikq+RAxmqkYbUn1wkWvQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
To:     SeongJae Park <sjpark@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:33 AM SeongJae Park <sjpark@amazon.com> wrote:
>
> On Fri, 11 Dec 2020 09:43:41 +0100 Eric Dumazet <edumazet@google.com> wrote:
>
> > On Fri, Dec 11, 2020 at 9:21 AM SeongJae Park <sjpark@amazon.com> wrote:
> > >
> > > From: SeongJae Park <sjpark@amazon.de>
> > >
> > > For each 'fqdir_exit()' call, a work for destroy of the 'fqdir' is
> > > enqueued.  The work function, 'fqdir_work_fn()', internally calls
> > > 'rcu_barrier()'.  In case of intensive 'fqdir_exit()' (e.g., frequent
> > > 'unshare()' systemcalls), this increased contention could result in
> > > unacceptably high latency of 'rcu_barrier()'.  This commit avoids such
> > > contention by doing the 'rcu_barrier()' and subsequent lightweight works
> > > in a batched manner using a dedicated singlethread worker, as similar to
> > > that of 'cleanup_net()'.
> >
> >
> > Not sure why you submit a patch series with a single patch.
> >
> > Your cover letter contains interesting info that would better be
> > captured in this changelog IMO
>
> I thought someone might think this is not a kernel issue but the reproducer is
> insane or 'rcu_barrier()' needs modification.  I wanted to do such discussion
> on the coverletter.  Seems I misjudged.  I will make this single patch and move
> the detailed information here from the next version.
>
> >
> > >
> > > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > > ---
> > >  include/net/inet_frag.h  |  1 +
> > >  net/ipv4/inet_fragment.c | 45 +++++++++++++++++++++++++++++++++-------
> > >  2 files changed, 39 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> > > index bac79e817776..48cc5795ceda 100644
> > > --- a/include/net/inet_frag.h
> > > +++ b/include/net/inet_frag.h
> > > @@ -21,6 +21,7 @@ struct fqdir {
> > >         /* Keep atomic mem on separate cachelines in structs that include it */
> > >         atomic_long_t           mem ____cacheline_aligned_in_smp;
> > >         struct work_struct      destroy_work;
> > > +       struct llist_node       free_list;
> > >  };
> > >
> > >  /**
> > > diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> > > index 10d31733297d..a6fc4afcc323 100644
> > > --- a/net/ipv4/inet_fragment.c
> > > +++ b/net/ipv4/inet_fragment.c
> > > @@ -145,12 +145,17 @@ static void inet_frags_free_cb(void *ptr, void *arg)
> > >                 inet_frag_destroy(fq);
> > >  }
> > >
> > > -static void fqdir_work_fn(struct work_struct *work)
> > > +static struct workqueue_struct *fqdir_wq;
> > > +static LLIST_HEAD(free_list);
> > > +
> > > +static void fqdir_free_fn(struct work_struct *work)
> > >  {
> > > -       struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > > -       struct inet_frags *f = fqdir->f;
> > > +       struct llist_node *kill_list;
> > > +       struct fqdir *fqdir, *tmp;
> > > +       struct inet_frags *f;
> > >
> > > -       rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > > +       /* Atomically snapshot the list of fqdirs to free */
> > > +       kill_list = llist_del_all(&free_list);
> > >
> > >         /* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
> > >          * have completed, since they need to dereference fqdir.
> > > @@ -158,12 +163,38 @@ static void fqdir_work_fn(struct work_struct *work)
> > >          */
> > >         rcu_barrier();
> > >
> > > -       if (refcount_dec_and_test(&f->refcnt))
> > > -               complete(&f->completion);
> > > +       llist_for_each_entry_safe(fqdir, tmp, kill_list, free_list) {
> > > +               f = fqdir->f;
> > > +               if (refcount_dec_and_test(&f->refcnt))
> > > +                       complete(&f->completion);
> > >
> > > -       kfree(fqdir);
> > > +               kfree(fqdir);
> > > +       }
> > >  }
> > >
> > > +static DECLARE_WORK(fqdir_free_work, fqdir_free_fn);
> > > +
> > > +static void fqdir_work_fn(struct work_struct *work)
> > > +{
> > > +       struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> > > +
> > > +       rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> > > +
> > > +       if (llist_add(&fqdir->free_list, &free_list))
> > > +               queue_work(fqdir_wq, &fqdir_free_work);
> >
> > I think you misunderstood me.
> >
> > Since this fqdir_free_work will have at most one instance, you can use
> > system_wq here, there is no risk of abuse.
> >
> > My suggestion was to not use system_wq for fqdir_exit(), to better
> > control the number
> >  of threads in rhashtable cleanups.
> >
> > void fqdir_exit(struct fqdir *fqdir)
> > {
> >         INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
> > -       queue_work(system_wq, &fqdir->destroy_work);
> > +      queue_work(fqdir_wq, &fqdir->destroy_work);
> > }
>
> Oh, got it.  I definitely misunderstood.  My fault, sorry.
>
> >
> >
> >
> > > +}
> > > +
> > > +static int __init fqdir_wq_init(void)
> > > +{
> > > +       fqdir_wq = create_singlethread_workqueue("fqdir");
> >
> >
> > And here, I suggest to use a non ordered work queue, allowing one
> > thread per cpu, to allow concurrent rhashtable cleanups
> >
> > Also "fqdir" name is rather vague, this is an implementation detail ?
> >
> > fqdir_wq =create_workqueue("inet_frag_wq");
>
> So, what you are suggesting is to use a dedicated non-ordered work queue
> (fqdir_wq) for rhashtable cleanup and do the remaining works with system_wq in
> the batched manner, right?  IOW, doing below change on top of this patch.
>
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -145,7 +145,7 @@ static void inet_frags_free_cb(void *ptr, void *arg)
>                 inet_frag_destroy(fq);
>  }
>
> -static struct workqueue_struct *fqdir_wq;
> +static struct workqueue_struct *inet_frag_wq;
>  static LLIST_HEAD(free_list);

Nit : Please prefix this free_list , like fqdir_free_list  to avoid
namespace pollution.


>
>  static void fqdir_free_fn(struct work_struct *work)
> @@ -181,14 +181,14 @@ static void fqdir_work_fn(struct work_struct *work)
>         rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
>
>         if (llist_add(&fqdir->free_list, &free_list))
> -               queue_work(fqdir_wq, &fqdir_free_work);
> +               queue_work(system_wq, &fqdir_free_work);
>  }
>
>  static int __init fqdir_wq_init(void)
>  {
> -       fqdir_wq = create_singlethread_workqueue("fqdir");
> -       if (!fqdir_wq)
> -               panic("Could not create fqdir workq");
> +       inet_frag_wq = create_workqueue("inet_frag_wq");
> +       if (!inet_frag_wq)
> +               panic("Could not create inet frag workq");
>         return 0;
>  }
>
> @@ -218,7 +218,7 @@ EXPORT_SYMBOL(fqdir_init);
>  void fqdir_exit(struct fqdir *fqdir)
>  {
>         INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
> -       queue_work(system_wq, &fqdir->destroy_work);
> +       queue_work(inet_frag_wq, &fqdir->destroy_work);
>  }
>  EXPORT_SYMBOL(fqdir_exit);
>
> If I'm still misunderstanding, please let me know.
>

I think that with the above changes, we should be good ;)

Thanks !
