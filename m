Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F254E635E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350184AbiCXMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350145AbiCXMaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:30:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1F190CC6;
        Thu, 24 Mar 2022 05:28:45 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648124923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5rsG9toEvk+yv0gvFyF46EXgKfcd55pOCxUTFUIEcfQ=;
        b=R1T7Yi+S3DRcHjAkDL6FAu+WD4xDL9h6QDVV9r1zrxBMKCxTmNj92NHeTR3Sj8/8Yd2wOf
        HUZiaSZibfiUvWdtXuVrL6pVX0yVKUW3Tqho59Ma3l3y/j7ooKiFxextaYh/mTtKUfs4nd
        s+zmqDCy0qBDHN8TpJr3NG/y1bzx/E07jHylrW7GpKYAI9Fqf0dptXMJt+MIXkDiNeslqn
        yqi1zVk1euW8Cll+ilmXsU4hYZaB3kA6lBeICbnJTYySwxZU+jvdYFIYtw1oC0ZabQcrk/
        asYqfcETKpBjXekVLkofpACguSVfCKjuap7DsNJGOy5HmTqHJ6tAxA6KdbDrjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648124923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5rsG9toEvk+yv0gvFyF46EXgKfcd55pOCxUTFUIEcfQ=;
        b=wPFJ2ajHVQdzMUlIDIjJVhzfn5miyQF8sblkaQT1znvApVNRq2fffqyPxzSB705UabvkKN
        YUnvHEYMnhuhVxAQ==
To:     Artem Savkov <asavkov@redhat.com>, jpoimboe@redhat.com,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: Re: [PATCH 1/2] timer: introduce upper bound timers
In-Reply-To: <20220323111642.2517885-2-asavkov@redhat.com>
References: <20220323111642.2517885-1-asavkov@redhat.com>
 <20220323111642.2517885-2-asavkov@redhat.com>
Date:   Thu, 24 Mar 2022 13:28:43 +0100
Message-ID: <87tubn8rgk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Artem,

On Wed, Mar 23 2022 at 12:16, Artem Savkov wrote:
> Add TIMER_UPPER_BOUND flag which allows creation of timers that would
> expire at most at specified time or earlier.
>
> This was previously discussed here:
> https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

please add the context to the changelog. A link is only supplemental
information and does not replace content.

>  static inline unsigned calc_index(unsigned long expires, unsigned lvl,
> -				  unsigned long *bucket_expiry)
> +				  unsigned long *bucket_expiry, bool upper_bound)
>  {
>  
>  	/*
> @@ -501,34 +501,39 @@ static inline unsigned calc_index(unsigned long expires, unsigned lvl,
>  	 * - Truncation of the expiry time in the outer wheel levels
>  	 *
>  	 * Round up with level granularity to prevent this.
> +	 * Do not perform round up in case of upper bound timer.
>  	 */
> -	expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
> +	if (upper_bound)
> +		expires = expires >> LVL_SHIFT(lvl);
> +	else
> +		expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);

While this "works", I fundamentally hate this because it adds an extra
conditional into the common case. That affects every user of the timer
wheel. We went great length to optimize that code and I'm not really enthused
to sacrifice that just because of _one_ use case.

The resulting text bloat is +25% on x86/64 and a quick test case shows
that this is well measurable overhead. The first ones who will complain
about that are going to be - drumroll - the network people.

There must be smarter ways to solve that. Let me think about it.

Thanks,

        tglx
