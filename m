Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ED327B4A0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgI1Sgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:36:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726821AbgI1SgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:36:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601318181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=9oz+ynoTvhiufuVyMQ1xRlRqNWLd2L6kBLmgTWRX5ss=;
        b=Ygcw0dGRLe/e3XgOOe7GEKbOi33+SmaqafwCUcO1dA69FEVi4WDYJv6GaB8TM3UCP34hBz
        9pqAEQf4jHS35m8znmXpPvOXUEhrpWrj7L0SSeSd6impO8FlzNh69wycCKCfriBjA4vW8i
        fXy/oBzoTgmDSJqjBgXXaYDP5cCQQaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-vfI2srfRPH2G4PSp-PI-ng-1; Mon, 28 Sep 2020 14:36:16 -0400
X-MC-Unique: vfI2srfRPH2G4PSp-PI-ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C434585C732;
        Mon, 28 Sep 2020 18:36:13 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 084E860C11;
        Mon, 28 Sep 2020 18:36:11 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, nitesh@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
Date:   Mon, 28 Sep 2020 14:35:29 -0400
Message-Id: <20200928183529.471328-5-nitesh@redhat.com>
In-Reply-To: <20200928183529.471328-1-nitesh@redhat.com>
References: <20200928183529.471328-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have isolated CPUs dedicated for use by real-time tasks, we try to
move IRQs to housekeeping CPUs from the userspace to reduce latency
overhead on the isolated CPUs.

If we allocate too many IRQ vectors, moving them all to housekeeping CPUs
may exceed per-CPU vector limits.

When we have isolated CPUs, limit the number of vectors allocated by
pci_alloc_irq_vectors() to the minimum number required by the driver, or
to one per housekeeping CPU if that is larger.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/pci/msi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 30ae4ffda5c1..8c156867803c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/irqdomain.h>
 #include <linux/of_irq.h>
+#include <linux/sched/isolation.h>
 
 #include "pci.h"
 
@@ -1191,8 +1192,25 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 				   struct irq_affinity *affd)
 {
 	struct irq_affinity msi_default_affd = {0};
+	unsigned int hk_cpus;
 	int nvecs = -ENOSPC;
 
+	hk_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
+
+	/*
+	 * If we have isolated CPUs for use by real-time tasks, to keep the
+	 * latency overhead to a minimum, device-specific IRQ vectors are moved
+	 * to the housekeeping CPUs from the userspace by changing their
+	 * affinity mask. Limit the vector usage to keep housekeeping CPUs from
+	 * running out of IRQ vectors.
+	 */
+	if (hk_cpus < num_online_cpus()) {
+		if (hk_cpus < min_vecs)
+			max_vecs = min_vecs;
+		else if (hk_cpus < max_vecs)
+			max_vecs = hk_cpus;
+	}
+
 	if (flags & PCI_IRQ_AFFINITY) {
 		if (!affd)
 			affd = &msi_default_affd;
-- 
2.18.2

