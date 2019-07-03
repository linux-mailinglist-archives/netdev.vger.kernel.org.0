Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32645DC0C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfGCCUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbfGCCSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC48721874;
        Wed,  3 Jul 2019 02:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120301;
        bh=ye+Ja5/B68R+Hn3vbN6XivSxzOuvDgGo+/DCZNk2Un4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4F00yNR43g6rBm8MtAmtN8mZFUbG46AWKlYUjp9tjv8BQSUvz7P4nsfZ8m6bX0Ep
         68fTNr48YuAeM84vwb89TEUVH/g0JSko8luJNg/o5S3JPqMmf4PCTXpZYYGMpK+SAT
         ZK41GYGtCFpcuCZ2XuPNyuj4LKJ/QBrG0XSxGaW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Oros <poros@redhat.com>, Ivan Vecera <ivecera@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/13] be2net: fix link failure after ethtool offline test
Date:   Tue,  2 Jul 2019 22:18:06 -0400
Message-Id: <20190703021814.18385-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021814.18385-1-sashal@kernel.org>
References: <20190703021814.18385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Oros <poros@redhat.com>

[ Upstream commit 2e5db6eb3c23e5dc8171eb8f6af7a97ef9fcf3a9 ]

Certain cards in conjunction with certain switches need a little more
time for link setup that results in ethtool link test failure after
offline test. Patch adds a loop that waits for a link setup finish.

Changes in v2:
- added fixes header

Fixes: 4276e47e2d1c ("be2net: Add link test to list of ethtool self tests.")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/emulex/benet/be_ethtool.c    | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 6ce7b8435ace..f66b246acaea 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -893,7 +893,7 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 			 u64 *data)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
-	int status;
+	int status, cnt;
 	u8 link_status = 0;
 
 	if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC) {
@@ -904,6 +904,9 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 
 	memset(data, 0, sizeof(u64) * ETHTOOL_TESTS_NUM);
 
+	/* check link status before offline tests */
+	link_status = netif_carrier_ok(netdev);
+
 	if (test->flags & ETH_TEST_FL_OFFLINE) {
 		if (be_loopback_test(adapter, BE_MAC_LOOPBACK, &data[0]) != 0)
 			test->flags |= ETH_TEST_FL_FAILED;
@@ -924,13 +927,26 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 		test->flags |= ETH_TEST_FL_FAILED;
 	}
 
-	status = be_cmd_link_status_query(adapter, NULL, &link_status, 0);
-	if (status) {
-		test->flags |= ETH_TEST_FL_FAILED;
-		data[4] = -1;
-	} else if (!link_status) {
+	/* link status was down prior to test */
+	if (!link_status) {
 		test->flags |= ETH_TEST_FL_FAILED;
 		data[4] = 1;
+		return;
+	}
+
+	for (cnt = 10; cnt; cnt--) {
+		status = be_cmd_link_status_query(adapter, NULL, &link_status,
+						  0);
+		if (status) {
+			test->flags |= ETH_TEST_FL_FAILED;
+			data[4] = -1;
+			break;
+		}
+
+		if (link_status)
+			break;
+
+		msleep_interruptible(500);
 	}
 }
 
-- 
2.20.1

