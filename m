Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F420547D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgFWOZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:25:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6311 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732993AbgFWOZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 10:25:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6444B347C528EBEE661A;
        Tue, 23 Jun 2020 22:25:07 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Tue, 23 Jun 2020 22:24:56 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v2 5/5] hinic: add support to get eeprom information
Date:   Tue, 23 Jun 2020 22:24:09 +0800
Message-ID: <20200623142409.19081-6-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623142409.19081-1-luobin9@huawei.com>
References: <20200623142409.19081-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to get eeprom information from the plug-in module
with ethtool -m cmd.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 69 +++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  4 +
 .../net/ethernet/huawei/hinic/hinic_port.c    | 75 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 30 ++++++++
 4 files changed, 178 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 770d548d0f99..66538e0c15eb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -25,6 +25,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ethtool.h>
 #include <linux/vmalloc.h>
+#include <linux/sfp.h>
 
 #include "hinic_hw_qp.h"
 #include "hinic_hw_dev.h"
@@ -1795,6 +1796,72 @@ static int hinic_set_phys_id(struct net_device *netdev,
 	return err;
 }
 
+static int hinic_get_module_info(struct net_device *netdev,
+				 struct ethtool_modinfo *modinfo)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u8 sfp_type_ext;
+	u8 sfp_type;
+	int err;
+
+	err = hinic_get_sfp_type(nic_dev->hwdev, &sfp_type, &sfp_type_ext);
+	if (err)
+		return err;
+
+	switch (sfp_type) {
+	case SFF8024_ID_SFP:
+		modinfo->type = ETH_MODULE_SFF_8472;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		break;
+	case SFF8024_ID_QSFP_8438:
+		modinfo->type = ETH_MODULE_SFF_8436;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
+		break;
+	case SFF8024_ID_QSFP_8436_8636:
+		if (sfp_type_ext >= 0x3) {
+			modinfo->type = ETH_MODULE_SFF_8636;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
+
+		} else {
+			modinfo->type = ETH_MODULE_SFF_8436;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
+		}
+		break;
+	case SFF8024_ID_QSFP28_8636:
+		modinfo->type = ETH_MODULE_SFF_8636;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
+		break;
+	default:
+		netif_warn(nic_dev, drv, netdev,
+			   "Optical module unknown: 0x%x\n", sfp_type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hinic_get_module_eeprom(struct net_device *netdev,
+				   struct ethtool_eeprom *ee, u8 *data)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u8 sfp_data[STD_SFP_INFO_MAX_SIZE];
+	u16 len;
+	int err;
+
+	if (!ee->len || ((ee->len + ee->offset) > STD_SFP_INFO_MAX_SIZE))
+		return -EINVAL;
+
+	memset(data, 0, ee->len);
+
+	err = hinic_get_sfp_eeprom(nic_dev->hwdev, sfp_data, &len);
+	if (err)
+		return err;
+
+	memcpy(data, sfp_data + ee->offset, ee->len);
+
+	return 0;
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -1826,6 +1893,8 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_strings = hinic_get_strings,
 	.self_test = hinic_diag_test,
 	.set_phys_id = hinic_set_phys_id,
+	.get_module_info = hinic_get_module_info,
+	.get_module_eeprom = hinic_get_module_eeprom,
 };
 
 static const struct ethtool_ops hinicvf_ethtool_ops = {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 01fe94f2d4bc..958ea1a6a60d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -130,9 +130,13 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_AUTONEG	= 219,
 
+	HINIC_PORT_CMD_GET_STD_SFP_INFO = 240,
+
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
 
 	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
+
+	HINIC_PORT_CMD_GET_SFP_ABS	= 251,
 };
 
 /* cmd of mgmt CPU message for HILINK module */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index fc99d9f6799a..428d186956f3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -1326,3 +1326,78 @@ int hinic_reset_led_status(struct hinic_hwdev *hwdev, u8 port)
 
 	return err;
 }
