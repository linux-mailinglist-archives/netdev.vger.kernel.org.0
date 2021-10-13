Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0B42BCDA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhJMKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:33:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:43420 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhJMKdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 06:33:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="226170344"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="226170344"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 03:31:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="547782394"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.159])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 03:31:41 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1mabXu-000JEQ-AK;
        Wed, 13 Oct 2021 13:31:38 +0300
Date:   Wed, 13 Oct 2021 13:31:38 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
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
Subject: Re: [PATCH v2 0/4] kernel.h further split
Message-ID: <YWa1igOl4eAxv6FL@smile.fi.intel.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <YV7NEze2IvUgHusJ@kroah.com>
 <CAHp75VfoQ-rFEEFu2FnaPuPDwyiTHpA_dCwqfA1SYSkFPM2uMA@mail.gmail.com>
 <20211008113758.6cbee642@t14s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211008113758.6cbee642@t14s>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 11:37:58AM +0200, Thorsten Leemhuis wrote:
> On Thu, 7 Oct 2021 14:51:15 +0300
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Thu, Oct 7, 2021 at 1:34 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Thu, Oct 07, 2021 at 12:51:25PM +0300, Andy Shevchenko wrote:
> > > > The kernel.h is a set of something which is not related to each
> > > > other and often used in non-crossed compilation units, especially
> > > > when drivers need only one or two macro definitions from it.
> > > >
> > > > Here is the split of container_of(). The goals are the following:
> > > > - untwist the dependency hell a bit
> > > > - drop kernel.h inclusion where it's only used for container_of()
> > > > - speed up C preprocessing.
> > > >
> > > > People, like Greg KH and Miguel Ojeda, were asking about the
> > > > latter. Read below the methodology and test setup with outcome
> > > > numbers.
> > > >
> > > > The methodology
> > > > ===============
> > > > The question here is how to measure in the more or less clean way
> > > > the C preprocessing time when building a project like Linux
> > > > kernel. To answer it, let's look around and see what tools do we
> > > > have that may help. Aha, here is ccache tool that seems quite
> > > > plausible to be used. Its core idea is to preprocess C file,
> > > > count hash (MD4) and compare to ones that are in the cache. If
> > > > found, return the object file, avoiding compilation stage.
> > > >
> > > > Taking into account the property of the ccache, configure and use
> > > > it in the below steps:
> > > >
> > > > 1. Configure kernel with allyesconfig
> > > >
> > > > 2. Make it with `make` to be sure that the cache is filled with
> > > >    the latest data. I.o.w. warm up the cache.
> > > >
> > > > 3. Run `make -s` (silent mode to reduce the influence of
> > > >    the unrelated things, like console output) 10 times and
> > > >    measure 'real' time spent.
> > > >
> > > > 4. Repeat 1-3 for each patch or patch set to get data sets before
> > > >    and after.
> > > >
> > > > When we get the raw data, calculating median will show us the
> > > > number. Comparing them before and after we will see the
> > > > difference.
> > > >
> > > > The setup
> > > > =========
> > > > I have used the Intel x86_64 server platform (see partial output
> > > > of `lscpu` below):
> > > >
> > > > $ lscpu
> > > > Architecture:            x86_64
> > > >   CPU op-mode(s):        32-bit, 64-bit
> > > >   Address sizes:         46 bits physical, 48 bits virtual
> > > >   Byte Order:            Little Endian
> > > > CPU(s):                  88
> > > >   On-line CPU(s) list:   0-87
> > > > Vendor ID:               GenuineIntel
> > > >   Model name:            Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz
> > > >     CPU family:          6
> > > >     Model:               79
> > > >     Thread(s) per core:  2
> > > >     Core(s) per socket:  22
> > > >     Socket(s):           2
> > > >     Stepping:            1
> > > >     CPU max MHz:         3600.0000
> > > >     CPU min MHz:         1200.0000
> > > > ...
> > > > Caches (sum of all):
> > > >   L1d:                   1.4 MiB (44 instances)
> > > >   L1i:                   1.4 MiB (44 instances)
> > > >   L2:                    11 MiB (44 instances)
> > > >   L3:                    110 MiB (2 instances)
> > > > NUMA:
> > > >   NUMA node(s):          2
> > > >   NUMA node0 CPU(s):     0-21,44-65
> > > >   NUMA node1 CPU(s):     22-43,66-87
> > > > Vulnerabilities:
> > > >   Itlb multihit:         KVM: Mitigation: Split huge pages
> > > >   L1tf:                  Mitigation; PTE Inversion; VMX
> > > > conditional cache flushes, SMT vulnerable Mds:
> > > > Mitigation; Clear CPU buffers; SMT vulnerable Meltdown:
> > > >    Mitigation; PTI Spec store bypass:     Mitigation; Speculative
> > > > Store Bypass disabled via prctl and seccomp Spectre v1:
> > > >  Mitigation; usercopy/swapgs barriers and __user pointer
> > > > sanitization Spectre v2:            Mitigation; Full generic
> > > > retpoline, IBPB conditional, IBRS_FW, STIBP conditional, RSB
> > > > filling Tsx async abort:       Mitigation; Clear CPU buffers; SMT
> > > > vulnerable
> > > >
> > > > With the following GCC:
> > > >
> > > > $ gcc --version
> > > > gcc (Debian 10.3.0-11) 10.3.0
> > > >
> > > > The commands I have run during the measurement were:
> > > >
> > > >       rm -rf $O
> > > >       make O=$O allyesconfig
> > > >       time make O=$O -s -j64  # this step has been measured
> 
> BTW, what kcbench does in the end is not that different, but it only
> builds the config once and that uses it for all further testing.

