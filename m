Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A744E647A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350688AbiCXN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350682AbiCXNzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:55:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9B23AA51;
        Thu, 24 Mar 2022 06:54:22 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648130061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bo4oh0xgueLYq/ZucSpzqDXmdQwXHyaJwvL+CGmcSVg=;
        b=n2mkfR5ErnTI17aWRsmxHA4JLR70o7LNo8nMWo2Hywde6OoRxPhE7FuBCehyVUYtmN1G3g
        LR69WNhbDCcQwHUYLpAxW19+Yc/BnbOU/OsuSluiKrwmemkwt6mR+R2itDPNa0/SXryA+B
        kCuS8YmjEQrNRnveOh/6t0UHL91YvI35yh2Pu6lqcJO8BJsbIOsDDUXFO2khgvrNNM0+9w
        jliDisJJX7RvpVHMGLBZEW83gKb8a7IiUz9oIeVSVCMotpU9dVh6fBO4kvchAtuQaFb7LW
        bG0sUHiw20ALTFPSI6hAg2iGJsbHDgHEWqn2n0kpsbXQygbXETVImIoVuGE4MA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648130061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bo4oh0xgueLYq/ZucSpzqDXmdQwXHyaJwvL+CGmcSVg=;
        b=PgKBGTgT2lglTNsJjTiAMUa7pDuUgUiyaQyd3SQh17Ir3RDl04oCLL//HuioEWtDSfDyJ5
        vBr0yD/TANvOkDCA==
To:     Artem Savkov <asavkov@redhat.com>, jpoimboe@redhat.com,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: Re: [PATCH 1/2] timer: introduce upper bound timers
In-Reply-To: <87tubn8rgk.ffs@tglx>
References: <20220323111642.2517885-1-asavkov@redhat.com>
 <20220323111642.2517885-2-asavkov@redhat.com> <87tubn8rgk.ffs@tglx>
Date:   Thu, 24 Mar 2022 14:54:21 +0100
Message-ID: <87h77ncv76.ffs@tglx>
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

On Thu, Mar 24 2022 at 13:28, Thomas Gleixner wrote:
> On Wed, Mar 23 2022 at 12:16, Artem Savkov wrote:
>> Add TIMER_UPPER_BOUND flag which allows creation of timers that would
>> expire at most at specified time or earlier.
>>
>> This was previously discussed here:
>> https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u
>
> please add the context to the changelog. A link is only supplemental
> information and does not replace content.
>
>>  static inline unsigned calc_index(unsigned long expires, unsigned lvl,
>> -				  unsigned long *bucket_expiry)
>> +				  unsigned long *bucket_expiry, bool upper_bound)
>>  {
>>  
>>  	/*
>> @@ -501,34 +501,39 @@ static inline unsigned calc_index(unsigned long expires, unsigned lvl,
>>  	 * - Truncation of the expiry time in the outer wheel levels
>>  	 *
>>  	 * Round up with level granularity to prevent this.
>> +	 * Do not perform round up in case of upper bound timer.
>>  	 */
>> -	expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
>> +	if (upper_bound)
>> +		expires = expires >> LVL_SHIFT(lvl);
>> +	else
>> +		expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
>
> While this "works", I fundamentally hate this because it adds an extra
> conditional into the common case. That affects every user of the timer
> wheel. We went great length to optimize that code and I'm not really enthused
> to sacrifice that just because of _one_ use case.

Aside of that this is not mathematically correct. Why?

The level selection makes the cutoff at: LEVEL_MAX(lvl) - 1. E.g. 62
instead of 63 for the first level.

The reason is that this accomodates for the + LVL_GRAN(lvl). Now with
surpressing the roundup this creates a gap. Not a horrible problem, but
not correct either.

Thanks,

        tglx
