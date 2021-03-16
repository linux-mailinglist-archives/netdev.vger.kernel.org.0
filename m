Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EED33D906
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhCPQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:19:53 -0400
Received: from casper.infradead.org ([90.155.50.34]:43394 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbhCPQTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tQSgEyq3e/24fO04sGy+yuhUuhNZG+H4P8v8m08CZO8=; b=EMRSRUM85d23bRQNbCtWms/Ov9
        +nO5obOz28orL3QyAnxxo5YGoQjKoJpInkSBrBw6Ab08Wcf7AzFwUEmYOYPry20bJxaEnMDAWfcmc
        8NTOjcXEGFDdxEVys6bfCwI+0HvrAZIkdqmU2sqF/IpMyqV17YHtmS8IY7y9so0o6GU+tTV7nKRUJ
        SBelw/K1FANplHEgl6lIWuE1Otj96xISEy/2njegWGdKy3TH1dEFuDYEjhug4e91IWGCvH3KbOznB
        rryBNOOWoZgedj0eXq2d1sxXlZBnCyeNjYcQOI2guJe3ft2hJNQ84nsul4E6TfnnWZR5Nj9PLQb/F
        ALhiuglA==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMCOp-000Imx-4h; Tue, 16 Mar 2021 16:18:30 +0000
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
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Date:   Tue, 16 Mar 2021 16:38:22 +0100
Message-Id: <20210316153825.135976-17-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

Instead make the global iommu_dma_strict paramete in iommu.c canonical by
exporting helpers to get and set it and use those directly in the drivers.

This make sure that the iommu.strict parameter also works for the AMD and
Intel IOMMU drivers on x86.  As those default to lazy flushing a new
IOMMU_CMD_LINE_STRICT is used to turn the value into a tristate to
represent the default if not overriden by an explicit parameter.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>.
[ported on top of the other iommu_attr changes and added a few small
 missing bits]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/amd/iommu.c                   | 23 +-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 50 +---------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 27 +--------
 drivers/iommu/dma-iommu.c                   |  9 +--
 drivers/iommu/intel/iommu.c                 | 64 ++++-----------------
 drivers/iommu/iommu.c                       | 27 ++++++---
 include/linux/iommu.h                       |  4 +-
 8 files changed, 40 insertions(+), 165 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a69a8b573e40d0..ce6393d2224d86 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1771,26 +1771,6 @@ static struct iommu_group *amd_iommu_device_group(struct device *dev)
 	return acpihid_device_group(dev);
 }
 
-static int amd_iommu_domain_get_attr(struct iommu_domain *domain,
-		enum iommu_attr attr, void *data)
-{
-	switch (domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		return -ENODEV;
-	case IOMMU_DOMAIN_DMA:
-		switch (attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = !amd_iommu_unmap_flush;
-			return 0;
-		default:
-			return -ENODEV;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-}
-
 /*****************************************************************************
  *
  * The next functions belong to the dma_ops mapping/unmapping code.
@@ -1855,7 +1835,7 @@ int __init amd_iommu_init_dma_ops(void)
 		pr_info("IO/TLB flush on unmap enabled\n");
 	else
 		pr_info("Lazy IO/TLB flushing enabled\n");
-
+	iommu_set_dma_strict(amd_iommu_unmap_flush);
 	return 0;
 
 }
@@ -2257,7 +2237,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.release_device = amd_iommu_release_device,
 	.probe_finalize = amd_iommu_probe_finalize,
 	.device_group = amd_iommu_device_group,
-	.domain_get_attr = amd_iommu_domain_get_attr,
 	.get_resv_regions = amd_iommu_get_resv_regions,
 	.put_resv_regions = generic_iommu_put_resv_regions,
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f1e38526d5bd40..996dfdf9d375dd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2017,7 +2017,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		.iommu_dev	= smmu->dev,
 	};
 
-	if (smmu_domain->non_strict)
+	if (!iommu_get_dma_strict())
 		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
 
 	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
@@ -2449,52 +2449,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr, void *data)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-
-	switch (domain->type) {
-	case IOMMU_DOMAIN_DMA:
-		switch (attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = smmu_domain->non_strict;
-			return 0;
-		default:
-			return -ENODEV;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-}
-
-static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr, void *data)
-{
-	int ret = 0;
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-
-	mutex_lock(&smmu_domain->init_mutex);
-
-	switch (domain->type) {
-	case IOMMU_DOMAIN_DMA:
-		switch(attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			smmu_domain->non_strict = *(int *)data;
-			break;
-		default:
-			ret = -ENODEV;
-		}
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	mutex_unlock(&smmu_domain->init_mutex);
-	return ret;
-}
-
 static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2607,8 +2561,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-	.domain_get_attr	= arm_smmu_domain_get_attr,
-	.domain_set_attr	= arm_smmu_domain_set_attr,
 	.enable_nesting		= arm_smmu_enable_nesting,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f985817c967a25..edb1de479dd1a7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -668,7 +668,6 @@ struct arm_smmu_domain {
 	struct mutex			init_mutex; /* Protects smmu pointer */
 
 	struct io_pgtable_ops		*pgtbl_ops;
-	bool				non_strict;
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 0aa6d667274970..3dde22b1f8ffb0 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -761,6 +761,9 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
 		.iommu_dev	= smmu->dev,
 	};
 
+	if (!iommu_get_dma_strict())
+		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
+
 	if (smmu->impl && smmu->impl->init_context) {
 		ret = smmu->impl->init_context(smmu_domain, &pgtbl_cfg, dev);
 		if (ret)
@@ -1499,18 +1502,6 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 			return -ENODEV;
 		}
 		break;
-	case IOMMU_DOMAIN_DMA:
-		switch (attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE: {
-			bool non_strict = smmu_domain->pgtbl_cfg.quirks &
-					  IO_PGTABLE_QUIRK_NON_STRICT;
-			*(int *)data = non_strict;
-			return 0;
-		}
-		default:
-			return -ENODEV;
-		}
-		break;
 	default:
 		return -EINVAL;
 	}
