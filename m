Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB5F23F26B
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHGSE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:04:28 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39511 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgHGSE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 14:04:27 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 077I4CJt006795;
        Fri, 7 Aug 2020 20:04:12 +0200
Date:   Fri, 7 Aug 2020 20:04:12 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, tytso@mit.edu,
        netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200807180412.GA6790@1wt.eu>
References: <20200807174302.GA6740@1wt.eu>
 <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Fri, Aug 07, 2020 at 10:55:11AM -0700, Andy Lutomirski wrote:
> >> This is still another non-cryptographic PRNG.
> > 
> > Absolutely. During some discussions regarding the possibility of using
> > CSPRNGs, orders around hundreds of CPU cycles were mentioned for them,
> > which can definitely be a huge waste of precious resources for some
> > workloads, possibly causing the addition of a few percent extra machines
> > in certain environments just to keep the average load under a certain
> > threshold.
> 
> I think the real random.c can run plenty fast. It's ChaCha20 plus ludicrous
> overhead right now. I'm working (slowly) on making the overhead go away.  I'm
> hoping to have something testable in a few days.  As it stands, there is a
> ton of indirection, a pile of locks, multiple time comparisons, per-node and
> percpu buffers (why both?), wasted bits due to alignment, and probably other
> things that can be cleaned up.  I'm trying to come up with something that is
> fast and has easy-to-understand semantics.
> 
> You can follow along at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=random/fast

Thanks, we'll see. I developed a quick test tool that's meant to be easy
to use to measure the performance impact on connect/accept. I have not
yet run it on a modified PRNG to verify if it works. I'll send it once
I've tested. I'd definitely would like to see no measurable performance
drop, and ideally even a small performance increase (as Tausworthe isn't
the lightest thing around either so we do have some little margin).

Willy
