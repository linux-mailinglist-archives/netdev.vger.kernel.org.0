Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B95A2222E4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgGPMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:51:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbgGPMvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 08:51:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BF95FEF5B4D3C46CFF14;
        Thu, 16 Jul 2020 20:51:18 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 20:51:11 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next 2/2] hinic: add log in exception handling processes
Date:   Thu, 16 Jul 2020 20:50:56 +0800
Message-ID: <20200716125056.27160-3-luobin9@huawei.com>
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

improve the error message when functions return failure and dump
relevant registers in some exception handling processes

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../ethernet/huawei/hinic/hinic_hw_api_cmd.c  | 27 +++++++-
 .../ethernet/huawei/hinic/hinic_hw_api_cmd.h  |  4 ++
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 12 ++--
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 39 ++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |  4 ++
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   | 23 +++++++
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  1 +
 .../net/ethernet/huawei/hinic/hinic_port.c    | 62 +++++++++----------
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |  6 +-
 13 files changed, 144 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
index 583fd24c29cf..29e88e25a4a4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
@@ -112,6 +112,26 @@ static u32 get_hw_cons_idx(struct hinic_api_cmd_chain *chain)
 	return HINIC_API_CMD_STATUS_GET(val, CONS_IDX);
 }
 
+static void dump_api_chain_reg(struct hinic_api_cmd_chain *chain)
+{
+	u32 addr, val;
+
+	addr = HINIC_CSR_API_CMD_STATUS_ADDR(chain->chain_type);
+	val  = hinic_hwif_read_reg(chain->hwif, addr);
+
+	dev_err(&chain->hwif->pdev->dev, "Chain type: 0x%x, cpld error: 0x%x, check error: 0x%x, current fsm: 0x%x\n",
+		chain->chain_type, HINIC_API_CMD_STATUS_GET(val, CPLD_ERR),
+		HINIC_API_CMD_STATUS_GET(val, CHKSUM_ERR),
+		HINIC_API_CMD_STATUS_GET(val, FSM));
+
+	dev_err(&chain->hwif->pdev->dev, "Chain hw current ci: 0x%x\n",
+		HINIC_API_CMD_STATUS_GET(val, CONS_IDX));
+
+	addr = HINIC_CSR_API_CMD_CHAIN_PI_ADDR(chain->chain_type);
+	val  = hinic_hwif_read_reg(chain->hwif, addr);
+	dev_err(&chain->hwif->pdev->dev, "Chain hw current pi: 0x%x\n", val);
+}
+
 /**
  * chain_busy - check if the chain is still processing last requests
  * @chain: chain to check
@@ -131,8 +151,10 @@ static int chain_busy(struct hinic_api_cmd_chain *chain)
 
 		/* check for a space for a new command */
 		if (chain->cons_idx == MASKED_IDX(chain, prod_idx + 1)) {
-			dev_err(&pdev->dev, "API CMD chain %d is busy\n",
-				chain->chain_type);
+			dev_err(&pdev->dev, "API CMD chain %d is busy, cons_idx: %d, prod_idx: %d\n",
+				chain->chain_type, chain->cons_idx,
+				chain->prod_idx);
+			dump_api_chain_reg(chain);
 			return -EBUSY;
 		}
 		break;
@@ -332,6 +354,7 @@ static int wait_for_api_cmd_completion(struct hinic_api_cmd_chain *chain)
 		err = wait_for_status_poll(chain);
 		if (err) {
 			dev_err(&pdev->dev, "API CMD Poll status timeout\n");
+			dump_api_chain_reg(chain);
 			break;
 		}
 		break;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.h
index 0ba00fd828df..6d1654b050ad 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.h
@@ -103,10 +103,14 @@
 	 HINIC_API_CMD_STATUS_HEADER_##member##_MASK)
 
 #define HINIC_API_CMD_STATUS_CONS_IDX_SHIFT                     0
+#define HINIC_API_CMD_STATUS_FSM_SHIFT				24
 #define HINIC_API_CMD_STATUS_CHKSUM_ERR_SHIFT                   28
