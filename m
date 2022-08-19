Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D559A854
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbiHSWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240485AbiHSWTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:19:08 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2E3D8B37;
        Fri, 19 Aug 2022 15:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=efMK60nr83yuRCx5Ljwx52Fk9k5SHvdIGer1v3Qxdhs=; b=SjQSOrdIC0PRcYZolS77irogck
        Mcx5v/0ZNaHxyEbxFL3onPgr5fMu09Pd2ybtyiuoazQiRcE4q1BCAdwvuZlYFgooxjD3BxoZoH4PK
        E/IlV6B+dBp+jSqRHfRRW0pIXAMZz1tIYerq39GhYuucnq6cSpZZ0C96yp+R/lJeJCEuPn+qomTxx
        BGxXGbnwkISEpDio7Vmfl6/6+0bvNYjEYtE6gc8UcjowEqH3UBtnvIUbDmL7qJyOrM5MVw4W2US5T
        3K1YJX1V/eWgE3S5pK2h+HxIYqHNfmis/7gh2PMnSysILIOzmrBUaMLqgXhAwCFkg2rzBmE/TgWP6
        uuEMeQ0Q==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAKN-00Casf-VT; Sat, 20 Aug 2022 00:18:59 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, xuqiang36@huawei.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs shutdown paths
Date:   Fri, 19 Aug 2022 19:17:21 -0300
Message-Id: <20220819221731.480795-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819221731.480795-1-gpiccoli@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the regular CPU shutdown path for ARM disables IRQs/FIQs
in the secondary CPUs - smp_send_stop() calls ipi_cpu_stop(), which
is responsible for that. IRQs are architecturally masked when we
take an interrupt, but FIQs are high priority than IRQs, hence they
aren't masked. With that said, it makes sense to disable FIQs here,
but there's no need for (re-)disabling IRQs.

More than that: there is an alternative path for disabling CPUs,
in the form of function crash_smp_send_stop(), which is used for
kexec/panic path. This function relies on a SMP call that also
triggers a busy-wait loop [at machine_crash_nonpanic_core()], but
without disabling FIQs. This might lead to odd scenarios, like
early interrupts in the boot of kexec'd kernel or even interrupts
in secondary "disabled" CPUs while the main one still works in the
panic path and assumes all secondary CPUs are (really!) off.

So, let's disable FIQs in both paths and *not* disable IRQs a second
time, since they are already masked in both paths by the architecture.
This way, we keep both CPU quiesce paths consistent and safe.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- No changes.

V2:
- Small wording improvement (thanks Michael Kelley);
- Only disable FIQs, since IRQs are masked by architecture
definition when we take an interrupt. Thanks a lot Russell
and Marc for the discussion [0].

Should we add a Fixes tag here? If so, maybe the proper target is:
b23065313297 ("ARM: 6522/1: kexec: Add call to non-crashing cores through IPI")

[0] https://lore.kernel.org/lkml/Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk/


 arch/arm/kernel/machine_kexec.c | 2 ++
 arch/arm/kernel/smp.c           | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index f567032a09c0..0b482bcb97f7 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -77,6 +77,8 @@ void machine_crash_nonpanic_core(void *unused)
 {
 	struct pt_regs regs;
 
+	local_fiq_disable();
+
 	crash_setup_regs(&regs, get_irq_regs());
 	printk(KERN_DEBUG "CPU %u will stop doing anything useful since another CPU has crashed\n",
 	       smp_processor_id());
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 978db2d96b44..36e6efad89f3 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -600,6 +600,8 @@ static DEFINE_RAW_SPINLOCK(stop_lock);
  */
 static void ipi_cpu_stop(unsigned int cpu)
 {
+	local_fiq_disable();
+
 	if (system_state <= SYSTEM_RUNNING) {
 		raw_spin_lock(&stop_lock);
 		pr_crit("CPU%u: stopping\n", cpu);
@@ -609,9 +611,6 @@ static void ipi_cpu_stop(unsigned int cpu)
 
 	set_cpu_online(cpu, false);
 
-	local_fiq_disable();
-	local_irq_disable();
-
 	while (1) {
 		cpu_relax();
 		wfe();
-- 
2.37.2

