Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD9820EDAD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgF3Fo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgF3Foz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:44:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164BFC061755;
        Mon, 29 Jun 2020 22:44:55 -0700 (PDT)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593495893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GrkSvba99FgobDAlEmHj32dyhwgdl+SntEs2ao/WN8=;
        b=sl2ud3iMwCuA6+ElAUIYrRbM0m0RkkvU3bPJWCxHmZ8RLhKd7jX1ai+0Es5gcCrVdZr4TN
        qFylmPM5fVePH9cFtO1+ce22yno+YtUk6p9/yQfP2yweVa7q7vmF0UUwoKw7ta6+V/yWXA
        krKIMA2BsgcE3E+6E5R8byS0wT2Kw9e6d2DecXagQtp9AMuPa8EuXk5XAByC7SAFUX8cNe
        AB2ybJtpX6ge3GWDvOPp475PgjiCjNbRc/XsnegbgvlijyHGJqdZzPDQZkcr5rmKTYGpEx
        SwNLFUwaL+73SHR2Y5oDSz2QNONcFUQnXUogkZvdFDTTnC5VadgV6VHK+oaTmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593495893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GrkSvba99FgobDAlEmHj32dyhwgdl+SntEs2ao/WN8=;
        b=T6B9D7uRvkWFYBzG4VSPoBuzOvE107rTU7zJx7VaIT56htIad2D/bhxA4ml8dGqu9vGoDf
        AYhJ7D39uLRInqAg==
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 00/20] seqlock: Extend seqcount API with associated locks
Date:   Tue, 30 Jun 2020 07:44:32 +0200
Message-Id: <20200630054452.3675847-1-a.darwish@linutronix.de>
In-Reply-To: <20200519214547.352050-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is v3 of the seqlock patch series:

   [PATCH v1 00/25] seqlock: Extend seqcount API with associated locks
   https://lore.kernel.org/lkml/20200519214547.352050-1-a.darwish@linutronix.de

   [PATCH v2 00/18]
   https://lore.kernel.org/lkml/20200608005729.1874024-1-a.darwish@linutronix.de

It's based over:

   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git locking/core

to get Peter's lockdep irqstate tracking series below, which untangles
mainline seqlock.h<=>sched.h 'current->' task_struct circular dependency:

   https://lkml.kernel.org/r/linuxppc-dev/20200623083645.277342609@infradead.org

Changelog-v3:

 - Re-add lockdep non-preemptibility checks on seqcount_t write paths.
   They were removed from v2 due to the circular dependencies mentioned.

 - Slight rebase over the new v5.8-rc1 KCSAN seqlock.h changes

 - Collect seqcount_t call-sites acked-by tags

Thanks,

8<--------------

Ahmed S. Darwish (20):
  Documentation: locking: Describe seqlock design and usage
  seqlock: Properly format kernel-doc code samples
  seqlock: Add missing kernel-doc annotations
  lockdep: Add preemption enabled/disabled assertion APIs
  seqlock: lockdep assert non-preemptibility on seqcount_t write
  seqlock: Extend seqcount API with associated locks
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

 Documentation/locking/index.rst               |   1 +
 Documentation/locking/seqlock.rst             | 242 +++++
 MAINTAINERS                                   |   2 +-
 block/blk-iocost.c                            |   5 +-
 drivers/dma-buf/dma-resv.c                    |  15 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  |   2 -
 drivers/md/raid5.c                            |   2 +-
 drivers/md/raid5.h                            |   2 +-
 fs/dcache.c                                   |   2 +-
 fs/fs_struct.c                                |   4 +-
 fs/nfs/nfs4_fs.h                              |   2 +-
 fs/nfs/nfs4state.c                            |   2 +-
 fs/userfaultfd.c                              |   4 +-
 include/linux/dcache.h                        |   2 +-
 include/linux/dma-resv.h                      |   4 +-
 include/linux/fs_struct.h                     |   2 +-
 include/linux/hrtimer.h                       |   2 +-
 include/linux/kvm_irqfd.h                     |   2 +-
 include/linux/lockdep.h                       |  18 +
 include/linux/sched.h                         |   2 +-
 include/linux/seqlock.h                       | 872 ++++++++++++++----
 include/linux/seqlock_types_internal.h        | 186 ++++
 include/net/netfilter/nf_conntrack.h          |   2 +-
 init/init_task.c                              |   3 +-
 kernel/fork.c                                 |   2 +-
 kernel/time/hrtimer.c                         |  13 +-
 kernel/time/timekeeping.c                     |  19 +-
 lib/Kconfig.debug                             |   1 +
 net/netfilter/nf_conntrack_core.c             |   5 +-
 net/netfilter/nft_set_rbtree.c                |   4 +-
 net/xfrm/xfrm_policy.c                        |  10 +-
 virt/kvm/eventfd.c                            |   2 +-
 32 files changed, 1211 insertions(+), 225 deletions(-)
 create mode 100644 Documentation/locking/seqlock.rst
 create mode 100644 include/linux/seqlock_types_internal.h

base-commit: 997e89fa345e9006f311cf9f9c8fd9f7d96c240f
--
2.20.1
