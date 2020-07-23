Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0A22B8BA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgGWVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:31:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33144 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgGWVbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:31:24 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595539880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTaOmK1fljiBJkf3c8Nti65S9vGlXgkkQUKKguVWmf8=;
        b=aQCjhe4d0wIyOBORyzrR29tEOgdrXxUwLI3iWKoPygWwI+/ZWwAtezMjZXIDVHV9UK6W14
        pNcV5RhT7sjy4F0s3xyM21ugFyHijnlKDlBAPwA6h5EfrdUsd7pegCecme6H8dSvkDsPHD
        4zcvgOHTf2npBJpb6mpih6kLK6M/gxVJexQoq9mm/XlxYInLW6mrDP2gibLSIO0VhveZO/
        WBEtZP6TmlygyVCEVTkXE9R70d61LJr9+IhgA28/1+QQQNcMHnWECzAohdqKpPo7E9JXca
        8uYT2rFwm9UhBAr9GVd+R7o+8cqZneGTTc32l/gJMxHz7nK9NWpLlKgmCgKIPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595539880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTaOmK1fljiBJkf3c8Nti65S9vGlXgkkQUKKguVWmf8=;
        b=+y9s+u2QMH2yf4VSCm/jg8KJhMXVBtIQ7RDj2qXNVHUrRqu8All6mNPLrDb2q97TekY6An
        e6AtBl6Y5t0t4vAg==
To:     Alex Belits <abelits@marvell.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>
Cc:     "mingo\@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
In-Reply-To: <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <87imeextf3.fsf@nanos.tec.linutronix.de> <831e023422aa0e4cb3da37ceef6fdcd5bc854682.camel@marvell.com>
Date:   Thu, 23 Jul 2020 23:31:20 +0200
Message-ID: <87a6zpx6jb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex,

Alex Belits <abelits@marvell.com> writes:
> On Thu, 2020-07-23 at 15:17 +0200, Thomas Gleixner wrote:
>> 
>> Without going into details of the individual patches, let me give you a
>> high level view of this series:
>> 
>>   1) Entry code handling:
>> 
>>      That's completely broken vs. the careful ordering and instrumentation
>>      protection of the entry code. You can't just slap stuff randomly
>>      into places which you think are safe w/o actually trying to understand
>>      why this code is ordered in the way it is.
>> 
>>      This clearly was never built and tested with any of the relevant
>>      debug options enabled. Both build and boot would have told you.
>
> This is intended to avoid a race condition when entry or exit from isolation
> happens at the same time as an event that requires synchronization. The idea
> is, it is possible to insulate the core from all events while it is running
> isolated task in userspace, it will receive those calls normally after
> breaking isolation and entering kernel, and it will synchronize itself on
> kernel entry.

It does not matter what your intention is. Fact is that you disrupt a
carefully designed entry code sequence without even trying to point out
that you did so because you don't know how to do it better. There is a
big fat comment above enter_from_user_mode() which should have make you
ask at least. Peter and myself spent month on getting this correct
vs. RCU, instrumentation, code patching and some more things.

From someone who tries to fiddle with such a sensitive area of code it's
not too much asked that he follows or reads up on these changes instead
of just making uninformed choices of placement by defining that this new
stuff is the most important thing on the planet or at least documenting
why this is correct and not violating any of the existing constraints.

> This has two potential problems that I am trying to solve:
>
> 1. Without careful ordering, there will be a race condition with events that
> happen at the same time as kernel entry or exit.

Entry code is all about ordering. News at 11.

> 2. CPU runs some kernel code after entering but before synchronization. This
> code should be restricted to early entry that is not affected by the "stale"
> state, similar to how IPI code that receives synchronization events does it
> normally.

And because of that you define that you can place anything you need
_before_ functionality which is essential for establishing kernel state
correctly without providing the minimum proof that this does not violate
any of the existing contraints.

> reach them. This means, there should be established some point on kernel entry
> when it is safe for the core to catch up with the rest of kernel. It may be
> useful for other purposes, however at this point task isolation is the first
> to need it, so I had to determine where such point is for every supported
> architecture and method of kernel entry.

You decided that your feature has to run first. Where is the analysis
that this is safe and correct vs. the existing ordering constraints?

Why does this trigger build and run time warnings? (I neither built nor
ran it, but with full debug enabled it will for sure).

> Nevertheless, I believe that the goal of finding those points and using
> them for synchronization is valid.

The goal does not justify the means. 

