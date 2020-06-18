Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D661FEB40
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFRGHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:07:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:64268 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFRGHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:07:03 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05I66ob6030007;
        Wed, 17 Jun 2020 23:06:59 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next v2 2/5] cxgb4: add support to flash PHY image
Date:   Thu, 18 Jun 2020 11:35:53 +0530
Message-Id: <20200618060556.14410-3-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200618060556.14410-1-vishal@chelsio.com>
References: <20200618060556.14410-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update set_flash to flash PHY image to flash region

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  1 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 39 +++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index a7a1e1f5d554..b49d16a54ada 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -141,6 +141,7 @@ enum cc_fec {
 
 enum {
 	CXGB4_ETHTOOL_FLASH_FW = 1,
+	CXGB4_ETHTOOL_FLASH_PHY = 2,
 };
 
 struct port_stats {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 92f79d0cd6ab..7118ba016f01 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -26,6 +26,7 @@ static void set_msglevel(struct net_device *dev, u32 val)
 static const char * const flash_region_strings[] = {
 	"All",
 	"Firmware",
+	"PHY Firmware",
 };
 
 static const char stats_strings[][ETH_GSTRING_LEN] = {
@@ -1240,6 +1241,39 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return err;
 }
 
+#define CXGB4_PHY_SIG 0x130000ea
+
+static int cxgb4_validate_phy_image(const u8 *data, u32 *size)
+{
+	struct cxgb4_fw_data *header;
+
+	header = (struct cxgb4_fw_data *)data;
+	if (be32_to_cpu(header->signature) != CXGB4_PHY_SIG)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
+				   const u8 *data, u32 size)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	int ret;
+
+	ret = cxgb4_validate_phy_image(data, NULL);
+	if (ret) {
+		dev_err(adap->pdev_dev, "PHY signature mismatch\n");
+		return ret;
+	}
+
+	ret = t4_load_phy_fw(adap, MEMWIN_NIC, &adap->win0_lock,
+			     NULL, data, size);
+	if (ret)
+		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
+
+	return ret;
+}
+
 static int cxgb4_ethtool_flash_fw(struct net_device *netdev,
 				  const u8 *data, u32 size)
 {
@@ -1273,6 +1307,9 @@ static int cxgb4_ethtool_flash_region(struct net_device *netdev,
 	case CXGB4_ETHTOOL_FLASH_FW:
 		ret = cxgb4_ethtool_flash_fw(netdev, data, size);
 		break;
+	case CXGB4_ETHTOOL_FLASH_PHY:
+		ret = cxgb4_ethtool_flash_phy(netdev, data, size);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1306,6 +1343,8 @@ static int cxgb4_ethtool_get_flash_region(const u8 *data, u32 *size)
 {
 	if (!cxgb4_validate_fw_image(data, size))
 		return CXGB4_ETHTOOL_FLASH_FW;
+	if (!cxgb4_validate_phy_image(data, size))
+		return CXGB4_ETHTOOL_FLASH_PHY;
 
 	return -EOPNOTSUPP;
 }
-- 
2.21.1

