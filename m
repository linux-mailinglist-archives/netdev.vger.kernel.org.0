Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7F15F2069
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJAWok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJAWoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C6526E8
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FE4660DD1
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9552C433C1;
        Sat,  1 Oct 2022 22:44:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jJP/YTjS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664664271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NNrTB57pfT7RujVBUZiGV0HukMfhesxKrJO7wSeGDzs=;
        b=jJP/YTjSPkDTL/uEB9F5XYpd1NkF4ue+FyvZbIhysgUjvbRtn5d4HmhbhiUDDDOrtnqLOB
        d+L5T3ZrABrSzggnMBNvO8sDoO8hSpvTRhmikZwf+66cpQmNRLkqp2AuqnbWwW97R0G8KK
        dxh0x5XOEGc2Bz44/pSJHOrKMVs4w+o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6fb174de (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 1 Oct 2022 22:44:30 +0000 (UTC)
Date:   Sun, 2 Oct 2022 00:44:28 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
Message-ID: <YzjCzGGGE3WUsQr0@zx2c4.com>
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221001205102.2319658-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 01:51:02PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Christophe Leroy reported a ~80ms latency spike
> happening at first TCP connect() time.
> 
> This is because __inet_hash_connect() uses get_random_once()
> to populate a perturbation table which became quite big
> after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> 
> get_random_once() uses DO_ONCE(), which block hard irqs for the duration
> of the operation.
> 
> This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> for operations where we prefer to stay in process context.
> 
> Then __inet_hash_connect() can use get_random_slow_once()
> to populate its perturbation table.
> 
> Fixes: 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
> Fixes: 190cc82489f4 ("tcp: change source port randomizarion at connect() time")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Link: https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#t
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> ---
>  include/linux/once.h       | 28 ++++++++++++++++++++++++++++
>  lib/once.c                 | 30 ++++++++++++++++++++++++++++++
>  net/ipv4/inet_hashtables.c |  4 ++--
>  3 files changed, 60 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/once.h b/include/linux/once.h
> index b14d8b309d52b198bb144689fe67d9ed235c2b3e..176ab75b42df740a738d04d8480821a0b3b65ba9 100644
> --- a/include/linux/once.h
> +++ b/include/linux/once.h
> @@ -5,10 +5,18 @@
>  #include <linux/types.h>
>  #include <linux/jump_label.h>
>  
> +/* Helpers used from arbitrary contexts.
> + * Hard irqs are blocked, be cautious.
> + */
>  bool __do_once_start(bool *done, unsigned long *flags);
>  void __do_once_done(bool *done, struct static_key_true *once_key,
>  		    unsigned long *flags, struct module *mod);
>  
> +/* Variant for process contexts only. */
> +bool __do_once_slow_start(bool *done);
> +void __do_once_slow_done(bool *done, struct static_key_true *once_key,
> +			 struct module *mod);
> +
>  /* Call a function exactly once. The idea of DO_ONCE() is to perform
>   * a function call such as initialization of random seeds, etc, only
>   * once, where DO_ONCE() can live in the fast-path. After @func has
> @@ -52,7 +60,27 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
>  		___ret;							     \
>  	})
>  
> +/* Variant of DO_ONCE() for process/sleepable contexts. */
> +#define DO_ONCE_SLOW(func, ...)						     \
> +	({								     \
> +		bool ___ret = false;					     \
> +		static bool __section(".data.once") ___done = false;	     \
> +		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
> +		if (static_branch_unlikely(&___once_key)) {		     \
> +			___ret = __do_once_slow_start(&___done);	     \
> +			if (unlikely(___ret)) {				     \
> +				func(__VA_ARGS__);			     \
> +				__do_once_slow_done(&___done, &___once_key,  \
> +						    THIS_MODULE);	     \
> +			}						     \
> +		}							     \
> +		___ret;							     \
> +	})
> +

Hmm, I dunno about this macro-choice explosion here. The whole thing
with DO_ONCE() is that the static branch makes it zero cost most of the
time while being somewhat expensive the rest of the time, but who cares,
because "the rest" is just once.

So instead, why not just branch on whether or not we can sleep here, if
that can be worked out dynamically? If not, and if you really do need
two sets of macros and functions, at least you can call the new one
something other than "slow"? Maybe something about being _SLEEPABLE()
instead?

Also, the __do_once_slow_done() function misses a really nice
optimization, which is that the static branch can be changed
synchronously instead of having to allocate and fire off that workqueue,
since by definition we're in sleepable context here.

Jason
