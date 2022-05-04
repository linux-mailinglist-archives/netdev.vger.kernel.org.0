Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD89519FE6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349968AbiEDMuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbiEDMuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:50:08 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447452CE37;
        Wed,  4 May 2022 05:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UDxTzr/LbFPHIhZF1U36kLmGFtpbBGYhm6tD7CfQBjM=; b=KDrxDW8Mnr1qToRh0yGaDv25Fu
        TWpgQRScRF3dRjjU3pakegMZLqUHmycIdjATA6DbY60uPfya2zQOAwJ0e5erFJc5BJn7o3eV3sQ41
        Tox4yunn4/jA8a3IjyUJT/sI3KcoYtb2p2FNUwcMM3f1g/ex9W0DrY0odKixjZjudGtrtbA3G1JPw
        m7Nny7DVsQFLh+HpvU/q7Yc8/k1hRGwJeSWIAUBYmqnc5ZdThCMVxiKgVNOsyAMWZdrNHmIgXn40c
        w6AF2HzVr+D+OvvIusg4XzuOUWHoF2AYp44ZOOo2CAb1BDljEp1qf8qc23J8WoJ9sqhtbxFJxmFVB
        8aeUFBag==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nmEOH-0003Ke-Oi; Wed, 04 May 2022 14:46:02 +0200
Message-ID: <9581851d-6c61-a2ef-a3c4-6e2ce05eab12@igalia.com>
Date:   Wed, 4 May 2022 09:45:31 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 04/30] firmware: google: Convert regular spinlock into
 trylock on panic path
Content-Language: en-US
To:     Evan Green <evgreen@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        pmladek@suse.com, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
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
 <adcf6d0e-c37c-6ede-479e-29959d03d8c0@igalia.com>
 <CAE=gft623NxqetRssrZnaRmJLSP4BT5=-sVVwtYoHuspO_gULQ@mail.gmail.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <CAE=gft623NxqetRssrZnaRmJLSP4BT5=-sVVwtYoHuspO_gULQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2022 18:56, Evan Green wrote:
> Hi Guilherme,
> [...] 
>> Do you agree with that, or prefer really a parameter in
>> gsmi_shutdown_reason() ? I'll follow your choice =)
> 
> I'm fine with either, thanks for the link. Mostly I want to make sure
> other paths to gsmi_shutdown_reason() aren't also converted to a try.

Hi Evan, thanks for the prompt response! So, I'll proceed like I did in
s390, for consistency.

> [...]
>> Reasoning: the problem with your example is that, by default, secondary
>> CPUs are disabled in the panic path, through an IPI mechanism. IPIs take
>> precedence and interrupt the work in these CPUs, effectively
>> interrupting the "polite work" with the lock held heh
> 
> The IPI can only interrupt a CPU with irqs disabled if the IPI is an
> NMI. I haven't looked before to see if we use NMI IPIs to corral the
> other CPUs on panic. On x86, I grepped my way down to
> native_stop_other_cpus(), which looks like it does a normal IPI, waits
> 1 second, then does an NMI IPI. So, if a secondary CPU has the lock
> held, on x86 it has roughly 1s to finish what it's doing and re-enable
> interrupts before smp_send_stop() brings the NMI hammer down. I think
> this should be more than enough time for the secondary CPU to get out
> and release the lock.
> 
> So then it makes sense to me that you're fixing cases where we
> panicked with the lock held, or hung with the lock held. Given the 1
> second grace period x86 gives us, I'm on board, as that helps mitigate
> the risk that we bailed out early with the try and should have spun a
> bit longer instead. Thanks.
> 
> -Evan

Well, in the old path without "crash_kexec_post_notifiers", we indeed
end-up relying on native_stop_other_cpus() for x86 as you said, and the
"1s rule" makes sense. But after this series (or even before, if the
kernel parameter "crash_kexec_post_notifiers" was used) the function
used to stop CPUs in the panic path is crash_smp_send_stop(), and the
call chain is like:

Main CPU:
crash_smp_send_stop()
--kdump_nmi_shootdown_cpus()
----nmi_shootdown_cpus()

Then, in each CPU (except the main one, running panic() path),
we execute kdump_nmi_callback() in NMI context.

So, we seem to indeed interrupt any context (even with IRQs disabled),
increasing the likelihood of the potential lockups due to stopped CPUs
holding the locks heheh

Thanks again for the good discussion, let me know if anything I'm saying
doesn't make sense - this crash path is a bit convoluted, specially in
x86, I might have understood something wrongly =)
Cheers,


Guilherme
