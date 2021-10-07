Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D763142513C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbhJGKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240868AbhJGKj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A49260C4C;
        Thu,  7 Oct 2021 10:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633603053;
        bh=xDMazokcPNABQ4Qk5ZpSLObojNMHpNQ7xmSlqlHdOXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddn/JHGpcuqFBIT5H+VDQ8CAR2wDHpesc/AofsrL8HwIWIX7Eo4zQIbcPI+6VqB0d
         2eGvtZFHMt+pKKMzNkQtYLEiwgDvi+KwXJWXPpKNfaVAgowCFMP8kNYf3i9Fp8Pfc8
         AXsRpvRKtzpEH4nzdOHT/d7L9b723qNH96RcgA6o=
Date:   Thu, 7 Oct 2021 12:37:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org,
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
Subject: Re: [PATCH v2 2/4] kernel.h: Split out container_of() and
 typeof_member() macros
Message-ID: <YV7N6/2+/oDv81Fq@kroah.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <20211007095129.22037-3-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007095129.22037-3-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:51:27PM +0300, Andy Shevchenko wrote:
> kernel.h is being used as a dump for all kinds of stuff for a long time.
> Here is the attempt cleaning it up by splitting out container_of() and
> typeof_member() macros.
> 
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
>  include/kunit/test.h         |  2 ++
>  include/linux/container_of.h | 37 ++++++++++++++++++++++++++++++++++++
>  include/linux/kernel.h       | 31 +-----------------------------
>  include/linux/kobject.h      |  1 +
>  include/linux/list.h         |  6 ++++--
>  include/linux/llist.h        |  4 +++-
>  include/linux/plist.h        |  5 ++++-
>  include/media/media-entity.h |  3 ++-
>  lib/radix-tree.c             |  6 +++++-
>  lib/rhashtable.c             |  1 +
>  10 files changed, 60 insertions(+), 36 deletions(-)
>  create mode 100644 include/linux/container_of.h
> 
> diff --git a/include/kunit/test.h b/include/kunit/test.h
> index 24b40e5c160b..4d498f496790 100644
> --- a/include/kunit/test.h
> +++ b/include/kunit/test.h
> @@ -11,6 +11,8 @@
>  
>  #include <kunit/assert.h>
>  #include <kunit/try-catch.h>
> +
> +#include <linux/container_of.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> diff --git a/include/linux/container_of.h b/include/linux/container_of.h
> new file mode 100644
> index 000000000000..f6ee1be0e784
> --- /dev/null
> +++ b/include/linux/container_of.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_CONTAINER_OF_H
> +#define _LINUX_CONTAINER_OF_H
> +
> +#define typeof_member(T, m)	typeof(((T*)0)->m)
> +
> +/**
> + * container_of - cast a member of a structure out to the containing structure
> + * @ptr:	the pointer to the member.
> + * @type:	the type of the container struct this is embedded in.
> + * @member:	the name of the member within the struct.
> + *
> + */
> +#define container_of(ptr, type, member) ({				\
> +	void *__mptr = (void *)(ptr);					\
> +	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
> +			 !__same_type(*(ptr), void),			\
> +			 "pointer type mismatch in container_of()");	\
> +	((type *)(__mptr - offsetof(type, member))); })
> +
> +/**
> + * container_of_safe - cast a member of a structure out to the containing structure
> + * @ptr:	the pointer to the member.
> + * @type:	the type of the container struct this is embedded in.
> + * @member:	the name of the member within the struct.
> + *
> + * If IS_ERR_OR_NULL(ptr), ptr is returned unchanged.
> + */
> +#define container_of_safe(ptr, type, member) ({				\
> +	void *__mptr = (void *)(ptr);					\
> +	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
> +			 !__same_type(*(ptr), void),			\
> +			 "pointer type mismatch in container_of()");	\
> +	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
> +		((type *)(__mptr - offsetof(type, member))); })
> +
> +#endif	/* _LINUX_CONTAINER_OF_H */
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d416fe3165cb..ad9fdcce9dcf 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -9,6 +9,7 @@
>  #include <linux/stddef.h>
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <linux/container_of.h>
>  #include <linux/bitops.h>
>  #include <linux/kstrtox.h>
>  #include <linux/log2.h>
> @@ -482,36 +483,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  #define __CONCAT(a, b) a ## b
>  #define CONCATENATE(a, b) __CONCAT(a, b)
>  
> -/**
> - * container_of - cast a member of a structure out to the containing structure
> - * @ptr:	the pointer to the member.
> - * @type:	the type of the container struct this is embedded in.
> - * @member:	the name of the member within the struct.
> - *
> - */
> -#define container_of(ptr, type, member) ({				\
> -	void *__mptr = (void *)(ptr);					\
> -	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
> -			 !__same_type(*(ptr), void),			\
> -			 "pointer type mismatch in container_of()");	\
> -	((type *)(__mptr - offsetof(type, member))); })
> -
> -/**
> - * container_of_safe - cast a member of a structure out to the containing structure
> - * @ptr:	the pointer to the member.
> - * @type:	the type of the container struct this is embedded in.
> - * @member:	the name of the member within the struct.
> - *
> - * If IS_ERR_OR_NULL(ptr), ptr is returned unchanged.
> - */
> -#define container_of_safe(ptr, type, member) ({				\
> -	void *__mptr = (void *)(ptr);					\
> -	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
> -			 !__same_type(*(ptr), void),			\
> -			 "pointer type mismatch in container_of()");	\
> -	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
> -		((type *)(__mptr - offsetof(type, member))); })
> -
>  /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index efd56f990a46..bf8371e58b17 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -15,6 +15,7 @@
>  #ifndef _KOBJECT_H_
>  #define _KOBJECT_H_
>  
> +#include <linux/container_of.h>
>  #include <linux/types.h>
>  #include <linux/list.h>
>  #include <linux/sysfs.h>
> diff --git a/include/linux/list.h b/include/linux/list.h
> index f2af4b4aa4e9..5dc679b373da 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -2,11 +2,13 @@
>  #ifndef _LINUX_LIST_H
>  #define _LINUX_LIST_H
>  
> +#include <linux/container_of.h>
> +#include <linux/const.h>
>  #include <linux/types.h>
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
> -#include <linux/const.h>
> -#include <linux/kernel.h>
> +
> +#include <asm/barrier.h>
>  
>  /*
>   * Circular doubly linked list implementation.


This change looks odd.

You already have kernel.h including container_of.h, so why not have a
series that does:
	- create container_of.h and have kernel.h include it
	- multiple patches that remove kernel.h and use container_of.h
	  instead only.
	- multiple patches that remove kernel.h and use container_of.h
	  and other .h files (like list.h seems to need here.)
	- remove container_of.h from kernel.h

Mushing them all together here makes this really hard to understand why
this change is needed here.

thanks,

greg k-h
