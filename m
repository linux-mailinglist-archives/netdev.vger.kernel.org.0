Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBF926B14E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgIOW2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgIOQTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:19:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7770AC061788;
        Tue, 15 Sep 2020 09:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eona0AYiSh/znPkSOpw3Nw8CD1xNwL4V1h0yfTAB4Hk=; b=Wsus/ivqm8grfYeSP6z68xdX1x
        /cIm0jtfGbhk+VmVtqSQ/iY5d+5djYDyuxa98INla0l2ETi1N1/0w3Ed/q3rtAKOzQ3uqj19Eys1O
        +6nIyWduDpAErX2tZFPICqd6V05JwBWMeGOCnu6ggpHA8J1vk4TnT/p8eBFTfM5QUctfAAYPHJkgk
        5jWuDY2Vb2n+Cu977sssSRrWhpE1cTmcpeCYbGl08RhkwlS2gldOQ+gcQVR3AT//4wh6UZmOTq9nY
        mGq2nXZFdSXvf0xLyK6EEBxoSCZuO0CLFHLLqiBlPkIg92/ahUA3uyJSYhU6hc5HQjGFSIktXN22R
        m3mk/5qQ==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDNH-0003mr-4Y; Tue, 15 Sep 2020 16:00:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 03/18] drm/exynos: stop setting DMA_ATTR_NON_CONSISTENT
Date:   Tue, 15 Sep 2020 17:51:07 +0200
Message-Id: <20200915155122.1768241-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915155122.1768241-1-hch@lst.de>
References: <20200915155122.1768241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA_ATTR_NON_CONSISTENT is a no-op except on PA-RISC and a few MIPS
configs, so don't set it in this ARM specific driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/exynos/exynos_drm_gem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index efa476858db54b..07073222b8f691 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -42,8 +42,6 @@ static int exynos_drm_alloc_buf(struct exynos_drm_gem *exynos_gem, bool kvmap)
 	if (exynos_gem->flags & EXYNOS_BO_WC ||
 			!(exynos_gem->flags & EXYNOS_BO_CACHABLE))
 		attr |= DMA_ATTR_WRITE_COMBINE;
-	else
-		attr |= DMA_ATTR_NON_CONSISTENT;
 
 	/* FBDev emulation requires kernel mapping */
 	if (!kvmap)
-- 
2.28.0

