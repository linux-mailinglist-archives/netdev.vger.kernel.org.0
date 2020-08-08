Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40323F8DE
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 22:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgHHU7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 16:59:34 -0400
Received: from mx.sdf.org ([205.166.94.24]:54685 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgHHU7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 16:59:33 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078KxCTd017128
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 20:59:13 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078KxCQo019409;
        Sat, 8 Aug 2020 20:59:12 GMT
Date:   Sat, 8 Aug 2020 20:59:12 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Florian Westphal <fw@strlen.de>
Cc:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808205912.GE27941@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
 <20200808191827.GA19310@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808191827.GA19310@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 09:18:27PM +0200, Florian Westphal wrote:
> Can't we keep prandom_u32 as-is...?  Most of the usage, esp. in the
> packet schedulers, is fine.
> 
> I'd much rather have a prandom_u32_hashed() or whatever for
> those cases where some bits might leak to the outside and then convert
> those prandom_u32 users over to the siphashed version.

That's a question I've been asking.  Since this is apparently an
Important Security Bug that wants backported to -stable, I'm making
the minimally-invasive change, which is to change prandom_u32() for
all callers rather that decide which gets what.

But going forward, adding an additional security level between
the current prandom_u32() and get_random_u32() is possible.

I'm not sure it's a good idea, however.  This entire hullalbaloo stems
from someone choosing the wrong PRNG.  Adding another option doesn't
seem likely to prevent a repetition in future.
