Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B9745F43
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfFNNsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbfFNNsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=voUH/VESvtWj4I6HLsXBpYRJA1I9bz8V8FhWnyIglGY=; b=uRK7ZFAnjpL2rr/0CUfA2lvRvn
        MMA/TT67HwvKwHALsH6Yi1bK/9hQpeF2Y9WNSQiuHCQZk3pGo5Iut8pm4tAYvEGrw/6WXYNTmPxKO
        dAMk/oU/QBEx/xXpnJFg9G8wz5Fp9ysZOZxj3YySGlQxOS9aKURHvR4B3f1nS4JChwui9qEEY8i6X
        bJlC9leC1vR0nEGsTg5/vqnuj4fdWff3QX72bE0zpkRJHcgzwvQf1m9HIJwDxhhdbqgBXTTX3ixSJ
        5oYDmNfDcKyAIPrOHNouEAsKLx5bVbDJIHGyKOFWk1kar/q9/gTj6w2JpvlWTWoobtck9JM+dFHSI
        3wLzosZw==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYd-00054z-8V; Fri, 14 Jun 2019 13:47:56 +0000
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
Subject: [PATCH 07/16] IB/hfi1: stop passing bogus gfp flags arguments to dma_alloc_coherent
Date:   Fri, 14 Jun 2019 15:47:17 +0200
Message-Id: <20190614134726.3827-8-hch@lst.de>
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

dma_alloc_coherent is not just the page allocator.  The only valid
arguments to pass are either GFP_ATOMIC or GFP_ATOMIC with possible
modifiers of __GFP_NORETRY or __GFP_NOWARN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/hw/hfi1/init.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 71cb9525c074..ff9d106ee784 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1846,17 +1846,10 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
-		gfp_t gfp_flags;
-
 		amt = rcvhdrq_size(rcd);
 
-		if (rcd->ctxt < dd->first_dyn_alloc_ctxt || rcd->is_vnic)
-			gfp_flags = GFP_KERNEL;
-		else
-			gfp_flags = GFP_USER;
 		rcd->rcvhdrq = dma_alloc_coherent(&dd->pcidev->dev, amt,
-						  &rcd->rcvhdrq_dma,
-						  gfp_flags | __GFP_COMP);
+						  &rcd->rcvhdrq_dma, GFP_KERNEL);
 
 		if (!rcd->rcvhdrq) {
 			dd_dev_err(dd,
@@ -1870,7 +1863,7 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 			rcd->rcvhdrtail_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
 								    PAGE_SIZE,
 								    &rcd->rcvhdrqtailaddr_dma,
-								    gfp_flags);
+								    GFP_KERNEL);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
 		}
@@ -1926,19 +1919,10 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 {
 	struct hfi1_devdata *dd = rcd->dd;
 	u32 max_entries, egrtop, alloced_bytes = 0;
-	gfp_t gfp_flags;
 	u16 order, idx = 0;
 	int ret = 0;
 	u16 round_mtu = roundup_pow_of_two(hfi1_max_mtu);
 
-	/*
-	 * GFP_USER, but without GFP_FS, so buffer cache can be
-	 * coalesced (we hope); otherwise, even at order 4,
-	 * heavy filesystem activity makes these fail, and we can
-	 * use compound pages.
-	 */
-	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
-
 	/*
 	 * The minimum size of the eager buffers is a groups of MTU-sized
 	 * buffers.
@@ -1969,7 +1953,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			dma_alloc_coherent(&dd->pcidev->dev,
 					   rcd->egrbufs.rcvtid_size,
 					   &rcd->egrbufs.buffers[idx].dma,
-					   gfp_flags);
+					   GFP_KERNEL);
 		if (rcd->egrbufs.buffers[idx].addr) {
 			rcd->egrbufs.buffers[idx].len =
 				rcd->egrbufs.rcvtid_size;
-- 
2.20.1

