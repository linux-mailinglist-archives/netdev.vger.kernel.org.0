Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9D33D8D4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhCPQMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:12:23 -0400
Received: from casper.infradead.org ([90.155.50.34]:41692 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbhCPQMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kHsRf80hweLFXx2Y8vqSJos+4uW9lRm5vIxtw6UsvMs=; b=SIEddbpnHlyrrcTbha6VnM5ANP
        765jLuSEDVATvpW3nQzBo9iAZMRlfjctVKLpGIuBZZ/WxT22BvVZ88DqZIEqeI7qYuA/sdqi3ikYx
        eoO0xmAg37aZHnzboSseJQfV/oHQKqQ3xKLSi+uJJk66r54ilb8RrGb+6UdSUWKCvWRhMaRwp5RZV
        5U5eUchuFjOb9w7ODwAWi3DvzoLKg/F8/2mjQL6N5SaWmV6EGehccsU7nvbmjCgMcNyYgfrZOtIGN
        kWLiA8Ikltq449FxFC8QxBDvYAo4jQSt/vYqmP+hlAyEqNYSzToufY8hV10sNWU7OsPUPOhLUypS8
        UU1IXipA==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMCIH-000I1z-Lk; Tue, 16 Mar 2021 16:11:42 +0000
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
Subject: [PATCH 13/18] iommu: remove DOMAIN_ATTR_GEOMETRY
Date:   Tue, 16 Mar 2021 16:38:19 +0100
Message-Id: <20210316153825.135976-14-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The geometry information can be trivially queried from the iommu_domain
struture.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/iommu.c           | 20 +++-----------------
 drivers/vfio/vfio_iommu_type1.c | 26 ++++++++++++--------------
 drivers/vhost/vdpa.c            | 10 +++-------
 include/linux/iommu.h           |  1 -
 4 files changed, 18 insertions(+), 39 deletions(-)

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
2.30.1

