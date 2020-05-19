Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8281DA596
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgESX37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:29:59 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:51238 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgESX36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589930997; x=1621466997;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=r7lbs73sfsvJ86GyRkYhd6/aeNxAVZ1wrAJ3MEWq1QM=;
  b=vIqPsPAplA6WpXtqyybTqMVOdFQYsDFx+OvQzEHCEdTY3aiD7ihfOx59
   g+5BMFzLzIVKJIoC8HddpFK/h1w7AKRMg77HKOsDj3+9/F3v4v+Z7Pp9M
   Zk9x3dzk4C1EP8xfQi0G4jq2PYRjluRTA/stvNspoNmy/5TtEmH7VzYiX
   0=;
IronPort-SDR: 9zWNpH8TfAOVXYXC65zH0YTjctxGH5l94tqUBCBdTwFQ9nB5vkppYKlmCsdTEitS5G1lbnrQj9
 3msnk5oBY8Ww==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="31182653"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 May 2020 23:29:55 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 304E8A2003;
        Tue, 19 May 2020 23:29:53 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:29:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:29:39 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:29:39 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 81BF340712; Tue, 19 May 2020 23:29:39 +0000 (UTC)
Date:   Tue, 19 May 2020 23:29:39 +0000
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
Subject: [PATCH 11/12] xen: Update sched clock offset to avoid system
 instability in hibernation
Message-ID: <4066d54951f4ba9437eb0ff6aeb5288fcd20c2fb.1589926004.git.anchalag@amazon.com>
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
 arch/x86/xen/suspend.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index dae0f74f5390..7e5275944810 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -105,6 +105,8 @@ static int xen_syscore_suspend(void)
 		xen_save_steal_clock(cpu);
 	}
 
+	xen_save_sched_clock_offset();
+
 	xrfp.domid = DOMID_SELF;
 	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
 
@@ -126,6 +128,12 @@ static void xen_syscore_resume(void)
 
 	pvclock_resume();
 
+	/*
+	 * Restore xen_sched_clock_offset during resume to maintain
+	 * monotonic clock value
+	 */
+	xen_restore_sched_clock_offset();
+
 	/* Nonboot CPUs will be resumed when they're brought up */
 	xen_restore_steal_clock(smp_processor_id());
 
-- 
2.24.1.AMZN

