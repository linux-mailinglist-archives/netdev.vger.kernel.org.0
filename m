Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AD1DDBD4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgEVALV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:41697 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730480AbgEVALP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:15 -0400
IronPort-SDR: ARSYWrp/z7/+3+usFm49V3kswbYCahhq70A5D88IPY0KmCEfukGirJTpDIRLAELONKjfEq/bdn
 7rvQeyCf95/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:11 -0700
IronPort-SDR: 59RTXgXD3mmR2jZkx9kEAz/Hz5z6nTb0JIRVBPB5pYRZsVl7CFVNQUHZqQneNaSLB5RIjvcVhA
 uvebYPSbT53A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133958"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/15] igc: Cleanup _get|set_rxnfc ethtool ops
Date:   Thu, 21 May 2020 17:11:04 -0700
Message-Id: <20200522001108.1675149-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch does a trivial change in igc_ethtool_get_rxnfc() and
igc_ethtool_set_rxnfc() to simplify their logic.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 33 ++++++--------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 9081f36ee1f7..37fb5f0544ad 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1055,31 +1055,23 @@ static int igc_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 			 u32 *rule_locs)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
-	int ret = -EOPNOTSUPP;
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
 		cmd->data = adapter->num_rx_queues;
-		ret = 0;
-		break;
+		return 0;
 	case ETHTOOL_GRXCLSRLCNT:
 		cmd->rule_cnt = adapter->nfc_filter_count;
-		ret = 0;
-		break;
+		return 0;
 	case ETHTOOL_GRXCLSRULE:
-		ret = igc_get_ethtool_nfc_entry(adapter, cmd);
-		break;
+		return igc_get_ethtool_nfc_entry(adapter, cmd);
 	case ETHTOOL_GRXCLSRLALL:
-		ret = igc_get_ethtool_nfc_all(adapter, cmd, rule_locs);
-		break;
+		return igc_get_ethtool_nfc_all(adapter, cmd, rule_locs);
 	case ETHTOOL_GRXFH:
-		ret = igc_get_rss_hash_opts(adapter, cmd);
-		break;
+		return igc_get_rss_hash_opts(adapter, cmd);
 	default:
-		break;
+		return -EOPNOTSUPP;
 	}
-
-	return ret;
 }
 
 #define UDP_RSS_FLAGS (IGC_FLAG_RSS_FIELD_IPV4_UDP | \
@@ -1418,22 +1410,17 @@ static int igc_del_ethtool_nfc_entry(struct igc_adapter *adapter,
 static int igc_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
-	int ret = -EOPNOTSUPP;
 
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXFH:
-		ret = igc_set_rss_hash_opt(adapter, cmd);
-		break;
+		return igc_set_rss_hash_opt(adapter, cmd);
 	case ETHTOOL_SRXCLSRLINS:
-		ret = igc_add_ethtool_nfc_entry(adapter, cmd);
-		break;
+		return igc_add_ethtool_nfc_entry(adapter, cmd);
 	case ETHTOOL_SRXCLSRLDEL:
-		ret = igc_del_ethtool_nfc_entry(adapter, cmd);
+		return igc_del_ethtool_nfc_entry(adapter, cmd);
 	default:
-		break;
+		return -EOPNOTSUPP;
 	}
-
-	return ret;
 }
 
 void igc_write_rss_indir_tbl(struct igc_adapter *adapter)
-- 
2.26.2

