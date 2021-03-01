Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CE13279F9
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhCAIvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbhCAIs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:48:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1745EC061756;
        Mon,  1 Mar 2021 00:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=E7hhcteK4GUQFY9xJ3UXZHBinl63OJRSjslBjH5SJ4o=; b=O9MMPi8P/b5H+w4VoMI8YihaaA
        BPVU5aXQqLQQj97pJgAx+OanvHJgHAHYqG4osgFX4FdkSeUoiQALMA1zpxM3LhNUWq3j7RlE2zhlk
        nXQdh9z5M0xgAycaeWyvFMu0U+yIpNcghIBVN+93bMa5oiFMW7ZrNJAMZy5s5wHwSaUHY3AQbHUV4
        EzSgaqp7xRzOBYqhRo+qswdIUSKXlm1J1ykAVaj1SYP5j2D+2STDtXcLCbdZly0NivQpFDcLiRa74
        OEGlXEz38hVpN6W99EJhHgrab4vvXFmNjp/2m1XhY13n93ZuU0UJFPJ+YZjk+7mdiNYaKVziqbUCz
        DqT4a2zA==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGeD0-00FUqj-3N; Mon, 01 Mar 2021 08:47:26 +0000
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
Subject: [PATCH 12/17] iommu: remove DOMAIN_ATTR_PAGING
Date:   Mon,  1 Mar 2021 09:42:52 +0100
Message-Id: <20210301084257.945454-13-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301084257.945454-1-hch@lst.de>
References: <20210301084257.945454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DOMAIN_ATTR_PAGING is never used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/iommu.c | 5 -----
 include/linux/iommu.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b212bf0261820b..9a4cda390993e6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2668,7 +2668,6 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
 	struct iommu_domain_geometry *geometry;
-	bool *paging;
 	int ret = 0;
 
 	switch (attr) {
@@ -2676,10 +2675,6 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 		geometry  = data;
 		*geometry = domain->geometry;
 
-		break;
-	case DOMAIN_ATTR_PAGING:
-		paging  = data;
-		*paging = (domain->pgsize_bitmap != 0UL);
 		break;
 	default:
 		if (!domain->ops->domain_get_attr)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 840864844027dc..180ff4bd7fa7ef 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -108,7 +108,6 @@ enum iommu_cap {
 
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
-	DOMAIN_ATTR_PAGING,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
-- 
2.29.2

