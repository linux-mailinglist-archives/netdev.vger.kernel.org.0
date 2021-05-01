Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93183704F8
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 04:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhEACTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 22:19:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:20878 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhEACTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 22:19:39 -0400
IronPort-SDR: TlVpk4yjaAuBYCWXl5h9M0tlKyTXtHw/uK3ya+YKpa+4JNznusyHHgEYSA7VXYHoK8M5KgyVvh
 JL2dZ5eZ69yg==
X-IronPort-AV: E=McAfee;i="6200,9189,9970"; a="197508593"
X-IronPort-AV: E=Sophos;i="5.82,264,1613462400"; 
   d="scan'208";a="197508593"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 19:18:50 -0700
IronPort-SDR: JlpZ7xyrmFpR/5vTZHzOHISvtpryqsXmldHmo04zipfTYW/bB4m2M5kAjy/pZyyKFydt34Y8NK
 5ziTmsOj11yQ==
X-IronPort-AV: E=Sophos;i="5.82,264,1613462400"; 
   d="scan'208";a="467070538"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 19:18:50 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Nitesh Lal <nilal@redhat.com>
Subject: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
Date:   Fri, 30 Apr 2021 19:18:32 -0700
Message-Id: <20210501021832.743094-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was pointed out by Nitesh that the original work I did in 2014
to automatically set the interrupt affinity when requesting a
mask is no longer necessary. The kernel has moved on and no
longer has the original problem, BUT the original patch
introduced a subtle bug when booting a system with reserved or
excluded CPUs. Drivers calling this function with a mask value
that included a CPU that was currently or in the future
unavailable would generally not update the hint.

I'm sure there are a million ways to solve this, but the simplest
one is to just remove a little code that tries to force the
affinity, as Nitesh has shown it fixes the bug and doesn't seem
to introduce immediate side effects.

While I'm here, introduce a kernel-doc for the hint function.

Ref: https://lore.kernel.org/lkml/CAFki+L=_dd+JgAR12_eBPX0kZO2_6=1dGdgkwHE=u=K6chMeLQ@mail.gmail.com/
Cc: netdev@vger.kernel.org
Fixes: 4fe7ffb7e17c ("genirq: Fix null pointer reference in irq_set_affinity_hint()")
Fixes: e2e64a932556 ("genirq: Set initial affinity in irq_set_affinity_hint()")
Reported-by: Nitesh Lal <nilal@redhat.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

!!! NOTE: Compile tested only, would appreciate feedback

---
 kernel/irq/manage.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e976c4927b25..a31df64662d5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -456,6 +456,16 @@ int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 	return ret;
 }
 
+/**
+ * 	irq_set_affinity_hint - set the hint for an irq
+ *	@irq:	Interrupt for which to set the hint
+ *	@m:	Mask to indicate which CPUs to suggest for the interrupt, use
+ *		NULL here to indicate to clear the value.
+ *
+ *	Use this function to recommend which CPU should handle the
+ *	interrupt to any userspace that uses /proc/irq/nn/smp_affinity_hint
+ *	in order to align interrupts. Pass NULL as the mask to clear the hint.
+ */
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
@@ -465,9 +475,6 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 		return -EINVAL;
 	desc->affinity_hint = m;
 	irq_put_desc_unlock(desc, flags);
-	/* set the initial affinity to prevent every interrupt being on CPU0 */
-	if (m)
-		__irq_set_affinity(irq, m, false);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);

base-commit: 765822e1569a37aab5e69736c52d4ad4a289eba6
-- 
2.30.2

