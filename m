Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BF2351B51
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhDASHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbhDASBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:01:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D174C02D57E;
        Thu,  1 Apr 2021 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=a335jwrDQUCIDB0PLMT4Bi0PLGtfSsidoCsV+7NPZSw=; b=Jm4YM1cgbTXujlbOs7gh/YkZXl
        6bHE0FEMAACZyycfzai0Zrl9+34hJNJ67gIyXK6JRT4CXiC62BEJ2u2Xf5O4f/eNl7ZE/T637Sbun
        uOUfGXy7AIV7WWuJoeUBV2LiYRJY6Mq9NDnszI/oN2JzrfKLoXx7xfQMPP4vcQyOgL8CGEM7RkxRG
        snKrJrSiL7ptfKsi0YkiCGWY6qgPobaUY8VNpCHXIzWi0WsxI2lhQmG99snBIuHusV0CsysNNhLBt
        lsb8XMDH5z+8/aFy4jA0asAUu/C66IyIflLuP+uOGzWvUK2BmVRRLIFBdcJULD3dwH9DzQUNx6T2C
        UteOvdqg==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzdz-00Cifp-Mc; Thu, 01 Apr 2021 15:54:04 +0000
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
Subject: [PATCH 20/20] iommu: remove iommu_domain_{get,set}_attr
Date:   Thu,  1 Apr 2021 17:52:56 +0200
Message-Id: <20210401155256.298656-21-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the now unused iommu attr infrastructure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Will Deacon <will@kernel.org>
---
 drivers/iommu/iommu.c | 26 --------------------------
 include/linux/iommu.h | 36 ------------------------------------
 2 files changed, 62 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bf7dcd2fc08643..d19944733b9dac 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2665,32 +2665,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_domain_get_attr(struct iommu_domain *domain,
-			  enum iommu_attr attr, void *data)
-{
-	if (!domain->ops->domain_get_attr)
-		return -EINVAL;
-	return domain->ops->domain_get_attr(domain, attr, data);
-}
-EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
-
-int iommu_domain_set_attr(struct iommu_domain *domain,
-			  enum iommu_attr attr, void *data)
-{
-	int ret = 0;
-
-	switch (attr) {
-	default:
-		if (domain->ops->domain_set_attr == NULL)
-			return -EINVAL;
-
-		ret = domain->ops->domain_set_attr(domain, attr, data);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
-
 int iommu_enable_nesting(struct iommu_domain *domain)
 {
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4280be90a27956..1a905446dc4ca1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -96,20 +96,6 @@ enum iommu_cap {
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 };
 
-/*
- * Following constraints are specifc to FSL_PAMUV1:
- *  -aperture must be power of 2, and naturally aligned
- *  -number of windows must be power of 2, and address space size
- *   of each window is determined by aperture size / # of windows
- *  -the actual size of the mapped region of a window must be power
- *   of 2 starting with 4KB and physical address must be naturally
- *   aligned.
- */
-
-enum iommu_attr {
-	DOMAIN_ATTR_MAX,
-};
-
 /* These are the possible reserved region types */
 enum iommu_resv_type {
 	/* Memory regions which must be mapped 1:1 at all times */
@@ -191,8 +177,6 @@ struct iommu_iotlb_gather {
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
  *                  group and attached to the groups domain
  * @device_group: find iommu group for a particular device
- * @domain_get_attr: Query domain attributes
- * @domain_set_attr: Change domain attributes
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @get_resv_regions: Request list of reserved regions for a device
@@ -243,10 +227,6 @@ struct iommu_ops {
 	void (*release_device)(struct device *dev);
 	void (*probe_finalize)(struct device *dev);
 	struct iommu_group *(*device_group)(struct device *dev);
-	int (*domain_get_attr)(struct iommu_domain *domain,
-			       enum iommu_attr attr, void *data);
-	int (*domain_set_attr)(struct iommu_domain *domain,
-			       enum iommu_attr attr, void *data);
 	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
@@ -493,10 +473,6 @@ extern int iommu_page_response(struct device *dev,
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
-				 void *data);
-extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
-				 void *data);
 int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
@@ -869,18 +845,6 @@ static inline int iommu_group_id(struct iommu_group *group)
 	return -ENODEV;
 }
 
-static inline int iommu_domain_get_attr(struct iommu_domain *domain,
-					enum iommu_attr attr, void *data)
-{
-	return -EINVAL;
-}
-
-static inline int iommu_domain_set_attr(struct iommu_domain *domain,
-					enum iommu_attr attr, void *data)
-{
-	return -EINVAL;
-}
-
 static inline int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
-- 
2.30.1

