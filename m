Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F7B1BD33F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD2Drm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:47:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3379 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgD2Drm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 23:47:42 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C8369D2ECF5E782F5F7E;
        Wed, 29 Apr 2020 11:47:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Apr 2020 11:47:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2] net: hns3: adds support for reading module eeprom info
Date:   Wed, 29 Apr 2020 11:46:24 +0800
Message-ID: <1588131984-27468-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

This patch adds support for reading the optical module eeprom
info via "ethtool -m".

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
V2: replace self-defined macro with the SFF8024_ID_* in sfp.h
    suggested by Jakub Kicinski.
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  75 +++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  15 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 102 +++++++++++++++++++++
 4 files changed, 196 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6291aa9..5602bf2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -374,6 +374,8 @@ struct hnae3_ae_dev {
  *   Set the max tx rate of specified vf.
  * set_vf_mac
  *   Configure the default MAC for specified VF
+ * get_module_eeprom
+ *   Get the optical module eeprom info.
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -548,6 +550,8 @@ struct hnae3_ae_ops {
 	int (*set_vf_rate)(struct hnae3_handle *handle, int vf,
 			   int min_tx_rate, int max_tx_rate, bool force);
 	int (*set_vf_mac)(struct hnae3_handle *handle, int vf, u8 *p);
+	int (*get_module_eeprom)(struct hnae3_handle *handle, u32 offset,
+				 u32 len, u8 *data);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 4d9c85f..1a105f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/string.h>
 #include <linux/phy.h>
+#include <linux/sfp.h>
 
 #include "hns3_enet.h"
 
@@ -12,6 +13,11 @@ struct hns3_stats {
 	int stats_offset;
 };
 
+struct hns3_sfp_type {
+	u8 type;
+	u8 ext_type;
+};
+
 /* tqp related stats */
 #define HNS3_TQP_STAT(_string, _member)	{			\
 	.stats_string = _string,				\
@@ -1386,6 +1392,73 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	return ops->set_fec(handle, fec_mode);
 }
 
+static int hns3_get_module_info(struct net_device *netdev,
+				struct ethtool_modinfo *modinfo)
+{
+#define HNS3_SFF_8636_V1_3 0x03
+
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	struct hns3_sfp_type sfp_type;
+	int ret;
+
+	if (handle->pdev->revision == 0x20 || !ops->get_module_eeprom)
+		return -EOPNOTSUPP;
+
+	memset(&sfp_type, 0, sizeof(sfp_type));
+	ret = ops->get_module_eeprom(handle, 0, sizeof(sfp_type) / sizeof(u8),
+				     (u8 *)&sfp_type);
+	if (ret)
+		return ret;
+
+	switch (sfp_type.type) {
+	case SFF8024_ID_SFP:
+		modinfo->type = ETH_MODULE_SFF_8472;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		break;
+	case SFF8024_ID_QSFP_8438:
+		modinfo->type = ETH_MODULE_SFF_8436;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
+		break;
+	case SFF8024_ID_QSFP_8436_8636:
+		if (sfp_type.ext_type < HNS3_SFF_8636_V1_3) {
+			modinfo->type = ETH_MODULE_SFF_8436;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
+		} else {
+			modinfo->type = ETH_MODULE_SFF_8636;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
+		}
+		break;
+	case SFF8024_ID_QSFP28_8636:
+		modinfo->type = ETH_MODULE_SFF_8636;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
+		break;
+	default:
+		netdev_err(netdev, "Optical module unknown: %#x\n",
+			   sfp_type.type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hns3_get_module_eeprom(struct net_device *netdev,
+				  struct ethtool_eeprom *ee, u8 *data)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (handle->pdev->revision == 0x20 || !ops->get_module_eeprom)
+		return -EOPNOTSUPP;
+
+	if (!ee->len)
+		return -EINVAL;
+
+	memset(data, 0, ee->len);
+
+	return ops->get_module_eeprom(handle, ee->offset, ee->len, data);
+}
+
 #define HNS3_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_USECS |		\
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
@@ -1449,6 +1522,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_msglevel = hns3_set_msglevel,
 	.get_fecparam = hns3_get_fecparam,
 	.set_fecparam = hns3_set_fecparam,
+	.get_module_info = hns3_get_module_info,
+	.get_module_eeprom = hns3_get_module_eeprom,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 90e422ef..9a9d752 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -270,6 +270,8 @@ enum hclge_opcode_type {
 	HCLGE_OPC_M7_COMPAT_CFG		= 0x701A,
 
 	/* SFP command */
+	HCLGE_OPC_GET_SFP_EEPROM	= 0x7100,
+	HCLGE_OPC_GET_SFP_EXIST		= 0x7101,
 	HCLGE_OPC_GET_SFP_INFO		= 0x7104,
 
 	/* Error INT commands */
@@ -1054,6 +1056,19 @@ struct hclge_firmware_compat_cmd {
 	u8 rsv[20];
 };
 
+#define HCLGE_SFP_INFO_CMD_NUM	6
+#define HCLGE_SFP_INFO_BD0_LEN	20
+#define HCLGE_SFP_INFO_BDX_LEN	24
+#define HCLGE_SFP_INFO_MAX_LEN \
+	(HCLGE_SFP_INFO_BD0_LEN + \
+	(HCLGE_SFP_INFO_CMD_NUM - 1) * HCLGE_SFP_INFO_BDX_LEN)
+
+struct hclge_sfp_info_bd0_cmd {
+	__le16 offset;
+	__le16 read_len;
+	u8 data[HCLGE_SFP_INFO_BD0_LEN];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e2fec83..71a54dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11119,6 +11119,107 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 	}
 }
 
+static bool hclge_module_existed(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc;
+	u32 existed;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_GET_SFP_EXIST, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get SFP exist state, ret = %d\n", ret);
+		return false;
+	}
+
+	existed = le32_to_cpu(desc.data[0]);
+
+	return existed != 0;
+}
+
+/* need 6 bds(total 140 bytes) in one reading
+ * return the number of bytes actually read, 0 means read failed.
+ */
+static u16 hclge_get_sfp_eeprom_info(struct hclge_dev *hdev, u32 offset,
+				     u32 len, u8 *data)
+{
+	struct hclge_desc desc[HCLGE_SFP_INFO_CMD_NUM];
+	struct hclge_sfp_info_bd0_cmd *sfp_info_bd0;
+	u16 read_len;
+	u16 copy_len;
+	int ret;
+	int i;
+
+	/* setup all 6 bds to read module eeprom info. */
+	for (i = 0; i < HCLGE_SFP_INFO_CMD_NUM; i++) {
+		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_GET_SFP_EEPROM,
+					   true);
+
+		/* bd0~bd4 need next flag */
+		if (i < HCLGE_SFP_INFO_CMD_NUM - 1)
+			desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	}
+
+	/* setup bd0, this bd contains offset and read length. */
+	sfp_info_bd0 = (struct hclge_sfp_info_bd0_cmd *)desc[0].data;
+	sfp_info_bd0->offset = cpu_to_le16((u16)offset);
+	read_len = min_t(u16, len, HCLGE_SFP_INFO_MAX_LEN);
+	sfp_info_bd0->read_len = cpu_to_le16(read_len);
+
+	ret = hclge_cmd_send(&hdev->hw, desc, i);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get SFP eeprom info, ret = %d\n", ret);
+		return 0;
+	}
+
+	/* copy sfp info from bd0 to out buffer. */
+	copy_len = min_t(u16, len, HCLGE_SFP_INFO_BD0_LEN);
+	memcpy(data, sfp_info_bd0->data, copy_len);
+	read_len = copy_len;
+
+	/* copy sfp info from bd1~bd5 to out buffer if needed. */
+	for (i = 1; i < HCLGE_SFP_INFO_CMD_NUM; i++) {
+		if (read_len >= len)
+			return read_len;
+
+		copy_len = min_t(u16, len - read_len, HCLGE_SFP_INFO_BDX_LEN);
+		memcpy(data + read_len, desc[i].data, copy_len);
+		read_len += copy_len;
+	}
+
+	return read_len;
+}
+
+static int hclge_get_module_eeprom(struct hnae3_handle *handle, u32 offset,
+				   u32 len, u8 *data)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 read_len = 0;
+	u16 data_len;
+
+	if (hdev->hw.mac.media_type != HNAE3_MEDIA_TYPE_FIBER)
+		return -EOPNOTSUPP;
+
+	if (!hclge_module_existed(hdev))
+		return -ENXIO;
+
+	while (read_len < len) {
+		data_len = hclge_get_sfp_eeprom_info(hdev,
+						     offset + read_len,
+						     len - read_len,
+						     data + read_len);
+		if (!data_len)
+			return -EIO;
+
+		read_len += data_len;
+	}
+
+	return 0;
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -11211,6 +11312,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_vf_trust = hclge_set_vf_trust,
 	.set_vf_rate = hclge_set_vf_rate,
 	.set_vf_mac = hclge_set_vf_mac,
+	.get_module_eeprom = hclge_get_module_eeprom,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.7.4

