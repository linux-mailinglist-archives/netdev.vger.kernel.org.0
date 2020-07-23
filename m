Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8086A22B186
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgGWOk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:40:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbgGWOk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 10:40:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1796A448245B3C4B532A;
        Thu, 23 Jul 2020 22:40:42 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 22:40:33 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v3 1/2] hinic: add support to handle hw abnormal event
Date:   Thu, 23 Jul 2020 22:40:37 +0800
Message-ID: <20200723144038.10430-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723144038.10430-1-luobin9@huawei.com>
References: <20200723144038.10430-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to handle hw abnormal event such as hardware failure,
cable unplugged,link error

Signed-off-by: Luo bin <luobin9@huawei.com>
---
V2~V3: add devlink health support
V1~V2: add link extended state
V0~V1: fix auto build test WARNING

 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   4 +
 .../net/ethernet/huawei/hinic/hinic_devlink.c | 299 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_devlink.h |   8 +-
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  20 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 148 ++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 148 ++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  10 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   4 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  87 +++--
 .../net/ethernet/huawei/hinic/hinic_port.h    |  25 ++
 10 files changed, 717 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index befd925c03dc..0a1e20edf7cf 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -98,10 +98,14 @@ struct hinic_dev {
 	int				lb_pkt_len;
 	u8				*lb_test_rx_buf;
 	struct devlink			*devlink;
+	bool				cable_unplugged;
+	bool				module_unrecognized;
 };
 
 struct hinic_devlink_priv {
 	struct hinic_hwdev		*hwdev;
+	struct devlink_health_reporter  *hw_fault_reporter;
+	struct devlink_health_reporter  *fw_fault_reporter;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index a40a10ac1ee9..926d53a40a1d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -16,9 +16,9 @@
 #include <net/devlink.h>
 #include <linux/firmware.h>
 
-#include "hinic_dev.h"
 #include "hinic_port.h"
 #include "hinic_devlink.h"
+#include "hinic_hw_dev.h"
 
 static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
 			      u32 image_size, struct host_image_st *host_image)
@@ -317,12 +317,305 @@ void hinic_devlink_free(struct devlink *devlink)
 	devlink_free(devlink);
 }
 
-int hinic_devlink_register(struct devlink *devlink, struct device *dev)
+int hinic_devlink_register(struct hinic_devlink_priv *priv, struct device *dev)
 {
+	struct devlink *devlink = priv_to_devlink(priv);
+
 	return devlink_register(devlink, dev);
 }
 
-void hinic_devlink_unregister(struct devlink *devlink)
+void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
 {
+	struct devlink *devlink = priv_to_devlink(priv);
+
 	devlink_unregister(devlink);
 }
