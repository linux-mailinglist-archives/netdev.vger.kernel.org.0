Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1818C3ABB6A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhFQSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:25:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233333AbhFQSZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yYHuenJYgR7jtuCWCYvc0qdRH5XTlfnj11MyvxR9Vw0=;
        b=asgjGRMZEcRoMAVBjf9ZmQ0KGaF0JK3VmoFdPs5rmOd8MoU0HAyWEKrlkYPodIDDMBW6ly
        uRtzMtwrmd0c35OiKSGL7VX36hbFMD1w9IlSwj376EEolQprga9CS4aWiBEIsQTWgeKDOS
        UBbI8qutDsEmV5L7qg91Ekz55A37foM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-jEJ7TYZaPYiafxmZlJvdUw-1; Thu, 17 Jun 2021 14:23:19 -0400
X-MC-Unique: jEJ7TYZaPYiafxmZlJvdUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5D568042A9;
        Thu, 17 Jun 2021 18:23:14 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F29DC60C05;
        Thu, 17 Jun 2021 18:23:07 +0000 (UTC)
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
        luobin9@huawei.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        nilal@redhat.com
Subject: [PATCH v1 02/14] iavf: Use irq_update_affinity_hint
Date:   Thu, 17 Jun 2021 14:22:30 -0400
Message-Id: <20210617182242.8637-3-nitesh@redhat.com>
In-Reply-To: <20210617182242.8637-1-nitesh@redhat.com>
References: <20210617182242.8637-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() for two purposes:

- To set the affinity_hint which is consumed by the userspace for
  distributing the interrupts

- To apply an affinity that it provides for the iavf interrupts

The latter is done to ensure that all the interrupts are evenly spread
across all available CPUs. However, since commit a0c9259dc4e1 ("irq/matrix:
Spread interrupts on allocation") the spreading of interrupts is
dynamically performed at the time of allocation. Hence, there is no need
for the drivers to enforce their own affinity for the spreading of
interrupts.

Also, irq_set_affinity_hint() applying the provided cpumask as an affinity
for the interrupt is an undocumented side effect. To remove this side
effect irq_set_affinity_hint() has been marked as deprecated and new
interfaces have been introduced. Hence, replace the irq_set_affinity_hint()
with the new interface irq_update_affinity_hint() that only sets the
pointer for the affinity_hint.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e612c24fa384..f2e8fab53cb9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -449,10 +449,10 @@ iavf_request_traffic_irqs(struct iavf_adapter *adapter, char *basename)
 		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
 		/* Spread the IRQ affinity hints across online CPUs. Note that
 		 * get_cpu_mask returns a mask with a permanent lifetime so
-		 * it's safe to use as a hint for irq_set_affinity_hint.
+		 * it's safe to use as a hint for irq_update_affinity_hint.
 		 */
 		cpu = cpumask_local_spread(q_vector->v_idx, -1);
-		irq_set_affinity_hint(irq_num, get_cpu_mask(cpu));
+		irq_update_affinity_hint(irq_num, get_cpu_mask(cpu));
 	}
 
 	return 0;
@@ -462,7 +462,7 @@ iavf_request_traffic_irqs(struct iavf_adapter *adapter, char *basename)
 		vector--;
 		irq_num = adapter->msix_entries[vector + NONQ_VECS].vector;
 		irq_set_affinity_notifier(irq_num, NULL);
-		irq_set_affinity_hint(irq_num, NULL);
+		irq_update_affinity_hint(irq_num, NULL);
 		free_irq(irq_num, &adapter->q_vectors[vector]);
 	}
 	return err;
@@ -514,7 +514,7 @@ static void iavf_free_traffic_irqs(struct iavf_adapter *adapter)
 	for (vector = 0; vector < q_vectors; vector++) {
 		irq_num = adapter->msix_entries[vector + NONQ_VECS].vector;
 		irq_set_affinity_notifier(irq_num, NULL);
-		irq_set_affinity_hint(irq_num, NULL);
+		irq_update_affinity_hint(irq_num, NULL);
 		free_irq(irq_num, &adapter->q_vectors[vector]);
 	}
 }
-- 
2.27.0