> If you can recommend me a better way for at least x86, I will be happy
> to follow your advice. I have tried to cover kernel entry in a generic
> way while making the changes least disruptive, and this is why it
> looks simple and spread over multiple places.

It does not look simple. It looks random and like the outcome of try and
error. Oh, here it explodes, lets slap another instance into it.

> I also had to do the same for arm and arm64 (that I use for
> development), and for each architecture I had to produce sequences of
> entry points and function calls to determine the correct placement of
> task_isolation_enter() calls in them. It is not random, however it does
> reflect the complex nature of kernel entry code. I believe, RCU
> implementation faced somewhat similar requirements for calls on kernel
> entry, however it is not completely unified, either

But RCU has a well defined design and requirement list and people are
working on making the entry sequence generic and convert architectures
over to it. And no, we don't try to do 5 architectures at once. We did
x86 with an eye on others. It's not perfect and it never will be because
of hardware.

>>  2) Instruction synchronization
>>     Trying to do instruction synchronization delayed is a clear recipe
>>     for hard to diagnose failures. Just because it blew not up in your
>>     face does not make it correct in any way. It's broken by design and
>>     violates _all_ rules of safe instruction patching and introduces a
>>     complete trainwreck in x86 NMI processing.
>
> The idea is that just like synchronization events are handled by regular IPI,
> we already use some code with the assumption that it is safe to be entered in
> "stale" state before synchronization. I have extended it to allow
> synchronization points on all kernel entry points.

The idea is clear, just where is the analysis that this is safe?

Just from quickly skimming the code it's clear that this has never been
done. Experimental development on the base of 'does not explode' is not
a valid approach in the kernel whatever your goal is.

>>     If you really think that this is correct, then please have at least
>>     the courtesy to come up with a detailed and precise argumentation
>>     why this is a valid approach.
>>
>>     While writing that up you surely will find out why it is not.
>
> I had to document a sequence of calls for every entry point on three supported
> architectures, to determine the points for synchronization.

Why is that documentation not part of the patches in form of
documentation or proper changelogs?

> It is possible that I have somehow missed something, however I don't
> see a better approach, save for establishing a kernel-wide
> infrastructure for this. And even if we did just that, it would be
> possible to implement this kind of synchronization point calls first,
> and convert them to something more generic later.

You're putting the cart before the horse.

You want delayed instruction patching synchronization. So the right
approach is to:

   1) Analyze the constraints of instruction patching on a given
      architecture.

   2) Implement a scheme for this architecture to handle delayed
      patching as a stand alone feature with well documented and fine
      grained patches and proper prove that none of the constraints is
      violated.

      Find good arguments why such a feature is generally useful and not
      only for your personal pet pieve.

Once you've done that, then you'll find out that there is no need for
magic task isolation hackery simply because it's already there.

Code patching is very much architecture specific and the constraints
vary due to the different hardware requirements. The idea of making this
generic is laudable, but naive at best. Once you have done #1 above on
two architectures you will know why.

>>   3) Debug calls
>> 
>>      Sprinkling debug calls around the codebase randomly is not going to
>>      happen. That's an unmaintainable mess.
>
> Those report isolation breaking causes, and are intended for application and
> system debugging.

I don't care what they do as that does not make them more palatable or
maintainable.

>> 
>>      Aside of that none of these dmesg based debug things is necessary.
>>      This can simply be monitored with tracing.
>
> I think, it would be better to make all that information available to the
> userspace application, however I have based this on the Chris Metcalf code,
> and gradually updated the mechanisms and interfaces. The original reporting
> of isolation breaking causes had far greater problems, so at first I wanted
> to have something that produces easily visible and correct reporting, and
> does not break things while doing so.

Why are you exposing other people to these horrors? I don't care what
you use in your development branch and I don't care what you share with
your friends, but if you want maintainers and reviewers to look at that
stuff then ensure that what you present:

  - Makes sense
  - Is properly implemented
  - Is properly documented
  - Is properly argumented why this is the right approach.

'I need', 'I want', 'this does' are non-arguments to begin with.

>>   5) Signal on page fault
>> 
>>      Why is this a magic task isolation feature instead of making it
>>      something which can be used in general? There are other legit
>>      reasons why a task might want a notification about an unexpected
>>      (resolved) page fault.
>
> Page fault causes isolation breaking. When a task runs in isolated mode it
> does so because it requires predictable timing, so causing page faults and
> expecting them to be handled along the way would defeat the purpose of
> isolation. So if page fault did happen, it is important that application will
> receive notification about isolation being broken, and then may decide to do
> something about it, re-enter isolation, etc.

