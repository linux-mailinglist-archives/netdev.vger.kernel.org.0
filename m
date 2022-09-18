Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D545BBE34
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIROAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIROAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:00:15 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B97515A12;
        Sun, 18 Sep 2022 07:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KeyHnDwtz03NUIbQKH0mlcSz0RqoE8e8mbmPZs7mkVU=; b=GyOYQyWwt07jEidfRgym5hfyeF
        Z4VYyLbUDS88clnJfP6wT0v8u9Gms5C6knDRu2rd8MMCgTFaB4VWuaWyaIp2gbnvvbH9zpXzZ8+uD
        xmj4oh/KWun0X4Nq1P3vat9RDKcGAXckDahHA1MaAmjhznR4AjwuNzJdLVWv6+5ZTb/S8iINUA/Ml
        oX+h7kLt+O5SEPLkMCwAGYqSAMbNdJQOTikSXqr3LZSL+1lYRtQAvRtuSwl9ZpbxIZyPLm419tv7n
        w9swsXuoBv0tfQG23yq1NaMCcKnfM8mPLX74wNC5L3jNPbiqyiU6lMUxLiYd6lcF7MRVq/n58xRDE
        AOb6wX9Q==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZup8-0080cc-ON; Sun, 18 Sep 2022 15:59:06 +0200
Message-ID: <a25cb242-7c85-867c-8a61-f3119458dcdb@igalia.com>
Date:   Sun, 18 Sep 2022 10:58:34 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs
 shutdown paths
Content-Language: en-US
To:     Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        Mark Rutland <mark.rutland@arm.com>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
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
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-2-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-2-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> Currently the regular CPU shutdown path for ARM disables IRQs/FIQs
> in the secondary CPUs - smp_send_stop() calls ipi_cpu_stop(), which
> is responsible for that. IRQs are architecturally masked when we
> take an interrupt, but FIQs are high priority than IRQs, hence they
> aren't masked. With that said, it makes sense to disable FIQs here,
> but there's no need for (re-)disabling IRQs.
> 
> More than that: there is an alternative path for disabling CPUs,
> in the form of function crash_smp_send_stop(), which is used for
> kexec/panic path. This function relies on a SMP call that also
> triggers a busy-wait loop [at machine_crash_nonpanic_core()], but
> without disabling FIQs. This might lead to odd scenarios, like
> early interrupts in the boot of kexec'd kernel or even interrupts
> in secondary "disabled" CPUs while the main one still works in the
> panic path and assumes all secondary CPUs are (really!) off.
> 
> So, let's disable FIQs in both paths and *not* disable IRQs a second
> time, since they are already masked in both paths by the architecture.
> This way, we keep both CPU quiesce paths consistent and safe.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - No changes.
> 
> V2:
> - Small wording improvement (thanks Michael Kelley);
> - Only disable FIQs, since IRQs are masked by architecture
> definition when we take an interrupt. Thanks a lot Russell
> and Marc for the discussion [0].
> 
> Should we add a Fixes tag here? If so, maybe the proper target is:
> b23065313297 ("ARM: 6522/1: kexec: Add call to non-crashing cores through IPI")
> 
> [0] https://lore.kernel.org/lkml/Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk/
> 
> 
>  arch/arm/kernel/machine_kexec.c | 2 ++
>  arch/arm/kernel/smp.c           | 5 ++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
> index f567032a09c0..0b482bcb97f7 100644
> --- a/arch/arm/kernel/machine_kexec.c
> +++ b/arch/arm/kernel/machine_kexec.c
> @@ -77,6 +77,8 @@ void machine_crash_nonpanic_core(void *unused)
>  {
>  	struct pt_regs regs;
>  
> +	local_fiq_disable();
> +
>  	crash_setup_regs(&regs, get_irq_regs());
>  	printk(KERN_DEBUG "CPU %u will stop doing anything useful since another CPU has crashed\n",
>  	       smp_processor_id());
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 978db2d96b44..36e6efad89f3 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -600,6 +600,8 @@ static DEFINE_RAW_SPINLOCK(stop_lock);
>   */
>  static void ipi_cpu_stop(unsigned int cpu)
>  {
> +	local_fiq_disable();
> +
>  	if (system_state <= SYSTEM_RUNNING) {
>  		raw_spin_lock(&stop_lock);
>  		pr_crit("CPU%u: stopping\n", cpu);
> @@ -609,9 +611,6 @@ static void ipi_cpu_stop(unsigned int cpu)
>  
>  	set_cpu_online(cpu, false);
>  
> -	local_fiq_disable();
> -	local_irq_disable();
> -
>  	while (1) {
>  		cpu_relax();
>  		wfe();

[+CC all ARM folks I could find]

Hi folks, sorry for the ping. Any reviews are greatly appreciated in
this one - this is the V3 of the series but I never got any specific
review for this patch.

Based on a previous discussion with Russell and Marc [0], seems this one
makes sense and fixes an inconsistency related to kdump/panic.

Really appreciate reviews or at least some indication on which path I
should take to get this potentially merged.

Cheers,


Guilherme


[0] https://lore.kernel.org/lkml/Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk/
