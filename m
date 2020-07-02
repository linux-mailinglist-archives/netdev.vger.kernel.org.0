Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919E9212C23
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgGBSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:22:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:16185 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBSW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593714149; x=1625250149;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=OCpSQw7b/4F/s9Kck7b/oFt4msmldkjBxvkPzpRtc18=;
  b=tqqsBMxFTLUVjjRi7LL4fIe8T6OFO7AiuSCUxoXqOAbZGlai2ErSsTgO
   nR61Bze+tCA8KDWpHqzw5NAHxgmUuA7Q3+fLpghFsRI2XKA4zcp9MbASw
   AMt10g19LP4Dwbpkz6itQ+yHXcfWauKCG86ASe/JrWPFve9V+NuEK3Hcn
   w=;
IronPort-SDR: vkg/Sg8L6s4rdxfrTdTR2arayeY3g64ZdS81u9rg8mgIf0I0him3TpE5PXpud66wIReuCHA0QC
 aagUD9PVAMEA==
X-IronPort-AV: E=Sophos;i="5.75,305,1589241600"; 
   d="scan'208";a="55693165"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2020 18:22:29 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 1F1CDA18CF;
        Thu,  2 Jul 2020 18:22:27 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:22:05 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:22:05 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 18:22:05 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 0A86C40844; Thu,  2 Jul 2020 18:22:05 +0000 (UTC)
Date:   Thu, 2 Jul 2020 18:22:05 +0000
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
Subject: [PATCH v2 04/11] x86/xen: add system core suspend and resume
 callbacks
Message-ID: <20200702182205.GA3531@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1593665947.git.anchalag@amazon.com>
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
Signed-off-by: Agarwal Anchal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 arch/x86/xen/enlighten_hvm.c |  1 +
 arch/x86/xen/suspend.c       | 47 ++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h        |  2 ++
 3 files changed, 50 insertions(+)

diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index d91099928746..bd6bf6eb2052 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -215,6 +215,7 @@ static void __init xen_hvm_guest_init(void)
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 
+	xen_setup_syscore_ops();
 	xen_hvm_smp_init();
 	WARN_ON(xen_cpuhp_setup(xen_cpu_up_prepare_hvm, xen_cpu_dead_hvm));
 	xen_unplug_emulated_devices();
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 1d83152c761b..e8c924e93fc5 100644
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
@@ -82,3 +87,45 @@ void xen_arch_suspend(void)
 
 	on_each_cpu(xen_vcpu_notify_suspend, NULL, 1);
 }
+
+static int xen_syscore_suspend(void)
+{
+	struct xen_remove_from_physmap xrfp;
+	int ret;
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
index 2521d6a306cd..9fa8a4082d68 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -41,6 +41,8 @@ u64 xen_steal_clock(int cpu);
 int xen_setup_shutdown_event(void);
 
 bool xen_is_xen_suspend(void);
+void xen_setup_syscore_ops(void);
+
 extern unsigned long *xen_contiguous_bitmap;
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
-- 
2.20.1

