Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC41B1A39
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgDTXnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:14658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgDTXnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:17 -0400
IronPort-SDR: A5dY3v47R7EWIExdttrTh6uN5JPyu99tKixAAk0ufYuZfqMMfwNiDIuov2G/76M6SA+ZyS9yIV
 oFs/Zj3HNQkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:16 -0700
IronPort-SDR: VDo6Q7MGxAcMB7EV9Us+hp2zNeN0B/CrkpvwQHYL9CJwxkF0VHP8V4rMwUnUiHG+ef9i+HTqIc
 Lnql1NWH050Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428851"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/13] igc: Use netdev log helpers in igc_ethtool.c
Date:   Mon, 20 Apr 2020 16:43:04 -0700
Message-Id: <20200420234313.2184282-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In igc_ethtool.c we print log messages using dev_* helpers, generating
inconsistent output with the rest of the driver. Since this is a network
device driver, we should preferably use netdev_* helpers because they
append the interface name to the message, helping making sense the of
the logs.

This patch converts all dev_* calls to netdev_*. It also takes this
opportunity to remove the '\n' character at the end of messages since it
is automatically added by netdev_* log helpers.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 43 ++++++++++----------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index c14196663ebb..be6b1cbff926 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1155,8 +1155,8 @@ static int igc_set_rss_hash_opt(struct igc_adapter *adapter,
 
 		if ((flags & UDP_RSS_FLAGS) &&
 		    !(adapter->flags & UDP_RSS_FLAGS))
-			dev_err(&adapter->pdev->dev,
-				"enabling UDP RSS: fragmented packets may arrive out of order to the stack above\n");
+			netdev_err(adapter->netdev,
+				   "Enabling UDP RSS: fragmented packets may arrive out of order to the stack above");
 
 		adapter->flags = flags;
 
@@ -1195,7 +1195,8 @@ static int igc_rxnfc_write_etype_filter(struct igc_adapter *adapter,
 			break;
 	}
 	if (i == MAX_ETYPE_FILTER) {
-		dev_err(&adapter->pdev->dev, "ethtool -N: etype filters are all used.\n");
+		netdev_err(adapter->netdev,
+			   "ethtool -N: etype filters are all used");
 		return -EINVAL;
 	}
 
@@ -1236,7 +1237,8 @@ static int igc_rxnfc_write_vlan_prio_filter(struct igc_adapter *adapter,
 	/* check whether this vlan prio is already set */
 	if (vlapqf & IGC_VLAPQF_P_VALID(vlan_priority) &&
 	    queue_index != input->action) {
-		dev_err(&adapter->pdev->dev, "ethtool rxnfc set vlan prio filter failed.\n");
+		netdev_err(adapter->netdev,
+			   "ethtool rxnfc set vlan prio filter failed");
 		return -EEXIST;
 	}
 
@@ -1255,8 +1257,8 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 
 	if (hw->mac.type == igc_i225 &&
 	    !(input->filter.match_flags & ~IGC_FILTER_FLAG_SRC_MAC_ADDR)) {
-		dev_err(&adapter->pdev->dev,
-			"i225 doesn't support flow classification rules specifying only source addresses.\n");
+		netdev_err(adapter->netdev,
+			   "i225 doesn't support flow classification rules specifying only source addresses");
 		return -EOPNOTSUPP;
 	}
 
@@ -1404,13 +1406,14 @@ static int igc_add_ethtool_nfc_entry(struct igc_adapter *adapter,
 	 */
 	if (fsp->ring_cookie == RX_CLS_FLOW_DISC ||
 	    fsp->ring_cookie >= adapter->num_rx_queues) {
-		dev_err(&adapter->pdev->dev, "ethtool -N: The specified action is invalid\n");
+		netdev_err(netdev,
+			   "ethtool -N: The specified action is invalid");
 		return -EINVAL;
 	}
 
 	/* Don't allow indexes to exist outside of available space */
 	if (fsp->location >= IGC_MAX_RXNFC_FILTERS) {
-		dev_err(&adapter->pdev->dev, "Location out of range\n");
+		netdev_err(netdev, "Location out of range");
 		return -EINVAL;
 	}
 
@@ -1458,8 +1461,8 @@ static int igc_add_ethtool_nfc_entry(struct igc_adapter *adapter,
 		if (!memcmp(&input->filter, &rule->filter,
 			    sizeof(input->filter))) {
 			err = -EEXIST;
-			dev_err(&adapter->pdev->dev,
-				"ethtool: this filter is already set\n");
+			netdev_err(netdev,
+				   "ethtool: this filter is already set");
 			goto err_out_w_lock;
 		}
 	}
@@ -1832,6 +1835,7 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 				  const struct ethtool_link_ksettings *cmd)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct net_device *dev = adapter->netdev;
 	struct igc_hw *hw = &adapter->hw;
 	u32 advertising;
 
@@ -1839,8 +1843,7 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 	 * cannot be changed
 	 */
 	if (igc_check_reset_block(hw)) {
-		dev_err(&adapter->pdev->dev,
-			"Cannot change link characteristics when reset is active.\n");
+		netdev_err(dev, "Cannot change link characteristics when reset is active");
 		return -EINVAL;
 	}
 
@@ -1851,7 +1854,7 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 	if (cmd->base.eth_tp_mdix_ctrl) {
 		if (cmd->base.eth_tp_mdix_ctrl != ETH_TP_MDI_AUTO &&
 		    cmd->base.autoneg != AUTONEG_ENABLE) {
-			dev_err(&adapter->pdev->dev, "forcing MDI/MDI-X state is not supported when link speed and/or duplex are forced\n");
+			netdev_err(dev, "Forcing MDI/MDI-X state is not supported when link speed and/or duplex are forced");
 			return -EINVAL;
 		}
 	}
@@ -1868,9 +1871,7 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 		if (adapter->fc_autoneg)
 			hw->fc.requested_mode = igc_fc_default;
 	} else {
-		/* calling this overrides forced MDI setting */
-		dev_info(&adapter->pdev->dev,
-			 "Force mode currently not supported\n");
+		netdev_info(dev, "Force mode currently not supported");
 	}
 
 	/* MDI-X => 2; MDI => 1; Auto => 3 */
@@ -1904,7 +1905,7 @@ static void igc_diag_test(struct net_device *netdev,
 	bool if_running = netif_running(netdev);
 
 	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
-		netdev_info(adapter->netdev, "offline testing starting");
+		netdev_info(adapter->netdev, "Offline testing starting");
 		set_bit(__IGC_TESTING, &adapter->state);
 
 		/* Link test performed before hardware reset so autoneg doesn't
@@ -1918,19 +1919,19 @@ static void igc_diag_test(struct net_device *netdev,
 		else
 			igc_reset(adapter);
 
-		netdev_info(adapter->netdev, "register testing starting");
+		netdev_info(adapter->netdev, "Register testing starting");
 		if (!igc_reg_test(adapter, &data[TEST_REG]))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
 		igc_reset(adapter);
 
-		netdev_info(adapter->netdev, "eeprom testing starting");
+		netdev_info(adapter->netdev, "EEPROM testing starting");
 		if (!igc_eeprom_test(adapter, &data[TEST_EEP]))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
 		igc_reset(adapter);
 
-		netdev_info(adapter->netdev, "interrupt testing starting");
+		netdev_info(adapter->netdev, "Interrupt testing starting");
 		if (!igc_intr_test(adapter, &data[TEST_IRQ]))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
@@ -1943,7 +1944,7 @@ static void igc_diag_test(struct net_device *netdev,
 		if (if_running)
 			igc_open(netdev);
 	} else {
-		netdev_info(adapter->netdev, "online testing starting");
+		netdev_info(adapter->netdev, "Online testing starting");
 
 		/* register, eeprom, intr and loopback tests not run online */
 		data[TEST_REG] = 0;
-- 
2.25.3

