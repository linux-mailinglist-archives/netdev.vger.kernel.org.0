Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C0924E35D
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHUW2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:28:13 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:33809 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgHUW2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:28:11 -0400
X-IronPort-AV: E=Sophos;i="5.76,338,1592870400"; 
   d="scan'208";a="49215816"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Aug 2020 22:28:07 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 1CFA0A250B;
        Fri, 21 Aug 2020 22:28:05 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:27:49 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 22:27:48 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 22:27:42 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id AB73240362; Fri, 21 Aug 2020 22:27:42 +0000 (UTC)
Date:   Fri, 21 Aug 2020 22:27:42 +0000
From:   Thomas Gleixner <tglx@linutronix.de>
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
Subject: [PATCH v3 05/11] genirq: Shutdown irq chips in suspend/resume during
 hibernation
Message-ID: <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com>
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

Many legacy device drivers do not implement power management (PM)
functions which means that interrupts requested by these drivers stay
in active state when the kernel is hibernated.

This does not matter on bare metal and on most hypervisors because the
interrupt is restored on resume without any noticable side effects as
it stays connected to the same physical or virtual interrupt line.

The XEN interrupt mechanism is different as it maintains a mapping
between the Linux interrupt number and a XEN event channel. If the
interrupt stays active on hibernation this mapping is preserved but
there is unfortunately no guarantee that on resume the same event
channels are reassigned to these devices. This can result in event
channel conflicts which prevent the affected devices from being
restored correctly.

One way to solve this would be to add the necessary power management
functions to all affected legacy device drivers, but that's a
questionable effort which does not provide any benefits on non-XEN
environments.

The least intrusive and most efficient solution is to provide a
mechanism which allows the core interrupt code to tear down these
interrupts on hibernation and bring them back up again on resume. This
allows the XEN event channel mechanism to assign an arbitrary event
channel on resume without affecting the functionality of these
devices.

Fortunately all these device interrupts are handled by a dedicated XEN
interrupt chip so the chip can be marked that all interrupts connected
to it are handled this way. This is pretty much in line with the other
interrupt chip specific quirks, e.g. IRQCHIP_MASK_ON_SUSPEND.

Add a new quirk flag IRQCHIP_SHUTDOWN_ON_SUSPEND and add support for
it the core interrupt suspend/resume paths.

Changelog:
v1->v2: Corrected the author's name to tglx@
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events/events_base.c |  1 +
 include/linux/irq.h              |  2 ++
 kernel/irq/chip.c                |  2 +-
 kernel/irq/internals.h           |  1 +
 kernel/irq/pm.c                  | 31 ++++++++++++++++++++++---------
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 140c7bf33a98..958dea2a4916 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1611,6 +1611,7 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 	.irq_set_affinity	= set_affinity_irq,
 
 	.irq_retrigger		= retrigger_dynirq,
+	.flags                  = IRQCHIP_SHUTDOWN_ON_SUSPEND,
 };
 
 static struct irq_chip xen_percpu_chip __read_mostly = {
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1b7f4dfee35b..9340eec4a5a6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -555,6 +555,7 @@ struct irq_chip {
  * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  * IRQCHIP_SUPPORTS_LEVEL_MSI	Chip can provide two doorbells for Level MSIs
  * IRQCHIP_SUPPORTS_NMI:	Chip can deliver NMIs, only for root irqchips
+ * IRQCHIP_SHUTDOWN_ON_SUSPEND: Shutdown non wake irqs in the suspend path
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -566,6 +567,7 @@ enum {
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
 	IRQCHIP_SUPPORTS_LEVEL_MSI	= (1 <<  7),
 	IRQCHIP_SUPPORTS_NMI		= (1 <<  8),
+	IRQCHIP_SHUTDOWN_ON_SUSPEND     = (1 <<  9),
 };
 
 #include <linux/irqdesc.h>
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 857f5f4c8098..136e3ebe996f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -233,7 +233,7 @@ __irq_startup_managed(struct irq_desc *desc, struct cpumask *aff, bool force)
 }
 #endif
 
-static int __irq_startup(struct irq_desc *desc)
+int __irq_startup(struct irq_desc *desc)
 {
 	struct irq_data *d = irq_desc_get_irq_data(desc);
 	int ret = 0;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 7db284b10ac9..b6fca5eacff7 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -80,6 +80,7 @@ extern void __enable_irq(struct irq_desc *desc);
 extern int irq_activate(struct irq_desc *desc);
 extern int irq_activate_and_startup(struct irq_desc *desc, bool resend);
 extern int irq_startup(struct irq_desc *desc, bool resend, bool force);
+extern int __irq_startup(struct irq_desc *desc);
 
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_shutdown_and_deactivate(struct irq_desc *desc);
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index c6c7e187ae74..3c4ffb2b6ef2 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -85,16 +85,25 @@ static bool suspend_device_irq(struct irq_desc *desc)
 	}
 
 	desc->istate |= IRQS_SUSPENDED;
-	__disable_irq(desc);
-
 	/*
-	 * Hardware which has no wakeup source configuration facility
-	 * requires that the non wakeup interrupts are masked at the
-	 * chip level. The chip implementation indicates that with
-	 * IRQCHIP_MASK_ON_SUSPEND.
+	 * Some irq chips (e.g. XEN PIRQ) require a full shutdown on suspend
+	 * as some of the legacy drivers(e.g. floppy) do nothing during the
+	 * suspend path
 	 */
-	if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
-		mask_irq(desc);
+	if (irq_desc_get_chip(desc)->flags & IRQCHIP_SHUTDOWN_ON_SUSPEND) {
+		irq_shutdown(desc);
+	} else {
+		__disable_irq(desc);
+
+	       /*
+		* Hardware which has no wakeup source configuration facility
+		* requires that the non wakeup interrupts are masked at the
+		* chip level. The chip implementation indicates that with
+		* IRQCHIP_MASK_ON_SUSPEND.
+		*/
+		if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
+			mask_irq(desc);
+	}
 	return true;
 }
 
@@ -152,7 +161,11 @@ static void resume_irq(struct irq_desc *desc)
 	irq_state_set_masked(desc);
 resume:
 	desc->istate &= ~IRQS_SUSPENDED;
-	__enable_irq(desc);
+
+	if (irq_desc_get_chip(desc)->flags & IRQCHIP_SHUTDOWN_ON_SUSPEND)
+		__irq_startup(desc);
+	else
+		__enable_irq(desc);
 }
 
 static void resume_irqs(bool want_early)
-- 
2.16.6

