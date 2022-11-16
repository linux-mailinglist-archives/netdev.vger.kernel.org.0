Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7295262CF38
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbiKPX4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKPX4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:56:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61175657E5;
        Wed, 16 Nov 2022 15:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15466205D;
        Wed, 16 Nov 2022 23:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABDBC433D6;
        Wed, 16 Nov 2022 23:55:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="goQ4eWiA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668642952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sM9LBQZ376u5w/8PZH+YQVlUaxTNIyanmkjPT3FYfMU=;
        b=goQ4eWiAvkZqWkfss8gq1ex5AtlA/ahfxEBk6r2fheEdHDzxQqDvdaI7jHnRtKQZacSknN
        xALKJahBGIU2w4KpYkodsz6zSfQUgQjwtn/9XiLQzmbduxm8SAGcIyMTbNpEffPJ6eVtj8
        fknlTQXlnEW5l9AjbJbPQ6U48mWYP8U=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 48c033fa (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 16 Nov 2022 23:55:51 +0000 (UTC)
Date:   Thu, 17 Nov 2022 00:55:47 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org,
        ydroneaud@opteya.com
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <Y3V4g8eorwiU++Y3@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
 <202211161436.A45AD719A@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202211161436.A45AD719A@keescook>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 02:43:13PM -0800, Kees Cook wrote:
> On Mon, Nov 14, 2022 at 05:45:58PM +0100, Jason A. Donenfeld wrote:
> > -				(get_random_u32_below(1024) + 1) * PAGE_SIZE;
> > +				get_random_u32_between(1, 1024 + 1) * PAGE_SIZE;
> 
> I really don't like "between". Can't this be named "inclusive" (and
> avoid adding 1 everywhere, which seems ugly), or at least named
> something less ambiguous?
> 
> > -		n = get_random_u32_below(100) + 1;
> > +		n = get_random_u32_between(1, 101);
> 
> Because I find this much less readable. "Below 100" is clear: 0-99
> inclusive, plus 1, so 1-100 inclusive. "Between 1 and 101" is not obvious
> to me to mean: 1-100 inclusive.
> 
> These seem so much nicer:
> 	get_random_u32_inclusive(1, 1024)
> 	get_random_u32_inclusive(1, 100)

Yann pointed out something similar -- the half-closed interval being
confusing -- and while I was initially dismissive, I've warmed up to
doing this fully closed after sending a diff of that:

https://lore.kernel.org/lkml/Y3Qt8HiXj8giOnZy@zx2c4.com/

So okay, let's say that I'll implement the inclusive version instead. We
now have two problems to solve:

1) How/whether to make f(0, UR2_MAX) safe,
   - without additional 64-bit arithmetic,
   - minimizing the number of branches.
   I have a few ideas I'll code golf for a bit.

2) What to call it:
   - between I still like, because it mirrors "I'm thinking of a number
     between 1 and 10 and..." that everybody knows,
   - inclusive I guess works, but it's not a preposition,
   - bikeshed color #3?

I think I can make progress with (1) alone by fiddling around with
godbolt enough, like usual. I could use some more ideas for (2) though.

Jason
