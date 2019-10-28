Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE8E7CC7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfJ1XSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:18:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfJ1XSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:18:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEEE214BE72C3;
        Mon, 28 Oct 2019 16:18:17 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:18:17 -0700 (PDT)
Message-Id: <20191028.161817.126838643568293118.davem@davemloft.net>
To:     tj@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, josef@toxicpanda.com,
        eric.dumazet@gmail.com, jakub.kicinski@netronome.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mgorman@suse.de,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory
 reclaim
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
        <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:18:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 24 Oct 2019 13:50:27 -0700

> sk_page_frag() optimizes skb_frag allocations by using per-task
> skb_frag cache when it knows it's the only user.  The condition is
> determined by seeing whether the socket allocation mask allows
> blocking - if the allocation may block, it obviously owns the task's
> context and ergo exclusively owns current->task_frag.
> 
> Unfortunately, this misses recursion through memory reclaim path.
> Please take a look at the following backtrace.
 ...
> In [0], tcp_send_msg_locked() was using current->page_frag when it
> called sk_wmem_schedule().  It already calculated how many bytes can
> be fit into current->page_frag.  Due to memory pressure,
> sk_wmem_schedule() called into memory reclaim path which called into
> xfs and then IO issue path.  Because the filesystem in question is
> backed by nbd, the control goes back into the tcp layer - back into
> tcp_sendmsg_locked().
> 
> nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
> sense - it's in the process of freeing memory and wants to be able to,
> e.g., drop clean pages to make forward progress.  However, this
> confused sk_page_frag() called from [2].  Because it only tests
> whether the allocation allows blocking which it does, it now thinks
> current->page_frag can be used again although it already was being
> used in [0].
> 
> After [2] used current->page_frag, the offset would be increased by
> the used amount.  When the control returns to [0],
> current->page_frag's offset is increased and the previously calculated
> number of bytes now may overrun the end of allocated memory leading to
> silent memory corruptions.
> 
> Fix it by adding gfpflags_normal_context() which tests sleepable &&
> !reclaim and use it to determine whether to use current->task_frag.
> 
> v2: Eric didn't like gfp flags being tested twice.  Introduce a new
>     helper gfpflags_normal_context() and combine the two tests.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied and queued up for -stable, thanks Tejun.
