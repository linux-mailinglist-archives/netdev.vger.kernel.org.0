Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CAA23F927
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHHV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:29:36 -0400
Received: from mx.sdf.org ([205.166.94.24]:50176 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgHHV3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 17:29:36 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078LTJXB014448
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 21:29:19 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078LTI13024452;
        Sat, 8 Aug 2020 21:29:18 GMT
Date:   Sat, 8 Aug 2020 21:29:18 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     netdev@vger.kernel.org, w@1wt.eu, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808212918.GF27941@SDF.ORG>
References: <20200808190343.GB27941@SDF.ORG>
 <A92CFD64-176B-4DC2-9BF2-257F4EBBE901@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A92CFD64-176B-4DC2-9BF2-257F4EBBE901@amacapital.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 12:49:30PM -0700, Andy Lutomirski wrote:

> I don't care about throwing this stuff away. My plan (not quite 
> implemented yet) is to have a percpu RNG stream and to never to anything 
> resembling mixing anything in. The stream is periodically discarded and 
> reinitialized from the global "primary" pool instead.  The primary pool 
> has a global lock. We do some vaguely clever trickery to arrange for all 
> the percpu pools to reseed from the primary pool at different times.
>
> Meanwhile the primary pool gets reseeded by the input pool on a schedule 
> for catastrophic reseeding.

Sounds good to me.

> Do we really need 256 bits of key erasure?  I suppose if we only replace 
> half the key each time, we're just asking for some cryptographer to run 
> the numbers on a break-one-of-many attack and come up with something 
> vaguely alarming.

It's possible to have different levels of overall and key-erasure 
security, but I'm not sure what the point is.  It doesn't change the 
numbers *that* much.

(But yes, if you do it, I like the idea of arranging the key 
overwrite so all of the key gets replaced after two passes.)

> I wonder if we get good performance by spreading out the work. We could, 
> for example, have a 320 byte output buffer that get_random_bytes() uses 
> and a 320+32 byte ?next? buffer that is generated as the output buffer 
> is used. When we finish the output buffer, the first 320 bytes of the next 
> buffer becomes the current buffer and the extra 32 bytes becomes the new 
> key (or nonce).  This will have lower worst case latency, but it will 
> hit the cache lines more often, potentially hurting throughout.

You definitely lose something in locality of reference when you spread out 
the work, but you don't need a double-sized buffer (and the resultant 
D-cache hit). Every time you use up a block of current output, fill it 
with a block of next output.

The last 32 bytes of the buffer are the next key. When you've used up all 
of the current buffer but that, overwrite the last block of the current 
buffer with the next^2 key and start over at the beginning, outputting the 
was-next-now-current data.

On other words, with a 320-byte buffer, 320-32 = 288 bytes are available 
for output.  When we pass 64, 128, 256 and 288 bytes, there is a small 
latency spike to run one iteration of ChaCha.

The main issue is the latency between seeding and it affecting the output.  
In particular, I think people expect writes to /dev/random (RNDADDENTROPY) 
to affect subsequent reads immediately, so we'd need to invalidate & 
regenerate the buffer in that case.  We could do something with generation 
numbers so in-kernel users aren't affected.

(And remember that we don't have to fill the whole buffer.  If it's
early boot and we're expecting crng_init to increment, we could
pregenerate less.)


