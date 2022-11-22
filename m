Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B5F63414E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiKVQU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiKVQUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:20:39 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B7F742F7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:18:43 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id n189so5451292yba.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wVB2KVTaMDERLhDjtduFCPu4liW3TCS04xmE59bUWJA=;
        b=c9huGcbU6Xlw/LZZ4ATcsjVRzaYy5/FNeWrVX6sj4nCwjyPnHvMC29v146W+dOftvy
         +UMvrOl/WXcn35PtduMkqhAVrWU+81OQ+MODz3b+SHUrfKub0LWBaeUmV5evt4I35vHX
         1r5a2+n+Vad7t4U6SMTTAu1C2MU9Id3PoId9PxKf8jur5pdTdNhKr88clMuWhQCoPczX
         bMTcyxRdJ/wZ6WEnHT8glf9151bKWMqvUoaMyUuQw0TFCB+KlF+lGSRq/PG0dEg9Ji5V
         ir2LR4QFP7rRLy51q2bwA/b7tPNPqFJMJAZB9cpirr9egdzphAhoSyIg9hisJTSj46Uv
         r2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVB2KVTaMDERLhDjtduFCPu4liW3TCS04xmE59bUWJA=;
        b=i/+DW17lZm/Jn7f/lezG12u0fFdUHMeUghSjux6jDPzj5HI0EX5zDMp9eKjZE3nk6Q
         UPrsx3mAvaib9gWmTn/TFJI8iOrCkDUH6cBtL1opBaqgselrGte9uP3H4Cn0+tAW0w35
         CBpKwW+/XJnsklX0w6icM8yUpFSjzs8L5CnAxiX0prTHWUDExbljwljkZKn9q8OsiVk7
         ckaHTJkhsTbkFnGoXyZU6XO1KQf6OsM/wjupbXD3mxMy1v7R2L6424YhtNNq6nz5R53j
         m/KYPFO/dSrvsWkSNWqAHvNcMnsL46xDC/HEs4+HcTNsa2ZlogilqcjLFesszqSR7JXZ
         iqtQ==
X-Gm-Message-State: ANoB5pnpe5YGowkJ1DFahYFfs8yGDAqZkkUU1p/721OLWAv6LbWzvz29
        85+eSMDzt6yKnLweiQNywFAQDjW1HZS/9CqfPOelWg==
X-Google-Smtp-Source: AA0mqf6iNqOh9F3cgMAu3OxmC3uGf0VtnH0289nCSF04tDb+KA0RGqgAssQNR0DteUsbajvr30uRDDTPlxQTYsOkXVs=
X-Received: by 2002:a25:9343:0:b0:6cf:f7c8:7340 with SMTP id
 g3-20020a259343000000b006cff7c87340mr7920681ybo.83.1669133922189; Tue, 22 Nov
 2022 08:18:42 -0800 (PST)
MIME-Version: 1.0
References: <e102081e103d897cc0b76908acdac1bf0b65050d.1669130955.git.pabeni@redhat.com>
In-Reply-To: <e102081e103d897cc0b76908acdac1bf0b65050d.1669130955.git.pabeni@redhat.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 22 Nov 2022 11:18:05 -0500
Message-ID: <CACSApvYq=r3YAyZ_XceoRz1BuU+Q+MypXaG_S1fMoYCyFEpbrw@mail.gmail.com>
Subject: Re: [REPOST PATCH] epoll: use refcount to reduce ep_mutex contention
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:43 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> We are observing huge contention on the epmutex during an http
> connection/rate test:
>
>  83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
> [...]
>            |--66.96%--__fput
>                       |--60.04%--eventpoll_release_file
>                                  |--58.41%--__mutex_lock.isra.6
>                                            |--56.56%--osq_lock
>
> The application is multi-threaded, creates a new epoll entry for
> each incoming connection, and does not delete it before the
> connection shutdown - that is, before the connection's fd close().
>
> Many different threads compete frequently for the epmutex lock,
> affecting the overall performance.
>
> To reduce the contention this patch introduces explicit reference counting
> for the eventpoll struct. Each registered event acquires a reference,
> and references are released at ep_remove() time. ep_free() doesn't touch
> anymore the event RB tree, it just unregisters the existing callbacks
> and drops a reference to the ep struct. The struct itself is freed when
> the reference count reaches 0. The reference count updates are protected
> by the mtx mutex so no additional atomic operations are needed.
>
> Since ep_free() can't compete anymore with eventpoll_release_file()
> for epitems removal, we can drop the epmutex usage at disposal time.
>
> With the patched kernel, in the same connection/rate scenario, the mutex
> operations disappear from the perf report, and the measured connections/rate
> grows by ~60%.

