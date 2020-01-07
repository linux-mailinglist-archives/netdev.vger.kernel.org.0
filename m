Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189B61337A3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgAGXol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:44:41 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49868 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgAGXol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440680; x=1609976680;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=f6Z3Yh5Svpg3B2CNoDg+pE4bEOLYIDxF72khvbH/8BY=;
  b=jPvScGo5QEpUBPzh7LP5nv5KKNgTK80b5wox5ndDK4Cf6qEDfDXjLTko
   NSBsKxFb/S/CEIC/4C1f+5rw4mB9kJ/BEzX873Qsz3tBeSHoA5L1ZqYv6
   /TsV0N/DZoDuN3c+WRNt801wm9CDaNq/RsXHryTP9cCbdCL25VgWE99M+
   k=;
IronPort-SDR: VN1Xhl+bt3NNnO0zmMcnfsgfdV3B10I31QHUCoO03TuuoIqc3+CWPtyE1hCWoqAapXVMKhX0hf
 /se6u6x4A+3Q==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="11335463"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Jan 2020 23:44:39 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 8A5F71A0AC3;
        Tue,  7 Jan 2020 23:44:36 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:44:21 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:44:21 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:44:20 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id CE67040E65; Tue,  7 Jan 2020 23:44:20 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:44:20 +0000
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
Subject: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during
 shutdown PIRQs
Message-ID: <20200107234420.GA18738@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shutdown_pirq is invoked during hibernation path and hence
PIRQs should be restarted during resume.
Before this commit'020db9d3c1dc0a' xen/events: Fix interrupt lost
during irq_disable and irq_enable startup_pirq was automatically
called during irq_enable however, after this commit pirq's did not
get explicitly started once resumed from hibernation.

chip->irq_startup is called only if IRQD_IRQ_STARTED is unset during
irq_startup on resume. This flag gets cleared by free_irq->irq_shutdown
during suspend. free_irq() never gets explicitly called for ioapic-edge
and ioapic-level interrupts as respective drivers do nothing during
suspend/resume. So we shut them down explicitly in the first place in
syscore_suspend path to clear IRQ<>event channel mapping. shutdown_pirq
being called explicitly during suspend does not clear this flags, hence
.irq_enable is called in irq_startup during resume instead and pirq's
never start up.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 drivers/xen/events/events_base.c | 1 +
 include/linux/irq.h              | 1 +
 kernel/irq/chip.c                | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index b893536d8af4..aae7c4997b51 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1606,6 +1606,7 @@ void xen_shutdown_pirqs(void)
 			continue;
 
 		shutdown_pirq(irq_get_irq_data(info->irq));
+		irq_state_clr_started(irq_to_desc(info->irq));
 	}
 }
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fb301cf29148..1e125cd22cf0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -745,6 +745,7 @@ extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
 				struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
+extern void irq_state_clr_started(struct irq_desc *desc);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
 {
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b76703b2c0af..3e8a36c673d6 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -173,10 +173,11 @@ static void irq_state_clr_masked(struct irq_desc *desc)
 	irqd_clear(&desc->irq_data, IRQD_IRQ_MASKED);
 }
 
-static void irq_state_clr_started(struct irq_desc *desc)
+void irq_state_clr_started(struct irq_desc *desc)
 {
 	irqd_clear(&desc->irq_data, IRQD_IRQ_STARTED);
 }
+EXPORT_SYMBOL_GPL(irq_state_clr_started);
 
 static void irq_state_set_started(struct irq_desc *desc)
 {
-- 
2.15.3.AMZN

