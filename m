Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A524E344
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHUW0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:26:02 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:15381 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgHUW0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598048760; x=1629584760;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=P6c+ghbxBFW6FKLFXMggDpsPZB1htB1D5l7v91pDUP4=;
  b=Ig431mc8nkL7A2MVUhWBPacrSyQ+W4gVssi6yw6WUQTFR00KxbUYfSEJ
   bBNll5FaRaUMO5TOqXtvye6SAqBu2NJzWumWb3wuXT7f4N/u5fsF0D7J8
   9/oh2CQz2KfRvXKiniguHk+6c2+s5QwCeTtQBUrgpZ5nyYMWhEFxrQ5ti
   c=;
X-IronPort-AV: E=Sophos;i="5.76,338,1592870400"; 
   d="scan'208";a="49215629"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Aug 2020 22:25:58 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id B7A6CA2891;
        Fri, 21 Aug 2020 22:25:50 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:25:50 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:25:49 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 22:25:49 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 6AD8840362; Fri, 21 Aug 2020 22:25:49 +0000 (UTC)
Date:   Fri, 21 Aug 2020 22:25:49 +0000
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
Subject: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Message-ID: <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
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

Guest hibernation is different from xen suspend/resume/live migration.
Xen save/restore does not use pm_ops as is needed by guest hibernation.
Hibernation in guest follows ACPI path and is guest inititated , the
hibernation image is saved within guest as compared to later modes
which are xen toolstack assisted and image creation/storage is in
control of hypervisor/host machine.
To differentiate between Xen suspend and PM hibernation, keep track
of the on-going suspend mode by mainly using a new API to keep track of
SHUTDOWN_SUSPEND state.
Introduce a simple function that keeps track of on-going suspend mode
so that PM hibernation code can behave differently according to the
current suspend mode.
Since Xen suspend doesn't have corresponding PM event, its main logic
is modfied to acquire pm_mutex.

Though, accquirng pm_mutex is still right thing to do, we may
see deadlock if PM hibernation is interrupted by Xen suspend.
PM hibernation depends on xenwatch thread to process xenbus state
transactions, but the thread will sleep to wait pm_mutex which is
already held by PM hibernation context in the scenario. Xen shutdown
code may need some changes to avoid the issue.

[Anchal Agarwal: Changelog]:
 RFC v1->v2: Code refactoring
 v1->v2:     Remove unused functions for PM SUSPEND/PM hibernation
 v2->v3:     Added logic to use existing pm_notifier to detect for ARM
	     and abort hibernation for ARM guests. Also removed different
	     suspend_modes and simplified the code with using existing state
	     variables for tracking Xen suspend. The notifier won't get
	     registered for pvh dom0 either.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/xen/manage.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h |  1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index cd046684e0d1..d2a51c454c3e 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -14,6 +14,7 @@
 #include <linux/freezer.h>
 #include <linux/syscore_ops.h>
 #include <linux/export.h>
+#include <linux/suspend.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -40,6 +41,11 @@ enum shutdown_state {
 /* Ignore multiple shutdown requests. */
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
+bool is_xen_suspend(void)
+{
+	return shutting_down == SHUTDOWN_SUSPEND;
+}
+
 struct suspend_info {
 	int cancelled;
 };
@@ -99,6 +105,8 @@ static void do_suspend(void)
 	int err;
 	struct suspend_info si;
 
+	lock_system_sleep();
+
 	shutting_down = SHUTDOWN_SUSPEND;
 
 	err = freeze_processes();
@@ -162,6 +170,8 @@ static void do_suspend(void)
 	thaw_processes();
 out:
 	shutting_down = SHUTDOWN_INVALID;
+
+	unlock_system_sleep();
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */
 
@@ -387,3 +397,39 @@ int xen_setup_shutdown_event(void)
 EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);
 
 subsys_initcall(xen_setup_shutdown_event);
+
+static int xen_pm_notifier(struct notifier_block *notifier,
+	unsigned long pm_event, void *unused)
+{
+	int ret;
+
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+	case PM_HIBERNATION_PREPARE:
+	/* Guest hibernation is not supported for aarch64 currently*/
+	if (IS_ENABLED(CONFIG_ARM64)) {
+		ret = NOTIFY_BAD;
+		break;
+	}
+	case PM_RESTORE_PREPARE:
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+	default:
+		ret = NOTIFY_OK;
+	}
+	return ret;
+};
+
+static struct notifier_block xen_pm_notifier_block = {
+	.notifier_call = xen_pm_notifier
+};
+
+static int xen_setup_pm_notifier(void)
+{
+	if (!xen_hvm_domain() || xen_initial_domain())
+		return -ENODEV;
+	return register_pm_notifier(&xen_pm_notifier_block);
+}
+
+subsys_initcall(xen_setup_pm_notifier);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 39a5580f8feb..e8b08734fab1 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -40,6 +40,7 @@ u64 xen_steal_clock(int cpu);
 
 int xen_setup_shutdown_event(void);
 
+bool is_xen_suspend(void);
 extern unsigned long *xen_contiguous_bitmap;
 
 #if defined(CONFIG_XEN_PV) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)
-- 
2.16.6

