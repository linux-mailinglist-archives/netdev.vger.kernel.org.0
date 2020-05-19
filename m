Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2621DA3E3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgESVrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgESVrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:47:02 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6485C08C5C0;
        Tue, 19 May 2020 14:47:01 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jbA3Z-0002YP-5y; Tue, 19 May 2020 23:45:49 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v1 00/25] seqlock: Extend seqcount API with associated locks
Date:   Tue, 19 May 2020 23:45:22 +0200
Message-Id: <20200519214547.352050-1-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A sequence counter write side critical section must be protected by some
form of locking to serialize writers. If the serialization primitive is
not disabling preemption implicitly, preemption has to be explicitly
disabled before entering the write side critical section.

There is no built-in debugging mechanism to verify that the lock used
for writer serialization is held and preemption is disabled. Some usage
sites like dma-buf have explicit lockdep checks for the writer-side
lock, but this covers only a small portion of the sequence counter usage
in the kernel.

Add new sequence counter types which allows to associate a lock to the
sequence counter at initialization time. The seqcount API functions are
extended to provide appropriate lockdep assertions depending on the
seqcount/lock type.

For sequence counters with associated locks that do not implicitly
disable preemption, preemption protection is enforced in the sequence
counter write side functions. This removes the need to explicitly add
preempt_disable/enable() around the write side critical sections: the
write_begin/end() functions for these new sequence counter types
automatically do this.

Extend the lockdep API with a macro asserting that preemption is
disabled.  Use it to verify that preemption is disabled for all sequence
counters write side critical sections.

If lockdep is disabled, these lock associations and non-preemptibility
checks are compiled out and have neither storage size nor runtime
overhead. If lockdep is enabled, a pointer to the lock is stored in the
seqcount and the write side API functions enable lockdep assertions.

The following seqcount types with associated locks are introduced:

     seqcount_spinlock_t
     seqcount_raw_spinlock_t
     seqcount_rwlock_t
     seqcount_mutex_t
     seqcount_ww_mutex_t

This lock association is not only useful for debugging purposes, it also
provides a mechanism for PREEMPT_RT to prevent writer starvation. On RT
kernels spinlocks and rwlocks are substituted with sleeping locks and
the code sections protected by these locks become preemptible, which has
the same problem as write side critical section with preemption enabled
on a non-RT kernel. RT utilizes this association by storing the provided
lock pointer and in case that a reader sees an active writer (seqcount
is odd), it does not spin, but blocks on the associated lock similar to
read_seqbegin_or_lock().

By using the lockdep debugging mechanisms added in this patch series, a
number of erroneous seqcount call-sites were discovered across the
kernel. The fixes are included at the beginning of the series.

Thanks,

8<--------------

Ahmed S. Darwish (25):
  net: core: device_rename: Use rwsem instead of a seqcount
  mm/swap: Don't abuse the seqcount latching API
  net: phy: fixed_phy: Remove unused seqcount
  block: nr_sects_write(): Disable preemption on seqcount write
  u64_stats: Document writer non-preemptibility requirement
  dma-buf: Remove custom seqcount lockdep class key
  lockdep: Add preemption disabled assertion API
  seqlock: lockdep assert non-preemptibility on seqcount_t write
  Documentation: locking: Describe seqlock design and usage
  seqlock: Add RST directives to kernel-doc code samples and notes
  seqlock: Add missing kernel-doc annotations
  seqlock: Extend seqcount API with associated locks
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
 Documentation/locking/seqlock.rst             | 239 +++++
 MAINTAINERS                                   |   2 +-
 block/blk-iocost.c                            |   5 +-
 block/blk.h                                   |   2 +
 drivers/dma-buf/dma-resv.c                    |  15 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  |   2 -
 drivers/md/raid5.c                            |   2 +-
 drivers/md/raid5.h                            |   2 +-
 drivers/net/phy/fixed_phy.c                   |  25 +-
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
 include/linux/lockdep.h                       |   9 +
 include/linux/sched.h                         |   2 +-
 include/linux/seqlock.h                       | 882 +++++++++++++++---
 include/linux/seqlock_types_internal.h        | 187 ++++
 include/linux/u64_stats_sync.h                |  38 +-
 include/net/netfilter/nf_conntrack.h          |   2 +-
 init/init_task.c                              |   3 +-
 kernel/fork.c                                 |   2 +-
 kernel/locking/lockdep.c                      |  15 +
 kernel/time/hrtimer.c                         |  13 +-
 kernel/time/timekeeping.c                     |  19 +-
 lib/Kconfig.debug                             |   1 +
 mm/swap.c                                     |  57 +-
 net/core/dev.c                                |  30 +-
 net/netfilter/nf_conntrack_core.c             |   5 +-
 net/netfilter/nft_set_rbtree.c                |   4 +-
 net/xfrm/xfrm_policy.c                        |  10 +-
 virt/kvm/eventfd.c                            |   2 +-
 38 files changed, 1325 insertions(+), 277 deletions(-)
 create mode 100644 Documentation/locking/seqlock.rst
 create mode 100644 include/linux/seqlock_types_internal.h

base-commit: 2ef96a5bb12be62ef75b5828c0aab838ebb29cb8
--
2.20.1
