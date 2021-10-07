Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886D54251F0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbhJGL0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:26:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55890 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232729AbhJGL0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 07:26:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYRVB-0008EV-J1; Thu, 07 Oct 2021 19:23:53 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYRUm-00051c-R8; Thu, 07 Oct 2021 19:23:28 +0800
Date:   Thu, 7 Oct 2021 19:23:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] lib/rhashtable: Replace kernel.h with the
 necessary inclusions
Message-ID: <20211007112328.GA19281@gondor.apana.org.au>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <20211007095129.22037-4-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007095129.22037-4-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:51:28PM +0300, Andy Shevchenko wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  lib/rhashtable.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index a422c7dd9126..01502cf77564 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -12,9 +12,13 @@
>   */
>  
>  #include <linux/atomic.h>
> +#include <linux/bit_spinlock.h>
>  #include <linux/container_of.h>
> -#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
>  #include <linux/init.h>
> +#include <linux/jhash.h>
> +#include <linux/lockdep.h>
>  #include <linux/log2.h>
>  #include <linux/sched.h>
>  #include <linux/rculist.h>

Nack.  I can see the benefits of splitting things out of kernel.h
but there is no reason to add crap to end users like rhashtable.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
