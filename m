Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF216358EC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiKWKFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiKWKE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:04:26 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C0116057;
        Wed, 23 Nov 2022 01:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0cYrYJ63JcoWuFpltXlh9I/Ds9FjL9eWbh2RaLh+/iw=; b=pR8MVsxftq/T47+/sGUDSeuMAt
        KWW16+tL1UeTsRurldFHHT0kphQwBFS2Bac1ceibqPPKtWIxq7Ka0FhWE2sShj88xfdWbOPqWxV1j
        u45nfQQYx7DfAZwVCcDEbltiP7VgtdCksrUWlmpK4cyo0nvbCsoGwFvhAc57e6Octy6TU0GRsxBSW
        CXGwkPKFDRWStw/ql5jS3wh7/ALuyZoNHh0j1Kdf9E63ji5UJJDUj4ZcDBtz/DKq4lXPdKwbYKdkY
        xybjeeo/Q3uc2It+xMbjH4ILdHjjS/HlIz+97zXirMzO3vw3mGEEoK1/5tFKsTctZQ7XuV7iVHYNE
        MVDhhQrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxmTa-003kIE-K9; Wed, 23 Nov 2022 09:55:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26AC9300202;
        Wed, 23 Nov 2022 10:55:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07B532C24761D; Wed, 23 Nov 2022 10:55:29 +0100 (CET)
Date:   Wed, 23 Nov 2022 10:55:28 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/5] jump_label: Prevent key->enabled int overflow
Message-ID: <Y33uEHIHwPZ/5IiA@hirez.programming.kicks-ass.net>
References: <20221122185534.308643-1-dima@arista.com>
 <20221122185534.308643-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122185534.308643-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:55:30PM +0000, Dmitry Safonov wrote:

> +/***
> + * static_key_fast_inc_not_negative - adds a user for a static key
> + * @key: static key that must be already enabled
> + *
> + * The caller must make sure that the static key can't get disabled while
> + * in this function. It doesn't patch jump labels, only adds a user to
> + * an already enabled static key.
> + *
> + * Returns true if the increment was done.
> + */

I don't normally do kerneldoc style comments, and this is the first in
the whole file. The moment I get a docs person complaining about some
markup issue I just take the ** off.

> +static bool static_key_fast_inc_not_negative(struct static_key *key)
>  {
> +	int v;
> +
>  	STATIC_KEY_CHECK_USE(key);
> +	/*
> +	 * Negative key->enabled has a special meaning: it sends
> +	 * static_key_slow_inc() down the slow path, and it is non-zero
> +	 * so it counts as "enabled" in jump_label_update().  Note that
> +	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
> +	 */
> +	v = atomic_read(&key->enabled);
> +	do {
> +		if (v <= 0 || (v + 1) < 0)
> +			return false;
> +	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
> +
> +	return true;
> +}

( vexing how this function and the JUMP_LABEL=n static_key_slow_inc() are
  only a single character different )

So while strictly accurate, I dislike this name (and I see I was not
quick enough responding to your earlier suggestion :/). The whole
negative thing is an implementation detail that should not spread
outside of jump_label.c.

Since you did not like the canonical _inc_not_zero(), how about
inc_not_disabled() ?

Also, perhaps expose this function in this patch, instead of hiding that
in patch 3?



Otherwise, things look good.

Thanks!
