Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE451CBD1C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgEIEBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:01:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbgEIEBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 00:01:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D42EE3D475E10830EBD1;
        Sat,  9 May 2020 12:01:34 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 12:01:29 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v2] hinic: add three net_device_ops of vf
Date:   Fri, 8 May 2020 20:18:50 +0000
Message-ID: <20200508201850.5003-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adds ndo_set_vf_rate/ndo_set_vf_spoofchk/ndo_set_vf_link_state
to configure netdev of virtual function

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  29 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  35 ++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  21 ++
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   |  32 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |   6 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c |   4 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  17 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    |   8 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |  43 +++
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 275 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |   7 +
 11 files changed, 453 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 33c5333657c1..cb5b6e5f787f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -849,6 +849,25 @@ static int init_cmdqs_ctxt(struct hinic_hwdev *hwdev,
 	return err;
 }
 
+static int hinic_set_cmdq_depth(struct hinic_hwdev *hwdev, u16 cmdq_depth)
+{
+	struct hinic_cmd_hw_ioctxt hw_ioctxt = { 0 };
+	struct hinic_pfhwdev *pfhwdev;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	hw_ioctxt.func_idx = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	hw_ioctxt.ppf_idx = HINIC_HWIF_PPF_IDX(hwdev->hwif);
+
+	hw_ioctxt.set_cmdq_depth = HW_IOCTXT_SET_CMDQ_DEPTH_ENABLE;
+	hw_ioctxt.cmdq_depth = (u8)ilog2(cmdq_depth);
+
+	return hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				 HINIC_COMM_CMD_HWCTXT_SET,
+				 &hw_ioctxt, sizeof(hw_ioctxt), NULL,
+				 NULL, HINIC_MGMT_MSG_SYNC);
+}
+
 /**
  * hinic_init_cmdqs - init all cmdqs
  * @cmdqs: cmdqs to init
@@ -899,8 +918,18 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 
 	hinic_ceq_register_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ, cmdqs,
 			      cmdq_ceq_handler);
+
+	err = hinic_set_cmdq_depth(hwdev, CMDQ_DEPTH);
+	if (err) {
+		dev_err(&hwif->pdev->dev, "Failed to set cmdq depth\n");
+		goto err_set_cmdq_depth;
+	}
+
 	return 0;
 
+err_set_cmdq_depth:
+	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);
+
 err_cmdq_ctxt:
 	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
 			    HINIC_MAX_CMDQ_TYPES);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index e5cab58e4ddd..1ce8b8d572cf 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -44,10 +44,6 @@ enum io_status {
 	IO_RUNNING = 1,
 };
 
-enum hw_ioctxt_set_cmdq_depth {
-	HW_IOCTXT_SET_CMDQ_DEPTH_DEFAULT,
-};
-
 /**
  * get_capability - convert device capabilities to NIC capabilities
  * @hwdev: the HW device to set and convert device capabilities for
@@ -667,6 +663,32 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 	hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 }
 
+static int hinic_l2nic_reset(struct hinic_hwdev *hwdev)
+{
+	struct hinic_cmd_l2nic_reset l2nic_reset = {0};
+	u16 out_size = sizeof(l2nic_reset);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	l2nic_reset.func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	/* 0 represents standard l2nic reset flow */
+	l2nic_reset.reset_flag = 0;
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_L2NIC_RESET, &l2nic_reset,
+				sizeof(l2nic_reset), &l2nic_reset,
+				&out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || !out_size || l2nic_reset.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to reset L2NIC resources, err: %d, status: 0x%x, out_size: 0x%x\n",
+			err, l2nic_reset.status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * hinic_init_hwdev - Initialize the NIC HW
  * @pdev: the NIC pci device
@@ -729,6 +751,10 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 		goto err_init_pfhwdev;
 	}
 
