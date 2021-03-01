Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9143279F5
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhCAIuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhCAIrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:47:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ACEC06121F;
        Mon,  1 Mar 2021 00:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=xW3e/be0EWhcIVogSADJb6O7B/1UPJRMXZ1DHw7XToM=; b=DRyzqUvjLicdwyE1oaGJikVtBy
        aQDPW4RFib9iRVgCqH8O0asS8IXpzN1MHH3K1Lvt8ETu7k4NVb5fAeiqi+A1+q+gYgPxLjm2YcMEf
        zT+89mwG7MzZM59zy8lUpzNOFJBMeeXnAThdQsqWq1PfoWdcKEvQtvDb3zYowx/cXkI88HzFrnsX5
        b8tsOZx/4tAadAZuCY2pz9vC4gXg8gxRwyD72KPNVew+ScbpQxFgXIoEJSS+mVPMOmOBIxWnXQ7RQ
        tHCO/aZYKICm7c98vq7zV0y9eNRU0OKizoSsJUb1IYcwhG26q0Vb6JO70tamcp1BQHo5CYNqQtZcG
        kknH2w5g==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeBL-00FUjk-Ir; Mon, 01 Mar 2021 08:45:46 +0000
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
Subject: [PATCH 09/17] iommu/fsl_pamu: merge handle_attach_device into fsl_pamu_attach_device
Date:   Mon,  1 Mar 2021 09:42:49 +0100
Message-Id: <20210301084257.945454-10-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No good reason to split this functionality over two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/fsl_pamu_domain.c | 59 +++++++++++----------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 4a4944332674f7..962cdc1a4a1924 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -240,45 +240,13 @@ static int update_domain_stash(struct fsl_dma_domain *dma_domain, u32 val)
 	return ret;
 }
 
-/*
- * Attach the LIODN to the DMA domain and configure the geometry
- * and window mappings.
- */
-static int handle_attach_device(struct fsl_dma_domain *dma_domain,
-				struct device *dev, const u32 *liodn,
-				int num)
-{
-	unsigned long flags;
-	int ret = 0;
-	int i;
-
-	spin_lock_irqsave(&dma_domain->domain_lock, flags);
-	for (i = 0; i < num; i++) {
-		/* Ensure that LIODN value is valid */
-		if (liodn[i] >= PAACE_NUMBER_ENTRIES) {
-			pr_debug("Invalid liodn %d, attach device failed for %pOF\n",
-				 liodn[i], dev->of_node);
-			ret = -EINVAL;
-			break;
-		}
-
-		attach_device(dma_domain, liodn[i], dev);
-		ret = pamu_set_liodn(dma_domain, dev, liodn[i]);
-		if (ret)
-			break;
-	}
-	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
-
-	return ret;
-}
-
 static int fsl_pamu_attach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
 	struct fsl_dma_domain *dma_domain = to_fsl_dma_domain(domain);
+	unsigned long flags;
+	int len, ret = 0, i;
 	const u32 *liodn;
-	u32 liodn_cnt;
-	int len, ret = 0;
 	struct pci_dev *pdev = NULL;
 	struct pci_controller *pci_ctl;
 
@@ -298,14 +266,27 @@ static int fsl_pamu_attach_device(struct iommu_domain *domain,
 	}
 
 	liodn = of_get_property(dev->of_node, "fsl,liodn", &len);
-	if (liodn) {
-		liodn_cnt = len / sizeof(u32);
-		ret = handle_attach_device(dma_domain, dev, liodn, liodn_cnt);
-	} else {
+	if (!liodn) {
 		pr_debug("missing fsl,liodn property at %pOF\n", dev->of_node);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
+	spin_lock_irqsave(&dma_domain->domain_lock, flags);
+	for (i = 0; i < len / sizeof(u32); i++) {
+		/* Ensure that LIODN value is valid */
+		if (liodn[i] >= PAACE_NUMBER_ENTRIES) {
+			pr_debug("Invalid liodn %d, attach device failed for %pOF\n",
+				 liodn[i], dev->of_node);
+			ret = -EINVAL;
+			break;
+		}
+
+		attach_device(dma_domain, liodn[i], dev);
+		ret = pamu_set_liodn(dma_domain, dev, liodn[i]);
+		if (ret)
+			break;
+	}
+	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
 	return ret;
 }
 
-- 
2.29.2

