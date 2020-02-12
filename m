Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4B915B3D8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgBLWes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:34:48 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61877 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbgBLWes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546888; x=1613082888;
  h=date:from:to:subject:message-id:mime-version;
  bh=tYSU9iIsoDiHOrDtUYIpPVrJzHedrCrd1HEsqWaOGf0=;
  b=tD+1J8/GbJodCU7B5y1Kbz1Bu64/n3fcoZneWvH4rFY7ChaexmiKoAxJ
   rKdflZjgdYrtWXGR4A2BQH/vSMMEAXA2E26PnAKAbBp+1IakhRrcw5G0F
   37FqG1v2wRGviETPJfk4R0MiKIj+dY6/75KopLV/AqoCjbkE98hCYl67X
   8=;
IronPort-SDR: bkSrtJsJHpidimijd2L1wIMETSIqwjC5vVxq1oCoMg6L/owqJK4HB0Xj7VHCDOcGTayR5JOFV8
 X4CMSFr17QNw==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="16328108"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Feb 2020 22:34:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id E0121A28F3;
        Wed, 12 Feb 2020 22:34:45 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:34:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:34:39 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:34:39 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 83531400D1; Wed, 12 Feb 2020 22:34:39 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:34:39 +0000
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
Message-ID: <20200212223439.GA4444@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce wrappers for save/restore xen_sched_clock_offset to be
used by PM hibernation code to avoid system instability during resume.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>

---
Changes since V2:
* Dropped marking tsc unstable during hibernation patch
* Fixed issue with xen_sched_clock_offset during suspend/resume
* On further interrogation and testing, the issue wasn't with tsc
being stable/unstable

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

