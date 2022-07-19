Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6863657A78E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiGSTyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGSTyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:54:41 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3090F5508F;
        Tue, 19 Jul 2022 12:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NzJkqrhLfp7az4+yXZfyI4Xu06KCclK8E00ozdzhX0c=; b=kdE4g8XhcHzqUShnmdXBDwW8CU
        OKSkCidYSdZziHR8EayCsAtG4cw7rk5rgDxu3QNyJ/s1/XJ3I+q/y5KabMaMztGbbjwyt1AUIn0Y0
        oxpoeK+/oMlAl7WHHn7ESkubFWWkuaIheBOQp1mBA4LhHsnGFDPEwQkiIomtoBXl5/FafdmOS95q5
        ycbsOhJPdA4POSqNNrDpnmvFYkvAFzugdNZnVYvIwYeiYrrp2mjj2cwS3+XYdiTWkxPb5zSoQaRJ5
        UB3/nFZAllA3I2vsg59AW+q7p2v6N/ypoM6F626B+IzDh13LT0/S6krgZC3iPFY7hyBPbAJAZzDTC
        fjfWof/A==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtIf-006fA7-Fi; Tue, 19 Jul 2022 21:54:34 +0200
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
        will@kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 01/13] ARM: Disable FIQs (but not IRQs) on CPUs shutdown paths
Date:   Tue, 19 Jul 2022 16:53:14 -0300
Message-Id: <20220719195325.402745-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719195325.402745-1-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index 73fc645fc4c7..0c24ec1fd88e 100644
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
2.37.1

