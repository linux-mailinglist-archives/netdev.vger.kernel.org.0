Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A453D0550
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhGTWqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:46:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233543AbhGTWqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626823603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8qwJ8QWsQyg6yDCqte1+0YiYPKWYX+C0w9lgnqdx8jY=;
        b=hWny+PJfN1T+/1guwDGMLAgN4cIzMDJnRd3wNUeUOKSvT/1QqXxg625y02nF0Hdsb1rKdL
        0FMkkE8uw7jSFAq9T16ZNwmbUcYn6ABmugkdo2mJAJv3DuzpHRQHjrv9jPnorrGLR2kA+g
        mcZLS4PbIkZ+1tsXJGTsvp/ZsPO5dsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-UVkORPB-PCCzXzPFZZCzBA-1; Tue, 20 Jul 2021 19:26:41 -0400
X-MC-Unique: UVkORPB-PCCzXzPFZZCzBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FA66100C61C;
        Tue, 20 Jul 2021 23:26:39 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6B9E69CB4;
        Tue, 20 Jul 2021 23:26:34 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        _govind@gmx.com, kabel@kernel.org, viresh.kumar@linaro.org,
        Tushar.Khandelwal@arm.com, kuba@kernel.org
Subject: [PATCH v5 01/14] genirq: Provide new interfaces for affinity hints
Date:   Tue, 20 Jul 2021 19:26:11 -0400
Message-Id: <20210720232624.1493424-2-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-1-nitesh@redhat.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The discussion about removing the side effect of irq_set_affinity_hint() of
actually applying the cpumask (if not NULL) as affinity to the interrupt,
unearthed a few unpleasantries:

  1) The modular perf drivers rely on the current behaviour for the very
     wrong reasons.

  2) While none of the other drivers prevents user space from changing
     the affinity, a cursorily inspection shows that there are at least
     expectations in some drivers.

#1 needs to be cleaned up anyway, so that's not a problem

#2 might result in subtle regressions especially when irqbalanced (which
   nowadays ignores the affinity hint) is disabled.

Provide new interfaces:

  irq_update_affinity_hint()  - Only sets the affinity hint pointer
  irq_set_affinity_and_hint() - Set the pointer and apply the affinity to
                                the interrupt

Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
document it to be phased out.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
---
 include/linux/interrupt.h | 53 ++++++++++++++++++++++++++++++++++++++-
 kernel/irq/manage.c       |  8 +++---
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2ed65b01c961..c2563a9321d7 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -328,7 +328,46 @@ extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
-extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+				     bool setaffinity);
+
+/**
+ * irq_update_affinity_hint - Update the affinity hint
+ * @irq:	Interrupt to update
+ * @m:		cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint, but does not change the affinity of the interrupt.
+ */
+static inline int
+irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, false);
+}
+
+/**
+ * irq_set_affinity_and_hint - Update the affinity hint and apply the provided
+ *			     cpumask to the interrupt
+ * @irq:	Interrupt to update
+ * @m:		cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint and if @m is not NULL it applies it as the
+ * affinity of that interrupt.
+ */
+static inline int
+irq_set_affinity_and_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, true);
+}
+
+/*
+ * Deprecated. Use irq_update_affinity_hint() or irq_set_affinity_and_hint()
+ * instead.
+ */
+static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return irq_set_affinity_and_hint(irq, m);
+}
+
 extern int irq_update_affinity_desc(unsigned int irq,
 				    struct irq_affinity_desc *affinity);
 
@@ -360,6 +399,18 @@ static inline int irq_can_set_affinity(unsigned int irq)
 
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
+static inline int irq_update_affinity_hint(unsigned int irq,
+					   const struct cpumask *m)
+{
+	return -EINVAL;
+}
+
+static inline int irq_set_affinity_and_hint(unsigned int irq,
+					    const struct cpumask *m)
+{
+	return -EINVAL;
+}
+
 static inline int irq_set_affinity_hint(unsigned int irq,
 					const struct cpumask *m)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ef30b4762947..837b63e63111 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -487,7 +487,8 @@ int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
 }
 EXPORT_SYMBOL_GPL(irq_force_affinity);
 
-int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+			      bool setaffinity)
 {
 	unsigned long flags;
 	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
@@ -496,12 +497,11 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 		return -EINVAL;
 	desc->affinity_hint = m;
 	irq_put_desc_unlock(desc, flags);
-	/* set the initial affinity to prevent every interrupt being on CPU0 */
-	if (m)
+	if (m && setaffinity)
 		__irq_set_affinity(irq, m, false);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+EXPORT_SYMBOL_GPL(__irq_apply_affinity_hint);
 
 static void irq_affinity_notify(struct work_struct *work)
 {
-- 
2.27.0

