Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6372351C2D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhDASNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhDASKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:10:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55874C02D575;
        Thu,  1 Apr 2021 08:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wDCpF7eA/jBfJE8TX4WtMtbQcLjyYKphl/5zM+AMN4E=; b=LafK1H4R5CszpawGybodA4QlYz
        djVgVU7nIHYvARbHMtDR3EViy1Cet1N99EQ8Dpy2YiA/KdQtX2BL9Ibiaz0GzoEKwBm0OQxKgWvrl
        mRD7LaUUdCMLrEZblY5EfqmwSCY3BG94IqbKCTD7u8gHB8BJBKXa/98vOrZjoVjOr29NM+ce+aQvZ
        bRd8eyGos7K86FuEDzsy8MzyBCYjmeW61WRBRaoCGKQSTPhZ7lFlZV+2F281ghBIfX40mdPPWC5wP
        +zgDAbAslIshmHmj8X0iesvI5VzGb22t7SAWXCi5XrNYxl1XQGFmhYVbB9YzUdnx62zCxWaFhlLKe
        6ATDquqQ==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzda-00CicQ-Q4; Thu, 01 Apr 2021 15:53:39 +0000
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
Subject: [PATCH 11/20] iommu/fsl_pamu: remove the snoop_id field
Date:   Thu,  1 Apr 2021 17:52:47 +0200
Message-Id: <20210401155256.298656-12-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The snoop_id is always set to ~(u32)0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/fsl_pamu_domain.c | 5 ++---
 drivers/iommu/fsl_pamu_domain.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index c2e7e17570e76d..e9c1e0dd68f084 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -97,12 +97,12 @@ static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
 		goto out_unlock;
 	ret = pamu_config_ppaace(liodn, geom->aperture_start,
 				 geom->aperture_end + 1, omi_index, 0,
-				 dma_domain->snoop_id, dma_domain->stash_id, 0);
+				 ~(u32)0, dma_domain->stash_id, 0);
 	if (ret)
 		goto out_unlock;
 	ret = pamu_config_ppaace(liodn, geom->aperture_start,
 				 geom->aperture_end + 1, ~(u32)0,
-				 0, dma_domain->snoop_id, dma_domain->stash_id,
+				 0, ~(u32)0, dma_domain->stash_id,
 				 PAACE_AP_PERMS_QUERY | PAACE_AP_PERMS_UPDATE);
 out_unlock:
 	spin_unlock_irqrestore(&iommu_lock, flags);
@@ -210,7 +210,6 @@ static struct iommu_domain *fsl_pamu_domain_alloc(unsigned type)
 		return NULL;
 
 	dma_domain->stash_id = ~(u32)0;
-	dma_domain->snoop_id = ~(u32)0;
 	INIT_LIST_HEAD(&dma_domain->devices);
 	spin_lock_init(&dma_domain->domain_lock);
 
diff --git a/drivers/iommu/fsl_pamu_domain.h b/drivers/iommu/fsl_pamu_domain.h
index 5f4ed253f61b31..95ac1b3cab3b69 100644
--- a/drivers/iommu/fsl_pamu_domain.h
+++ b/drivers/iommu/fsl_pamu_domain.h
@@ -13,7 +13,6 @@ struct fsl_dma_domain {
 	/* list of devices associated with the domain */
 	struct list_head		devices;
 	u32				stash_id;
-	u32				snoop_id;
 	struct iommu_domain		iommu_domain;
 	spinlock_t			domain_lock;
 };
-- 
2.30.1

