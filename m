Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E76169531
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgBWCWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbgBWCWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EE42071E;
        Sun, 23 Feb 2020 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424521;
        bh=DrogBba9msTbngHtLmWtxQahOenWiF9iZhri+C8iWa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7R+W1RstGT52AaFiAVp6e2ZioAXHgaKAa6cEOVMneeMEDq30jOi1yvJ4lk5EHvwj
         gglXPuawluaERxmK0iEtf17sWkVf2I3iZGPjVAHDUVYNAfbo1Mjv1wn2xw/YYBp6bz
         hIhwZb5l1AN7b2tJ5iskMBS0/x7++1Oa3sk5tsgg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 34/58] net: ena: rss: do not allocate key when not supported
Date:   Sat, 22 Feb 2020 21:20:55 -0500
Message-Id: <20200223022119.707-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 6a4f7dc82d1e3abd3feb0c60b5041056fcd9880c ]

Currently we allocate the key whether the device supports setting the
key or not. This commit adds a check to the allocation function and
handles the error accordingly.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 24 ++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index d6b894b06fa30..6f758ece86f60 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1057,6 +1057,20 @@ static void ena_com_hash_key_fill_default_key(struct ena_com_dev *ena_dev)
 static int ena_com_hash_key_allocate(struct ena_com_dev *ena_dev)
 {
 	struct ena_rss *rss = &ena_dev->rss;
+	struct ena_admin_feature_rss_flow_hash_control *hash_key;
+	struct ena_admin_get_feat_resp get_resp;
+	int rc;
+
+	hash_key = (ena_dev->rss).hash_key;
+
+	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
+				    ENA_ADMIN_RSS_HASH_FUNCTION,
+				    ena_dev->rss.hash_key_dma_addr,
+				    sizeof(ena_dev->rss.hash_key), 0);
+	if (unlikely(rc)) {
+		hash_key = NULL;
+		return -EOPNOTSUPP;
+	}
 
 	rss->hash_key =
 		dma_alloc_coherent(ena_dev->dmadev, sizeof(*rss->hash_key),
@@ -2640,11 +2654,15 @@ int ena_com_rss_init(struct ena_com_dev *ena_dev, u16 indr_tbl_log_size)
 	if (unlikely(rc))
 		goto err_indr_tbl;
 
+	/* The following function might return unsupported in case the
+	 * device doesn't support setting the key / hash function. We can safely
+	 * ignore this error and have indirection table support only.
+	 */
 	rc = ena_com_hash_key_allocate(ena_dev);
-	if (unlikely(rc))
+	if (unlikely(rc) && rc != -EOPNOTSUPP)
 		goto err_hash_key;
-
-	ena_com_hash_key_fill_default_key(ena_dev);
+	else if (rc != -EOPNOTSUPP)
+		ena_com_hash_key_fill_default_key(ena_dev);
 
 	rc = ena_com_hash_ctrl_init(ena_dev);
 	if (unlikely(rc))
-- 
2.20.1

