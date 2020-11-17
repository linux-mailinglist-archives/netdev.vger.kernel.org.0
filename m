Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EBF2B6FFE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgKQUXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:23:42 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51667 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgKQUXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:23:41 -0500
Received: from orion.localdomain ([95.118.38.12]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MPXMa-1ksvIj1mVO-00MgRQ; Tue, 17 Nov 2020 21:23:11 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] x86: make hyperv support optional
Date:   Tue, 17 Nov 2020 21:23:08 +0100
Message-Id: <20201117202308.7568-2-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201117202308.7568-1-info@metux.net>
References: <20201117202308.7568-1-info@metux.net>
X-Provags-ID: V03:K1:BgMdxQqz+4cbD/qdDNJN3Ul44DDzOcucX7OQQF5mExr0hrvibj3
 jlliB9hkpyWQ7fm7aEw+TiHppj4aHIRMU9L4t32Dvpl/YQX1IyijLcrspy4r6AMsNX5hSv+
 jKNM76P58FwQhs/mng8MWZsJ9jRzkL7LU++z4Ob0TSqVS9WERPnzEbSFK0HrmEaRGuLvjHd
 jFm4lD/jJpv5uxAJr8nMA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3yLVPCypgnA=:XprJRzAno0MASne4OrR4Jl
 BvlRoNricagJ8yqm1/R8KWFUNWiw5MKakpnSNICGMP3BAKPjzauaR54ikOGfNdBPwk2BXnV3O
 xQtazhVh7AQRzZOGQGbj+1GeqCizu/94x8G7to+C9PdiEDI3JyrN2t/zyqdt290qxN3G7fteX
 L3klq1bkTACe7MnxhJqbfKe1HpCo053FYrXFqWvYbdfkJ4e/lRVSdvVbIJ+ZAiLRQiuYFMeQI
 RX8CKav8e/oAd53h+thfVKcq8FY583xS7mYYI2n3vo8sgkxarUrnXNlWEQf3EFeN7QyII4UZy
 ZARR0IKd+qTKmkS35p85LOljKdpJ7gKmWRvRan3/A+yxsFlao0w7a+V9MwkthXrPbcADoyCPY
 Rf55RS6yA+eoFnonzF6AE3bZN6QI0dnRpK002FaACaLrUwxxNiGwI7CFewuWK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to opt-out from hyperv support.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 arch/x86/Kconfig                 | 7 +++++++
 arch/x86/kernel/cpu/Makefile     | 4 ++--
 arch/x86/kernel/cpu/hypervisor.c | 2 ++
 drivers/hv/Kconfig               | 2 +-
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c227c1fa0091..60aab344d6ab 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -808,6 +808,13 @@ config VMWARE_GUEST
 	  This option enables several optimizations for running under the
 	  VMware hypervisor.
 
+config HYPERV_GUEST
+	bool "HyperV Guest support"
+	default y
+	help
+	  This option enables several optimizations for running under the
+	  HyperV hypervisor.
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