+	err = hinic_l2nic_reset(hwdev);
+	if (err)
+		goto err_l2nic_reset;
+
 	err = get_dev_cap(hwdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to get device capabilities\n");
@@ -759,6 +785,7 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 err_init_fw_ctxt:
 	hinic_vf_func_free(hwdev);
 err_vf_func_init:
+err_l2nic_reset:
 err_dev_cap:
 	free_pfhwdev(pfhwdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 531d1072e0df..c8f62a024a58 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -25,6 +25,7 @@
 
 #define HINIC_PF_SET_VF_ALREADY				0x4
 #define HINIC_MGMT_STATUS_EXIST				0x6
+#define HINIC_MGMT_CMD_UNSUPPORTED			0xFF
 
 struct hinic_cap {
 	u16     max_qps;
@@ -33,6 +34,11 @@ struct hinic_cap {
 	u16     max_vf_qps;
 };
 
+enum hw_ioctxt_set_cmdq_depth {
+	HW_IOCTXT_SET_CMDQ_DEPTH_DEFAULT,
+	HW_IOCTXT_SET_CMDQ_DEPTH_ENABLE,
+};
+
 enum hinic_port_cmd {
 	HINIC_PORT_CMD_VF_REGISTER = 0x0,
 	HINIC_PORT_CMD_VF_UNREGISTER = 0x1,
@@ -86,12 +92,16 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
 
+	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 78,
+
 	HINIC_PORT_CMD_GET_MGMT_VERSION = 88,
 
 	HINIC_PORT_CMD_SET_FUNC_STATE   = 93,
 
 	HINIC_PORT_CMD_GET_GLOBAL_QPN   = 102,
 
+	HINIC_PORT_CMD_SET_VF_RATE = 105,
+
 	HINIC_PORT_CMD_SET_VF_VLAN	= 106,
 
 	HINIC_PORT_CMD_CLR_VF_VLAN,
@@ -107,6 +117,8 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_GET_CAP          = 170,
 
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
+
+	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
 };
 
 enum hinic_ucode_cmd {
@@ -247,6 +259,15 @@ struct hinic_cmd_hw_ci {
 	u64     ci_addr;
 };
 
+struct hinic_cmd_l2nic_reset {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	reset_flag;
+};
+
 struct hinic_hwdev {
 	struct hinic_hwif               *hwif;
 	struct msix_entry               *msix_entries;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index 3fbd2eb80582..cf127d896ba6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include "hinic_hw_csr.h"
 #include "hinic_hw_if.h"
@@ -18,6 +19,8 @@
 
 #define VALID_MSIX_IDX(attr, msix_index) ((msix_index) < (attr)->num_irqs)
 
+#define WAIT_HWIF_READY_TIMEOUT	10000
+
 /**
  * hinic_msix_attr_set - set message attribute for msix entry
  * @hwif: the HW interface of a pci function device
@@ -187,20 +190,39 @@ void hinic_set_msix_state(struct hinic_hwif *hwif, u16 msix_idx,
  **/
 static int hwif_ready(struct hinic_hwif *hwif)
 {
-	struct pci_dev *pdev = hwif->pdev;
 	u32 addr, attr1;
 
 	addr   = HINIC_CSR_FUNC_ATTR1_ADDR;
 	attr1  = hinic_hwif_read_reg(hwif, addr);
 
-	if (!HINIC_FA1_GET(attr1, INIT_STATUS)) {
-		dev_err(&pdev->dev, "hwif status is not ready\n");
-		return -EFAULT;
+	if (!HINIC_FA1_GET(attr1, MGMT_INIT_STATUS))
+		return -EBUSY;
+
+	if (HINIC_IS_VF(hwif)) {
+		if (!HINIC_FA1_GET(attr1, PF_INIT_STATUS))
+			return -EBUSY;
 	}
 
 	return 0;
 }
 
+static int wait_hwif_ready(struct hinic_hwif *hwif)
+{
+	unsigned long timeout = 0;
+
+	do {
+		if (!hwif_ready(hwif))
+			return 0;
+
+		usleep_range(999, 1000);
+		timeout++;
+	} while (timeout <= WAIT_HWIF_READY_TIMEOUT);
+
+	dev_err(&hwif->pdev->dev, "Wait for hwif timeout\n");
+
+	return -EBUSY;
+}
+
 /**
  * set_hwif_attr - set the attributes in the relevant members in hwif
  * @hwif: the HW interface of a pci function device
@@ -373,7 +395,7 @@ int hinic_init_hwif(struct hinic_hwif *hwif, struct pci_dev *pdev)
 		goto err_map_intr_bar;
 	}
 
-	err = hwif_ready(hwif);
+	err = wait_hwif_ready(hwif);
 	if (err) {
 		dev_err(&pdev->dev, "HW interface is not ready\n");
 		goto err_hwif_ready;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index 53bb89c1dd26..5bb6ec4dcb7c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -55,13 +55,15 @@
 #define HINIC_FA1_IRQS_PER_FUNC_SHIFT                           20
 #define HINIC_FA1_DMA_ATTR_PER_FUNC_SHIFT                       24
 /* reserved members - off 27 */
-#define HINIC_FA1_INIT_STATUS_SHIFT                             30
+#define HINIC_FA1_MGMT_INIT_STATUS_SHIFT			30
+#define HINIC_FA1_PF_INIT_STATUS_SHIFT				31
 
 #define HINIC_FA1_AEQS_PER_FUNC_MASK                            0x3
 #define HINIC_FA1_CEQS_PER_FUNC_MASK                            0x7
 #define HINIC_FA1_IRQS_PER_FUNC_MASK                            0xF
 #define HINIC_FA1_DMA_ATTR_PER_FUNC_MASK                        0x7
-#define HINIC_FA1_INIT_STATUS_MASK                              0x1
+#define HINIC_FA1_MGMT_INIT_STATUS_MASK                         0x1
+#define HINIC_FA1_PF_INIT_STATUS_MASK				0x1
 
 #define HINIC_FA1_GET(val, member)                              \
 	(((val) >> HINIC_FA1_##member##_SHIFT) & HINIC_FA1_##member##_MASK)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 564fb2294a29..bc2f87e6cb5d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -627,7 +627,7 @@ wait_for_mbox_seg_completion(struct hinic_mbox_func_to_func *func_to_func,
 	struct hinic_hwdev *hwdev = func_to_func->hwdev;
 	struct completion *done = &send_mbox->send_done;
 	u32 cnt = 0;
-	ulong jif;
+	unsigned long jif;
 
 	if (poll) {
 		while (cnt < MBOX_MSG_POLLING_TIMEOUT) {
@@ -869,7 +869,7 @@ int hinic_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
 {
 	struct hinic_recv_mbox *mbox_for_resp;
 	struct mbox_msg_info msg_info = {0};
-	ulong timeo;
+	unsigned long timeo;
 	int err;
 
 	mbox_for_resp = &func_to_func->mbox_resp[dst_func];
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index b66bb86cff96..3d6569d7bac8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -427,10 +427,6 @@ static int hinic_open(struct net_device *netdev)
 		goto err_func_port_state;
 	}
 
-	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
-		/* Wait up to 3 sec between port enable to link state */
-		msleep(3000);
-
 	down(&nic_dev->mgmt_lock);
 
 	err = hinic_port_link_state(nic_dev, &link_state);
@@ -766,10 +762,12 @@ static void hinic_set_rx_mode(struct net_device *netdev)
 		  HINIC_RX_MODE_MC |
 		  HINIC_RX_MODE_BC;
 
-	if (netdev->flags & IFF_PROMISC)
-		rx_mode |= HINIC_RX_MODE_PROMISC;
-	else if (netdev->flags & IFF_ALLMULTI)
+	if (netdev->flags & IFF_PROMISC) {
+		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+			rx_mode |= HINIC_RX_MODE_PROMISC;
+	} else if (netdev->flags & IFF_ALLMULTI) {
 		rx_mode |= HINIC_RX_MODE_MC_ALL;
+	}
 
 	rx_mode_work->rx_mode = rx_mode;
 
@@ -868,6 +866,9 @@ static const struct net_device_ops hinic_netdev_ops = {
 	.ndo_set_vf_vlan = hinic_ndo_set_vf_vlan,
 	.ndo_get_vf_config = hinic_ndo_get_vf_config,
 	.ndo_set_vf_trust = hinic_ndo_set_vf_trust,
+	.ndo_set_vf_rate = hinic_ndo_set_vf_bw,
+	.ndo_set_vf_spoofchk = hinic_ndo_set_vf_spoofchk,
+	.ndo_set_vf_link_state = hinic_ndo_set_vf_link_state,
 };
 
 static const struct net_device_ops hinicvf_netdev_ops = {
@@ -1232,6 +1233,8 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
+	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
+
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
 				  HINIC_MGMT_MSG_CMD_LINK_STATUS);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index b7fe0adcc29a..714d8279c591 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -66,15 +66,15 @@ static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		return -EFAULT;
 	}
 
-	if (cmd == HINIC_PORT_CMD_SET_MAC && port_mac_cmd.status ==
-	    HINIC_PF_SET_VF_ALREADY) {
-		dev_warn(&pdev->dev, "PF has already set VF mac, Ignore set operation\n");
+	if (port_mac_cmd.status == HINIC_PF_SET_VF_ALREADY) {
+		dev_warn(&pdev->dev, "PF has already set VF mac, ignore %s operation\n",
+			 (op == MAC_SET) ? "set" : "del");
 		return HINIC_PF_SET_VF_ALREADY;
 	}
 
 	if (cmd == HINIC_PORT_CMD_SET_MAC && port_mac_cmd.status ==
 	    HINIC_MGMT_STATUS_EXIST)
-		dev_warn(&pdev->dev, "MAC is repeated. Ignore set operation\n");
+		dev_warn(&pdev->dev, "MAC is repeated, ignore set operation\n");
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 5ad04fb6722a..f2781521970e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -506,6 +506,49 @@ struct hinic_cmd_vport_stats {
 	struct hinic_vport_stats stats;
 };
 
+struct hinic_tx_rate_cfg_max_min {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+	u32	min_rate;
+	u32	max_rate;
+	u8	rsvd2[8];
+};
+
+struct hinic_tx_rate_cfg {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u16	rsvd1;
+	u32	tx_rate;
+};
+
+enum nic_speed_level {
+	LINK_SPEED_10MB = 0,
+	LINK_SPEED_100MB,
+	LINK_SPEED_1GB,
+	LINK_SPEED_10GB,
+	LINK_SPEED_25GB,
+	LINK_SPEED_40GB,
+	LINK_SPEED_100GB,
+	LINK_SPEED_LEVELS,
+};
+
+struct hinic_spoofchk_set {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u8	state;
+	u8	rsvd1;
+	u16	func_id;
+};
+
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		       u16 vlan_id);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index fd4aaf43874a..efab2dd2c889 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -22,6 +22,7 @@ MODULE_PARM_DESC(set_vf_link_state, "Set vf link state, 0 represents link auto,
 
 #define HINIC_VLAN_PRIORITY_SHIFT 13
 #define HINIC_ADD_VLAN_IN_MAC 0x8000
+#define HINIC_TX_RATE_TABLE_FULL 12
 
 static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
 			 u16 vlan_id, u16 func_id)
@@ -129,6 +130,84 @@ static int hinic_set_vf_vlan(struct hinic_hwdev *hwdev, bool add, u16 vid,
 	return 0;
 }
 
+static int hinic_set_vf_tx_rate_max_min(struct hinic_hwdev *hwdev, u16 vf_id,
+					u32 max_rate, u32 min_rate)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	struct hinic_tx_rate_cfg_max_min rate_cfg = {0};
+	u16 out_size = sizeof(rate_cfg);
+	int err;
+
+	rate_cfg.func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+	rate_cfg.max_rate = max_rate;
+	rate_cfg.min_rate = min_rate;
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE,
+				 &rate_cfg, sizeof(rate_cfg), &rate_cfg,
+				 &out_size);
+	if ((rate_cfg.status != HINIC_MGMT_CMD_UNSUPPORTED &&
+	     rate_cfg.status) || err || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set VF(%d) max rate(%d), min rate(%d), err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), max_rate, min_rate, err,
+			rate_cfg.status, out_size);
+		return -EIO;
+	}
+
+	if (!rate_cfg.status) {
+		nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].max_rate = max_rate;
+		nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].min_rate = min_rate;
+	}
+
+	return rate_cfg.status;
+}
+
+static int hinic_set_vf_rate_limit(struct hinic_hwdev *hwdev, u16 vf_id,
+				   u32 tx_rate)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	struct hinic_tx_rate_cfg rate_cfg = {0};
+	u16 out_size = sizeof(rate_cfg);
+	int err;
+
+	rate_cfg.func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+	rate_cfg.tx_rate = tx_rate;
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_VF_RATE,
+				 &rate_cfg, sizeof(rate_cfg), &rate_cfg,
+				 &out_size);
+	if (err || !out_size || rate_cfg.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set VF(%d) rate(%d), err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), tx_rate, err, rate_cfg.status,
+			out_size);
+		if (rate_cfg.status)
+			return rate_cfg.status;
+
+		return -EIO;
+	}
+
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].max_rate = tx_rate;
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].min_rate = 0;
+
+	return 0;
+}
+
+static int hinic_set_vf_tx_rate(struct hinic_hwdev *hwdev, u16 vf_id,
+				u32 max_rate, u32 min_rate)
+{
+	int err;
+
+	err = hinic_set_vf_tx_rate_max_min(hwdev, vf_id, max_rate, min_rate);
+	if (err != HINIC_MGMT_CMD_UNSUPPORTED)
+		return err;
+
+	if (min_rate) {
+		dev_err(&hwdev->hwif->pdev->dev, "Current firmware doesn't support to set min tx rate\n");
+		return -EOPNOTSUPP;
+	}
+
+	dev_info(&hwdev->hwif->pdev->dev, "Current firmware doesn't support to set min tx rate, force min_tx_rate = max_tx_rate\n");
+
+	return hinic_set_vf_rate_limit(hwdev, vf_id, max_rate);
+}
+
 static int hinic_init_vf_config(struct hinic_hwdev *hwdev, u16 vf_id)
 {
 	struct vf_data_storage *vf_info;
@@ -160,6 +239,17 @@ static int hinic_init_vf_config(struct hinic_hwdev *hwdev, u16 vf_id)
 		}
 	}
 
