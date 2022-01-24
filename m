Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FA0497F8A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbiAXM3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:29:14 -0500
Received: from mga07.intel.com ([134.134.136.100]:6547 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239650AbiAXM3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 07:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643027353; x=1674563353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o7r0U7Ku8gJK9VEbYjNho62PNu3+pf6Q/1IyLG6vJkk=;
  b=kFhlw11iXnsD/zys52QjWkBc42TYF5UVZ/jFZSjGvVz48GItMBKX7otW
   PLcPatXa6l1PTFGoNsNlaZW4YewKXwc47p9t1f6OkIe1yALmou075W8za
   +lJKRAKCQSNwtVb5UaaMcketwTYpZP7xtJU6eB++uDeC/r5idDVyX0SbI
   4C+PMtje1VSoOv9DMH8swYNU3U5WMP/Z1V0tqfYjkAa6bIrkXqUAxhTkh
   MEZrmE071E7YsXLklF3f5zkNDA0F3vIAriWz437Y9g5V8SaiokxfgJsi9
   XOQhVk1AljwJRQwExNxPGIZ8KGn6ZhIio2KyeLVKoya3tUAzIwxULhsjj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309353499"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309353499"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:29:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="580353480"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:29:08 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nByS0-00DszF-DE;
        Mon, 24 Jan 2022 14:28:00 +0200
Date:   Mon, 24 Jan 2022 14:28:00 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/54] net: ethernet: replace bitmap_weight with
 bitmap_empty for qlogic
Message-ID: <Ye6bUC1GyLLUV37p@smile.fi.intel.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-11-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123183925.1052919-11-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 10:38:41AM -0800, Yury Norov wrote:
> qlogic/qed code calls bitmap_weight() to check if any bit of a given
> bitmap is set. It's better to use bitmap_empty() in that case because
> bitmap_empty() stops traversing the bitmap as soon as it finds first
> set bit, while bitmap_weight() counts all bits unconditionally.

> -		if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
> +		if (!bitmap_empty((unsigned long *)&pmap[item], 64 * 8))

> -	    (bitmap_weight((unsigned long *)&pmap[item],
> +	    (!bitmap_empty((unsigned long *)&pmap[item],

Side note, these castings reminds me previous discussion and I'm wondering
if you have this kind of potentially problematic places in your TODO as
subject to fix.


-- 
With Best Regards,
Andy Shevchenko


