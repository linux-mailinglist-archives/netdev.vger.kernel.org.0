Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668A6327A07
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhCAIxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhCAItL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:49:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E61C061788;
        Mon,  1 Mar 2021 00:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=E/LKSHDwwzGiWLcH5n+WeTB74m8ESiCywnIfCbtw87s=; b=uq6dlLskuP/tcPB55euUeWUQsH
        TkTGV9HhYmkI/tO9Ey/FA/o7V7Re3hEwZb28TvXyc9evs9IQhTKvixiX1+oWK2bQvd+YTkR8fr9hR
        XFrLMsEwC1ES85XiFTfZPgRNst8sn4TJWNzpGWnHmTYuta9ncKNc4718W9DNrml4y5fV0DG77QLSn
        euQ0SaijCGxeIESo1cjH/Epr9ezTG0aVMq4AIlUzm2XF3vM278ZO9BEESqvTl2WjcnC6nYNLyBbGR
        M6SXkDwPXNb4l0x7gVGzKizpSFKeUfPkxs+370P6sIczRLHVEqXMSYwKBAv5l68T9YKjK40kKrgA/
        FMVHdAGA==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeDY-00FUsn-9n; Mon, 01 Mar 2021 08:48:00 +0000
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
Subject: [PATCH 13/17] iommu: remove DOMAIN_ATTR_GEOMETRY
Date:   Mon,  1 Mar 2021 09:42:53 +0100
Message-Id: <20210301084257.945454-14-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The geometry information can be trivially queried from the iommu_domain
struture.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/iommu.c               | 20 +++-----------------
 drivers/soc/fsl/qbman/qman_portal.c |  1 +
 drivers/vfio/vfio_iommu_type1.c     | 26 ++++++++++++--------------
 drivers/vhost/vdpa.c                | 10 +++-------
 include/linux/iommu.h               |  1 -
 5 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9a4cda390993e6..23daaea7883b75 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2667,23 +2667,9 @@ core_initcall(iommu_init);
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
-	struct iommu_domain_geometry *geometry;
-	int ret = 0;
-
-	switch (attr) {
-	case DOMAIN_ATTR_GEOMETRY:
-		geometry  = data;
-		*geometry = domain->geometry;
-
-		break;
-	default:
-		if (!domain->ops->domain_get_attr)
-			return -EINVAL;
-
-		ret = domain->ops->domain_get_attr(domain, attr, data);
-	}
-
-	return ret;
+	if (!domain->ops->domain_get_attr)
+		return -EINVAL;
+	return domain->ops->domain_get_attr(domain, attr, data);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
 
diff --git a/drivers/soc/fsl/qbman/qman_portal.c b/drivers/soc/fsl/qbman/qman_portal.c
index bf38eb0042ed52..4a4466cc26c232 100644
--- a/drivers/soc/fsl/qbman/qman_portal.c
+++ b/drivers/soc/fsl/qbman/qman_portal.c
@@ -53,6 +53,7 @@ static void portal_set_cpu(struct qm_portal_config *pcfg, int cpu)
 		dev_err(dev, "%s(): iommu_domain_alloc() failed", __func__);
 		goto no_iommu;
 	}
+
 	ret = fsl_pamu_configure_l1_stash(pcfg->iommu_domain, cpu);
 	if (ret < 0) {
 		dev_err(dev, "%s(): fsl_pamu_configure_l1_stash() = %d",
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4bb162c1d649b3..c8e57f22f421c5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2252,7 +2252,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	int ret;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
-	struct iommu_domain_geometry geo;
+	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
 
@@ -2333,10 +2333,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_domain;
 
 	/* Get aperture info */
-	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
-
-	if (vfio_iommu_aper_conflict(iommu, geo.aperture_start,
-				     geo.aperture_end)) {
+	geo = &domain->domain->geometry;
+	if (vfio_iommu_aper_conflict(iommu, geo->aperture_start,
+				     geo->aperture_end)) {
 		ret = -EINVAL;
 		goto out_detach;
 	}
@@ -2359,8 +2358,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_detach;
 
-	ret = vfio_iommu_aper_resize(&iova_copy, geo.aperture_start,
-				     geo.aperture_end);
+	ret = vfio_iommu_aper_resize(&iova_copy, geo->aperture_start,
+				     geo->aperture_end);
 	if (ret)
 		goto out_detach;
 
@@ -2493,7 +2492,6 @@ static void vfio_iommu_aper_expand(struct vfio_iommu *iommu,
 				   struct list_head *iova_copy)
 {
 	struct vfio_domain *domain;
-	struct iommu_domain_geometry geo;
 	struct vfio_iova *node;
 	dma_addr_t start = 0;
 	dma_addr_t end = (dma_addr_t)~0;
@@ -2502,12 +2500,12 @@ static void vfio_iommu_aper_expand(struct vfio_iommu *iommu,
 		return;
 
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY,
-				      &geo);
-		if (geo.aperture_start > start)
-			start = geo.aperture_start;
-		if (geo.aperture_end < end)
-			end = geo.aperture_end;
+		struct iommu_domain_geometry *geo = &domain->domain->geometry;
+
+		if (geo->aperture_start > start)
+			start = geo->aperture_start;
+		if (geo->aperture_end < end)
+			end = geo->aperture_end;
 	}
 
 	/* Modify aperture limits. The new aper is either same or bigger */
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e6f..25824fab433d0a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -826,18 +826,14 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
 static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 {
 	struct vdpa_iova_range *range = &v->range;
-	struct iommu_domain_geometry geo;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 
 	if (ops->get_iova_range) {
 		*range = ops->get_iova_range(vdpa);
-	} else if (v->domain &&
-		   !iommu_domain_get_attr(v->domain,
-		   DOMAIN_ATTR_GEOMETRY, &geo) &&
-		   geo.force_aperture) {
-		range->first = geo.aperture_start;
-		range->last = geo.aperture_end;
+	} else if (v->domain && v->domain->geometry.force_aperture) {
+		range->first = v->domain->geometry.aperture_start;
+		range->last = v->domain->geometry.aperture_end;
 	} else {
 		range->first = 0;
 		range->last = ULLONG_MAX;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 180ff4bd7fa7ef..c15a8658daad64 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -107,7 +107,6 @@ enum iommu_cap {
  */
 
 enum iommu_attr {
-	DOMAIN_ATTR_GEOMETRY,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
-- 
2.29.2

