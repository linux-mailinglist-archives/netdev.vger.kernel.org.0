Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E7B64AF8D
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 07:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiLMGBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 01:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiLMGBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 01:01:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29E31A225;
        Mon, 12 Dec 2022 22:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D58AB810D9;
        Tue, 13 Dec 2022 06:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71D3C433EF;
        Tue, 13 Dec 2022 06:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670911273;
        bh=Zm0ZW55NBxkf93eC0YUdg0I7MwwoIiM8sdJEKEUMCYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSlQoMZ4SBMRhVsILSn4ozXPcuxJMF++qfycdW1UDNLsHeKL/Y2CGLz47ohDTDghl
         l+3LtPZJY+YpBzk1TmTfNPCl7jMN404vFSj5h6bcVJeN3rO+Dtz/xDf3IjahQAIggB
         7sfucFqYs/CXHhXelTjXPbWtIapZR9eAglP7yMmhiNtomzjMbWminUjzgsF14RKw/7
         WS8PO6iIm8RsWeSizc/XOem2RFDpnAGZrQC3Vh1ZYYntqX2984nV93Oi2sLmOd7g8X
         Bzo11AdEvTrGSxEcPnKPxFYN1O0pCXzEHEUmYMLi1fSNQL74zisCMElyO0poh22826
         NjInCkS1B1a8w==
Date:   Mon, 12 Dec 2022 22:01:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
Message-ID: <Y5gVJz+qDfw0tEP1@sol.localdomain>
References: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 07:00:10PM +0100, Paolo Abeni wrote:
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
> ep_free() and eventpoll_release_file(): the latter marks, under f_lock
> spinlock, each epitem as before removing it, while ep_free() does not
> touch dying epitems.
> 
> The eventpoll struct is released by whoever - among ep_free() and
> eventpoll_release_file() drops its last reference.
> 
> With all the above in place, we can drop the epmutex usage at disposal time.
> 
> Overall this produces a significant performance improvement in the
> mentioned connection/rate scenario: the mutex operations disappear from
> the topmost offenders in the perf report, and the measured connections/rate
> grows by ~60%.
> 
> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

I am trying to understand whether this patch is correct.

One thing that would help would be to use more standard naming:

	ep_put => ep_refcount_dec_and_test (or ep_put_and_test)
	ep_dispose => ep_free
	ep_free => ep_clear_and_put

- Eric
