Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F50EBA4D
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfJaXUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJaXUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 19:20:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B2582080F;
        Thu, 31 Oct 2019 23:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572564050;
        bh=yPaNXg7rVEUmYhJlagKrkpm6GOQfnu1T7GvUBG/ADnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NdET+Wl6EXY+gsB+rwq78qtmLhnWNtrebAGY0ue+iOBdaOpcpGhCBIDLsa9MioC1q
         PlhBqz3P4A955GEX821+G61N82B91g5Qmpbe7Uwif2q3+tN/TbQxU8DcWfefjZc4T+
         7gbk9ZRyemxWrRv0Z9Lb3Ua0oJrSMcInpX1R/8mA=
Date:   Thu, 31 Oct 2019 16:20:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory
 reclaim
Message-Id: <20191031162049.27e54d9412214aea79acd2ea@linux-foundation.org>
In-Reply-To: <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
        <20191024205027.GF3622521@devbig004.ftw2.facebook.com>
        <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:35:21 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> +Michal Hocko
> 
> On Thu, Oct 24, 2019 at 1:50 PM Tejun Heo <tj@kernel.org> wrote:
> >
> > sk_page_frag() optimizes skb_frag allocations by using per-task
> > skb_frag cache when it knows it's the only user.  The condition is
> > determined by seeing whether the socket allocation mask allows
> > blocking - if the allocation may block, it obviously owns the task's
> > context and ergo exclusively owns current->task_frag.
> >
> > Unfortunately, this misses recursion through memory reclaim path.
> > Please take a look at the following backtrace.
> >
> >  [2] RIP: 0010:tcp_sendmsg_locked+0xccf/0xe10
> >      ...
> >      tcp_sendmsg+0x27/0x40
> >      sock_sendmsg+0x30/0x40
> >      sock_xmit.isra.24+0xa1/0x170 [nbd]
> >      nbd_send_cmd+0x1d2/0x690 [nbd]
> >      nbd_queue_rq+0x1b5/0x3b0 [nbd]
> >      __blk_mq_try_issue_directly+0x108/0x1b0
> >      blk_mq_request_issue_directly+0xbd/0xe0
> >      blk_mq_try_issue_list_directly+0x41/0xb0
> >      blk_mq_sched_insert_requests+0xa2/0xe0
> >      blk_mq_flush_plug_list+0x205/0x2a0
> >      blk_flush_plug_list+0xc3/0xf0
> >  [1] blk_finish_plug+0x21/0x2e
> >      _xfs_buf_ioapply+0x313/0x460
> >      __xfs_buf_submit+0x67/0x220
> >      xfs_buf_read_map+0x113/0x1a0
> >      xfs_trans_read_buf_map+0xbf/0x330
> >      xfs_btree_read_buf_block.constprop.42+0x95/0xd0
> >      xfs_btree_lookup_get_block+0x95/0x170
> >      xfs_btree_lookup+0xcc/0x470
> >      xfs_bmap_del_extent_real+0x254/0x9a0
> >      __xfs_bunmapi+0x45c/0xab0
> >      xfs_bunmapi+0x15/0x30
> >      xfs_itruncate_extents_flags+0xca/0x250
> >      xfs_free_eofblocks+0x181/0x1e0
> >      xfs_fs_destroy_inode+0xa8/0x1b0
> >      destroy_inode+0x38/0x70
> >      dispose_list+0x35/0x50
> >      prune_icache_sb+0x52/0x70
> >      super_cache_scan+0x120/0x1a0
> >      do_shrink_slab+0x120/0x290
> >      shrink_slab+0x216/0x2b0
> >      shrink_node+0x1b6/0x4a0
> >      do_try_to_free_pages+0xc6/0x370
> >      try_to_free_mem_cgroup_pages+0xe3/0x1e0
> >      try_charge+0x29e/0x790
> >      mem_cgroup_charge_skmem+0x6a/0x100
> >      __sk_mem_raise_allocated+0x18e/0x390
> >      __sk_mem_schedule+0x2a/0x40
> >  [0] tcp_sendmsg_locked+0x8eb/0xe10
> >      tcp_sendmsg+0x27/0x40
> >      sock_sendmsg+0x30/0x40
> >      ___sys_sendmsg+0x26d/0x2b0
> >      __sys_sendmsg+0x57/0xa0
> >      do_syscall_64+0x42/0x100
> >      entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > In [0], tcp_send_msg_locked() was using current->page_frag when it

"tcp_sendmsg_locked" and "current->task_frag".  Stuff like this makes
review harder :(

> > called sk_wmem_schedule().  It already calculated how many bytes can
> > be fit into current->page_frag.  Due to memory pressure,
> > sk_wmem_schedule() called into memory reclaim path which called into
> > xfs and then IO issue path.  Because the filesystem in question is
> > backed by nbd, the control goes back into the tcp layer - back into
> > tcp_sendmsg_locked().
> >
> > nbd sets sk_allocation to (GFP_NOIO | __GFP_MEMALLOC) which makes
> > sense - it's in the process of freeing memory and wants to be able to,
> > e.g., drop clean pages to make forward progress.  However, this
> > confused sk_page_frag() called from [2].  Because it only tests
> > whether the allocation allows blocking which it does, it now thinks
> > current->page_frag can be used again although it already was being
> > used in [0].
> >
> > After [2] used current->page_frag, the offset would be increased by
> > the used amount.  When the control returns to [0],
> > current->page_frag's offset is increased and the previously calculated
> > number of bytes now may overrun the end of allocated memory leading to
> > silent memory corruptions.
> >
> > Fix it by adding gfpflags_normal_context() which tests sleepable &&
> > !reclaim and use it to determine whether to use current->task_frag.
> >

Dumb-but-obvious question.  Rather than putzing with allocation modes,
is it not feasible to change the net layer to copy the current value of
current->task_frag into a local then restore its value when it has
finished being used?

