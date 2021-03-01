Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4753279AF
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhCAIpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbhCAIpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:45:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884AFC061786;
        Mon,  1 Mar 2021 00:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B/pSWqws04grk0HkUj22u2i3N2ditR5XkyO2J29q1Xg=; b=HwKfa1A5MiCq8sKlXE2g/kVMvh
        S/racpVxDPkmw4iOa4VlBWJ4Avrr4/cLwKd66j1WZoDpoREaw7y/8CXYoEyAc3IhneaSLCoE870MS
        q8pvTVS13Ctd1t4sbbQzNW7Z/IO4/Ht1Ul6gU7/Vt7VDeBkKXGKDjScv2jCAv6YG9o82isLDJ//Dv
        QpZW9Vvkm136A5UuZqLKqnOILkp1wFKIpAuF+xPTUplPYWFIBE3PduE4bPnDrRicRDuIHEIutFEh6
        K1U5GuBQlvBfpovXJURwnpXj/R052gZL3yswVnmW8ykUSuVJadUkt0jwn1ndhga/ffSgiUDhsQFP7
        1gLmabxw==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGe9P-00FUXu-9A; Mon, 01 Mar 2021 08:43:36 +0000
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
Subject: [PATCH 05/17] iommu/fsl_pamu: remove support for multiple windows
Date:   Mon,  1 Mar 2021 09:42:45 +0100
Message-Id: <20210301084257.945454-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only domains allocated forces use of a single window.  Remove all
the code related to multiple window support, as well as the need for
qman_portal to force a single window.

Remove the now unused DOMAIN_ATTR_WINDOWS iommu_attr.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/fsl_pamu.c            | 264 +-------------------------
 drivers/iommu/fsl_pamu.h            |  10 +-
 drivers/iommu/fsl_pamu_domain.c     | 275 +++++-----------------------
 drivers/iommu/fsl_pamu_domain.h     |  12 +-
 drivers/soc/fsl/qbman/qman_portal.c |   7 -
 include/linux/iommu.h               |   1 -
 6 files changed, 59 insertions(+), 510 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index b9a974d9783113..3e1647cd5ad47a 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -63,19 +63,6 @@ static const struct of_device_id l3_device_ids[] = {
 /* maximum subwindows permitted per liodn */
 static u32 max_subwindow_count;
 
-/* Pool for fspi allocation */
-static struct gen_pool *spaace_pool;
-
-/**
- * pamu_get_max_subwin_cnt() - Return the maximum supported
- * subwindow count per liodn.
- *
- */
-u32 pamu_get_max_subwin_cnt(void)
-{
-	return max_subwindow_count;
-}
-
 /**
  * pamu_get_ppaace() - Return the primary PACCE
  * @liodn: liodn PAACT index for desired PAACE
@@ -155,13 +142,6 @@ static unsigned int map_addrspace_size_to_wse(phys_addr_t addrspace_size)
 	return fls64(addrspace_size) - 2;
 }
 
-/* Derive the PAACE window count encoding for the subwindow count */
-static unsigned int map_subwindow_cnt_to_wce(u32 subwindow_cnt)
-{
-	/* window count is 2^(WCE+1) bytes */
-	return __ffs(subwindow_cnt) - 1;
-}
-
 /*
  * Set the PAACE type as primary and set the coherency required domain
  * attribute
@@ -174,89 +154,11 @@ static void pamu_init_ppaace(struct paace *ppaace)
 	       PAACE_M_COHERENCE_REQ);
 }
 
-/*
- * Set the PAACE type as secondary and set the coherency required domain
- * attribute.
- */
-static void pamu_init_spaace(struct paace *spaace)
-{
-	set_bf(spaace->addr_bitfields, PAACE_AF_PT, PAACE_PT_SECONDARY);
-	set_bf(spaace->domain_attr.to_host.coherency_required, PAACE_DA_HOST_CR,
-	       PAACE_M_COHERENCE_REQ);
-}
-
-/*
- * Return the spaace (corresponding to the secondary window index)
- * for a particular ppaace.
- */
-static struct paace *pamu_get_spaace(struct paace *paace, u32 wnum)
-{
-	u32 subwin_cnt;
-	struct paace *spaace = NULL;
-
-	subwin_cnt = 1UL << (get_bf(paace->impl_attr, PAACE_IA_WCE) + 1);
-
-	if (wnum < subwin_cnt)
-		spaace = &spaact[paace->fspi + wnum];
-	else
-		pr_debug("secondary paace out of bounds\n");
-
-	return spaace;
-}
-
-/**
- * pamu_get_fspi_and_allocate() - Allocates fspi index and reserves subwindows
- *                                required for primary PAACE in the secondary
- *                                PAACE table.
- * @subwin_cnt: Number of subwindows to be reserved.
- *
- * A PPAACE entry may have a number of associated subwindows. A subwindow
- * corresponds to a SPAACE entry in the SPAACT table. Each PAACE entry stores
- * the index (fspi) of the first SPAACE entry in the SPAACT table. This
- * function returns the index of the first SPAACE entry. The remaining
- * SPAACE entries are reserved contiguously from that index.
- *
- * Returns a valid fspi index in the range of 0 - SPAACE_NUMBER_ENTRIES on success.
- * If no SPAACE entry is available or the allocator can not reserve the required
- * number of contiguous entries function returns ULONG_MAX indicating a failure.
- *
- */
-static unsigned long pamu_get_fspi_and_allocate(u32 subwin_cnt)
-{
-	unsigned long spaace_addr;
-
-	spaace_addr = gen_pool_alloc(spaace_pool, subwin_cnt * sizeof(struct paace));
-	if (!spaace_addr)
-		return ULONG_MAX;
-
-	return (spaace_addr - (unsigned long)spaact) / (sizeof(struct paace));
-}
-
-/* Release the subwindows reserved for a particular LIODN */
-void pamu_free_subwins(int liodn)
-{
-	struct paace *ppaace;
-	u32 subwin_cnt, size;
-
-	ppaace = pamu_get_ppaace(liodn);
-	if (!ppaace) {
-		pr_debug("Invalid liodn entry\n");
-		return;
-	}
-
-	if (get_bf(ppaace->addr_bitfields, PPAACE_AF_MW)) {
-		subwin_cnt = 1UL << (get_bf(ppaace->impl_attr, PAACE_IA_WCE) + 1);
-		size = (subwin_cnt - 1) * sizeof(struct paace);
-		gen_pool_free(spaace_pool, (unsigned long)&spaact[ppaace->fspi], size);
-		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
-	}
-}
-
 /*
  * Function used for updating stash destination for the coressponding
  * LIODN.
  */
-int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value)
+int pamu_update_paace_stash(int liodn, u32 value)
 {
 	struct paace *paace;
 
@@ -265,11 +167,6 @@ int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value)
 		pr_debug("Invalid liodn entry\n");
 		return -ENOENT;
 	}
