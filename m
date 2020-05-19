Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46821DA56D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgESX0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:26:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:64802 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgESX0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589930798; x=1621466798;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=+5sqW/9tRYGzDifQrxQJ7j+i6WgVO1jvWkTIJZXYHhc=;
  b=K46XGdq+bQjjsBSF58nOLshjyQJUeGKZesZ9jXdJfsN/covNZ3BRqVU/
   tGtr/k9ujNTkUHmXPTzVco+WvZo0/HKbfy54uVrjU49o5CA54bJ8MVNWP
   rwysXkR544eRybIl/BESTHj2ng4qsUgqFYGKKqACW/qPKEdfAMH2a6b71
   Q=;
IronPort-SDR: mWw8AR8ej5ULAmO2NWPA9U3fjvDcfrEySiPbnKH0hbJ0nS6cPVOD41yjXFXqxCxYYtwfKRalTW
 k2MS/P3b7VvQ==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="31243916"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 May 2020 23:26:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id CA0F8A1EEC;
        Tue, 19 May 2020 23:26:20 +0000 (UTC)
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:26:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB002.ant.amazon.com (10.43.161.136) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:26:15 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:26:15 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5012E40712; Tue, 19 May 2020 23:26:15 +0000 (UTC)
Date:   Tue, 19 May 2020 23:26:15 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <benh@kernel.crashing.org>
Subject: [PATCH 04/12] x86/xen: add system core suspend and resume callbacks
Message-ID: <79cf02631dc00e62ebf90410bfbbdb52fe7024cb.1589926004.git.anchalag@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1589926004.git.anchalag@amazon.com>
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
 arch/x86/xen/suspend.c       | 53 ++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h        |  3 ++
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
index 4ffe031adfc7..89b1e88712d6 100644
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
2.24.1.AMZN

