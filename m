Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6273723F8CA
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHHUrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 16:47:47 -0400
Received: from mx.sdf.org ([205.166.94.24]:55009 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgHHUrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 16:47:47 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078KlUKH010985
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 20:47:30 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078KlTZ7022030;
        Sat, 8 Aug 2020 20:47:29 GMT
Date:   Sat, 8 Aug 2020 20:47:29 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808204729.GD27941@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 11:19:01AM -0700, Linus Torvalds wrote:
> If siphash is a good enough hash to make the pseudo-random state hard
> to guess, then it's also a good enough hash to hide the small part of
> the fast-pool we mix in.

No!

No, no, a thousand times no.

I *just* finished explaining, using dribs and drabs of entropy allows an 
*information theoretical attack* which *no* crypto can prevent.

The drip-feed design of the current patch is a catastrophic antifeature
which must be anethametized.

You could replace SipHash with a random function, the platonic ideal
to which all other cryptographic functions are compared, and you'd
still have a hole.

The fact that *nothing* can fix bad seeding is the entire reason
/dev/random exists in the first place.


*Second*, I have no intention of using full SipHash.  I'm spending
all of that security margin making it as fast as possible, leaving
just enough to discourage the original attack.

As you just pointed out, half-MD4 (still used in fs/ext4/hash.c) is quite 
enough to discourage attack if used appropriately.

If you go and *vastly* increase the value of a successful attack, 
letting an attacker at long-lived high-value keys, I have to put all
that margin back.

(Not to mention, even full SipHash only offers 128-bit security in the 
first place!  Shall I go and delete AES-256 and SHA2-512, since we've 
decided the Linux kernel is capped at 128-bit security?)

It's not even remotely difficult: use the *output* of random.c.  
Making that safe is what all that code is for.

(It costs some cycles, but SipHash's strength lets you go long 
enough between reseeds that it amorizes to insignificance.)