+
+static int chip_fault_show(struct devlink_fmsg *fmsg,
+			   struct hinic_fault_event *event)
+{
+	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+		"fatal", "reset", "flr", "general", "suggestion"};
+	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
+	u8 level;
+	int err;
+
+	level = event->event.chip.err_level;
+	if (level < FAULT_LEVEL_MAX)
+		strncpy(level_str, fault_level[level],
+			FAULT_SHOW_STR_LEN);
+	else
+		strncpy(level_str, "Unknown", strlen("Unknown"));
+
+	if (level == FAULT_LEVEL_SERIOUS_FLR) {
+		err = devlink_fmsg_u32_pair_put(fmsg, "Function level err func_id",
+						(u32)event->event.chip.func_id);
+		if (err)
+			return err;
+	}
+
+	err = devlink_fmsg_u8_pair_put(fmsg, "module_id", event->event.chip.node_id);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "err_type", (u32)event->event.chip.err_type);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_string_pair_put(fmsg, "err_level", level_str);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "err_csr_addr",
+					event->event.chip.err_csr_addr);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "err_csr_value",
+					event->event.chip.err_csr_value);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int fault_report_show(struct devlink_fmsg *fmsg,
+			     struct hinic_fault_event *event)
+{
+	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+		"chip", "ucode", "mem rd timeout", "mem wr timeout",
+		"reg rd timeout", "reg wr timeout", "phy fault"};
+	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
+	int err;
+
+	if (event->type < FAULT_TYPE_MAX)
+		strncpy(type_str, fault_type[event->type], FAULT_SHOW_STR_LEN);
+	else
+		strncpy(type_str, "Unknown", strlen("Unknown"));
+
+	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_binary_pair_put(fmsg, "Fault raw data",
+					   event->event.val, sizeof(event->event.val));
+	if (err)
+		return err;
+
+	switch (event->type) {
+	case FAULT_TYPE_CHIP:
+		err = chip_fault_show(fmsg, event);
+		if (err)
+			return err;
+		break;
+	case FAULT_TYPE_UCODE:
+		err = devlink_fmsg_u8_pair_put(fmsg, "Cause_id", event->event.ucode.cause_id);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg, "core_id", event->event.ucode.core_id);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg, "c_id", event->event.ucode.c_id);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg, "epc", event->event.ucode.epc);
+		if (err)
+			return err;
+		break;
+	case FAULT_TYPE_MEM_RD_TIMEOUT:
+	case FAULT_TYPE_MEM_WR_TIMEOUT:
+		err = devlink_fmsg_u32_pair_put(fmsg, "Err_csr_ctrl",
+						event->event.mem_timeout.err_csr_ctrl);
+		if (err)
+			return err;
+		err = devlink_fmsg_u32_pair_put(fmsg, "err_csr_data",
+						event->event.mem_timeout.err_csr_data);
+		if (err)
+			return err;
+		err = devlink_fmsg_u32_pair_put(fmsg, "ctrl_tab",
+						event->event.mem_timeout.ctrl_tab);
+		if (err)
+			return err;
+		err = devlink_fmsg_u32_pair_put(fmsg, "mem_index",
+						event->event.mem_timeout.mem_index);
+		if (err)
+			return err;
+		break;
+	case FAULT_TYPE_REG_RD_TIMEOUT:
+	case FAULT_TYPE_REG_WR_TIMEOUT:
+		err = devlink_fmsg_u32_pair_put(fmsg, "Err_csr", event->event.reg_timeout.err_csr);
+		if (err)
+			return err;
+		break;
+	case FAULT_TYPE_PHY_FAULT:
+		err = devlink_fmsg_u8_pair_put(fmsg, "Op_type", event->event.phy_fault.op_type);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg, "port_id", event->event.phy_fault.port_id);
+		if (err)
+			return err;
+		err = devlink_fmsg_u8_pair_put(fmsg, "dev_ad", event->event.phy_fault.dev_ad);
+		if (err)
+			return err;
+
+		err = devlink_fmsg_u32_pair_put(fmsg, "csr_addr", event->event.phy_fault.csr_addr);
+		if (err)
+			return err;
+		err = devlink_fmsg_u32_pair_put(fmsg, "op_data", event->event.phy_fault.op_data);
+		if (err)
+			return err;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int hinic_hw_reporter_dump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	struct hinic_fault_event *event;
+	int err;
+
+	if (priv_ctx) {
+		event = priv_ctx;
+		err = fault_report_show(fmsg, event);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int mgmt_watchdog_report_show(struct devlink_fmsg *fmsg,
+				     struct hinic_mgmt_watchdog_info *watchdog_info)
+{
+	int err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "Mgmt deadloop time_h", watchdog_info->curr_time_h);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "time_l", watchdog_info->curr_time_l);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "task_id", watchdog_info->task_id);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "sp", watchdog_info->sp);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "stack_current_used", watchdog_info->curr_used);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "peak_used", watchdog_info->peak_used);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "\n Overflow_flag", watchdog_info->is_overflow);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "stack_top", watchdog_info->stack_top);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "stack_bottom", watchdog_info->stack_bottom);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "mgmt_pc", watchdog_info->pc);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "lr", watchdog_info->lr);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "cpsr", watchdog_info->cpsr);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_binary_pair_put(fmsg, "Mgmt register info",
+					   watchdog_info->reg, sizeof(watchdog_info->reg));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_binary_pair_put(fmsg, "Mgmt dump stack(start from sp)",
+					   watchdog_info->data, sizeof(watchdog_info->data));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	struct hinic_mgmt_watchdog_info *watchdog_info;
+	int err;
+
+	if (priv_ctx) {
+		watchdog_info = priv_ctx;
+		err = mgmt_watchdog_report_show(fmsg, watchdog_info);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops hinic_hw_fault_reporter_ops = {
+	.name = "hw",
+	.dump = hinic_hw_reporter_dump,
+};
+
+static const struct devlink_health_reporter_ops hinic_fw_fault_reporter_ops = {
+	.name = "fw",
+	.dump = hinic_fw_reporter_dump,
+};
+
+int hinic_health_reporters_create(struct hinic_devlink_priv *priv)
+{
+	struct devlink *devlink = priv_to_devlink(priv);
+
+	priv->hw_fault_reporter =
+		devlink_health_reporter_create(devlink, &hinic_hw_fault_reporter_ops,
+					       0, priv);
+	if (IS_ERR(priv->hw_fault_reporter)) {
+		dev_warn(&priv->hwdev->hwif->pdev->dev, "Failed to create hw fault reporter, err: %ld\n",
+			 PTR_ERR(priv->hw_fault_reporter));
+		return PTR_ERR(priv->hw_fault_reporter);
+	}
+
+	priv->fw_fault_reporter =
+		devlink_health_reporter_create(devlink, &hinic_fw_fault_reporter_ops,
+					       0, priv);
+	if (IS_ERR(priv->fw_fault_reporter)) {
+		dev_warn(&priv->hwdev->hwif->pdev->dev, "Failed to create fw fault reporter, err: %ld\n",
+			 PTR_ERR(priv->fw_fault_reporter));
+		return PTR_ERR(priv->fw_fault_reporter);
+	}
+
+	return 0;
+}
+
+void hinic_health_reporters_destroy(struct hinic_devlink_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->fw_fault_reporter)) {
+		devlink_health_reporter_destroy(priv->fw_fault_reporter);
+		priv->fw_fault_reporter = NULL;
+	}
+
+	if (!IS_ERR_OR_NULL(priv->hw_fault_reporter)) {
+		devlink_health_reporter_destroy(priv->hw_fault_reporter);
+		priv->hw_fault_reporter = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
index 604e95a7c5ce..a090ebcfaabb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
@@ -7,6 +7,7 @@
 #define __HINIC_DEVLINK_H__
 
 #include <net/devlink.h>
+#include "hinic_dev.h"
 
 #define MAX_FW_TYPE_NUM 30
 #define HINIC_MAGIC_NUM 0x18221100
@@ -109,7 +110,10 @@ struct host_image_st {
 
 struct devlink *hinic_devlink_alloc(void);
 void hinic_devlink_free(struct devlink *devlink);
-int hinic_devlink_register(struct devlink *devlink, struct device *dev);
-void hinic_devlink_unregister(struct devlink *devlink);
+int hinic_devlink_register(struct hinic_devlink_priv *priv, struct device *dev);
+void hinic_devlink_unregister(struct hinic_devlink_priv *priv);
+
+int hinic_health_reporters_create(struct hinic_devlink_priv *priv);
+void hinic_health_reporters_destroy(struct hinic_devlink_priv *priv);
 
 #endif /* __HINIC_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index cb5ebae54f73..6bb65ade1d77 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1766,6 +1766,25 @@ static int hinic_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static int
+hinic_get_link_ext_state(struct net_device *netdev,
+			 struct ethtool_link_ext_state_info *link_ext_state_info)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+
+	if (netif_carrier_ok(netdev))
+		return -ENODATA;
+
+	if (nic_dev->cable_unplugged)
+		link_ext_state_info->link_ext_state =
+			ETHTOOL_LINK_EXT_STATE_NO_CABLE;
+	else if (nic_dev->module_unrecognized)
+		link_ext_state_info->link_ext_state =
+			ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH;
+
+	return 0;
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -1776,6 +1795,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
 	.set_link_ksettings = hinic_set_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
+	.get_link_ext_state = hinic_get_link_ext_state,
 	.get_ringparam = hinic_get_ringparam,
 	.set_ringparam = hinic_set_ringparam,
 	.get_coalesce = hinic_get_coalesce,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 9831c14324e6..55672ee18aab 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -16,8 +16,11 @@
 #include <linux/log2.h>
 #include <linux/err.h>
 #include <linux/netdevice.h>
+#include <net/devlink.h>
 
+#include "hinic_devlink.h"
 #include "hinic_sriov.h"
+#include "hinic_dev.h"
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
 #include "hinic_hw_mgmt.h"
@@ -621,6 +624,113 @@ static void nic_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
 	nic_cb->cb_state &= ~HINIC_CB_RUNNING;
 }
 
+static void hinic_comm_recv_mgmt_self_cmd_reg(struct hinic_pfhwdev *pfhwdev,
+					      u8 cmd,
+					      comm_mgmt_self_msg_proc proc)
+{
+	u8 cmd_idx;
+
+	cmd_idx = pfhwdev->proc.cmd_num;
+	if (cmd_idx >= HINIC_COMM_SELF_CMD_MAX) {
+		dev_err(&pfhwdev->hwdev.hwif->pdev->dev,
+			"Register recv mgmt process failed, cmd: 0x%x\n", cmd);
+		return;
+	}
+
+	pfhwdev->proc.info[cmd_idx].cmd = cmd;
+	pfhwdev->proc.info[cmd_idx].proc = proc;
+	pfhwdev->proc.cmd_num++;
+}
+
+static void hinic_comm_recv_mgmt_self_cmd_unreg(struct hinic_pfhwdev *pfhwdev,
+						u8 cmd)
+{
+	u8 cmd_idx;
+
+	cmd_idx = pfhwdev->proc.cmd_num;
+	if (cmd_idx >= HINIC_COMM_SELF_CMD_MAX) {
+		dev_err(&pfhwdev->hwdev.hwif->pdev->dev, "Unregister recv mgmt process failed, cmd: 0x%x\n",
+			cmd);
+		return;
+	}
+
+	for (cmd_idx = 0; cmd_idx < HINIC_COMM_SELF_CMD_MAX; cmd_idx++) {
+		if (cmd == pfhwdev->proc.info[cmd_idx].cmd) {
+			pfhwdev->proc.info[cmd_idx].cmd = 0;
+			pfhwdev->proc.info[cmd_idx].proc = NULL;
+			pfhwdev->proc.cmd_num--;
+		}
+	}
+}
+
+static void comm_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
+				  u16 in_size, void *buf_out, u16 *out_size)
+{
+	struct hinic_pfhwdev *pfhwdev = handle;
+	u8 cmd_idx;
+
+	for (cmd_idx = 0; cmd_idx < pfhwdev->proc.cmd_num; cmd_idx++) {
+		if (cmd == pfhwdev->proc.info[cmd_idx].cmd) {
+			if (!pfhwdev->proc.info[cmd_idx].proc) {
+				dev_warn(&pfhwdev->hwdev.hwif->pdev->dev,
+					 "PF recv mgmt comm msg handle null, cmd: 0x%x\n",
+					 cmd);
+			} else {
+				pfhwdev->proc.info[cmd_idx].proc
+					(&pfhwdev->hwdev, buf_in, in_size,
+					 buf_out, out_size);
+			}
+
+			return;
+		}
+	}
+
+	dev_warn(&pfhwdev->hwdev.hwif->pdev->dev, "Received unknown mgmt cpu event: 0x%x\n",
+		 cmd);
+
+	*out_size = 0;
+}
+
+/* pf fault report event */
+static void pf_fault_event_handler(void *dev, void *buf_in, u16 in_size,
+				   void *buf_out, u16 *out_size)
+{
+	struct hinic_cmd_fault_event *fault_event = buf_in;
+	struct hinic_hwdev *hwdev = dev;
+
+	if (in_size != sizeof(*fault_event)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Invalid fault event report, length: %d, should be %zu\n",
+			in_size, sizeof(*fault_event));
+		return;
+	}
+
+	if (!hwdev->devlink_dev || IS_ERR_OR_NULL(hwdev->devlink_dev->hw_fault_reporter))
+		return;
+
+	devlink_health_report(hwdev->devlink_dev->hw_fault_reporter,
+			      "HW fatal error reported", &fault_event->event);
+}
+
+static void mgmt_watchdog_timeout_event_handler(void *dev,
+						void *buf_in, u16 in_size,
+						void *buf_out, u16 *out_size)
+{
+	struct hinic_mgmt_watchdog_info *watchdog_info = buf_in;
+	struct hinic_hwdev *hwdev = dev;
+
+	if (in_size != sizeof(*watchdog_info)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Invalid mgmt watchdog report, length: %d, should be %zu\n",
+			in_size, sizeof(*watchdog_info));
+		return;
+	}
+
+	if (!hwdev->devlink_dev || IS_ERR_OR_NULL(hwdev->devlink_dev->fw_fault_reporter))
+		return;
+
+	devlink_health_report(hwdev->devlink_dev->fw_fault_reporter,
+			      "FW fatal error reported", watchdog_info);
+}
+
 /**
  * init_pfhwdev - Initialize the extended components of PF
  * @pfhwdev: the HW device for PF
@@ -640,20 +750,37 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 		return err;
 	}
 
+	err = hinic_devlink_register(hwdev->devlink_dev, &pdev->dev);
+	if (err) {
+		dev_err(&hwif->pdev->dev, "Failed to register devlink\n");
+		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
+		return err;
+	}
+
 	err = hinic_func_to_func_init(hwdev);
 	if (err) {
 		dev_err(&hwif->pdev->dev, "Failed to init mailbox\n");
+		hinic_devlink_unregister(hwdev->devlink_dev);
 		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 		return err;
 	}
 
-	if (!HINIC_IS_VF(hwif))
+	if (!HINIC_IS_VF(hwif)) {
 		hinic_register_mgmt_msg_cb(&pfhwdev->pf_to_mgmt,
 					   HINIC_MOD_L2NIC, pfhwdev,
 					   nic_mgmt_msg_handler);
-	else
+		hinic_register_mgmt_msg_cb(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+					   pfhwdev, comm_mgmt_msg_handler);
+		hinic_comm_recv_mgmt_self_cmd_reg(pfhwdev,
+						  HINIC_COMM_CMD_FAULT_REPORT,
+						  pf_fault_event_handler);
+		hinic_comm_recv_mgmt_self_cmd_reg
+			(pfhwdev, HINIC_COMM_CMD_WATCHDOG_INFO,
+			 mgmt_watchdog_timeout_event_handler);
+	} else {
 		hinic_register_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC,
 					  nic_mgmt_msg_handler);
+	}
 
 	hinic_set_pf_action(hwif, HINIC_PF_MGMT_ACTIVE);
 
@@ -670,14 +797,23 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 
 	hinic_set_pf_action(hwdev->hwif, HINIC_PF_MGMT_INIT);
 
-	if (!HINIC_IS_VF(hwdev->hwif))
+	if (!HINIC_IS_VF(hwdev->hwif)) {
+		hinic_comm_recv_mgmt_self_cmd_unreg(pfhwdev,
+						    HINIC_COMM_CMD_WATCHDOG_INFO);
+		hinic_comm_recv_mgmt_self_cmd_unreg(pfhwdev,
+						    HINIC_COMM_CMD_FAULT_REPORT);
+		hinic_unregister_mgmt_msg_cb(&pfhwdev->pf_to_mgmt,
+					     HINIC_MOD_COMM);
 		hinic_unregister_mgmt_msg_cb(&pfhwdev->pf_to_mgmt,
 					     HINIC_MOD_L2NIC);
-	else
+	} else {
 		hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
+	}
 
 	hinic_func_to_func_free(hwdev);
 
+	hinic_devlink_unregister(hwdev->devlink_dev);
+
 	hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 }
 
@@ -777,7 +913,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
  *
  * Initialize the NIC HW device and return a pointer to it
  **/
-struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
+struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev, struct devlink *devlink)
 {
 	struct hinic_pfhwdev *pfhwdev;
 	struct hinic_hwdev *hwdev;
@@ -802,6 +938,8 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 
 	hwdev = &pfhwdev->hwdev;
 	hwdev->hwif = hwif;
+	hwdev->devlink_dev = devlink_priv(devlink);
+	hwdev->devlink_dev->hwdev = hwdev;
 
 	err = init_msix(hwdev);
 	if (err) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 94593a8ad667..2fb5f784f116 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <net/devlink.h>
 
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
@@ -164,9 +165,12 @@ enum hinic_ucode_cmd {
 #define NIC_RSS_CMD_TEMP_FREE   0x02
 
 enum hinic_mgmt_msg_cmd {
-	HINIC_MGMT_MSG_CMD_BASE         = 160,
+	HINIC_MGMT_MSG_CMD_BASE         = 0xA0,
 
-	HINIC_MGMT_MSG_CMD_LINK_STATUS  = 160,
+	HINIC_MGMT_MSG_CMD_LINK_STATUS  = 0xA0,
+
+	HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT	= 0xE5,
+	HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT	= 0xE6,
 
 	HINIC_MGMT_MSG_CMD_MAX,
 };
@@ -348,6 +352,7 @@ struct hinic_hwdev {
 
 	struct hinic_cap                nic_cap;
 	u8				port_id;
+	struct hinic_devlink_priv	*devlink_dev;
 };
 
 struct hinic_nic_cb {
@@ -359,12 +364,29 @@ struct hinic_nic_cb {
 	unsigned long   cb_state;
 };
 
+#define HINIC_COMM_SELF_CMD_MAX 4
+
+typedef void (*comm_mgmt_self_msg_proc)(void *handle, void *buf_in, u16 in_size,
+					void *buf_out, u16 *out_size);
+
+struct comm_mgmt_self_msg_sub_info {
+	u8 cmd;
+	comm_mgmt_self_msg_proc proc;
+};
+
+struct comm_mgmt_self_msg_info {
+	u8 cmd_num;
+	struct comm_mgmt_self_msg_sub_info info[HINIC_COMM_SELF_CMD_MAX];
+};
+
 struct hinic_pfhwdev {
 	struct hinic_hwdev              hwdev;
 
 	struct hinic_pf_to_mgmt         pf_to_mgmt;
 
 	struct hinic_nic_cb             nic_cb[HINIC_MGMT_NUM_MSG_CMD];
+
+	struct comm_mgmt_self_msg_info	proc;
 };
 
 struct hinic_dev_cap {
@@ -386,6 +408,126 @@ struct hinic_dev_cap {
 	u8      rsvd3[204];
 };
 
+union hinic_fault_hw_mgmt {
+	u32 val[4];
+	/* valid only type == FAULT_TYPE_CHIP */
+	struct {
+		u8 node_id;
+		u8 err_level;
+		u16 err_type;
+		u32 err_csr_addr;
+		u32 err_csr_value;
+		/* func_id valid only if err_level == FAULT_LEVEL_SERIOUS_FLR */
+		u16 func_id;
+		u16 rsvd2;
+	} chip;
+
+	/* valid only if type == FAULT_TYPE_UCODE */
+	struct {
+		u8 cause_id;
+		u8 core_id;
+		u8 c_id;
+		u8 rsvd3;
+		u32 epc;
+		u32 rsvd4;
+		u32 rsvd5;
+	} ucode;
+
+	/* valid only if type == FAULT_TYPE_MEM_RD_TIMEOUT ||
+	 * FAULT_TYPE_MEM_WR_TIMEOUT
+	 */
+	struct {
+		u32 err_csr_ctrl;
+		u32 err_csr_data;
+		u32 ctrl_tab;
+		u32 mem_index;
+	} mem_timeout;
+
+	/* valid only if type == FAULT_TYPE_REG_RD_TIMEOUT ||
+	 * FAULT_TYPE_REG_WR_TIMEOUT
+	 */
+	struct {
+		u32 err_csr;
+		u32 rsvd6;
+		u32 rsvd7;
+		u32 rsvd8;
+	} reg_timeout;
+
+	struct {
+		/* 0: read; 1: write */
+		u8 op_type;
+		u8 port_id;
+		u8 dev_ad;
+		u8 rsvd9;
+		u32 csr_addr;
+		u32 op_data;
+		u32 rsvd10;
+	} phy_fault;
+};
+
+struct hinic_fault_event {
+	u8 type;
+	u8 fault_level;
+	u8 rsvd0[2];
+	union hinic_fault_hw_mgmt event;
+};
+
+struct hinic_cmd_fault_event {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	struct hinic_fault_event event;
+};
+
+enum hinic_fault_type {
+	FAULT_TYPE_CHIP,
+	FAULT_TYPE_UCODE,
+	FAULT_TYPE_MEM_RD_TIMEOUT,
+	FAULT_TYPE_MEM_WR_TIMEOUT,
+	FAULT_TYPE_REG_RD_TIMEOUT,
+	FAULT_TYPE_REG_WR_TIMEOUT,
+	FAULT_TYPE_PHY_FAULT,
+	FAULT_TYPE_MAX,
+};
+
+#define FAULT_SHOW_STR_LEN 16
+
+enum hinic_fault_err_level {
+	FAULT_LEVEL_FATAL,
+	FAULT_LEVEL_SERIOUS_RESET,
+	FAULT_LEVEL_SERIOUS_FLR,
+	FAULT_LEVEL_GENERAL,
+	FAULT_LEVEL_SUGGESTION,
+	FAULT_LEVEL_MAX
+};
+
+struct hinic_mgmt_watchdog_info {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	u32 curr_time_h;
+	u32 curr_time_l;
+	u32 task_id;
+	u32 rsv;
+
+	u32 reg[13];
+	u32 pc;
+	u32 lr;
+	u32 cpsr;
+
+	u32 stack_top;
+	u32 stack_bottom;
+	u32 sp;
+	u32 curr_used;
+	u32 peak_used;
+	u32 is_overflow;
+
+	u32 stack_actlen;
+	u8 data[1024];
+};
+
 void hinic_hwdev_cb_register(struct hinic_hwdev *hwdev,
 			     enum hinic_mgmt_msg_cmd cmd, void *handle,
 			     void (*handler)(void *handle, void *buf_in,
@@ -407,7 +549,7 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev, u16 sq_depth, u16 rq_depth);
 
 void hinic_hwdev_ifdown(struct hinic_hwdev *hwdev);
 
-struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev);
+struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev, struct devlink *devlink);
 
 void hinic_free_hwdev(struct hinic_hwdev *hwdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index e0f5a81d8620..f5a46d5bb007 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -12,8 +12,10 @@
 #include <linux/semaphore.h>
 #include <linux/completion.h>
 #include <linux/slab.h>
+#include <net/devlink.h>
 #include <asm/barrier.h>
 
+#include "hinic_devlink.h"
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
 #include "hinic_hw_api_cmd.h"
@@ -617,10 +619,15 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	if (HINIC_IS_VF(hwif))
 		return 0;
 
+	err = hinic_health_reporters_create(hwdev->devlink_dev);
+	if (err)
+		return err;
+
 	sema_init(&pf_to_mgmt->sync_msg_lock, 1);
 	pf_to_mgmt->workq = create_singlethread_workqueue("hinic_mgmt");
 	if (!pf_to_mgmt->workq) {
 		dev_err(&pdev->dev, "Failed to initialize MGMT workqueue\n");
+		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return -ENOMEM;
 	}
 	pf_to_mgmt->sync_msg_id = 0;
@@ -628,12 +635,14 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = alloc_msg_buf(pf_to_mgmt);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate msg buffers\n");
+		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
 
 	err = hinic_api_cmd_init(pf_to_mgmt->cmd_chain, hwif);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize cmd chains\n");
+		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
 
@@ -658,4 +667,5 @@ void hinic_pf_to_mgmt_free(struct hinic_pf_to_mgmt *pf_to_mgmt)
 	hinic_aeq_unregister_hw_cb(&hwdev->aeqs, HINIC_MSG_FROM_MGMT_CPU);
 	hinic_api_cmd_free(pf_to_mgmt->cmd_chain);
 	destroy_workqueue(pf_to_mgmt->workq);
+	hinic_health_reporters_destroy(hwdev->devlink_dev);
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index 21b93b654d6b..f626100b85c1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -81,6 +81,8 @@ enum hinic_comm_cmd {
 	HINIC_COMM_CMD_MSI_CTRL_REG_WR_BY_UP,
 	HINIC_COMM_CMD_MSI_CTRL_REG_RD_BY_UP,
 
+	HINIC_COMM_CMD_FAULT_REPORT	= 0x37,
+
 	HINIC_COMM_CMD_SET_LED_STATUS	= 0x4a,
 
 	HINIC_COMM_CMD_L2NIC_RESET	= 0x4b,
@@ -89,6 +91,8 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_GET_BOARD_INFO	= 0x52,
 
+	HINIC_COMM_CMD_WATCHDOG_INFO	= 0x56,
+
 	HINIC_COMM_CMD_MAX,
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c4c6f9c29f0e..501056fd32ee 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -444,8 +444,11 @@ int hinic_open(struct net_device *netdev)
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
 		hinic_notify_all_vfs_link_changed(nic_dev->hwdev, link_state);
 
-	if (link_state == HINIC_LINK_STATE_UP)
+	if (link_state == HINIC_LINK_STATE_UP) {
 		nic_dev->flags |= HINIC_LINK_UP;
+		nic_dev->cable_unplugged = false;
+		nic_dev->module_unrecognized = false;
+	}
 
 	nic_dev->flags |= HINIC_INTF_UP;
 
@@ -935,6 +938,8 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 		down(&nic_dev->mgmt_lock);
 
 		nic_dev->flags |= HINIC_LINK_UP;
+		nic_dev->cable_unplugged = false;
+		nic_dev->module_unrecognized = false;
 
 		if ((nic_dev->flags & (HINIC_LINK_UP | HINIC_INTF_UP)) ==
 		    (HINIC_LINK_UP | HINIC_INTF_UP)) {
@@ -971,6 +976,39 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 	*out_size = sizeof(*ret_link_status);
 }
 
+static void cable_plug_event(void *handle,
+			     void *buf_in, u16 in_size,
+			     void *buf_out, u16 *out_size)
+{
+	struct hinic_cable_plug_event *plug_event = buf_in;
+	struct hinic_dev *nic_dev = handle;
+
+	nic_dev->cable_unplugged = plug_event->plugged ? false : true;
+
+	*out_size = sizeof(*plug_event);
+	plug_event = buf_out;
+	plug_event->status = 0;
+}
+
+static void link_err_event(void *handle,
+			   void *buf_in, u16 in_size,
+			   void *buf_out, u16 *out_size)
+{
+	struct hinic_link_err_event *link_err = buf_in;
+	struct hinic_dev *nic_dev = handle;
+
+	if (link_err->err_type >= LINK_ERR_NUM)
+		netif_info(nic_dev, link, nic_dev->netdev,
+			   "Link failed, Unknown error type: 0x%x\n",
+			   link_err->err_type);
+	else
+		nic_dev->module_unrecognized = true;
+
+	*out_size = sizeof(*link_err);
+	link_err = buf_out;
+	link_err->status = 0;
+}
+
 static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
@@ -1077,28 +1115,24 @@ static int nic_dev_init(struct pci_dev *pdev)
 	struct hinic_rx_mode_work *rx_mode_work;
 	struct hinic_txq_stats *tx_stats;
 	struct hinic_rxq_stats *rx_stats;
-	struct hinic_devlink_priv *priv;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
 	struct devlink *devlink;
 	int err, num_qps;
 
-	hwdev = hinic_init_hwdev(pdev);
-	if (IS_ERR(hwdev)) {
-		dev_err(&pdev->dev, "Failed to initialize HW device\n");
-		return PTR_ERR(hwdev);
-	}
-
 	devlink = hinic_devlink_alloc();
 	if (!devlink) {
 		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
-		err = -ENOMEM;
-		goto err_devlink_alloc;
+		return -ENOMEM;
 	}
 
-	priv = devlink_priv(devlink);
-	priv->hwdev = hwdev;
+	hwdev = hinic_init_hwdev(pdev, devlink);
+	if (IS_ERR(hwdev)) {
+		dev_err(&pdev->dev, "Failed to initialize HW device\n");
+		hinic_devlink_free(devlink);
+		return PTR_ERR(hwdev);
+	}
 
 	num_qps = hinic_hwdev_num_qps(hwdev);
 	if (num_qps <= 0) {
@@ -1161,10 +1195,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_workq;
 	}
 
-	err = hinic_devlink_register(devlink, &pdev->dev);
-	if (err)
-		goto err_devlink_reg;
-
 	pci_set_drvdata(pdev, netdev);
 
 	err = hinic_port_get_mac(nic_dev, netdev->dev_addr);
@@ -1206,6 +1236,12 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	hinic_hwdev_cb_register(nic_dev->hwdev, HINIC_MGMT_MSG_CMD_LINK_STATUS,
 				nic_dev, link_status_event_handler);
+	hinic_hwdev_cb_register(nic_dev->hwdev,
+				HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT,
+				nic_dev, cable_plug_event);
+	hinic_hwdev_cb_register(nic_dev->hwdev,
+				HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT,
+				nic_dev, link_err_event);
 
 	err = set_features(nic_dev, 0, nic_dev->netdev->features, true);
 	if (err)
@@ -1237,6 +1273,10 @@ static int nic_dev_init(struct pci_dev *pdev)
 err_init_intr:
 err_set_pfc:
 err_set_features:
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT);
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT);
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
 				  HINIC_MGMT_MSG_CMD_LINK_STATUS);
 	cancel_work_sync(&rx_mode_work->work);
@@ -1246,17 +1286,15 @@ static int nic_dev_init(struct pci_dev *pdev)
 err_add_mac:
 err_get_mac:
 	pci_set_drvdata(pdev, NULL);
-err_devlink_reg:
 	destroy_workqueue(nic_dev->workq);
-
 err_workq:
 err_vlan_bitmap:
 	free_netdev(netdev);
 
 err_alloc_etherdev:
 err_num_qps:
-err_devlink_alloc:
 	hinic_free_hwdev(hwdev);
+	hinic_devlink_free(devlink);
 	return err;
 }
 
@@ -1343,6 +1381,7 @@ static void hinic_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct devlink *devlink = nic_dev->devlink;
 	struct hinic_rx_mode_work *rx_mode_work;
 
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
@@ -1356,6 +1395,10 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
 
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT);
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT);
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
 				  HINIC_MGMT_MSG_CMD_LINK_STATUS);
 
@@ -1364,16 +1407,14 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
-	hinic_devlink_unregister(nic_dev->devlink);
-
 	destroy_workqueue(nic_dev->workq);
 
-	hinic_devlink_free(nic_dev->devlink);
-
 	hinic_free_hwdev(nic_dev->hwdev);
 
 	free_netdev(netdev);
 
+	hinic_devlink_free(devlink);
+
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 14931adaffb8..9c3cbe45c9ec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -189,6 +189,31 @@ struct hinic_port_link_status {
 	u8      port_id;
 };
 
+struct hinic_cable_plug_event {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	plugged; /* 0: unplugged, 1: plugged */
+	u8	port_id;
+};
+
+enum link_err_type {
+	LINK_ERR_MODULE_UNRECOGENIZED,
+	LINK_ERR_NUM,
+};
+
+struct hinic_link_err_event {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	err_type;
+	u8	port_id;
+};
+
 struct hinic_port_func_state_cmd {
 	u8      status;
 	u8      version;
-- 
2.17.1

