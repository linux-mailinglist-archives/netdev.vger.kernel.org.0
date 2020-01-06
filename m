Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E6131C3D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgAFXUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:20:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:21027 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgAFXUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:20:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 15:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,404,1571727600"; 
   d="scan'208";a="303013028"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2020 15:20:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/5] igc: Add support for ethtool GET_TS_INFO command
Date:   Mon,  6 Jan 2020 15:19:55 -0800
Message-Id: <20200106231956.549255-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
References: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This command allows igc to report what types of timestamping are
supported. ptp4l uses this to detect if the hardware supports
timestamping.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 455c1cdceb6e..ee07011e13e9 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1600,6 +1600,39 @@ static int igc_set_channels(struct net_device *netdev,
 	return 0;
 }
 
+static int igc_get_ts_info(struct net_device *dev,
+			   struct ethtool_ts_info *info)
+{
+	struct igc_adapter *adapter = netdev_priv(dev);
+
+	if (adapter->ptp_clock)
+		info->phc_index = ptp_clock_index(adapter->ptp_clock);
+	else
+		info->phc_index = -1;
+
+	switch (adapter->hw.mac.type) {
+	case igc_i225:
+		info->so_timestamping =
+			SOF_TIMESTAMPING_TX_SOFTWARE |
+			SOF_TIMESTAMPING_RX_SOFTWARE |
+			SOF_TIMESTAMPING_SOFTWARE |
+			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_RX_HARDWARE |
+			SOF_TIMESTAMPING_RAW_HARDWARE;
+
+		info->tx_types =
+			BIT(HWTSTAMP_TX_OFF) |
+			BIT(HWTSTAMP_TX_ON);
+
+		info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+		info->rx_filters |= BIT(HWTSTAMP_FILTER_ALL);
+
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static u32 igc_get_priv_flags(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1847,6 +1880,7 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_rxfh_indir_size	= igc_get_rxfh_indir_size,
 	.get_rxfh		= igc_get_rxfh,
 	.set_rxfh		= igc_set_rxfh,
+	.get_ts_info		= igc_get_ts_info,
 	.get_channels		= igc_get_channels,
 	.set_channels		= igc_set_channels,
 	.get_priv_flags		= igc_get_priv_flags,
-- 
2.24.1

