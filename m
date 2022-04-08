Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFFB4F8B98
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiDHAjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 20:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiDHAjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 20:39:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE78108BED;
        Thu,  7 Apr 2022 17:37:28 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649378246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=v8wAVqTjtr3S+yNv24Qoju4enrtKRg9Vl4AVQdzomKw=;
        b=EMhH88jCeXdBb1SKvMaZwP6woFbq2hzV0FAO3tm1K9W1Upm0GFyR+9p7LY0jhTcEra8UlP
        Z8rAb+JxBHZpZBq7+l3VMyr84gBs4Khq/9tCFMsboYlFJp9d8MmEoyv5XW31TpnbsnUOkt
        3CkV014aq4TYNi8CFJB4XyTdQZrIadAGOo7Zx8nB/yUvxgHNOrC9ffZgHug/ZZV0LVJ/Do
        dT/gys9+jRQiQTki4Q31k/Ye/f2xWLRFbZLlSXkJL7oWca/RItkDw5TriDM4sLOUb0M/rH
        41UbjLf2EaC2yQDiCv+mzWhZL3erlEdwl9dcaenFxtO1nG8dwiyDhlnTrudrTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649378246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=v8wAVqTjtr3S+yNv24Qoju4enrtKRg9Vl4AVQdzomKw=;
        b=l+aIohejJ8RgDSgG7Yq473re5HP4cGl8sszvF4o4IpgtFIq89KPjotDtzACMNeGJIJH38R
        pUUKwix4YDTBIGDg==
To:     Artem Savkov <asavkov@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: Re: [PATCH v4 1/2] timer: add a function to adjust timeouts to be
 upper bound
In-Reply-To: <20220407075242.118253-2-asavkov@redhat.com>
Date:   Fri, 08 Apr 2022 02:37:25 +0200
Message-ID: <87zgkwjtq2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07 2022 at 09:52, Artem Savkov wrote:
> Current timer wheel implementation is optimized for performance and
> energy usage but lacks in precision. This, normally, is not a problem as
> most timers that use timer wheel are used for timeouts and thus rarely
> expire, instead they often get canceled or modified before expiration.
> Even when they don't, expiring a bit late is not an issue for timeout
> timers.
>
> TCP keepalive timer is a special case, it's aim is to prevent timeouts,
> so triggering earlier rather than later is desired behavior. In a
> reported case the user had a 3600s keepalive timer for preventing firewall
> disconnects (on a 3650s interval). They observed keepalive timers coming
> in up to four minutes late, causing unexpected disconnects.
>
> This commit adds upper_bound_timeout() function that takes a relative

s/This commit adds/Add a new function to ..../

See Documentation/process/*

> timeout and adjusts it based on timer wheel granularity so that supplied
> value effectively becomes an upper bound for the timer.
>  
> -static int calc_wheel_index(unsigned long expires, unsigned long clk,
> -			    unsigned long *bucket_expiry)
> +static inline int get_wheel_lvl(unsigned long delta)
>  {
> -	unsigned long delta = expires - clk;
> -	unsigned int idx;
> -
>  	if (delta < LVL_START(1)) {
> -		idx = calc_index(expires, 0, bucket_expiry);
> +		return 0;
>  	} else if (delta < LVL_START(2)) {

Can you please get rid of all those brackets?

> +	return -1;
> +}
> +
> +static int calc_wheel_index(unsigned long expires, unsigned long clk,
> +			    unsigned long *bucket_expiry)
> +{
> +	unsigned long delta = expires - clk;
> +	unsigned int idx;
> +	int lvl = get_wheel_lvl(delta);
> +
> +	if (lvl >= 0) {
> +		idx = calc_index(expires, lvl, bucket_expiry);
>  	} else if ((long) delta < 0) {
>  		idx = clk & LVL_MASK;
>  		*bucket_expiry = clk;
> @@ -545,6 +555,38 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
>  	return idx;
>  }

This generates horrible code on various compilers. I ran that through a
couple of perf test scenarios and came up with the following, which
still is a tad slower for the level 0 case depending on the branch
predictor state. But it at least prevents the compilers from doing
stupid things and on average it's on par.

Though the level 0 case matters because of *drumroll* networking.

static int calc_wheel_index(unsigned long expires, unsigned long clk,
			    unsigned long *bucket_expiry)
{
	unsigned long delta = expires - clk;
	int lvl = get_wheel_lvl(delta);

	if (likely(lvl) >= 0)
		return __calc_index(expires, lvl, bucket_expiry);

	if ((long) delta < 0) {
		*bucket_expiry = clk;
		return clk & LVL_MASK;
	}

	/*
	 * Force expire obscene large timeouts to expire at the capacity
	 * limit of the wheel.
	 */
	if (delta >= WHEEL_TIMEOUT_CUTOFF)
		expires = clk + WHEEL_TIMEOUT_MAX;

	return __calc_index(expires, LVL_DEPTH - 1, bucket_expiry);
}

