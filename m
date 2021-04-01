Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BE3519D8
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhDAR4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbhDARvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:51:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F16FC02D577;
        Thu,  1 Apr 2021 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6DcxZsiPepfGUgEn3X4Pytv10TvLFSsigpRcj4GEp8w=; b=uRAAEOxv+dvr1q453virD2Gtg2
        RxsviVpQmrYjUOesDnzmffH1s4f5/g/ydd6GmWzsNFgEAhk4MwZz160FCUG54cbCwoO7u9CKV2e6H
        oA/2q/iPNV0v3FgBw4/fS+dY5iILltmFPA24gZPu1D2JMj/qR3IqQRU6Y3/mqHpy3MK6b3FqwnQMT
        ZIKQX7drOizNIcl/RvwRzhCvsTPnqRZzU1azHpSJ2cwTryCvxHonansIz6pnu26oZ3I9+tYVkzdGQ
        Ub7tBWI6c7Tf08rokSakQpzuRx3oyNbi65wV30f87Ope5E1zKUA3FQEE9GQ5dk0QmbFmXxQyTxWUb
        Q2It65xg==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzdg-00Cict-3h; Thu, 01 Apr 2021 15:53:44 +0000
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
Subject: [PATCH 13/20] iommu/fsl_pamu: hardcode the window address and size in pamu_config_ppaace
Date:   Thu,  1 Apr 2021 17:52:49 +0200
Message-Id: <20210401155256.298656-14-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The win_addr and win_size parameters are always set to 0 and 1 << 36
respectively, so just hard code them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/fsl_pamu.c        | 23 ++++-------------------
 drivers/iommu/fsl_pamu.h        |  3 +--
 drivers/iommu/fsl_pamu_domain.c | 10 ++--------
 3 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index 742fa0e8c45b88..fc38b1fba7cff0 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -178,8 +178,6 @@ int pamu_update_paace_stash(int liodn, u32 value)
  * pamu_config_paace() - Sets up PPAACE entry for specified liodn
  *
  * @liodn: Logical IO device number
- * @win_addr: starting address of DSA window
- * @win-size: size of DSA window
  * @omi: Operation mapping index -- if ~omi == 0 then omi not defined
  * @stashid: cache stash id for associated cpu -- if ~stashid == 0 then
  *	     stashid not defined
@@ -187,35 +185,22 @@ int pamu_update_paace_stash(int liodn, u32 value)
  *
  * Returns 0 upon success else error code < 0 returned
  */
-int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
-		       u32 omi, u32 stashid, int prot)
+int pamu_config_ppaace(int liodn, u32 omi, u32 stashid, int prot)
 {
 	struct paace *ppaace;
 
-	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
-		pr_debug("window size too small or not a power of two %pa\n",
-			 &win_size);
-		return -EINVAL;
-	}
-
-	if (win_addr & (win_size - 1)) {
-		pr_debug("window address is not aligned with window size\n");
-		return -EINVAL;
-	}
-
 	ppaace = pamu_get_ppaace(liodn);
 	if (!ppaace)
 		return -ENOENT;
 
 	/* window size is 2^(WSE+1) bytes */
 	set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE,
-	       map_addrspace_size_to_wse(win_size));
+	       map_addrspace_size_to_wse(1ULL << 36));
 
 	pamu_init_ppaace(ppaace);
 
-	ppaace->wbah = win_addr >> (PAMU_PAGE_SHIFT + 20);
-	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL,
-	       (win_addr >> PAMU_PAGE_SHIFT));
+	ppaace->wbah = 0;
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
 
 	/* set up operation mapping if it's configured */
 	if (omi < OME_NUMBER_ENTRIES) {
diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
index c96b29f0c7077f..36df7975ff64d3 100644
--- a/drivers/iommu/fsl_pamu.h
+++ b/drivers/iommu/fsl_pamu.h
@@ -383,8 +383,7 @@ struct ome {
 int pamu_domain_init(void);
 int pamu_enable_liodn(int liodn);
 int pamu_disable_liodn(int liodn);
-int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
-		       u32 omi, uint32_t stashid, int prot);
+int pamu_config_ppaace(int liodn, u32 omi, uint32_t stashid, int prot);
 
 u32 get_stash_id(u32 stash_dest_hint, u32 vcpu);
 void get_ome_index(u32 *omi_index, struct device *dev);
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index c83f1e7c2cb0c9..32944d67baa495 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -78,8 +78,6 @@ static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
 static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
 			  int liodn)
 {
-	struct iommu_domain *domain = &dma_domain->iommu_domain;
-	struct iommu_domain_geometry *geom = &domain->geometry;
 	u32 omi_index = ~(u32)0;
 	unsigned long flags;
 	int ret;
@@ -95,14 +93,10 @@ static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
 	ret = pamu_disable_liodn(liodn);
 	if (ret)
 		goto out_unlock;
-	ret = pamu_config_ppaace(liodn, geom->aperture_start,
-				 geom->aperture_end + 1, omi_index,
-				 dma_domain->stash_id, 0);
+	ret = pamu_config_ppaace(liodn, omi_index, dma_domain->stash_id, 0);
 	if (ret)
 		goto out_unlock;
-	ret = pamu_config_ppaace(liodn, geom->aperture_start,
-				 geom->aperture_end + 1, ~(u32)0,
-				 dma_domain->stash_id,
+	ret = pamu_config_ppaace(liodn, ~(u32)0, dma_domain->stash_id,
 				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);
 out_unlock:
 	spin_unlock_irqrestore(&iommu_lock, flags);
-- 
2.30.1

