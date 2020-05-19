Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BBC1DA58F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgESX3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:29:50 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:16133 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESX3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589930988; x=1621466988;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=Dbh0kC6AUhdBwnm/rg5xRtYEoyS/bWB7gw8bESiUXu8=;
  b=ujARxPOZrE2ff4RNd5HwI/Tui0eVklwzmkSIeS+vo7z1bLgqkk56Ahib
   yWb27O88x/8y4B2JfKMBqVDxFuO69pVerN/KMDelOBCHeLkR3vkxCltzU
   Uz6qByLCepoC46jVTcyTuKS+baWy29gWwevisJicw7l0RgkK/r0wuzqYk
   U=;
IronPort-SDR: QyxaVj7m3HsYActdDDQN//Bklv0kPtNEJKpgFFZzEhwvzUrO/yoZHFxDlLIQE70DrdHpZ7H+j2
 ZsDe6R6BRV9g==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="32497101"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 May 2020 23:29:33 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 3F3DDA217A;
        Tue, 19 May 2020 23:29:31 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:29:11 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:29:11 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:29:11 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id CEAED40712; Tue, 19 May 2020 23:29:10 +0000 (UTC)
Date:   Tue, 19 May 2020 23:29:10 +0000
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
Subject: [PATCH 10/12] xen: Introduce wrapper for save/restore sched clock
 offset
Message-ID: <9bb393ade4a6a30a2d4ba3ba191603a2b2fb8512.1589926004.git.anchalag@amazon.com>
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

Introduce wrappers for save/restore xen_sched_clock_offset to be
used by PM hibernation code to avoid system instability during resume.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/time.c    | 15 +++++++++++++--
 arch/x86/xen/xen-ops.h |  2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 33d754564b09..1fc2beb7a6c1 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -386,12 +386,23 @@ static const struct pv_time_ops xen_time_ops __initconst = {
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
@@ -434,7 +445,7 @@ void xen_restore_time_memory_area(void)
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

