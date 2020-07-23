Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A77022B042
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgGWNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:17:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57992 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbgGWNRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 09:17:06 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595510224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZpHq0wJmoP/QXQlRoyC1nwl6NlG0XCOjSsjs7SeBVk=;
        b=I5uUAnslI9iohcWcGvwQ1La8igmc08Dgutc4K//ZOliRBQaRsCvuWzc70N//cMry0vvrwH
        BKtNKQK2R6FuwQbymWrVlq1H766ZtytsV+w3XlJHlILbIxNyCPFOrkPY/PgkLStzNEVlpZ
        ExnlHmkAFLgeRofqnevAlRou3mGVDq+YsL5M5ajc2FXqt0WB/u24ZCK3ed6yEdWGmWC9T2
        ISXOUS0/toZi2WFWflYc+eIH8Qw7UsY8Ip8KA+qKQMRU7Sfo89WKBsASebhKJ25ZKzPVfF
        EAPBco13PdctmXrPup1XDQFusXVSvpOdaemNoWJMM0RFwWrGyE5G60g+AWBCuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595510224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZpHq0wJmoP/QXQlRoyC1nwl6NlG0XCOjSsjs7SeBVk=;
        b=WwsN8Q02+6+OIT1IGfrmoJ1cKOXiIf+cRiWF3uIDoAkx/POgXeIUtk17XXPG2yXE9l/RJX
        We5XQT2JyzofwSBg==
To:     Alex Belits <abelits@marvell.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Date:   Thu, 23 Jul 2020 15:17:04 +0200
Message-ID: <87imeextf3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex,

Alex Belits <abelits@marvell.com> writes:
> This is a new version of task isolation implementation. Previous version is at
> https://lore.kernel.org/lkml/07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com/
>
> Mostly this covers race conditions prevention on breaking isolation. Early after kernel entry,
> task_isolation_enter() is called to update flags visible to other CPU cores and to perform
> synchronization if necessary. Before this call only "safe" operations happen, as long as
> CONFIG_TRACE_IRQFLAGS is not enabled.

Without going into details of the individual patches, let me give you a
high level view of this series:

  1) Entry code handling:

     That's completely broken vs. the careful ordering and instrumentation
     protection of the entry code. You can't just slap stuff randomly
     into places which you think are safe w/o actually trying to understand
     why this code is ordered in the way it is.

     This clearly was never built and tested with any of the relevant
     debug options enabled. Both build and boot would have told you.

  2) Instruction synchronization

     Trying to do instruction synchronization delayed is a clear recipe
     for hard to diagnose failures. Just because it blew not up in your
     face does not make it correct in any way. It's broken by design and
     violates _all_ rules of safe instruction patching and introduces a
     complete trainwreck in x86 NMI processing.

     If you really think that this is correct, then please have at least
     the courtesy to come up with a detailed and precise argumentation
     why this is a valid approach.

     While writing that up you surely will find out why it is not.

  3) Debug calls

     Sprinkling debug calls around the codebase randomly is not going to
     happen. That's an unmaintainable mess.

     Aside of that none of these dmesg based debug things is necessary.
     This can simply be monitored with tracing.

  4) Tons of undocumented smp barriers

     See Documentation/process/submit-checklist.rst #25

  5) Signal on page fault

     Why is this a magic task isolation feature instead of making it
     something which can be used in general? There are other legit
     reasons why a task might want a notification about an unexpected
     (resolved) page fault.

  6) Coding style violations all over the place

     Using checkpatch.pl is mandatory

  7) Not Cc'ed maintainers

     While your Cc list is huge, you completely fail to Cc the relevant
     maintainers of various files and subsystems as requested in
     Documentation/process/*

  8) Changelogs

     Most of the changelogs have something along the lines:

     'task isolation does not want X, so do Y to make it not do X'

     without any single line of explanation why this approach was chosen
     and why it is correct under all circumstances and cannot have nasty
     side effects.

     It's not the job of the reviewers/maintainers to figure this out.

Please come up with a coherent design first and then address the
identified issues one by one in a way which is palatable and reviewable.

Throwing a big pile of completely undocumented 'works for me' mess over
the fence does not get you anywhere, not even to the point that people
are willing to review it in detail.

Thanks,

        tglx
