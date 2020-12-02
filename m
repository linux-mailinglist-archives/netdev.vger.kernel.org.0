Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87942CC8DA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgLBVWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:22:55 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:49579 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgLBVWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:22:54 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N4hBx-1k4jqp1hY7-011lWC; Wed, 02 Dec 2020 22:19:52 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/2] x86: make Hyper-V support optional
Date:   Wed,  2 Dec 2020 22:19:49 +0100
Message-Id: <20201202211949.17730-2-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202211949.17730-1-info@metux.net>
References: <20201202211949.17730-1-info@metux.net>
X-Provags-ID: V03:K1:ZYw8JALVJyM7+za0bb7JmaCzzkuqUcrysb74jSbDe7uDw14f2UV
 vdlkaMrjlMmq4uyMuGRmD9OZbCTRRKrCLuendqIOAn2gg4DNusUa+hAdknrE+ZI9jFT9u4s
 xjWldC7c477x6uphyaHewlc00iTZVx6lm7ENjYAu5nLL0yVt58pb4JI+AymvGxfp2VYszzg
 xQI/vRldWoOHMfKFk23Mw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SsW/Vx7eYCw=:zIS1LJ0NodFzrr2suQ0yaF
 j72DldIEnk06X32w5FJ1IP3lcj4G6cTYvNPUphwmT4OdwbNvac9HFiBmB8w6AwTzZyU7Ik7jY
 e30Tx/r2YicPKUGV4dShnlyGJ4ENU/J/siK3nxDXoqCqujOcxW1T0sYxq0Q49Apt075LJpdg4
 cJbDddQBqG5pG0hUwJw0DU8ohtKFuN4RWKn8hjcpNDZlstgeWqZNUEul9rFfqOZitUlQCfidH
 4LkbOlD6J7KKT3+CSA0nLjXfrC9WGyerneO9j1K1ZSwBVtQPKTxUXI2WAysMrPOXg+aSO30eC
 sgl7t3xt7dA/smbOGwApOUsLQ/4vQ+UphimZDC74T7f2k7lrLYO/PVxbX4J4VTxwjplm1/HZ3
 n/h+68yvBjtHHhnUaMhQBEWfl5dyS5BPhuwQjmxUzQ2pzCTzkqYJXM4xv3QGK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to opt-out from Hyper-V support, for minimized kernels
that never will by run under Hyper-V. (eg. high-density virtualization
or embedded systems)

Average distro kernel will leave it on, therefore default to y.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 arch/x86/Kconfig                 | 11 +++++++++++
 arch/x86/kernel/cpu/Makefile     |  4 ++--
 arch/x86/kernel/cpu/hypervisor.c |  2 ++
 drivers/hv/Kconfig               |  2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eff12460cb3c..57d20591d6ee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -812,6 +812,17 @@ config VMWARE_GUEST
 	  density virtualization or embedded systems running (para)virtualized
 	  workloads.
 
+config HYPERV_GUEST
+	bool "Hyper-V Guest support"
+	default y
+	help
+	  This option enables several optimizations for running under the
+	  Hyper-V hypervisor.
+
+	  Disabling it saves a few kb, for stripped down kernels eg. in high
+	  density virtualization or embedded systems running (para)virtualized
+	  workloads.
+
 config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a615b0152bf0..5536b801cb44 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -51,9 +51,9 @@ obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
-obj-$(CONFIG_HYPERVISOR_GUEST)		+= hypervisor.o mshyperv.o
+obj-$(CONFIG_HYPERVISOR_GUEST)		+= hypervisor.o
 obj-$(CONFIG_VMWARE_GUEST)		+= vmware.o
-
+obj-$(CONFIG_HYPERV_GUEST)		+= mshyperv.o
 obj-$(CONFIG_ACRN_GUEST)		+= acrn.o
 
 ifdef CONFIG_X86_FEATURE_NAMES
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index c0e770a224aa..32d6b2084d05 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -37,7 +37,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #ifdef CONFIG_VMWARE_GUEST
 	&x86_hyper_vmware,
 #endif
+#ifdef CONFIG_HYPERV_GUEST
 	&x86_hyper_ms_hyperv,
+#endif
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
 #endif
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 79e5356a737a..7b3094c59a81 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -4,7 +4,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERVISOR_GUEST
+	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERV_GUEST
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR
 	help
-- 
2.11.0

