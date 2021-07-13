Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285083C78E7
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 23:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhGMVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49319 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236887AbhGMVUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 17:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626211036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Th3vaV2j817/WDzJbZssbF/Balmf7wt+58Irkccy28s=;
        b=AJNBWtTfanTSe+IqLEbu4oNARGR3zk8Rs3W9CWuX/ccFXLc/Zs59BdjjfNKHJMuXZ+iQY+
        3KoenGaZGVJoHPJBxGnDVQvllyGLqnWOPVbusdfkU1Dg0+rnMWAv11/+hrywEGz+Lyy3SB
        ZlTmkk0QM6S4+8IV5eZpPfCPNsezwPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-bMDFSjwRPoeKj1w7CGj0dg-1; Tue, 13 Jul 2021 17:17:14 -0400
X-MC-Unique: bMDFSjwRPoeKj1w7CGj0dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4739118414A0;
        Tue, 13 Jul 2021 21:17:09 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 970FF5D9DD;
        Tue, 13 Jul 2021 21:17:05 +0000 (UTC)
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
        ahs3@redhat.com, leonro@nvidia.com, chandrakanth.patil@broadcom.com
Subject: [PATCH v3 14/14] net/mlx4: Use irq_update_affinity_hint
Date:   Tue, 13 Jul 2021 17:15:02 -0400
Message-Id: <20210713211502.464259-15-nitesh@redhat.com>
In-Reply-To: <20210713211502.464259-1-nitesh@redhat.com>
References: <20210713211502.464259-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 9e48509ed3b2..414e390e6b48 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -244,9 +244,9 @@ static void mlx4_set_eq_affinity_hint(struct mlx4_priv *priv, int vec)
 	    cpumask_empty(eq->affinity_mask))
 		return;
 
-	hint_err = irq_set_affinity_hint(eq->irq, eq->affinity_mask);
+	hint_err = irq_update_affinity_hint(eq->irq, eq->affinity_mask);
 	if (hint_err)
-		mlx4_warn(dev, "irq_set_affinity_hint failed, err %d\n", hint_err);
+		mlx4_warn(dev, "irq_update_affinity_hint failed, err %d\n", hint_err);
 }
 #endif
 
@@ -1123,9 +1123,7 @@ static void mlx4_free_irqs(struct mlx4_dev *dev)
 	for (i = 0; i < dev->caps.num_comp_vectors + 1; ++i)
 		if (eq_table->eq[i].have_irq) {
 			free_cpumask_var(eq_table->eq[i].affinity_mask);
-#if defined(CONFIG_SMP)
-			irq_set_affinity_hint(eq_table->eq[i].irq, NULL);
-#endif
+			irq_update_affinity_hint(eq_table->eq[i].irq, NULL);
 			free_irq(eq_table->eq[i].irq, eq_table->eq + i);
 			eq_table->eq[i].have_irq = 0;
 		}
-- 
2.27.0

