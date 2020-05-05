Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353871C4C97
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEEDOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:14:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:47871 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgEEDOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:14:19 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dqv1019487;
        Mon, 4 May 2020 20:14:09 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 5/5] Crypto/chcr: fix for hmac(sha) test fails
Date:   Tue,  5 May 2020 08:42:57 +0530
Message-Id: <20200505031257.9153-6-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200505031257.9153-1-shiva@chelsio.com>
References: <20200505031257.9153-1-shiva@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hmac(sha) test fails for a zero length source text data.
For hmac(sha) minimum length of the data must be of block-size.
So fix this by including the data_len for the last block.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 0d25af42cadb..b8c1c4dd3ef0 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2005,7 +2005,7 @@ static int chcr_ahash_digest(struct ahash_request *req)
 	req_ctx->data_len += params.bfr_len + params.sg_len;
 
 	if (req->nbytes == 0) {
-		create_last_hash_block(req_ctx->reqbfr, bs, 0);
+		create_last_hash_block(req_ctx->reqbfr, bs, req_ctx->data_len);
 		params.more = 1;
 		params.bfr_len = bs;
 	}
-- 
2.18.1

