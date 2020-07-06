Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550A7215A11
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgGFOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:54:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7257 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729205AbgGFOyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 10:54:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 972738ED8A5B8E5F3D7D;
        Mon,  6 Jul 2020 22:54:32 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 22:54:23 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next] hinic: add firmware update support
Date:   Mon, 6 Jul 2020 22:54:06 +0800
Message-ID: <20200706145406.7742-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to update firmware with with "ethtool -f" cmd

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 283 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_ethtool.h | 108 +++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  26 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  34 +++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   4 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |  25 ++
 6 files changed, 479 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_ethtool.h

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index cb5ebae54f73..85cf8f3a66b3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -25,6 +25,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ethtool.h>
 #include <linux/vmalloc.h>
+#include <linux/firmware.h>
 #include <linux/sfp.h>
 
 #include "hinic_hw_qp.h"
@@ -33,6 +34,7 @@
 #include "hinic_tx.h"
 #include "hinic_rx.h"
 #include "hinic_dev.h"
+#include "hinic_ethtool.h"
 
 #define SET_LINK_STR_MAX_LEN	128
 
@@ -1766,6 +1768,286 @@ static int hinic_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static bool check_image_valid(struct hinic_dev *nic_dev, const u8 *buf,
+			      u32 image_size, struct host_image_st *host_image)
+{
+	struct fw_image_st *fw_image = NULL;
+	u32 len = 0;
+	u32 i;
+
+	fw_image = (struct fw_image_st *)buf;
+
+	if (fw_image->fw_magic != HINIC_MAGIC_NUM) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Wrong fw_magic read from file, fw_magic: 0x%x\n",
+			  fw_image->fw_magic);
+		return false;
+	}
+
+	if (fw_image->fw_info.fw_section_cnt > MAX_FW_TYPE_NUM) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Wrong fw_type_num read from file, fw_type_num: 0x%x\n",
+			  fw_image->fw_info.fw_section_cnt);
+		return false;
+	}
+
+	for (i = 0; i < fw_image->fw_info.fw_section_cnt; i++) {
+		len += fw_image->fw_section_info[i].fw_section_len;
+		memcpy(&host_image->image_section_info[i],
+		       &fw_image->fw_section_info[i],
+		       sizeof(struct fw_section_info_st));
+	}
+
+	if (len != fw_image->fw_len ||
+	    (fw_image->fw_len + UPDATEFW_IMAGE_HEAD_SIZE) != image_size) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Wrong data size read from file\n");
+		return false;
+	}
+
+	host_image->image_info.up_total_len = fw_image->fw_len;
+	host_image->image_info.fw_version = fw_image->fw_version;
+	host_image->section_type_num = fw_image->fw_info.fw_section_cnt;
+	host_image->device_id = fw_image->device_id;
+
+	return true;
+}
+
+static bool check_image_integrity(struct hinic_dev *nic_dev,
+				  struct host_image_st *host_image,
+				  u32 update_type)
+{
+	u32 collect_section_type = 0;
+	u32 i, type;
+
+	for (i = 0; i < host_image->section_type_num; i++) {
+		type = host_image->image_section_info[i].fw_section_type;
+		if (collect_section_type & (1U << type)) {
+			netif_err(nic_dev, drv, nic_dev->netdev, "Duplicate section type: %u\n",
+				  type);
+			return false;
+		}
+		collect_section_type |= (1U << type);
+	}
+
+	if (update_type == FW_UPDATE_COLD &&
+	    (((collect_section_type & _IMAGE_COLD_SUB_MODULES_MUST_IN) ==
+	       _IMAGE_COLD_SUB_MODULES_MUST_IN) ||
+	      collect_section_type == _IMAGE_CFG_SUB_MODULES_MUST_IN))
+		return true;
+
+	if (update_type == FW_UPDATE_HOT &&
+	    (collect_section_type & _IMAGE_HOT_SUB_MODULES_MUST_IN) ==
+	    _IMAGE_HOT_SUB_MODULES_MUST_IN)
+		return true;
+
+	if (update_type == FW_UPDATE_COLD)
+		netif_err(nic_dev, drv, nic_dev->netdev, "Check file integrity failed, valid: 0x%x or 0x%lx, current: 0x%x\n",
+			  _IMAGE_COLD_SUB_MODULES_MUST_IN,
+			  _IMAGE_CFG_SUB_MODULES_MUST_IN, collect_section_type);
+	else
+		netif_err(nic_dev, drv, nic_dev->netdev, "Check file integrity failed, valid:0x%x, current: 0x%x\n",
+			  _IMAGE_HOT_SUB_MODULES_MUST_IN, collect_section_type);
+
+	return false;
+}
+
+static int check_image_device_type(struct hinic_dev *nic_dev,
+				   u32 image_device_type)
+{
+	struct hinic_comm_board_info board_info = {0};
+
+	if (image_device_type) {
+		if (!hinic_get_board_info(nic_dev->hwdev, &board_info)) {
+			if (image_device_type == board_info.info.board_type)
+				return true;
+
+			netif_err(nic_dev, drv, nic_dev->netdev, "The device type of upgrade file dismatches the device type of current firmware, please check the upgrade file\n");
+			netif_err(nic_dev, drv, nic_dev->netdev, "The image device type: 0x%x, firmware device type: 0x%x\n",
+				  image_device_type, board_info.info.board_type);
+
+			return false;
+		}
+	}
+
+	return false;
+}
+
+static int hinic_flash_fw(struct hinic_dev *nic_dev, const u8 *data,
+			  struct host_image_st *host_image, u32 boot_flag)
+{
+	u32 section_remain_send_len, send_fragment_len, send_pos, up_total_len;
+	struct hinic_cmd_update_fw *fw_update_msg = NULL;
+	u32 section_type, section_crc, section_version;
+	u32 i, len, section_len, section_offset;
+	u16 out_size = sizeof(*fw_update_msg);
+	int total_len_flag = 0;
+	int err;
+
+	fw_update_msg = kzalloc(sizeof(*fw_update_msg), GFP_KERNEL);
+
+	up_total_len = host_image->image_info.up_total_len;
+
+	if (!boot_flag) {
+		for (i = 0; i < host_image->section_type_num; i++) {
+			len = host_image->image_section_info[i].fw_section_len;
+			if (host_image->image_section_info[i].fw_section_type ==
+			    UP_FW_UPDATE_BOOT) {
+				up_total_len = up_total_len - len;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < host_image->section_type_num; i++) {
+		section_len =
+			host_image->image_section_info[i].fw_section_len;
+		section_offset =
+			host_image->image_section_info[i].fw_section_offset;
+		section_remain_send_len = section_len;
+		section_type =
+			host_image->image_section_info[i].fw_section_type;
+		section_crc = host_image->image_section_info[i].fw_section_crc;
+		section_version =
+			host_image->image_section_info[i].fw_section_version;
+
+		if (!boot_flag && section_type == UP_FW_UPDATE_BOOT)
+			continue;
+
+		send_fragment_len = 0;
+		send_pos = 0;
+
+		while (section_remain_send_len > 0) {
+			if (!total_len_flag) {
+				fw_update_msg->total_len = up_total_len;
+				total_len_flag = 1;
+			} else {
+				fw_update_msg->total_len = 0;
+			}
+
+			memset(fw_update_msg->data, 0, MAX_FW_FRAGMENT_LEN);
+
+			fw_update_msg->ctl_info.SF =
+				(section_remain_send_len == section_len) ?
+				true : false;
+			fw_update_msg->section_info.FW_section_CRC = section_crc;
+			fw_update_msg->fw_section_version = section_version;
+			fw_update_msg->ctl_info.flag = UP_TYPE_A;
+
+			if (section_type <= UP_FW_UPDATE_UP_DATA_B) {
+				fw_update_msg->section_info.FW_section_type =
+					(section_type % 2) ?
+					UP_FW_UPDATE_UP_DATA :
+					UP_FW_UPDATE_UP_TEXT;
+
+				fw_update_msg->ctl_info.flag = UP_TYPE_B;
+				if (section_type <= UP_FW_UPDATE_UP_DATA_A)
+					fw_update_msg->ctl_info.flag = UP_TYPE_A;
+			} else {
+				fw_update_msg->section_info.FW_section_type =
+					section_type - 0x2;
+			}
+
+			fw_update_msg->setion_total_len = section_len;
+			fw_update_msg->section_offset = send_pos;
+
+			if (section_remain_send_len <= MAX_FW_FRAGMENT_LEN) {
+				fw_update_msg->ctl_info.SL = true;
+				fw_update_msg->ctl_info.fragment_len =
+					section_remain_send_len;
+				send_fragment_len += section_remain_send_len;
+			} else {
+				fw_update_msg->ctl_info.SL = false;
+				fw_update_msg->ctl_info.fragment_len =
+					MAX_FW_FRAGMENT_LEN;
+				send_fragment_len += MAX_FW_FRAGMENT_LEN;
+			}
+
+			memcpy(fw_update_msg->data,
+			       data + UPDATEFW_IMAGE_HEAD_SIZE +
+			       section_offset + send_pos,
+			       fw_update_msg->ctl_info.fragment_len);
+
+			err = hinic_port_msg_cmd(nic_dev->hwdev,
+						 HINIC_PORT_CMD_UPDATE_FW,
+						 fw_update_msg,
+						 sizeof(*fw_update_msg),
+						 fw_update_msg, &out_size);
+			if (err || !out_size || fw_update_msg->status) {
+				dev_err(&nic_dev->hwdev->hwif->pdev->dev, "Failed to update firmware, err: %d, status: 0x%x, out size: 0x%x\n",
+					err, fw_update_msg->status, out_size);
+				err = fw_update_msg->status ?
+					fw_update_msg->status : -EIO;
+				kfree(fw_update_msg);
+				return err;
+			}
+
+			send_pos = send_fragment_len;
+			section_remain_send_len = section_len -
+						  send_fragment_len;
+		}
+	}
+
+	kfree(fw_update_msg);
+
+	return 0;
+}
+
+static int hinic_firmware_update(struct hinic_dev *nic_dev,
+				 const struct firmware *fw)
+{
+	struct host_image_st host_image = {0};
+	int err;
+
+	if (!check_image_valid(nic_dev, fw->data, fw->size, &host_image) ||
+	    !check_image_integrity(nic_dev, &host_image, FW_UPDATE_COLD) ||
+	    !check_image_device_type(nic_dev, host_image.device_id))
+		return -EINVAL;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Flash firmware begin\n");
+
+	err = hinic_flash_fw(nic_dev, fw->data, &host_image, 0);
+	if (err) {
+		if (err == HINIC_FW_DISMATCH_ERROR)
+			netif_err(nic_dev, drv, nic_dev->netdev, "Firmware image dismatches this card, please use newer image, err: %d\n",
+				  err);
+		else
+			netif_err(nic_dev, drv, nic_dev->netdev, "Send firmware image data failed, err: %d\n",
+				  err);
+		return err;
+	}
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Flash firmware end\n");
+
+	return 0;
+}
+
+static int hinic_flash_device(struct net_device *netdev,
+			      struct ethtool_flash *flash)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	const struct firmware *fw;
+	int err;
+
+	if (flash->region != ETHTOOL_FLASH_ALL_REGIONS)
+		return -EOPNOTSUPP;
+
+	err = request_firmware_direct(&fw, flash->data, &netdev->dev);
+	if (err) {
+		netif_err(nic_dev, drv, netdev, "Request_firmware_direct failed, err: %d\n",
+			  err);
+		return err;
+	}
+
+	dev_hold(netdev);
+	rtnl_unlock();
+
+	err = hinic_firmware_update(nic_dev, fw);
+	release_firmware(fw);
+
+	rtnl_lock();
+	dev_put(netdev);
+
+	return err;
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -1799,6 +2081,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.set_phys_id = hinic_set_phys_id,
 	.get_module_info = hinic_get_module_info,
 	.get_module_eeprom = hinic_get_module_eeprom,
+	.flash_device = hinic_flash_device,
 };
 
 static const struct ethtool_ops hinicvf_ethtool_ops = {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.h b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.h
new file mode 100644
index 000000000000..8c3c35727fb9
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef HINIC_ETHTOOL_H
+#define HINIC_ETHTOOL_H
+
+#define MAX_FW_TYPE_NUM 30
+#define HINIC_MAGIC_NUM 0x18221100
+#define UPDATEFW_IMAGE_HEAD_SIZE 1024
+#define FW_UPDATE_COLD 0
+#define FW_UPDATE_HOT  1
+
+#define UP_TYPE_A 0x0
+#define UP_TYPE_B 0x1
+
+#define MAX_FW_FRAGMENT_LEN 1536
+#define HINIC_FW_DISMATCH_ERROR 10
+
+enum hinic_fw_type {
+	UP_FW_UPDATE_UP_TEXT_A = 0x0,
+	UP_FW_UPDATE_UP_DATA_A,
+	UP_FW_UPDATE_UP_TEXT_B,
+	UP_FW_UPDATE_UP_DATA_B,
+	UP_FW_UPDATE_UP_DICT,
+
+	UP_FW_UPDATE_HLINK_ONE = 0x5,
+	UP_FW_UPDATE_HLINK_TWO,
+	UP_FW_UPDATE_HLINK_THR,
+	UP_FW_UPDATE_PHY,
+	UP_FW_UPDATE_TILE_TEXT,
+
+	UP_FW_UPDATE_TILE_DATA = 0xa,
+	UP_FW_UPDATE_TILE_DICT,
+	UP_FW_UPDATE_PPE_STATE,
+	UP_FW_UPDATE_PPE_BRANCH,
+	UP_FW_UPDATE_PPE_EXTACT,
+
+	UP_FW_UPDATE_CLP_LEGACY = 0xf,
+	UP_FW_UPDATE_PXE_LEGACY,
+	UP_FW_UPDATE_ISCSI_LEGACY,
+	UP_FW_UPDATE_CLP_EFI,
+	UP_FW_UPDATE_PXE_EFI,
+
+	UP_FW_UPDATE_ISCSI_EFI = 0x14,
+	UP_FW_UPDATE_CFG,
+	UP_FW_UPDATE_BOOT,
+	UP_FW_UPDATE_VPD,
+	FILE_TYPE_TOTAL_NUM
+};
+
+#define _IMAGE_UP_ALL_IN   ((1 << UP_FW_UPDATE_UP_TEXT_A) | \
+			    (1 << UP_FW_UPDATE_UP_DATA_A) | \
+			    (1 << UP_FW_UPDATE_UP_TEXT_B) | \
+			    (1 << UP_FW_UPDATE_UP_DATA_B) | \
+			    (1 << UP_FW_UPDATE_UP_DICT) | \
+			    (1 << UP_FW_UPDATE_BOOT) | \
+			    (1 << UP_FW_UPDATE_HLINK_ONE) | \
+			    (1 << UP_FW_UPDATE_HLINK_TWO) | \
+			    (1 << UP_FW_UPDATE_HLINK_THR))
+
+#define _IMAGE_UCODE_ALL_IN ((1 << UP_FW_UPDATE_TILE_TEXT) | \
+			     (1 << UP_FW_UPDATE_TILE_DICT) | \
+			     (1 << UP_FW_UPDATE_PPE_STATE) | \
+			     (1 << UP_FW_UPDATE_PPE_BRANCH) | \
+			     (1 << UP_FW_UPDATE_PPE_EXTACT))
+
+#define _IMAGE_COLD_SUB_MODULES_MUST_IN (_IMAGE_UP_ALL_IN | _IMAGE_UCODE_ALL_IN)
+#define _IMAGE_HOT_SUB_MODULES_MUST_IN (_IMAGE_UP_ALL_IN | _IMAGE_UCODE_ALL_IN)
+#define _IMAGE_CFG_SUB_MODULES_MUST_IN BIT(UP_FW_UPDATE_CFG)
+#define UP_FW_UPDATE_UP_TEXT  0x0
+#define UP_FW_UPDATE_UP_DATA  0x1
+#define UP_FW_UPDATE_VPD_B    0x15
+
+struct fw_section_info_st {
+	u32 fw_section_len;
+	u32 fw_section_offset;
+	u32 fw_section_version;
+	u32 fw_section_type;
+	u32 fw_section_crc;
+};
+
+struct fw_image_st {
+	u32 fw_version;
+	u32 fw_len;
+	u32 fw_magic;
+	struct {
+		u32 fw_section_cnt:16;
+		u32 resd:16;
+	} fw_info;
+	struct fw_section_info_st fw_section_info[MAX_FW_TYPE_NUM];
+	u32 device_id;
+	u32 res[101];
+	void *bin_data;
+};
+
+struct host_image_st {
+	struct fw_section_info_st image_section_info[MAX_FW_TYPE_NUM];
+	struct {
+		u32 up_total_len;
+		u32 fw_version;
+	} image_info;
+	u32 section_type_num;
+	u32 device_id;
+};
+
+#endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 45c137827a16..26777c2a8daa 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -1045,3 +1045,29 @@ void hinic_hwdev_set_msix_state(struct hinic_hwdev *hwdev, u16 msix_index,
 {
 	hinic_set_msix_state(hwdev->hwif, msix_index, flag);
 }
