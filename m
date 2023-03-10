Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCA56B397B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjCJJCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCJJBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:01:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9AA110537;
        Fri, 10 Mar 2023 00:55:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF4B6115C;
        Fri, 10 Mar 2023 08:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E9BC433EF;
        Fri, 10 Mar 2023 08:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678438533;
        bh=AyDHsHcaeFxIsFdxmIlVycwGMhNgoSvd8Vb6XkDH0V4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cRnutpYeVCGD23q/4kXuS+FKKdtfzGjOzAGhW5IVBbbN7HZbnNbYIrIWldg3nylO1
         CuWhLptegTC+YSj0Dc/oXdH1wd6R56oR2zQK0fP8B2fC3phqZMpyInJbOzar22+tkZ
         PUFMNJAliIkcXqexcuB5j3azhGNIDIROpsekVk7wB/ZlnVONvZMHMTiOXyGX+QY1fO
         x6OjWfbGHA9CdzRY4PHehEVTM199maEYyfgpER2CmR7i4Mxv3LNwT1cU8i+FQL1c1k
         bU3jfFuyA34pDIYGsFrqmhd/EJWUMUVPzaRjcFwtVvETADyGrOB/5DV7ncUOS2DYDG
         iXboZTW33KMuA==
Date:   Fri, 10 Mar 2023 09:55:27 +0100
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
Message-ID: <20230310085527.mxezm3qzytet2duu@wittgenstein>
References: <323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com>
 <20230309111803.2z242amw4f5nwfwu@wittgenstein>
 <5de48abb24e033a5eb457007d0a5b6b391831fd4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5de48abb24e033a5eb457007d0a5b6b391831fd4.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:47:23PM +0100, Paolo Abeni wrote:
> On Thu, 2023-03-09 at 12:18 +0100, Christian Brauner wrote:
> > On Wed, Mar 08, 2023 at 10:51:31PM +0100, Paolo Abeni wrote:
> > > We are observing huge contention on the epmutex during an http
> > > connection/rate test:
> > > 
> > >  83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
> > > [...]
> > >            |--66.96%--__fput
> > >                       |--60.04%--eventpoll_release_file
> > >                                  |--58.41%--__mutex_lock.isra.6
> > >                                            |--56.56%--osq_lock
> > > 
> > > The application is multi-threaded, creates a new epoll entry for
> > > each incoming connection, and does not delete it before the
> > > connection shutdown - that is, before the connection's fd close().
> > > 
> > > Many different threads compete frequently for the epmutex lock,
> > > affecting the overall performance.
> > > 
> > > To reduce the contention this patch introduces explicit reference counting
> > > for the eventpoll struct. Each registered event acquires a reference,
> > > and references are released at ep_remove() time.
> > > 
> > > The eventpoll struct is released by whoever - among EP file close() and
> > > and the monitored file close() drops its last reference.
> > > 
> > > Additionally, this introduces a new 'dying' flag to prevent races between
> > > the EP file close() and the monitored file close().
> > > ep_eventpoll_release() marks, under f_lock spinlock, each epitem as dying
> > > before removing it, while EP file close() does not touch dying epitems.
> > > 
> > > The above is needed as both close operations could run concurrently and
> > > drop the EP reference acquired via the epitem entry. Without the above
> > > flag, the monitored file close() could reach the EP struct via the epitem
> > > list while the epitem is still listed and then try to put it after its
> > > disposal.
> > > 
> > > An alternative could be avoiding touching the references acquired via
> > > the epitems at EP file close() time, but that could leave the EP struct
> > > alive for potentially unlimited time after EP file close(), with nasty
> > > side effects.
> > > 
> > > With all the above in place, we can drop the epmutex usage at disposal time.
> > > 
> > > Overall this produces a significant performance improvement in the
> > > mentioned connection/rate scenario: the mutex operations disappear from
> > > the topmost offenders in the perf report, and the measured connections/rate
> > > grows by ~60%.
> > > 
> > > To make the change more readable this additionally renames ep_free() to
> > > ep_clear_and_put(), and moves the actual memory cleanup in a separate
> > > ep_free() helper.
> > > 
> > > Tested-by: Xiumei Mu <xmu@redhiat.com>
> > 
> > Is that a typo "redhiat" in the mail?
> 
> Indeed yes! Thanks for noticing. Should I share a new revision to
> address that?

No, I think we can just fix that up...