-	if (subwin) {
-		paace = pamu_get_spaace(paace, subwin - 1);
-		if (!paace)
-			return -ENOENT;
-	}
 	set_bf(paace->impl_attr, PAACE_IA_CID, value);
 
 	mb();
@@ -277,31 +174,6 @@ int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value)
 	return 0;
 }
 
-/* Disable a subwindow corresponding to the LIODN */
-int pamu_disable_spaace(int liodn, u32 subwin)
-{
-	struct paace *paace;
-
-	paace = pamu_get_ppaace(liodn);
-	if (!paace) {
-		pr_debug("Invalid liodn entry\n");
-		return -ENOENT;
-	}
-	if (subwin) {
-		paace = pamu_get_spaace(paace, subwin - 1);
-		if (!paace)
-			return -ENOENT;
-		set_bf(paace->addr_bitfields, PAACE_AF_V, PAACE_V_INVALID);
-	} else {
-		set_bf(paace->addr_bitfields, PAACE_AF_AP,
-		       PAACE_AP_PERMS_DENIED);
-	}
-
-	mb();
-
-	return 0;
-}
-
 /**
  * pamu_config_paace() - Sets up PPAACE entry for specified liodn
  *
@@ -314,17 +186,15 @@ int pamu_disable_spaace(int liodn, u32 subwin)
  *	     stashid not defined
  * @snoopid: snoop id for hardware coherency -- if ~snoopid == 0 then
  *	     snoopid not defined
- * @subwin_cnt: number of sub-windows
  * @prot: window permissions
  *
  * Returns 0 upon success else error code < 0 returned
  */
 int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
 		       u32 omi, unsigned long rpn, u32 snoopid, u32 stashid,
