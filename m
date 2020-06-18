Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B800A1FEB3F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgFRGHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:07:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12124 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFRGHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:07:00 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05I66ob5030007;
        Wed, 17 Jun 2020 23:06:54 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next v2 1/5] cxgb4: update set_flash to flash different images
Date:   Thu, 18 Jun 2020 11:35:52 +0530
Message-Id: <20200618060556.14410-2-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200618060556.14410-1-vishal@chelsio.com>
References: <20200618060556.14410-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chelsio adapter contains different flash regions and each
region is used by different binary files. This patch adds
support to flash images like PHY firmware, boot and boot config
using ethtool -f N.

The N value mapping is as follows.
N = 0 : Parse image and decide which region to flash
N = 1 : Firmware
N = 2 : PHY firmware
N = 3 : boot image
N = 4 : boot cfg

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   9 ++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 121 +++++++++++++++---
 2 files changed, 115 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index cf69c6edcfec..a7a1e1f5d554 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -139,6 +139,10 @@ enum cc_fec {
 	FEC_BASER_RS  = 1 << 2   /* BaseR/Reed-Solomon */
 };
 
+enum {
+	CXGB4_ETHTOOL_FLASH_FW = 1,
+};
+
 struct port_stats {
 	u64 tx_octets;            /* total # of octets in good frames */
 	u64 tx_frames;            /* all good frames */
@@ -492,6 +496,11 @@ struct trace_params {
 	unsigned char port;
 };
 
+struct cxgb4_fw_data {
+	__be32 signature;
+	__u8 reserved[4];
+};
+
 /* Firmware Port Capabilities types. */
 
 typedef u16 fw_port_cap16_t;	/* 16-bit Port Capabilities integral value */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 9fd496732b2c..92f79d0cd6ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -23,6 +23,11 @@ static void set_msglevel(struct net_device *dev, u32 val)
 	netdev2adap(dev)->msg_enable = val;
 }
 
+static const char * const flash_region_strings[] = {
+	"All",
+	"Firmware",
+};
+
 static const char stats_strings[][ETH_GSTRING_LEN] = {
 	"tx_octets_ok           ",
 	"tx_frames_ok           ",
@@ -1235,15 +1240,88 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return err;
 }
 
-static int set_flash(struct net_device *netdev, struct ethtool_flash *ef)
+static int cxgb4_ethtool_flash_fw(struct net_device *netdev,
+				  const u8 *data, u32 size)
 {
-	int ret;
-	const struct firmware *fw;
 	struct adapter *adap = netdev2adap(netdev);
 	unsigned int mbox = PCIE_FW_MASTER_M + 1;
-	u32 pcie_fw;
+	int ret;
+
+	/* If the adapter has been fully initialized then we'll go ahead and
+	 * try to get the firmware's cooperation in upgrading to the new
+	 * firmware image otherwise we'll try to do the entire job from the
+	 * host ... and we always "force" the operation in this path.
+	 */
+	if (adap->flags & CXGB4_FULL_INIT_DONE)
+		mbox = adap->mbox;
+
+	ret = t4_fw_upgrade(adap, mbox, data, size, 1);
+	if (ret)
+		dev_err(adap->pdev_dev,
+			"Failed to flash firmware\n");
+
+	return ret;
+}
+
+static int cxgb4_ethtool_flash_region(struct net_device *netdev,
+				      const u8 *data, u32 size, u32 region)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	int ret;
+
+	switch (region) {
+	case CXGB4_ETHTOOL_FLASH_FW:
+		ret = cxgb4_ethtool_flash_fw(netdev, data, size);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	if (!ret)
+		dev_info(adap->pdev_dev,
+			 "loading %s successful, reload cxgb4 driver\n",
+			 flash_region_strings[region]);
+	return ret;
+}
+
+#define CXGB4_FW_SIG 0x4368656c
+#define CXGB4_FW_SIG_OFFSET 0x160
+
+static int cxgb4_validate_fw_image(const u8 *data, u32 *size)
+{
+	struct cxgb4_fw_data *header;
+
+	header = (struct cxgb4_fw_data *)&data[CXGB4_FW_SIG_OFFSET];
+	if (be32_to_cpu(header->signature) != CXGB4_FW_SIG)
+		return -EINVAL;
+
+	if (size)
+		*size = be16_to_cpu(((struct fw_hdr *)data)->len512) * 512;
+
+	return 0;
+}
+
+static int cxgb4_ethtool_get_flash_region(const u8 *data, u32 *size)
+{
+	if (!cxgb4_validate_fw_image(data, size))
+		return CXGB4_ETHTOOL_FLASH_FW;
+
+	return -EOPNOTSUPP;
+}
+
+static int set_flash(struct net_device *netdev, struct ethtool_flash *ef)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	const struct firmware *fw;
 	unsigned int master;
 	u8 master_vld = 0;
+	const u8 *fw_data;
+	size_t fw_size;
+	u32 size = 0;
+	u32 pcie_fw;
+	int region;
+	int ret;
 
 	pcie_fw = t4_read_reg(adap, PCIE_FW_A);
 	master = PCIE_FW_MASTER_G(pcie_fw);
@@ -1261,19 +1339,32 @@ static int set_flash(struct net_device *netdev, struct ethtool_flash *ef)
 	if (ret < 0)
 		return ret;
 
-	/* If the adapter has been fully initialized then we'll go ahead and
-	 * try to get the firmware's cooperation in upgrading to the new
-	 * firmware image otherwise we'll try to do the entire job from the
-	 * host ... and we always "force" the operation in this path.
-	 */
-	if (adap->flags & CXGB4_FULL_INIT_DONE)
-		mbox = adap->mbox;
+	fw_data = fw->data;
+	fw_size = fw->size;
+	if (ef->region == ETHTOOL_FLASH_ALL_REGIONS) {
+		while (fw_size > 0) {
+			size = 0;
+			region = cxgb4_ethtool_get_flash_region(fw_data, &size);
+			if (region < 0 || !size) {
+				ret = region;
+				goto out_free_fw;
+			}
+
+			ret = cxgb4_ethtool_flash_region(netdev, fw_data, size,
+							 region);
+			if (ret)
+				goto out_free_fw;
+
+			fw_data += size;
+			fw_size -= size;
+		}
+	} else {
+		ret = cxgb4_ethtool_flash_region(netdev, fw_data, fw_size,
+						 ef->region);
+	}
 
-	ret = t4_fw_upgrade(adap, mbox, fw->data, fw->size, 1);
+out_free_fw:
 	release_firmware(fw);
-	if (!ret)
-		dev_info(adap->pdev_dev,
-			 "loaded firmware %s, reload cxgb4 driver\n", ef->data);
 	return ret;
 }
 
-- 
2.21.1

