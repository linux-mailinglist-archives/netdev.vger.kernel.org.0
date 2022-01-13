Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E329248DCEF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbiAMR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:29:11 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53932 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231404AbiAMR3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:29:11 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 20DHSnc0019461
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:28:50 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8D35415C40F6; Thu, 13 Jan 2022 12:28:49 -0500 (EST)
Date:   Thu, 13 Jan 2022 12:28:49 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH RFC v1 0/3] remove remaining users of SHA-1
Message-ID: <YeBhUTPkmAnLQSzm@mit.edu>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <CACXcFmkauHRkTdD1zkr9QRCwG-uD8=7q9=Wk0_VFueRy-Oy+Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmkauHRkTdD1zkr9QRCwG-uD8=7q9=Wk0_VFueRy-Oy+Nw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 11:24:10AM +0800, Sandy Harris wrote:
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > There are currently two remaining users of SHA-1 left in the kernel: bpf
> > tag generation, and ipv6 address calculation.
> 
> I think there are three, since drivers/char/random.c also uses it.

This was changed as of commit 9f9eff85a008 ("random: use BLAKE2s
instead of SHA1 in extraction"), which just landed in Linus's tree.

> Moreover, there's some inefficiency there (or was last time I
> looked) since it produces a 160-bit hash then folds it in half
> to give an 80-bit output.

This dates back to very early days of the /dev/random driver, back
when all that was known about SHA-1 was that it was designed by the
NSA using classified design principles, and it had not yet been as
well studied outside of the halls of the NSA.  So folding the SHA-1
hash in half was done deliberately, since at the time, performance was
*not* the primary goal; security was.

(This was also back in the days when encryption algorithms would run
you into export control difficulties, since this is around the times
when the source code of PGP was being published in an OCR font with a
barcode containing the checksum of the content of every single page
was being published by the MIT press, and we were publishing Kerberos
with all of the *calls* to the crypto stripped out and calling it
"Bones" since there were assertions that code that *called*
cryptographic algoriothms might be subject to export control, even if
it didn't have any crypto algorithms in the program themselves.  This
is also why HMAC-based constructions were so popular.  People seem to
forget how much things have changed since the late 1980's....)

       	   	       	    	    	  - Ted
