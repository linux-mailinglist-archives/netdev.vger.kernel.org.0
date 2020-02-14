Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E998A15FA95
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgBNX1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:27:48 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1035 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgBNX1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581722867; x=1613258867;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=w2YudPijii+dzE2cW4maD6E6FQY1WRpU8HmwPnvoM5k=;
  b=wIWeAYgn40YOrYt2FC6c5BTIphd+RIWYLpUy4SbFnDl1Cp9drlyhvVc6
   N6VynUKymRW5+/IXaVCtxQa6ACgoS7pFMti42jWpUJ9wV9sdUlKLIfV9c
   JA7UZLw1SXo1k6n10q7e3xqgNSG/14gZHHn0S6xD+tF38IR+IZUBgLjbu
   0=;
IronPort-SDR: 4QzLk7agU2cCkHMRbCkf+yxdh7O3HX/h13ILndMQD5DBXAC5QIGb3xBDBxJz+ZI2EvA/bpTqBv
 mUC+a3+dOYhg==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="26558954"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 14 Feb 2020 23:27:45 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 9E2B3C0845;
        Fri, 14 Feb 2020 23:27:38 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:27:25 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:27:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 14 Feb 2020 23:27:19 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id F07DD4028E; Fri, 14 Feb 2020 23:27:18 +0000 (UTC)
Date:   Fri, 14 Feb 2020 23:27:18 +0000
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
Subject: [RFC PATCH v3 10/12] xen: Introduce wrapper for save/restore sched
 clock offset
Message-ID: <305f20fbf503b637b1a08b7bec543f49271a725a.1581721799.git.anchalag@amazon.com>
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

Introduce wrappers for save/restore xen_sched_clock_offset to be
used by PM hibernation code to avoid system instability during resume.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/time.c    | 15 +++++++++++++--
 arch/x86/xen/xen-ops.h |  2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 8cf632dda605..eeb6d3d2eaab 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -379,12 +379,23 @@ static const struct pv_time_ops xen_time_ops __initconst = {
 static struct pvclock_vsyscall_time_info *xen_clock __read_mostly;
 static u64 xen_clock_value_saved;
 
+/*This is needed to maintain a monotonic clock value during PM hibernation */
+void xen_save_sched_clock_offset(void)
+{
+	xen_clock_value_saved = xen_clocksource_read() - xen_sched_clock_offset;
+}
+
+void xen_restore_sched_clock_offset(void)
+{
+	xen_sched_clock_offset = xen_clocksource_read() - xen_clock_value_saved;
+}
+
 void xen_save_time_memory_area(void)
 {
 	struct vcpu_register_time_memory_area t;
 	int ret;
 
-	xen_clock_value_saved = xen_clocksource_read() - xen_sched_clock_offset;
+	xen_save_sched_clock_offset();
 
 	if (!xen_clock)
 		return;
@@ -426,7 +437,7 @@ void xen_restore_time_memory_area(void)
 out:
 	/* Need pvclock_resume() before using xen_clocksource_read(). */
 	pvclock_resume();
-	xen_sched_clock_offset = xen_clocksource_read() - xen_clock_value_saved;
+	xen_restore_sched_clock_offset();
 }
 
 static void xen_setup_vsyscall_time_info(void)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index d84c357994bd..9f49124df033 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -72,6 +72,8 @@ void xen_save_time_memory_area(void);
 void xen_restore_time_memory_area(void);
 void xen_init_time_ops(void);
 void xen_hvm_init_time_ops(void);
+void xen_save_sched_clock_offset(void);
+void xen_restore_sched_clock_offset(void);
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
-- 
2.24.1.AMZN

