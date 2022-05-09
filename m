Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542EC51FCFD
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiEIMhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiEIMhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:37:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21BD28BDC9;
        Mon,  9 May 2022 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L3p0/83L4yDVyZoegOtsQfWmJV/6wtv6TZoOXChWFJg=; b=Gm1PabHNS+/VMjWNpRDgN0q7Gz
        okgDM+2WHp5z93ZUGeQzJtlj40ch1Djul+F9LKvzWURwbafLBOoP/NgGu9GSmPuuE28KOgN2Dlog/
        GHXl8dWWFH9IUIBQmU28gspF2npPpEWaJ19eWl8SzxR3mk4Q/F4kmhrZuCV0rVMHSE4nkq5aDi9ss
        tskoNSlPr3h/0gKp/FmRCE42MZtPYeJf36WeID1+imZk2dUy5vrTX2Nb6oqUW3HqWx20YRVV7+Jqn
        2U5xO3lqX+ogULZEqtYM74LQ/XjYNOdW70A5rw6LBK7UHwdRlT2URD08Y6BIbm5BwJqTO8MAols4i
        vbgjN92g==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1no2ZO-0002Vw-CD; Mon, 09 May 2022 14:32:58 +0200
Message-ID: <b5a1370c-1319-24d1-6b2a-629e5c8915ed@igalia.com>
Date:   Mon, 9 May 2022 09:32:27 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 01/30] x86/crash,reboot: Avoid re-disabling VMX in all
 CPUs on crash/restart
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, vkuznets@redhat.com
Cc:     kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, will@kernel.org,
        "David P . Reed" <dpreed@deepplum.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-2-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220427224924.592546-2-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2022 19:48, Guilherme G. Piccoli wrote:
> In the panic path we have a list of functions to be called, the panic
> notifiers - such callbacks perform various actions in the machine's
> last breath, and sometimes users want them to run before kdump. We
> have the parameter "crash_kexec_post_notifiers" for that. When such
> parameter is used, the function "crash_smp_send_stop()" is executed
> to poweroff all secondary CPUs through the NMI-shootdown mechanism;
> part of this process involves disabling virtualization features in
> all CPUs (except the main one).
> 
> Now, in the emergency restart procedure we have also a way of
> disabling VMX in all CPUs, using the same NMI-shootdown mechanism;
> what happens though is that in case we already NMI-disabled all CPUs,
> the emergency restart fails due to a second addition of the same items
> in the NMI list, as per the following log output:
> 
> sysrq: Trigger a crash
> Kernel panic - not syncing: sysrq triggered crash
> [...]
> Rebooting in 2 seconds..
> list_add double add: new=<addr1>, prev=<addr2>, next=<addr1>.
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:29!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI
> 
> In order to reproduce the problem, users just need to set the kernel
> parameter "crash_kexec_post_notifiers" *without* kdump set in any
> system with the VMX feature present.
> 
> Since there is no benefit in re-disabling VMX in all CPUs in case
> it was already done, this patch prevents that by guarding the restart
> routine against doubly issuing NMIs unnecessarily. Notice we still
> need to disable VMX locally in the emergency restart.
> 
> Fixes: ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported)
> Fixes: 0ee59413c967 ("x86/panic: replace smp_send_stop() with kdump friendly version in panic path")
> Cc: David P. Reed <dpreed@deepplum.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  arch/x86/include/asm/cpu.h |  1 +
>  arch/x86/kernel/crash.c    |  8 ++++----
>  arch/x86/kernel/reboot.c   | 14 ++++++++++++--
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 

Hi Paolo / Sean / Vitaly, sorry for the ping.
But do you think this fix is OK from the VMX point-of-view?

I'd like to send a V2 of this set soon, so any review here is highly
appreciated!

Cheers,


Guilherme

