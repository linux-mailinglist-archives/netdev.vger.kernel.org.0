Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2344B3AB6
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 11:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiBMKCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 05:02:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiBMKCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 05:02:47 -0500
X-Greylist: delayed 2580 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 02:02:41 PST
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FAD55D181
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 02:02:41 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21D9GKNV030588;
        Sun, 13 Feb 2022 03:16:20 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21D9GJKW030587;
        Sun, 13 Feb 2022 03:16:19 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Sun, 13 Feb 2022 03:16:19 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "'Christophe Leroy'" <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Remove branch in csum_shift()
Message-ID: <20220213091619.GY614@gate.crashing.org>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu> <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 02:39:06AM +0000, David Laight wrote:
> From: Christophe Leroy
> > Sent: 11 February 2022 08:48
> > 
> > Today's implementation of csum_shift() leads to branching based on
> > parity of 'offset'
> > 
> > 	000002f8 <csum_block_add>:
> > 	     2f8:	70 a5 00 01 	andi.   r5,r5,1
> > 	     2fc:	41 a2 00 08 	beq     304 <csum_block_add+0xc>
> > 	     300:	54 84 c0 3e 	rotlwi  r4,r4,24
> > 	     304:	7c 63 20 14 	addc    r3,r3,r4
> > 	     308:	7c 63 01 94 	addze   r3,r3
> > 	     30c:	4e 80 00 20 	blr
> > 
> > Use first bit of 'offset' directly as input of the rotation instead of
> > branching.
> > 
> > 	000002f8 <csum_block_add>:
> > 	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
> > 	     2fc:	20 a5 00 20 	subfic  r5,r5,32
> > 	     300:	5c 84 28 3e 	rotlw   r4,r4,r5
> > 	     304:	7c 63 20 14 	addc    r3,r3,r4
> > 	     308:	7c 63 01 94 	addze   r3,r3
> > 	     30c:	4e 80 00 20 	blr
> > 
> > And change to left shift instead of right shift to skip one more
> > instruction. This has no impact on the final sum.
> > 
> > 	000002f8 <csum_block_add>:
> > 	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
> > 	     2fc:	5c 84 28 3e 	rotlw   r4,r4,r5
> > 	     300:	7c 63 20 14 	addc    r3,r3,r4
> > 	     304:	7c 63 01 94 	addze   r3,r3
> > 	     308:	4e 80 00 20 	blr
> 
> That is ppc64.

That is 32-bit powerpc.

> What happens on x86-64?
> 
> Trying to do the same in the x86 ipcsum code tended to make the code worse.
> (Although that test is for an odd length fragment and can just be removed.)

In an ideal world the compiler could choose the optimal code sequences
everywhere.  But that won't ever happen, the search space is way too
big.  So compilers just use heuristics, not exhaustive search like
superopt does.  There is a middle way of course, something with directed
searches, and maybe in a few decades systems will be fast enough.  Until
then we will very often see code that is 10% slower and 30% bigger than
necessary.  A single insn more than needed isn't so bad :-)

Making things branch-free is very much worth it here though!


Segher
