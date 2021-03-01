Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A443279E6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhCAItA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhCAIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:47:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A1DC0617A7;
        Mon,  1 Mar 2021 00:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8cw/tB+04J2iAtsMKLPoPx+hBRR1FdRVQFha9jtElog=; b=Q9Ino2DcdhwI4DA9ItrytUgJDg
        g7hUPeJyocCO+CrgKSBtOKBaZMm+wrO7mDJ/6jbj+IqPpVE7tQK66zjLR0kMgmMFzrrljx7Oma0t4
        XfNtNECDNj7CVEXS35GAV+r5r+k7gnql5Xu+ougkfnhFfGb6L56G3yxUd8i97qnPfM8kQ4fw0Jwci
        xNeigVYeeM8/9CxJTnz6ZjQ1dpq8G2xK7PExWjD4jJ4gbdG4davy+7WpnDoAymNGb/FQHvIgelbgH
        1/HpTZXRuf7e/aGaLYqBPzvmaNvrPUrDEoyvqFfjHf7JvGYFvOUR7TKJYN3ceDXwjflMroMRjrM/N
        xMlPy/ZA==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeAh-00FUcs-Bk; Mon, 01 Mar 2021 08:45:02 +0000
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
Subject: [PATCH 08/17] iommu/fsl_pamu: merge pamu_set_liodn and map_liodn
Date:   Mon,  1 Mar 2021 09:42:48 +0100
Message-Id: <20210301084257.945454-9-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the two fuctions that configure the ppaace into a single coherent
function.  I somehow doubt we need the two pamu_config_ppaace calls,
but keep the existing behavior just to be on the safe side.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/fsl_pamu_domain.c | 65 +++++++++------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 40eff4b7bc5d42..4a4944332674f7 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -54,25 +54,6 @@ static int __init iommu_init_mempool(void)
 	return 0;
 }
 
-/* Map the DMA window corresponding to the LIODN */
-static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
-{
-	int ret;
-	struct iommu_domain_geometry *geom = &dma_domain->iommu_domain.geometry;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iommu_lock, flags);
-	ret = pamu_config_ppaace(liodn, geom->aperture_start,
-				 geom->aperture_end - 1, ~(u32)0,
-				 0, dma_domain->snoop_id, dma_domain->stash_id,
-				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);
-	spin_unlock_irqrestore(&iommu_lock, flags);
-	if (ret)
-		pr_debug("PAACE configuration failed for liodn %d\n", liodn);
-
-	return ret;
-}
-
 static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
 			      u32 val)
 {
@@ -94,11 +75,11 @@ static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
 }
 
 /* Set the geometry parameters for a LIODN */
-static int pamu_set_liodn(int liodn, struct device *dev,
-			  struct fsl_dma_domain *dma_domain,
-			  struct iommu_domain_geometry *geom_attr)
+static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
+			  int liodn)
 {
-	phys_addr_t window_addr, window_size;
+	struct iommu_domain *domain = &dma_domain->iommu_domain;
+	struct iommu_domain_geometry *geom = &domain->geometry;
 	u32 omi_index = ~(u32)0;
 	unsigned long flags;
 	int ret;
@@ -110,22 +91,25 @@ static int pamu_set_liodn(int liodn, struct device *dev,
 	 */
 	get_ome_index(&omi_index, dev);
 
-	window_addr = geom_attr->aperture_start;
-	window_size = geom_attr->aperture_end + 1;
-
 	spin_lock_irqsave(&iommu_lock, flags);
 	ret = pamu_disable_liodn(liodn);
-	if (!ret)
-		ret = pamu_config_ppaace(liodn, window_addr, window_size, omi_index,
-					 0, dma_domain->snoop_id,
-					 dma_domain->stash_id, 0);
+	if (ret)
+		goto out_unlock;
+	ret = pamu_config_ppaace(liodn, geom->aperture_start,
+				 geom->aperture_end - 1, omi_index, 0,
+				 dma_domain->snoop_id, dma_domain->stash_id, 0);
+	if (ret)
+		goto out_unlock;
+	ret = pamu_config_ppaace(liodn, geom->aperture_start,
+				 geom->aperture_end - 1, ~(u32)0,
+				 0, dma_domain->snoop_id, dma_domain->stash_id,
+				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);
+out_unlock:
 	spin_unlock_irqrestore(&iommu_lock, flags);
 	if (ret) {
 		pr_debug("PAACE configuration failed for liodn %d\n",
 			 liodn);
-		return ret;
 	}
-
 	return ret;
 }
 
@@ -265,7 +249,6 @@ static int handle_attach_device(struct fsl_dma_domain *dma_domain,
 				int num)
 {
 	unsigned long flags;
-	struct iommu_domain *domain = &dma_domain->iommu_domain;
 	int ret = 0;
 	int i;
 
@@ -280,21 +263,7 @@ static int handle_attach_device(struct fsl_dma_domain *dma_domain,
 		}
 
 		attach_device(dma_domain, liodn[i], dev);
-		/*
-		 * Check if geometry has already been configured
-		 * for the domain. If yes, set the geometry for
-		 * the LIODN.
-		 */
-		ret = pamu_set_liodn(liodn[i], dev, dma_domain,
-				     &domain->geometry);
-		if (ret)
-			break;
-
-		/*
-		 * Create window/subwindow mapping for
-		 * the LIODN.
-		 */
-		ret = map_liodn(liodn[i], dma_domain);
+		ret = pamu_set_liodn(dma_domain, dev, liodn[i]);
 		if (ret)
 			break;
 	}
-- 
2.29.2