@@ -1557,18 +1548,6 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 			ret = -ENODEV;
 		}
 		break;
-	case IOMMU_DOMAIN_DMA:
-		switch (attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			if (*(int *)data)
-				smmu_domain->pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
-			else
-				smmu_domain->pgtbl_cfg.quirks &= ~IO_PGTABLE_QUIRK_NON_STRICT;
-			break;
-		default:
-			ret = -ENODEV;
-		}
-		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index af765c813cc84c..49cec03dec3dd2 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -304,10 +304,7 @@ static void iommu_dma_flush_iotlb_all(struct iova_domain *iovad)
 
 	cookie = container_of(iovad, struct iommu_dma_cookie, iovad);
 	domain = cookie->fq_domain;
-	/*
-	 * The IOMMU driver supporting DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
-	 * implies that ops->flush_iotlb_all must be non-NULL.
-	 */
+
 	domain->ops->flush_iotlb_all(domain);
 }
 
@@ -334,7 +331,6 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	unsigned long order, base_pfn;
 	struct iova_domain *iovad;
-	int attr;
 
 	if (!cookie || cookie->type != IOMMU_DMA_IOVA_COOKIE)
 		return -EINVAL;
@@ -371,8 +367,7 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 	init_iova_domain(iovad, 1UL << order, base_pfn);
 
 	if (!cookie->fq_domain && (!dev || !dev_is_untrusted(dev)) &&
-	    !iommu_domain_get_attr(domain, DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) &&
-	    attr) {
+	    domain->ops->flush_iotlb_all && !iommu_get_dma_strict()) {
 		if (init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
 					  iommu_dma_entry_dtor))
 			pr_warn("iova flush queue initialization failed\n");
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 070ba76242e819..5b00adfb7212a7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4377,6 +4377,17 @@ int __init intel_iommu_init(void)
 
 	down_read(&dmar_global_lock);
 	for_each_active_iommu(iommu, drhd) {
+		/*
+		 * The flush queue implementation does not perform
+		 * page-selective invalidations that are required for efficient
+		 * TLB flushes in virtual environments.  The benefit of batching
+		 * is likely to be much lower than the overhead of synchronizing
+		 * the virtual and physical IOMMU page-tables.
+		 */
+		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
+			pr_warn("IOMMU batching is disabled due to virtualization");
+			intel_iommu_strict = 1;
+		}
 		iommu_device_sysfs_add(&iommu->iommu, NULL,
 				       intel_iommu_groups,
 				       "%s", iommu->name);
@@ -4385,6 +4396,7 @@ int __init intel_iommu_init(void)
 	}
 	up_read(&dmar_global_lock);
 
