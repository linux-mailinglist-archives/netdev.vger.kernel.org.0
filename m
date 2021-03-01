Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EABC327A01
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhCAIwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhCAIsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:48:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F48DC06174A;
        Mon,  1 Mar 2021 00:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=usr7xT8HjEnq451z093KqRmLnxf+lOohzyPFd88RWYc=; b=qoX9vVxVZZKAyq7B5O0VZvcYtQ
        M1LLUOhp5PXNHx3LLs7t+kTFESYbZVnXg///4sLFsnDJ6YAc7sx0E7LxldOc05oZ4jRo0RlJu47tJ
        O5UwI4r8nvaAw6Z0ID0gcNv1Nq9526ZQx+GtA3BWS27srD8y+6L1slKHkvqYKmT2m0IJrfUORQB8m
        RV0AJLuqivIXh9zJINYtKgWsg8dzdoAzdIHhD2m4shGEwS3g3Oaate2Tpj+ohHthG9x/A1gd8m3t2
        VLK/BghVxmkGpZq6vvyOuutmdPOZZoaKtqLvAr6nn+FS8uyv936L4FUlVEI87OVFnB7SIfWkxVUDC
        HgObuMmw==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeCV-00FUoN-LS; Mon, 01 Mar 2021 08:46:52 +0000
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
Subject: [PATCH 11/17] iommu/fsl_pamu: remove the snoop_id field
Date:   Mon,  1 Mar 2021 09:42:51 +0100
Message-Id: <20210301084257.945454-12-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The snoop_id is always set to ~(u32)0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/fsl_pamu_domain.c | 5 ++---
 drivers/iommu/fsl_pamu_domain.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 21c6d9e79eddf9..701fc3f187a100 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -97,12 +97,12 @@ static int pamu_set_liodn(struct fsl_dma_domain *dma_domain, struct device *dev,
 		goto out_unlock;
 	ret = pamu_config_ppaace(liodn, geom->aperture_start,
 				 geom->aperture_end - 1, omi_index, 0,
-				 dma_domain->snoop_id, dma_domain->stash_id, 0);
+				 ~(u32)0, dma_domain->stash_id, 0);
 	if (ret)
 		goto out_unlock;
 	ret = pamu_config_ppaace(liodn, geom->aperture_start,
 				 geom->aperture_end - 1, ~(u32)0,
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
2.29.2

