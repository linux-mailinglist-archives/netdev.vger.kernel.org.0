Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C75D400217
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349755AbhICP0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349723AbhICP0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630682735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNj8NGWz5L1ZAr7qBLVnIqJwxG8whEp3JYJxUDyzQI8=;
        b=hv9JHDl5A8XII+4iKxXuhNPn4RqVm9Y/Hqb97ejWHy9v4Q12iLzPZmng36JJP7OD3CHkB6
        aPCXJTmpaLcUpSmiPang+PrhVQGFPnRrPKlDnWKxA9ae6FRK1705sOtkpOpDcgnGSSEDiz
        svMoj6l146y4JF64NvqVAdHc88F0L8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-UySCPEeaMxaHy29gvn9Law-1; Fri, 03 Sep 2021 11:25:34 -0400
X-MC-Unique: UySCPEeaMxaHy29gvn9Law-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43C3780198A;
        Fri,  3 Sep 2021 15:25:33 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87A0B69CAD;
        Fri,  3 Sep 2021 15:25:28 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        mtosatti@redhat.com, juri.lelli@redhat.com, frederic@kernel.org,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org
Cc:     nilal@redhat.com, jesse.brandeburg@intel.com, robin.murphy@arm.com,
        mingo@kernel.org, jbrandeb@kernel.org, akpm@linuxfoundation.org,
        sfr@canb.auug.org.au, stephen@networkplumber.org,
        rppt@linux.vnet.ibm.com, chris.friesen@windriver.com,
        maz@kernel.org, nhorman@tuxdriver.com, pjwaskiewicz@gmail.com,
        sassmann@redhat.com, thenzl@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kabel@kernel.org, viresh.kumar@linaro.org, kuba@kernel.org,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, tglx@linutronix.de,
        ley.foon.tan@intel.com, jbrunet@baylibre.com,
        johannes@sipsolutions.net, snelson@pensando.io,
        lewis.hanly@microchip.com, benve@cisco.com, _govind@gmx.com,
        jassisinghbrar@gmail.com
Subject: [PATCH v6 05/14] scsi: mpt3sas: Use irq_set_affinity_and_hint
Date:   Fri,  3 Sep 2021 11:24:21 -0400
Message-Id: <20210903152430.244937-6-nitesh@redhat.com>
In-Reply-To: <20210903152430.244937-1-nitesh@redhat.com>
References: <20210903152430.244937-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() specifically for the high IOPS
queue interrupts for two purposes:

- To set the affinity_hint which is consumed by the userspace for
  distributing the interrupts

- To apply an affinity that it provides

The driver enforces its own affinity to bind the high IOPS queue interrupts
to the local NUMA node. However, irq_set_affinity_hint() applying the
provided cpumask as an affinity (if not NULL) for the interrupt is an
undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked
as deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
where the provided mask needs to be applied as the affinity and
affinity_hint pointer needs to be set and replace with
irq_update_affinity_hint() where only affinity_hint needs to be updated.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Reviewed-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6c82435bc9cc..48b826b3414f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3084,6 +3084,7 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 void
 mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 {
+	unsigned int irq;
 	struct adapter_reply_queue *reply_q, *next;
 
 	if (list_empty(&ioc->reply_queue_list))
@@ -3096,9 +3097,10 @@ mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		}
 
-		if (ioc->smp_affinity_enable)
-			irq_set_affinity_hint(pci_irq_vector(ioc->pdev,
-			    reply_q->msix_index), NULL);
+		if (ioc->smp_affinity_enable) {
+			irq = pci_irq_vector(ioc->pdev, reply_q->msix_index);
+			irq_update_affinity_hint(irq, NULL);
+		}
 		free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index),
 			 reply_q);
 		kfree(reply_q);
@@ -3165,18 +3167,15 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
  * @ioc: per adapter object
  *
  * The enduser would need to set the affinity via /proc/irq/#/smp_affinity
- *
- * It would nice if we could call irq_set_affinity, however it is not
- * an exported symbol
  */
 static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
-	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	unsigned int cpu, nr_cpus, nr_msix, index = 0, irq;
 	struct adapter_reply_queue *reply_q;
-	int local_numa_node;
 	int iopoll_q_count = ioc->reply_queue_count -
 	    ioc->iopoll_q_start_index;
+	const struct cpumask *mask;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -3199,11 +3198,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			local_numa_node = dev_to_node(&ioc->pdev->dev);
+			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
-				irq_set_affinity_hint(pci_irq_vector(ioc->pdev,
-				    index), cpumask_of_node(local_numa_node));
+				irq = pci_irq_vector(ioc->pdev, index);
+				irq_set_affinity_and_hint(irq, mask);
 			}
 		}
 
-- 
2.27.0

