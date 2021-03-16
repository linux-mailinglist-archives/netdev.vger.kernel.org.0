Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6217233D8E2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbhCPQPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:15:03 -0400
Received: from casper.infradead.org ([90.155.50.34]:41994 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbhCPQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hWgOGEWBNgjWOFYRD+L4rHLGPWPrf1+D7OQXUxeyHwE=; b=XTYc8X/NOkg7j5/J2oc0CRMPSw
        k85Tffx7zg4OnAYUH+pjptNV+pAnwgzn3jZcQxSH6mGX3+GShXMAfhB9mABF/Z7IyrSNrtQdGv6U6
        26/cK2fjbSU8T9jT9ZUekCVkM//2kem+vEl4gzLPqe9vO/7/onZzVKABaRyhaJGPhQaGIHlO/jPeQ
        8xNDrEwAOVzxTYGRV1OdlGErR+0f0dRbULgCZ1J2ecOyNO4FYVkCuwTri8XT7gC+mS9lSK8JXzooP
        IltwJWxxqrqnAOtp3iqaINR82GWKI6eo/WYUXb7za8TYh2TYk58dKF2dURHGhexE9dJs3VlQZoRCo
        VVkm4RpQ==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMCKP-000IBx-LN; Tue, 16 Mar 2021 16:13:54 +0000
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
Subject: [PATCH 14/18] iommu: remove DOMAIN_ATTR_NESTING
Date:   Tue, 16 Mar 2021 16:38:20 +0100
Message-Id: <20210316153825.135976-15-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an explicit enable_nesting method instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 43 ++++++++-------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 30 +++++++-------
 drivers/iommu/intel/iommu.c                 | 31 +++++----------
 drivers/iommu/iommu.c                       | 10 +++++
 drivers/vfio/vfio_iommu_type1.c             |  5 +--
 include/linux/iommu.h                       |  4 +-
 6 files changed, 55 insertions(+), 68 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8594b4a8304375..f1e38526d5bd40 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2455,15 +2455,6 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	switch (domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		switch (attr) {
-		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
-		default:
-			return -ENODEV;
-		}
-		break;
 	case IOMMU_DOMAIN_DMA:
 		switch (attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
@@ -2487,23 +2478,6 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 	mutex_lock(&smmu_domain->init_mutex);
 
 	switch (domain->type) {
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
 	case IOMMU_DOMAIN_DMA:
 		switch(attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
@@ -2517,11 +2491,25 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 		ret = -EINVAL;
 	}
 
-out_unlock:
 	mutex_unlock(&smmu_domain->init_mutex);
 	return ret;
 }
 
+static int arm_smmu_enable_nesting(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	int ret = 0;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (smmu_domain->smmu)
+		ret = -EPERM;
+	else
+		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
+	mutex_unlock(&smmu_domain->init_mutex);
+
+	return ret;
+}
+
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2621,6 +2609,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.device_group		= arm_smmu_device_group,
 	.domain_get_attr	= arm_smmu_domain_get_attr,
 	.domain_set_attr	= arm_smmu_domain_set_attr,
+	.enable_nesting		= arm_smmu_enable_nesting,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index d8c6bfde6a6158..0aa6d667274970 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1489,9 +1489,6 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	switch(domain->type) {
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
-		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
 		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
 			struct io_pgtable_domain_attr *pgtbl_cfg = data;
 			*pgtbl_cfg = smmu_domain->pgtbl_cfg;
@@ -1519,6 +1516,21 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	}
 }
 
+static int arm_smmu_enable_nesting(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	int ret = 0;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (smmu_domain->smmu)
+		ret = -EPERM;
+	else
+		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
+	mutex_unlock(&smmu_domain->init_mutex);
+
+	return ret;
+}
+
 static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -1530,17 +1542,6 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
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
 
@@ -1633,6 +1634,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.device_group		= arm_smmu_device_group,
 	.domain_get_attr	= arm_smmu_domain_get_attr,
 	.domain_set_attr	= arm_smmu_domain_set_attr,
+	.enable_nesting		= arm_smmu_enable_nesting,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= generic_iommu_put_resv_regions,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ee0932307d646b..070ba76242e819 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5423,32 +5423,19 @@ static bool intel_iommu_is_attach_deferred(struct iommu_domain *domain,
 }
 
 static int
-intel_iommu_domain_set_attr(struct iommu_domain *domain,
-			    enum iommu_attr attr, void *data)
+intel_iommu_enable_nesting(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	unsigned long flags;
-	int ret = 0;
-
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
+	int ret = -ENODEV;
 
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
@@ -5577,7 +5564,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
 	.domain_get_attr        = intel_iommu_domain_get_attr,
-	.domain_set_attr	= intel_iommu_domain_set_attr,
+	.enable_nesting		= intel_iommu_enable_nesting,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
 	.aux_attach_dev		= intel_iommu_aux_attach_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 23daaea7883b75..58d1d11a8d5c10 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2690,6 +2690,16 @@ int iommu_domain_set_attr(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
 
+int iommu_enable_nesting(struct iommu_domain *domain)
+{
+	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
+		return -EINVAL;
+	if (!domain->ops->enable_nesting)
+		return -EINVAL;
+	return domain->ops->enable_nesting(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_enable_nesting);
+
 void iommu_get_resv_regions(struct device *dev, struct list_head *list)
 {
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c8e57f22f421c5..1201482e6eec6f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2320,10 +2320,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	if (iommu->nesting) {
-		int attr = 1;
-
-		ret = iommu_domain_set_attr(domain->domain, DOMAIN_ATTR_NESTING,
-					    &attr);
+		ret = iommu_enable_nesting(domain->domain);
 		if (ret)
 			goto out_domain;
 	}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c15a8658daad64..670e7a3523f286 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,7 +107,6 @@ enum iommu_cap {
  */
 
 enum iommu_attr {
-	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
 	DOMAIN_ATTR_MAX,
@@ -196,6 +195,7 @@ struct iommu_iotlb_gather {
  * @device_group: find iommu group for a particular device
  * @domain_get_attr: Query domain attributes
  * @domain_set_attr: Change domain attributes
+ * @enable_nesting: Enable nesting
  * @get_resv_regions: Request list of reserved regions for a device
  * @put_resv_regions: Free list of reserved regions for a device
  * @apply_resv_region: Temporary helper call-back for iova reserved ranges
@@ -248,6 +248,7 @@ struct iommu_ops {
 			       enum iommu_attr attr, void *data);
 	int (*domain_set_attr)(struct iommu_domain *domain,
 			       enum iommu_attr attr, void *data);
+	int (*enable_nesting)(struct iommu_domain *domain);
 
 	/* Request/Free a list of reserved regions for a device */
 	void (*get_resv_regions)(struct device *dev, struct list_head *list);
@@ -495,6 +496,7 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+int iommu_enable_nesting(struct iommu_domain *domain);
 
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
-- 
2.30.1

