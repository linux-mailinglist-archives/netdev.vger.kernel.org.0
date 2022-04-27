Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B335125E5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbiD0Wzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiD0Wxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:44 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7757C8A305;
        Wed, 27 Apr 2022 15:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9bJIN4/MOEhLx8CsVfKAquGTzb1mVDbHr+j6ymCNHAs=; b=S+EoVVMbG0R6l0pBfRnMsKZosp
        2PXBHwhmghS5Lvs4v4GQMUSqpGyoQ5U6Zbnyj6sMhUP4BCGILxO7PkeMyVqV/H8eeh+l7ihT1MYQn
        6lRWijWvq/MbBgY8W5xo5rf6VIJ8bQ3A6HUNn+RlRorsijlroe/vsascbDWK+dCTLeTv/edmbXzZt
        IkkQl7Ezob0EK5zEWLgIk+XPPHoVSiw2Ov7kaRBDa36NQrRgmO2O3HFxvBLZEYb5QzmHEcsWLMOdr
        YdjDzKF3as62X+/HBzxjW/bJqz3Ux15HOHGOCZtJDgeQcPUWNNi8PdpLZsxk0QJWHs39xjqIBwc58
        XGSV7jaw==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqU9-0001ye-3z; Thu, 28 Apr 2022 00:50:14 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
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
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
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
        will@kernel.org, Marc Zyngier <maz@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs shutdown path
Date:   Wed, 27 Apr 2022 19:48:56 -0300
Message-Id: <20220427224924.592546-3-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
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
is responsible for that. This makes sense, since we're turning off
such CPUs, putting them in an endless busy-wait loop.

Problem is that there is an alternative path for disabling CPUs,
in the form of function crash_smp_send_stop(), used for kexec/panic
paths. This functions relies in a SMP call that also triggers a
busy-wait loop [at machine_crash_nonpanic_core()], but *without*
disabling interrupts. This might lead to odd scenarios, like early
interrupts in the boot of kexec'd kernel or even interrupts in
other CPUs while the main one still works in the panic path and
assumes all secondary CPUs are (really!) off.

This patch mimics the ipi_cpu_stop() interrupt disable mechanism
in the crash CPU shutdown path, hence disabling IRQs/FIQs in all
secondary CPUs in the kexec/panic path as well.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/arm/kernel/machine_kexec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index f567032a09c0..ef788ee00519 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -86,6 +86,9 @@ void machine_crash_nonpanic_core(void *unused)
 	set_cpu_online(smp_processor_id(), false);
 	atomic_dec(&waiting_for_crash_ipi);
 
+	local_fiq_disable();
+	local_irq_disable();
+
 	while (1) {
 		cpu_relax();
 		wfe();
-- 
2.36.0