Did you actually read what I wrote? I very much understood what you are
trying to do and why. Otherwise I wouldn't have written the above.

>>   6) Coding style violations all over the place
>> 
>>      Using checkpatch.pl is mandatory
>> 
>>   7) Not Cc'ed maintainers
>> 
>>      While your Cc list is huge, you completely fail to Cc the relevant
>>      maintainers of various files and subsystems as requested in
>>      Documentation/process/*
>
> To be honest, I am not sure, whom I have missed, I tried to include everyone
> from my previous attempt.

May I ask you to read, understand and follow the documentation I pointed
you to?

>>   8) Changelogs
>> 
>>      Most of the changelogs have something along the lines:
>> 
>>      'task isolation does not want X, so do Y to make it not do X'
>> 
>>      without any single line of explanation why this approach was chosen
>>      and why it is correct under all circumstances and cannot have nasty
>>      side effects.
>
> This is the same as the previous version, except for the addition of kernel
> entry handling. As far as I can tell, the rest was discussed before, and not
> many questions remained except for the race condition on kernel entry.

How is that related to changelogs which are useless? 

> agree that kernel entry handling is a complex issue in itself, so I have
> included explanation of entry points / function calls sequences for each
> supported architecture.

Which explanations? Let's talk about 7/13 the x86 part:

> In prepare_exit_to_usermode(), run cleanup for tasks exited fromi
> isolation and call task_isolation_start() for tasks that entered
> TIF_TASK_ISOLATION.
>
> In syscall_trace_enter(), add the necessary support for reporting
> syscalls for task-isolation processes.
>
> Add task_isolation_remote() calls for the kernel exception types
> that do not result in signals, namely non-signalling page faults.
>
> Add task_isolation_kernel_enter() calls to interrupt and syscall
> entry handlers.
>
> This mechanism relies on calls to functions that call
> task_isolation_kernel_enter() early after entry into kernel. Those
> functions are:
>
> enter_from_user_mode()
>  called from do_syscall_64(), do_int80_syscall_32(),
>  do_fast_syscall_32(), idtentry_enter_user(),
>  idtentry_enter_cond_rcu()
> idtentry_enter_cond_rcu()
>  called from non-raw IDT macros and other entry points
> idtentry_enter_user()
> nmi_enter()
> xen_call_function_interrupt()
> xen_call_function_single_interrupt()
> xen_irq_work_interrupt()

Can you point me to a single word of explanation in this blurb?

It's a list of things WHAT the patch does without a single word of WHY
and without a single word of WHY any of this would be correct.

> I have longer call diagram, that I used to track each particular
> function, it probably should be included as a separate document.

Call diagrams are completely useless. The people who have to review this
know how that works. They want real explanations:

     - Why is this the right approach
     - Why does this not violate constraints A, B, C
     - What are the potential side effects
     - ...

All of this is asked for in Documentation/process/* for a reason.

>>      It's not the job of the reviewers/maintainers to figure this out.
>> 
>> Please come up with a coherent design first and then address the
>> identified issues one by one in a way which is palatable and reviewable.
>> 
>> Throwing a big pile of completely undocumented 'works for me' mess over
>> the fence does not get you anywhere, not even to the point that people
>> are willing to review it in detail.
>
> There is a design, and it is a result of a careful tracking of calls in the
> kernel source. It has multiple point where task_isolation_enter() is called
> for a reason similar to why RCU-related functions are called in multiple
> places.

Design based on call tracking? That must be some newfangled method of
design which was not taught when I was in school.

You can do analysis with call tracking, but not design. 

Comparing this to RCU is beyond hillarious. RCU has design and
requirements documented and every single instance of RCU state
establishment has been argued in the changelogs and is most of the time
(except for the obvious places) extensively commented.

> If someone can recommend a better way to introduce a kernel entry
> checkpoint for synchronization that did not exist before, I will be happy
> to hear it.

Start with a coherent explanation of:

  - What you are trying to achieve

  - Which problems did you observe in your analysis including the
    impact of the problem on your goal.

  - A per problem conceptual approach to solve it along with cleanly
    implemented and independent RFC code for each particular problem
    without tons of debug hacks and the vain attempts to make everything
    generic. There might be common parts of it, but as explained with
    code patching and #PF signals they can be completely independent of
    each other.

Thanks,

        tglx
