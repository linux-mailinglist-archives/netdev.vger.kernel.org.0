Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AED23CCA3
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgHEQ4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:56:07 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39416 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbgHEQx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:53:57 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 075Gr4vw017948;
        Wed, 5 Aug 2020 18:53:04 +0200
Date:   Wed, 5 Aug 2020 18:53:04 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     tytso@mit.edu
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805165304.GA17940@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805153432.GE497249@mit.edu>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ted,

On Wed, Aug 05, 2020 at 11:34:32AM -0400, tytso@mit.edu wrote:
> That being said, it certainly is a certificational / theoretical
> weakness, and if the bright boys and girls at Fort Meade did figure
> out a way to exploit this, they are very much unlikely to share it at
> an open Crypto conference.  So replacing LFSR-based PRnG with
> something stronger which didn't release any bits from the fast_pool
> would certainly be desireable, and I look forward to seeing what Willy
> has in mind.

I'll post a proposal patch shortly about this, hopefully this week-end
(got diverted by work lately :-)). Just to give you a few pointers,
it's a small modification of MSWS. It passes the Practrand test suite
on 256 GB of data with zero warning (something that Tausworthe is
supposed to fail at).

By default, MSWS *does* leak its internal state, as Amit showed us (and
seeing that the paper on it suggests it's safe as-is for crypto use is
a bit shocking), but once slightly adjusted, it doesn't reveal its state
anymore and that would constitute a much more future-proof solution for
quite some time. Tausworthe was created something like 20 years ago or
so, hence it's not surprizing that it's a bit dated by now, but if we
can upgrade once every 2 decades I guess it's not that bad.

Cheers,
Willy
