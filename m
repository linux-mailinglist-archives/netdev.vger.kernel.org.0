Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4E51577C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378352AbiD2WAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359568AbiD2WAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:00:33 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E8DC594;
        Fri, 29 Apr 2022 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eS25PhwvZQoNO/vrdkaYeu8w1J4I4bLwd4ZTs99JyTA=; b=ECdoj8MPrPw94rqNJkzG67Xg6u
        5w3+r9FZKL3W6Sz5zRa77JB5F86agKTzGYxwlLLEiZXrXTSk2m+k2FuOzlO52C0njkoCAxgy+FOi4
        NbVcSL4Lztxu2l4Ffp2YNwJJ/Y8NKCykCEJYOFD8NTX9U/x1OlE0AF3cSiTkk6ArLGAdmnn9RzvKe
        +YDGf9dxyEhvGPz5vqubLFDl4xc7G7O1n7kxIDUk0ceOUg9ZGVixjcU3/TKND9q/DVjCWl1sG0kaE
        cUjiBbJ/0Gd+0GoqtFAQ2G5bnqvlp008GZC0sOTWOBCZAoUh5dk2HlkdBig7SM6f3egXphVF+FJ+M
        iEBg1fYA==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkYbf-00026w-BA; Fri, 29 Apr 2022 23:56:55 +0200
Message-ID: <32495ca6-d79a-a932-a8e3-19ef54c44c48@igalia.com>
Date:   Fri, 29 Apr 2022 18:56:24 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs
 shutdown path
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
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
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, keescook@chromium.org, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-3-gpiccoli@igalia.com> <87mtg392fm.wl-maz@kernel.org>
 <71d829c4-b280-7d6e-647d-79a1baf9408b@igalia.com>
 <Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 18:45, Russell King (Oracle) wrote:
> [...]
>> Marc, I did some investigation in the code (and tried/failed in the ARM
>> documentation as well heh), but this is still not 100% clear for me.
>>
>> You're saying IPI calls disable IRQs/FIQs by default in the the target
>> CPUs? Where does it happen? I'm a bit confused if this a processor
>> mechanism, or it's in code.
> 
> When we taken an IRQ, IRQs will be masked, FIQs will not. IPIs are
> themselves interrupts, so IRQs will be masked while the IPI is being
> processed. Therefore, there should be no need to re-disable the
> already disabled interrupts.
> 
>> But crash_smp_send_stop() is different, it seems to IPI the other CPUs
>> with the flag IPI_CALL_FUNC, which leads to calling
>> generic_smp_call_function_interrupt() - does it disable interrupts/FIQs
>> as well? I couldn't find it.
> 
> It's buried in the architecture behaviour. When the CPU takes an
> interrupt and jumps to the interrupt vector in the vectors page, it is
> architecturally defined that interrupts will be disabled. If they
> weren't architecturally disabled at this point, then as soon as the
> first instruction is processed (at the interrupt vector, likely a
> branch) the CPU would immediately take another jump to the interrupt
> vector, and this process would continue indefinitely, making interrupt
> handling utterly useless.
> 
> So, you won't find an explicit instruction in the code path from the
> vectors to the IPI handler that disables interrupts - because it's
> written into the architecture that this is what must happen.
> 
> IRQs are a lower priority than FIQs, so FIQs remain unmasked.
> 

Thanks a lot for the *great* explanation Russell, much appreciated.
So, this leads to the both following questions:

a) Shall we then change the patch to only disable FIQs, since it's panic
path and we don't want secondary CPUs getting interrupted, but only
spinning quietly "forever"?

b) How about cleaning ipi_cpu_stop() then, by dropping the call to
local_irq_disable() there, to avoid the double IRQ disabling?

Thanks,


Guilherme
