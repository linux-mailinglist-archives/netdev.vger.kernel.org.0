Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14508351801
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhDARnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhDARjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:39:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967DAC02D57D;
        Thu,  1 Apr 2021 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=t3+j7oE4m8hHvZnx2Arcm+rr/82u0pUfHN8zF6/xR9E=; b=fJXqhckHmBh50Vl8BSqpluikrM
        wiJ/AxH4UsNpWLTsk+FoWfR5/A1qVv9HMXUBbpHrC0pcACkPigO4L7PJuy8CvOjqWv6SmogpUAmz2
        B2tFOZ6NmYjiTx8uT8/Or2JY3+OStVKRal6Yp2jzGhjvwvEfyg+TDmkwl45zdceRAvKXfJHRzuHvJ
        6nbjpVmHbEC8W90MlbJUDAAqqMI2S7x1kNPqPfW66UFsR5UJ0Zztne5MYmKkJBuj3ky3qTr+ESE98
        jPT47D2Wr84u3SHsw16K683UOjQ2YZ7QaNwaTvyjnNNz+7kZHAAndU3rnHuC7LrOHGQeFtq3tw3I5
        3+muvjpQ==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzdx-00Cifc-0g; Thu, 01 Apr 2021 15:54:01 +0000
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
Subject: [PATCH 19/20] iommu: remove DOMAIN_ATTR_IO_PGTABLE_CFG
Date:   Thu,  1 Apr 2021 17:52:55 +0200
Message-Id: <20210401155256.298656-20-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an explicit set_pgtable_quirks method instead that just passes
the actual quirk bitmask instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c |  5 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c   | 64 +++++--------------------
 drivers/iommu/arm/arm-smmu/arm-smmu.h   |  2 +-
 drivers/iommu/iommu.c                   | 11 +++++
 include/linux/io-pgtable.h              |  4 --
 include/linux/iommu.h                   | 12 ++++-
 6 files changed, 35 insertions(+), 63 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 0f184c3dd9d9ec..4a0b14dad93e2e 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -188,10 +188,7 @@ int adreno_zap_shader_load(struct msm_gpu *gpu, u32 pasid)
 
 void adreno_set_llc_attributes(struct iommu_domain *iommu)
 {
-	struct io_pgtable_domain_attr pgtbl_cfg;
-
-	pgtbl_cfg.quirks = IO_PGTABLE_QUIRK_ARM_OUTER_WBWA;
-	iommu_domain_set_attr(iommu, DOMAIN_ATTR_IO_PGTABLE_CFG, &pgtbl_cfg);
+	iommu_set_pgtable_quirks(iommu, IO_PGTABLE_QUIRK_ARM_OUTER_WBWA);
 }
 
 struct msm_gem_address_space *
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index f17c54a76ef6f1..3c6adcdb201bb8 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -770,8 +770,8 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
 			goto out_clear_smmu;
 	}
 
-	if (smmu_domain->pgtbl_cfg.quirks)
-		pgtbl_cfg.quirks |= smmu_domain->pgtbl_cfg.quirks;
+	if (smmu_domain->pgtbl_quirks)
+		pgtbl_cfg.quirks |= smmu_domain->pgtbl_quirks;
 
 	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
 	if (!pgtbl_ops) {
@@ -1484,29 +1484,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr, void *data)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-
-	switch(domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		switch (attr) {
-		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
-			struct io_pgtable_domain_attr *pgtbl_cfg = data;
-			*pgtbl_cfg = smmu_domain->pgtbl_cfg;
-
-			return 0;
-		}
-		default:
-			return -ENODEV;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -1522,37 +1499,19 @@ static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 	return ret;
 }
 
-static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr, void *data)
+static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
+		unsigned long quirks)
 {
-	int ret = 0;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	int ret = 0;
 
 	mutex_lock(&smmu_domain->init_mutex);
-
-	switch(domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		switch (attr) {
-		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
-			struct io_pgtable_domain_attr *pgtbl_cfg = data;
-
-			if (smmu_domain->smmu) {
-				ret = -EPERM;
-				goto out_unlock;
-			}
-
-			smmu_domain->pgtbl_cfg = *pgtbl_cfg;
-			break;
-		}
-		default:
-			ret = -ENODEV;
-		}
-		break;
-	default:
-		ret = -EINVAL;
-	}
-out_unlock:
+	if (smmu_domain->smmu)
+		ret = -EPERM;
+	else
+		smmu_domain->pgtbl_quirks = quirks;
 	mutex_unlock(&smmu_domain->init_mutex);
