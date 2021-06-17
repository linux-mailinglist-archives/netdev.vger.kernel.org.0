Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C923ABBA0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhFQS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233638AbhFQS0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zkGoMadKmvDhmhMXSbPLlXhKPKbYIBPf7+Kg/PZ+k4c=;
        b=FvmNtBURLcpoMtfyPz6HaZy7C8Nntv47PSU0j57/Zj+9xdxdT5tl62dRMt0KbNPpIKAqkH
        fPqd7cPmTqXsCokeuPBxJUqQ7WVHbsxk7BC8PmKkfNGG/wh1ajAG+MY26+Zd0/fGJlrcWH
        3GVnEgdmcWfCNfbqA1FveaBPFvsZXJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-LOBidRndP4OqeYDabxhLeA-1; Thu, 17 Jun 2021 14:24:25 -0400
X-MC-Unique: LOBidRndP4OqeYDabxhLeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 098BC100C61F;
        Thu, 17 Jun 2021 18:24:20 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7961F61156;
        Thu, 17 Jun 2021 18:24:16 +0000 (UTC)
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
Subject: [PATCH v1 10/14] mailbox: Use irq_update_affinity_hint
Date:   Thu, 17 Jun 2021 14:22:38 -0400
Message-Id: <20210617182242.8637-11-nitesh@redhat.com>
In-Reply-To: <20210617182242.8637-1-nitesh@redhat.com>
References: <20210617182242.8637-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() to:

- Set the affinity_hint which is consumed by the userspace for
  distributing the interrupts

- Enforce affinity

As per commit 6ac17fe8c14a ("mailbox: bcm-flexrm-mailbox: Set IRQ affinity
hint for FlexRM ring IRQs") the latter is done to ensure that the FlexRM
ring interrupts are evenly spread across all available CPUs. However, since
commit a0c9259dc4e1 ("irq/matrix: Spread interrupts on allocation") the
spreading of interrupts is dynamically performed at the time of allocation.
Hence, there is no need for the drivers to enforce their own affinity for
the spreading of interrupts.

Also, irq_set_affinity_hint() applying the provided cpumask as an affinity
for the interrupt is an undocumented side effect. To remove this side
effect irq_set_affinity_hint() has been marked as deprecated and new
interfaces have been introduced. Hence, replace the irq_set_affinity_hint()
with the new interface irq_update_affinity_hint() that only sets the
affinity_hint pointer.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/mailbox/bcm-flexrm-mailbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index b4f33dc399a0..abdd06d1986a 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -1298,7 +1298,7 @@ static int flexrm_startup(struct mbox_chan *chan)
 	val = (num_online_cpus() < val) ? val / num_online_cpus() : 1;
 	cpumask_set_cpu((ring->num / val) % num_online_cpus(),
 			&ring->irq_aff_hint);
-	ret = irq_set_affinity_hint(ring->irq, &ring->irq_aff_hint);
+	ret = irq_update_affinity_hint(ring->irq, &ring->irq_aff_hint);
 	if (ret) {
 		dev_err(ring->mbox->dev,
 			"failed to set IRQ affinity hint for ring%d\n",
@@ -1425,7 +1425,7 @@ static void flexrm_shutdown(struct mbox_chan *chan)
 
 	/* Release IRQ */
 	if (ring->irq_requested) {
-		irq_set_affinity_hint(ring->irq, NULL);
+		irq_update_affinity_hint(ring->irq, NULL);
 		free_irq(ring->irq, ring);
 		ring->irq_requested = false;
 	}
-- 
2.27.0

