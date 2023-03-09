Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090226B22B3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCILWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCILWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:22:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A0DDF34;
        Thu,  9 Mar 2023 03:18:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E14B81EE3;
        Thu,  9 Mar 2023 11:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F9FC433EF;
        Thu,  9 Mar 2023 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678360688;
        bh=HZ223M8cnHrjBGIpobPcXc4CwG9s1VHSbiqCjj8QMGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HO6PRo+Fz5z9H8ej/B+YZmCOtLfgNYpM7FJMO4GpWs1GpYZ/2PoUe7SM3oLWXSZqi
         vXMXcp4ZiwG5kw4+pqzedAnFjKXgWEhPcrL3zYxOCxM4ZGz/bfSPepb/hTYeZKkm5J
         VF2RvbkklHbiJ/aEXEP0sltv2mXHxjezxn9LLm2QwG/f/dXblvHM6Jko1jHbrYR/ef
         1AFNGcW5uScLyQB4kcLOZsnqm+BMFqsEIFGv0ZQXN/3AN/W5ouP6iy0YQirC1aUEDj
         jD9ogLgPm4hD38Q72F4QgSs3ky2TqKAsh5xg6jAUxnkvDqiORmFyLkhPp/+RH/Sd6F
         szFKoNFCTeAzA==
Date:   Thu, 9 Mar 2023 12:18:03 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] epoll: use refcount to reduce ep_mutex contention
Message-ID: <20230309111803.2z242amw4f5nwfwu@wittgenstein>
References: <323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:51:31PM +0100, Paolo Abeni wrote:
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
> and references are released at ep_remove() time.
> 
> The eventpoll struct is released by whoever - among EP file close() and
> and the monitored file close() drops its last reference.
> 
> Additionally, this introduces a new 'dying' flag to prevent races between
> the EP file close() and the monitored file close().
> ep_eventpoll_release() marks, under f_lock spinlock, each epitem as dying
> before removing it, while EP file close() does not touch dying epitems.
> 
> The above is needed as both close operations could run concurrently and
> drop the EP reference acquired via the epitem entry. Without the above
> flag, the monitored file close() could reach the EP struct via the epitem
> list while the epitem is still listed and then try to put it after its
> disposal.
> 
> An alternative could be avoiding touching the references acquired via
> the epitems at EP file close() time, but that could leave the EP struct
> alive for potentially unlimited time after EP file close(), with nasty
> side effects.
> 
> With all the above in place, we can drop the epmutex usage at disposal time.
> 
> Overall this produces a significant performance improvement in the
> mentioned connection/rate scenario: the mutex operations disappear from
> the topmost offenders in the perf report, and the measured connections/rate
> grows by ~60%.
> 
> To make the change more readable this additionally renames ep_free() to
> ep_clear_and_put(), and moves the actual memory cleanup in a separate
> ep_free() helper.
> 
> Tested-by: Xiumei Mu <xmu@redhiat.com>

Is that a typo "redhiat" in the mail?

> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> This revision does not introduce any code change, it hopefully
> clarifies the 'dying' flag role and a few comments, as per Andrew
> suggestion.
> 
>     v4 repost at:
>     https://lore.kernel.org/linux-fsdevel/f0c49fb4b682b81d64184d1181bc960728907474.camel@redhat.com/T/#t
> 
>     v4 at:
>     https://lore.kernel.org/linux-fsdevel/9d8ad7995e51ad3aecdfe6f7f9e72231b8c9d3b5.1671569682.git.pabeni@redhat.com/
> 
>     v3 at:
>     https://lore.kernel.org/linux-fsdevel/1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com/
> 
>     v2 at:
>     https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/
> 
>     v1 at:
>     https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/
> 
>     Previous related effort at:
>     https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-cj.chengjian@huawei.com/
>     https://lkml.org/lkml/2017/10/28/81
> ---
>  fs/eventpoll.c | 186 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 117 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 64659b110973..2b01fc05c307 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -57,13 +57,7 @@
>   * we need a lock that will allow us to sleep. This lock is a
>   * mutex (ep->mtx). It is acquired during the event transfer loop,
>   * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
> - * Then we also need a global mutex to serialize eventpoll_release_file()
> - * and ep_free().
> - * This mutex is acquired by ep_free() during the epoll file
> - * cleanup path and it is also acquired by eventpoll_release_file()
> - * if a file has been pushed inside an epoll set and it is then
> - * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
> - * It is also acquired when inserting an epoll fd onto another epoll
> + * The epmutex is acquired when inserting an epoll fd onto another epoll
>   * fd. We do this so that we walk the epoll tree and ensure that this
>   * insertion does not create a cycle of epoll file descriptors, which
>   * could lead to deadlock. We need a global mutex to prevent two
> @@ -153,6 +147,13 @@ struct epitem {
>  	/* The file descriptor information this item refers to */
>  	struct epoll_filefd ffd;
>  
> +	/*
> +	 * Protected by file->f_lock, true for to-be-released epitem already
> +	 * removed from the "struct file" items list; together with
> +	 * eventpoll->refcount orchestrates "struct eventpoll" disposal
> +	 */
> +	bool dying;
> +
>  	/* List containing poll wait queues */
>  	struct eppoll_entry *pwqlist;
>  
> @@ -217,6 +218,12 @@ struct eventpoll {
>  	u64 gen;
>  	struct hlist_head refs;
>  
> +	/*
> +	 * usage count, used together with epitem->dying to
> +	 * orchestrate the disposal of this struct
> +	 */
> +	refcount_t refcount;
> +
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  	/* used to track busy poll napi_id */
>  	unsigned int napi_id;
> @@ -240,9 +247,7 @@ struct ep_pqueue {
>  /* Maximum number of epoll watched descriptors, per user */
>  static long max_user_watches __read_mostly;
>  
> -/*
> - * This mutex is used to serialize ep_free() and eventpoll_release_file().
> - */
> +/* Used for cycles detection */
>  static DEFINE_MUTEX(epmutex);
>  
>  static u64 loop_check_gen = 0;
> @@ -557,8 +562,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
>  
>  /*
>   * This function unregisters poll callbacks from the associated file
> - * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
> - * ep_free).
> + * descriptor.  Must be called with "mtx" held.
>   */
>  static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
>  {
> @@ -681,11 +685,40 @@ static void epi_rcu_free(struct rcu_head *head)
>  	kmem_cache_free(epi_cache, epi);
>  }
>  
> +static void ep_get(struct eventpoll *ep)
> +{
> +	refcount_inc(&ep->refcount);
> +}
> +
> +/*
> + * Returns true if the event poll can be disposed
> + */
> +static bool ep_refcount_dec_and_test(struct eventpoll *ep)
> +{
> +	if (!refcount_dec_and_test(&ep->refcount))
> +		return false;
> +
> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
> +	return true;
> +}
> +
> +static void ep_free(struct eventpoll *ep)
> +{
> +	mutex_destroy(&ep->mtx);
> +	free_uid(ep->user);
> +	wakeup_source_unregister(ep->ws);
> +	kfree(ep);
> +}
> +
>  /*
>   * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>   * all the associated resources. Must be called with "mtx" held.
> + * If the dying flag is set, do the removal only if force is true.
> + * This prevents ep_clear_and_put() from dropping all the ep references
> + * while running concurrently with eventpoll_release_file().
> + * Returns true if the eventpoll can be disposed.
>   */
> -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> +static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
>  {
>  	struct file *file = epi->ffd.file;
>  	struct epitems_head *to_free;
> @@ -700,6 +733,11 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>  
>  	/* Remove the current item from the list of epoll hooks */
>  	spin_lock(&file->f_lock);
> +	if (epi->dying && !force) {
> +		spin_unlock(&file->f_lock);
> +		return false;
> +	}

It's a bit unfortunate that we have to acquire the spinlock just to immediately
having to drop it. Slighly ugly but workable could be but that depends on how
likely we find it that we end up with !force and a dying fd...

completely untested:

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 2b01fc05c307..1e1eff049174 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -731,6 +731,10 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
         */
        ep_unregister_pollwait(ep, epi);

+       /* racy check to avoid having to acquire the spinlock */
+       if (!force && READ_ONCE(epi->dying) == true)
+               return false;
+
        /* Remove the current item from the list of epoll hooks */
        spin_lock(&file->f_lock);
        if (epi->dying && !force) {
@@ -951,7 +955,7 @@ void eventpoll_release_file(struct file *file)
        spin_lock(&file->f_lock);
        if (file->f_ep && file->f_ep->first) {
                epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
-               epi->dying = true;
+               WRITE_ONCE(epi->dying, true);
                spin_unlock(&file->f_lock);

                /*

?