+	iommu_set_dma_strict(intel_iommu_strict);
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 	if (si_domain && !hw_pass_through)
 		register_memory_notifier(&intel_iommu_memory_nb);
@@ -5440,57 +5452,6 @@ intel_iommu_enable_nesting(struct iommu_domain *domain)
 	return ret;
 }
 
-static bool domain_use_flush_queue(void)
-{
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-	bool r = true;
-
-	if (intel_iommu_strict)
-		return false;
-
-	/*
-	 * The flush queue implementation does not perform page-selective
-	 * invalidations that are required for efficient TLB flushes in virtual
-	 * environments. The benefit of batching is likely to be much lower than
-	 * the overhead of synchronizing the virtual and physical IOMMU
-	 * page-tables.
-	 */
-	rcu_read_lock();
-	for_each_active_iommu(iommu, drhd) {
-		if (!cap_caching_mode(iommu->cap))
-			continue;
-
-		pr_warn_once("IOMMU batching is disabled due to virtualization");
-		r = false;
-		break;
-	}
-	rcu_read_unlock();
-
-	return r;
-}
-
-static int
-intel_iommu_domain_get_attr(struct iommu_domain *domain,
-			    enum iommu_attr attr, void *data)
-{
-	switch (domain->type) {
-	case IOMMU_DOMAIN_UNMANAGED:
-		return -ENODEV;
-	case IOMMU_DOMAIN_DMA:
-		switch (attr) {
-		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = domain_use_flush_queue();
-			return 0;
-		default:
-			return -ENODEV;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-}
-
 /*
  * Check that the device does not live on an external facing PCI port that is
  * marked as untrusted. Such devices should not be able to apply quirks and
@@ -5563,7 +5524,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_free		= intel_iommu_domain_free,
-	.domain_get_attr        = intel_iommu_domain_get_attr,
 	.enable_nesting		= intel_iommu_enable_nesting,
 	.attach_dev		= intel_iommu_attach_device,
 	.detach_dev		= intel_iommu_detach_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 052cef11ae30df..e193ea88f3f842 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -69,6 +69,7 @@ static const char * const iommu_group_resv_type_string[] = {
 };
 
 #define IOMMU_CMD_LINE_DMA_API		BIT(0)
+#define IOMMU_CMD_LINE_STRICT		BIT(1)
 
 static int iommu_alloc_default_domain(struct iommu_group *group,
 				      struct device *dev);
@@ -318,10 +319,26 @@ early_param("iommu.passthrough", iommu_set_def_domain_type);
 
 static int __init iommu_dma_setup(char *str)
 {
-	return kstrtobool(str, &iommu_dma_strict);
+	int ret = kstrtobool(str, &iommu_dma_strict);
+
+	if (!ret)
+		iommu_cmd_line |= IOMMU_CMD_LINE_STRICT;
+	return ret;
 }
 early_param("iommu.strict", iommu_dma_setup);
 
+void iommu_set_dma_strict(bool strict)
+{
+	if (strict || !(iommu_cmd_line & IOMMU_CMD_LINE_STRICT))
+		iommu_dma_strict = strict;
+}
+
+bool iommu_get_dma_strict(void)
+{
+	return iommu_dma_strict;
+}
+EXPORT_SYMBOL_GPL(iommu_get_dma_strict);
+
 static ssize_t iommu_group_attr_show(struct kobject *kobj,
 				     struct attribute *__attr, char *buf)
 {
@@ -1500,14 +1517,6 @@ static int iommu_group_alloc_default_domain(struct bus_type *bus,
 	group->default_domain = dom;
 	if (!group->domain)
 		group->domain = dom;
-
-	if (!iommu_dma_strict) {
-		int attr = 1;
-		iommu_domain_set_attr(dom,
-				      DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
-				      &attr);
-	}
-
 	return 0;
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 670e7a3523f286..3d50ecf3a49c24 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,7 +107,6 @@ enum iommu_cap {
  */
 
 enum iommu_attr {
-	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
 	DOMAIN_ATTR_MAX,
 };
@@ -498,6 +497,9 @@ extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 int iommu_enable_nesting(struct iommu_domain *domain);
 
+void iommu_set_dma_strict(bool val);
+bool iommu_get_dma_strict(void);
+
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
 
-- 
2.30.1