I locally tried this patch and I can reproduce the results.  Thank you
for the nice optimization!

> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> This is just a repost reaching out for more recipents,
> as suggested by Carlos.
>
> Previous post at:
>
> https://lore.kernel.org/linux-fsdevel/20221122102726.4jremle54zpcapia@andromeda/T/#m6f98d4ccbe0a385d10c04fd4018e782b793944e6
> ---
>  fs/eventpoll.c | 113 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 64 insertions(+), 49 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 52954d4637b5..6e415287aeb8 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -226,6 +226,12 @@ struct eventpoll {
>         /* tracks wakeup nests for lockdep validation */
>         u8 nests;
>  #endif
> +
> +       /*
> +        * protected by mtx, used to avoid races between ep_free() and
> +        * ep_eventpoll_release()
> +        */
> +       unsigned int refcount;

nitpick: Given that napi_id and nest are both macro protected, you
might want to pull it right after min_wait_ts.

>  };
>
>  /* Wrapper struct used by poll queueing */
> @@ -240,9 +246,6 @@ struct ep_pqueue {
>  /* Maximum number of epoll watched descriptors, per user */
>  static long max_user_watches __read_mostly;
>
> -/*
> - * This mutex is used to serialize ep_free() and eventpoll_release_file().
> - */
>  static DEFINE_MUTEX(epmutex);
>
>  static u64 loop_check_gen = 0;
> @@ -555,8 +558,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
>
>  /*
>   * This function unregisters poll callbacks from the associated file
> - * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
> - * ep_free).
> + * descriptor.  Must be called with "mtx" held.
>   */
>  static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
>  {
> @@ -679,11 +681,37 @@ static void epi_rcu_free(struct rcu_head *head)
>         kmem_cache_free(epi_cache, epi);
>  }
>
> +static void ep_get(struct eventpoll *ep)
> +{
> +       ep->refcount++;
> +}
> +
> +/*
> + * Returns true if the event poll can be disposed
> + */
> +static bool ep_put(struct eventpoll *ep)
> +{
> +       if (--ep->refcount)
> +               return false;
> +
> +       WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
> +       return true;
> +}
> +
> +static void ep_dispose(struct eventpoll *ep)
> +{
> +       mutex_destroy(&ep->mtx);
> +       free_uid(ep->user);
> +       wakeup_source_unregister(ep->ws);
> +       kfree(ep);
> +}
> +
>  /*
>   * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>   * all the associated resources. Must be called with "mtx" held.
> + * Returns true if the eventpoll can be disposed.
>   */
> -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> +static bool ep_remove(struct eventpoll *ep, struct epitem *epi)
>  {
>         struct file *file = epi->ffd.file;
>         struct epitems_head *to_free;
> @@ -731,28 +759,20 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>         call_rcu(&epi->rcu, epi_rcu_free);
>
>         percpu_counter_dec(&ep->user->epoll_watches);
> -
> -       return 0;
> +       return ep_put(ep);
>  }
>
>  static void ep_free(struct eventpoll *ep)
>  {
>         struct rb_node *rbp;
>         struct epitem *epi;
> +       bool dispose;
>
>         /* We need to release all tasks waiting for these file */
>         if (waitqueue_active(&ep->poll_wait))
>                 ep_poll_safewake(ep, NULL);
>
> -       /*
> -        * We need to lock this because we could be hit by
> -        * eventpoll_release_file() while we're freeing the "struct eventpoll".
> -        * We do not need to hold "ep->mtx" here because the epoll file
> -        * is on the way to be removed and no one has references to it
> -        * anymore. The only hit might come from eventpoll_release_file() but
> -        * holding "epmutex" is sufficient here.
> -        */
> -       mutex_lock(&epmutex);
> +       mutex_lock(&ep->mtx);
>
>         /*
>          * Walks through the whole tree by unregistering poll callbacks.
> @@ -765,26 +785,14 @@ static void ep_free(struct eventpoll *ep)
>         }
>
>         /*
> -        * Walks through the whole tree by freeing each "struct epitem". At this
> -        * point we are sure no poll callbacks will be lingering around, and also by
> -        * holding "epmutex" we can be sure that no file cleanup code will hit
> -        * us during this operation. So we can avoid the lock on "ep->lock".
> -        * We do not need to lock ep->mtx, either, we only do it to prevent
> -        * a lockdep warning.
> +        * epitems in the rb tree are freed either with EPOLL_CTL_DEL
> +        * or at the relevant file close time by eventpoll_release_file()
>          */
> -       mutex_lock(&ep->mtx);
> -       while ((rbp = rb_first_cached(&ep->rbr)) != NULL) {
> -               epi = rb_entry(rbp, struct epitem, rbn);
> -               ep_remove(ep, epi);
> -               cond_resched();
> -       }
> +       dispose = ep_put(ep);
>         mutex_unlock(&ep->mtx);
>
> -       mutex_unlock(&epmutex);
> -       mutex_destroy(&ep->mtx);
> -       free_uid(ep->user);
> -       wakeup_source_unregister(ep->ws);
> -       kfree(ep);
> +       if (dispose)
> +               ep_dispose(ep);
>  }
>
>  static int ep_eventpoll_release(struct inode *inode, struct file *file)
> @@ -905,6 +913,7 @@ void eventpoll_release_file(struct file *file)
>         struct eventpoll *ep;
>         struct epitem *epi;
>         struct hlist_node *next;
> +       bool dispose;
>
>         /*
>          * We don't want to get "file->f_lock" because it is not
> @@ -912,25 +921,18 @@ void eventpoll_release_file(struct file *file)
>          * cleanup path, and this means that no one is using this file anymore.
>          * So, for example, epoll_ctl() cannot hit here since if we reach this
>          * point, the file counter already went to zero and fget() would fail.
> -        * The only hit might come from ep_free() but by holding the mutex
> -        * will correctly serialize the operation. We do need to acquire
> -        * "ep->mtx" after "epmutex" because ep_remove() requires it when called
> -        * from anywhere but ep_free().
>          *
>          * Besides, ep_remove() acquires the lock, so we can't hold it here.
>          */
> -       mutex_lock(&epmutex);
> -       if (unlikely(!file->f_ep)) {
> -               mutex_unlock(&epmutex);
> -               return;
> -       }
>         hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
>                 ep = epi->ep;
> -               mutex_lock_nested(&ep->mtx, 0);
> -               ep_remove(ep, epi);
> +               mutex_lock(&ep->mtx);
> +               dispose = ep_remove(ep, epi);
>                 mutex_unlock(&ep->mtx);
> +
> +               if (dispose)
> +                       ep_dispose(ep);
>         }
> -       mutex_unlock(&epmutex);
>  }
>
>  static int ep_alloc(struct eventpoll **pep)
> @@ -953,6 +955,7 @@ static int ep_alloc(struct eventpoll **pep)
>         ep->rbr = RB_ROOT_CACHED;
>         ep->ovflist = EP_UNACTIVE_PTR;
>         ep->user = user;
> +       ep->refcount = 1;
>
>         *pep = ep;
>
> @@ -1494,6 +1497,12 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
>         if (tep)
>                 mutex_unlock(&tep->mtx);
>
> +       /*
> +        * ep_remove() calls in the later error paths can't lead to ep_dispose()
> +        * as overall will lead to no refcount changes
> +        */
> +       ep_get(ep);
> +
>         /* now check if we've created too many backpaths */
>         if (unlikely(full_check && reverse_path_check())) {
>                 ep_remove(ep, epi);
> @@ -2165,10 +2174,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
>                         error = -EEXIST;
>                 break;
>         case EPOLL_CTL_DEL:
> -               if (epi)
> -                       error = ep_remove(ep, epi);
> -               else
> +               if (epi) {
> +                       /*
> +                        * The eventpoll itself is still alive: the refcount
> +                        * can't go to zero here.
> +                        */
> +                       WARN_ON_ONCE(ep_remove(ep, epi));

There are similar examples of calling ep_remove() without checking the
return value in ep_insert().

I believe we should add a similar comment there, and maybe a
WARN_ON_ONCE.  I'm not sure, but it might be worth adding a new helper
given this repeated pattern?


> +                       error = 0;
> +               } else {
>                         error = -ENOENT;
> +               }
>                 break;
>         case EPOLL_CTL_MOD:
>                 if (epi) {
> --
> 2.38.1
>
