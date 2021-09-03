Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1258400244
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349900AbhICP1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:27:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349883AbhICP1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630682790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlJZZ03tUx1PxwJQCyd0YU+FHfqGaKBG0WNFuJvPPDM=;
        b=Zz69YF2EfUDMIPn+XLaRWeon5+joaGSGzdkcOQCvC7nvuXHD+AA40vc5ErNmxQ/wjcR8wW
        NgyesQzjhrqqVP3x5aU4ovfxwnbzJ7ct+c4Y3ehU8IIbVznPMz5Ftth1yLOwcDbFH6YWOZ
        IrzURMZSvLQd6ZZPGBP2GFxsxd/0M3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-rf7Wxu9dPPOIr2jULio5eQ-1; Fri, 03 Sep 2021 11:26:28 -0400
X-MC-Unique: rf7Wxu9dPPOIr2jULio5eQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3940B6F301;
        Fri,  3 Sep 2021 15:26:27 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B96966F7EB;
        Fri,  3 Sep 2021 15:26:18 +0000 (UTC)
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
Subject: [PATCH v6 13/14] net/mlx5: Use irq_set_affinity_and_hint
Date:   Fri,  3 Sep 2021 11:24:29 -0400
Message-Id: <20210903152430.244937-14-nitesh@redhat.com>
In-Reply-To: <20210903152430.244937-1-nitesh@redhat.com>
References: <20210903152430.244937-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() to update the affinity_hint mask
that is consumed by the userspace to distribute the interrupts and to apply
the provided mask as the affinity for the mlx5 interrupts. However,
irq_set_affinity_hint() applying the provided cpumask as an affinity for
the interrupt is an undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked
as deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
where the provided mask needs to be applied as the affinity and
affinity_hint pointer needs to be set and replace with
irq_update_affinity_hint() where only affinity_hint needs to be updated.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c79a10b3454d..1c96d136dbac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -143,11 +143,11 @@ static void irq_release(struct mlx5_irq *irq)
 	struct mlx5_irq_pool *pool = irq->pool;
 
 	xa_erase(&pool->irqs, irq->index);
-	/* free_irq requires that affinity and rmap will be cleared
+	/* free_irq requires that affinity_hint and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
 	 */
-	irq_set_affinity_hint(irq->irqn, NULL);
+	irq_update_affinity_hint(irq->irqn, NULL);
 	free_cpumask_var(irq->mask);
 	free_irq(irq->irqn, &irq->nh);
 	kfree(irq);
@@ -306,7 +306,7 @@ static struct mlx5_irq *irq_pool_create_irq(struct mlx5_irq_pool *pool,
 	if (IS_ERR(irq))
 		return irq;
 	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
+	irq_set_affinity_and_hint(irq->irqn, irq->mask);
 	return irq;
 }
 
@@ -386,7 +386,7 @@ irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
 	if (IS_ERR(irq) || !affinity)
 		goto unlock;
 	cpumask_copy(irq->mask, affinity);
-	irq_set_affinity_hint(irq->irqn, irq->mask);
+	irq_set_affinity_and_hint(irq->irqn, irq->mask);
 unlock:
 	mutex_unlock(&pool->lock);
 	return irq;
-- 
2.27.0