Just for the record. I told you last time that your patch creates a
measurable overhead and I explained you in depth why the performance of
this stupid thing matters. So why are you not providing a proper
analysis for that?

> +/**
> + * upper_bound_timeout - return granularity-adjusted timeout
> + * @timeout: timeout value in jiffies
> + *
> + * This function return supplied timeout adjusted based on timer wheel
> + * granularity effectively making supplied value an upper bound at which the
> + * timer will expire. Due to the way timer wheel works timeouts smaller than
> + * LVL_GRAN on their respecrive levels will be _at least_
> + * LVL_GRAN(lvl) - LVL_GRAN(lvl -1)) jiffies early.

Contrary to the simple "timeout - timeout/8" this gives better accuracy
as it does not converge to the early side for long timeouts.

With the quirk that this cuts timeout=1 to 0, which means it expires
immediately. The wonders of integer math avoid that with the simple
timeout -= timeout >> 3 approach for timeouts up to 8 ticks. :)

But that want's to be properly documented.

> +unsigned long upper_bound_timeout(unsigned long timeout)
> +{
> +	int lvl = get_wheel_lvl(timeout);

which is equivalent to:

         lvl = calc_wheel_index(timeout, 0, &dummy) >> LVL_BITS;

Sorry, could not resist. :)

The more interesting question is, how frequently this upper bounds
function is used. It's definitely not something which you want to
inflict onto a high frequency (re)arming timer.

Did you analyse that? And if so, then why is that analysis missing from
the change log of the keepalive timer patch?

Aside of that it clearly lacks any argument why the simple, stupid, but
fast approach of shortening the timeout by 12.5% is not good enough and
why we need yet another function which is just going to be another
source of 'optimizations' for the wrong reasons.

Seriously, I apprecitate that you want to make this 'perfect', but it's
never going to be perfect and the real question is whether there is any
reasonable difference between 'good' and almost 'perfect'.

And this clearly resonates in your changelog of the network patch:

 "Make sure TCP keepalive timer does not expire late. Switching to upper
  bound timers means it can fire off early but in case of keepalive
  tcp_keepalive_timer() handler checks elapsed time and resets the timer
  if it was triggered early. This results in timer "cascading" to a
  higher precision and being just a couple of milliseconds off it's
  original mark."

Which reinvents the cascading effect of the original timer wheel just
with more overhead. Where is the justification for this?

Is this really true for all the reasons where the keep alive timers are
armed? I seriously doubt that. Why?

On the end which waits for the keep alive packet to arrive in time it
does not matter at all, whether the cutoff is a bit later than defined.

     So why do you want to let the timer fire early just to rearm it? 

But it matters a lot on the sender side. If that is late and the other
end is strict about the timeout then you lost. But does it matter
whether you send the packet too early? No, it does not matter at all
because the important point is that you send it _before_ the other side
decides to give up.

     So why do you want to let the timer fire precise?

You are solving the sender side problem by introducing a receiver side
problem and both suffer from the overhead for no reason.

Aside of the theoerical issue why this matters at all I have yet ot see
a reasonable argument what the practical problen is. If this would be a
real problem in the wild then why haven't we ssen a reassonable bug
report within 6 years?

Thanks,

        tglx
