Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71D33D885
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbhCPQC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:02:29 -0400
Received: from casper.infradead.org ([90.155.50.34]:40304 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbhCPQA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uAkAL9bKpEi2EHehW2pGjvC7Z2PgJIxUdOpjcgZC0vk=; b=Qt22ze7Ge8lRN1C/kGC82F1d6H
        MJExup8bOyJQbhJDnVi2n/POMgBEQJBqGxeQUfNS7uZY0W0qw8WeFwUmbF5QwFTot1AgE9JTwPHOJ
        cBdq0yVzkPLNFL+kM6co7kJ70DIwfkL6snqTVa5+A1B79uxD9b26FLheYDcM03iOsXg1UmQoIRr++
        0+WdeMQw5SMM1Oinu7tKy4rKkKdpW7l/RtTpD3LQkXe6YqbQe2pibrMwmCdhGFFrFCzNIO/j1gn11
        2mg0fIH7YfDY19y+biZHqZgbHl+uLPnbrNnqgU5kYwS63iJ93vPMjJ8Pl3e9/IcuoBdMfnRTCcWEA
        tMnVcidQ==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMC6q-000Gy8-1D; Tue, 16 Mar 2021 15:59:54 +0000
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
Subject: [PATCH 08/18] iommu/fsl_pamu: merge pamu_set_liodn and map_liodn
Date:   Tue, 16 Mar 2021 16:38:14 +0100
Message-Id: <20210316153825.135976-9-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
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
Acked-by: Li Yang <leoyang.li@nxp.com>
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
2.30.1

