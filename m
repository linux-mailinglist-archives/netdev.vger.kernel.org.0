Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8C223D44
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGQNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:49:18 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:31035 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQNtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:49:16 -0400
Received: from vishal.asicdesigners.com (indranil-pc.asicdesigners.com [10.193.177.163] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HDn2F6017430;
        Fri, 17 Jul 2020 06:49:12 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 1/4] cxgb4: Add ethtool self-test support
Date:   Fri, 17 Jul 2020 19:17:56 +0530
Message-Id: <20200717134759.8268-2-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200717134759.8268-1-vishal@chelsio.com>
References: <20200717134759.8268-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test checks whether adapter has crashed or not

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index b66a2e6cbbeb..1ec6157f8ba7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -25,6 +25,15 @@ static void set_msglevel(struct net_device *dev, u32 val)
 	netdev2adap(dev)->msg_enable = val;
 }
 
+enum cxgb4_ethtool_tests {
+	CXGB4_ETHTOOL_ADAPTER_TEST,
+	CXGB4_ETHTOOL_MAX_TEST,
+};
+
+static const char cxgb4_selftest_strings[CXGB4_ETHTOOL_MAX_TEST][ETH_GSTRING_LEN] = {
+	"Adapter health status",
+};
+
 static const char * const flash_region_strings[] = {
 	"All",
 	"Firmware",
@@ -166,6 +175,8 @@ static int get_sset_count(struct net_device *dev, int sset)
 		       ARRAY_SIZE(loopback_stats_strings);
 	case ETH_SS_PRIV_FLAGS:
 		return ARRAY_SIZE(cxgb4_priv_flags_strings);
+	case ETH_SS_TEST:
+		return ARRAY_SIZE(cxgb4_selftest_strings);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -228,6 +239,9 @@ static void get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	} else if (stringset == ETH_SS_PRIV_FLAGS) {
 		memcpy(data, cxgb4_priv_flags_strings,
 		       sizeof(cxgb4_priv_flags_strings));
+	} else if (stringset == ETH_SS_TEST) {
+		memcpy(data, cxgb4_selftest_strings,
+		       sizeof(cxgb4_selftest_strings));
 	}
 }
 
@@ -2056,6 +2070,31 @@ static int cxgb4_set_priv_flags(struct net_device *netdev, u32 flags)
 	return 0;
 }
 
+static void cxgb4_adapter_status_test(struct net_device *netdev, u64 *data)
+{
+	struct port_info *pi = netdev_priv(netdev);
+	struct adapter *adap = pi->adapter;
+	u32 pcie_fw;
+
+	pcie_fw = t4_read_reg(adap, PCIE_FW_A);
+	if (pcie_fw & PCIE_FW_ERR_F) {
+		*data = 1;
+		return;
+	}
+
+	*data = 0;
+}
+
+static void cxgb4_self_test(struct net_device *netdev,
+			    struct ethtool_test *eth_test, u64 *data)
+{
+	memset(data, 0, sizeof(u64) * CXGB4_ETHTOOL_MAX_TEST);
+
+	cxgb4_adapter_status_test(netdev, &data[CXGB4_ETHTOOL_ADAPTER_TEST]);
+	if (data[CXGB4_ETHTOOL_ADAPTER_TEST])
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+}
+
 static const struct ethtool_ops cxgb_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -2090,6 +2129,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.get_rxfh_indir_size = get_rss_table_size,
 	.get_rxfh	   = get_rss_table,
 	.set_rxfh	   = set_rss_table,
+	.self_test	   = cxgb4_self_test,
 	.flash_device      = set_flash,
 	.get_ts_info       = get_ts_info,
 	.set_dump          = set_dump,
-- 
2.21.1

