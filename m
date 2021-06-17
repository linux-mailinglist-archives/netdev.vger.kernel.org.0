Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA153ABBB4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhFQS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233497AbhFQS0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6+l1Dz4nXKaHLOIK3SgI5C3tka/WEK7p+xu1pPKipI=;
        b=gkU8kyUdLj0xw9cBvASKT5FILSBnetLhqcNxfvvx/KmksFr3/XvGgb81Kx//qGA2u/pSCR
        aR3/5BzDEQ20Qrpi2lVOwQyBXP+Vxz24jsaSyeQ9jnWN+HKzcHauUToHf/c5YtdaX+tX/C
        oEmQtSYl6/QYxo7zcNXAjXAZjC0uX3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-LKlcGSMuO0OAUVClM7-1hg-1; Thu, 17 Jun 2021 14:24:38 -0400
X-MC-Unique: LKlcGSMuO0OAUVClM7-1hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE3D8800C60;
        Thu, 17 Jun 2021 18:24:33 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C67B60C05;
        Thu, 17 Jun 2021 18:24:27 +0000 (UTC)
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
Subject: [PATCH v1 13/14] net/mlx5: Use irq_update_affinity_hint
Date:   Thu, 17 Jun 2021 14:22:41 -0400
Message-Id: <20210617182242.8637-14-nitesh@redhat.com>
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
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c3373fb1cd7f..a1b9434f4e25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -276,8 +276,8 @@ static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	cpumask_set_cpu(cpumask_local_spread(i, mdev->priv.numa_node),
 			irq->mask);
 	if (IS_ENABLED(CONFIG_SMP) &&
-	    irq_set_affinity_hint(irqn, irq->mask))
-		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x",
+	    irq_update_affinity_hint(irqn, irq->mask))
+		mlx5_core_warn(mdev, "irq_update_affinity_hint failed, irq 0x%.4x",
 			       irqn);
 
 	return 0;
@@ -291,7 +291,7 @@ static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 
 	irq = mlx5_irq_get(mdev, vecidx);
 	irqn = pci_irq_vector(mdev->pdev, vecidx);
-	irq_set_affinity_hint(irqn, NULL);
+	irq_update_affinity_hint(irqn, NULL);
 	free_cpumask_var(irq->mask);
 }
 
-- 
2.27.0

