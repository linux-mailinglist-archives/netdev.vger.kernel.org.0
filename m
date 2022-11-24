Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD7638148
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 00:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKXXCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 18:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXXCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 18:02:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C5F026;
        Thu, 24 Nov 2022 15:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCBF62273;
        Thu, 24 Nov 2022 23:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D59EC433D6;
        Thu, 24 Nov 2022 23:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669330967;
        bh=pGxiDuHGJOoJ80vUsLcUHg+/zk+VDTA69PRsOM9fD+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kq8C+kajkupXyMH+CCDjSG6fUOUpsbW3tNykckiFQAd+g4UW0uiuILSwGIfaGx9V+
         lKPjPKy/++EqdXZZQf0NsVunyNSSb+sdZhxe+hpLWkSUEfXkPTlfpMcbRylBGsj35M
         MaNe6l13qA868mk5Pb3AgUPT+S2RQe7AsRebuciG7gfs/0e494QtexB9UOaG4te26q
         mUh2aPGsWBnMcE+oyo9Bqe6V6JoqmJmMLMjmQa8HKjBBtZ/dOPEo4xwbcrwYkaT3cx
         JJJL21Iauk6B/ZOuwI3Ax0vL3z60qFLywigwhM+EKehdPV83+28sFRM3rb0CBF2yFN
         1NpmvuGLSUlhQ==
Date:   Thu, 24 Nov 2022 15:02:45 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] epoll: use refcount to reduce ep_mutex contention
Message-ID: <Y3/4FW4mqY3fWRfU@sol.localdomain>
References: <f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 06:57:41PM +0100, Paolo Abeni wrote:
> To reduce the contention this patch introduces explicit reference counting
> for the eventpoll struct. Each registered event acquires a reference,
> and references are released at ep_remove() time. ep_free() doesn't touch
> anymore the event RB tree, it just unregisters the existing callbacks
> and drops a reference to the ep struct. The struct itself is freed when
> the reference count reaches 0. The reference count updates are protected
> by the mtx mutex so no additional atomic operations are needed.

So, the behavior before this patch is that closing an epoll file frees all
resources associated with it.  This behavior is documented in the man page
epoll_create(2): "When all file descriptors referring to an epoll instance have
been closed, the kernel destroys the instance and releases the associated
resources for reuse."

The behavior after this patch is that the resources aren't freed until the epoll
file *and* all files that were added to it have been closed.

Is that okay?  I suppose in most cases it is, since the usual use case for epoll
is to have a long-lived epoll instance and shorter lived file descriptors that
are polled using that long-lived epoll instance.

But probably some users do things the other way around.  I.e., they have a
long-lived file descriptor that is repeatedly polled using different epoll
instances that have a shorter lifetime.

In that case, the number of 'struct eventpoll' and 'struct epitem' in kernel
memory will keep growing until 'max_user_watches' is hit, at which point
EPOLL_CTL_ADD will start failing with ENOSPC.

Are you sure that is fine?

I'll also note that there is a comment at the top of fs/eventpoll.c that
describes the locking scheme, which this patch forgets to update.

- Eric