-		       u32 subwin_cnt, int prot)
+		       int prot)
 {
 	struct paace *ppaace;
-	unsigned long fspi;
 
 	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
 		pr_debug("window size too small or not a power of two %pa\n",
@@ -368,116 +238,12 @@ int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
 	if (~snoopid != 0)
 		ppaace->domain_attr.to_host.snpid = snoopid;
 
-	if (subwin_cnt) {
-		/* The first entry is in the primary PAACE instead */
-		fspi = pamu_get_fspi_and_allocate(subwin_cnt - 1);
-		if (fspi == ULONG_MAX) {
-			pr_debug("spaace indexes exhausted\n");
-			return -EINVAL;
-		}
-
-		/* window count is 2^(WCE+1) bytes */
-		set_bf(ppaace->impl_attr, PAACE_IA_WCE,
-		       map_subwindow_cnt_to_wce(subwin_cnt));
-		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0x1);
-		ppaace->fspi = fspi;
-	} else {
-		set_bf(ppaace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
-		ppaace->twbah = rpn >> 20;
-		set_bf(ppaace->win_bitfields, PAACE_WIN_TWBAL, rpn);
-		set_bf(ppaace->addr_bitfields, PAACE_AF_AP, prot);
-		set_bf(ppaace->impl_attr, PAACE_IA_WCE, 0);
-		set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
-	}
-	mb();
-
-	return 0;
-}
-
-/**
- * pamu_config_spaace() - Sets up SPAACE entry for specified subwindow
- *
- * @liodn:  Logical IO device number
- * @subwin_cnt:  number of sub-windows associated with dma-window
- * @subwin: subwindow index
- * @subwin_size: size of subwindow
- * @omi: Operation mapping index
- * @rpn: real (true physical) page number
- * @snoopid: snoop id for hardware coherency -- if ~snoopid == 0 then
- *			  snoopid not defined
- * @stashid: cache stash id for associated cpu
- * @enable: enable/disable subwindow after reconfiguration
- * @prot: sub window permissions
- *
- * Returns 0 upon success else error code < 0 returned
- */
-int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin,
-		       phys_addr_t subwin_size, u32 omi, unsigned long rpn,
-		       u32 snoopid, u32 stashid, int enable, int prot)
-{
-	struct paace *paace;
-
-	/* setup sub-windows */
-	if (!subwin_cnt) {
-		pr_debug("Invalid subwindow count\n");
-		return -EINVAL;
-	}
-
-	paace = pamu_get_ppaace(liodn);
-	if (subwin > 0 && subwin < subwin_cnt && paace) {
-		paace = pamu_get_spaace(paace, subwin - 1);
-
-		if (paace && !(paace->addr_bitfields & PAACE_V_VALID)) {
-			pamu_init_spaace(paace);
-			set_bf(paace->addr_bitfields, SPAACE_AF_LIODN, liodn);
-		}
-	}
-
-	if (!paace) {
-		pr_debug("Invalid liodn entry\n");
-		return -ENOENT;
-	}
-
-	if ((subwin_size & (subwin_size - 1)) || subwin_size < PAMU_PAGE_SIZE) {
-		pr_debug("subwindow size out of range, or not a power of 2\n");
-		return -EINVAL;
-	}
-
-	if (rpn == ULONG_MAX) {
-		pr_debug("real page number out of range\n");
-		return -EINVAL;
-	}
-
-	/* window size is 2^(WSE+1) bytes */
-	set_bf(paace->win_bitfields, PAACE_WIN_SWSE,
-	       map_addrspace_size_to_wse(subwin_size));
-
-	set_bf(paace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
-	paace->twbah = rpn >> 20;
-	set_bf(paace->win_bitfields, PAACE_WIN_TWBAL, rpn);
-	set_bf(paace->addr_bitfields, PAACE_AF_AP, prot);
-
-	/* configure snoop id */
-	if (~snoopid != 0)
-		paace->domain_attr.to_host.snpid = snoopid;
-
-	/* set up operation mapping if it's configured */
-	if (omi < OME_NUMBER_ENTRIES) {
-		set_bf(paace->impl_attr, PAACE_IA_OTM, PAACE_OTM_INDEXED);
-		paace->op_encode.index_ot.omi = omi;
-	} else if (~omi != 0) {
-		pr_debug("bad operation mapping index: %d\n", omi);
-		return -EINVAL;
-	}
-
-	if (~stashid != 0)
-		set_bf(paace->impl_attr, PAACE_IA_CID, stashid);
-
-	smp_wmb();
-
-	if (enable)
-		set_bf(paace->addr_bitfields, PAACE_AF_V, PAACE_V_VALID);
-
+	set_bf(ppaace->impl_attr, PAACE_IA_ATM, PAACE_ATM_WINDOW_XLATE);
+	ppaace->twbah = rpn >> 20;
+	set_bf(ppaace->win_bitfields, PAACE_WIN_TWBAL, rpn);
+	set_bf(ppaace->addr_bitfields, PAACE_AF_AP, prot);
+	set_bf(ppaace->impl_attr, PAACE_IA_WCE, 0);
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
 	mb();
 
 	return 0;
@@ -1129,17 +895,6 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 	spaact_phys = virt_to_phys(spaact);
 	omt_phys = virt_to_phys(omt);
 
-	spaace_pool = gen_pool_create(ilog2(sizeof(struct paace)), -1);
-	if (!spaace_pool) {
-		ret = -ENOMEM;
-		dev_err(dev, "Failed to allocate spaace gen pool\n");
-		goto error;
-	}
-
-	ret = gen_pool_add(spaace_pool, (unsigned long)spaact, SPAACT_SIZE, -1);
-	if (ret)
-		goto error_genpool;
-
 	pamubypenr = in_be32(&guts_regs->pamubypenr);
 
 	for (pamu_reg_off = 0, pamu_counter = 0x80000000; pamu_reg_off < size;
@@ -1167,9 +922,6 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 
 	return 0;
 
-error_genpool:
-	gen_pool_destroy(spaace_pool);
-
 error:
 	if (irq != NO_IRQ)
 		free_irq(irq, data);
diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
index e1496ba96160fd..04fd843d718dd1 100644
--- a/drivers/iommu/fsl_pamu.h
+++ b/drivers/iommu/fsl_pamu.h
@@ -383,18 +383,12 @@ struct ome {
 int pamu_domain_init(void);
 int pamu_enable_liodn(int liodn);
 int pamu_disable_liodn(int liodn);
-void pamu_free_subwins(int liodn);
 int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
 		       u32 omi, unsigned long rpn, u32 snoopid, uint32_t stashid,
-		       u32 subwin_cnt, int prot);
-int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
-		       phys_addr_t subwin_size, u32 omi, unsigned long rpn,
-		       uint32_t snoopid, u32 stashid, int enable, int prot);
+		       int prot);
 
 u32 get_stash_id(u32 stash_dest_hint, u32 vcpu);
 void get_ome_index(u32 *omi_index, struct device *dev);
-int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value);
-int pamu_disable_spaace(int liodn, u32 subwin);
-u32 pamu_get_max_subwin_cnt(void);
+int  pamu_update_paace_stash(int liodn, u32 value);
 
 #endif  /* __FSL_PAMU_H */
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index a4da5597755d3d..e6bdd38fc18409 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -56,65 +56,19 @@ static int __init iommu_init_mempool(void)
 
 static phys_addr_t get_phys_addr(struct fsl_dma_domain *dma_domain, dma_addr_t iova)
 {
-	u32 win_cnt = dma_domain->win_cnt;
 	struct dma_window *win_ptr = &dma_domain->win_arr[0];
 	struct iommu_domain_geometry *geom;
 
 	geom = &dma_domain->iommu_domain.geometry;
 
-	if (!win_cnt) {
-		pr_debug("Number of windows/geometry not configured for the domain\n");
-		return 0;
-	}
-
-	if (win_cnt > 1) {
-		u64 subwin_size;
-		dma_addr_t subwin_iova;
-		u32 wnd;
-
-		subwin_size = (geom->aperture_end + 1) >> ilog2(win_cnt);
-		subwin_iova = iova & ~(subwin_size - 1);
-		wnd = (subwin_iova - geom->aperture_start) >> ilog2(subwin_size);
-		win_ptr = &dma_domain->win_arr[wnd];
-	}
-
 	if (win_ptr->valid)
 		return win_ptr->paddr + (iova & (win_ptr->size - 1));
 
 	return 0;
 }
 
