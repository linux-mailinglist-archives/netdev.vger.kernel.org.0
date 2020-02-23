Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5D51694AC
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgBWCXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgBWCXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0608208C3;
        Sun, 23 Feb 2020 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424591;
        bh=Wn/4Yi/m96hOLe/jzp6H24+r/KiD9+YMjhMDtg05hG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiZbqR8FrN0jpzMln4rz52EVM6v1tXMQwDKYuOKaeGsGkUUBAY+7GsoJ7FUDTtLhk
         BxLy4LYYFwBdksEt4Fl1Eu1UbmC6lntuxejWyHARArjEKPLOoeJj4UwD6gWSmM1IOc
         1baf6a5LKR2TzIa0SDsQHe3aftoTBe1cqwYYKkss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/50] net: ena: fix potential crash when rxfh key is NULL
Date:   Sat, 22 Feb 2020 21:22:14 -0500
Message-Id: <20200223022235.1404-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 91a65b7d3ed8450f31ab717a65dcb5f9ceb5ab02 ]

When ethtool -X is called without an hkey, ena_com_fill_hash_function()
is called with key=NULL, which is passed to memcpy causing a crash.

This commit fixes this issue by checking key is not NULL.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index ea62604fdf8ca..e54c44fdcaa73 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2297,15 +2297,16 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 
 	switch (func) {
 	case ENA_ADMIN_TOEPLITZ:
-		if (key_len > sizeof(hash_key->key)) {
-			pr_err("key len (%hu) is bigger than the max supported (%zu)\n",
-			       key_len, sizeof(hash_key->key));
-			return -EINVAL;
+		if (key) {
+			if (key_len != sizeof(hash_key->key)) {
+				pr_err("key len (%hu) doesn't equal the supported size (%zu)\n",
+				       key_len, sizeof(hash_key->key));
+				return -EINVAL;
+			}
+			memcpy(hash_key->key, key, key_len);
+			rss->hash_init_val = init_val;
+			hash_key->keys_num = key_len >> 2;
 		}
-
-		memcpy(hash_key->key, key, key_len);
-		rss->hash_init_val = init_val;
-		hash_key->keys_num = key_len >> 2;
 		break;
 	case ENA_ADMIN_CRC32:
 		rss->hash_init_val = init_val;
-- 
2.20.1

