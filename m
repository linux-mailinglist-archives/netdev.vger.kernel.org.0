Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06607425063
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbhJGJxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:53:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:26302 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhJGJx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:53:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="206330887"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="206330887"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 02:51:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="440210338"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 07 Oct 2021 02:51:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id EABC21C8; Thu,  7 Oct 2021 12:51:35 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] kernel.h further split
Date:   Thu,  7 Oct 2021 12:51:25 +0300
Message-Id: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel.h is a set of something which is not related to each other
and often used in non-crossed compilation units, especially when drivers
need only one or two macro definitions from it.

Here is the split of container_of(). The goals are the following:
- untwist the dependency hell a bit
- drop kernel.h inclusion where it's only used for container_of()
- speed up C preprocessing.

People, like Greg KH and Miguel Ojeda, were asking about the latter.
Read below the methodology and test setup with outcome numbers.

The methodology
===============
The question here is how to measure in the more or less clean way
the C preprocessing time when building a project like Linux kernel.
To answer it, let's look around and see what tools do we have that
may help. Aha, here is ccache tool that seems quite plausible to
be used. Its core idea is to preprocess C file, count hash (MD4)
and compare to ones that are in the cache. If found, return the
object file, avoiding compilation stage.

Taking into account the property of the ccache, configure and use
it in the below steps:

1. Configure kernel with allyesconfig

2. Make it with `make` to be sure that the cache is filled with
   the latest data. I.o.w. warm up the cache.

3. Run `make -s` (silent mode to reduce the influence of
   the unrelated things, like console output) 10 times and
   measure 'real' time spent.

4. Repeat 1-3 for each patch or patch set to get data sets before
   and after.

When we get the raw data, calculating median will show us the number.
Comparing them before and after we will see the difference.

The setup
=========
I have used the Intel x86_64 server platform (see partial output of
 `lscpu` below):

$ lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         46 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  88
  On-line CPU(s) list:   0-87
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz
    CPU family:          6
    Model:               79
    Thread(s) per core:  2
    Core(s) per socket:  22
    Socket(s):           2
    Stepping:            1
    CPU max MHz:         3600.0000
    CPU min MHz:         1200.0000
...
Caches (sum of all):
  L1d:                   1.4 MiB (44 instances)
  L1i:                   1.4 MiB (44 instances)
  L2:                    11 MiB (44 instances)
  L3:                    110 MiB (2 instances)
NUMA:
  NUMA node(s):          2
  NUMA node0 CPU(s):     0-21,44-65
  NUMA node1 CPU(s):     22-43,66-87
Vulnerabilities:
  Itlb multihit:         KVM: Mitigation: Split huge pages
  L1tf:                  Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                   Mitigation; Clear CPU buffers; SMT vulnerable
  Meltdown:              Mitigation; PTI
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl and seccomp
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; Full generic retpoline, IBPB conditional, IBRS_FW, STIBP conditional, RSB filling
  Tsx async abort:       Mitigation; Clear CPU buffers; SMT vulnerable

With the following GCC:

$ gcc --version
gcc (Debian 10.3.0-11) 10.3.0

The commands I have run during the measurement were:

	rm -rf $O
	make O=$O allyesconfig
	time make O=$O -s -j64	# this step has been measured

The raw data and median
=======================
Before patch 2 (yes, I have measured the only patch 2 effect) in the series
(the data is sorted by time):

real    2m8.794s
real    2m11.183s
real    2m11.235s
real    2m11.639s
real    2m11.960s
real    2m12.014s
real    2m12.609s
real    2m13.177s
real    2m13.462s
real    2m19.132s

After patch 2 has been applied:

real    2m8.536s
real    2m8.776s
real    2m9.071s
real    2m9.459s
real    2m9.531s
real    2m9.610s
real    2m10.356s
real    2m10.430s
real    2m11.117s
real    2m11.885s

Median values are:
	131.987s before
	129.571s after

We see the steady speedup as of 1.83%.

Andy Shevchenko (4):
  kernel.h: Drop unneeded <linux/kernel.h> inclusion from other headers
  kernel.h: Split out container_of() and typeof_member() macros
  lib/rhashtable: Replace kernel.h with the necessary inclusions
  kunit: Replace kernel.h with the necessary inclusions

 include/kunit/test.h         | 14 ++++++++++++--
 include/linux/container_of.h | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h       | 31 +-----------------------------
 include/linux/kobject.h      |  1 +
 include/linux/list.h         |  6 ++++--
 include/linux/llist.h        |  4 +++-
 include/linux/plist.h        |  5 ++++-
 include/linux/rwsem.h        |  1 -
 include/linux/spinlock.h     |  1 -
 include/media/media-entity.h |  3 ++-
 lib/radix-tree.c             |  6 +++++-
 lib/rhashtable.c             |  7 ++++++-
 12 files changed, 75 insertions(+), 41 deletions(-)
 create mode 100644 include/linux/container_of.h

-- 
2.33.0

