Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3082495E0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHSG7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgHSG5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:57:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CEEC061389;
        Tue, 18 Aug 2020 23:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=n4jQXphtlWRBonOsn2A/IyhKyng5urQ9vpv5ufSXxPk=; b=KZRDty0LVAb6IYb2EgXMMhn/94
        SNEs4mh9p9rnpC99fbEF92zB0m3D7WvJjRrv50NXQbUGZKAsDefMFkOeLXMlu5DGet/i0Q9+pl76I
        aaliGVgEvwT5cxt1TbyaDjkrLykaxId7hOxXC+ZOaJy8uANKWgBSuv8uzKG0dIz02N2Wnv5H5ODMi
        ttApx1YRztY1G2Z8kh2b2znxpwj3fI2l7IbnOPpFlIj5pd/gOp3ou9Ec/tRlwpM24x+nOxNVfmTEW
        S+hiYJx3yCvEXbP8d1qXwPlzIa+qdIhtu9aJV1TdaM8Wtl9rPhU5pdy8P2ws0LiXUnHKn5IwFwvO7
        bsGbSO+A==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1u-00007J-2i; Wed, 19 Aug 2020 06:57:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 27/28] nvme-pci: fix PRP pool size
Date:   Wed, 19 Aug 2020 08:55:54 +0200
Message-Id: <20200819065555.1802761-28-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All operations are based on the controller, not the host page size.
Switch the dma pool to use the controller page size as well to avoid
massive overallocations on large page size systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ba725ae47305ef..a33adab62acbaf 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2460,7 +2460,8 @@ static int nvme_disable_prepare_reset(struct nvme_dev *dev, bool shutdown)
 static int nvme_setup_prp_pools(struct nvme_dev *dev)
 {
 	dev->prp_page_pool = dma_pool_create("prp list page", dev->dev,
-						PAGE_SIZE, PAGE_SIZE, 0);
+						NVME_CTRL_PAGE_SIZE,
+						NVME_CTRL_PAGE_SIZE, 0);
 	if (!dev->prp_page_pool)
 		return -ENOMEM;
 
-- 
2.28.0

