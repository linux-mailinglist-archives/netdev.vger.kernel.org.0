Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6778327A08
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhCAIxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhCAIts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:49:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FECFC061793;
        Mon,  1 Mar 2021 00:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bD29qdrhzRiITERPobenMjk3BMUizVOAgg7QS9JRwSM=; b=NSOkLMzI6zbyZQStLSNZkvPOPO
        UpWPJvXUzIA++EvwUMyqjpJFjGY6OygYi+ZSTKaMQ1KAIniM/5Uj/sR8K0JtCtxb+2QmkBNd9J/iR
        GYrvDiwGiqVELHyIbKz0OF+FoaKrrlSQkt/YnfUsrteo4uk756KkL9YZKPfaHghOFcz9YCmSwSJTM
        zYKJvJQsPu8djPSHyVybeJHvqZqgs+rcxt34NB52YgLEwTJtxsFMvlnKOeElSs8HRyeIzqyx326kb
        JrN6I8XymRALbzHGv5NUP/WOJMAundfmHMi0mzu6G8YEinmahYOBwzm9S2kIBFT2M7ZFXqwwKDxZI
        GNsA3T8w==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeE4-00FUv9-FI; Mon, 01 Mar 2021 08:48:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
Date:   Mon,  1 Mar 2021 09:42:55 +0100
Message-Id: <20210301084257.945454-16-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 40 ++++++---------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 30 ++++++++++------
 drivers/iommu/intel/iommu.c                 | 28 +++++----------
 drivers/iommu/iommu.c                       |  8 +++++
 drivers/vfio/vfio_iommu_type1.c             |  5 +--
 include/linux/iommu.h                       |  4 ++-
 6 files changed, 50 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bf96172e8c1f71..8e6fee3ea454d3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2466,41 +2466,21 @@ static void arm_smmu_dma_enable_flush_queue(struct iommu_domain *domain)
 	to_smmu_domain(domain)->non_strict = true;
 }
 
-static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr, void *data)
+static int arm_smmu_domain_enable_nesting(struct iommu_domain *domain)
 {
-	int ret = 0;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	int ret = -EPERM;
 
-	mutex_lock(&smmu_domain->init_mutex);
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
 
-	switch (domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		switch (attr) {
-		case DOMAIN_ATTR_NESTING:
-			if (smmu_domain->smmu) {
-				ret = -EPERM;
-				goto out_unlock;
-			}
-
-			if (*(int *)data)
-				smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-			else
-				smmu_domain->stage = ARM_SMMU_DOMAIN_S1;
-			break;
-		default:
-			ret = -ENODEV;
-		}
-		break;
-	case IOMMU_DOMAIN_DMA:
-		ret = -ENODEV;
-		break;
-	default:
-		ret = -EINVAL;
+	mutex_lock(&smmu_domain->init_mutex);
+	if (!smmu_domain->smmu) {
+		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
+		ret = 0;
 	}
-
-out_unlock:
 	mutex_unlock(&smmu_domain->init_mutex);
+
 	return ret;
 }
 
@@ -2603,7 +2583,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.device_group		= arm_smmu_device_group,
 	.dma_use_flush_queue	= arm_smmu_dma_use_flush_queue,
 	.dma_enable_flush_queue	= arm_smmu_dma_enable_flush_queue,
-	.domain_set_attr	= arm_smmu_domain_set_attr,
+	.domain_enable_nesting	= arm_smmu_domain_enable_nesting,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index e7893e96f5177a..2e17d990d04481 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1497,6 +1497,24 @@ static void arm_smmu_dma_enable_flush_queue(struct iommu_domain *domain)
 	to_smmu_domain(domain)->pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
 }
 