Since I measure the third operation only this shouldn't affect recreation
of the configuration file.

> > > > The raw data and median
> > > > =======================
> > > > Before patch 2 (yes, I have measured the only patch 2 effect) in
> > > > the series (the data is sorted by time):
> > > >
> > > > real    2m8.794s
> > > > real    2m11.183s
> > > > real    2m11.235s
> > > > real    2m11.639s
> > > > real    2m11.960s
> > > > real    2m12.014s
> > > > real    2m12.609s
> > > > real    2m13.177s
> > > > real    2m13.462s
> > > > real    2m19.132s
> > > >
> > > > After patch 2 has been applied:
> > > >
> > > > real    2m8.536s
> > > > real    2m8.776s
> > > > real    2m9.071s
> > > > real    2m9.459s
> > > > real    2m9.531s
> > > > real    2m9.610s
> > > > real    2m10.356s
> > > > real    2m10.430s
> > > > real    2m11.117s
> > > > real    2m11.885s
> > > >
> > > > Median values are:
> > > >       131.987s before
> > > >       129.571s after
> > > >
> > > > We see the steady speedup as of 1.83%.
> > >
> > > You do know about kcbench:
> > >         https://gitlab.com/knurd42/kcbench.git
> > >
> > > Try running that to make it such that we know how it was tested :)
> > 
> > I'll try it.
> > 
> > Meanwhile, Thorsten, can you have a look at my approach and tell if it
> > makes sense?
> 
> I'm not the right person to ask here, I don't know enough about the
> inner working of ccache and C preprocessing. Reminder: I'm not a real
> kernel/C developer, but more kind of a parasite that lives on the
> fringes of kernel development. ;-) Kcbench in fact originated as a
> benchmark magazine for the computer magazine I used to work for – where
> I also did quite a few benchmarks. But that knowledge might be helpful
> here:
> 
> The measurements before and after patch 2 was applied get slower over
> time. That is a hint that something is interfering. Is the disk filling
> up and making the fs do more work? Or is the machine getting to hot? It
> IMHO would be worth investigating and ruling out, as the differences
> you are looking out are likely quite small

I tried to explain why my methodology is closer to what we need to measure
in the above and replies. TL;DR: mathematically the O() shadows o() and as
we know the CPU and disk usage during compilation is a huge in comparison
to the C preprocessing. I'm not sure what you are referring by "slower
over time" since I explicitly said that I have _sorted_ the data. Nothing
should be done here, I believe.

> Also: the last run of the first measurement cycle is off by quite a
> bit, so I wouldn't even include the result, as there like was something
> that disturbed the benchmark.

I believe you missed the very same remark, i.e. that the data is sorted.

> And I might be missing something, but why were you using "-j 64" on a
> machine with 44 cores/88 threads?

Because that machine has more processes being run. And I would like to
minimize fluctuation of the CPU scheduling when some process requires
a resource to perform little work.

> I wonder if that might lead do
> interesting effects due to SMT (some core will run two threads, other
> only one). Using either "-j 44" or "-j 88" might be better.

How -j64 can be better? Nothing will guarantee that any of the core will
be half-loaded. But -j88 is worse because any process that wakes up and
requires for a resource may affect the measurements.

> But I
> suggest you run kcbench once without specifying "-j", as that will
> check which setting is the fastest on this system – and then use that
> for all further tests.

Next time I will try this approach, thanks for your reply and insights!

-- 
With Best Regards,
Andy Shevchenko


