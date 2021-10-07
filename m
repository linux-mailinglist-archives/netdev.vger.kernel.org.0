Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6591E425141
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbhJGKk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240949AbhJGKkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F57B60F02;
        Thu,  7 Oct 2021 10:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633603103;
        bh=lu5k2LNYph7kGX6NH429bKjPjz5kZlIuiNVBrGopjRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FsJkGVtPNbgrwogrOSdK+rN2seu5yj1PE4+u2NIGUe5Y3/9JbaMTJz+bEFD31/K5e
         VhntWSLtGP2rsc0Pt4o9ElpUJeaQKTCb4rFwYqoEpa2kbjdYMVddcfo1XRKjK/CLFv
         5KVQuX2l22s/RDZ4jnmVjdTTNmlAk+fn75hmueY0=
Date:   Thu, 7 Oct 2021 12:38:21 +0200
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
Message-ID: <YV7OHWy+0MNGpUKl@kroah.com>
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
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -12,19 +12,21 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/bug.h>
> +#include <linux/container_of.h>
>  #include <linux/cpu.h>
>  #include <linux/errno.h>
>  #include <linux/export.h>
>  #include <linux/idr.h>
>  #include <linux/init.h>
> -#include <linux/kernel.h>
>  #include <linux/kmemleak.h>
> +#include <linux/math.h>
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>		/* in_interrupt() */
>  #include <linux/radix-tree.h>
>  #include <linux/rcupdate.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/types.h>
>  #include <linux/xarray.h>
>  
>  /*
> @@ -285,6 +287,8 @@ radix_tree_node_alloc(gfp_t gfp_mask, struct radix_tree_node *parent,
>  	return ret;
>  }
>  
> +extern void radix_tree_node_rcu_free(struct rcu_head *head);

.c files should not need an extern, this belongs in a .h file somewhere,
or something really went wrong here...

thanks,

greg k-h
