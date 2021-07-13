Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5353C6F5F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhGMLTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:19:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:2090 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235937AbhGMLTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 07:19:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="210118495"
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="210118495"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 04:16:31 -0700
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="649428726"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 04:16:24 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m3GOf-00CZLg-Ci; Tue, 13 Jul 2021 14:16:17 +0300
Date:   Tue, 13 Jul 2021 14:16:17 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>, jic23@kernel.org,
        linux@rasmusvillemoes.dk
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Message-ID: <YO12ARa3i1TprGnJ@smile.fi.intel.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
 <YO1s+rHEqC9RjMva@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO1s+rHEqC9RjMva@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 12:37:46PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 13, 2021 at 11:45:41AM +0300, Andy Shevchenko wrote:
> > kernel.h is being used as a dump for all kinds of stuff for a long time.
> > Here is the attempt cleaning it up by splitting out container_of() and
> > typeof_memeber() macros.
> 
> That feels messy, why?

Because the headers in the kernel are messy.

> Reading one .h file for these common
> macros/defines is fine, why are container_of and typeof somehow
> deserving of their own .h files?

It's explained here. There are tons of drivers that includes kernel.h for only
a few or even solely for container_of() macro.

> What speedups are you seeing by
> splitting this up?

C preprocessing.

> > At the same time convert users in the header and other folders to use it.
> > Though for time being include new header back to kernel.h to avoid twisted
> > indirected includes for existing users.
> > 
> > Note, there are _a lot_ of headers and modules that include kernel.h solely
> > for one of these macros and this allows to unburden compiler for the twisted
> > inclusion paths and to make new code cleaner in the future.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  include/kunit/test.h         | 14 ++++++++++++--
> >  include/linux/container_of.h | 37 ++++++++++++++++++++++++++++++++++++
> >  include/linux/kernel.h       | 31 +-----------------------------
> >  include/linux/kobject.h      | 14 +++++++-------
> 
> Why are all of these changes needed to kobject.h for this one change?
> This diff:
> 
> > --- a/include/linux/kobject.h
> > +++ b/include/linux/kobject.h
> > @@ -15,18 +15,18 @@
> >  #ifndef _KOBJECT_H_
> >  #define _KOBJECT_H_
> >  
> > -#include <linux/types.h>
> > -#include <linux/list.h>
> > -#include <linux/sysfs.h>
> > +#include <linux/atomic.h>
> >  #include <linux/compiler.h>
> > -#include <linux/spinlock.h>
> > +#include <linux/container_of.h>
> > +#include <linux/list.h>
> >  #include <linux/kref.h>
> >  #include <linux/kobject_ns.h>
> > -#include <linux/kernel.h>
> >  #include <linux/wait.h>
> > -#include <linux/atomic.h>
> > -#include <linux/workqueue.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/types.h>
> >  #include <linux/uidgid.h>
> > +#include <linux/workqueue.h>
> 
> Is a lot more changes than the "split the macros out" deserves.
> 
> Please make this a separate change, remember to only do one thing at a
> time (this patch is at least 2 changes...)
> 
> so NAK, this change isn't ok as-is.

Fair enough. I will remove these conversions from the patch in v2.

Thanks for review!

-- 
With Best Regards,
Andy Shevchenko


