Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598DD15B3D4
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgBLWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:34:23 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61693 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbgBLWeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546863; x=1613082863;
  h=date:from:to:subject:message-id:mime-version;
  bh=Eo18FuPqTI4s9/8b+RyMmqnZX5xJ4fL1BD2xZjVWSBE=;
  b=mY3E4OGEZvstavDfNfa2/qa6u4Twa7Cm2DszTXho4H/Smv/MmIcvH71I
   YtV0ZXFPG8akppBAcxMti1No2Og4b3Ti/SIH5J5WA+V+RX6W0idp0cE7C
   +l4txKlcrV3B159hvg2TZgqbMIskdE4/f2XHNjtynCWVM2RJgblyiko2M
   Y=;
IronPort-SDR: CAoTjaJQmXCSqypAs4vlySVkxQ/IlBFjWb07NalXRqztxgZBJy36fgeRw1UIfOlZSSKUHy7wPG
 GxFxRyu9NIIA==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="16327964"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Feb 2020 22:34:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 7E329A24DF;
        Wed, 12 Feb 2020 22:34:19 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:34:13 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:34:13 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:34:13 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 58D23400D1; Wed, 12 Feb 2020 22:34:13 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:34:13 +0000
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
Subject: [RFC PATCH v3 09/12] x86/xen: save and restore steal clock
Message-ID: <20200212223413.GA4354@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Save steal clock values of all present CPUs in the system core ops
suspend callbacks. Also, restore a boot CPU's steal clock in the system
core resume callback. For non-boot CPUs, restore after they're brought
up, because runstate info for non-boot CPUs are not active until then.

Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>

---
Changes since V2:
    * Separate patch to add save/restore call to suspend/resume code
---
 arch/x86/xen/suspend.c | 13 ++++++++++++-
 arch/x86/xen/time.c    |  3 +++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 784c4484100b..dae0f74f5390 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -91,12 +91,20 @@ void xen_arch_suspend(void)
 static int xen_syscore_suspend(void)
 {
 	struct xen_remove_from_physmap xrfp;
-	int ret;
+	int cpu, ret;
 
 	/* Xen suspend does similar stuffs in its own logic */
 	if (xen_suspend_mode_is_xen_suspend())
 		return 0;
 
+	for_each_present_cpu(cpu) {
+		/*
+		 * Nonboot CPUs are already offline, but the last copy of
+		 * runstate info is still accessible.
+		 */
+		xen_save_steal_clock(cpu);
+	}
+
 	xrfp.domid = DOMID_SELF;
 	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
 
@@ -118,6 +126,9 @@ static void xen_syscore_resume(void)
 
 	pvclock_resume();
 
+	/* Nonboot CPUs will be resumed when they're brought up */
+	xen_restore_steal_clock(smp_processor_id());
+
 	gnttab_resume();
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index befbdd8b17f0..8cf632dda605 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -537,6 +537,9 @@ static void xen_hvm_setup_cpu_clockevents(void)
 {
 	int cpu = smp_processor_id();
 	xen_setup_runstate_info(cpu);
+	if (cpu)
+		xen_restore_steal_clock(cpu);
+
 	/*
 	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
 	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
-- 
2.24.1.AMZN

