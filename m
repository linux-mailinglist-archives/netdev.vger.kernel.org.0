Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9816010EB
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiJQOSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiJQOSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:18:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0489642E6;
        Mon, 17 Oct 2022 07:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JVIzeJt+PlF/c5BSNaEmK8JcIYkmC1OpG1XWAf8y8no=; b=RDZeg9BZ0P6y6R4831DxobziKN
        LLGI3W2nkrICpJLXV9Js/l6fbnvtmou0Y0GFk+yjjWcg0vhpjVH5uwDI0m8V9jeo7Ytf7KPnILE6y
        kh75vsYOhceAEM9Yk3FDAqzBSKbAnSSugDw/3hRkoQto+cA6f2hN8D6tJqXCbLKDXB5ysCnmo5zBb
        uvTzBMozd1Y7N1TdjeyqTXy9D6q0rB0MrNRIH9o6pfqUr+axBIqDVRdaQ727OqmoHCa1PbbtwN1Bo
        NgMmxxYqz7Z08BeLZTjI0/uRlFZIb7kuPUPkqTr7Ab9/9lcHKvOHSE50UAgNW+gLsB93QyoPo+D9m
        i3RcbRkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34754)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okQw4-0003LE-Va; Mon, 17 Oct 2022 15:17:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okQvv-00009b-5k; Mon, 17 Oct 2022 15:17:35 +0100
Date:   Mon, 17 Oct 2022 15:17:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        Mark Rutland <mark.rutland@arm.com>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>,
        kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        bp@alien8.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        xuqiang36@huawei.com
Subject: Re: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs
 shutdown paths
Message-ID: <Y01j/3qKUvj346AH@shell.armlinux.org.uk>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-2-gpiccoli@igalia.com>
 <a25cb242-7c85-867c-8a61-f3119458dcdb@igalia.com>
 <8e30b99e-70ed-7d5a-ea1f-3b0fadb644bc@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e30b99e-70ed-7d5a-ea1f-3b0fadb644bc@igalia.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 11:00:46AM -0300, Guilherme G. Piccoli wrote:
> On 18/09/2022 10:58, Guilherme G. Piccoli wrote:
> > On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> >> Currently the regular CPU shutdown path for ARM disables IRQs/FIQs
> >> in the secondary CPUs - smp_send_stop() calls ipi_cpu_stop(), which
> >> is responsible for that. IRQs are architecturally masked when we
> >> take an interrupt, but FIQs are high priority than IRQs, hence they
> >> aren't masked. With that said, it makes sense to disable FIQs here,
> >> but there's no need for (re-)disabling IRQs.
> >>
> >> More than that: there is an alternative path for disabling CPUs,
> >> in the form of function crash_smp_send_stop(), which is used for
> >> kexec/panic path. This function relies on a SMP call that also
> >> triggers a busy-wait loop [at machine_crash_nonpanic_core()], but
> >> without disabling FIQs. This might lead to odd scenarios, like
> >> early interrupts in the boot of kexec'd kernel or even interrupts
> >> in secondary "disabled" CPUs while the main one still works in the
> >> panic path and assumes all secondary CPUs are (really!) off.
> >>
> >> So, let's disable FIQs in both paths and *not* disable IRQs a second
> >> time, since they are already masked in both paths by the architecture.
> >> This way, we keep both CPU quiesce paths consistent and safe.
> >>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: Michael Kelley <mikelley@microsoft.com>
> >> Cc: Russell King <linux@armlinux.org.uk>
> >> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> >>
> 
> Monthly ping - let me know if there's something I should improve in
> order this fix is considered!

Patches don't get applied unless they end up in the patch system.
Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
