Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AA3C6EB1
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhGMKkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 06:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235408AbhGMKkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 06:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E4936120A;
        Tue, 13 Jul 2021 10:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626172669;
        bh=AgjVuCrRhRFKJ6UIPQshihlxJ0+9rq4qKDL2Tch43Pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sOGO+dHAUoasROuQDK8NKfLCxtos2xyt63I6H6tnRHDBhdCaWkiHytREWqsU7TkPj
         wzWNT+ExXmlC7Ta+yFqQdXjyW4p8Kb9KFZ8wWoHHuzGUlrMLtvAwTdpnK1sDahagye
         JAeuIDuxsmviT/zr1ArOqaoojkBXLGPPu9Mobe8Q=
Date:   Tue, 13 Jul 2021 12:37:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Message-ID: <YO1s+rHEqC9RjMva@kroah.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 11:45:41AM +0300, Andy Shevchenko wrote:
> kernel.h is being used as a dump for all kinds of stuff for a long time.
> Here is the attempt cleaning it up by splitting out container_of() and
> typeof_memeber() macros.

That feels messy, why?  Reading one .h file for these common
macros/defines is fine, why are container_of and typeof somehow
deserving of their own .h files?  What speedups are you seeing by
splitting this up?

> At the same time convert users in the header and other folders to use it.
> Though for time being include new header back to kernel.h to avoid twisted
> indirected includes for existing users.
> 
> Note, there are _a lot_ of headers and modules that include kernel.h solely
> for one of these macros and this allows to unburden compiler for the twisted
> inclusion paths and to make new code cleaner in the future.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/kunit/test.h         | 14 ++++++++++++--
>  include/linux/container_of.h | 37 ++++++++++++++++++++++++++++++++++++
>  include/linux/kernel.h       | 31 +-----------------------------
>  include/linux/kobject.h      | 14 +++++++-------

Why are all of these changes needed to kobject.h for this one change?
This diff:

> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -15,18 +15,18 @@
>  #ifndef _KOBJECT_H_
>  #define _KOBJECT_H_
>  
> -#include <linux/types.h>
> -#include <linux/list.h>
> -#include <linux/sysfs.h>
> +#include <linux/atomic.h>
>  #include <linux/compiler.h>
> -#include <linux/spinlock.h>
> +#include <linux/container_of.h>
> +#include <linux/list.h>
>  #include <linux/kref.h>
>  #include <linux/kobject_ns.h>
> -#include <linux/kernel.h>
>  #include <linux/wait.h>
> -#include <linux/atomic.h>
> -#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>
>  #include <linux/uidgid.h>
> +#include <linux/workqueue.h>

Is a lot more changes than the "split the macros out" deserves.

Please make this a separate change, remember to only do one thing at a
time (this patch is at least 2 changes...)

so NAK, this change isn't ok as-is.

greg k-h
