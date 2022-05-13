Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4B525B9D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344013AbiEMGc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbiEMGcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:32:55 -0400
X-Greylist: delayed 395 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 23:32:54 PDT
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966382A1896
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:32:54 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id AD3032013E7;
        Fri, 13 May 2022 06:26:05 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id C835E80957; Fri, 13 May 2022 08:18:53 +0200 (CEST)
Date:   Fri, 13 May 2022 08:18:53 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random32: use real rng for non-deterministic randomness
Message-ID: <Yn34Tf4CpSaZBlGi@owl.dominikbrodowski.net>
References: <20220511143257.88442-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220511143257.88442-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, May 11, 2022 at 04:32:57PM +0200 schrieb Jason A. Donenfeld:
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
> ---
> Jakub - If there are no objections to this plan, I intend on taking this
> through the random.git tree, which is what this commit is based on, with
> its recent siphash changes and such. -Jason

Nice! However, wouldn't it be much better to clean up the indirection
introduced here as well? prandom_u32() as wrapper for get_random_u32() and
prandom_bytes() as wrapper for get_random_bytes() seems unnecessary...

Thanks,
	Dominik
