Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138246C1B13
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjCTQQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjCTQQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:16:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734473C782;
        Mon, 20 Mar 2023 09:06:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679328356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AyDCO7N2ppOC05C0las5UuJq+nueZMUBCyexYIIKPmY=;
        b=hrGc4Cvn311NU3PnzhiSIj3KQwXMKZ3Ny3JxXvitBRthtHOUsb6yU7ExW8Aha8M0wLP2pm
        eGDrK2GHMSv2L8rgSeL1gLMplvl6daDoKD9KAq6ydespH8Yei2IZf8tVq/gDzsr9qwg5CC
        ivxgsOxMk7yu5IcgqASmWl3b69LD3FFaCEVFPbmgFXFQx/UdSLQrXlrFXnQIefPepPqwFw
        Abnyuztfy8rGVCWlCO9wbA0qF8/ghskkDCtcjLw84KtkViSaBZB1I+yBr4bwVi4QTozNVA
        EV7L1wYg6iN46Ky0u0aMHxODTluQWcojYvlR9cVglFOHXqYKiyKxhv7h9qgBEA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679328356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AyDCO7N2ppOC05C0las5UuJq+nueZMUBCyexYIIKPmY=;
        b=z6FhcyLURLraqANgSf0vbYG4Kx1hfWb12uYhwouzwCIC+vPlU0IOKQ+5EulwPdnQZR76S6
        u9BbZkqoCtWeNGAg==
To:     Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc:     arjan.van.de.ven@intel.com, arjan@linux.intel.com,
        boqun.feng@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, peterz@infradead.org,
        torvalds@linuxfoundation.org, wangyang.guo@intel.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [patch V2 3/4] atomics: Provide rcuref - scalable reference
 counting
In-Reply-To: <20230309083523.66592-1-qiuxu.zhuo@intel.com>
References: <20230307125538.932671660@linutronix.de>
 <20230309083523.66592-1-qiuxu.zhuo@intel.com>
Date:   Mon, 20 Mar 2023 17:05:56 +0100
Message-ID: <87o7on9zmj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qiuxu!

On Thu, Mar 09 2023 at 16:35, Qiuxu Zhuo wrote:

>> rcuref treats the underlying atomic_t as an unsigned integer and partitions
>> this space into zones:
>> 
>>   0x00000000 - 0x7FFFFFFF	valid zone (1 .. INT_MAX references)
>
> From the point of rcuref_read()'s view:
> 0x00000000 encodes 1, ...,  then 0x7FFFFFFF should encode INT_MAX + 1
> references.

orrect.

>> + * The actual race is possible due to the unconditional increment and
>> + * decrements in rcuref_get() and rcuref_put():
>> + *
>> + *	T1				T2
>> + *	get()				put()
>> + *					if (atomic_add_negative(1, &ref->refcnt))
>
> For T2 put() here:
> "if (atomic_add_negative(1, &ref->refcnt))" ->
> "if (atomic_add_negative(-1, &ref->refcnt))"

Yup.


>> + *		succeeds->			atomic_cmpxchg(&ref->refcnt, -1, DEAD);
>
> Is it more readable if 's/-1/NODEF/g' ?

True

>> + *	T1				T2
>> + *	put()				get()
>> + *	// ref->refcnt = ONEREF
>> + *	if (atomic_add_negative(-1, &ref->cnt))
>
> For T1 put() here:
> "if (atomic_add_negative(-1, &ref->cnt))" ->
> "if (!atomic_add_negative(-1, &ref->cnt))"

Indeed.

>> + *		return false;				<- Not taken
>> + *
>> + *	// ref->refcnt == NOREF
>> + *	--> preemption
>> + *					// Elevates ref->c to ONEREF
>
> s/ref->c/ref->refcnt/g

Yes.

>> + *					if (!atomic_add_negative(1, &ref->refcnt))
>> + *						return true;			<- taken
>> + *
>> + *					if (put(&p->ref)) { <-- Succeeds
>> + *						remove_pointer(p);
>> + *						kfree_rcu(p, rcu);
>> + *					}
>> + *
>> + *		RCU grace period ends, object is freed
>> + *
>> + *	atomic_cmpxchg(&ref->refcnt, NONE, DEAD);	<- UAF
>
> s/NONE/NOREF/g

Right. Thanks for spotting these details!

       Thomas
