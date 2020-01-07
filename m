Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B01337AB
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgAGXqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:46:03 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:5234 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbgAGXqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440763; x=1609976763;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=C+JaTHQLVFTnM8u9L8ZSkRBth8A1GrfPB1444d3zUEk=;
  b=Sr9NWBfYr6ulkMkmcFHEzSiwvc0g0eAjiTkqpLLBYc2/3t4/dVKFqR95
   Do7mIs2bQBbtpyX5AUEL3C5jVkolmJ6faHxFTbFlZ/Pza6obA4kGp2B5r
   JChND7g4GwILW0PlTH91rspBZ0sB3LgcHihQr23kjXX0aOamypKS61tRf
   0=;
IronPort-SDR: tgZkjPccZ3NN32ilYfpUAqXwfPAg3ycN79+7mbg/yBELHAIIAEhZkb41aLfWqiI5YJOmjh5N2D
 RKzL0UoG9vhw==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="8919095"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Jan 2020 23:46:01 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 04022A2516;
        Tue,  7 Jan 2020 23:45:52 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:45:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:45:26 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:45:26 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 982CE40E65; Tue,  7 Jan 2020 23:45:26 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:45:26 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.co>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
CC:     <anchalag@amazon.com>
Subject: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eduardo Valentin <eduval@amazon.com>

System instability are seen during resume from hibernation when system
is under heavy CPU load. This is due to the lack of update of sched
clock data, and the scheduler would then think that heavy CPU hog
tasks need more time in CPU, causing the system to freeze
during the unfreezing of tasks. For example, threaded irqs,
and kernel processes servicing network interface may be delayed
for several tens of seconds, causing the system to be unreachable.

Situation like this can be reported by using lockup detectors
such as workqueue lockup detectors:

[root@ip-172-31-67-114 ec2-user]# echo disk > /sys/power/state

Message from syslogd@ip-172-31-67-114 at May  7 18:23:21 ...
 kernel:BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 57s!

Message from syslogd@ip-172-31-67-114 at May  7 18:23:21 ...
 kernel:BUG: workqueue lockup - pool cpus=1 node=0 flags=0x0 nice=0 stuck for 57s!

Message from syslogd@ip-172-31-67-114 at May  7 18:23:21 ...
 kernel:BUG: workqueue lockup - pool cpus=3 node=0 flags=0x1 nice=0 stuck for 57s!

Message from syslogd@ip-172-31-67-114 at May  7 18:29:06 ...
 kernel:BUG: workqueue lockup - pool cpus=3 node=0 flags=0x1 nice=0 stuck for 403s!

The fix for this situation is to mark the sched clock as unstable
as early as possible in the resume path, leaving it unstable
for the duration of the resume process. This will force the
scheduler to attempt to align the sched clock across CPUs using
the delta with time of day, updating sched clock data. In a post
hibernation event, we can then mark the sched clock as stable
again, avoiding unnecessary syncs with time of day on systems
in which TSC is reliable.

Reviewed-by: Erik Quanstrom <quanstro@amazon.com>
Reviewed-by: Frank van der Linden <fllinden@amazon.com>
Reviewed-by: Balbir Singh <sblbir@amazon.com>
Reviewed-by: Munehisa Kamata <kamatam@amazon.com>
Tested-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Eduardo Valentin <eduval@amazon.com>
---
 arch/x86/kernel/tsc.c       | 29 +++++++++++++++++++++++++++++
 include/linux/sched/clock.h |  5 +++++
 kernel/sched/clock.c        |  4 ++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7e322e2daaf5..ae77b8bc4e46 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -14,6 +14,7 @@
 #include <linux/percpu.h>
 #include <linux/timex.h>
 #include <linux/static_key.h>
+#include <linux/suspend.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -1534,3 +1535,31 @@ unsigned long calibrate_delay_is_known(void)
 	return 0;
 }
 #endif
+
+static int tsc_pm_notifier(struct notifier_block *notifier,
+			    unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+		clear_sched_clock_stable();
+		break;
+	case PM_POST_HIBERNATION:
+		/* Set back to the default */
+		if (!check_tsc_unstable())
+			set_sched_clock_stable();
+		break;
+	}
+
+	return 0;
+};
+
+static struct notifier_block tsc_pm_notifier_block = {
+       .notifier_call = tsc_pm_notifier,
+};
+
+static int tsc_setup_pm_notifier(void)
+{
+       return register_pm_notifier(&tsc_pm_notifier_block);
+}
+
+subsys_initcall(tsc_setup_pm_notifier);
diff --git a/include/linux/sched/clock.h b/include/linux/sched/clock.h
index 867d588314e0..902654ac5f7e 100644
--- a/include/linux/sched/clock.h
+++ b/include/linux/sched/clock.h
@@ -32,6 +32,10 @@ static inline void clear_sched_clock_stable(void)
 {
 }
 
+static inline void set_sched_clock_stable(void)
+{
+}
+
 static inline void sched_clock_idle_sleep_event(void)
 {
 }
@@ -51,6 +55,7 @@ static inline u64 local_clock(void)
 }
 #else
 extern int sched_clock_stable(void);
+extern void set_sched_clock_stable(void);
 extern void clear_sched_clock_stable(void);
 
 /*
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 1152259a4ca0..374d40e5b1a2 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -116,7 +116,7 @@ static void __scd_stamp(struct sched_clock_data *scd)
 	scd->tick_raw = sched_clock();
 }
 
-static void __set_sched_clock_stable(void)
+void set_sched_clock_stable(void)
 {
 	struct sched_clock_data *scd;
 
@@ -236,7 +236,7 @@ static int __init sched_clock_init_late(void)
 	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
 
 	if (__sched_clock_stable_early)
-		__set_sched_clock_stable();
+		set_sched_clock_stable();
 
 	return 0;
 }
-- 
2.15.3.AMZN

