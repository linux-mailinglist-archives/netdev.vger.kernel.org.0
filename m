Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB7223D46
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGQNtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:49:24 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51706 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQNtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:49:23 -0400
Received: from vishal.asicdesigners.com (indranil-pc.asicdesigners.com [10.193.177.163] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HDn2F8017430;
        Fri, 17 Jul 2020 06:49:19 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 3/4] cxgb4: Add speed link test to ethtool
Date:   Fri, 17 Jul 2020 19:17:58 +0530
Message-Id: <20200717134759.8268-4-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200717134759.8268-1-vishal@chelsio.com>
References: <20200717134759.8268-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test checks whether the current speed is supported or not

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index f374757e15c8..5d3eb44dee46 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -28,12 +28,14 @@ static void set_msglevel(struct net_device *dev, u32 val)
 enum cxgb4_ethtool_tests {
 	CXGB4_ETHTOOL_ADAPTER_TEST,
 	CXGB4_ETHTOOL_LINK_TEST,
+	CXGB4_ETHTOOL_LINK_SPEED_TEST,
 	CXGB4_ETHTOOL_MAX_TEST,
 };
 
 static const char cxgb4_selftest_strings[CXGB4_ETHTOOL_MAX_TEST][ETH_GSTRING_LEN] = {
 	"Adapter health status",
 	"Link test",
+	"Link speed test",
 };
 
 static const char * const flash_region_strings[] = {
@@ -2102,6 +2104,26 @@ static void cxgb4_link_test(struct net_device *netdev, u64 *data)
 	*data = !link;
 }
 
+static void cxgb4_link_speed_test(struct net_device *netdev, u64 *data)
+{
+	struct port_info *pi = netdev_priv(netdev);
+	unsigned int speed;
+	int ret;
+
+	ret = t4_get_link_params(pi, NULL, &speed, NULL);
+	if (ret) {
+		*data = ret;
+		return;
+	}
+
+	if (!speed_to_fw_caps(speed)) {
+		*data = 1;
+		return;
+	}
+
+	*data = 0;
+}
+
 static void cxgb4_self_test(struct net_device *netdev,
 			    struct ethtool_test *eth_test, u64 *data)
 {
@@ -2120,6 +2142,8 @@ static void cxgb4_self_test(struct net_device *netdev,
 	}
 
 	cxgb4_link_test(netdev, &data[CXGB4_ETHTOOL_LINK_TEST]);
+	cxgb4_link_speed_test(netdev, &data[CXGB4_ETHTOOL_LINK_SPEED_TEST]);
+
 	for (i = CXGB4_ETHTOOL_ADAPTER_TEST; i < CXGB4_ETHTOOL_MAX_TEST; i++) {
 		if (data[i]) {
 			eth_test->flags |= ETH_TEST_FL_FAILED;
-- 
2.21.1

