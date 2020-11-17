Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31A32B6FFB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgKQUXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:23:41 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:55217 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgKQUXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:23:40 -0500
Received: from orion.localdomain ([95.118.38.12]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mgf4k-1k2kx032Zo-00h5N4; Tue, 17 Nov 2020 21:23:10 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] x86: make vmware support optional
Date:   Tue, 17 Nov 2020 21:23:07 +0100
Message-Id: <20201117202308.7568-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:aQMhedQ9DH39pXkkk4keWo4+iVb3sE6UEGSxAPzrx3B0JtGgs4V
 DA5iExg74yDH1OZ1pfVTN4yTAO1yQibGTI3w/v1efyGvDgxZg0JHxW8IRi7Dc0TUGbj/vqm
 pUsjdNmwshnFBXqLm5uvKMXRgQnlX36AEYKNvYosup2ySVcpEvrPJ8xkcqvMOi9YsBB1Q4G
 PVzu/yEkl56UQYA+ONraQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YHRAOHj2caQ=:88h1gSmPZjYX3Ldqfpbe/h
 eT0nrUL2WiqntO1qM2V9YPwrA/Afg29o9dYc2xo6BIrDwQPjpv3ic+e/qC/mOMh2RUDpW8laH
 t3SOUXFaXixiGK+2Xhl71acMJkg+llI60ow0Mc3orPIo99DepBijk/bVgWR0F/0N0uZSC1pd/
 fZde7R2R8jYxVCeWvlCFfMl8g277HvFAIflgM50jGaeyBC70MYG0DhkWhICcAPYY50P4vPns2
 sDY9abCgfBHRR/Dry21ICRa6h54BrMi1A2qtDlEHtOm44ukcNJgZ7DWdjYWslG9i2SXvGtqMm
 PJvpHJNYshIr/K9IxXVtT2sN8j4Bm3vRlwVRaxDrSBIamyMYBmX2GXyew33vb5nvtFcLOAxuC
 uiBhkcoPaz/MFeUVCsUS7K+RHldpYu9hpecjlhAtygFJ/HIc2BdN27z7Ns/uE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to opt-out from vmware support

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 arch/x86/Kconfig                 | 7 +++++++
 arch/x86/kernel/cpu/Makefile     | 4 +++-
 arch/x86/kernel/cpu/hypervisor.c | 2 ++
 drivers/input/mouse/Kconfig      | 2 +-
 drivers/misc/Kconfig             | 2 +-
 drivers/ptp/Kconfig              | 2 +-
 6 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f6946b81f74a..c227c1fa0091 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -801,6 +801,13 @@ config X86_HV_CALLBACK_VECTOR
 
 source "arch/x86/xen/Kconfig"
 
+config VMWARE_GUEST
+	bool "Vmware Guest support"
+	default y
+	help
+	  This option enables several optimizations for running under the
+	  VMware hypervisor.
+
 config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 93792b457b81..a615b0152bf0 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -51,7 +51,9 @@ obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
-obj-$(CONFIG_HYPERVISOR_GUEST)		+= vmware.o hypervisor.o mshyperv.o
+obj-$(CONFIG_HYPERVISOR_GUEST)		+= hypervisor.o mshyperv.o
+obj-$(CONFIG_VMWARE_GUEST)		+= vmware.o
+
 obj-$(CONFIG_ACRN_GUEST)		+= acrn.o
 
 ifdef CONFIG_X86_FEATURE_NAMES
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 553bfbfc3a1b..c0e770a224aa 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -34,7 +34,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #ifdef CONFIG_XEN_PVHVM
 	&x86_hyper_xen_hvm,
 #endif
+#ifdef CONFIG_VMWARE_GUEST
 	&x86_hyper_vmware,
+#endif
 	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index d8b6a5dab190..29ced69d5c85 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -186,7 +186,7 @@ config MOUSE_PS2_FOCALTECH
 
 config MOUSE_PS2_VMMOUSE
 	bool "Virtual mouse (vmmouse)"
-	depends on MOUSE_PS2 && X86 && HYPERVISOR_GUEST
+	depends on MOUSE_PS2 && X86 && VMWARE_GUEST
 	help
 	  Say Y here if you are running under control of VMware hypervisor
 	  (ESXi, Workstation or Fusion). Also make sure that when you enable
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fafa8b0d8099..d2bd8eff6eb6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -363,7 +363,7 @@ config DS1682
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
-	depends on VMWARE_VMCI && X86 && HYPERVISOR_GUEST
+	depends on VMWARE_VMCI && X86 && VMWARE_GUEST
 	select MEMORY_BALLOON
 	help
 	  This is VMware physical memory management driver which acts
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 942f72d8151d..6bf30153270e 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -141,7 +141,7 @@ config PTP_1588_CLOCK_IDTCM
 
 config PTP_1588_CLOCK_VMW
 	tristate "VMware virtual PTP clock"
-	depends on ACPI && HYPERVISOR_GUEST && X86
+	depends on ACPI && VMWARE_GUEST && X86
 	depends on PTP_1588_CLOCK
 	help
 	  This driver adds support for using VMware virtual precision
-- 
2.11.0

