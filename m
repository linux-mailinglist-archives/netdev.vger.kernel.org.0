Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FDE30864
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaGOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:14:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:8741 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaGOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 02:14:37 -0400
Received: from localhost (r10.asicdesigners.com [10.192.194.10])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4V6EVSx004960;
        Thu, 30 May 2019 23:14:31 -0700
From:   Nirranjan Kirubaharan <nirranjan@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, vishal@chelsio.com,
        dt@chelsio.com, indranil@chelsio.com
Subject: [PATCH net-next] cxgb4: Set initial IRQ affinity hints
Date:   Thu, 30 May 2019 23:14:28 -0700
Message-Id: <1c4c78465a3f128a72c912a68ec3afcd19f206fb.1559115965.git.nirranjan@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spread initial IRQ affinity hints across the device node CPUs,
for nic queue and uld queue IRQs, to load balance and avoid all
interrupts on CPU0.

Signed-off-by: Nirranjan Kirubaharan <nirranjan@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  7 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 56 +++++++++++++++++++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c  | 21 +++++++---
 3 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 7c06e2aebc9e..52d1ca20ee06 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -880,6 +880,7 @@ struct uld_msix_info {
 	unsigned short vec;
 	char desc[IFNAMSIZ + 10];
 	unsigned int idx;
+	cpumask_var_t aff_mask;
 };
 
 struct vf_info {
@@ -940,9 +941,10 @@ struct adapter {
 	struct cxgb4_virt_res vres;
 	unsigned int swintr;
 
-	struct {
+	struct msix_info {
 		unsigned short vec;
 		char desc[IFNAMSIZ + 10];
+		cpumask_var_t aff_mask;
 	} msix_info[MAX_INGQ + 1];
 	struct uld_msix_info *msix_info_ulds; /* msix info for uld's */
 	struct uld_msix_bmap msix_bmap_ulds; /* msix bitmap for all uld */
@@ -1900,5 +1902,8 @@ int t4_set_vlan_acl(struct adapter *adap, unsigned int mbox, unsigned int vf,
 
 int cxgb4_thermal_init(struct adapter *adap);
 int cxgb4_thermal_remove(struct adapter *adap);
+int cxgb4_set_msix_aff(struct adapter *adap, unsigned short vec,
+		       cpumask_var_t aff_mask, int idx);
+void cxgb4_clear_msix_aff(unsigned short vec, cpumask_var_t aff_mask);
 
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7d7df59f9a70..46a41a02c788 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -702,9 +702,38 @@ static void name_msix_vecs(struct adapter *adap)
 	}
 }
 
+int cxgb4_set_msix_aff(struct adapter *adap, unsigned short vec,
+		       cpumask_var_t aff_mask, int idx)
+{
+	int rv;
+
+	if (!zalloc_cpumask_var(&aff_mask, GFP_KERNEL)) {
+		dev_err(adap->pdev_dev, "alloc_cpumask_var failed\n");
+		return -ENOMEM;
+	}
+
+	cpumask_set_cpu(cpumask_local_spread(idx, dev_to_node(adap->pdev_dev)),
+			aff_mask);
+
+	rv = irq_set_affinity_hint(vec, aff_mask);
+	if (rv)
+		dev_warn(adap->pdev_dev,
+			 "irq_set_affinity_hint %u failed %d\n",
+			 vec, rv);
+
+	return 0;
+}
+
+void cxgb4_clear_msix_aff(unsigned short vec, cpumask_var_t aff_mask)
+{
+	irq_set_affinity_hint(vec, NULL);
+	free_cpumask_var(aff_mask);
+}
+
 static int request_msix_queue_irqs(struct adapter *adap)
 {
 	struct sge *s = &adap->sge;
+	struct msix_info *minfo;
 	int err, ethqidx;
 	int msi_index = 2;
 
@@ -714,32 +743,43 @@ static int request_msix_queue_irqs(struct adapter *adap)
 		return err;
 
 	for_each_ethrxq(s, ethqidx) {
-		err = request_irq(adap->msix_info[msi_index].vec,
+		minfo = &adap->msix_info[msi_index];
+		err = request_irq(minfo->vec,
 				  t4_sge_intr_msix, 0,
-				  adap->msix_info[msi_index].desc,
+				  minfo->desc,
 				  &s->ethrxq[ethqidx].rspq);
 		if (err)
 			goto unwind;
+
+		cxgb4_set_msix_aff(adap, minfo->vec,
+				   minfo->aff_mask, ethqidx);
 		msi_index++;
 	}
 	return 0;
 
 unwind:
-	while (--ethqidx >= 0)
-		free_irq(adap->msix_info[--msi_index].vec,
-			 &s->ethrxq[ethqidx].rspq);
+	while (--ethqidx >= 0) {
+		--msi_index;
+		minfo = &adap->msix_info[msi_index];
+		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
+		free_irq(minfo->vec, &s->ethrxq[ethqidx].rspq);
+	}
 	free_irq(adap->msix_info[1].vec, &s->fw_evtq);
 	return err;
 }
 
 static void free_msix_queue_irqs(struct adapter *adap)
 {
-	int i, msi_index = 2;
 	struct sge *s = &adap->sge;
+	struct msix_info *minfo;
+	int i, msi_index = 2;
 
 	free_irq(adap->msix_info[1].vec, &s->fw_evtq);
-	for_each_ethrxq(s, i)
-		free_irq(adap->msix_info[msi_index++].vec, &s->ethrxq[i].rspq);
+	for_each_ethrxq(s, i) {
+		minfo = &adap->msix_info[msi_index++];
+		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
+		free_irq(minfo->vec, &s->ethrxq[i].rspq);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 6c685b920713..8d45315c71d4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -352,25 +352,32 @@ static void free_queues_uld(struct adapter *adap, unsigned int uld_type)
 request_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
+	struct uld_msix_info *minfo;
 	int err = 0;
 	unsigned int idx, bmap_idx;
 
 	for_each_uldrxq(rxq_info, idx) {
 		bmap_idx = rxq_info->msix_tbl[idx];
-		err = request_irq(adap->msix_info_ulds[bmap_idx].vec,
+		minfo = &adap->msix_info_ulds[bmap_idx];
+		err = request_irq(minfo->vec,
 				  t4_sge_intr_msix, 0,
-				  adap->msix_info_ulds[bmap_idx].desc,
+				  minfo->desc,
 				  &rxq_info->uldrxq[idx].rspq);
 		if (err)
 			goto unwind;
+
+		cxgb4_set_msix_aff(adap, minfo->vec,
+				   minfo->aff_mask, idx);
 	}
 	return 0;
+
 unwind:
 	while (idx-- > 0) {
 		bmap_idx = rxq_info->msix_tbl[idx];
+		minfo = &adap->msix_info_ulds[bmap_idx];
+		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
 		free_msix_idx_in_bmap(adap, bmap_idx);
-		free_irq(adap->msix_info_ulds[bmap_idx].vec,
-			 &rxq_info->uldrxq[idx].rspq);
+		free_irq(minfo->vec, &rxq_info->uldrxq[idx].rspq);
 	}
 	return err;
 }
@@ -379,14 +386,16 @@ static void free_queues_uld(struct adapter *adap, unsigned int uld_type)
 free_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
+	struct uld_msix_info *minfo;
 	unsigned int idx, bmap_idx;
 
 	for_each_uldrxq(rxq_info, idx) {
 		bmap_idx = rxq_info->msix_tbl[idx];
+		minfo = &adap->msix_info_ulds[bmap_idx];
 
+		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
 		free_msix_idx_in_bmap(adap, bmap_idx);
-		free_irq(adap->msix_info_ulds[bmap_idx].vec,
-			 &rxq_info->uldrxq[idx].rspq);
+		free_irq(minfo->vec, &rxq_info->uldrxq[idx].rspq);
 	}
 }
 
-- 
1.8.3.1

