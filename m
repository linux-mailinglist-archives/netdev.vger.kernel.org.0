Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466595156FE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbiD2Vmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiD2Vmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:42:32 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4AFABF6F;
        Fri, 29 Apr 2022 14:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zaZR6AionffdB1xNnJGX+2SLzxIRGHxmDTzkdAsF8Lw=; b=f2se15ohqCxFdZ9Cbwp90MFGzT
        jTOap9gxEPPT4aTyNt5E3ZHiiiT+V3lzyiVXivZvxSS+ElUToKTRjGns0j7W5gu+rUZwjHaY5hGeN
        otkXyAwqu6HD3avUoXVIxjGs+UlKUlBOe/StJroDKFugT/kZL7npThsCdsHpDWufEk+wh4fOOIDQw
        l7OyKb0Jm89RaQG7TSk5bTRs2tlRpACA1IvBqK2eiZLAu6g1+MyYc/cQwPm5SUuYLGV0bPXJdES3s
        lnyV4bPi3phdA0er49wiR1R3K1IMQcdtRi5k8Pou9s9nypOSId//IHiPuzLjmzkdZNlZyJjIhfVzV
        toxHByUQ==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkYK9-0001bD-CM; Fri, 29 Apr 2022 23:38:49 +0200
Message-ID: <71d829c4-b280-7d6e-647d-79a1baf9408b@igalia.com>
Date:   Fri, 29 Apr 2022 18:38:19 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs
 shutdown path
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
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
        will@kernel.org, Russell King <linux@armlinux.org.uk>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-3-gpiccoli@igalia.com> <87mtg392fm.wl-maz@kernel.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <87mtg392fm.wl-maz@kernel.org>
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

Thanks Marc and Michael for the review/discussion.

On 29/04/2022 15:20, Marc Zyngier wrote:
> [...]

> My expectations would be that, since we're getting here using an IPI,
> interrupts are already masked. So what reenabled them the first place?
> 
> Thanks,
> 
> 	M.
> 

Marc, I did some investigation in the code (and tried/failed in the ARM
documentation as well heh), but this is still not 100% clear for me.

You're saying IPI calls disable IRQs/FIQs by default in the the target
CPUs? Where does it happen? I'm a bit confused if this a processor
mechanism, or it's in code.

Looking the smp_send_stop() in arch/arm/, it does IPI the CPUs, with the
flag IPI_CPU_STOP, eventually calling ipi_cpu_stop(), and the latter
does disable IRQ/FIQ in code - that's where I stole my code from.

But crash_smp_send_stop() is different, it seems to IPI the other CPUs
with the flag IPI_CALL_FUNC, which leads to calling
generic_smp_call_function_interrupt() - does it disable interrupts/FIQs
as well? I couldn't find it.

Appreciate your clarifications about that, thanks again.
Cheers,


Guilherme