+
+int hinic_get_board_info(struct hinic_hwdev *hwdev,
+			 struct hinic_comm_board_info *board_info)
+{
+	u16 out_size = sizeof(*board_info);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	if (!hwdev || !board_info)
+		return -EINVAL;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_GET_BOARD_INFO,
+				board_info, sizeof(*board_info),
+				board_info, &out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || board_info->status || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to get board info, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, board_info->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 958ea1a6a60d..94593a8ad667 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -116,6 +116,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_TSO          = 112,
 
+	HINIC_PORT_CMD_UPDATE_FW	= 114,
+
 	HINIC_PORT_CMD_SET_RQ_IQ_MAP	= 115,
 
 	HINIC_PORT_CMD_LINK_STATUS_REPORT = 160,
@@ -307,6 +309,35 @@ struct hinic_msix_config {
 	u8	rsvd1[3];
 };
 
+struct hinic_board_info {
+	u32	board_type;
+	u32	port_num;
+	u32	port_speed;
+	u32	pcie_width;
+	u32	host_num;
+	u32	pf_num;
+	u32	vf_total_num;
+	u32	tile_num;
+	u32	qcm_num;
+	u32	core_num;
+	u32	work_mode;
+	u32	service_mode;
+	u32	pcie_mode;
+	u32	cfg_addr;
+	u32	boot_sel;
+	u32	board_id;
+};
+
+struct hinic_comm_board_info {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	struct hinic_board_info info;
+
+	u32	rsvd1[4];
+};
+
 struct hinic_hwdev {
 	struct hinic_hwif               *hwif;
 	struct msix_entry               *msix_entries;
@@ -407,4 +438,7 @@ int hinic_get_interrupt_cfg(struct hinic_hwdev *hwdev,
 int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 			    struct hinic_msix_config *interrupt_info);
 
+int hinic_get_board_info(struct hinic_hwdev *hwdev,
+			 struct hinic_comm_board_info *board_info);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index 919d2c6ffc35..cec4aaacd00b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -87,7 +87,9 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_PAGESIZE_SET	= 0x50,
 
-	HINIC_COMM_CMD_MAX              = 0x51,
+	HINIC_COMM_CMD_GET_BOARD_INFO	= 0x52,
+
+	HINIC_COMM_CMD_MAX,
 };
 
 enum hinic_mgmt_cb_state {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 0e444d2c02bb..0829e61c3cb7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -703,6 +703,31 @@ struct hinic_cmd_get_std_sfp_info {
 	u8 sfp_info[STD_SFP_INFO_MAX_SIZE];
 };
 
+struct hinic_cmd_update_fw {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	struct {
+		u32 SL:1;
+		u32 SF:1;
+		u32 flag:1;
+		u32 reserved:13;
+		u32 fragment_len :16;
+	} ctl_info;
+
+	struct {
+		u32 FW_section_CRC;
+		u32 FW_section_type;
+	} section_info;
+
+	u32 total_len;
+	u32 setion_total_len;
+	u32 fw_section_version;
+	u32 section_offset;
+	u32 data[384];
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
-- 
2.17.1

