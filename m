Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77B1C4C99
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgEEDOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:14:11 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:17398 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEEDOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:14:11 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dquv019487;
        Mon, 4 May 2020 20:13:57 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 1/5] Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests
Date:   Tue,  5 May 2020 08:42:53 +0530
Message-Id: <20200505031257.9153-2-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200505031257.9153-1-shiva@chelsio.com>
References: <20200505031257.9153-1-shiva@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two issues observed during self tests with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.

1. gcm(aes) hang issue , that happens during decryption.
2. rfc4106-gcm-aes-chcr encryption unexpectedly succeeded.

For gcm-aes decryption , authtag is not mapped due to
sg_nents_for_len(upto size: assoclen+ cryptlen - authsize).
So fix it by dma_mapping authtag.
Also replaced sg_nents() to sg_nents_for_len() in case of aead_dma_unmap().

For rfc4106-gcm-aes-chcr, used crypto_ipsec_check_assoclen() for checking
the validity of assoclen.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index c29b80dd30d8..e300eb32a9d3 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2556,7 +2556,7 @@ int chcr_aead_dma_map(struct device *dev,
 	int dst_size;
 
 	dst_size = req->assoclen + req->cryptlen + (op_type ?
-				-authsize : authsize);
+				0 : authsize);
 	if (!req->cryptlen || !dst_size)
 		return 0;
 	reqctx->iv_dma = dma_map_single(dev, reqctx->iv, (IV + reqctx->b0_len),
@@ -2603,15 +2603,16 @@ void chcr_aead_dma_unmap(struct device *dev,
 	int dst_size;
 
 	dst_size = req->assoclen + req->cryptlen + (op_type ?
-					-authsize : authsize);
+					0 : authsize);
 	if (!req->cryptlen || !dst_size)
 		return;
 
 	dma_unmap_single(dev, reqctx->iv_dma, (IV + reqctx->b0_len),
 					DMA_BIDIRECTIONAL);
 	if (req->src == req->dst) {
-		dma_unmap_sg(dev, req->src, sg_nents(req->src),
-				   DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev, req->src,
+			     sg_nents_for_len(req->src, dst_size),
+			     DMA_BIDIRECTIONAL);
 	} else {
 		dma_unmap_sg(dev, req->src, sg_nents(req->src),
 				   DMA_TO_DEVICE);
@@ -3702,6 +3703,13 @@ static int chcr_aead_op(struct aead_request *req,
 			return -ENOSPC;
 	}
 
+	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106 &&
+	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
+		pr_err("RFC4106: Invalid value of assoclen %d\n",
+		       req->assoclen);
+		return -EINVAL;
+	}
+
 	/* Form a WR from req */
 	skb = create_wr_fn(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx], size);
 
-- 
2.18.1

