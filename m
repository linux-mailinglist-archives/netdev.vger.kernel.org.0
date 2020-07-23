Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B219522B8D6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGWVo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgGWVo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:44:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BCEC0619D3;
        Thu, 23 Jul 2020 14:44:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595540664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YJAOZn+NV3c8JWx5UIem9HzDm7TCzzCZdh+QLWV9zos=;
        b=uDfZmcKsPrtAZ9EPCn7wuQ2LYhtSESV/A3K5F2BxInsEbE5KGH3iTpU6hfb8Iq3xSCK73q
        V9Cj62JEzbOFW3OO9Qd4MRy2gZ2LSAw0z46WszgaNU/zJbi7ZP7wk8dnXiKQf60M7aLhsx
        jA/7O0lW2KwCga8BN95btUdT1LJ9rQgh/X0cFNLnGiatFNKk6B3MMAUoyAmKRGq5mWhl79
        odbPA/3HPG1ndaQplTcsZgUZws6tgJxUTJ71z6h374VhakEAxq6k5LLugh0TyHZ/kGjtDo
        JwM8uW6KKdYjq7gj0dY71e+o+dj1Dtmc74+ETE3waVxSWFBvllqwwCzBYnJN7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595540664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YJAOZn+NV3c8JWx5UIem9HzDm7TCzzCZdh+QLWV9zos=;
        b=gtKjIi1mnr4FAzRJ1lQR9YtI+U6Z6fGDmO5VwPoawB9wYFUsAn5WivGjVh4rSWoYiyjTpS
        sAHmg2otDHvRriBw==
To:     Alex Belits <abelits@marvell.com>,
        "peterz\@infradead.org" <peterz@infradead.org>
Cc:     "davem\@davemloft.net" <davem@davemloft.net>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
In-Reply-To: <3ff1383e669b543462737b0d12c0d1fb7d409e3e.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <87imeextf3.fsf@nanos.tec.linutronix.de> <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com> <20200723154933.GB709@worktop.programming.kicks-ass.net> <3ff1383e669b543462737b0d12c0d1fb7d409e3e.camel@marvell.com>
Date:   Thu, 23 Jul 2020 23:44:24 +0200
Message-ID: <877dutx5xj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Belits <abelits@marvell.com> writes:
> On Thu, 2020-07-23 at 17:49 +0200, Peter Zijlstra wrote:
>> 
>> 'What does noinstr mean? and why do we have it" -- don't dare touch
>> the
>> entry code until you can answer that.
>
> noinstr disables instrumentation, so there would not be calls and
> dependencies on other parts of the kernel when it's not yet safe to
> call them. Relevant functions already have it, and I add an inline call
> to perform flags update and synchronization. Unless something else is
> involved, those operations are safe, so I am not adding anything that
> can break those.

Sure.

 1) That inline function can be put out of line by the compiler and
    placed into the regular text section which makes it subject to
    instrumentation

 2) That inline function invokes local_irq_save() which is subject to
    instrumentation _before_ the entry state for the instrumentation
    mechanisms is established.

 3) That inline function invokes sync_core() before important state has
    been established, which is especially interesting in NMI like
    exceptions.

As you clearly documented why all of the above is safe and does not
cause any problems, it's just me and Peter being silly, right?

Try again.

Thanks,

        tglx
