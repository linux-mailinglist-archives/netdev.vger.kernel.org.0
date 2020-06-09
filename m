Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4789E1F48D2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgFIVZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:25:11 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:49353 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFIVZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:25:10 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 059LOn5O030078;
        Tue, 9 Jun 2020 14:25:05 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 1/2] Crypto/chcr: Calculate src and dst sg lengths separately for dma map
Date:   Wed, 10 Jun 2020 02:54:31 +0530
Message-Id: <20200609212432.2467-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200609212432.2467-1-ayush.sawal@chelsio.com>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch calculates src and dst sg lengths separately for
dma mapping in case of aead operation.

This fixes a panic which occurs due to the accessing of a zero
length sg.
Panic:
[  138.173225] kernel BUG at drivers/iommu/intel-iommu.c:1184!

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 63 +++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f26a7a15551a..f8b55137cf7d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2590,11 +2590,22 @@ int chcr_aead_dma_map(struct device *dev,
 	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(tfm);
-	int dst_size;
+	int src_len, dst_len;
 
-	dst_size = req->assoclen + req->cryptlen + (op_type ?
-				0 : authsize);
-	if (!req->cryptlen || !dst_size)
+	/* calculate and handle src and dst sg length separately
+	 * for inplace and out-of place operations
+	 */
+	if (req->src == req->dst) {
+		src_len = req->assoclen + req->cryptlen + (op_type ?
+							0 : authsize);
+		dst_len = src_len;
+	} else {
+		src_len = req->assoclen + req->cryptlen;
+		dst_len = req->assoclen + req->cryptlen + (op_type ?
+							-authsize : authsize);
+	}
+
+	if (!req->cryptlen || !src_len || !dst_len)
 		return 0;
 	reqctx->iv_dma = dma_map_single(dev, reqctx->iv, (IV + reqctx->b0_len),
 					DMA_BIDIRECTIONAL);
@@ -2606,20 +2617,23 @@ int chcr_aead_dma_map(struct device *dev,
 		reqctx->b0_dma = 0;
 	if (req->src == req->dst) {
 		error = dma_map_sg(dev, req->src,
-				sg_nents_for_len(req->src, dst_size),
+				sg_nents_for_len(req->src, src_len),
 					DMA_BIDIRECTIONAL);
 		if (!error)
 			goto err;
 	} else {
-		error = dma_map_sg(dev, req->src, sg_nents(req->src),
+		error = dma_map_sg(dev, req->src,
+				   sg_nents_for_len(req->src, src_len),
 				   DMA_TO_DEVICE);
 		if (!error)
 			goto err;
-		error = dma_map_sg(dev, req->dst, sg_nents(req->dst),
+		error = dma_map_sg(dev, req->dst,
+				   sg_nents_for_len(req->dst, dst_len),
 				   DMA_FROM_DEVICE);
 		if (!error) {
-			dma_unmap_sg(dev, req->src, sg_nents(req->src),
-				   DMA_TO_DEVICE);
+			dma_unmap_sg(dev, req->src,
+				     sg_nents_for_len(req->src, src_len),
+				     DMA_TO_DEVICE);
 			goto err;
 		}
 	}
@@ -2637,24 +2651,37 @@ void chcr_aead_dma_unmap(struct device *dev,
 	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(tfm);
-	int dst_size;
+	int src_len, dst_len;
 
-	dst_size = req->assoclen + req->cryptlen + (op_type ?
-					0 : authsize);
-	if (!req->cryptlen || !dst_size)
+	/* calculate and handle src and dst sg length separately
+	 * for inplace and out-of place operations
+	 */
+	if (req->src == req->dst) {
+		src_len = req->assoclen + req->cryptlen + (op_type ?
+							0 : authsize);
+		dst_len = src_len;
+	} else {
+		src_len = req->assoclen + req->cryptlen;
+		dst_len = req->assoclen + req->cryptlen + (op_type ?
+						-authsize : authsize);
+	}
+
+	if (!req->cryptlen || !src_len || !dst_len)
 		return;
 
 	dma_unmap_single(dev, reqctx->iv_dma, (IV + reqctx->b0_len),
 					DMA_BIDIRECTIONAL);
 	if (req->src == req->dst) {
 		dma_unmap_sg(dev, req->src,
-			     sg_nents_for_len(req->src, dst_size),
+			     sg_nents_for_len(req->src, src_len),
 			     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(dev, req->src, sg_nents(req->src),
-				   DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst),
-				   DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, req->src,
+			     sg_nents_for_len(req->src, src_len),
+			     DMA_TO_DEVICE);
+		dma_unmap_sg(dev, req->dst,
+			     sg_nents_for_len(req->dst, dst_len),
+			     DMA_FROM_DEVICE);
 	}
 }
 
-- 
2.26.0.rc1.11.g30e9940

