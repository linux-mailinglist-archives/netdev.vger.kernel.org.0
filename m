Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E154522543
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiEJUNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiEJUNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:13:12 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764F1A051;
        Tue, 10 May 2022 13:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gJbDvxZCHLE9Xc3dgTDCPLuG4mRgGmv6OD8aG7M3JDQ=; b=g3Nx+lB9bAjkoFhfBAw/tKnujE
        HE49wVGnvYPT6LdjDh7XC7p9pg3dQOiKQmVqs5yBTQcMLD/Qb7loz7GoYe9PtUSJMIbL1xCX7WOmP
        Vje/KjqWSNfESrwYFEgzZTAiGGwdZ+mo/M5Y4DNbzDEU8fdx1WAqo3dhuepVJxkwfJ6AyMl1hzYbL
        37Bt4s+cXuNOUF+dflK9we5prMFoOFLTCAg4y4fzR8H75s0j2xAYXr1Tlb+YwkS4w97u5Z+/kankc
        sGAGYvqPkX6LoRGzU4WQr1NirsakQGzt8bG3WfLCBDveLwXiZiOyOvqFNe/oiLGpRxJijV5VJBRHK
        Ucite2AA==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1noWDn-0000dk-Tv; Tue, 10 May 2022 22:12:41 +0200
Message-ID: <24a56892-adb3-809c-8c35-b5b5f001c283@igalia.com>
Date:   Tue, 10 May 2022 17:11:08 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 01/30] x86/crash,reboot: Avoid re-disabling VMX in all
 CPUs on crash/restart
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, "David P . Reed" <dpreed@deepplum.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-2-gpiccoli@igalia.com> <Ynk40U/KA+hLBZRC@google.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Ynk40U/KA+hLBZRC@google.com>
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

On 09/05/2022 12:52, Sean Christopherson wrote:
> I find the shortlog to be very confusing, the bug has nothing to do with disabling
> VMX and I distinctly remember wrapping VMXOFF with exception fixup to prevent doom
> if VMX is already disabled :-).  The issue is really that nmi_shootdown_cpus() doesn't
> play nice with being called twice.
> 

Hey Sean, OK - I agree with you, the issue is really about the double
list addition.

> [...]
> 
> Call stacks for the two callers would be very, very helpful.
> [...]

> This feels like were just adding more duct tape to the mess.  nmi_shootdown() is
> still unsafe for more than one caller, and it takes a _lot_ of staring and searching
> to understand that crash_smp_send_stop() is invoked iff CONFIG_KEXEC_CORE=y, i.e.
> that it will call smp_ops.crash_stop_other_cpus() and not just smp_send_stop().
> 
> Rather than shared a flag between two relatively unrelated functions, what if we
> instead disabling virtualization in crash_nmi_callback() and then turn the reboot
> call into a nop if an NMI shootdown has already occurred?  That will also add a
> bit of documentation about multiple shootdowns not working.
> 
> And I believe there's also a lurking bug in native_machine_emergency_restart() that
> can be fixed with cleanup.  SVM can also block INIT and so should be disabled during
> an emergency reboot.
> 
> The attached patches are compile tested only.  If they seem sane, I'll post an
> official mini series.

Thanks Sean, it makes sense - my patch is more a "band-aid" whereas
yours fixes it in a more generic way. Confess I found the logic of your
patch complex, but as you said, it requires a *lot* of code analysis to
understand these multiple shutdown patches, the problem is complicated
by nature heh

I've tested your patch 0001 and it works well for all cases [0], so go
ahead and submit the miniseries, feel free to add:

Reported-and-tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>


I've read patch 0002 and it makes sense to me as well, a good proactive
bug fix =)

With that said, I'll of course drop this one from V2 of this series.
Cheers,


Guilherme




[0]
A summary of my tests and the code paths that the panic shutdown take
depending on some conditions:

New function that disables VMX/SVM: cpu_crash_disable_virtualization()
[should be executed in every online CPU on shutdown)

The panic path triggers the following call stacks depending on kdump and
post_notifiers:


(1) kexec/kdump + !crash_kexec_post_notifiers
->machine_crash_shutdown()
----.crash_shutdown() <custom handler>
------native_machine_crash_shutdown() [all custom handlers except Xen PV
call the native generic function]
--------crash_smp_send_stop()
----------kdump_nmi_shootdown_cpus()
------------nmi_shootdown_cpus(kdump_nmi_callback)
--------------crash_nmi_callback()
----------------kdump_nmi_callback()
------------------cpu_crash_disable_virtualization()


(2) kexec/kdump + crash_kexec_post_notifiers
->crash_smp_send_stop()
----kdump_nmi_shootdown_cpus()
------nmi_shootdown_cpus(kdump_nmi_callback)
--------crash_nmi_callback()
----------kdump_nmi_callback()
------------cpu_crash_disable_virtualization()

After this path, will execute machine_crash_shutdown() but
crash_smp_send_stop()
is guarded against double execution. Also, emergency restart calls
emergency_vmx_disable_all() .


(3) !kexec/kdump + crash_kexec_post_notifiers

Same as (2)


(4) !kexec/kdump + !crash_kexec_post_notifiers
-> smp_send_stop()
----native_stop_other_cpus()
------apic_send_IPI_allbutself(REBOOT_VECTOR)
--------sysvec_reboot
----------cpu_emergency_vmxoff() <if the IPI approach succeeded, CPU
stopped here>

If not:
------register_stop_handler()
--------apic_send_IPI_allbutself(NMI_VECTOR)
----------smp_stop_nmi_callback()
------------cpu_emergency_vmxoff()

After that, emergency_vmx_disable_all() gets called in the emergency
restart path as well.
