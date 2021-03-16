Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9346033D82E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhCPPvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:51:14 -0400
Received: from casper.infradead.org ([90.155.50.34]:39362 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhCPPup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Rw7EzDJS9qw2BQD9ybEsSVHRfrLN5SOhcMfS8kp3ZR4=; b=wO7ZBevcmjJiemSBKSjj4uO268
        KqJjDeIav31h0tTKUvZY27AJEWA560Wj1p1l7UTBYcz0BJeAWkWkkj5/a1W5iB7YfMtLZf8M8gMaa
        xcDgkI08ipECOG9nTB20LOf/J9+jK3qQEtY/V3t/8aSV6+08iXjATWpqr+QbwLUGVms6zRsknZvJ/
        ZaDj8FDBcaN1W2C6pr67cBD62CEjgDK2SWIwU0tGjHa1RVqOPIAc/XXh0xcHou91+QUcif3YjGYh7
        Q5ME8Giltlt3gHu2jbcEhyzpf0o6GtJ/+A+TkQf0ew6b8UPFPRnnH6a5BlhMY/DtVyqZbylYs0nzz
        tWRpCaLg==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMBxO-000GJk-5v; Tue, 16 Mar 2021 15:50:08 +0000
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
Subject: [PATCH 04/18] iommu/fsl_pamu: merge iommu_alloc_dma_domain into fsl_pamu_domain_alloc
Date:   Tue, 16 Mar 2021 16:38:10 +0100
Message-Id: <20210316153825.135976-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep the functionality to allocate the domain together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/fsl_pamu_domain.c | 34 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 7bd08ddad07779..a4da5597755d3d 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -292,25 +292,6 @@ static int check_size(u64 size, dma_addr_t iova)
 	return 0;
 }
 
-static struct fsl_dma_domain *iommu_alloc_dma_domain(void)
-{
-	struct fsl_dma_domain *domain;
-
-	domain = kmem_cache_zalloc(fsl_pamu_domain_cache, GFP_KERNEL);
-	if (!domain)
-		return NULL;
-
-	domain->stash_id = ~(u32)0;
-	domain->snoop_id = ~(u32)0;
-	domain->win_cnt = pamu_get_max_subwin_cnt();
-
-	INIT_LIST_HEAD(&domain->devices);
-
-	spin_lock_init(&domain->domain_lock);
-
-	return domain;
-}
-
 static void remove_device_ref(struct device_domain_info *info, u32 win_cnt)
 {
 	unsigned long flags;
@@ -412,12 +393,17 @@ static struct iommu_domain *fsl_pamu_domain_alloc(unsigned type)
 	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
-	dma_domain = iommu_alloc_dma_domain();
-	if (!dma_domain) {
-		pr_debug("dma_domain allocation failed\n");
+	dma_domain = kmem_cache_zalloc(fsl_pamu_domain_cache, GFP_KERNEL);
+	if (!dma_domain)
 		return NULL;
-	}
-	/* defaul geometry 64 GB i.e. maximum system address */
+
+	dma_domain->stash_id = ~(u32)0;
+	dma_domain->snoop_id = ~(u32)0;
+	dma_domain->win_cnt = pamu_get_max_subwin_cnt();
+	INIT_LIST_HEAD(&dma_domain->devices);
+	spin_lock_init(&dma_domain->domain_lock);
+
+	/* default geometry 64 GB i.e. maximum system address */
 	dma_domain->iommu_domain. geometry.aperture_start = 0;
 	dma_domain->iommu_domain.geometry.aperture_end = (1ULL << 36) - 1;
 	dma_domain->iommu_domain.geometry.force_aperture = true;
-- 
2.30.1

