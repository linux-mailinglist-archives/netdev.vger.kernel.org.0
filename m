Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277731F10D5
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgFHA6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbgFHA6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:58:06 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C2FC08C5C4;
        Sun,  7 Jun 2020 17:58:06 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1ji66U-0000hc-WF; Mon, 08 Jun 2020 02:57:31 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
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
Subject: [PATCH v2 00/18] seqlock: Extend seqcount API with associated locks
Date:   Mon,  8 Jun 2020 02:57:11 +0200
Message-Id: <20200608005729.1874024-1-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519214547.352050-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
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

This is v2 of the seqlock patch series:

   [PATCH v1 00/25] seqlock: Extend seqcount API with associated locks
   https://lore.kernel.org/lkml/20200519214547.352050-1-a.darwish@linutronix.de

Patches 1=>3 of this v2 series add documentation for the existing
seqlock.h datatypes and APIs. Hopefully they can hit v5.8 -rc2 or -rc3.

Changelog-v2
============

1. Drop, for now, the seqlock v1 patches #7 and #8. These patches added
lockdep non-preemptibility checks to seqcount_t write paths, but they
now depend on on-going work by Peter:

   [PATCH v3 0/5] lockdep: Change IRQ state tracking to use per-cpu variables
   https://lkml.kernel.org/r/20200529213550.683440625@infradead.org

   [PATCH 00/14] x86/entry: disallow #DB more and x86/entry lockdep/nmi
   https://lkml.kernel.org/r/20200529212728.795169701@infradead.org

Once Peter's work get merged, I'll send the non-preemptibility checks as
a separate series.

2. Drop the v1 seqcount_t call-sites bugfixes. I've already posted them
in an isolated series. They got merged into their respective trees, and
will hit v5.8-rc1 soon:

   [PATCH v2 0/6] seqlock: seqcount_t call sites bugfixes
   https://lore.kernel.org/lkml/20200603144949.1122421-1-a.darwish@linutronix.de

3. Patch #1: Add a small paragraph explaining that seqcount_t/seqlock_t
cannot be used if the protected data contains pointers. A similar
paragraph already existed in seqlock.h, but got mistakenly dropped.

4. Patch #2: Don't add RST directives inside kernel-doc comments. Peter
doesn't like them :) I've kept the indentation though, and found a
minimal way for Sphinx to properly render these code samples without too
much disruption.

5. Patch #3: Brush up the introduced kernel-doc comments. Make them more
consistent overall, and more concise.

Thanks,

8<--------------

Ahmed S. Darwish (18):
  Documentation: locking: Describe seqlock design and usage
  seqlock: Properly format kernel-doc code samples
  seqlock: Add missing kernel-doc annotations
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
 include/linux/sched.h                         |   2 +-
 include/linux/seqlock.h                       | 855 ++++++++++++++----
 include/linux/seqlock_types_internal.h        | 187 ++++
 include/net/netfilter/nf_conntrack.h          |   2 +-
 init/init_task.c                              |   3 +-
 kernel/fork.c                                 |   2 +-
 kernel/time/hrtimer.c                         |  13 +-
 kernel/time/timekeeping.c                     |  19 +-
 net/netfilter/nf_conntrack_core.c             |   5 +-
 net/netfilter/nft_set_rbtree.c                |   4 +-
 net/xfrm/xfrm_policy.c                        |  10 +-
 virt/kvm/eventfd.c                            |   2 +-
 30 files changed, 1175 insertions(+), 226 deletions(-)
 create mode 100644 Documentation/locking/seqlock.rst
 create mode 100644 include/linux/seqlock_types_internal.h

base-commit: 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
--
2.20.1
