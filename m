Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE95724E358
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHUW1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:27:39 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:38559 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgHUW1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598048857; x=1629584857;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=pnNXSAi218kX4gixFJtZ3Iig1xRXyX/Xb2Q2WiRjc+w=;
  b=HFG0wtmbk7Tj/C5tVa4u5QW79GpfD7XtRwd1gPEw1xihzWbTiTJtLL6A
   U6sb4IFgazJVXraM5ewAs6iI1ryi0q7aL0PdPe8zWOy+CA4ADCiMy3WLB
   kNK5QeV/ZUKtSjwA8irfL9TCn6ZcBN6I7Lsc8hnxJMlc+5ZNizJIKC9wh
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,338,1592870400"; 
   d="scan'208";a="49306994"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Aug 2020 22:27:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id AA474A2B36;
        Fri, 21 Aug 2020 22:27:32 +0000 (UTC)
Received: from EX13D05UWB003.ant.amazon.com (10.43.161.26) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:27:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D05UWB003.ant.amazon.com (10.43.161.26) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:27:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 22:27:25 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id E96BE40362; Fri, 21 Aug 2020 22:27:25 +0000 (UTC)
Date:   Fri, 21 Aug 2020 22:27:25 +0000
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
Subject: [PATCH v3 04/11] x86/xen: add system core suspend and resume
 callbacks
Message-ID: <6b86a4bf71ee3e3e9b0bb00f594a4edc85da19a9.1598042152.git.anchalag@amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1598042152.git.anchalag@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Add Xen PVHVM specific system core callbacks for PM
hibernation support. The callbacks suspend and resume
Xen primitives like shared_info, pvclock and grant table.
These syscore_ops are specifically for domU hibernation.
xen_suspend() calls syscore_suspend() during Xen suspend
operation however, during xen suspend lock_system_sleep()
lock is taken and thus system cannot trigger hibernation.
These system core callbacks will be called only from the
hibernation context.

[Anchal Agarwal: Changelog]:
v1->v2: Edit commit message
        Fixed syscore_suspend() to call gnntab_suspend
        Removed suspend mode check in syscore_suspend()/
        syscore_resume()
v2->v3: Re-introduced check for xen suspend mode to avoid
        syscore osp callbacks getting executed during xen
	suspend/resume

Signed-off-by: Agarwal Anchal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 arch/x86/xen/enlighten_hvm.c |  1 +
 arch/x86/xen/suspend.c       | 55 ++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h        |  2 ++
 3 files changed, 58 insertions(+)

diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index ff7c69278f63..4b6ad30106dd 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -216,6 +216,7 @@ static void __init xen_hvm_guest_init(void)
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 
+	xen_setup_syscore_ops();
 	xen_hvm_smp_init();
 	WARN_ON(xen_cpuhp_setup(xen_cpu_up_prepare_hvm, xen_cpu_dead_hvm));
 	xen_unplug_emulated_devices();
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 1d83152c761b..550aa0fc9465 100644
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
@@ -82,3 +87,53 @@ void xen_arch_suspend(void)
 
 	on_each_cpu(xen_vcpu_notify_suspend, NULL, 1);
 }
+
+static int xen_syscore_suspend(void)
+{
+	struct xen_remove_from_physmap xrfp;
+	int ret;
+
+	/* Xen suspend does similar stuffs in its own logic */
+	if (is_xen_suspend())
+		return 0;
+
+	gnttab_suspend();
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
+	if (is_xen_suspend())
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
index e8b08734fab1..bad334cd55d7 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -41,6 +41,8 @@ u64 xen_steal_clock(int cpu);
 int xen_setup_shutdown_event(void);
 
 bool is_xen_suspend(void);
+void xen_setup_syscore_ops(void);
+
 extern unsigned long *xen_contiguous_bitmap;
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
-- 
2.16.6

