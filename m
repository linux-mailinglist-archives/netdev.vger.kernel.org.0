Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344AD15FA5D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgBNXWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:41 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:8451 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgBNXWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581722557; x=1613258557;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=eMxbySX2+Q9C9EOEiRSgj0VbC617wxOCoVYvUYL8fpI=;
  b=WICp9M02s017QBgouIW2fL8yanCHWC10hGpybHWE0fEu+nag6alQ8cnz
   8lh8aHcVKA7hZm8Z5qUZGdtVq2a5l9Uif78V6Thn+CCuzaG3jTsv/d5oF
   wqpy0YjPch33NcDS7EVFdtAyaybvoCmouMDqL7Fc2oohZmksIxvCwvagE
   8=;
IronPort-SDR: y8XMJpVBLvSO59b36Gvrm5SW1/nIbpAtTjjiO/1OKPsLUicx920bBL8XverR7HeoI3BJ2aceF9
 AUi0ra0Y0/HQ==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="16797643"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Feb 2020 23:22:34 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 1A7F0A07D0;
        Fri, 14 Feb 2020 23:22:26 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:22:09 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:22:08 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 14 Feb 2020 23:22:08 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 756394028E; Fri, 14 Feb 2020 23:22:08 +0000 (UTC)
Date:   Fri, 14 Feb 2020 23:22:08 +0000
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
Message-ID: <36567b7204db25d7307a165a6565837a213efdf8.1581721799.git.anchalag@amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1581721799.git.anchalag@amazon.com>
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

