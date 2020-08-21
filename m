Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906E424E374
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgHUWa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:30:59 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:12254 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgHUWa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598049057; x=1629585057;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=8mKR6nGsN4/J6yUPoHqgy6Vb/KbDSfcnRfNiku5bjZI=;
  b=RgsIr8Z7VXg/2KiGmru6OI2t0IpbT+jjoTnyR+KBB1255FwjNnNT5zSG
   LTwZRsFZd5c/zrYvE/mDlVNPKXZsu119muuZfuZ0zZOpcR5B/cwpZMYHF
   IQ7GrE3nZUGkSB8JSkg3PWKM5pbiZMUhjnGB8Qv6N6pS5UvmHuhmuELLe
   E=;
X-IronPort-AV: E=Sophos;i="5.76,338,1592870400"; 
   d="scan'208";a="49403856"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Aug 2020 22:30:56 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 51046A22AF;
        Fri, 21 Aug 2020 22:30:48 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:30:29 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:30:29 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 22:30:29 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 1520540362; Fri, 21 Aug 2020 22:30:29 +0000 (UTC)
Date:   Fri, 21 Aug 2020 22:30:29 +0000
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
Subject: [PATCH v3 10/11] xen: Update sched clock offset to avoid system
 instability in hibernation
Message-ID: <238e837b8d4e17925801c4e85de17bdfca4ddd00.1598042152.git.anchalag@amazon.com>
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

Save/restore xen_sched_clock_offset in syscore suspend/resume during PM
hibernation. Commit '867cefb4cb1012: ("xen: Fix x86 sched_clock() interface
for xen")' fixes xen guest time handling during migration. A similar issue
is seen during PM hibernation when system runs CPU intensive workload.
Post resume pvclock resets the value to 0 however, xen sched_clock_offset
is never updated. System instability is seen during resume from hibernation
when system is under heavy CPU load. Since xen_sched_clock_offset is not
updated, system does not see the monotonic clock value and the scheduler
would then think that heavy CPU hog tasks need more time in CPU, causing
the system to freeze

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/suspend.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index b12db6966af6..a62e08a11681 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -98,8 +98,9 @@ static int xen_syscore_suspend(void)
 		return 0;
 
 	gnttab_suspend();
-
 	xen_manage_runstate_time(-1);
+	xen_save_sched_clock_offset();
+
 	xrfp.domid = DOMID_SELF;
 	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
 
@@ -120,6 +121,12 @@ static void xen_syscore_resume(void)
 	xen_hvm_map_shared_info();
 
 	pvclock_resume();
+
+	/*
+	 * Restore xen_sched_clock_offset during resume to maintain
+	 * monotonic clock value
+	 */
+	xen_restore_sched_clock_offset();
 	xen_manage_runstate_time(0);
 	gnttab_resume();
 }
-- 
2.16.6

