Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EC615B3CE
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgBLWdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:33:40 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:14124 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgBLWdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546819; x=1613082819;
  h=date:from:to:subject:message-id:mime-version;
  bh=A9MU6ix5doEWHx0Vi3fmKI9vPHFZ3AdrseuapfeQP6E=;
  b=oo6cXdKExzZ42s6Pj6UB01pCDhsvV+KIwaI3YVMfxqkCUXvZmL7Ayp83
   /+9H6nLd5NGJKxRqY9+zOZKpZWVUkZox5SPM9CARCdtTeXsRybXA5TfMN
   JMhMVvKQdoZWsSZVxddI3jd9b9T51SrGhFqMbi6K3hrQ9X18uqvWRbOdu
   I=;
IronPort-SDR: 6SjWQm0/EyoJwJdeUjL93w2E+e0UXuq767GbG34KzQQlp+sr4MEOYRW+f62srQBgMnRa/xpbuQ
 pYbwJNMLtC2A==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="16031289"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 12 Feb 2020 22:33:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 9CF35A1F8F;
        Wed, 12 Feb 2020 22:33:19 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:33:05 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:33:05 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:33:04 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id BFC29400D1; Wed, 12 Feb 2020 22:33:04 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:33:04 +0000
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
Subject: [RFC PATCH v3 07/12] genirq: Shutdown irq chips in suspend/resume
 during hibernation
Message-ID: <20200212223304.GA4262@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no pm handlers for the legacy devices, so during tear down
stale event channel <> IRQ mapping may still remain in the image and
resume may fail. To avoid adding much code by implementing handlers for
legacy devices, add a new irq_chip flag IRQCHIP_SHUTDOWN_ON_SUSPEND which
when enabled on an irq-chip e.g xen-pirq, it will let core suspend/resume
irq code to shutdown and restart the active irqs. PM suspend/hibernation
code will rely on this.
Without this, in PM hibernation, information about the event channel
remains in hibernation image, but there is no guarantee that the same
event channel numbers are assigned to the devices when restoring the
system. This may cause conflict like the following and prevent some
devices from being restored correctly.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>

---
Changes since V2:
    * Its new  patch to fix shutdown/restore pirqs during hibernation
    * Removed previous 2 patches to shutdown/restore pirqs in xen code
---
 drivers/xen/events/events_base.c |  1 +
 include/linux/irq.h              |  2 ++
 kernel/irq/chip.c                |  2 +-
 kernel/irq/internals.h           |  1 +
 kernel/irq/pm.c                  | 31 ++++++++++++++++++++++---------
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 6c8843968a52..e44f27b45bef 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1620,6 +1620,7 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 	.irq_set_affinity	= set_affinity_irq,
 
 	.irq_retrigger		= retrigger_dynirq,
+	.flags                  = IRQCHIP_SHUTDOWN_ON_SUSPEND,
 };
 
 static struct irq_chip xen_percpu_chip __read_mostly = {
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fb301cf29148..2873a579fd9d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -511,6 +511,7 @@ struct irq_chip {
  * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  * IRQCHIP_SUPPORTS_LEVEL_MSI	Chip can provide two doorbells for Level MSIs
  * IRQCHIP_SUPPORTS_NMI:	Chip can deliver NMIs, only for root irqchips
+ * IRQCHIP_SHUTDOWN_ON_SUSPEND: Shutdown non wake irqs in the suspend path
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -522,6 +523,7 @@ enum {
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
 	IRQCHIP_SUPPORTS_LEVEL_MSI	= (1 <<  7),
 	IRQCHIP_SUPPORTS_NMI		= (1 <<  8),
+	IRQCHIP_SHUTDOWN_ON_SUSPEND     = (1 <<  9),
 };
 
 #include <linux/irqdesc.h>
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b76703b2c0af..a1e8df5193ba 100644
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
index 3924fbe829d4..11c7c55bda63 100644
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
index 8f557fa1f4fe..dc48a25f1756 100644
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
2.24.1.AMZN

