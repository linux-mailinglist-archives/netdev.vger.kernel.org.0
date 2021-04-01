Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F15035180C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhDARnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbhDARk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:40:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091AEC02D57B;
        Thu,  1 Apr 2021 08:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=g/lYlQLJmKIelbYGsJOMK8K3baqJu4KrHdTwHylUH98=; b=yk7zp4/a/VVy/qjNyBy+25HhKE
        M3MLuAAEGCHkhoP6K+6R5Jrd2o9QTpPa/n+D+jPbw8PfF0Hj+LlRVl4uxYQG9l3BZZ+4dc5I8r9e2
        IjqvjarJiebl1F9i4ul0iOVUIzj1oDsJXbYJ2qkBZ0gl0i5I6XA+OeaYxW2MRRFfMRRV32/ae8F5J
        dDH6vXR/maOTz6DfB53SyQcBbg8iRcUEK8qYomkv4uD4P3cJvtU6CBHm5BwRr30BFkiHIqeNzDoDA
        LbAzmQekckWvz0YH4pL5dkKd9Izu6Dwi1ld24zxZdieLRhcx6J9vWJ1Ig/OL/cF1UeinsSVUXpGco
        +Rs+TVvQ==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzdr-00Ciee-IE; Thu, 01 Apr 2021 15:53:56 +0000
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
Subject: [PATCH 17/20] iommu: remove iommu_set_cmd_line_dma_api and iommu_cmd_line_dma_api
Date:   Thu,  1 Apr 2021 17:52:53 +0200
Message-Id: <20210401155256.298656-18-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210401155256.298656-1-hch@lst.de>
References: <20210401155256.298656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't obsfucate the trivial bit flag check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Will Deacon <will@kernel.org>
---
 drivers/iommu/iommu.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 58d1d11a8d5c10..052cef11ae30df 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -70,16 +70,6 @@ static const char * const iommu_group_resv_type_string[] = {
 
 #define IOMMU_CMD_LINE_DMA_API		BIT(0)
 
-static void iommu_set_cmd_line_dma_api(void)
-{
-	iommu_cmd_line |= IOMMU_CMD_LINE_DMA_API;
-}
-
-static bool iommu_cmd_line_dma_api(void)
-{
-	return !!(iommu_cmd_line & IOMMU_CMD_LINE_DMA_API);
-}
-
 static int iommu_alloc_default_domain(struct iommu_group *group,
 				      struct device *dev);
 static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
@@ -130,9 +120,7 @@ static const char *iommu_domain_type_str(unsigned int t)
 
 static int __init iommu_subsys_init(void)
 {
-	bool cmd_line = iommu_cmd_line_dma_api();
-
-	if (!cmd_line) {
+	if (!(iommu_cmd_line & IOMMU_CMD_LINE_DMA_API)) {
 		if (IS_ENABLED(CONFIG_IOMMU_DEFAULT_PASSTHROUGH))
 			iommu_set_default_passthrough(false);
 		else
@@ -146,7 +134,8 @@ static int __init iommu_subsys_init(void)
 
 	pr_info("Default domain type: %s %s\n",
 		iommu_domain_type_str(iommu_def_domain_type),
-		cmd_line ? "(set via kernel command line)" : "");
+		(iommu_cmd_line & IOMMU_CMD_LINE_DMA_API) ?
+			"(set via kernel command line)" : "");
 
 	return 0;
 }
@@ -2757,16 +2746,14 @@ EXPORT_SYMBOL_GPL(iommu_alloc_resv_region);
 void iommu_set_default_passthrough(bool cmd_line)
 {
 	if (cmd_line)
-		iommu_set_cmd_line_dma_api();
-
+		iommu_cmd_line |= IOMMU_CMD_LINE_DMA_API;
 	iommu_def_domain_type = IOMMU_DOMAIN_IDENTITY;
 }
 
 void iommu_set_default_translated(bool cmd_line)
 {
 	if (cmd_line)
-		iommu_set_cmd_line_dma_api();
-
+		iommu_cmd_line |= IOMMU_CMD_LINE_DMA_API;
 	iommu_def_domain_type = IOMMU_DOMAIN_DMA;
 }
 
-- 
2.30.1

