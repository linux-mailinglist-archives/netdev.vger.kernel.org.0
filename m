Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C682222E6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgGPMvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:51:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728087AbgGPMvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 08:51:31 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B8891F9FA125F884966A;
        Thu, 16 Jul 2020 20:51:18 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 20:51:10 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next 1/2] hinic: add support to handle hw abnormal event
Date:   Thu, 16 Jul 2020 20:50:55 +0800
Message-ID: <20200716125056.27160-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716125056.27160-1-luobin9@huawei.com>
References: <20200716125056.27160-1-luobin9@huawei.com>
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
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 249 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 144 +++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   4 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  56 ++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  25 ++
 5 files changed, 472 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 9831c14324e6..b53294d89d78 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -621,6 +621,231 @@ static void nic_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
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
+static void chip_fault_show(struct hinic_hwdev *hwdev,
+			    struct hinic_fault_event *event)
+{
+	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+		"fatal", "reset", "flr", "general", "suggestion"};
+	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
+	u8 level;
+
+	level = event->event.chip.err_level;
+	if (level < FAULT_LEVEL_MAX)
+		strncpy(level_str, fault_level[level],
+			FAULT_SHOW_STR_LEN);
+	else
+		strncpy(level_str, "Unknown", FAULT_SHOW_STR_LEN);
+
+	if (level == FAULT_LEVEL_SERIOUS_FLR)
+		dev_err(&hwdev->hwif->pdev->dev, "err_level: %d [%s], flr func_id: %d\n",
+			level, level_str, event->event.chip.func_id);
+
+	dev_err(&hwdev->hwif->pdev->dev, "Module_id: 0x%x, err_type: 0x%x, err_level: %d[%s], err_csr_addr: 0x%08x, err_csr_value: 0x%08x\n",
+		event->event.chip.node_id,
+		event->event.chip.err_type, level, level_str,
+		event->event.chip.err_csr_addr,
+		event->event.chip.err_csr_value);
+}
+
+static void fault_report_show(struct hinic_hwdev *hwdev,
+			      struct hinic_fault_event *event)
+{
+	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+		"chip", "ucode", "mem rd timeout", "mem wr timeout",
+		"reg rd timeout", "reg wr timeout", "phy fault"};
+	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
+
+	dev_err(&hwdev->hwif->pdev->dev, "Fault event report received, func_id: %d\n",
+		HINIC_HWIF_FUNC_IDX(hwdev->hwif));
+
+	if (event->type < FAULT_TYPE_MAX)
+		strncpy(type_str, fault_type[event->type], FAULT_SHOW_STR_LEN);
+	else
+		strncpy(type_str, "Unknown", FAULT_SHOW_STR_LEN);
+
+	dev_err(&hwdev->hwif->pdev->dev, "Fault type: %d [%s]\n", event->type,
+		type_str);
+	dev_err(&hwdev->hwif->pdev->dev,  "Fault val[0]: 0x%08x, val[1]: 0x%08x, val[2]: 0x%08x, val[3]: 0x%08x\n",
+		event->event.val[0], event->event.val[1], event->event.val[2],
+		event->event.val[3]);
+
+	switch (event->type) {
+	case FAULT_TYPE_CHIP:
+		chip_fault_show(hwdev, event);
+		break;
+	case FAULT_TYPE_UCODE:
+		dev_err(&hwdev->hwif->pdev->dev, "Cause_id: %d, core_id: %d, c_id: %d, epc: 0x%08x\n",
+			event->event.ucode.cause_id, event->event.ucode.core_id,
+			event->event.ucode.c_id, event->event.ucode.epc);
+		break;
+	case FAULT_TYPE_MEM_RD_TIMEOUT:
+	case FAULT_TYPE_MEM_WR_TIMEOUT:
+		dev_err(&hwdev->hwif->pdev->dev, "Err_csr_ctrl: 0x%08x, err_csr_data: 0x%08x, ctrl_tab: 0x%08x, mem_index: 0x%08x\n",
+			event->event.mem_timeout.err_csr_ctrl,
+			event->event.mem_timeout.err_csr_data,
+			event->event.mem_timeout.ctrl_tab,
+			event->event.mem_timeout.mem_index);
+		break;
+	case FAULT_TYPE_REG_RD_TIMEOUT:
+	case FAULT_TYPE_REG_WR_TIMEOUT:
+		dev_err(&hwdev->hwif->pdev->dev, "Err_csr: 0x%08x\n",
+			event->event.reg_timeout.err_csr);
+		break;
+	case FAULT_TYPE_PHY_FAULT:
+		dev_err(&hwdev->hwif->pdev->dev, "Op_type: %u, port_id: %u, dev_ad: %u, csr_addr: 0x%08x, op_data: 0x%08x\n",
+			event->event.phy_fault.op_type,
+			event->event.phy_fault.port_id,
+			event->event.phy_fault.dev_ad,
+			event->event.phy_fault.csr_addr,
+			event->event.phy_fault.op_data);
+		break;
+	default:
+		break;
+	}
+}
+
+/* pf fault report event */
+static void pf_fault_event_handler(void *hwdev, void *buf_in, u16 in_size,
+				   void *buf_out, u16 *out_size)
+{
+	struct hinic_cmd_fault_event *fault_event = buf_in;
+
+	fault_report_show(hwdev, &fault_event->event);
+}
+
+static void mgmt_watchdog_timeout_event_handler(void *dev,
+						void *buf_in, u16 in_size,
+						void *buf_out, u16 *out_size)
+{
+	struct hinic_mgmt_watchdog_info *watchdog_info = NULL;
+	struct hinic_hwdev *hwdev = dev;
+	u32 *dump_addr = NULL;
+	u32 stack_len, i, j;
+	u32 *reg = NULL;
+
+	if (in_size != sizeof(*watchdog_info)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Invalid mgmt watchdog report, length: %d, should be %ld\n",
+			in_size, sizeof(*watchdog_info));
+		return;
+	}
+
+	watchdog_info = buf_in;
+
+	dev_err(&hwdev->hwif->pdev->dev, "Mgmt deadloop time: 0x%x 0x%x, task id: 0x%x, sp: 0x%x\n",
+		watchdog_info->curr_time_h, watchdog_info->curr_time_l,
+		watchdog_info->task_id, watchdog_info->sp);
+	dev_err(&hwdev->hwif->pdev->dev, "Stack current used: 0x%x, peak used: 0x%x, overflow flag: 0x%x, top: 0x%x, bottom: 0x%x\n",
+		watchdog_info->curr_used, watchdog_info->peak_used,
+		watchdog_info->is_overflow, watchdog_info->stack_top,
+		watchdog_info->stack_bottom);
+
+	dev_err(&hwdev->hwif->pdev->dev, "Mgmt pc: 0x%08x, lr: 0x%08x, cpsr:0x%08x\n",
+		watchdog_info->pc, watchdog_info->lr, watchdog_info->cpsr);
+
+	dev_err(&hwdev->hwif->pdev->dev, "Mgmt register info\n");
+
+	for (i = 0; i < 3; i++) {
+		reg = watchdog_info->reg + (u64)(u32)(4 * i);
+		dev_err(&hwdev->hwif->pdev->dev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			*(reg), *(reg + 1), *(reg + 2), *(reg + 3));
+	}
+
+	dev_err(&hwdev->hwif->pdev->dev, "0x%08x\n", watchdog_info->reg[12]);
+
+	if (watchdog_info->stack_actlen <= 1024) {
+		stack_len = watchdog_info->stack_actlen;
+	} else {
+		dev_err(&hwdev->hwif->pdev->dev, "Oops stack length: 0x%x is wrong\n",
+			watchdog_info->stack_actlen);
+		stack_len = 1024;
+	}
+
+	dev_err(&hwdev->hwif->pdev->dev, "Mgmt dump stack, 16Bytes per line(start from sp)\n");
+	for (i = 0; i < (stack_len / 16); i++) {
+		dump_addr = (u32 *)(watchdog_info->data + ((u64)(u32)(i * 16)));
+		dev_err(&hwdev->hwif->pdev->dev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			*dump_addr, *(dump_addr + 1), *(dump_addr + 2),
+			*(dump_addr + 3));
+	}
+
+	for (j = 0; j < ((stack_len % 16) / 4); j++) {
+		dump_addr = (u32 *)(watchdog_info->data +
+			    ((u64)(u32)(i * 16 + j * 4)));
+		dev_err(&hwdev->hwif->pdev->dev, "0x%08x ", *dump_addr);
+	}
+
+	*out_size = sizeof(*watchdog_info);
+	watchdog_info = buf_out;
+	watchdog_info->status = 0;
+}
+
 /**
  * init_pfhwdev - Initialize the extended components of PF
  * @pfhwdev: the HW device for PF
@@ -647,13 +872,22 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
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
 
@@ -670,11 +904,18 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 
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
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 94593a8ad667..e6bcdce97e43 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -164,9 +164,12 @@ enum hinic_ucode_cmd {
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
@@ -359,12 +362,29 @@ struct hinic_nic_cb {
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
@@ -386,6 +406,126 @@ struct hinic_dev_cap {
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
index c4c6f9c29f0e..98d2133a268b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -75,6 +75,10 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 #define HINIC_DEAULT_TXRX_MSIX_COALESC_TIMER_CFG	32
 #define HINIC_DEAULT_TXRX_MSIX_RESEND_TIMER_CFG		7
 
+static const char *hinic_module_link_err[LINK_ERR_NUM] = {
+	"Unrecognized module",
+};
+
 static int change_mac_addr(struct net_device *netdev, const u8 *addr);
 
 static int set_features(struct hinic_dev *nic_dev,
@@ -971,6 +975,44 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 	*out_size = sizeof(*ret_link_status);
 }
 
+static void cable_plug_event(void *handle,
+			     void *buf_in, u16 in_size,
+			     void *buf_out, u16 *out_size)
+{
+	struct hinic_cable_plug_event *plug_event = buf_in;
+	struct hinic_dev *nic_dev = handle;
+
+	netif_info(nic_dev, link, nic_dev->netdev,
+		   "Port module event: Cable %s\n",
+		   plug_event->plugged ? "plugged" : "unplugged");
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
+		netif_info(nic_dev, link, nic_dev->netdev,
+			   "Link failed, error type: 0x%x: %s\n",
+			   link_err->err_type,
+			   hinic_module_link_err[link_err->err_type]);
+
+	*out_size = sizeof(*link_err);
+	link_err = buf_out;
+	link_err->status = 0;
+}
+
 static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
@@ -1206,6 +1248,12 @@ static int nic_dev_init(struct pci_dev *pdev)
 
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
@@ -1237,6 +1285,10 @@ static int nic_dev_init(struct pci_dev *pdev)
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
@@ -1356,6 +1408,10 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
 
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT);
+	hinic_hwdev_cb_unregister(nic_dev->hwdev,
+				  HINIC_MGMT_MSG_CMD_CABLE_PLUG_EVENT);
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
 				  HINIC_MGMT_MSG_CMD_LINK_STATUS);
 
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

