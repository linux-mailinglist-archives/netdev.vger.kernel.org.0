Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D431BA13
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 14:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhBONN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 08:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhBONNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 08:13:50 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9CDC061574;
        Mon, 15 Feb 2021 05:13:07 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lBdgE-003Frr-1U; Mon, 15 Feb 2021 14:12:46 +0100
Message-ID: <79aeb83a288051bd3a2a3f15e5ac42e06f154d48.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 15 Feb 2021 14:12:30 +0100
In-Reply-To: <20210215104402.GC4507@worktop.programming.kicks-ass.net> (sfid-20210215_114645_090502_64B4A89D)
References: <cover.1613171185.git.skhan@linuxfoundation.org>
         <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
         <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
         <20210215104402.GC4507@worktop.programming.kicks-ass.net>
         (sfid-20210215_114645_090502_64B4A89D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-15 at 11:44 +0100, Peter Zijlstra wrote:
> 
> I think something like so will work, but please double check.

Yeah, that looks better.

> +++ b/include/linux/lockdep.h
> @@ -294,11 +294,15 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
>  
>  #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
>  
> -#define lockdep_assert_held(l)	do {				\
> -		WARN_ON(debug_locks && !lockdep_is_held(l));	\
> +#define lockdep_assert_held(l)	do {					\
> +		WARN_ON(debug_locks && lockdep_is_held(l) == 0));	\
>  	} while (0)

That doesn't really need to change? It's the same.

> -#define lockdep_assert_held_write(l)	do {			\
> +#define lockdep_assert_not_held(l)	do {				\
> +		WARN_ON(debug_locks && lockdep_is_held(l) == 1));	\
> +	} while (0)
> +
> +#define lockdep_assert_held_write(l)	do {				\
>  		WARN_ON(debug_locks && !lockdep_is_held_type(l, 0));	\
>  	} while (0)
>  
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index c1418b47f625..983ba206f7b2 100644
> --- a/kernel/locking/lockdep.
> +++ b/kernel/locking/lockdep.c
> @@ -5467,7 +5467,7 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
>  	int ret = 0;
>  
>  	if (unlikely(!lockdep_enabled()))
> -		return 1; /* avoid false negative lockdep_assert_held() */
> +		return -1; /* avoid false negative lockdep_assert_held() */

Maybe add lockdep_assert_not_held() to the comment, to explain the -1
(vs non-zero)?

johannes

