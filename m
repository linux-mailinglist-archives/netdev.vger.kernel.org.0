Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7120423C3B3
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgHECt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:49:56 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39399 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgHECt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 22:49:56 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0752nfDC017394;
        Wed, 5 Aug 2020 04:49:41 +0200
Date:   Wed, 5 Aug 2020 04:49:41 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805024941.GA17301@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Aug 04, 2020 at 05:52:36PM -0700, Marc Plumb wrote:
> Seeding two PRNGs with the same entropy causes two problems. The minor one
> is that you're double counting entropy. The major one is that anyone who can
> determine the state of one PRNG can determine the state of the other.
> 
> The net_rand_state PRNG is effectively a 113 bit LFSR, so anyone who can see
> any 113 bits of output can determine the complete internal state.
> 
> The output of the net_rand_state PRNG is used to determine how data is sent
> to the network, so the output is effectively broadcast to anyone watching
> network traffic. Therefore anyone watching the network traffic can determine
> the seed data being fed to the net_rand_state PRNG.

The problem this patch is trying to work around is that the reporter
(Amit) was able to determine the entire net_rand_state after observing
a certain number of packets due to this trivial LFSR and the fact that
its internal state between two reseedings only depends on the number
of calls to read it. (please note that regarding this point I'll
propose a patch to replace that PRNG to stop directly exposing the
internal state to the network).

If you look closer at the patch, you'll see that in one interrupt
the patch only uses any 32 out of the 128 bits of fast_pool to
update only 32 bits of the net_rand_state. As such, the sequence
observed on the network also depends on the remaining bits of
net_rand_state, while the 96 other bits of the fast_pool are not
exposed there.

> Since this is the same
> seed data being fed to get_random_bytes, it allows an attacker to determine
> the state and there output of /dev/random. I sincerely hope that this was
> not the intended goal. :)

Not only was this obviously not the goal, but I'd be particularly
interested in seeing this reality demonstrated, considering that
the whole 128 bits of fast_pool together count as a single bit of
entropy, and that as such, even if you were able to figure the
value of the 32 bits leaked to net_rand_state, you'd still have to
guess the 96 other bits for each single entropy bit :-/

Regards,
Willy
