Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CFD38C62B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 14:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhEUMEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUMEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 08:04:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7C0C061574;
        Fri, 21 May 2021 05:03:08 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621598586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73BhFEnE00P9EM7W8eDaV9ldNZ5X2YG6+sa8CRY7WwM=;
        b=L25M5Zy6NkFNkFQBlo/MBFeB3Te3ulISHeXqR86FRlFCq8g6/qWe3XZ9/pwYYjkJ12704U
        q9oPzIRd0iGCg1nN3gY3diTI02L0JBvQSKYWgiTFFoH/ZRePhtv2PYf5UsVDswqr7r+DwQ
        5zJSxlP4BkqdpHUn2cv5x/8f/hXJK1toxKuforc+pQ193/UextIlqjeeGgMSPvANL+vr+p
        iIg82cUse/0NSDAEaaV0af9Jig2TmfUADkV5cd6/QqMDOfDCFqcqJJG1rZUTNJ//Gl1gZp
        6xZSGTHaCw0eAQW50oGNbgCMYvaZatY6jV+UxSdVx1J3k1tD1GaaYLHk1Vh6Qw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621598586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73BhFEnE00P9EM7W8eDaV9ldNZ5X2YG6+sa8CRY7WwM=;
        b=HEmmL6baryu7dXT+7IwyJWArNzSXr5UDH3j4xtBPCKgdAYRJHTQFzFPDgdTW9qDXx7Dk2G
        3SF1UU9zwPJyrCBA==
To:     Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Subject: [PATCH] genirq: Provide new interfaces for affinity hints
In-Reply-To: <87zgwo9u79.ffs@nanos.tec.linutronix.de>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com> <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com> <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com> <87zgwo9u79.ffs@nanos.tec.linutronix.de>
Date:   Fri, 21 May 2021 14:03:06 +0200
Message-ID: <87wnrs9tvp.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

  irq_update_affinity_hint() - Only sets the affinity hint pointer
  irq_apply_affinity_hint()  - Set the pointer and apply the affinity to
  			       the interrupt

Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
document it to be phased out.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
---
Applies on:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
---
 include/linux/interrupt.h |   41 ++++++++++++++++++++++++++++++++++++++++-
 kernel/irq/manage.c       |    8 ++++----
 2 files changed, 44 insertions(+), 5 deletions(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -328,7 +328,46 @@ extern int irq_force_affinity(unsigned i
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
-extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+				     bool setaffinity);
+
+/**
+ * irq_update_affinity_hint - Update the affinity hint
+ * @irq:	Interrupt to update
+ * @cpumask:	cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint, but does not change the affinity of the interrupt.
+ */
+static inline int
+irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, true);
+}
+
+/**
+ * irq_apply_affinity_hint - Update the affinity hint and apply the provided
+ *			     cpumask to the interrupt
+ * @irq:	Interrupt to update
+ * @cpumask:	cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint and if @cpumask is not NULL it applies it as
+ * the affinity of that interrupt.
+ */
+static inline int
+irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, true);
+}
+
+/*
+ * Deprecated. Use irq_update_affinity_hint() or irq_apply_affinity_hint()
+ * instead.
+ */
+static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return irq_apply_affinity_hint(irq, cpumask);
+}
+
 extern int irq_update_affinity_desc(unsigned int irq,
 				    struct irq_affinity_desc *affinity);
 
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -487,7 +487,8 @@ int irq_force_affinity(unsigned int irq,
 }
 EXPORT_SYMBOL_GPL(irq_force_affinity);
 
-int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+			      bool setaffinity)
 {
 	unsigned long flags;
 	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
@@ -496,12 +497,11 @@ int irq_set_affinity_hint(unsigned int i
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
