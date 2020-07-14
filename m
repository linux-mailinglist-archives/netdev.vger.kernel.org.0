Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB6C21F1F3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgGNMy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:54:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbgGNMy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 08:54:57 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 40C2F915A3EA195AC821;
        Tue, 14 Jul 2020 20:54:54 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 14 Jul 2020 20:54:46 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v2] hinic: add firmware update support
Date:   Tue, 14 Jul 2020 20:54:33 +0800
Message-ID: <20200714125433.18126-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to update firmware by the devlink flashing API

Signed-off-by: Luo bin <luobin9@huawei.com>
---
V1~V2: create separate devlink priv data structure and remove boot_flag
V0~V1: remove the implementation from ethtool to devlink

 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   6 +
 .../net/ethernet/huawei/hinic/hinic_devlink.c | 320 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_devlink.h | 115 +++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  28 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  34 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   4 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  29 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |  25 ++
 9 files changed, 559 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_devlink.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_devlink.h

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index 32a011ca44c3..67b59d0ba769 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o hinic_ethtool.o hinic_hw_mbox.o hinic_sriov.o
+	   hinic_common.o hinic_ethtool.o hinic_devlink.o hinic_hw_mbox.o hinic_sriov.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 9adb755f0820..3bb7a9ed29a8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -97,6 +97,12 @@ struct hinic_dev {
 	int				lb_test_rx_idx;
 	int				lb_pkt_len;
 	u8				*lb_test_rx_buf;
+	struct devlink			*devlink;
+};
+
+struct hinic_devlink_priv {
+	struct hinic_hwdev		*hwdev;
+	struct devlink			*devlink;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
new file mode 100644
index 000000000000..6a3d0d3d45b7
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ */
+#include <linux/netlink.h>
+#include <net/devlink.h>
+#include <linux/firmware.h>
+
+#include "hinic_dev.h"
+#include "hinic_port.h"
+#include "hinic_devlink.h"
+
+static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
+			      u32 image_size, struct host_image_st *host_image)
+{
+	struct fw_image_st *fw_image = NULL;
+	u32 len = 0;
+	u32 i;
+
+	fw_image = (struct fw_image_st *)buf;
+
+	if (fw_image->fw_magic != HINIC_MAGIC_NUM) {
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Wrong fw_magic read from file, fw_magic: 0x%x\n",
+			fw_image->fw_magic);
+		return false;
+	}
+
+	if (fw_image->fw_info.fw_section_cnt > MAX_FW_TYPE_NUM) {
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Wrong fw_type_num read from file, fw_type_num: 0x%x\n",
+			fw_image->fw_info.fw_section_cnt);
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
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Wrong data size read from file\n");
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
+static bool check_image_integrity(struct hinic_devlink_priv *priv,
+				  struct host_image_st *host_image,
+				  u32 update_type)
+{
+	u32 collect_section_type = 0;
+	u32 i, type;
+
+	for (i = 0; i < host_image->section_type_num; i++) {
+		type = host_image->image_section_info[i].fw_section_type;
+		if (collect_section_type & (1U << type)) {
+			dev_err(&priv->hwdev->hwif->pdev->dev, "Duplicate section type: %u\n",
+				type);
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
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Check file integrity failed, valid: 0x%x or 0x%lx, current: 0x%x\n",
+			_IMAGE_COLD_SUB_MODULES_MUST_IN,
+			_IMAGE_CFG_SUB_MODULES_MUST_IN, collect_section_type);
+	else
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Check file integrity failed, valid:0x%x, current: 0x%x\n",
+			_IMAGE_HOT_SUB_MODULES_MUST_IN, collect_section_type);
+
+	return false;
+}
+
+static int check_image_device_type(struct hinic_devlink_priv *priv,
+				   u32 image_device_type)
+{
+	struct hinic_comm_board_info board_info = {0};
+
+	if (hinic_get_board_info(priv->hwdev, &board_info)) {
+		dev_err(&priv->hwdev->hwif->pdev->dev, "Get board info failed\n");
+		return false;
+	}
+
+	if (image_device_type == board_info.info.board_type)
+		return true;
+
+	dev_err(&priv->hwdev->hwif->pdev->dev, "The device type of upgrade file doesn't match the device type of current firmware, please check the upgrade file\n");
+	dev_err(&priv->hwdev->hwif->pdev->dev, "The image device type: 0x%x, firmware device type: 0x%x\n",
+		image_device_type, board_info.info.board_type);
+
+	return false;
+}
+
+static int hinic_flash_fw(struct hinic_devlink_priv *priv, const u8 *data,
+			  struct host_image_st *host_image)
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
+	if (!fw_update_msg)
+		return -ENOMEM;
+
+	up_total_len = host_image->image_info.up_total_len;
+
+	for (i = 0; i < host_image->section_type_num; i++) {
+		len = host_image->image_section_info[i].fw_section_len;
+		if (host_image->image_section_info[i].fw_section_type ==
+		    UP_FW_UPDATE_BOOT) {
+			up_total_len = up_total_len - len;
+			break;
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
+		if (section_type == UP_FW_UPDATE_BOOT)
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
+			err = hinic_port_msg_cmd(priv->hwdev,
+						 HINIC_PORT_CMD_UPDATE_FW,
+						 fw_update_msg,
+						 sizeof(*fw_update_msg),
+						 fw_update_msg, &out_size);
+			if (err || !out_size || fw_update_msg->status) {
+				dev_err(&priv->hwdev->hwif->pdev->dev, "Failed to update firmware, err: %d, status: 0x%x, out size: 0x%x\n",
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
+static int hinic_firmware_update(struct hinic_devlink_priv *priv,
+				 const struct firmware *fw)
+{
+	struct host_image_st host_image;
+	int err;
+
+	memset(&host_image, 0, sizeof(struct host_image_st));
+
+	if (!check_image_valid(priv, fw->data, fw->size, &host_image) ||
+	    !check_image_integrity(priv, &host_image, FW_UPDATE_COLD) ||
+	    !check_image_device_type(priv, host_image.device_id))
+		return -EINVAL;
+
+	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware begin\n");
+
+	err = hinic_flash_fw(priv, fw->data, &host_image);
+	if (err) {
+		if (err == HINIC_FW_DISMATCH_ERROR)
+			dev_err(&priv->hwdev->hwif->pdev->dev, "Firmware image doesn't match this card, please use newer image, err: %d\n",
+				err);
+		else
+			dev_err(&priv->hwdev->hwif->pdev->dev, "Send firmware image data failed, err: %d\n",
+				err);
+		return err;
+	}
+
+	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware end\n");
+
+	return 0;
+}
+
+static int hinic_devlink_flash_update(struct devlink *devlink,
+				      const char *file_name,
+				      const char *component,
+				      struct netlink_ext_ack *extack)
+{
+	struct hinic_devlink_priv *priv = devlink_priv(devlink);
+	const struct firmware *fw;
+	int err;
+
+	if (component)
+		return -EOPNOTSUPP;
+
+	err = request_firmware_direct(&fw, file_name,
+				      &priv->hwdev->hwif->pdev->dev);
+	if (err)
+		return err;
+
+	err = hinic_firmware_update(priv, fw);
+	release_firmware(fw);
+
+	return err;
+}
+
+static const struct devlink_ops hinic_devlink_ops = {
+	.flash_update = hinic_devlink_flash_update,
+};
+
+struct devlink *hinic_devlink_alloc(void)
+{
+	return devlink_alloc(&hinic_devlink_ops, sizeof(struct hinic_dev));
+}
+
+void hinic_devlink_free(struct devlink *devlink)
+{
+	devlink_free(devlink);
+}
+
+int hinic_devlink_register(struct devlink *devlink, struct device *dev)
+{
+	return devlink_register(devlink, dev);
+}
+
+void hinic_devlink_unregister(struct devlink *devlink)
+{
+	devlink_unregister(devlink);
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
new file mode 100644
index 000000000000..604e95a7c5ce
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef __HINIC_DEVLINK_H__
+#define __HINIC_DEVLINK_H__
+
+#include <net/devlink.h>
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
+#define _IMAGE_UP_ALL_IN ((1 << UP_FW_UPDATE_UP_TEXT_A) | \
+			  (1 << UP_FW_UPDATE_UP_DATA_A) | \
+			  (1 << UP_FW_UPDATE_UP_TEXT_B) | \
+			  (1 << UP_FW_UPDATE_UP_DATA_B) | \
+			  (1 << UP_FW_UPDATE_UP_DICT) | \
+			  (1 << UP_FW_UPDATE_BOOT) | \
+			  (1 << UP_FW_UPDATE_HLINK_ONE) | \
+			  (1 << UP_FW_UPDATE_HLINK_TWO) | \
+			  (1 << UP_FW_UPDATE_HLINK_THR))
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
+struct devlink *hinic_devlink_alloc(void);
+void hinic_devlink_free(struct devlink *devlink);
+int hinic_devlink_register(struct devlink *devlink, struct device *dev);
+void hinic_devlink_unregister(struct devlink *devlink);
+
+#endif /* __HINIC_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 47c60d9752e4..9831c14324e6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -897,6 +897,8 @@ void hinic_free_hwdev(struct hinic_hwdev *hwdev)
 
 	set_resources_state(hwdev, HINIC_RES_CLEAN);
 
+	hinic_vf_func_free(hwdev);
+
 	free_pfhwdev(pfhwdev);
 
 	hinic_aeqs_free(&hwdev->aeqs);
@@ -1047,3 +1049,29 @@ void hinic_hwdev_set_msix_state(struct hinic_hwdev *hwdev, u16 msix_index,
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
index e8a55b53c855..21b93b654d6b 100644
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
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 834a20a0043c..a5d0197c2c22 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -18,6 +18,7 @@
 #include <linux/semaphore.h>
 #include <linux/workqueue.h>
 #include <net/ip.h>
+#include <net/devlink.h>
 #include <linux/bitops.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
@@ -25,6 +26,7 @@
 
 #include "hinic_hw_qp.h"
 #include "hinic_hw_dev.h"
+#include "hinic_devlink.h"
 #include "hinic_port.h"
 #include "hinic_tx.h"
 #include "hinic_rx.h"
@@ -1075,9 +1077,11 @@ static int nic_dev_init(struct pci_dev *pdev)
 	struct hinic_rx_mode_work *rx_mode_work;
 	struct hinic_txq_stats *tx_stats;
 	struct hinic_rxq_stats *rx_stats;
+	struct hinic_devlink_priv *priv;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
+	struct devlink *devlink;
 	int err, num_qps;
 
 	hwdev = hinic_init_hwdev(pdev);
@@ -1086,6 +1090,17 @@ static int nic_dev_init(struct pci_dev *pdev)
 		return PTR_ERR(hwdev);
 	}
 
+	devlink = hinic_devlink_alloc();
+	if (!devlink) {
+		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
+		err = -ENOMEM;
+		goto err_devlink_alloc;
+	}
+
+	priv = devlink_priv(devlink);
+	priv->hwdev = hwdev;
+	priv->devlink = devlink;
+
 	num_qps = hinic_hwdev_num_qps(hwdev);
 	if (num_qps <= 0) {
 		dev_err(&pdev->dev, "Invalid number of QPS\n");
@@ -1121,6 +1136,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->sriov_info.hwdev = hwdev;
 	nic_dev->sriov_info.pdev = pdev;
 	nic_dev->max_qps = num_qps;
+	nic_dev->devlink = devlink;
 
 	hinic_set_ethtool_ops(netdev);
 
@@ -1146,6 +1162,10 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_workq;
 	}
 
+	err = hinic_devlink_register(devlink, &pdev->dev);
+	if (err)
+		goto err_devlink_reg;
+
 	pci_set_drvdata(pdev, netdev);
 
 	err = hinic_port_get_mac(nic_dev, netdev->dev_addr);
@@ -1223,9 +1243,11 @@ static int nic_dev_init(struct pci_dev *pdev)
 	cancel_work_sync(&rx_mode_work->work);
 
 err_set_mtu:
-err_get_mac:
+	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
 err_add_mac:
+err_get_mac:
 	pci_set_drvdata(pdev, NULL);
+err_devlink_reg:
 	destroy_workqueue(nic_dev->workq);
 
 err_workq:
@@ -1234,6 +1256,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 err_alloc_etherdev:
 err_num_qps:
+err_devlink_alloc:
 	hinic_free_hwdev(hwdev);
 	return err;
 }
@@ -1342,9 +1365,11 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
+	hinic_devlink_unregister(nic_dev->devlink);
+
 	destroy_workqueue(nic_dev->workq);
 
-	hinic_vf_func_free(nic_dev->hwdev);
+	hinic_devlink_free(nic_dev->devlink);
 
 	hinic_free_hwdev(nic_dev->hwdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 0e444d2c02bb..14931adaffb8 100644
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
+		u32 fragment_len:16;
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