+	if (vf_info->max_rate) {
+		err = hinic_set_vf_tx_rate(hwdev, vf_id, vf_info->max_rate,
+					   vf_info->min_rate);
+		if (err) {
+			dev_err(&hwdev->hwif->pdev->dev, "Failed to set VF %d max rate: %d, min rate: %d\n",
+				HW_VF_ID_TO_OS(vf_id), vf_info->max_rate,
+				vf_info->min_rate);
+			return err;
+		}
+	}
+
 	return 0;
 }
 
@@ -700,6 +790,185 @@ int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting)
 	return err;
 }
 
+int hinic_ndo_set_vf_bw(struct net_device *netdev,
+			int vf, int min_tx_rate, int max_tx_rate)
+{
+	u32 speeds[] = {SPEED_10, SPEED_100, SPEED_1000, SPEED_10000,
+			SPEED_25000, SPEED_40000, SPEED_100000};
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_port_cap port_cap = { 0 };
+	enum hinic_port_link_state link_state;
+	int err;
+
+	if (vf >= nic_dev->sriov_info.num_vfs) {
+		netif_err(nic_dev, drv, netdev, "VF number must be less than %d\n",
+			  nic_dev->sriov_info.num_vfs);
+		return -EINVAL;
+	}
+
+	if (max_tx_rate < min_tx_rate) {
+		netif_err(nic_dev, drv, netdev, "Max rate %d must be greater than or equal to min rate %d\n",
+			  max_tx_rate, min_tx_rate);
+		return -EINVAL;
+	}
+
+	err = hinic_port_link_state(nic_dev, &link_state);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Get link status failed when setting vf tx rate\n");
+		return -EIO;
+	}
+
+	if (link_state == HINIC_LINK_STATE_DOWN) {
+		netif_err(nic_dev, drv, netdev,
+			  "Link status must be up when setting vf tx rate\n");
+		return -EPERM;
+	}
+
+	err = hinic_port_get_cap(nic_dev, &port_cap);
+	if (err || port_cap.speed > LINK_SPEED_100GB)
+		return -EIO;
+
+	/* rate limit cannot be less than 0 and greater than link speed */
+	if (max_tx_rate < 0 || max_tx_rate > speeds[port_cap.speed]) {
+		netif_err(nic_dev, drv, netdev, "Max tx rate must be in [0 - %d]\n",
+			  speeds[port_cap.speed]);
+		return -EINVAL;
+	}
+
+	err = hinic_set_vf_tx_rate(nic_dev->hwdev, OS_VF_ID_TO_HW(vf),
+				   max_tx_rate, min_tx_rate);
+	if (err) {
+		netif_err(nic_dev, drv, netdev,
+			  "Unable to set VF %d max rate %d min rate %d%s\n",
+			  vf, max_tx_rate, min_tx_rate,
+			  err == HINIC_TX_RATE_TABLE_FULL ?
+			  ", tx rate profile is full" : "");
+		return -EIO;
+	}
+
+	netif_info(nic_dev, drv, netdev,
+		   "Set VF %d max tx rate %d min tx rate %d successfully\n",
+		   vf, max_tx_rate, min_tx_rate);
+
+	return 0;
+}
+
+static int hinic_set_vf_spoofchk(struct hinic_hwdev *hwdev, u16 vf_id,
+				 bool spoofchk)
+{
+	struct hinic_spoofchk_set spoofchk_cfg = {0};
+	struct vf_data_storage *vf_infos = NULL;
+	u16 out_size = sizeof(spoofchk_cfg);
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	vf_infos = hwdev->func_to_io.vf_infos;
+
+	spoofchk_cfg.func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+	spoofchk_cfg.state = spoofchk ? 1 : 0;
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_ENABLE_SPOOFCHK,
+				 &spoofchk_cfg, sizeof(spoofchk_cfg),
+				 &spoofchk_cfg, &out_size);
+	if (spoofchk_cfg.status == HINIC_MGMT_CMD_UNSUPPORTED) {
+		err = HINIC_MGMT_CMD_UNSUPPORTED;
+	} else if (err || !out_size || spoofchk_cfg.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set VF(%d) spoofchk, err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), err, spoofchk_cfg.status,
+			out_size);
+		err = -EIO;
+	}
+
+	vf_infos[HW_VF_ID_TO_OS(vf_id)].spoofchk = spoofchk;
+
+	return err;
+}
+
+int hinic_ndo_set_vf_spoofchk(struct net_device *netdev, int vf, bool setting)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+	bool cur_spoofchk;
+	int err;
+
+	sriov_info = &nic_dev->sriov_info;
+	if (vf >= sriov_info->num_vfs)
+		return -EINVAL;
+
+	cur_spoofchk = nic_dev->hwdev->func_to_io.vf_infos[vf].spoofchk;
+
+	/* same request, so just return success */
+	if ((setting && cur_spoofchk) || (!setting && !cur_spoofchk))
+		return 0;
+
+	err = hinic_set_vf_spoofchk(sriov_info->hwdev,
+				    OS_VF_ID_TO_HW(vf), setting);
+
+	if (!err) {
+		netif_info(nic_dev, drv, netdev, "Set VF %d spoofchk %s successfully\n",
+			   vf, setting ? "on" : "off");
+	} else if (err == HINIC_MGMT_CMD_UNSUPPORTED) {
+		netif_err(nic_dev, drv, netdev,
+			  "Current firmware doesn't support to set vf spoofchk, need to upgrade latest firmware version\n");
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int hinic_set_vf_link_state(struct hinic_hwdev *hwdev, u16 vf_id,
+				   int link)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	struct vf_data_storage *vf_infos = nic_io->vf_infos;
+	u8 link_status = 0;
+
+	switch (link) {
+	case HINIC_IFLA_VF_LINK_STATE_AUTO:
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_forced = false;
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_up = nic_io->link_status ?
+			true : false;
+		link_status = nic_io->link_status;
+		break;
+	case HINIC_IFLA_VF_LINK_STATE_ENABLE:
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_forced = true;
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_up = true;
+		link_status = HINIC_LINK_UP;
+		break;
+	case HINIC_IFLA_VF_LINK_STATE_DISABLE:
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_forced = true;
+		vf_infos[HW_VF_ID_TO_OS(vf_id)].link_up = false;
+		link_status = HINIC_LINK_DOWN;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Notify the VF of its new link state */
+	hinic_notify_vf_link_status(hwdev, vf_id, link_status);
+
+	return 0;
+}
+
+int hinic_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	struct hinic_sriov_info *sriov_info;
+
+	sriov_info = &nic_dev->sriov_info;
+
+	if (vf_id >= sriov_info->num_vfs) {
+		netif_err(nic_dev, drv, netdev,
+			  "Invalid VF Identifier %d\n", vf_id);
+		return -EINVAL;
+	}
+
+	return hinic_set_vf_link_state(sriov_info->hwdev,
+				      OS_VF_ID_TO_HW(vf_id), link);
+}
+
 /* pf receive message from vf */
 static int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 			       u16 in_size, void *buf_out, u16 *out_size)
@@ -801,6 +1070,12 @@ static void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 	if (hinic_vf_info_vlanprio(nic_dev->hwdev, vf_id))
 		hinic_kill_vf_vlan(nic_dev->hwdev, vf_id);
 
+	if (vf_infos->max_rate)
+		hinic_set_vf_tx_rate(nic_dev->hwdev, vf_id, 0, 0);
+
+	if (vf_infos->spoofchk)
+		hinic_set_vf_spoofchk(nic_dev->hwdev, vf_id, false);
+
 	if (vf_infos->trust)
 		hinic_set_vf_trust(nic_dev->hwdev, vf_id, false);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
index 64affc7474b5..ba627a362f9a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
@@ -86,6 +86,13 @@ int hinic_ndo_get_vf_config(struct net_device *netdev,
 
 int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting);
 
+int hinic_ndo_set_vf_bw(struct net_device *netdev,
+			int vf, int min_tx_rate, int max_tx_rate);
+
+int hinic_ndo_set_vf_spoofchk(struct net_device *netdev, int vf, bool setting);
+
+int hinic_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link);
+
 void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
 				       u8 link_status);
 
-- 
2.17.1

