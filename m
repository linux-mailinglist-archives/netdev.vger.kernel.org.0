Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C846268B8
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiKLKES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLKEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:04:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC221036;
        Sat, 12 Nov 2022 02:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ez8m6w6iQrAp/mWVBLnC1dNjSrOykO/kHBz8bMMeI+A=; b=KSweJXMChimGzsabGzugV+tCvl
        NGLBFkMYvhz7NK56g7ZIX+UVB17n6oSafpOSmqGdAD4ZEmyNS76MEp/u1KJvBmaGUQ2pyF0FggUCv
        wxfUSecINLjPzwmvrFlkDPRBfbBz2VUBVnP/Q6xs4fIEK4VSszfmVYqViLIY3UcqNtatIa36Hag6a
        BKHF4Nk2ejW0eq7dOsdKGIYE3dAjzpxmzWVLJrFUkOENKKkRYP7pCUiPyJ4pqhMT89Bw7nrQngYJN
        VzWeSOtd+StU0JwxTzfaKBRSJeUH3O5sYX+MwqiylJMiMa9v/zoeBpCf9vkTG1Mc906pQB8KHESdS
        3392JewQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otnMk-00Dnrr-CS; Sat, 12 Nov 2022 10:03:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3828B3002EC;
        Sat, 12 Nov 2022 11:03:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0C6052C76E5D5; Sat, 12 Nov 2022 11:03:50 +0100 (CET)
Date:   Sat, 12 Nov 2022 11:03:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 1/3] jump_label: Prevent key->enabled int overflow
Message-ID: <Y29vhZ7dWtrlIMAz@hirez.programming.kicks-ass.net>
References: <20221111212320.1386566-1-dima@arista.com>
 <20221111212320.1386566-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111212320.1386566-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 09:23:18PM +0000, Dmitry Safonov wrote:
> 1. With CONFIG_JUMP_LABEL=n static_key_slow_inc() doesn't have any
>    protection against key->enabled refcounter overflow.
> 2. With CONFIG_JUMP_LABEL=y static_key_slow_inc_cpuslocked()
>    still may turn the refcounter negative as (v + 1) may overflow.
> 
> key->enabled is indeed a ref-counter as it's documented in multiple
> places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
> etc.
> 
> As -1 is reserved for static key that's in process of being enabled,
> functions would break with negative key->enabled refcount:
> - for CONFIG_JUMP_LABEL=n negative return of static_key_count()
>   breaks static_key_false(), static_key_true()
> - the ref counter may become 0 from negative side by too many
>   static_key_slow_inc() calls and lead to use-after-free issues.
> 
> These flaws result in that some users have to introduce an additional
> mutex and prevent the reference counter from overflowing themselves,
> see bpf_enable_runtime_stats() checking the counter against INT_MAX / 2.

Urgh,. nothing like working around defects instead of fixing them I
suppose :/

> Prevent the reference counter overflow by checking if (v + 1) > 0.
> Change functions API to return whether the increment was successful.
> 
> While at here, provide static_key_fast_inc() helper that does ref
> counter increment in atomic fashion (without grabbing cpus_read_lock()
> on CONFIG_JUMP_LABEL=y). This is needed to add a new user for

-ENOTHERE, did you forget to Cc me on all patches?

> a static_key when the caller controls the lifetime of another user.
> The exact detail where it will be used: if a listen socket with TCP-MD5
> key receives SYN packet that passes the verification and in result
> creates a request socket - it's all done from RX softirq. At that moment
> userspace can't lock the listen socket and remove that TCP-MD5 key, so
> the tcp_md5_needed static branch can't get disabled. But the refcounter
> of the static key needs to be adjusted to account for a new user
> (the request socket).

Arguably all this should be a separate patch. Also I'm hoping the caller
does something like WARN on failure?


> -static inline void static_key_slow_inc(struct static_key *key)
> +static inline bool static_key_fast_inc(struct static_key *key)
>  {
> +	int v, v1;
> +
>  	STATIC_KEY_CHECK_USE(key);
> -	atomic_inc(&key->enabled);
> +	/*
> +	 * Prevent key->enabled getting negative to follow the same semantics
> +	 * as for CONFIG_JUMP_LABEL=y, see kernel/jump_label.c comment.
> +	 */
> +	for (v = atomic_read(&key->enabled); v >= 0 && (v + 1) > 0; v = v1) {
> +		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
> +		if (likely(v1 == v))
> +			return true;
> +	}


Please, use atomic_try_cmpxchg(), it then turns into something like:

	int v = atomic_read(&key->enabled);

	do {
		if (v < 0 || (v + 1) < 0)
			return false;
	} while (!atomic_try_cmpxchg(&key->enabled, &v, v + 1))

	return true;

> +	return false;
>  }
> +#define static_key_slow_inc(key)	static_key_fast_inc(key)
>  
>  static inline void static_key_slow_dec(struct static_key *key)
>  {
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 714ac4c3b556..f2c1aa351d41 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -113,11 +113,38 @@ int static_key_count(struct static_key *key)
>  }
>  EXPORT_SYMBOL_GPL(static_key_count);
>  
> -void static_key_slow_inc_cpuslocked(struct static_key *key)
> +/***
> + * static_key_fast_inc - adds a user for a static key
> + * @key: static key that must be already enabled
> + *
> + * The caller must make sure that the static key can't get disabled while
> + * in this function. It doesn't patch jump labels, only adds a user to
> + * an already enabled static key.
> + *
> + * Returns true if the increment was done.
> + */
> +bool static_key_fast_inc(struct static_key *key)

Typically this primitive is called something_inc_not_zero().

>  {
>  	int v, v1;
>  
>  	STATIC_KEY_CHECK_USE(key);
> +	/*
> +	 * Negative key->enabled has a special meaning: it sends
> +	 * static_key_slow_inc() down the slow path, and it is non-zero
> +	 * so it counts as "enabled" in jump_label_update().  Note that
> +	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
> +	 */
> +	for (v = atomic_read(&key->enabled); v > 0 && (v + 1) > 0; v = v1) {
> +		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
> +		if (likely(v1 == v))
> +			return true;
> +	}

Idem on atomic_try_cmpxchg().

> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(static_key_fast_inc);
> +
> +bool static_key_slow_inc_cpuslocked(struct static_key *key)
> +{
>  	lockdep_assert_cpus_held();
>  
>  	/*
> @@ -126,17 +153,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
>  	 * jump_label_update() process.  At the same time, however,
>  	 * the jump_label_update() call below wants to see
>  	 * static_key_enabled(&key) for jumps to be updated properly.
> -	 *
> -	 * So give a special meaning to negative key->enabled: it sends
> -	 * static_key_slow_inc() down the slow path, and it is non-zero
> -	 * so it counts as "enabled" in jump_label_update().  Note that
> -	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
>  	 */
> -	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
> -		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
> -		if (likely(v1 == v))
> -			return;
> -	}

This does not in fact apply, since someone already converted to try_cmpxchg.

