Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9B6525816
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359356AbiELXFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359343AbiELXFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023AABE1;
        Thu, 12 May 2022 16:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C11162013;
        Thu, 12 May 2022 23:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E2CC385B8;
        Thu, 12 May 2022 23:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652396741;
        bh=7mTtf2SBQWjuZujeQe3659n0cchdS+tb6XYeZbaFeDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C2zCxyvSsJFuOMCEyiESWPfaL0YeizXzOmkmRanVacrMbqvxRqnhuWUwZsqRJwkcE
         JsVEWzBTkBkR5o6LFEGxlA/g+LQCYrCXs76JJaA5kYjyLRz9P3NtjqHSxit5WpJZ5I
         RNQGNxR+nh/gMzLKzd+zeb9VT9XaVlPQhL91QRmwRq0w6NXjcS1C26C7ddaZAr4F1o
         RORpcwJ1aZxnXPVW7rkU5PA1lkUlWMyluPyBK6bbNni4Y6s/UdOaWv+zxCGo9NgJ35
         wOV0kmwYT1CUbmPhlbla84Y0qvPbqxoLas8P2Vm41ak/3InIm6bL9Z3i229e5c6PRH
         tgZZuPOXBpMow==
Date:   Thu, 12 May 2022 16:05:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random32: use real rng for non-deterministic randomness
Message-ID: <20220512160540.255ddd88@kernel.org>
In-Reply-To: <20220511143257.88442-1-Jason@zx2c4.com>
References: <20220511143257.88442-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 16:32:57 +0200 Jason A. Donenfeld wrote:
> random32.c has two RNGs in it: one that is meant to be used
> deterministically, with some predefined seed, and one that does the same
> exact thing as random.c, except does it poorly. The first one has some
> use cases. The second one no longer does and can be replaced with calls
> to random.c's proper random number generator.
>=20
> The relatively recent siphash-based bad random32.c code was added in
> response to concerns that the prior random32.c was too deterministic.
> Out of fears that random.c was (at the time) too slow, this code was
> anonymously contributed by somebody who was likely reusing the alias of
> long time anonymous contributor George Spelvin. Then out of that emerged
> a kind of shadow entropy gathering system, with its own tentacles
> throughout various net code, added willy nilly.
>=20
> Stop=F0=9F=91=8Fmaking=F0=9F=91=8Fcrappy=F0=9F=91=8Fbespoke=F0=9F=91=8Fra=
ndom=F0=9F=91=8Fnumber=F0=9F=91=8Fgenerators=F0=9F=91=8F.
>=20
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
>=20
> The biggest benefit of this is that there are many users of prandom who
> probably should be using cryptographically secure random numbers. This
> makes all of those accidental cases become secure by just flipping a
> switch. Later on, we can do a tree-wide cleanup to remove the static
> inline wrapper functions that this commit adds.
>=20
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Jakub - If there are no objections to this plan, I intend on taking this
> through the random.git tree, which is what this commit is based on, with
> its recent siphash changes and such. -Jason

Acked-by: Jakub Kicinski <kuba@kernel.org>

I wish there was a good way to anycast to subsystem maintainers.
With 4 netdev maintainers now even name smooshing won't work.
