Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302F823F899
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgHHTSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 15:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgHHTSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 15:18:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D217C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 12:18:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k4UMN-0002T8-NW; Sat, 08 Aug 2020 21:18:27 +0200
Date:   Sat, 8 Aug 2020 21:18:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808191827.GA19310@breakpoint.cc>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808174451.GA7429@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy Tarreau <w@1wt.eu> wrote:
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 9ab7443bd91b..9e22973b207c 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -12,6 +12,7 @@
>  #include <linux/list.h>
>  #include <linux/once.h>
>  #include <asm/percpu.h>
> +#include <linux/siphash.h>
>  
>  #include <uapi/linux/random.h>
>  
> @@ -117,7 +118,8 @@ void prandom_seed(u32 seed);
>  void prandom_reseed_late(void);
>  
>  struct rnd_state {
> -	__u32 s1, s2, s3, s4;
> +	siphash_key_t key;
> +	uint64_t counter;
>  };

Does the siphash_key really need to be percpu?
The counter is different of course.
Alternative would be to siphash a few prandom_u32 results
if the extra u64 is too much storage.

>  DECLARE_PER_CPU(struct rnd_state, net_rand_state);
> @@ -161,12 +163,14 @@ static inline u32 __seed(u32 x, u32 m)
>   */
>  static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
>  {
> +#if 0
>  	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
>  
>  	state->s1 = __seed(i,   2U);
>  	state->s2 = __seed(i,   8U);
>  	state->s3 = __seed(i,  16U);
>  	state->s4 = __seed(i, 128U);
> +#endif
>  }
[..]

Can't we keep prandom_u32 as-is...?  Most of the usage, esp. in the
packet schedulers, is fine.

I'd much rather have a prandom_u32_hashed() or whatever for
those cases where some bits might leak to the outside and then convert
those prandom_u32 users over to the siphashed version.