+#define HINIC_API_CMD_STATUS_CPLD_ERR_SHIFT			30
 
 #define HINIC_API_CMD_STATUS_CONS_IDX_MASK                      0xFFFFFF
+#define HINIC_API_CMD_STATUS_FSM_MASK				0xFU
 #define HINIC_API_CMD_STATUS_CHKSUM_ERR_MASK                    0x3
+#define HINIC_API_CMD_STATUS_CPLD_ERR_MASK			0x1U
 
 #define HINIC_API_CMD_STATUS_GET(val, member)                   \
 	(((val) >> HINIC_API_CMD_STATUS_##member##_SHIFT) &     \
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index cb5b6e5f787f..e0eb294779ec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -401,6 +401,7 @@ static int cmdq_sync_cmd_direct_resp(struct hinic_cmdq *cmdq,
 
 		spin_unlock_bh(&cmdq->cmdq_lock);
 
+		hinic_dump_ceq_info(cmdq->hwdev);
 		return -ETIMEDOUT;
 	}
 
@@ -807,6 +808,7 @@ static int init_cmdqs_ctxt(struct hinic_hwdev *hwdev,
 
 	cmdq_type = HINIC_CMDQ_SYNC;
 	for (; cmdq_type < HINIC_MAX_CMDQ_TYPES; cmdq_type++) {
+		cmdqs->cmdq[cmdq_type].hwdev = hwdev;
 		err = init_cmdq(&cmdqs->cmdq[cmdq_type],
 				&cmdqs->saved_wqs[cmdq_type], cmdq_type,
 				db_area[cmdq_type]);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
index 3e4b0aef9fe6..f40c31e1879f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
@@ -130,6 +130,8 @@ struct hinic_cmdq_ctxt {
 };
 
 struct hinic_cmdq {
+	struct hinic_hwdev      *hwdev;
+
 	struct hinic_wq         *wq;
 
 	enum hinic_cmdq_type    cmdq_type;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index b53294d89d78..b97f72fa33a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -255,9 +255,9 @@ static int init_fw_ctxt(struct hinic_hwdev *hwdev)
 				 &fw_ctxt, sizeof(fw_ctxt),
 				 &fw_ctxt, &out_size);
 	if (err || (out_size != sizeof(fw_ctxt)) || fw_ctxt.status) {
-		dev_err(&pdev->dev, "Failed to init FW ctxt, ret = %d\n",
-			fw_ctxt.status);
-		return -EFAULT;
+		dev_err(&pdev->dev, "Failed to init FW ctxt, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, fw_ctxt.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -422,9 +422,9 @@ static int get_base_qpn(struct hinic_hwdev *hwdev, u16 *base_qpn)
 				 &cmd_base_qpn, sizeof(cmd_base_qpn),
 				 &cmd_base_qpn, &out_size);
 	if (err || (out_size != sizeof(cmd_base_qpn)) || cmd_base_qpn.status) {
-		dev_err(&pdev->dev, "Failed to get base qpn, status = %d\n",
-			cmd_base_qpn.status);
-		return -EFAULT;
+		dev_err(&pdev->dev, "Failed to get base qpn, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, cmd_base_qpn.status, out_size);
+		return -EIO;
 	}
 
 	*base_qpn = cmd_base_qpn.qpn;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 397936cac304..243cfa398b43 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -953,3 +953,42 @@ void hinic_ceqs_free(struct hinic_ceqs *ceqs)
 	for (q_id = 0; q_id < ceqs->num_ceqs; q_id++)
 		remove_eq(&ceqs->ceq[q_id]);
 }
+
+void hinic_dump_ceq_info(struct hinic_hwdev *hwdev)
+{
+	struct hinic_eq *eq = NULL;
+	u32 addr, ci, pi;
+	int q_id;
+
+	for (q_id = 0; q_id < hwdev->func_to_io.ceqs.num_ceqs; q_id++) {
+		eq = &hwdev->func_to_io.ceqs.ceq[q_id];
+		addr = EQ_CONS_IDX_REG_ADDR(eq);
+		ci = hinic_hwif_read_reg(hwdev->hwif, addr);
+		addr = EQ_PROD_IDX_REG_ADDR(eq);
+		pi = hinic_hwif_read_reg(hwdev->hwif, addr);
+		dev_err(&hwdev->hwif->pdev->dev, "Ceq id: %d, ci: 0x%08x, sw_ci: 0x%08x, pi: 0x%x, tasklet_state: 0x%lx, wrap: %d, ceqe: 0x%x\n",
+			q_id, ci, eq->cons_idx, pi,
+			eq->ceq_tasklet.state,
+			eq->wrapped, be32_to_cpu(*(GET_CURR_CEQ_ELEM(eq))));
+	}
+}
+
+void hinic_dump_aeq_info(struct hinic_hwdev *hwdev)
+{
+	struct hinic_aeq_elem *aeqe_pos = NULL;
+	struct hinic_eq *eq = NULL;
+	u32 addr, ci, pi;
+	int q_id;
+
+	for (q_id = 0; q_id < hwdev->aeqs.num_aeqs; q_id++) {
+		eq = &hwdev->aeqs.aeq[q_id];
+		addr = EQ_CONS_IDX_REG_ADDR(eq);
+		ci = hinic_hwif_read_reg(hwdev->hwif, addr);
+		addr = EQ_PROD_IDX_REG_ADDR(eq);
+		pi = hinic_hwif_read_reg(hwdev->hwif, addr);
+		aeqe_pos = GET_CURR_AEQ_ELEM(eq);
+		dev_err(&hwdev->hwif->pdev->dev, "Aeq id: %d, ci: 0x%08x, pi: 0x%x, work_state: 0x%x, wrap: %d, desc: 0x%x\n",
+			q_id, ci, pi, work_busy(&eq->aeq_work.work),
+			eq->wrapped, be32_to_cpu(aeqe_pos->desc));
+	}
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
index 74b9ff90640c..2595003341c6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
@@ -254,4 +254,8 @@ int hinic_ceqs_init(struct hinic_ceqs *ceqs, struct hinic_hwif *hwif,
 
 void hinic_ceqs_free(struct hinic_ceqs *ceqs);
 
+void hinic_dump_ceq_info(struct hinic_hwdev *hwdev);
+
+void hinic_dump_aeq_info(struct hinic_hwdev *hwdev);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index cf127d896ba6..bc8925c0c982 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -21,6 +21,8 @@
 
 #define WAIT_HWIF_READY_TIMEOUT	10000
 
+#define HINIC_SELFTEST_RESULT 0x883C
+
 /**
  * hinic_msix_attr_set - set message attribute for msix entry
  * @hwif: the HW interface of a pci function device
@@ -369,6 +371,26 @@ u16 hinic_pf_id_of_vf_hw(struct hinic_hwif *hwif)
 	return HINIC_FA0_GET(attr0, PF_IDX);
 }
 
+static void __print_selftest_reg(struct hinic_hwif *hwif)
+{
+	u32 addr, attr0, attr1;
+
+	addr   = HINIC_CSR_FUNC_ATTR1_ADDR;
+	attr1  = hinic_hwif_read_reg(hwif, addr);
+
+	if (attr1 == HINIC_PCIE_LINK_DOWN) {
+		dev_err(&hwif->pdev->dev, "PCIE is link down\n");
+		return;
+	}
+
+	addr   = HINIC_CSR_FUNC_ATTR0_ADDR;
+	attr0  = hinic_hwif_read_reg(hwif, addr);
+	if (HINIC_FA0_GET(attr0, FUNC_TYPE) != HINIC_VF &&
+	    !HINIC_FA0_GET(attr0, PCI_INTF_IDX))
+		dev_err(&hwif->pdev->dev, "Selftest reg: 0x%08x\n",
+			hinic_hwif_read_reg(hwif, HINIC_SELFTEST_RESULT));
+}
+
 /**
  * hinic_init_hwif - initialize the hw interface
  * @hwif: the HW interface of a pci function device
@@ -398,6 +420,7 @@ int hinic_init_hwif(struct hinic_hwif *hwif, struct pci_dev *pdev)
 	err = wait_hwif_ready(hwif);
 	if (err) {
 		dev_err(&pdev->dev, "HW interface is not ready\n");
+		__print_selftest_reg(hwif);
 		goto err_hwif_ready;
 	}
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index 0872e035faa1..675c10364223 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+#define HINIC_PCIE_LINK_DOWN					0xFFFFFFFF
+
 #define HINIC_DMA_ATTR_ST_SHIFT                                 0
 #define HINIC_DMA_ATTR_AT_SHIFT                                 8
 #define HINIC_DMA_ATTR_PH_SHIFT                                 10
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index bc2f87e6cb5d..47c93f946b94 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -650,6 +650,7 @@ wait_for_mbox_seg_completion(struct hinic_mbox_func_to_func *func_to_func,
 		if (!wait_for_completion_timeout(done, jif)) {
 			dev_err(&hwdev->hwif->pdev->dev, "Send mailbox segment timeout\n");
 			dump_mox_reg(hwdev);
+			hinic_dump_aeq_info(hwdev);
 			return -ETIMEDOUT;
 		}
 
@@ -897,6 +898,7 @@ int hinic_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
 		set_mbox_to_func_event(func_to_func, EVENT_TIMEOUT);
 		dev_err(&func_to_func->hwif->pdev->dev,
 			"Send mbox msg timeout, msg_id: %d\n", msg_info.msg_id);
+		hinic_dump_aeq_info(func_to_func->hwdev);
 		err = -ETIMEDOUT;
 		goto err_send_mbox;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index e0f5a81d8620..b7146012a546 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -274,6 +274,7 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 
 	if (!wait_for_completion_timeout(recv_done, timeo)) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
+		hinic_dump_aeq_info(pf_to_mgmt->hwdev);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index ba358bbb74a2..02cd635d6914 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -61,8 +61,8 @@ static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 	    (port_mac_cmd.status  &&
 	    port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY &&
 	    port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
-		dev_err(&pdev->dev, "Failed to change MAC, ret = %d\n",
-			port_mac_cmd.status);
+		dev_err(&pdev->dev, "Failed to change MAC, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_mac_cmd.status, out_size);
 		return -EFAULT;
 	}
 
@@ -129,8 +129,8 @@ int hinic_port_get_mac(struct hinic_dev *nic_dev, u8 *addr)
 				 &port_mac_cmd, sizeof(port_mac_cmd),
 				 &port_mac_cmd, &out_size);
 	if (err || (out_size != sizeof(port_mac_cmd)) || port_mac_cmd.status) {
-		dev_err(&pdev->dev, "Failed to get mac, ret = %d\n",
-			port_mac_cmd.status);
+		dev_err(&pdev->dev, "Failed to get mac, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_mac_cmd.status, out_size);
 		return -EFAULT;
 	}
 
@@ -172,9 +172,9 @@ int hinic_port_set_mtu(struct hinic_dev *nic_dev, int new_mtu)
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_CHANGE_MTU,
 				 &port_mtu_cmd, sizeof(port_mtu_cmd),
 				 &port_mtu_cmd, &out_size);
-	if (err || (out_size != sizeof(port_mtu_cmd)) || port_mtu_cmd.status) {
-		dev_err(&pdev->dev, "Failed to set mtu, ret = %d\n",
-			port_mtu_cmd.status);
+	if (err || out_size != sizeof(port_mtu_cmd) || port_mtu_cmd.status) {
+		dev_err(&pdev->dev, "Failed to set mtu, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_mtu_cmd.status, out_size);
 		return -EFAULT;
 	}
 
@@ -264,8 +264,8 @@ int hinic_port_link_state(struct hinic_dev *nic_dev,
 				 &link_cmd, sizeof(link_cmd),
 				 &link_cmd, &out_size);
 	if (err || (out_size != sizeof(link_cmd)) || link_cmd.status) {
-		dev_err(&pdev->dev, "Failed to get link state, ret = %d\n",
-			link_cmd.status);
+		dev_err(&pdev->dev, "Failed to get link state, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, link_cmd.status, out_size);
 		return -EINVAL;
 	}
 
@@ -298,8 +298,8 @@ int hinic_port_set_state(struct hinic_dev *nic_dev, enum hinic_port_state state)
 				 &port_state, sizeof(port_state),
 				 &port_state, &out_size);
 	if (err || (out_size != sizeof(port_state)) || port_state.status) {
-		dev_err(&pdev->dev, "Failed to set port state, ret = %d\n",
-			port_state.status);
+		dev_err(&pdev->dev, "Failed to set port state, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_state.status, out_size);
 		return -EFAULT;
 	}
 
@@ -330,8 +330,8 @@ int hinic_port_set_func_state(struct hinic_dev *nic_dev,
 				 &func_state, sizeof(func_state),
 				 &func_state, &out_size);
 	if (err || (out_size != sizeof(func_state)) || func_state.status) {
-		dev_err(&pdev->dev, "Failed to set port func state, ret = %d\n",
-			func_state.status);
+		dev_err(&pdev->dev, "Failed to set port func state, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, func_state.status, out_size);
 		return -EFAULT;
 	}
 
@@ -361,9 +361,9 @@ int hinic_port_get_cap(struct hinic_dev *nic_dev,
 				 port_cap, &out_size);
 	if (err || (out_size != sizeof(*port_cap)) || port_cap->status) {
 		dev_err(&pdev->dev,
-			"Failed to get port capabilities, ret = %d\n",
-			port_cap->status);
-		return -EINVAL;
+			"Failed to get port capabilities, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, port_cap->status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -393,9 +393,9 @@ int hinic_port_set_tso(struct hinic_dev *nic_dev, enum hinic_tso_state state)
 				 &tso_cfg, &out_size);
 	if (err || out_size != sizeof(tso_cfg) || tso_cfg.status) {
 		dev_err(&pdev->dev,
-			"Failed to set port tso, ret = %d\n",
-			tso_cfg.status);
-		return -EINVAL;
+			"Failed to set port tso, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, tso_cfg.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -423,9 +423,9 @@ int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en)
 				 &rx_csum_cfg, &out_size);
 	if (err || !out_size || rx_csum_cfg.status) {
 		dev_err(&pdev->dev,
-			"Failed to set rx csum offload, ret = %d\n",
-			rx_csum_cfg.status);
-		return -EINVAL;
+			"Failed to set rx csum offload, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rx_csum_cfg.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -480,9 +480,9 @@ int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
 				 &rq_num, &out_size);
 	if (err || !out_size || rq_num.status) {
 		dev_err(&pdev->dev,
-			"Failed to rxq number, ret = %d\n",
-			rq_num.status);
-		return -EINVAL;
+			"Failed to set rxq number, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rq_num.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -508,9 +508,9 @@ static int hinic_set_rx_lro(struct hinic_dev *nic_dev, u8 ipv4_en, u8 ipv6_en,
 				 &lro_cfg, &out_size);
 	if (err || !out_size || lro_cfg.status) {
 		dev_err(&pdev->dev,
-			"Failed to set lro offload, ret = %d\n",
-			lro_cfg.status);
-		return -EINVAL;
+			"Failed to set lro offload, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, lro_cfg.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
@@ -542,10 +542,10 @@ static int hinic_set_rx_lro_timer(struct hinic_dev *nic_dev, u32 timer_value)
 
 	if (err || !out_size || lro_timer.status) {
 		dev_err(&pdev->dev,
-			"Failed to set lro timer, ret = %d\n",
-			lro_timer.status);
+			"Failed to set lro timer, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, lro_timer.status, out_size);
 
-		return -EINVAL;
+		return -EIO;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index caf7e81e3f62..141206917e4d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -40,9 +40,9 @@ static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
 	if (err || out_size != sizeof(mac_info) ||
 	    (mac_info.status && mac_info.status != HINIC_PF_SET_VF_ALREADY &&
 	    mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
-		dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to change MAC, ret = %d\n",
-			mac_info.status);
-		return -EFAULT;
+		dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to set MAC, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, mac_info.status, out_size);
+		return -EIO;
 	}
 
 	return 0;
-- 
2.17.1

