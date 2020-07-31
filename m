Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D95234CA8
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgGaVEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:04:25 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:22608 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgGaVEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:04:24 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06VL4Lto018703;
        Fri, 31 Jul 2020 14:04:21 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next] cxgb4: fix check for running offline ethtool selftest
Date:   Sat,  1 Aug 2020 02:20:52 +0530
Message-Id: <1596228652-25525-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag indicating the selftest to run is a bitmask. So, fix the
check. Also, the selftests will fail if adapter initialization has
not been completed yet. So, add appropriate check and bail sooner.

Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 12ef9ddd1e54..9f3173f86eed 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -31,7 +31,7 @@ enum cxgb4_ethtool_tests {
 };
 
 static const char cxgb4_selftest_strings[CXGB4_ETHTOOL_MAX_TEST][ETH_GSTRING_LEN] = {
-	"Loop back test",
+	"Loop back test (offline)",
 };
 
 static const char * const flash_region_strings[] = {
@@ -2095,12 +2095,13 @@ static void cxgb4_self_test(struct net_device *netdev,
 
 	memset(data, 0, sizeof(u64) * CXGB4_ETHTOOL_MAX_TEST);
 
-	if (!(adap->flags & CXGB4_FW_OK)) {
+	if (!(adap->flags & CXGB4_FULL_INIT_DONE) ||
+	    !(adap->flags & CXGB4_FW_OK)) {
 		eth_test->flags |= ETH_TEST_FL_FAILED;
 		return;
 	}
 
-	if (eth_test->flags == ETH_TEST_FL_OFFLINE)
+	if (eth_test->flags & ETH_TEST_FL_OFFLINE)
 		cxgb4_lb_test(netdev, &data[CXGB4_ETHTOOL_LB_TEST]);
 
 	if (data[CXGB4_ETHTOOL_LB_TEST])
-- 
2.24.0

