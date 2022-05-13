Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C394525949
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376311AbiEMBNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353878AbiEMBNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:13:31 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE25223090;
        Thu, 12 May 2022 18:13:30 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24D1CvAK014725
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 21:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652404379; bh=iImDbU3nUHMZt1YRnYGIy84xsDPh4wA9Mi8DNnLVB5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=DlGM2Q2EeXmU85fZY30sh5X4mBkUOMnZ6DgXZJ8/qWBC82SspXjsx9J5Jz22ayUhR
         DCiRge0tKsm4irq1xgZ1mRLaSjV+kD0odUHoWOiw+z8HC3+xCB6VS/R2gc4z9H2UPy
         tkaUyluznidv9oqSc85hQdeAa+QC/xP6BrxJmrqsR8ykXlgu1Bdo1UOQyrsol9kUui
         yVN/YFIN4VKAU1VUMf+q78DfKnIPgw1s2XxfT3WWiFJUKGhR4rMZVMlGeWfeJEHZKg
         f7R2pj5fkv042wOz6ZUEQ6wnTFt1QG7WnUxl8vWLEaT5oOqWjo7EcLN9aesDgBoVhQ
         sYI8EAP2PZIfw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A579A15C3F2A; Thu, 12 May 2022 21:12:57 -0400 (EDT)
Date:   Thu, 12 May 2022 21:12:57 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] random32: use real rng for non-deterministic randomness
Message-ID: <Yn2wmb/McCbhNaTb@mit.edu>
References: <20220511143257.88442-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220511143257.88442-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 04:32:57PM +0200, Jason A. Donenfeld wrote:
> random32.c has two RNGs in it: one that is meant to be used
> deterministically, with some predefined seed, and one that does the same
> exact thing as random.c, except does it poorly. The first one has some
> use cases. The second one no longer does and can be replaced with calls
> to random.c's proper random number generator.
> 
> The relatively recent siphash-based bad random32.c code was added in
> response to concerns that the prior random32.c was too deterministic.
> Out of fears that random.c was (at the time) too slow, this code was
> anonymously contributed by somebody who was likely reusing the alias of
> long time anonymous contributor George Spelvin. Then out of that emerged
> a kind of shadow entropy gathering system, with its own tentacles
> throughout various net code, added willy nilly.
> 
> Stop👏making👏crappy👏bespoke👏random👏number👏generators👏.
> 
> Fortunately, recently advances in random.c mean that we can stop playing
> with this sketchiness, and just use get_random_u32(), which is now fast
> enough. In micro benchmarks using RDPMC, I'm seeing the same median
> cycle count between the two functions, with the mean being _slightly_
> higher due to batches refilling (which we can optimize further need be).
> However, when doing *real* benchmarks of the net functions that actually
> use these random numbers, the mean cycles actually *decreased* slightly
> (with the median still staying the same), likely because the additional
> prandom code means icache misses and complexity, whereas random.c is
> generally already being used by something else nearby.
> 
> The biggest benefit of this is that there are many users of prandom who
> probably should be using cryptographically secure random numbers. This
> makes all of those accidental cases become secure by just flipping a
> switch. Later on, we can do a tree-wide cleanup to remove the static
> inline wrapper functions that this commit adds.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Yay!

Acked-by: Theodore Ts'o <tytso@mit.edu>