-static int map_subwins(int liodn, struct fsl_dma_domain *dma_domain)
-{
-	struct dma_window *sub_win_ptr = &dma_domain->win_arr[0];
-	int i, ret;
-	unsigned long rpn, flags;
-
-	for (i = 0; i < dma_domain->win_cnt; i++) {
-		if (sub_win_ptr[i].valid) {
-			rpn = sub_win_ptr[i].paddr >> PAMU_PAGE_SHIFT;
-			spin_lock_irqsave(&iommu_lock, flags);
-			ret = pamu_config_spaace(liodn, dma_domain->win_cnt, i,
-						 sub_win_ptr[i].size,
-						 ~(u32)0,
-						 rpn,
-						 dma_domain->snoop_id,
-						 dma_domain->stash_id,
-						 (i > 0) ? 1 : 0,
-						 sub_win_ptr[i].prot);
-			spin_unlock_irqrestore(&iommu_lock, flags);
-			if (ret) {
-				pr_debug("SPAACE configuration failed for liodn %d\n",
-					 liodn);
-				return ret;
-			}
-		}
-	}
-
-	return ret;
-}
-
-static int map_win(int liodn, struct fsl_dma_domain *dma_domain)
+/* Map the DMA window corresponding to the LIODN */
+static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
 {
 	int ret;
 	struct dma_window *wnd = &dma_domain->win_arr[0];
@@ -127,7 +81,7 @@ static int map_win(int liodn, struct fsl_dma_domain *dma_domain)
 				 ~(u32)0,
 				 wnd->paddr >> PAMU_PAGE_SHIFT,
 				 dma_domain->snoop_id, dma_domain->stash_id,
-				 0, wnd->prot);
+				 wnd->prot);
 	spin_unlock_irqrestore(&iommu_lock, flags);
 	if (ret)
 		pr_debug("PAACE configuration failed for liodn %d\n", liodn);
