Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A686F22CA46
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgGXQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgGXQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:08:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD77C0619E4;
        Fri, 24 Jul 2020 09:08:16 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595606893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3s3Aqgk8wYEb6C7q76eOXNAqiLkE4bQcw2wKh9KEzyY=;
        b=FauBewUnsIbIwsfTsUPJbI07vZky8mAkl6COdDJH8e9nhi7dsgWxCcZiz5++vGloYa3wt8
        DJLWCHMQl5O+zK5Wo7MD6tkkesSF1QuLohYDxKaCf0tCms6mlkKUlTx+gFAoWQfqdrOUCX
        6gvrKASHtAoTZ5eOZ8EqInEwe7CMPWx5Df0krM3ODVoHV0ImV1dkgHnRCLwSbObdmwf00d
        UYNksdCl1f7je5OMYZLvE4+kDNmU8JuDBUQaLZxKRTMkC2HsVUCHhqMXTC+maDkF9LaN8Z
        7+t3sUmjMF4iXbA2ZhMq/CxAMXm+W+hORXO5U35Xvx30ERGSYcFgpxttvrVdCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595606893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3s3Aqgk8wYEb6C7q76eOXNAqiLkE4bQcw2wKh9KEzyY=;
        b=PYQzksp8119gJXWIbAR97q2k9vMn1xwijpvcyOhpepzX0j2WJs2GqqH2gviiTC/qtVWSyE
        M3LwSBgwFVJNHgCA==
To:     Alex Belits <abelits@marvell.com>,
        "peterz\@infradead.org" <peterz@infradead.org>
Cc:     "mingo\@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
In-Reply-To: <851ee54e8317cd186338a76a045f738476144fcc.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <87imeextf3.fsf@nanos.tec.linutronix.de> <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com> <20200723154933.GB709@worktop.programming.kicks-ass.net> <3ff1383e669b543462737b0d12c0d1fb7d409e3e.camel@marvell.com> <877dutx5xj.fsf@nanos.tec.linutronix.de> <851ee54e8317cd186338a76a045f738476144fcc.camel@marvell.com>
Date:   Fri, 24 Jul 2020 18:08:13 +0200
Message-ID: <87mu3ouc9e.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex,

Alex Belits <abelits@marvell.com> writes:
> On Thu, 2020-07-23 at 23:44 +0200, Thomas Gleixner wrote:
>>  1) That inline function can be put out of line by the compiler and
>>     placed into the regular text section which makes it subject to
>>     instrumentation
>> 
>>  2) That inline function invokes local_irq_save() which is subject to
>>     instrumentation _before_ the entry state for the instrumentation
>>     mechanisms is established.
>> 
>>  3) That inline function invokes sync_core() before important state
>> has
>>     been established, which is especially interesting in NMI like
>>     exceptions.
>> 
>> As you clearly documented why all of the above is safe and does not
>> cause any problems, it's just me and Peter being silly, right?
>> 
>> Try again.
>
> I don't think, accusations and mockery are really necessary here.

Let's get some context to this.

  I told you in my first mail, that this breaks noinstr and that
  building with full debug would have told you.

  Peter gave you a clear hint where to look.

Now it might be expected that you investigate that or at least ask
questions before making the bold claim:

>> > Unless something else is involved, those operations are safe, so I
>> > am not adding anything that can break those.

Surely I could have avoided the snide remark, but after you demonstrably
ignored technically valid concerns and suggestions in your other reply,
I was surely not in the mood to be overly careful in my choice of words.

> The result of this may be not a "design" per se, but an understanding
> of how things are implemented, and what rules are being followed, so I
> could add my code in a manner consistent with what is done, and
> document the whole thing.

Every other big and technically complex project which has to change the
very inner workings of the kernel started the same way. I'm not aware of
any of them getting accepted as is or in a big code dump.

What you have now qualifies as proof of concept and the big challenge is
to turn it into something which is acceptable and maintainable.

You talk in great length about how inconsistent stuff is all over the
place. Yes, it is indeed. You even call that inconsistency an existing
design:

> My patches reflect what is already in code and in its design.

I agree that you just work with the code as is, but you might have
noticed that quite some of this stuff is clearly not designed at all or
designed badly.

The solution is not to pile on top of the inconsistency, the solution is
to make it consistent in the first place.

You are surely going to say, that's beyond the scope of your project. I
can tell you that it is in the scope of your project simply because just
proliferating the status quo and piling new stuff on top is not an
option. And no, there are no people waiting in a row to mop up after
you either.

Quite some of the big technology projects have spent and still spend
considerable amount of time to do exactly this kind of consolidation
work upfront in order to make their features acceptable in a
maintainable form.

All of these projects have been merged or are still being merged
piecewise in reviewable chunks.

We are talking about intrusive technology which requires a very careful
integration to prevent it from becoming a roadblock or a maintenaince
headache. The approach and implementation has to be _agreed_ on by the
involved parties, i.e. submitters, reviewers and maintainers.

> While I understand that this is an unusual feature and by its nature
> it affects kernel in multiple places, it does not deserve to be called
> a "mess" and other synonyms of "mess".

The feature is perfectly fine and I completely understand why you want
it. Guess who started to lay the grounds for NOHZ_FULL more than a
decade ago and why?

The implementation is not acceptable on technical grounds,
maintainability reasons, lack of design and proper consolidated
integration.

> Another issue that you have asked me to defend is the existence and
> scope of task isolation itself.

I have not asked you to defend the existance. I asked you for coherent
explanations how the implementation works and why the chosen approach is
correct and valid. That's a completely different thing.

> It's an attempt to introduce a feature that turns Linux userspace into
> superior replacement of RTOS.....

Can you please spare me the advertising and marketing? I'm very well
aware what an RTOS is and I'm also very well aware that there is no such
thing like a 'superior replacement' for RTOS in general.

If your view of RTOS is limited to this particular feature, then I have
to tell you that this particular feature is only useful for a very small
portion of the overall RTOS use cases.

> However most definitely this is not a "mess", and it I do not believe
> that I have to defend the validity of this direction of development, or
> be accused of general incompetence every time someone finds a
> frustrating mistake in my code.

Nobody accuses you of incompetence, but you will have to defend the
validity of your approach and implementation and accept that things
might not be as shiny as you think they are. That's not hostility,
that's just how Linux kernel development works whether you like it or
not. 

I surely can understand your frustration over my view of this series,
but you might have noticed that aside of criticism I gave you very clear
technical arguments and suggestions how to proceed.

It's your decision what you make of that.

Thanks,

        tglx