+
 	return ret;
 }
 
@@ -1611,9 +1570,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-	.domain_get_attr	= arm_smmu_domain_get_attr,
-	.domain_set_attr	= arm_smmu_domain_set_attr,
 	.enable_nesting		= arm_smmu_enable_nesting,
+	.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.h b/drivers/iommu/arm/arm-smmu/arm-smmu.h
index d2a2d1bc58bad8..c31a59d35c64da 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.h
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.h
@@ -364,7 +364,7 @@ enum arm_smmu_domain_stage {
 struct arm_smmu_domain {
 	struct arm_smmu_device		*smmu;
 	struct io_pgtable_ops		*pgtbl_ops;
-	struct io_pgtable_domain_attr	pgtbl_cfg;
+	unsigned long			pgtbl_quirks;
 	const struct iommu_flush_ops	*flush_ops;
 	struct arm_smmu_cfg		cfg;
 	enum arm_smmu_domain_stage	stage;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d191e4a399785d..bf7dcd2fc08643 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2701,6 +2701,17 @@ int iommu_enable_nesting(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_enable_nesting);
 
+int iommu_set_pgtable_quirks(struct iommu_domain *domain,
+		unsigned long quirk)
+{
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+	if (!domain->ops->set_pgtable_quirks)
+		return -EINVAL;
+	return domain->ops->set_pgtable_quirks(domain, quirk);
+}
+EXPORT_SYMBOL_GPL(iommu_set_pgtable_quirks);
+
 void iommu_get_resv_regions(struct device *dev, struct list_head *list)
 {
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index a4c9ca2c31f10a..4d40dfa75b55fe 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -204,10 +204,6 @@ struct io_pgtable {
 
 #define io_pgtable_ops_to_pgtable(x) container_of((x), struct io_pgtable, ops)
 
-struct io_pgtable_domain_attr {
-	unsigned long quirks;
-};
-
 static inline void io_pgtable_tlb_flush_all(struct io_pgtable *iop)
 {
 	if (iop->cfg.tlb && iop->cfg.tlb->tlb_flush_all)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4e1051dd8d9946..4280be90a27956 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,7 +107,6 @@ enum iommu_cap {
  */
 
 enum iommu_attr {
-	DOMAIN_ATTR_IO_PGTABLE_CFG,
 	DOMAIN_ATTR_MAX,
 };
 
@@ -195,6 +194,7 @@ struct iommu_iotlb_gather {
  * @domain_get_attr: Query domain attributes
  * @domain_set_attr: Change domain attributes
  * @enable_nesting: Enable nesting
+ * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @get_resv_regions: Request list of reserved regions for a device
  * @put_resv_regions: Free list of reserved regions for a device
  * @apply_resv_region: Temporary helper call-back for iova reserved ranges
@@ -248,6 +248,8 @@ struct iommu_ops {
 	int (*domain_set_attr)(struct iommu_domain *domain,
 			       enum iommu_attr attr, void *data);
 	int (*enable_nesting)(struct iommu_domain *domain);
+	int (*set_pgtable_quirks)(struct iommu_domain *domain,
+				  unsigned long quirks);
 
 	/* Request/Free a list of reserved regions for a device */
 	void (*get_resv_regions)(struct device *dev, struct list_head *list);
@@ -496,6 +498,8 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 int iommu_enable_nesting(struct iommu_domain *domain);
+int iommu_set_pgtable_quirks(struct iommu_domain *domain,
+		unsigned long quirks);
 
 void iommu_set_dma_strict(bool val);
 bool iommu_get_dma_strict(struct iommu_domain *domain);
@@ -877,6 +881,12 @@ static inline int iommu_domain_set_attr(struct iommu_domain *domain,
 	return -EINVAL;
 }
 
+static inline int iommu_set_pgtable_quirks(struct iommu_domain *domain,
+		unsigned long quirks)
+{
+	return 0;
+}
+
 static inline int  iommu_device_register(struct iommu_device *iommu)
 {
 	return -ENODEV;
-- 
2.30.1

