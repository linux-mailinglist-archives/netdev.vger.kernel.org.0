Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C48C61447A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 07:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKAGGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 02:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiKAGGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 02:06:10 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E022F13F1C;
        Mon, 31 Oct 2022 23:06:06 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 94FAB205D3AB;
        Mon, 31 Oct 2022 23:06:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94FAB205D3AB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1667282766;
        bh=gtkRke9Of7UNDJRH6gO1HSSOTq81CvrSGszWmmhQGQs=;
        h=From:To:Subject:Date:From;
        b=Wbj56WLz2fbYuhtjtvkfXAT3L0O2p79+Gq3Nww84rlTuqU206bpsotb3z5IylJNUE
         HcLDv1Unn4XhHG8+pn6EiMLVwojI+gfJv7BC6hmAbSOqvc1dfcvhr7acCx7z1hv3w3
         r3lPO/Bd11+40weijXhjT2el+u5lOWkP+DAom/+k=
From:   Saurabh Sengar <ssengar@linux.microsoft.com>
To:     ssengar@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ssengar@linux.microsoft.com, colin.i.king@googlemail.com,
        vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com
Subject: [PATCH] net: mana: Assign interrupts to CPUs based on NUMA nodes
Date:   Mon, 31 Oct 2022 23:06:01 -0700
Message-Id: <1667282761-11547-1-git-send-email-ssengar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In large VMs with multiple NUMA nodes, network performance is usually
best if network interrupts are all assigned to the same virtual NUMA
node. This patch assigns online CPU according to a numa aware policy,
local cpus are returned first, followed by non-local ones, then it wraps
around.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |  1 +
 .../net/ethernet/microsoft/mana/gdma_main.c   | 30 +++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 4a6efe6ada08..db340f36ef29 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -353,6 +353,7 @@ struct gdma_context {
 	void __iomem		*shm_base;
 	void __iomem		*db_page_base;
 	u32 db_page_size;
+	int                     numa_node;
 
 	/* Shared memory chanenl (used to bootstrap HWC) */
 	struct shm_channel	shm_channel;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index a6f99b4344d9..726ac94d96ae 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1208,8 +1208,10 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct gdma_irq_context *gic;
 	unsigned int max_irqs;
+	u16 *cpus;
+	cpumask_var_t req_mask;
 	int nvec, irq;
-	int err, i, j;
+	int err, i = 0, j;
 
 	if (max_queues_per_port > MANA_MAX_NUM_QUEUES)
 		max_queues_per_port = MANA_MAX_NUM_QUEUES;
@@ -1228,7 +1230,21 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		goto free_irq_vector;
 	}
 
+	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL)) {
+		err = -ENOMEM;
+		goto free_irq;
+	}
+
+	cpus = kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);
+	if (!cpus) {
+		err = -ENOMEM;
+		goto free_mask;
+	}
+	for (i = 0; i < nvec; i++)
+		cpus[i] = cpumask_local_spread(i, gc->numa_node);
+
 	for (i = 0; i < nvec; i++) {
+		cpumask_set_cpu(cpus[i], req_mask);
 		gic = &gc->irq_contexts[i];
 		gic->handler = NULL;
 		gic->arg = NULL;
@@ -1236,13 +1252,17 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
-			goto free_irq;
+			goto free_mask;
 		}
 
 		err = request_irq(irq, mana_gd_intr, 0, "mana_intr", gic);
 		if (err)
-			goto free_irq;
+			goto free_mask;
+		irq_set_affinity_and_hint(irq, req_mask);
+		cpumask_clear(req_mask);
 	}
+	free_cpumask_var(req_mask);
+	kfree(cpus);
 
 	err = mana_gd_alloc_res_map(nvec, &gc->msix_resource);
 	if (err)
@@ -1253,6 +1273,9 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 
 	return 0;
 
+free_mask:
+	free_cpumask_var(req_mask);
+	kfree(cpus);
 free_irq:
 	for (j = i - 1; j >= 0; j--) {
 		irq = pci_irq_vector(pdev, j);
@@ -1382,6 +1405,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!bar0_va)
 		goto free_gc;
 
+	gc->numa_node = dev_to_node(&pdev->dev);
 	gc->is_pf = mana_is_pf(pdev->device);
 	gc->bar0_va = bar0_va;
 	gc->dev = &pdev->dev;
-- 
2.34.1

