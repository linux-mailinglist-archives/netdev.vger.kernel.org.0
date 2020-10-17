Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270D92912DF
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438193AbgJQQIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 12:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438126AbgJQQIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 12:08:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A960C061755;
        Sat, 17 Oct 2020 09:08:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602950898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qr/OgZjBzWF53qclusfF/MAUFz1VUdG8p5+rV3CeWNQ=;
        b=lWnissTyc8NlH5A1JHkJdOeIe6rxp8KSBW0FvpzopLg72wY2GaJGiNn3DhxHaqyPtX4/VS
        CJ+rWgPhKQIEx3ch2BII+B2QDg079gPqxsznNXp4cW2stI35Q/upjC0efcVWGvS9aeTRDx
        6DBWQvZtgbe1QbVCl/9A42JSKWnysSWKEJj6Sxmb1v7OP6RxTH8JOVOHcAs+OW+DB5YYbb
        NRvqaBeIuMvKLDcBXPu4zuTaCM1u3hop1UwTdbngoFsTR+ozM3To221EEyxq0ZDXW65bhG
        MLySwv6CQMciRIErN8UhhZgNanXqBplaqGfdbFdwZJvZS/2O6YFCCZ4pElXyiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602950898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qr/OgZjBzWF53qclusfF/MAUFz1VUdG8p5+rV3CeWNQ=;
        b=LkZRl4Cx55lMFJ1la+G1dY6Xr1/9hGPhFCQBTLsptNbRtGiGZzGf2MZ0aYM3CUULctW7QJ
        QWO6sNuLSF8aVIDw==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     "mingo\@kernel.org" <mingo@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard isolation from kernel
In-Reply-To: <91b8301b0888bf9e5ff7711c3b49d21beddf569a.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com> <20201001135640.GA1748@lothringen> <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com> <20201004231404.GA66364@lothringen> <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com> <91b8301b0888bf9e5ff7711c3b49d21beddf569a.camel@marvell.com>
Date:   Sat, 17 Oct 2020 18:08:18 +0200
Message-ID: <87r1pwj0nh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17 2020 at 01:08, Alex Belits wrote:
> On Mon, 2020-10-05 at 14:52 -0400, Nitesh Narayan Lal wrote:
>> On 10/4/20 7:14 PM, Frederic Weisbecker wrote:
> I think that the goal of "finding source of disturbance" interface is
> different from what can be accomplished by tracing in two ways:
>
> 1. "Source of disturbance" should provide some useful information about
> category of event and it cause as opposed to determining all precise
> details about things being called that resulted or could result in
> disturbance. It should not depend on the user's knowledge about
> details

Tracepoints already give you selectively useful information.

> of implementations, it should provide some definite answer of what
> happened (with whatever amount of details can be given in a generic
> mechanism) even if the user has no idea how those things happen and
> what part of kernel is responsible for either causing or processing
> them. Then if the user needs further details, they can be obtained with
> tracing.

It's just a matter of defining the tracepoint at the right place.

> 2. It should be usable as a runtime error handling mechanism, so the
> information it provides should be suitable for application use and
> logging. It should be usable when applications are running on a system
> in production, and no specific tracing or monitoring mechanism can be
> in use.

That's a strawman really. There is absolutely no reason why a specific
set of tracepoints cannot be enabled on a production system.

Your tracker is a monitoring mechanism, just a different flavour.  By
your logic above it cannot be enabled on a production system either.

Also you can enable tracepoints from a control application, consume, log
and act upon them. It's not any different from opening some magic
isolation tracker interface. There are even multiple ways to do that
including libraries.

> If, say, thousands of devices are controlling neutrino detectors on an
> ocean floor, and in a month of work one of them got one isolation
> breaking event, it should be able to report that isolation was broken
> by an interrupt from a network interface, so the users will be able to
> track it down to some userspace application reconfiguring those
> interrupts.

Tracing can do that and it can do it selectively on the isolated
CPUs. It's just a matter of proper configuration and usage.

> It will be a good idea to make such mechanism optional and suitable for
> tracking things on conditions other than "always enabled" and "enabled
> with task isolation".

Tracing already provides that. Tracepoints are individually controlled
and filtered.

> However in my opinion, there should be something in kernel entry
> procedure that, if enabled, prepared something to be filled by the
> cause data, and we know at least one such situation when this kernel
> entry procedure should be triggered -- when task isolation is on.

A tracepoint will gather that information for you.

task isolation is not special, it's just yet another way to configure
and use a system and tracepoints provide everything you need with the
bonus that you can gather more correlated information when you need it.

In fact tracing and tracepoints have replaced all specialized trackers
which were in the kernel before tracing was available. We're not going
to add a new one just because.

If there is anything which you find that tracing and tracepoints cannot
provide then the obvious solution is to extend that infrastructure so it
can serve your usecase.

Thanks,

        tglx