+static int arm_smmu_domain_enable_nesting(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	int ret = -EPERM;
+	
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (!smmu_domain->smmu) {
+		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
+		ret = 0;
+	}
+	mutex_unlock(&smmu_domain->init_mutex);
+
+	return ret;
+}
+
 static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -1508,17 +1526,6 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 	switch(domain->type) {
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
-		case DOMAIN_ATTR_NESTING:
-			if (smmu_domain->smmu) {
-				ret = -EPERM;
-				goto out_unlock;
-			}
-
-			if (*(int *)data)
-				smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-			else
-				smmu_domain->stage = ARM_SMMU_DOMAIN_S1;
-			break;
 		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
 			struct io_pgtable_domain_attr *pgtbl_cfg = data;
 
@@ -1603,6 +1610,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.dma_use_flush_queue	= arm_smmu_dma_use_flush_queue,
 	.dma_enable_flush_queue	= arm_smmu_dma_enable_flush_queue,
 	.domain_set_attr	= arm_smmu_domain_set_attr,
+	.domain_enable_nesting	= arm_smmu_domain_enable_nesting,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index eaa80c33f4bc91..0f1374d6612a60 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5423,32 +5423,22 @@ static bool intel_iommu_is_attach_deferred(struct iommu_domain *domain,
 }
 
 static int
-intel_iommu_domain_set_attr(struct iommu_domain *domain,
-			    enum iommu_attr attr, void *data)
+intel_iommu_domain_enable_nesting(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	unsigned long flags;
-	int ret = 0;
+	int ret = -ENODEV;
 
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
 
-	switch (attr) {
-	case DOMAIN_ATTR_NESTING:
-		spin_lock_irqsave(&device_domain_lock, flags);
-		if (nested_mode_support() &&
-		    list_empty(&dmar_domain->devices)) {
-			dmar_domain->flags |= DOMAIN_FLAG_NESTING_MODE;
-			dmar_domain->flags &= ~DOMAIN_FLAG_USE_FIRST_LEVEL;
-		} else {
-			ret = -ENODEV;
-		}
-		spin_unlock_irqrestore(&device_domain_lock, flags);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+	spin_lock_irqsave(&device_domain_lock, flags);
+	if (nested_mode_support() && list_empty(&dmar_domain->devices)) {
+		dmar_domain->flags |= DOMAIN_FLAG_NESTING_MODE;
+		dmar_domain->flags &= ~DOMAIN_FLAG_USE_FIRST_LEVEL;
+		ret = 0;
 	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	return ret;
 }
@@ -5556,7 +5546,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
 	.dma_use_flush_queue	= intel_iommu_dma_use_flush_queue,
-	.domain_set_attr	= intel_iommu_domain_set_attr,
+	.domain_enable_nesting	= intel_iommu_domain_enable_nesting,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
 	.aux_attach_dev		= intel_iommu_aux_attach_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0f12c4d58cdc42..2e9e058501a953 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2685,6 +2685,14 @@ int iommu_domain_set_attr(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
 
+int iommu_domain_enable_nesting(struct iommu_domain *domain)
+{
+	if (!domain->ops->domain_enable_nesting)
+		return -EINVAL;
+	return domain->ops->domain_enable_nesting(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_enable_nesting);
+
 void iommu_get_resv_regions(struct device *dev, struct list_head *list)
 {
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c8e57f22f421c5..9cea4d80dd66ed 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2320,10 +2320,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	if (iommu->nesting) {
-		int attr = 1;
-
-		ret = iommu_domain_set_attr(domain->domain, DOMAIN_ATTR_NESTING,
-					    &attr);
+		ret = iommu_domain_enable_nesting(domain->domain);
 		if (ret)
 			goto out_domain;
 	}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f30de33c6ff56e..aed88aa3bd3edf 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,7 +107,6 @@ enum iommu_cap {
  */
 
 enum iommu_attr {
-	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
 	DOMAIN_ATTR_MAX,
 };
@@ -196,6 +195,7 @@ struct iommu_iotlb_gather {
  * @dma_use_flush_queue: Returns %true if a DMA flush queue is used
  * @dma_enable_flush_queue: Try to enable the DMA flush queue
  * @domain_set_attr: Change domain attributes
+ * @domain_enable_nesting: Enable nesting
  * @get_resv_regions: Request list of reserved regions for a device
  * @put_resv_regions: Free list of reserved regions for a device
  * @apply_resv_region: Temporary helper call-back for iova reserved ranges
@@ -248,6 +248,7 @@ struct iommu_ops {
 	void (*dma_enable_flush_queue)(struct iommu_domain *domain);
 	int (*domain_set_attr)(struct iommu_domain *domain,
 			       enum iommu_attr attr, void *data);
+	int (*domain_enable_nesting)(struct iommu_domain *domain);
 
 	/* Request/Free a list of reserved regions for a device */
 	void (*get_resv_regions)(struct device *dev, struct list_head *list);
@@ -494,6 +495,7 @@ extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 bool iommu_dma_use_flush_queue(struct iommu_domain *domain);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+int iommu_domain_enable_nesting(struct iommu_domain *domain);
 
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
-- 
2.29.2

