Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5886B33D81F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCPPtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:49:41 -0400
Received: from casper.infradead.org ([90.155.50.34]:39190 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbhCPPtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QN7GVfC8ZM01/BUj2S43wlyrokZblV3LlQxxQPFIb2Y=; b=YAq24PLFLbc+LDhaZbapU2igNS
        Q1hMlEF+wEjEpYOK7BJoKJ8Lr6hwPfOsLhmfkWKv99zfbUDOvKo+t6jKPmcZR3YN+ZpU0tcsMztOl
        YxeEo6+iKYsOKdR3T/pNK0EbucjqREEueoB+U26pBw8iicBpd0dvNGaWTWM7H42V6k4Sbp4twyqi9
        H8qnmJscMf4IqatWdJh1YHhH8OOMCzMzf//lKseCe4fd3Bsh9DZAQcWwLeNTBu7iGohJOMSYkDIew
        VkB07QUW4FzdI6WC6YEiq9+7EVd0Bxp7PyadMxM/vhcPcVFvEtKXql2AM9SDZ3r/P45hfISSHv1YX
        US4gOoFg==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMBsf-000FwZ-DA; Tue, 16 Mar 2021 15:45:16 +0000
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
Subject: [PATCH 02/18] iommu/fsl_pamu: remove fsl_pamu_get_domain_attr
Date:   Tue, 16 Mar 2021 16:38:08 +0100
Message-Id: <20210316153825.135976-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of the values returned by this function are ever queried.  Also
remove the DOMAIN_ATTR_FSL_PAMUV1 enum value that is not otherwise used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/fsl_pamu_domain.c | 30 ------------------------------
 include/linux/iommu.h           |  4 ----
 2 files changed, 34 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 53380cf1fa452f..e587ec43f7e750 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -832,35 +832,6 @@ static int fsl_pamu_set_domain_attr(struct iommu_domain *domain,
 	return ret;
 }
 
-static int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
-				    enum iommu_attr attr_type, void *data)
-{
-	struct fsl_dma_domain *dma_domain = to_fsl_dma_domain(domain);
-	int ret = 0;
-
-	switch (attr_type) {
-	case DOMAIN_ATTR_FSL_PAMU_STASH:
-		memcpy(data, &dma_domain->dma_stash,
-		       sizeof(struct pamu_stash_attribute));
-		break;
-	case DOMAIN_ATTR_FSL_PAMU_ENABLE:
-		*(int *)data = dma_domain->enabled;
-		break;
-	case DOMAIN_ATTR_FSL_PAMUV1:
-		*(int *)data = DOMAIN_ATTR_FSL_PAMUV1;
-		break;
-	case DOMAIN_ATTR_WINDOWS:
-		*(u32 *)data = dma_domain->win_cnt;
-		break;
-	default:
-		pr_debug("Unsupported attribute type\n");
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
 static struct iommu_group *get_device_iommu_group(struct device *dev)
 {
 	struct iommu_group *group;
@@ -987,7 +958,6 @@ static const struct iommu_ops fsl_pamu_ops = {
 	.domain_window_enable = fsl_pamu_window_enable,
 	.iova_to_phys	= fsl_pamu_iova_to_phys,
 	.domain_set_attr = fsl_pamu_set_domain_attr,
-	.domain_get_attr = fsl_pamu_get_domain_attr,
 	.probe_device	= fsl_pamu_probe_device,
 	.release_device	= fsl_pamu_release_device,
 	.device_group   = fsl_pamu_device_group,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 47c8b318d8f523..52874ae164dd60 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -104,9 +104,6 @@ enum iommu_cap {
  *  -the actual size of the mapped region of a window must be power
  *   of 2 starting with 4KB and physical address must be naturally
  *   aligned.
- * DOMAIN_ATTR_FSL_PAMUV1 corresponds to the above mentioned contraints.
- * The caller can invoke iommu_domain_get_attr to check if the underlying
- * iommu implementation supports these constraints.
  */
 
 enum iommu_attr {
@@ -115,7 +112,6 @@ enum iommu_attr {
 	DOMAIN_ATTR_WINDOWS,
 	DOMAIN_ATTR_FSL_PAMU_STASH,
 	DOMAIN_ATTR_FSL_PAMU_ENABLE,
-	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
-- 
2.30.1