@@ -135,50 +89,27 @@ static int map_win(int liodn, struct fsl_dma_domain *dma_domain)
 	return ret;
 }
 
-/* Map the DMA window corresponding to the LIODN */
-static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
-{
-	if (dma_domain->win_cnt > 1)
-		return map_subwins(liodn, dma_domain);
-	else
-		return map_win(liodn, dma_domain);
-}
-
 /* Update window/subwindow mapping for the LIODN */
 static int update_liodn(int liodn, struct fsl_dma_domain *dma_domain, u32 wnd_nr)
 {
 	int ret;
 	struct dma_window *wnd = &dma_domain->win_arr[wnd_nr];
+	phys_addr_t wnd_addr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_lock, flags);
-	if (dma_domain->win_cnt > 1) {
-		ret = pamu_config_spaace(liodn, dma_domain->win_cnt, wnd_nr,
-					 wnd->size,
-					 ~(u32)0,
-					 wnd->paddr >> PAMU_PAGE_SHIFT,
-					 dma_domain->snoop_id,
-					 dma_domain->stash_id,
-					 (wnd_nr > 0) ? 1 : 0,
-					 wnd->prot);
-		if (ret)
-			pr_debug("Subwindow reconfiguration failed for liodn %d\n",
-				 liodn);
-	} else {
-		phys_addr_t wnd_addr;
 
-		wnd_addr = dma_domain->iommu_domain.geometry.aperture_start;
+	wnd_addr = dma_domain->iommu_domain.geometry.aperture_start;
 
-		ret = pamu_config_ppaace(liodn, wnd_addr,
-					 wnd->size,
-					 ~(u32)0,
-					 wnd->paddr >> PAMU_PAGE_SHIFT,
-					 dma_domain->snoop_id, dma_domain->stash_id,
-					 0, wnd->prot);
-		if (ret)
-			pr_debug("Window reconfiguration failed for liodn %d\n",
-				 liodn);
-	}
+	ret = pamu_config_ppaace(liodn, wnd_addr,
+				 wnd->size,
+				 ~(u32)0,
+				 wnd->paddr >> PAMU_PAGE_SHIFT,
+				 dma_domain->snoop_id, dma_domain->stash_id,
+				 wnd->prot);
+	if (ret)
+		pr_debug("Window reconfiguration failed for liodn %d\n",
+			 liodn);
 
 	spin_unlock_irqrestore(&iommu_lock, flags);
 
