Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13041F3154
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbgFIBIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgFHXGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3663F20774;
        Mon,  8 Jun 2020 23:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657604;
        bh=uyTL2Lu6aIQbzbN9xNngetGgXUNcmBdT+z3cenf8g70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuSjLWLKVDSST8YnBGzmK/lQbjKo0zTzoeGxpj7uBtzTDbNAMuLnhjWV6vq7wdTx0
         hBRsL/mb0yRK9BVXpMcooKDIR5Zk5rrfVowqSAgvnc5CTAM3XDB9Dxdsm7oi7bXMzz
         oLXGODs3BVkVkgaY8Fu9vmtY8E5UIXhluEq1HScQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 029/274] net: ena: fix error returning in ena_com_get_hash_function()
Date:   Mon,  8 Jun 2020 19:02:02 -0400
Message-Id: <20200608230607.3361041-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit e9a1de378dd46375f9abfd8de1e6f59ee114a793 ]

In case the "func" parameter is NULL we now return "-EINVAL".
This shouldn't happen in general, but when it does happen, this is the
proper way to handle it.

We also check func for NULL in the beginning of the function, as there
is no reason to do all the work and realize in the end of the function
it was useless.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index a250046b8e18..07b0f396d3c2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2345,6 +2345,9 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 		rss->hash_key;
 	int rc;
 
+	if (unlikely(!func))
+		return -EINVAL;
+
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_FUNCTION,
 				    rss->hash_key_dma_addr,
@@ -2357,8 +2360,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (rss->hash_func)
 		rss->hash_func--;
 
-	if (func)
-		*func = rss->hash_func;
+	*func = rss->hash_func;
 
 	if (key)
 		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);
-- 
2.25.1

