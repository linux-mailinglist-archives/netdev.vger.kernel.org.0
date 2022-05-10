Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21552165F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242224AbiEJNIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiEJNIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:08:47 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A17281368;
        Tue, 10 May 2022 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ERCDIneY1Q4o8JFrn6huil0jOKhd5NF1nm9+poeBUGY=; b=C1bwe/Dp28hHJCcth6j9FIvLRX
        pDXbwTw3GNkAuVoDVZ2t1Ig0Ha8VAgFyN1qfYHmoUYQVyDRHd7IRdBkOHux1OzR9Q7hmNC/ZbkDNy
        i9N1ZP1KkXJYzqp8Xch5cykWJAl8GjhN23tq785F2kRMcqVY6TftmyHyPJZTtkL8PDJb7GYsR63+v
        CyHpUemygecHOqy6UnkI5sacYa9DSfBokIBgO1vbgxAO3Lo/ZpYDMcX65a4mJHituF1N7bEMHTqnl
        wjibh2hSmhpgeMzHripimwe7gT4RuGZfcia5HzNoWvLT/w9CiRN4l1p9e5qQ/+lp5TdT6UNVMzl77
        9RtLUAvA==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1noPXc-0005Ct-K8; Tue, 10 May 2022 15:04:40 +0200
Message-ID: <c23f408f-d030-b599-19b4-8561d511ef73@igalia.com>
Date:   Tue, 10 May 2022 10:04:08 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 04/30] firmware: google: Convert regular spinlock into
 trylock on panic path
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>, Evan Green <evgreen@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
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
        jgross@suse.com, john.ogness@linutronix.de,
        Kees Cook <keescook@chromium.org>, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-5-gpiccoli@igalia.com>
 <CAE=gft5Pq25L4KFoPWbftkPF-JN1ex2yws77mMJ4GQnn9W0L2g@mail.gmail.com>
 <adcf6d0e-c37c-6ede-479e-29959d03d8c0@igalia.com> <YnpOv4hAPV4b+6v4@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YnpOv4hAPV4b+6v4@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2022 08:38, Petr Mladek wrote:
> [...]
> I see two more alternative solutions:
> 
> 1st variant is a trick already used in console write() callbacks.
> They do trylock() when oops_in_progress is set. They remember
> the result to prevent double unlock when printing Oops messages and
> the system will try to continue working. For example:
> 
> pl011_console_write(struct console *co, const char *s, unsigned int count)
> {
> [...]
> 	int locked = 1;
> [...]
> 	if (uap->port.sysrq)
> 		locked = 0;
> 	else if (oops_in_progress)
> 		locked = spin_trylock(&uap->port.lock);
> 	else
> 		spin_lock(&uap->port.lock);
> 
> [...]
> 
> 	if (locked)
> 		spin_unlock(&uap->port.lock);
> }
> 
> 
> 2nd variant is to check panic_cpu variable. It is used in printk.c.
> We might move the function to panic.h:
> 
> static bool panic_in_progress(void)
> {
> 	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
> }
> 
> and then do:
> 
> 	if (panic_in_progress()) {
> 		...

Thanks for the review Petr! I feel alternative two is way better, it
checks for panic - the oops_in_progress isn't really enough, since we
can call panic() directly, not necessarily through an oops path, correct?

For me, we could stick with the lock check, but I'll defer to Evan - I
didn't work the V2 patch yet, what do you prefer Evan?


> [...]
> As already mentioned in the other reply, panic() sometimes stops
> the other CPUs using NMI, for example, see kdump_nmi_shootdown_cpus().
> 
> Another situation is when the CPU using the lock ends in some
> infinite loop because something went wrong. The system is in
> an unpredictable state during panic().
> 
> I am not sure if this is possible with the code under gsmi_dev.lock
> but such things really happen during panic() in other subsystems.
> Using trylock in the panic() code path is a good practice.
> 
> Best Regards,
> Petr

Makes total sense, thanks for confirming!
Cheers,


Guilherme