@@ -192,21 +123,12 @@ static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_lock, flags);
-	if (!dma_domain->win_arr) {
-		pr_debug("Windows not configured, stash destination update failed for liodn %d\n",
-			 liodn);
+	ret = pamu_update_paace_stash(liodn, val);
+	if (ret) {
+		pr_debug("Failed to update SPAACE %d field for liodn %d\n ",
+			 i, liodn);
 		spin_unlock_irqrestore(&iommu_lock, flags);
-		return -EINVAL;
-	}
-
-	for (i = 0; i < dma_domain->win_cnt; i++) {
-		ret = pamu_update_paace_stash(liodn, i, val);
-		if (ret) {
-			pr_debug("Failed to update SPAACE %d field for liodn %d\n ",
-				 i, liodn);
-			spin_unlock_irqrestore(&iommu_lock, flags);
-			return ret;
-		}
+		return ret;
 	}
 
 	spin_unlock_irqrestore(&iommu_lock, flags);
@@ -217,14 +139,12 @@ static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
 /* Set the geometry parameters for a LIODN */
 static int pamu_set_liodn(int liodn, struct device *dev,
 			  struct fsl_dma_domain *dma_domain,
-			  struct iommu_domain_geometry *geom_attr,
-			  u32 win_cnt)
+			  struct iommu_domain_geometry *geom_attr)
 {
 	phys_addr_t window_addr, window_size;
-	phys_addr_t subwin_size;
-	int ret = 0, i;
 	u32 omi_index = ~(u32)0;
 	unsigned long flags;
+	int ret;
 
 	/*
 	 * Configure the omi_index at the geometry setup time.
@@ -241,34 +161,14 @@ static int pamu_set_liodn(int liodn, struct device *dev,
 	if (!ret)
 		ret = pamu_config_ppaace(liodn, window_addr, window_size, omi_index,
 					 0, dma_domain->snoop_id,
-					 dma_domain->stash_id, win_cnt, 0);
+					 dma_domain->stash_id, 0);
 	spin_unlock_irqrestore(&iommu_lock, flags);
 	if (ret) {
-		pr_debug("PAACE configuration failed for liodn %d, win_cnt =%d\n",
-			 liodn, win_cnt);
+		pr_debug("PAACE configuration failed for liodn %d\n",
+			 liodn);
 		return ret;
 	}
 
-	if (win_cnt > 1) {
-		subwin_size = window_size >> ilog2(win_cnt);
-		for (i = 0; i < win_cnt; i++) {
-			spin_lock_irqsave(&iommu_lock, flags);
-			ret = pamu_disable_spaace(liodn, i);
-			if (!ret)
-				ret = pamu_config_spaace(liodn, win_cnt, i,
-							 subwin_size, omi_index,
-							 0, dma_domain->snoop_id,
-							 dma_domain->stash_id,
-							 0, 0);
-			spin_unlock_irqrestore(&iommu_lock, flags);
-			if (ret) {
-				pr_debug("SPAACE configuration failed for liodn %d\n",
-					 liodn);
-				return ret;
-			}
-		}
-	}
-
 	return ret;
 }
 
@@ -292,14 +192,12 @@ static int check_size(u64 size, dma_addr_t iova)
 	return 0;
 }
 
-static void remove_device_ref(struct device_domain_info *info, u32 win_cnt)
+static void remove_device_ref(struct device_domain_info *info)
 {
 	unsigned long flags;
 
 	list_del(&info->link);
 	spin_lock_irqsave(&iommu_lock, flags);
-	if (win_cnt > 1)
-		pamu_free_subwins(info->liodn);
 	pamu_disable_liodn(info->liodn);
 	spin_unlock_irqrestore(&iommu_lock, flags);
 	spin_lock_irqsave(&device_domain_lock, flags);
@@ -317,7 +215,7 @@ static void detach_device(struct device *dev, struct fsl_dma_domain *dma_domain)
 	/* Remove the device from the domain device list */
 	list_for_each_entry_safe(info, tmp, &dma_domain->devices, link) {
 		if (!dev || (info->dev == dev))
-			remove_device_ref(info, dma_domain->win_cnt);
+			remove_device_ref(info);
 	}
 	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
 }
@@ -399,7 +297,6 @@ static struct iommu_domain *fsl_pamu_domain_alloc(unsigned type)
 
 	dma_domain->stash_id = ~(u32)0;
 	dma_domain->snoop_id = ~(u32)0;
-	dma_domain->win_cnt = pamu_get_max_subwin_cnt();
 	INIT_LIST_HEAD(&dma_domain->devices);
 	spin_lock_init(&dma_domain->domain_lock);
 
