Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF922B2EB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgGWPtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgGWPto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:49:44 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91660C0619DC;
        Thu, 23 Jul 2020 08:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LYu+ezmfFFcFKRanzHt9VPcPF2HH2rDVTFxSgTdp7dg=; b=alvZyoJ8DSaI1Us5j3jnl/Ljgo
        7S7hzNiPahJhOwpMmvfZiNTjyos5JOZv2Z0LSjLzTC8fqKwLgQC8cvMhStgS7M5YBR/6yVRy20UpI
        WtGo5RHCbF3WHW9eCY6HXpYgumPbEDb8R7ES/uYrGXURBbamBymu/jd9BOB3y2ekfr1hXMZqhHArJ
        A0etWtI9yNbA64C66p3z7q+m28NpBiTgJdKQN/pg8XlhfJiIJiqQThFLSNcT5jHqzKzUt4UKJR7ei
        sIKZHGXmL1I6w5Mu+KqUKaPu/s53OIJqzCouT+OCJtqtfDonGzVVtAtdNddrAU4qbGvguguy0wABm
        dv/9u6Mw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jydTT-00062q-17; Thu, 23 Jul 2020 15:49:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5BD82983422; Thu, 23 Jul 2020 17:49:33 +0200 (CEST)
Date:   Thu, 23 Jul 2020 17:49:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
Message-ID: <20200723154933.GB709@worktop.programming.kicks-ass.net>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <87imeextf3.fsf@nanos.tec.linutronix.de>
 <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:18:42PM +0000, Alex Belits wrote:
> On Thu, 2020-07-23 at 15:17 +0200, Thomas Gleixner wrote:
> > 
> > Without going into details of the individual patches, let me give you a
> > high level view of this series:
> > 
> >   1) Entry code handling:
> > 
> >      That's completely broken vs. the careful ordering and instrumentation
> >      protection of the entry code. You can't just slap stuff randomly
> >      into places which you think are safe w/o actually trying to understand
> >      why this code is ordered in the way it is.
> > 
> >      This clearly was never built and tested with any of the relevant
> >      debug options enabled. Both build and boot would have told you.
> 
> This is intended to avoid a race condition when entry or exit from isolation
> happens at the same time as an event that requires synchronization. The idea
> is, it is possible to insulate the core from all events while it is running
> isolated task in userspace, it will receive those calls normally after
> breaking isolation and entering kernel, and it will synchronize itself on
> kernel entry.

'What does noinstr mean? and why do we have it" -- don't dare touch the
entry code until you can answer that.
