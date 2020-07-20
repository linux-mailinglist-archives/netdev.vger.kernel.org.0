Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A6226A19
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgGTPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730669AbgGTPzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:55:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0D9C061794;
        Mon, 20 Jul 2020 08:55:33 -0700 (PDT)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595260531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jbWthf/sjZFiaxrDbdSXd7IDu0n+zAeGRM5n6XQ12Q=;
        b=cm5VzJaz5qrAkoZitAhzUZDycS7yfhS15HX/+qK23ajutc5u5UwdCxFcqwQzLus/vh7EWX
        UyDw/ZPHkHN0liJK3lBqbLf/i9L+sWnoSe6WIs1Gwx0jp3TkBs4IYDOE1YG7MPnC878s3w
        miPatgXK3fxnduOAlyFX1rDdxV+nxkYn47JxWpPmVWWwd7Glvmu7qAv3Wyil3jAmMaDY0v
        t9TgnD9Echr0UPz3HIcpF4TyuPgtaatVtc/2O94aTqnAy7T4WnHmjJF6O1OnQ9sedFqgKE
        SgF9i7DxWT0Af0lsIBTlGl05ZNKEBKMpJB1XK2TR2FaerXgz/IbL3NL1yn2O4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595260531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jbWthf/sjZFiaxrDbdSXd7IDu0n+zAeGRM5n6XQ12Q=;
        b=ZAFWlyQoaZ+tWxi7yUUbv462J9muSHDnco6CRcWa+luXz/lRxaZdbaNGE+wDp+0kF4FYvu
        h9M+wZzjsYe0YpDw==
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 00/24] seqlock: Extend seqcount API with associated locks
Date:   Mon, 20 Jul 2020 17:55:06 +0200
Message-Id: <20200720155530.1173732-1-a.darwish@linutronix.de>
In-Reply-To: <20200519214547.352050-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is v4 of the seqlock patch series:

   [PATCH v1 00/25]
   https://lore.kernel.org/lkml/20200519214547.352050-1-a.darwish@linutronix.de

   [PATCH v2 00/06] (bugfixes-only, merged)
   https://lore.kernel.org/lkml/20200603144949.1122421-1-a.darwish@linutronix.de

   [PATCH v2 00/18]
   https://lore.kernel.org/lkml/20200608005729.1874024-1-a.darwish@linutronix.de

   [PATCH v3 00/20]
   https://lore.kernel.org/lkml/20200630054452.3675847-1-a.darwish@linutronix.de

It is based over:

   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git :: locking/core

Changelog
=========

 - Unconditionally use C11 _Generic() expressions for seqcount_locktype_t
   switching. Thanks to Peter, pushing for 6ec4476ac825 ("Raise gcc
   version requirement to 4.9").

 - Compress the new seqcount_locktype_t code code by using generative
   macros, as suggested by Peter here:

   https://lkml.kernel.org/r/20200708122938.GQ4800@hirez.programming.kicks-ass.net

   Keep *all* functions that are to be invoked by call-sites out of such
   generative macros though. This simplifies the generative macros code,
   and (more importantly) make the newly exported seqlock.h API explicit.

 - Make all documentation "RST-lite", for better readability from text
   editors.

 - Add additional clean-ups at the start of the series for better
   overall readability of seqlock.h code, and for future extensibility.

Thanks,

8<--------------

Ahmed S. Darwish (24):
  Documentation: locking: Describe seqlock design and usage
  seqlock: Properly format kernel-doc code samples
  seqlock: seqcount_t latch: End read sections with
    read_seqcount_retry()
  seqlock: Reorder seqcount_t and seqlock_t API definitions
  seqlock: Add kernel-doc for seqcount_t and seqlock_t APIs
  seqlock: Implement raw_seqcount_begin() in terms of
    raw_read_seqcount()
  lockdep: Add preemption enabled/disabled assertion APIs
  seqlock: lockdep assert non-preemptibility on seqcount_t write
  seqlock: Extend seqcount API with associated locks
  seqlock: Align multi-line macros newline escapes at 72 columns
  dma-buf: Remove custom seqcount lockdep class key
  dma-buf: Use sequence counter with associated wound/wait mutex
  sched: tasks: Use sequence counter with associated spinlock
  netfilter: conntrack: Use sequence counter with associated spinlock
  netfilter: nft_set_rbtree: Use sequence counter with associated rwlock
  xfrm: policy: Use sequence counters with associated lock
  timekeeping: Use sequence counter with associated raw spinlock
  vfs: Use sequence counter with associated spinlock
  raid5: Use sequence counter with associated spinlock
  iocost: Use sequence counter with associated spinlock
  NFSv4: Use sequence counter with associated spinlock
  userfaultfd: Use sequence counter with associated spinlock
  kvm/eventfd: Use sequence counter with associated spinlock
  hrtimer: Use sequence counter with associated raw spinlock

 Documentation/locking/index.rst               |    1 +
 Documentation/locking/seqlock.rst             |  222 ++++
 block/blk-iocost.c                            |    5 +-
 drivers/dma-buf/dma-resv.c                    |   15 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  |    2 -
 drivers/md/raid5.c                            |    2 +-
 drivers/md/raid5.h                            |    2 +-
 fs/dcache.c                                   |    2 +-
 fs/fs_struct.c                                |    4 +-
 fs/nfs/nfs4_fs.h                              |    2 +-
 fs/nfs/nfs4state.c                            |    2 +-
 fs/userfaultfd.c                              |    4 +-
 include/linux/dcache.h                        |    2 +-
 include/linux/dma-resv.h                      |    4 +-
 include/linux/fs_struct.h                     |    2 +-
 include/linux/hrtimer.h                       |    2 +-
 include/linux/kvm_irqfd.h                     |    2 +-
 include/linux/lockdep.h                       |   19 +
 include/linux/sched.h                         |    2 +-
 include/linux/seqlock.h                       | 1139 +++++++++++++----
 include/net/netfilter/nf_conntrack.h          |    2 +-
 init/init_task.c                              |    3 +-
 kernel/fork.c                                 |    2 +-
 kernel/time/hrtimer.c                         |   13 +-
 kernel/time/timekeeping.c                     |   19 +-
 lib/Kconfig.debug                             |    1 +
 net/netfilter/nf_conntrack_core.c             |    5 +-
 net/netfilter/nft_set_rbtree.c                |    4 +-
 net/xfrm/xfrm_policy.c                        |   10 +-
 virt/kvm/eventfd.c                            |    2 +-
 30 files changed, 1173 insertions(+), 323 deletions(-)
 create mode 100644 Documentation/locking/seqlock.rst

base-commit: a9232dc5607dbada801f2fe83ea307cda762969a
--
2.20.1
