Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE33849DF38
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbiA0KWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:22:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23804 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbiA0KWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278920; x=1674814920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7PP7ZVyTuXhMGT+ABjcLpIvrOZ7cdserPfEvLTmZS64=;
  b=CtVIlUsm7GJG0G6b3ESoNfH2LZyjCYwGPqTO8zEs9yEKvM5KPZj8Ky7Q
   3ZfjTv1sWTFhp6mUc0WYU3Viku773SgAJ5XLOwAVMmJh3MshD88eZ13y/
   z66rI4PuRnO8CoGtvKOMu7mfXGh5T8kVA7DdhSM0lM01d8bsqbiA8EJwJ
   PpkGcsYLTKXyO2WNuyykaBREdTHhoqbWCjwKqwAMdIedk7lTqJE3fCj2n
   hQ/L+VXtoCVTogA10JK7OJd3zt428hs7pOTRCmiWVC+exIh3gTOyw7sY1
   2ZPnTsgbXeyJBt3d9pnKeYCp9370LZ5C34XYOI20Nqt/y21tfyebqdpYv
   w==;
IronPort-SDR: PR1JP+SV55GijEV8dYY4Nv6pdR+vM6O5KAVTAag4CSOS9DVJ3SkQCcD7MpMdvOYJITCTBdOTu1
 fCLLPGiK07kesbQSqm/qp1bOPYb1pOoLYKZ9TTMtDRRsCEo74500YoUZ/UqN7DRFXZhLIqoBYY
 etbcE7IMWrFv1zhWoYkxy3RpnJ/SbKmb0oNkxajrYJptH/Wo7jcdifJga9eZCt410GXpvIAlRb
 Iot2qZZ8eJcG5emTCU5dFk6S3+3Xkilz492pvZk1khfVDe4phTlN0FDBuKpdsMKqw2r1/0lQgl
 oDfKeZTE7CKHpWI+Cv3BBTKX
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="160173914"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 7/7] net: lan966x: Implement get_ts_info
Date:   Thu, 27 Jan 2022 11:23:33 +0100
Message-ID: <20220127102333.987195-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the function get_ts_info in ethtool_ops which is needed to get
the HW capabilities for timestamping.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_ethtool.c       | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index 614f12c2fe6a..1dd12e0c3b58 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -545,6 +545,41 @@ static int lan966x_set_pauseparam(struct net_device *dev,
 	return phylink_ethtool_set_pauseparam(port->phylink, pause);
 }
 
+static int lan966x_get_ts_info(struct net_device *dev,
+			       struct ethtool_ts_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_phc *phc;
+
+	if (!lan966x->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	phc = &lan966x->phc[LAN966X_PHC_PORT];
+
+	info->phc_index = phc->clock ? ptp_clock_index(phc->clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+				 SOF_TIMESTAMPING_RX_SOFTWARE |
+				 SOF_TIMESTAMPING_SOFTWARE |
+				 SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
+			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+
+	return 0;
+}
+
 const struct ethtool_ops lan966x_ethtool_ops = {
 	.get_link_ksettings     = lan966x_get_link_ksettings,
 	.set_link_ksettings     = lan966x_set_link_ksettings,
@@ -556,6 +591,7 @@ const struct ethtool_ops lan966x_ethtool_ops = {
 	.get_eth_mac_stats      = lan966x_get_eth_mac_stats,
 	.get_rmon_stats		= lan966x_get_eth_rmon_stats,
 	.get_link		= ethtool_op_get_link,
+	.get_ts_info		= lan966x_get_ts_info,
 };
 
 static void lan966x_check_stats_work(struct work_struct *work)
-- 
2.33.0

