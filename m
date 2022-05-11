Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9252313F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiEKLNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbiEKLN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:13:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E031B1ED29C;
        Wed, 11 May 2022 04:13:23 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 983B121B32;
        Wed, 11 May 2022 11:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652267602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FC1sflG6Id2SKeEdl4FJxU/B3titx078hgJ9iLge96M=;
        b=PzdYpVjDm9GZjow/EUq37H7ookCOkOdew3j+O3sWtMh70hNVOnxtZzKqOPpZDQnacwtKh8
        hTKee3j+Sl0MntfBuf4Onekv+PULsWjOAIitLyhS1jfqtNLxp3KL+emXCY3ZW29THEdaU3
        +LT7bZxhID8yMwqQ2reWXTGMidRsh/s=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BC7822C141;
        Wed, 11 May 2022 11:13:20 +0000 (UTC)
Date:   Wed, 11 May 2022 13:13:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
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
Message-ID: <20220511111320.GB26047@pathway.suse.cz>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-5-gpiccoli@igalia.com>
 <CAE=gft5Pq25L4KFoPWbftkPF-JN1ex2yws77mMJ4GQnn9W0L2g@mail.gmail.com>
 <adcf6d0e-c37c-6ede-479e-29959d03d8c0@igalia.com>
 <YnpOv4hAPV4b+6v4@alley>
 <20220510132015.38923cb2@gandalf.local.home>
 <87h75xkwg9.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h75xkwg9.fsf@jogness.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2022-05-10 21:46:38, John Ogness wrote:
> On 2022-05-10, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> As already mentioned in the other reply, panic() sometimes stops the
> >> other CPUs using NMI, for example, see kdump_nmi_shootdown_cpus().
> >> 
> >> Another situation is when the CPU using the lock ends in some
> >> infinite loop because something went wrong. The system is in
> >> an unpredictable state during panic().
> >> 
> >> I am not sure if this is possible with the code under gsmi_dev.lock
> >> but such things really happen during panic() in other subsystems.
> >> Using trylock in the panic() code path is a good practice.
> >
> > I believe that Peter Zijlstra had a special spin lock for NMIs or
> > early printk, where it would not block if the lock was held on the
> > same CPU. That is, if an NMI happened and paniced while this lock was
> > held on the same CPU, it would not deadlock. But it would block if the
> > lock was held on another CPU.
> 
> Yes. And starting with 5.19 it will be carrying the name that _you_ came
> up with (cpu_sync):
> 
> printk_cpu_sync_get_irqsave()
> printk_cpu_sync_put_irqrestore()

There is a risk that this lock might become a big kernel lock.

This special lock would need to be used even during normal
system operation. It does not make sense to suddenly start using
another lock during panic.

So I think that we should think twice before using it.
I would prefer using trylock of the original lock when
possible during panic.

It is possible that I miss something.

Best Regards,
Petr
