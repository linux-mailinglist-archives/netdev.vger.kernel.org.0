Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C51F15FA87
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgBNX0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:26:50 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:9208 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgBNX0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:26:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581722809; x=1613258809;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=UMKkqskcj+uJc+bMo+rVrL+B1mUIrmErlOz9JcigkDg=;
  b=K7YnIgqvLokD5Zq7gJtR+xt+KWcEPo58+XvVX/HcROgC7lM147PcEho/
   jcGOZyfAyaEYDax4nMIyx5cLiHe8+yfGtZbgsUOrCFf5yubwIbQ185lFa
   n7rb7LVujZxHf78bVUGxpcwxQE7uCS4bLl6jqNLBxq8O6vFpV5AytflBN
   s=;
IronPort-SDR: XLi6hZdvWyf7uNHazz/iulkhBXgI093HQ6dQRzAdNaXJql5DDSrkG+d7cAh5YRJHw6o1DuT9Es
 275DPTN1UEvw==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="16798132"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Feb 2020 23:26:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 46059A272A;
        Fri, 14 Feb 2020 23:26:39 +0000 (UTC)
Received: from EX13D07UWB004.ant.amazon.com (10.43.161.196) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:26:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D07UWB004.ant.amazon.com (10.43.161.196) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:26:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 14 Feb 2020 23:26:24 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 9BC794028E; Fri, 14 Feb 2020 23:26:24 +0000 (UTC)
Date:   Fri, 14 Feb 2020 23:26:24 +0000
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
Subject: [RFC PATCH v3 08/12] xen/time: introduce
 xen_{save,restore}_steal_clock
Message-ID: <489caa869095f77ed8db188d36e858533d7b4d7c.1581721799.git.anchalag@amazon.com>
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

Currently, steal time accounting code in scheduler expects steal clock
callback to provide monotonically increasing value. If the accounting
code receives a smaller value than previous one, it uses a negative
value to calculate steal time and results in incorrectly updated idle
and steal time accounting. This breaks userspace tools which read
/proc/stat.

top - 08:05:35 up  2:12,  3 users,  load average: 0.00, 0.07, 0.23
Tasks:  80 total,   1 running,  79 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.0%sy,  0.0%ni,30100.0%id,  0.0%wa,  0.0%hi, 0.0%si,-1253874204672.0%st

This can actually happen when a Xen PVHVM guest gets restored from
hibernation, because such a restored guest is just a fresh domain from
Xen perspective and the time information in runstate info starts over
from scratch.

This patch introduces xen_save_steal_clock() which saves current values
in runstate info into per-cpu variables. Its couterpart,
xen_restore_steal_clock(), sets offset if it found the current values in
runstate info are smaller than previous ones. xen_steal_clock() is also
modified to use the offset to ensure that scheduler only sees
monotonically increasing number.

Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 drivers/xen/time.c    | 29 ++++++++++++++++++++++++++++-
 include/xen/xen-ops.h |  2 ++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/time.c b/drivers/xen/time.c
index 0968859c29d0..3560222cc0dd 100644
--- a/drivers/xen/time.c
+++ b/drivers/xen/time.c
@@ -23,6 +23,9 @@ static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
 
 static DEFINE_PER_CPU(u64[4], old_runstate_time);
 
+static DEFINE_PER_CPU(u64, xen_prev_steal_clock);
+static DEFINE_PER_CPU(u64, xen_steal_clock_offset);
+
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
 {
@@ -149,7 +152,7 @@ bool xen_vcpu_stolen(int vcpu)
 	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
 }
 
-u64 xen_steal_clock(int cpu)
+static u64 __xen_steal_clock(int cpu)
 {
 	struct vcpu_runstate_info state;
 
@@ -157,6 +160,30 @@ u64 xen_steal_clock(int cpu)
 	return state.time[RUNSTATE_runnable] + state.time[RUNSTATE_offline];
 }
 
+u64 xen_steal_clock(int cpu)
+{
+	return __xen_steal_clock(cpu) + per_cpu(xen_steal_clock_offset, cpu);
+}
+
+void xen_save_steal_clock(int cpu)
+{
+	per_cpu(xen_prev_steal_clock, cpu) = xen_steal_clock(cpu);
+}
+
+void xen_restore_steal_clock(int cpu)
+{
+	u64 steal_clock = __xen_steal_clock(cpu);
+
+	if (per_cpu(xen_prev_steal_clock, cpu) > steal_clock) {
+		/* Need to update the offset */
+		per_cpu(xen_steal_clock_offset, cpu) =
+		    per_cpu(xen_prev_steal_clock, cpu) - steal_clock;
+	} else {
+		/* Avoid unnecessary steal clock warp */
+		per_cpu(xen_steal_clock_offset, cpu) = 0;
+	}
+}
+
 void xen_setup_runstate_info(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 3b3992b5b0c2..12b3f4474a05 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -37,6 +37,8 @@ void xen_time_setup_guest(void);
 void xen_manage_runstate_time(int action);
 void xen_get_runstate_snapshot(struct vcpu_runstate_info *res);
 u64 xen_steal_clock(int cpu);
+void xen_save_steal_clock(int cpu);
+void xen_restore_steal_clock(int cpu);
 
 int xen_setup_shutdown_event(void);
 
-- 
2.24.1.AMZN

