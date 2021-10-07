Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DFC4255C0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbhJGOth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:49:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:42119 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233419AbhJGOtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:49:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="225038290"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="225038290"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 07:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="489020729"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 07:47:35 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1mYUgF-009Z2n-Ho;
        Thu, 07 Oct 2021 17:47:31 +0300
Date:   Thu, 7 Oct 2021 17:47:31 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
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
Message-ID: <YV8Ig9WyCk5kx634@smile.fi.intel.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <YV7NEze2IvUgHusJ@kroah.com>
 <CAHp75VfoQ-rFEEFu2FnaPuPDwyiTHpA_dCwqfA1SYSkFPM2uMA@mail.gmail.com>
 <YV79LGUsUZ3/iwOs@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV79LGUsUZ3/iwOs@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 03:59:08PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 07, 2021 at 02:51:15PM +0300, Andy Shevchenko wrote:
> > On Thu, Oct 7, 2021 at 1:34 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:

...

> > Meanwhile, Thorsten, can you have a look at my approach and tell if it
> > makes sense?
> 
> No, do not use ccache when trying to benchmark the speed of kernel
> builds, that tests the speed of your disk subsystem...

First rule of the measurement is to be sure WHAT we are measuring.
And I'm pretty much explained WHAT and HOW. On the other hand, the
kcbench can't answer to the question about C preprocessing speed
without help of ccache or something similar.

Measuring complete build is exactly not what we want because of
O(compilation) vs. o(C preprocessing) meaning that any fluctuation
in the former makes silly to measure anything from the latter.

You see, my theory is proved by practical experiment:

$ kcbench -i 3 -j 64 -o $O -s $PWD --no-download -m
Processor:           Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz [88 CPUs]
Cpufreq; Memory:     powersave [intel_pstate]; 128823 MiB
Linux running:       5.6.0-2-amd64 [x86_64]
Compiler:            gcc (Debian 10.3.0-11) 10.3.0
Linux compiled:      5.15.0-rc4
Config; Environment: allmodconfig; CCACHE_DISABLE="1"
Build command:       make vmlinux modules
Filling caches:      This might take a while... Done
Run 1 (-j 64):       464.07 seconds / 7.76 kernels/hour [P:6001%]
Run 2 (-j 64):       464.64 seconds / 7.75 kernels/hour [P:6000%]
Run 3 (-j 64):       486.41 seconds / 7.40 kernels/hour [P:5727%]

$ kcbench -i 3 -j 64 -o $O -s $PWD --no-download -m
Processor:           Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz [88 CPUs]
Cpufreq; Memory:     powersave [intel_pstate]; 128823 MiB
Linux running:       5.6.0-2-amd64 [x86_64]
Compiler:            gcc (Debian 10.3.0-11) 10.3.0
Linux compiled:      5.15.0-rc4
Config; Environment: allmodconfig; CCACHE_DISABLE="1"
Build command:       make vmlinux modules
Filling caches:      This might take a while... Done
Run 1 (-j 64):       462.32 seconds / 7.79 kernels/hour [P:6009%]
Run 2 (-j 64):       462.33 seconds / 7.79 kernels/hour [P:6006%]
Run 3 (-j 64):       465.45 seconds / 7.73 kernels/hour [P:5999%]

In [41]: numpy.median(y1)
Out[41]: 464.64

In [42]: numpy.median(y2)
Out[42]: 462.33

Speedup: +0.5%

-- 
With Best Regards,
Andy Shevchenko


