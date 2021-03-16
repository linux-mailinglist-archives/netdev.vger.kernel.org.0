Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC92E33D8ED
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhCPQRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:17:12 -0400
Received: from casper.infradead.org ([90.155.50.34]:42668 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhCPQQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WCctDB3aBbf47gvZbBBbXOyUY2tUO8VwmVGAxmrB6lU=; b=deUFeS00cyCtv1K6xdoQSBzs4S
        7apA+k0/2Zd4K9E+AeMCsc956KeepRkBycFxEG3F8Jv0WfGepxghziwaNXRJ+v20OzB47kpRopAdb
        e+1HmVPyZkCrvobyhdR3rdoz+wXNzxMJDua55Srn/1/QUceh815wN2VdiZqOjL0lr0H+9B3MRsZUV
        U6cKSNMU2rIqN2QhWBYqpmkQfw9FC32BDpB4IN/VnP2We0InqV++LUWq5YL5XJeHWBTcH/xcoIqZ6
        ccTQtKNy8c7DoTlE7lDlAshX09CXkw8OMgMUKouRXb+I7Nptovh5syzrtPhBk1n9VlPqDPsS39xOx
        ssSAD9jw==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMCMY-000IT2-QA; Tue, 16 Mar 2021 16:16:09 +0000
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
Subject: [PATCH 15/18] iommu: remove iommu_set_cmd_line_dma_api and iommu_cmd_line_dma_api
Date:   Tue, 16 Mar 2021 16:38:21 +0100
Message-Id: <20210316153825.135976-16-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't obsfucate the trivial bit flag check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

