Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89A6380C2
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 22:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKXV6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 16:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKXV6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 16:58:15 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D7724BE3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 13:58:13 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 1so3081282ybl.7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 13:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zXhZqtO6lmIiHIHV8f5T6mf313QipbdR7t/SZwwhSGs=;
        b=PLhCWZQLKY83x+x1NvhLjNu2b1j+lLVrT6RTBb8aAcbjIGFdK4H4zGv4pm20WBCK0k
         znGBxCj8I0PnWjv4F8B3X4ke8pfGtNPwA4DQcw0IA+heSGMLVlyYx8bg+XxP1JI0ii/a
         mYHBaAx6cPsXxb0j5M4QbbpgR5XcVwZDbSMjuilyz02ovLwNBX6X1MCNW01my8BAqnxX
         kf84bDA8cQd0ct0TAUccoh9psThc+wggJ2JylMYakfHx5p7m4Z9beZTHSFpzBtkVjNBi
         upESZ2JvNgQoUnZdS+gziy4Uv88WVJVXGk9u+9ahKUNmdfNVdVEHx1MQUCH8/BBI1OoJ
         Gziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zXhZqtO6lmIiHIHV8f5T6mf313QipbdR7t/SZwwhSGs=;
        b=aftVQSAS8y0Y3M7wM2S5x3ERbtVCk3Q9wIRnP64XJDc9+RJoZluhQBLDL8/v08bz+F
         nkKklL+eSCax3eIkorw6v+IfIngIScE6z8EDcVm9igsoFFg1C4enT4geOMiA93KLxxiw
         zXhSSBgCEw/Bd5BkobsMhL1/2CEBUBDG0+eYB4YzKqQLPZ9iZ09ePMX6fL740vmyhZHA
         dYFIkVtQyuIRQbl5WshXOntPxohM8XdVqVn8LSRnlYA0d7eB4V/kGh3uydxJwcQ/PUJe
         HAmwYfmFMkZbwUoewKd1CC/1c+R1udm6ZhtN9ZgQCi66yUQXGiQV27YXHGciz+gvQHVJ
         2EQA==
X-Gm-Message-State: ANoB5pm87j4fD3S55C1qGnhCJD8ac5rn5mlSx9FGtoRLB0V6KPTk+C5R
        yoL7QK5jBzxdExU6aflA2mauDWHl9ZD5khNOZRd9cQ==
X-Google-Smtp-Source: AA0mqf4v4BJ+xjKLnh6guvzMw+k9VTSwxVbgu3o0/W3JEcFF4+NwS0u/X/LiF/D+gwBVw8fnnmQOaXFlPs+cnCPQFhw=
X-Received: by 2002:a05:6902:118e:b0:6e7:f54:b3d6 with SMTP id
 m14-20020a056902118e00b006e70f54b3d6mr16038223ybu.577.1669327092174; Thu, 24
 Nov 2022 13:58:12 -0800 (PST)
MIME-Version: 1.0
References: <f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com>
In-Reply-To: <f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 24 Nov 2022 16:57:36 -0500
Message-ID: <CACSApvZ3H95eLbj0xS2kBdZb5d38UmrDW7EGUNbBb8ZbWSBHYw@mail.gmail.com>
Subject: Re: [PATCH v2] epoll: use refcount to reduce ep_mutex contention
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 12:58 PM Paolo Abeni <pabeni@redhat.com> wrote:
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
>
> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the nice optimization!

> ---
> v2:
>  - introduce and use an helper for callers owning additional ep
> references
>  - move the 'refcount' field before the conditional section of
> struct eventpoll
>
> v1 at:
> https://lore.kernel.org/linux-fsdevel/CACSApvaMCeKLn88uNAWOxrzPWC9Rr2BZLa3--6TQuY6toYZdOg@mail.gmail.com/
>
> Previous related effort at:
> https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-cj.chengjian@huawei.com/
> https://lkml.org/lkml/2017/10/28/81
> ---
>  fs/eventpoll.c | 125 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 74 insertions(+), 51 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 52954d4637b5..0a1383b19ed9 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -217,6 +217,12 @@ struct eventpoll {
>         u64 gen;
>         struct hlist_head refs;
>
> +       /*
> +        * protected by mtx, used to avoid races between ep_free() and
> +        * ep_eventpoll_release()
> +        */
> +       unsigned int refcount;
> +
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>         /* used to track busy poll napi_id */
>         unsigned int napi_id;
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
> @@ -731,28 +759,28 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>         call_rcu(&epi->rcu, epi_rcu_free);
>
>         percpu_counter_dec(&ep->user->epoll_watches);
> +       return ep_put(ep);
> +}
>
> -       return 0;
> +/*
> + * ep_remove variant for callers owing an additional reference to the ep
> + */
> +static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
> +{
> +       WARN_ON_ONCE(ep_remove(ep, epi));
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
> @@ -765,26 +793,14 @@ static void ep_free(struct eventpoll *ep)
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
> @@ -905,6 +921,7 @@ void eventpoll_release_file(struct file *file)
>         struct eventpoll *ep;
>         struct epitem *epi;
>         struct hlist_node *next;
> +       bool dispose;
>
>         /*
>          * We don't want to get "file->f_lock" because it is not
> @@ -912,25 +929,18 @@ void eventpoll_release_file(struct file *file)
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
> @@ -953,6 +963,7 @@ static int ep_alloc(struct eventpoll **pep)
>         ep->rbr = RB_ROOT_CACHED;
>         ep->ovflist = EP_UNACTIVE_PTR;
>         ep->user = user;
> +       ep->refcount = 1;
>
>         *pep = ep;
>
> @@ -1494,16 +1505,22 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
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
> -               ep_remove(ep, epi);
> +               ep_remove_safe(ep, epi);
>                 return -EINVAL;
>         }
>
>         if (epi->event.events & EPOLLWAKEUP) {
>                 error = ep_create_wakeup_source(epi);
>                 if (error) {
> -                       ep_remove(ep, epi);
> +                       ep_remove_safe(ep, epi);
>                         return error;
>                 }
>         }
> @@ -1527,7 +1544,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
>          * high memory pressure.
>          */
>         if (unlikely(!epq.epi)) {
> -               ep_remove(ep, epi);
> +               ep_remove_safe(ep, epi);
>                 return -ENOMEM;
>         }
>
> @@ -2165,10 +2182,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
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
> +                       ep_remove_safe(ep, epi);
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
