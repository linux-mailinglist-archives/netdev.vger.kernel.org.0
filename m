Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E94B2CC8D7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbgLBVWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:22:55 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:48861 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgLBVWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:22:55 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M6m1g-1koRgX3GjG-008HQP; Wed, 02 Dec 2020 22:19:51 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] x86: make VMware support optional
Date:   Wed,  2 Dec 2020 22:19:48 +0100
Message-Id: <20201202211949.17730-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:M0EvxXaN0cRaHbPb8XuaI2edSaP/HobpTTCXvKZQcRBzxPyGwa2
 hxQPq6hkNWD7lhx7Ultkh+X2isbJiePeNcLHbYGU62gCjXBeWg4AuE2MZPekNAvZ4IG0RxF
 YuUQig9sZl2yIJZnnZdp3XA/4ora9PFX77d265Abp9z4DI0lp+APR2zl9mrl/Wf0O5sPYuC
 RmyvbQjvu5s4+QPjEm7Xw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+CqD6IYdmE8=:kS66WbhQji/2ME7GMaJYJR
 w6XzE7zbaNfUXV7qFiHPptu7c4KQCnWI3gsuhwwT0YHxp4DFsH/gM8COfBmFS3n/1Drkwvn0m
 2+VgFPfB5U5T6Ie6C9reiZvaayx1E9BNWqDAAowdZdEa/7xVGTbyo6jmT9tKbrVOzltjwLU3S
 BpWxLKZtIaWBW1Ey2RVn/+nZ7xIycyo+50JG0ocCDH5ZQwpDjwXoIhfYawmZNfITrxuHsmEU9
 l2eXsGCF1Gq71rjJgNDFSdSRCTRTY3LopjX9WepmvqXSHN1BQiUV2rHhW6hjpGgs0rCzItQi3
 b0fIFlv6/HfcmLOXDkhg5QWWSFyMGOnpkVqoxwB1oWjUK0sST3LrFl2HqrPwuCGI6l38L4iZS
 GS4WG827aqqSldQOmuwwgfGvyf/HOEcLFPotsmUsEdsK/+2UWFscce7pZWtOS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to opt-out from VMware support, for minimized kernels
that never will be run under Vmware (eg. high-density virtualization
or embedded systems).

Average distro kernel will leave it on, therefore default to y.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 arch/x86/Kconfig                 | 11 +++++++++++
 arch/x86/kernel/cpu/Makefile     |  4 +++-
 arch/x86/kernel/cpu/hypervisor.c |  2 ++
 drivers/input/mouse/Kconfig      |  2 +-
 drivers/misc/Kconfig             |  2 +-
 drivers/ptp/Kconfig              |  2 +-
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f6946b81f74a..eff12460cb3c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -801,6 +801,17 @@ config X86_HV_CALLBACK_VECTOR
 
 source "arch/x86/xen/Kconfig"
 
+config VMWARE_GUEST
+	bool "VMware Guest support"
+	default y
+	help
+	  This option enables several optimizations for running under the
+	  VMware hypervisor.
+
+	  Disabling it saves a few kb, for stripped down kernels eg. in high
+	  density virtualization or embedded systems running (para)virtualized
+	  workloads.
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

