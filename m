Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685262B6FF2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgKQUWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:22:12 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:41607 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQUWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:22:07 -0500
Received: from orion.localdomain ([95.118.38.12]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mv3I0-1kNj5V0PI0-00qycw; Tue, 17 Nov 2020 21:21:37 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] x86: make hyperv support optional
Date:   Tue, 17 Nov 2020 21:21:34 +0100
Message-Id: <20201117202134.6312-2-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201117202134.6312-1-info@metux.net>
References: <20201117202134.6312-1-info@metux.net>
X-Provags-ID: V03:K1:ph+Tgcw1zVIlrJX8Mt4vFYz8rLohGAqq3s1BZmrXQ0fOF3hE2SH
 K06jt/2aHWe9A6aq7YUI+pBfFjKpqHA1HDDxwBFHXDbKfwnY4ovqzqxI0cpyfwcXGLnxU9Q
 d0hSxcvpqI3XUygrNImtokmdqGGYqIgtrPu+xrxb8fsW9IJ93EQgY0W3rsM5LAaRXf/3yoW
 jxiANUQKq24FEZqA4KD7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cenxsi2fg00=:rapmf7r1BfGtnSW29zwI7p
 cyqmzInHBfM7goUKEV32bmMioL+BaBu8PfOv0RfhLA5EtbGJtfiWquxMk7Ot+WI1cOkmVL0SS
 Rkwlt/ijqYOEbQBRlxDYSxtASdkW/TqgFL6MNILZi2LLNHGT1IQAv0g1g/EToDM0yyqo3kf56
 t2qeCUc8rroeEte+xeBZW+CdKHd2soh1YmEPwnPsoD1vVNU5y+ShEeI8ULoDf8G7OmABqrx7u
 Q4oc+D2dXCf7eLLrIkAjjv9fmmM/9Tu0l1jj1ZTXjCdE57lQGYb0lfQK0xegdQCKn72zH0JQM
 eOXsVOyn2oEUcydvnbozvqF6lucZVGj1TTbh7e1HcESRkiDs+UupTKuycolgAmVBBsv0szTXJ
 WBj1Dieyj9ldmw4aAjHrxleOFvSXJiIo0LthqvrGK4y/ebumFT0oVWPN53Ex3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

