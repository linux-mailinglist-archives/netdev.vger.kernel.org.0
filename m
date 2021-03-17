Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEBD33F251
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCQOK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCQOK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:10:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D182FC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:10:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615990255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1vQ9YBqfyGFcRgecDoV4jQS1bBK9A29s4WUuP0E3ctE=;
        b=igfxW4lUB3qrHBVnzdW6pHNuSB3x3UUfVD6hRMKbXGqtnwNfXaFYYsAfew73WbQBIpMpaJ
        rPY9/Id5+B1uQwqxiKq5rVD9owcsr+V0ekieG/6nGxNWVRXW0HkB2+uJKHcX7XqkliM1s1
        MVslfbmCwO0NAQOf2ndtpLWYv9h19fU9jKgVBA01UITJ54KFM2Hts9IzPEhK9Xv993Fr9V
        +zc0tCZVi91iC65Ycw5Z6/PX+VNxqpRwuEiPI+fsiZzOeDL2MUOHxP2UgVqFkimefJ6H6O
        Qo2OsbOr6jg70V/iUhWFpWXaD9eTvq8albGhbE/GFjwUvOF7Bv9M54U25WeMfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615990255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1vQ9YBqfyGFcRgecDoV4jQS1bBK9A29s4WUuP0E3ctE=;
        b=rLh2280T9sXISRB3eJxMVQx5BTcPec5O6XLO9W7TZ23ixElxcHFbgtPi+qFsi68oYM5hNv
        oTCcT809NIIdm/Dg==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in softirq context with `threadirqs'
In-Reply-To: <20200416135938.jiglv4ctjayg5qmg@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de> <20191126222013.1904785-3-bigeasy@linutronix.de> <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com> <20191127093521.6achiubslhv7u46c@linutronix.de> <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com> <CANn89i+Aje5j2iJDoq9FCU966kxC-gaD=ObxwVL49VC9L85_vA@mail.gmail.com> <20191127173719.q3hrdthuvkt2h2ul@linutronix.de> <20200416135938.jiglv4ctjayg5qmg@linutronix.de>
Date:   Wed, 17 Mar 2021 15:10:55 +0100
Message-ID: <871rcdzx8w.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16 2020 at 15:59, Sebastian Andrzej Siewior wrote:
> any comments from the timer department?

Yes.

> On 2019-11-27 18:37:19 [+0100], To Eric Dumazet wrote:
>> On 2019-11-27 09:11:40 [-0800], Eric Dumazet wrote:
>> > Resent in non HTML mode :/
>> don't worry, mutt handles both :)
>> 
>> > Long story short, why hrtimer are not by default using threaded mode
>> > in threadirqs mode ?
>> 
>> Because it is only documented to thread only interrupts. Not sure if we
>> want change this.
>> In RT we expire most of the hrtimers in softirq context for other
>> reasons. A subset of them still expire in hardirq context.
>>
>> > Idea of having some (but not all of them) hard irq handlers' now being
>> > run from BH mode,
>> > is rather scary.
>> 
>> As I explained in my previous email: All IRQ-handlers fire in
>> threaded-mode if enabled. Only the hrtimer is not affected by this
>> change.
>> 
>> > Also, hrtimers got the SOFT thing only in 4.16, while the GRO patch
>> > went in linux-3.19
>> > 
>> > What would be the plan for stable trees ?
>> No idea yet. We could let __napi_schedule_irqoff() behave like
>> __napi_schedule(). 

It's not really a timer departement problem. It's an interrupt problem.

With force threaded interrupts we don't call the handler with interrupts
disabled. What sounded a good idea long ago, is actually bad.

See https://lore.kernel.org/r/87eegdzzez.fsf@nanos.tec.linutronix.de

Any leftover issues on a RT kernel are a different story, but for !RT
this is the proper fix.

I'll spin up a proper patch and tag it for stable...

Thanks,

        tglx
