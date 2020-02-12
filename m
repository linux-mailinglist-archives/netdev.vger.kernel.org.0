Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16E715B3B5
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgBLWbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:31:00 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20640 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbgBLWbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546660; x=1613082660;
  h=date:from:to:subject:message-id:mime-version;
  bh=lXUfPVCqOw43hJmA37ZNPhgrTtTkVXf8HnLPkdJWiEM=;
  b=K4QvLvukE4XCZsxDVAajjZadK8oOy2xv3blqAcJviLA1FxH1Vm355R/g
   Z817rZCdaLXhJfHsf39UC7aQdabgYgVESj0FCHRs28l+uhS428q6NPOiJ
   QhtL1gyLoi3oEPC3NTGeROCeblX6w2h+RDhlldzVaEwaqAQO6MudT2JJc
   g=;
IronPort-SDR: wj0rP/4g7pIfoN8xmEr/giPmQ1SZih6GVao218XZ5Ck786gidFMD9z9Ffv8EwCVBjqDYTkm3/m
 i77D21jlZtKg==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="16932720"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 12 Feb 2020 22:30:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 5CFCAA2483;
        Wed, 12 Feb 2020 22:30:43 +0000 (UTC)
Received: from EX13D05UWC004.ant.amazon.com (10.43.162.223) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:30:13 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC004.ant.amazon.com (10.43.162.223) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:30:12 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:30:12 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id C890D400D1; Wed, 12 Feb 2020 22:30:12 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:30:12 +0000
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
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Subject: [RFC PATCH v3 01/12] xen/manage: keep track of the on-going suspend
 mode
Message-ID: <20200212223012.GA3445@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Guest hibernation is different from xen suspend/resume/live migration.
Xen save/restore does not use pm_ops as is needed by guest hibernation.
Hibernation in guest follows ACPI path and is guest inititated , the
hibernation image is saved within guest as compared to later modes
which are xen toolstack assisted and image creation/storage is in
control of hypervisor/host machine.
To differentiate between Xen suspend and PM hibernation, keep track
of the on-going suspend mode by mainly using a new PM notifier.
Introduce simple functions which help to know the on-going suspend mode
so that other Xen-related code can behave differently according to the
current suspend mode.
Since Xen suspend doesn't have corresponding PM event, its main logic
is modfied to acquire pm_mutex and set the current mode.

Though, acquirng pm_mutex is still right thing to do, we may
see deadlock if PM hibernation is interrupted by Xen suspend.
PM hibernation depends on xenwatch thread to process xenbus state
transactions, but the thread will sleep to wait pm_mutex which is
already held by PM hibernation context in the scenario. Xen shutdown
code may need some changes to avoid the issue.

[Anchal Changelog: Merged patch xen/manage: introduce helper function
to know the on-going suspend mode into this one for better readability]
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>

---

Changes since V2: None
---
 drivers/xen/manage.c  | 73 +++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h |  3 ++
 2 files changed, 76 insertions(+)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index cd046684e0d1..0b30ab522b77 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -14,6 +14,7 @@
 #include <linux/freezer.h>
 #include <linux/syscore_ops.h>
 #include <linux/export.h>
+#include <linux/suspend.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -40,6 +41,31 @@ enum shutdown_state {
 /* Ignore multiple shutdown requests. */
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
+enum suspend_modes {
+	NO_SUSPEND = 0,
+	XEN_SUSPEND,
+	PM_SUSPEND,
+	PM_HIBERNATION,
+};
+
+/* Protected by pm_mutex */
+static enum suspend_modes suspend_mode = NO_SUSPEND;
+
+bool xen_suspend_mode_is_xen_suspend(void)
+{
+	return suspend_mode == XEN_SUSPEND;
+}
+
+bool xen_suspend_mode_is_pm_suspend(void)
+{
+	return suspend_mode == PM_SUSPEND;
+}
+
+bool xen_suspend_mode_is_pm_hibernation(void)
+{
+	return suspend_mode == PM_HIBERNATION;
+}
+
 struct suspend_info {
 	int cancelled;
 };
@@ -99,6 +125,10 @@ static void do_suspend(void)
 	int err;
 	struct suspend_info si;
 
+	lock_system_sleep();
+
+	suspend_mode = XEN_SUSPEND;
+
 	shutting_down = SHUTDOWN_SUSPEND;
 
 	err = freeze_processes();
@@ -162,6 +192,10 @@ static void do_suspend(void)
 	thaw_processes();
 out:
 	shutting_down = SHUTDOWN_INVALID;
+
+	suspend_mode = NO_SUSPEND;
+
+	unlock_system_sleep();
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */
 
@@ -387,3 +421,42 @@ int xen_setup_shutdown_event(void)
 EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);
 
 subsys_initcall(xen_setup_shutdown_event);
+
+static int xen_pm_notifier(struct notifier_block *notifier,
+			   unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		suspend_mode = PM_SUSPEND;
+		break;
+	case PM_HIBERNATION_PREPARE:
+	case PM_RESTORE_PREPARE:
+		suspend_mode = PM_HIBERNATION;
+		break;
+	case PM_POST_SUSPEND:
+	case PM_POST_RESTORE:
+	case PM_POST_HIBERNATION:
+		/* Set back to the default */
+		suspend_mode = NO_SUSPEND;
+		break;
+	default:
+		pr_warn("Receive unknown PM event 0x%lx\n", pm_event);
+		return -EINVAL;
+	}
+
+	return 0;
+};
+
+static struct notifier_block xen_pm_notifier_block = {
+	.notifier_call = xen_pm_notifier
+};
+
+static int xen_setup_pm_notifier(void)
+{
+	if (!xen_hvm_domain())
+		return -ENODEV;
+
+	return register_pm_notifier(&xen_pm_notifier_block);
+}
+
+subsys_initcall(xen_setup_pm_notifier);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index d89969aa9942..6c36e161dfd1 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -40,6 +40,9 @@ u64 xen_steal_clock(int cpu);
 
 int xen_setup_shutdown_event(void);
 
+bool xen_suspend_mode_is_xen_suspend(void);
+bool xen_suspend_mode_is_pm_suspend(void);
+bool xen_suspend_mode_is_pm_hibernation(void);
 extern unsigned long *xen_contiguous_bitmap;
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
-- 
2.24.1.AMZN

