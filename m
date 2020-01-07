Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D9D13378C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgAGXlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:41:01 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:62199 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgAGXlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440459; x=1609976459;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=R/ChRdUub8GaU9C55T2reGXH2khOUkoMgXccaQMjyI4=;
  b=SF4dCTB8IsKeN/VdRKwCZ3QjbKruP0lWSOXIsBf2ZozAVK2AARa+Pveu
   Vrd7F2XP+lmaVx5OcJrulV7lrcLvYL1thiRQAfyMVDo/UGJhyAIwjVaWk
   ZiSYeLuRyyxOhjySYbx2pZTYMLOy/ja5Z3f553cqIL2CTRFik0hLL0srP
   g=;
IronPort-SDR: 5g/iqkzFvYugBmDKt0Glzcp1Q3t/ykf/uYOlIE5v/VAcV7ggyE/V7zO/wgrTEjPikfKPNIr6jw
 N16mKYQ8zZGw==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="11930671"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 07 Jan 2020 23:40:57 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 1A4B4A1EE3;
        Tue,  7 Jan 2020 23:40:55 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:40:39 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:40:38 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:40:38 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 4B11640E65; Tue,  7 Jan 2020 23:40:38 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:40:38 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.co>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
CC:     <anchalag@amazon.com>
Subject: [RFC PATCH V2 04/11] x86/xen: add system core suspend and resume
 callbacks
Message-ID: <20200107234038.GA18296@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Add Xen PVHVM specific system core callbacks for PM suspend and
hibernation support. The callbacks suspend and resume Xen
primitives,like shared_info, pvclock and grant table. Note that
Xen suspend can handle them in a different manner, but system
core callbacks are called from the context. So if the callbacks
are called from Xen suspend context, return immediately.

Signed-off-by: Agarwal Anchal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 arch/x86/xen/enlighten_hvm.c |  1 +
 arch/x86/xen/suspend.c       | 53 ++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h        |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index 75b1ec7a0fcd..138e71786e03 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -204,6 +204,7 @@ static void __init xen_hvm_guest_init(void)
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 
+	xen_setup_syscore_ops();
 	xen_hvm_smp_init();
 	WARN_ON(xen_cpuhp_setup(xen_cpu_up_prepare_hvm, xen_cpu_dead_hvm));
 	xen_unplug_emulated_devices();
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 1d83152c761b..784c4484100b 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -2,17 +2,22 @@
 #include <linux/types.h>
 #include <linux/tick.h>
 #include <linux/percpu-defs.h>
+#include <linux/syscore_ops.h>
+#include <linux/kernel_stat.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
 #include <xen/grant_table.h>
 #include <xen/events.h>
+#include <xen/xen-ops.h>
 
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
 #include <asm/fixmap.h>
+#include <asm/pvclock.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -82,3 +87,51 @@ void xen_arch_suspend(void)
 
 	on_each_cpu(xen_vcpu_notify_suspend, NULL, 1);
 }
+
+static int xen_syscore_suspend(void)
+{
+	struct xen_remove_from_physmap xrfp;
+	int ret;
+
+	/* Xen suspend does similar stuffs in its own logic */
+	if (xen_suspend_mode_is_xen_suspend())
+		return 0;
+
+	xrfp.domid = DOMID_SELF;
+	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
+
+	ret = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrfp);
+	if (!ret)
+		HYPERVISOR_shared_info = &xen_dummy_shared_info;
+
+	return ret;
+}
+
+static void xen_syscore_resume(void)
+{
+	/* Xen suspend does similar stuffs in its own logic */
+	if (xen_suspend_mode_is_xen_suspend())
+		return;
+
+	/* No need to setup vcpu_info as it's already moved off */
+	xen_hvm_map_shared_info();
+
+	pvclock_resume();
+
+	gnttab_resume();
+}
+
+/*
+ * These callbacks will be called with interrupts disabled and when having only
+ * one CPU online.
+ */
+static struct syscore_ops xen_hvm_syscore_ops = {
+	.suspend = xen_syscore_suspend,
+	.resume = xen_syscore_resume
+};
+
+void __init xen_setup_syscore_ops(void)
+{
+	if (xen_hvm_domain())
+		register_syscore_ops(&xen_hvm_syscore_ops);
+}
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 6c36e161dfd1..3b3992b5b0c2 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -43,6 +43,9 @@ int xen_setup_shutdown_event(void);
 bool xen_suspend_mode_is_xen_suspend(void);
 bool xen_suspend_mode_is_pm_suspend(void);
 bool xen_suspend_mode_is_pm_hibernation(void);
+
+void xen_setup_syscore_ops(void);
+
 extern unsigned long *xen_contiguous_bitmap;
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
-- 
2.15.3.AMZN

