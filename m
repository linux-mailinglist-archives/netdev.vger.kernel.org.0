Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA03016944A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgBWC3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbgBWCYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B521920707;
        Sun, 23 Feb 2020 02:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424640;
        bh=osVklB8pscuOnNSyEep2Q6rChRj+SW+wKvUMrT7fdAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X22/nCWVoTf5dLFSw5gtu/TZU/FOu37/cqGWOaU0nVFX2Hq0jUSr4ZAmgNDgndJEl
         IasE7U/+PrcuJl6wPrpUxmXg0FaYyOlcSTKEobyhsfC6s0GVnX/rxl5bKR4rLaO0OW
         KZeJkGzh7InKpy4t2wIKCFhW6O0aU0DUvqhjyJ4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/25] net: ena: rss: fix failure to get indirection table
Date:   Sat, 22 Feb 2020 21:23:31 -0500
Message-Id: <20200223022339.1885-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022339.1885-1-sashal@kernel.org>
References: <20200223022339.1885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 0c8923c0a64fb5d14bebb9a9065d2dc25ac5e600 ]

On old hardware, getting / setting the hash function is not supported while
gettting / setting the indirection table is.

This commit enables us to still show the indirection table on older
hardwares by setting the hash function and key to NULL.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 237fbcac734f5..dc63aa912aebb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -661,7 +661,21 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	if (rc)
 		return rc;
 
+	/* We call this function in order to check if the device
+	 * supports getting/setting the hash function.
+	 */
 	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
+
+	if (rc) {
+		if (rc == -EOPNOTSUPP) {
+			key = NULL;
+			hfunc = NULL;
+			rc = 0;
+		}
+
+		return rc;
+	}
+
 	if (rc)
 		return rc;
 
-- 
2.20.1

