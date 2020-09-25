Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C0279045
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgIYS1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:27:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729758AbgIYS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:27:16 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601058435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=rRcKZ8I6kczvYIrMGUe8rB/gq5sgstXC59hVf7TDlHU=;
        b=eEQJtITTC+hOGfEWdww96WTGNZXH0mcpEfUcLzXMvlFfX60mes9SPLSEZ0CEwjXU0Q46NA
        5/IelAlfb/J2fBek3bHSfslJEz1hpNgdHVgwjYObwQd0VqNZUNa+XDguAutFuYEI/CPIYG
        anJ7jPkEtt7r871U2pEBX4YJIbgcp8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-FZhrcYxJO-OgZXPDVOWqFQ-1; Fri, 25 Sep 2020 14:27:13 -0400
X-MC-Unique: FZhrcYxJO-OgZXPDVOWqFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2F0188EF1F;
        Fri, 25 Sep 2020 18:27:10 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BBA878810;
        Fri, 25 Sep 2020 18:27:09 +0000 (UTC)
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
Subject: [PATCH v3 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
Date:   Fri, 25 Sep 2020 14:26:54 -0400
Message-Id: <20200925182654.224004-5-nitesh@redhat.com>
In-Reply-To: <20200925182654.224004-1-nitesh@redhat.com>
References: <20200925182654.224004-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 include/linux/pci.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 835530605c0d..a7b10240b778 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/resource_ext.h>
+#include <linux/sched/isolation.h>
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
@@ -1797,6 +1798,22 @@ static inline int
 pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
 		      unsigned int max_vecs, unsigned int flags)
 {
+	unsigned int hk_cpus;
+
+	hk_cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
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
 	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
 					      NULL);
 }
-- 
2.18.2

