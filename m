Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1A22853FE
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgJFVlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFVlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 17:41:18 -0400
Received: from localhost (cha74-h07-176-172-165-181.dsl.sta.abo.bbox.fr [176.172.165.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A895B208B6;
        Tue,  6 Oct 2020 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602020477;
        bh=9wLduu0HibYTvQ1PxET1bwvOHmceqeDnpLGd3eg73zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2gCpOuwlb9OCrTs8XdwbsjCC4BukoUfz0Mvac17ZIGhzrZJLjfCkNYUOHOHUoqqri
         OIOiw9PbygkXW73CcQougUiK/NjNN+08X/TVwhkLEOiN9KU6jcrRLND5yoQwFZvivV
         kkF0BPaHRf4ooYAz0mS3oP3jWuSjTIeE9AhIWZDA=
Date:   Tue, 6 Oct 2020 23:41:13 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 10/13] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Message-ID: <20201006214113.GA38684@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <5acf7502c071c0d1365ba5e5940e003a7da6521f.camel@marvell.com>
 <20201001144454.GB6595@lothringen>
 <ab85fd564686845648d08779b1d4ecc3ab440b2a.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab85fd564686845648d08779b1d4ecc3ab440b2a.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 03:22:09PM +0000, Alex Belits wrote:
> 
> On Thu, 2020-10-01 at 16:44 +0200, Frederic Weisbecker wrote:
> > > @@ -268,7 +269,8 @@ static void tick_nohz_full_kick(void)
> > >   */
> > >  void tick_nohz_full_kick_cpu(int cpu)
> > >  {
> > > -	if (!tick_nohz_full_cpu(cpu))
> > > +	smp_rmb();
> > 
> > What is it ordering?
> 
> ll_isol_flags will be read in task_isolation_on_cpu(), that accrss
> should be ordered against writing in
> task_isolation_kernel_enter(), fast_task_isolation_cpu_cleanup()
> and task_isolation_start().
> 
> Since task_isolation_on_cpu() is often called for multiple CPUs in a
> sequence, it would be wasteful to include a barrier inside it.

Then I think you meant a full barrier: smp_mb()

> 
> > > +	if (!tick_nohz_full_cpu(cpu) || task_isolation_on_cpu(cpu))
> > >  		return;
> > 
> > You can't simply ignore an IPI. There is always a reason for a
> > nohz_full CPU
> > to be kicked. Something triggered a tick dependency. It can be posix
> > cpu timers
> > for example, or anything.
> 
> I realize that this is unusual, however the idea is that while the task
> is running in isolated mode in userspace, we assume that from this CPUs
> point of view whatever is happening in kernel, can wait until CPU is
> back in kernel and when it first enters kernel from this mode, it
> should "catch up" with everything that happened in its absence.
> task_isolation_kernel_enter() is supposed to do that, so by the time
> anything should be done involving the rest of the kernel, CPU is back
> to normal.

You can't assume that. If something needs the tick, this can't wait.
If the user did something wrong, such as setting a posix cpu timer
to an isolated task, that's his fault and the kernel has to stick with
correctness and kick that task out of isolation mode.

> 
> It is application's responsibility to avoid triggering things that
> break its isolation

Precisely.

> so the application assumes that everything that
> involves entering kernel will not be available while it is isolated.

We can't do things that way and just ignore IPIs. You need to solve the
source of the noise, not the symptoms.

Thanks.
