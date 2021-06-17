Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385663ABB83
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhFQS0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:26:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233570AbhFQS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yGtGwjM0HqOorIAs5Vljr+3B7rxAzLOFx0Bg3o4IjhM=;
        b=Dyzz1t/Q/bqrnu03P074f5xJ1bIj3ePyLf5Ftg2U5LlkJEjIfKUnC/cRSNpQncX2lPaooq
        QI3384J721LMlOm4IJi45FAc7eF048NMpUz7sMNQkSGssn6PBa5Wst1w5qYcZqKuy078c5
        6LMS9FnNc7CUoFiZ9BPfYsbjRL+aI8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-0R0f6V6_PCKTQDqRXIZhfQ-1; Thu, 17 Jun 2021 14:23:57 -0400
X-MC-Unique: 0R0f6V6_PCKTQDqRXIZhfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43D54100C619;
        Thu, 17 Jun 2021 18:23:51 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CFCF60C05;
        Thu, 17 Jun 2021 18:23:43 +0000 (UTC)
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
Subject: [PATCH v1 06/14] RDMA/i40iw: Use irq_update_affinity_hint
Date:   Thu, 17 Jun 2021 14:22:34 -0400
Message-Id: <20210617182242.8637-7-nitesh@redhat.com>
In-Reply-To: <20210617182242.8637-1-nitesh@redhat.com>
References: <20210617182242.8637-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() to update the affinity_hint mask
that is consumed by the userspace to distribute the interrupts. However,
under the hood irq_set_affinity_hint() also applies the provided cpumask
(if not NULL) as the affinity for the given interrupt which is an
undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked
as deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
that only updates the affinity_hint pointer.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index b496f30ce066..433d91c30cae 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -266,7 +266,7 @@ static void i40iw_disable_irq(struct i40iw_sc_dev *dev,
 		i40iw_wr32(dev->hw, I40E_PFINT_DYN_CTLN(msix_vec->idx - 1), 0);
 	else
 		i40iw_wr32(dev->hw, I40E_VFINT_DYN_CTLN1(msix_vec->idx - 1), 0);
-	irq_set_affinity_hint(msix_vec->irq, NULL);
+	irq_update_affinity_hint(msix_vec->irq, NULL);
 	free_irq(msix_vec->irq, dev_id);
 }
 
@@ -696,7 +696,7 @@ static enum i40iw_status_code i40iw_configure_ceq_vector(struct i40iw_device *iw
 
 	cpumask_clear(&msix_vec->mask);
 	cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
-	irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
+	irq_update_affinity_hint(msix_vec->irq, &msix_vec->mask);
 
 	if (status) {
 		i40iw_pr_err("ceq irq config fail\n");
-- 
2.27.0

