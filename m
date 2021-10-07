Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B664254E7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbhJGOBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232936AbhJGOBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA48960FD7;
        Thu,  7 Oct 2021 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633615150;
        bh=sqvFZb6sh7VYr+Bej9DmEIpIK2fkoZ+270sq/HauX80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HX73yf/qM/zvtw9gKSJ6/lZuPfVcwWdTJdMdjUpKYTezXfu5D19LbqXCeFhk8Jjwc
         ooPcFqYwg2B+XDrRw7HgQ22nV+w+mnYT8hGXPaxefRJuhQEf2oBiq9AaTROyYfsEL+
         OZOkVxVWGINC02Dhfkt+l942Lj+Es8+wjzAkQxwY=
Date:   Thu, 7 Oct 2021 15:59:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <YV79LGUsUZ3/iwOs@kroah.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <YV7NEze2IvUgHusJ@kroah.com>
 <CAHp75VfoQ-rFEEFu2FnaPuPDwyiTHpA_dCwqfA1SYSkFPM2uMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfoQ-rFEEFu2FnaPuPDwyiTHpA_dCwqfA1SYSkFPM2uMA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:51:15PM +0300, Andy Shevchenko wrote:
> On Thu, Oct 7, 2021 at 1:34 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 07, 2021 at 12:51:25PM +0300, Andy Shevchenko wrote:
> > > The kernel.h is a set of something which is not related to each other
> > > and often used in non-crossed compilation units, especially when drivers
> > > need only one or two macro definitions from it.
> > >
> > > Here is the split of container_of(). The goals are the following:
> > > - untwist the dependency hell a bit
> > > - drop kernel.h inclusion where it's only used for container_of()
> > > - speed up C preprocessing.
> > >
> > > People, like Greg KH and Miguel Ojeda, were asking about the latter.
> > > Read below the methodology and test setup with outcome numbers.
> > >
> > > The methodology
> > > ===============
> > > The question here is how to measure in the more or less clean way
> > > the C preprocessing time when building a project like Linux kernel.
> > > To answer it, let's look around and see what tools do we have that
> > > may help. Aha, here is ccache tool that seems quite plausible to
> > > be used. Its core idea is to preprocess C file, count hash (MD4)
> > > and compare to ones that are in the cache. If found, return the
> > > object file, avoiding compilation stage.
> > >
> > > Taking into account the property of the ccache, configure and use
> > > it in the below steps:
> > >
> > > 1. Configure kernel with allyesconfig
> > >
> > > 2. Make it with `make` to be sure that the cache is filled with
> > >    the latest data. I.o.w. warm up the cache.
> > >
> > > 3. Run `make -s` (silent mode to reduce the influence of
> > >    the unrelated things, like console output) 10 times and
> > >    measure 'real' time spent.
> > >
> > > 4. Repeat 1-3 for each patch or patch set to get data sets before
> > >    and after.
> > >
> > > When we get the raw data, calculating median will show us the number.
> > > Comparing them before and after we will see the difference.
> > >
> > > The setup
> > > =========
> > > I have used the Intel x86_64 server platform (see partial output of
> > >  `lscpu` below):
> > >
> > > $ lscpu
> > > Architecture:            x86_64
> > >   CPU op-mode(s):        32-bit, 64-bit
> > >   Address sizes:         46 bits physical, 48 bits virtual
> > >   Byte Order:            Little Endian
> > > CPU(s):                  88
> > >   On-line CPU(s) list:   0-87
> > > Vendor ID:               GenuineIntel
> > >   Model name:            Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz
> > >     CPU family:          6
> > >     Model:               79
> > >     Thread(s) per core:  2
> > >     Core(s) per socket:  22
> > >     Socket(s):           2
> > >     Stepping:            1
> > >     CPU max MHz:         3600.0000
> > >     CPU min MHz:         1200.0000
> > > ...
> > > Caches (sum of all):
> > >   L1d:                   1.4 MiB (44 instances)
> > >   L1i:                   1.4 MiB (44 instances)
> > >   L2:                    11 MiB (44 instances)
> > >   L3:                    110 MiB (2 instances)
> > > NUMA:
> > >   NUMA node(s):          2
> > >   NUMA node0 CPU(s):     0-21,44-65
> > >   NUMA node1 CPU(s):     22-43,66-87
> > > Vulnerabilities:
> > >   Itlb multihit:         KVM: Mitigation: Split huge pages
> > >   L1tf:                  Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
> > >   Mds:                   Mitigation; Clear CPU buffers; SMT vulnerable
> > >   Meltdown:              Mitigation; PTI
> > >   Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl and seccomp
> > >   Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
> > >   Spectre v2:            Mitigation; Full generic retpoline, IBPB conditional, IBRS_FW, STIBP conditional, RSB filling
> > >   Tsx async abort:       Mitigation; Clear CPU buffers; SMT vulnerable
> > >
> > > With the following GCC:
> > >
> > > $ gcc --version
> > > gcc (Debian 10.3.0-11) 10.3.0
> > >
> > > The commands I have run during the measurement were:
> > >
> > >       rm -rf $O
> > >       make O=$O allyesconfig
> > >       time make O=$O -s -j64  # this step has been measured
> > >
> > > The raw data and median
> > > =======================
> > > Before patch 2 (yes, I have measured the only patch 2 effect) in the series
> > > (the data is sorted by time):
> > >
> > > real    2m8.794s
> > > real    2m11.183s
> > > real    2m11.235s
> > > real    2m11.639s
> > > real    2m11.960s
> > > real    2m12.014s
> > > real    2m12.609s
> > > real    2m13.177s
> > > real    2m13.462s
> > > real    2m19.132s
> > >
> > > After patch 2 has been applied:
> > >
> > > real    2m8.536s
> > > real    2m8.776s
> > > real    2m9.071s
> > > real    2m9.459s
> > > real    2m9.531s
> > > real    2m9.610s
> > > real    2m10.356s
> > > real    2m10.430s
> > > real    2m11.117s
> > > real    2m11.885s
> > >
> > > Median values are:
> > >       131.987s before
> > >       129.571s after
> > >
> > > We see the steady speedup as of 1.83%.
> >
> > You do know about kcbench:
> >         https://gitlab.com/knurd42/kcbench.git
> >
> > Try running that to make it such that we know how it was tested :)
> 
> I'll try it.
> 
> Meanwhile, Thorsten, can you have a look at my approach and tell if it
> makes sense?

No, do not use ccache when trying to benchmark the speed of kernel
builds, that tests the speed of your disk subsystem...

thanks,

greg k-h
