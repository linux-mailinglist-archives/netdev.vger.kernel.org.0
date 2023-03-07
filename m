Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A636AF7A4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCGVbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCGVbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECD5849A;
        Tue,  7 Mar 2023 13:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536956154D;
        Tue,  7 Mar 2023 21:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B47BC433EF;
        Tue,  7 Mar 2023 21:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678224658;
        bh=36o8AruU3hfc6QJy9oCEJc8TPiLr1A1Cs5VTFOz0r/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z+0VYs5E+j+bwhNXvsF9KnrZW3kmEeK3/rYutKZKZumj7/nKcfFNYAIyIe90j0jxh
         cN4JRWfZE9vH4OVaghpmbPPHKe7NAqsgFTgjoHF7EdJ8t7BfbaU+824eTt2/mdIbFk
         ZfEP+s7JSoTDg3NH9kwSGPQVwxQb8oiVIvvyuUYo=
Date:   Tue, 7 Mar 2023 13:30:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
Message-Id: <20230307133057.1904d8ffab2980f8e23ee3cc@linux-foundation.org>
In-Reply-To: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
References: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 19:46:37 +0100 Paolo Abeni <pabeni@redhat.com> wrote:

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
> Additionally, this introduces a new 'dying' flag to prevent races between
> the EP file close() and the monitored file close().
> ep_eventpoll_release() marks, under f_lock spinlock, each epitem as before

"as dying"?

> removing it, while EP file close() does not touch dying epitems.

The need for this dying flag is somewhat unclear to me.  I mean, if we
have refcounting done correctly, why the need for this flag?  Some
additional description of the dynamics would be helpful.

Methinks this flag is here to cope with the delayed freeing via
hlist_del_rcu(), but that's a guess?

> The eventpoll struct is released by whoever - among EP file close() and
> and the monitored file close() drops its last reference.
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
> ...
>
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
>
> ...
>
> +	free_uid(ep->user);
> +	wakeup_source_unregister(ep->ws);
> +	kfree(ep);
> +}
> +
>  /*
>   * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>   * all the associated resources. Must be called with "mtx" held.
> + * If the dying flag is set, do the removal only if force is true.

This comment describes "what" the code does, which is obvious from the
code anwyay.  It's better if comments describe "why" the code does what
it does.

> + * Returns true if the eventpoll can be disposed.
>   */
> -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> +static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
>  {
>  	struct file *file = epi->ffd.file;
>  	struct epitems_head *to_free;
>
> ...
>
>  	/*
> -	 * We don't want to get "file->f_lock" because it is not
> -	 * necessary. It is not necessary because we're in the "struct file"
> -	 * cleanup path, and this means that no one is using this file anymore.
> -	 * So, for example, epoll_ctl() cannot hit here since if we reach this
> -	 * point, the file counter already went to zero and fget() would fail.
> -	 * The only hit might come from ep_free() but by holding the mutex
> -	 * will correctly serialize the operation. We do need to acquire
> -	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
> -	 * from anywhere but ep_free().
> -	 *
> -	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
> +	 * Use the 'dying' flag to prevent a concurrent ep_cleat_and_put() from

s/cleat/clear/

> +	 * touching the epitems list before eventpoll_release_file() can access
> +	 * the ep->mtx.
>  	 */
> -	mutex_lock(&epmutex);
> -	if (unlikely(!file->f_ep)) {
> -		mutex_unlock(&epmutex);
> -		return;
> -	}
> -	hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
> +again:
> +	spin_lock(&file->f_lock);
> +	if (file->f_ep && file->f_ep->first) {
> +		/* detach from ep tree */

Comment appears to be misplaced - the following code doesn't detach
anything?

> +		epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
> +		epi->dying = true;
> +		spin_unlock(&file->f_lock);
> +
> +		/*
> +		 * ep access is safe as we still own a reference to the ep
> +		 * struct
> +		 */
>  		ep = epi->ep;
> -		mutex_lock_nested(&ep->mtx, 0);
> -		ep_remove(ep, epi);
> +		mutex_lock(&ep->mtx);
> +		dispose = __ep_remove(ep, epi, true);
>  		mutex_unlock(&ep->mtx);
> +
> +		if (dispose)
> +			ep_free(ep);
> +		goto again;
>  	}
> ...
>