@@ -411,24 +308,6 @@ static struct iommu_domain *fsl_pamu_domain_alloc(unsigned type)
 	return &dma_domain->iommu_domain;
 }
 
-/* Configure geometry settings for all LIODNs associated with domain */
-static int pamu_set_domain_geometry(struct fsl_dma_domain *dma_domain,
-				    struct iommu_domain_geometry *geom_attr,
-				    u32 win_cnt)
-{
-	struct device_domain_info *info;
-	int ret = 0;
-
-	list_for_each_entry(info, &dma_domain->devices, link) {
-		ret = pamu_set_liodn(info->liodn, info->dev, dma_domain,
-				     geom_attr, win_cnt);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 /* Update stash destination for all LIODNs associated with the domain */
 static int update_domain_stash(struct fsl_dma_domain *dma_domain, u32 val)
 {
@@ -475,39 +354,30 @@ static int fsl_pamu_window_enable(struct iommu_domain *domain, u32 wnd_nr,
 		pamu_prot |= PAACE_AP_PERMS_UPDATE;
 
 	spin_lock_irqsave(&dma_domain->domain_lock, flags);
-	if (!dma_domain->win_arr) {
-		pr_debug("Number of windows not configured\n");
-		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-		return -ENODEV;
-	}
-
-	if (wnd_nr >= dma_domain->win_cnt) {
+	if (wnd_nr > 0) {
 		pr_debug("Invalid window index\n");
 		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
 		return -EINVAL;
 	}
 
-	win_size = (domain->geometry.aperture_end + 1) >>
-			ilog2(dma_domain->win_cnt);
+	win_size = (domain->geometry.aperture_end + 1) >> ilog2(1);
 	if (size > win_size) {
 		pr_debug("Invalid window size\n");
 		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
 		return -EINVAL;
 	}
 
-	if (dma_domain->win_cnt == 1) {
-		if (dma_domain->enabled) {
-			pr_debug("Disable the window before updating the mapping\n");
-			spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-			return -EBUSY;
-		}
+	if (dma_domain->enabled) {
+		pr_debug("Disable the window before updating the mapping\n");
+		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+		return -EBUSY;
+	}
 
-		ret = check_size(size, domain->geometry.aperture_start);
-		if (ret) {
-			pr_debug("Aperture start not aligned to the size\n");
-			spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-			return -EINVAL;
-		}
+	ret = check_size(size, domain->geometry.aperture_start);
+	if (ret) {
+		pr_debug("Aperture start not aligned to the size\n");
+		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
+		return -EINVAL;
 	}
 
 	wnd = &dma_domain->win_arr[wnd_nr];
@@ -560,22 +430,18 @@ static int handle_attach_device(struct fsl_dma_domain *dma_domain,
 		 * for the domain. If yes, set the geometry for
 		 * the LIODN.
 		 */
-		if (dma_domain->win_arr) {
-			u32 win_cnt = dma_domain->win_cnt > 1 ? dma_domain->win_cnt : 0;
-
-			ret = pamu_set_liodn(liodn[i], dev, dma_domain,
-					     &domain->geometry, win_cnt);
+		ret = pamu_set_liodn(liodn[i], dev, dma_domain,
+				     &domain->geometry);
+		if (ret)
+			break;
+		if (dma_domain->mapped) {
+			/*
+			 * Create window/subwindow mapping for
+			 * the LIODN.
+			 */
+			ret = map_liodn(liodn[i], dma_domain);
 			if (ret)
 				break;
-			if (dma_domain->mapped) {
-				/*
-				 * Create window/subwindow mapping for
-				 * the LIODN.
-				 */
-				ret = map_liodn(liodn[i], dma_domain);
-				if (ret)
-					break;
-			}
 		}
 	}
 	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
@@ -706,48 +572,6 @@ static int configure_domain_dma_state(struct fsl_dma_domain *dma_domain, bool en
 	return 0;
 }
 
-static int fsl_pamu_set_windows(struct iommu_domain *domain, u32 w_count)
-{
-	struct fsl_dma_domain *dma_domain = to_fsl_dma_domain(domain);
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&dma_domain->domain_lock, flags);
-	/* Ensure domain is inactive i.e. DMA should be disabled for the domain */
-	if (dma_domain->enabled) {
-		pr_debug("Can't set geometry attributes as domain is active\n");
-		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-		return  -EBUSY;
-	}
-
-	/*
-	 * Ensure we have valid window count i.e. it should be less than
-	 * maximum permissible limit and should be a power of two.
-	 */
-	if (w_count > pamu_get_max_subwin_cnt() || !is_power_of_2(w_count)) {
-		pr_debug("Invalid window count\n");
-		spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-		return -EINVAL;
-	}
-
-	ret = pamu_set_domain_geometry(dma_domain, &domain->geometry,
-				       w_count > 1 ? w_count : 0);
-	if (!ret) {
-		kfree(dma_domain->win_arr);
-		dma_domain->win_arr = kcalloc(w_count,
-					      sizeof(*dma_domain->win_arr),
-					      GFP_ATOMIC);
-		if (!dma_domain->win_arr) {
-			spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-			return -ENOMEM;
-		}
-		dma_domain->win_cnt = w_count;
-	}
-	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-
-	return ret;
-}
-
 static int fsl_pamu_set_domain_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr_type, void *data)
 {
@@ -761,9 +585,6 @@ static int fsl_pamu_set_domain_attr(struct iommu_domain *domain,
 	case DOMAIN_ATTR_FSL_PAMU_ENABLE:
 		ret = configure_domain_dma_state(dma_domain, *(int *)data);
 		break;
-	case DOMAIN_ATTR_WINDOWS:
-		ret = fsl_pamu_set_windows(domain, *(u32 *)data);
-		break;
 	default:
 		pr_debug("Unsupported attribute type\n");
 		ret = -EINVAL;
diff --git a/drivers/iommu/fsl_pamu_domain.h b/drivers/iommu/fsl_pamu_domain.h
index 53d359d66fe577..b9236fb5a8f82e 100644
--- a/drivers/iommu/fsl_pamu_domain.h
+++ b/drivers/iommu/fsl_pamu_domain.h
@@ -17,23 +17,13 @@ struct dma_window {
 };
 
 struct fsl_dma_domain {
-	/*
-	 * Number of windows assocaited with this domain.
-	 * During domain initialization, it is set to the
-	 * the maximum number of subwindows allowed for a LIODN.
-	 * Minimum value for this is 1 indicating a single PAMU
-	 * window, without any sub windows. Value can be set/
-	 * queried by set_attr/get_attr API for DOMAIN_ATTR_WINDOWS.
-	 * Value can only be set once the geometry has been configured.
-	 */
-	u32				win_cnt;
 	/*
 	 * win_arr contains information of the configured
 	 * windows for a domain. This is allocated only
 	 * when the number of windows for the domain are
 	 * set.
 	 */
-	struct dma_window		*win_arr;
+	struct dma_window		win_arr[1];
 	/* list of devices associated with the domain */
 	struct list_head		devices;
 	/* dma_domain states:
diff --git a/drivers/soc/fsl/qbman/qman_portal.c b/drivers/soc/fsl/qbman/qman_portal.c
index c958e6310d3094..3d56ec4b373b4b 100644
--- a/drivers/soc/fsl/qbman/qman_portal.c
+++ b/drivers/soc/fsl/qbman/qman_portal.c
@@ -55,13 +55,6 @@ static void portal_set_cpu(struct qm_portal_config *pcfg, int cpu)
 		dev_err(dev, "%s(): iommu_domain_alloc() failed", __func__);
 		goto no_iommu;
 	}
-	ret = iommu_domain_set_attr(pcfg->iommu_domain, DOMAIN_ATTR_WINDOWS,
-				    &window_count);
-	if (ret < 0) {
-		dev_err(dev, "%s(): iommu_domain_set_attr() = %d", __func__,
-			ret);
-		goto out_domain_free;
-	}
 	stash_attr.cpu = cpu;
 	stash_attr.cache = PAMU_ATTR_CACHE_L1;
 	ret = iommu_domain_set_attr(pcfg->iommu_domain,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 52874ae164dd60..861c3558c878bf 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -109,7 +109,6 @@ enum iommu_cap {
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
 	DOMAIN_ATTR_PAGING,
-	DOMAIN_ATTR_WINDOWS,
 	DOMAIN_ATTR_FSL_PAMU_STASH,
 	DOMAIN_ATTR_FSL_PAMU_ENABLE,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
-- 
2.29.2

