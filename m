Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB945EF5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfFNNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbfFNNsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GC9Gboqptsed7WVs/myU7Q6vnMi9vBxIwQ2uPA5D0pw=; b=UntrdW5G2+b49vgfbJaGUDLN0E
        6yE3PpGKvsuDOwoXcyXIdlGC5PZ5Rx2/rsrnwuL8rTHEvIhh9QW1GU17v1tVNFho0ne9tn/Z4eT54
        OswJKEO4vsr1FvbWuovnG6n4mY8AwbgfvU32igpwJyhrRibTzRGYZ0pS+zdU9gFhrv4TTezoxvPTg
        hlLUh5YHvDGvTCdMXXQ7VhKjApYDYfxlL3VT+nNwtwNQkVPOAXwAW1qubfFu1o+AsbdCjGKbzv2rR
        p+QnqhNY4+X8ZCNtkVbeuJ4T0148xhaiU0PQmlP12f+mNEdx8mMY/AvPPLm2vvkGBNkm80UQVHowq
        4Bj27y3g==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYa-0004vN-2H; Fri, 14 Jun 2019 13:47:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] drm: don't pass __GFP_COMP to dma_alloc_coherent in drm_pci_alloc
Date:   Fri, 14 Jun 2019 15:47:16 +0200
Message-Id: <20190614134726.3827-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory returned from dma_alloc_coherent is opaqueue to the user,
thus the exact way of page refcounting shall not matter either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/drm_bufs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index b640437ce90f..7a79a16a055c 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -70,7 +70,7 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 	dmah->size = size;
 	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
 					 &dmah->busaddr,
-					 GFP_KERNEL | __GFP_COMP);
+					 GFP_KERNEL);
 
 	if (dmah->vaddr == NULL) {
 		kfree(dmah);
-- 
2.20.1

