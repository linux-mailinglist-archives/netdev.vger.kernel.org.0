Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22A25224F5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiEJTkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiEJTko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:40:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE9111163;
        Tue, 10 May 2022 12:40:42 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652211640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OEDxfxfGB0zzvmyrmmb19QrPenmgyOx+wB7aMTpPY14=;
        b=s9qpTYE/3WJU4N3KJVSOdyb7xWHt1vkR4fCuQ5J8Zkt0v0hhGnmBmJdDRvMzx7U23g78AD
        5x0GWGYOK6up5rJgLjlqAJ0oKWgxSuZArLqIZD7/93+m719asCNv2npDv0K4E3pzaf0TU1
        QT3fxi7rAkTN0NzY7sIU3W6vHFJAKmFF1D5WFGFp25IVzQ1U2GLRWaAA15JzW4DMVMPiln
        C4PlGutDHid0b5MW+yz4Oad3VH/9G9wKQ7qYFzrw5pmS2R8UQ108RRuRC1xOe7QqhudZaN
        toooF05flVTdgRJ8Mw90Ti/8UtTs7R3lmx6LjRAd0TtWQNVsyqtk/eFe4jDJKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652211640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OEDxfxfGB0zzvmyrmmb19QrPenmgyOx+wB7aMTpPY14=;
        b=vLCouTuSreEprlIyaHBdxRuhj0utQMxldxJLsrUVX2CbalgS135YGbpGNA0WSY+j9euZdD
        GTFEAV97omDLmGAg==
To:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Evan Green <evgreen@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, Kees Cook <keescook@chromium.org>,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH 04/30] firmware: google: Convert regular spinlock into
 trylock on panic path
In-Reply-To: <20220510132015.38923cb2@gandalf.local.home>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-5-gpiccoli@igalia.com>
 <CAE=gft5Pq25L4KFoPWbftkPF-JN1ex2yws77mMJ4GQnn9W0L2g@mail.gmail.com>
 <adcf6d0e-c37c-6ede-479e-29959d03d8c0@igalia.com> <YnpOv4hAPV4b+6v4@alley>
 <20220510132015.38923cb2@gandalf.local.home>
Date:   Tue, 10 May 2022 21:46:38 +0206
Message-ID: <87h75xkwg9.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,INVALID_DATE_TZ_ABSURD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-10, Steven Rostedt <rostedt@goodmis.org> wrote:
>> As already mentioned in the other reply, panic() sometimes stops the
>> other CPUs using NMI, for example, see kdump_nmi_shootdown_cpus().
>> 
>> Another situation is when the CPU using the lock ends in some
>> infinite loop because something went wrong. The system is in
>> an unpredictable state during panic().
>> 
>> I am not sure if this is possible with the code under gsmi_dev.lock
>> but such things really happen during panic() in other subsystems.
>> Using trylock in the panic() code path is a good practice.
>
> I believe that Peter Zijlstra had a special spin lock for NMIs or
> early printk, where it would not block if the lock was held on the
> same CPU. That is, if an NMI happened and paniced while this lock was
> held on the same CPU, it would not deadlock. But it would block if the
> lock was held on another CPU.

Yes. And starting with 5.19 it will be carrying the name that _you_ came
up with (cpu_sync):

printk_cpu_sync_get_irqsave()
printk_cpu_sync_put_irqrestore()

John