+
+static bool hinic_if_sfp_absent(struct hinic_hwdev *hwdev)
+{
+	struct hinic_cmd_get_light_module_abs sfp_abs = {0};
+	u16 out_size = sizeof(sfp_abs);
+	u8 port_id = hwdev->port_id;
+	int err;
+
+	sfp_abs.port_id = port_id;
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_SFP_ABS,
+				 &sfp_abs, sizeof(sfp_abs), &sfp_abs,
+				 &out_size);
+	if (sfp_abs.status || err || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to get port%d sfp absent status, err: %d, status: 0x%x, out size: 0x%x\n",
+			port_id, err, sfp_abs.status, out_size);
+		return true;
+	}
+
+	return ((sfp_abs.abs_status == 0) ? false : true);
+}
+
+int hinic_get_sfp_eeprom(struct hinic_hwdev *hwdev, u8 *data, u16 *len)
+{
+	struct hinic_cmd_get_std_sfp_info sfp_info = {0};
+	u16 out_size = sizeof(sfp_info);
+	u8 port_id;
+	int err;
+
+	if (!hwdev || !data || !len)
+		return -EINVAL;
+
+	port_id = hwdev->port_id;
+
+	if (hinic_if_sfp_absent(hwdev))
+		return -ENXIO;
+
+	sfp_info.port_id = port_id;
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_STD_SFP_INFO,
+				 &sfp_info, sizeof(sfp_info), &sfp_info,
+				 &out_size);
+	if (sfp_info.status || err || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to get port%d sfp eeprom information, err: %d, status: 0x%x, out size: 0x%x\n",
+			port_id, err, sfp_info.status, out_size);
+		return -EIO;
+	}
+
+	*len = min_t(u16, sfp_info.eeprom_len, STD_SFP_INFO_MAX_SIZE);
+	memcpy(data, sfp_info.sfp_info, STD_SFP_INFO_MAX_SIZE);
+
+	return  0;
+}
+
+int hinic_get_sfp_type(struct hinic_hwdev *hwdev, u8 *data0, u8 *data1)
+{
+	u8 sfp_data[STD_SFP_INFO_MAX_SIZE];
+	u16 len;
+	int err;
+
+	if (!hwdev || !data0 || !data1)
+		return -EINVAL;
+
+	if (hinic_if_sfp_absent(hwdev))
+		return -ENXIO;
+
+	err = hinic_get_sfp_eeprom(hwdev, sfp_data, &len);
+	if (err)
+		return err;
+
+	*data0 = sfp_data[0];
+	*data1 = sfp_data[1];
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 5c916875f295..0e444d2c02bb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -677,6 +677,32 @@ struct hinic_led_info {
 	u8	reset;
 };
 
+#define STD_SFP_INFO_MAX_SIZE	640
+
+struct hinic_cmd_get_light_module_abs {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	u8 port_id;
+	u8 abs_status; /* 0:present, 1:absent */
+	u8 rsv[2];
+};
+
+#define STD_SFP_INFO_MAX_SIZE	640
+
+struct hinic_cmd_get_std_sfp_info {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	u8 port_id;
+	u8 wire_type;
+	u16 eeprom_len;
+	u32 rsvd;
+	u8 sfp_info[STD_SFP_INFO_MAX_SIZE];
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
@@ -800,6 +826,10 @@ int hinic_reset_led_status(struct hinic_hwdev *hwdev, u8 port);
 int hinic_set_led_status(struct hinic_hwdev *hwdev, u8 port,
 			 enum hinic_led_type type, enum hinic_led_mode mode);
 
+int hinic_get_sfp_type(struct hinic_hwdev *hwdev, u8 *data0, u8 *data1);
+
+int hinic_get_sfp_eeprom(struct hinic_hwdev *hwdev, u8 *data, u16 *len);
+
 int hinic_open(struct net_device *netdev);
 
 int hinic_close(struct net_device *netdev);
-- 
2.17.1

