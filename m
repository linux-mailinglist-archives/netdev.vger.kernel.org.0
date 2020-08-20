Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AE724BAA6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgHTMO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:14:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9794 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729772AbgHTMOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 08:14:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3C17FDB495225A70BC90;
        Thu, 20 Aug 2020 20:14:12 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 20 Aug 2020 20:14:04 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next] hinic: add debugfs support
Date:   Thu, 20 Aug 2020 20:14:32 +0800
Message-ID: <20200820121432.23597-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add debugfs node for querying sq/rq info, mac table, sq ci table,
rq cqe info, global table, function table, port and vlan table.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/Makefile    |    3 +-
 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 1354 +++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_debugfs.h |  769 ++++++++++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |    2 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   25 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   25 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |    1 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c |    1 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |    2 +
 .../net/ethernet/huawei/hinic/hinic_hw_wq.c   |    5 +
 .../net/ethernet/huawei/hinic/hinic_hw_wq.h   |    2 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |   20 +-
 12 files changed, 2207 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index 67b59d0ba769..2f89119c9b69 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o hinic_ethtool.o hinic_devlink.o hinic_hw_mbox.o hinic_sriov.o
+	   hinic_common.o hinic_ethtool.o hinic_devlink.o hinic_hw_mbox.o \
+	   hinic_sriov.o hinic_debugfs.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
new file mode 100644
index 000000000000..3263afc50d85
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -0,0 +1,1354 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+
+#include "hinic_debugfs.h"
+
+static struct dentry *hinic_dbgfs_root;
+
+struct hinic_tx_hw_page {
+	u64     phy_addr;
+	u64	*map_addr;
+};
+
+struct hinic_dbg_sq_info {
+	u16	q_id;
+	u16	pi;
+	u16	ci; /* sw_ci */
+	u16	fi; /* hw_ci */
+
+	u32	q_depth;
+	u16	pi_reverse;
+	u16	wqebb_size;
+
+	u8	priority;
+	u16	*ci_addr;
+	u64	cla_addr;
+
+	void	*slq_handle;
+
+	struct hinic_tx_hw_page	direct_wqe;
+	struct hinic_tx_hw_page	db_addr;
+	u32	pg_idx;
+
+	u32	glb_sq_id;
+};
+
+struct hinic_dbg_rq_info {
+	u16	q_id;
+	u16	glb_rq_id;
+	u16	hw_pi;
+	u16	sw_ci;
+	u16	sw_pi;
+	u16	wqebb_size;
+	u16	q_depth;
+	u16	buf_len;
+
+	void	*slq_handle;
+	u64	ci_wqe_page_addr;
+	u64	ci_cla_tbl_addr;
+
+	u16	msix_idx;
+	u32	msix_vector;
+};
+
+static void tx_show_sq_info(struct hinic_dev *nic_dev,
+			    struct hinic_dbg_sq_info *sq_info)
+{
+	netif_info(nic_dev, drv, nic_dev->netdev, "Send queue %u information:\n",
+		   sq_info->q_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "queue_id: %u\n",
+		   sq_info->q_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pi: %u\n", sq_info->pi);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ci: %u\n", sq_info->ci);
+	netif_info(nic_dev, drv, nic_dev->netdev, "fi: %u\n", sq_info->fi);
+	netif_info(nic_dev, drv, nic_dev->netdev, "sq_depth: %u\n",
+		   sq_info->q_depth);
+	netif_info(nic_dev, drv, nic_dev->netdev, "sq_wqebb_size: %u\n",
+		   sq_info->wqebb_size);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ci_addr: %p\n",
+		   sq_info->ci_addr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cla_addr: 0x%llx\n",
+		   sq_info->cla_addr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "slq_handle: %p\n",
+		   sq_info->slq_handle);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_qpn: %u\n",
+		   sq_info->glb_sq_id);
+}
+
+static int hinic_dbg_get_sq_info(struct hinic_dev *nic_dev,
+				 const char *cmd_buf)
+{
+	struct hinic_dbg_sq_info *sq_info;
+	struct hinic_sq *sq;
+	struct hinic_wq *wq;
+	u32 queue_id;
+	int cnt;
+
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Netdev is down, can't get sq info\n");
+		return -EPERM;
+	}
+
+	cnt = kstrtouint(&cmd_buf[8], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	sq_info = kzalloc(sizeof(*sq_info), GFP_KERNEL);
+	if (!sq_info)
+		return -ENOMEM;
+
+	sq = nic_dev->txqs[queue_id].sq;
+	wq = sq->wq;
+
+	sq_info->q_id = queue_id;
+	sq_info->pi = atomic_read(&wq->prod_idx) & wq->mask;
+	sq_info->ci = atomic_read(&wq->cons_idx) & wq->mask;
+	sq_info->fi = be16_to_cpu(*(__be16 *)(sq->hw_ci_addr)) & wq->mask;
+	sq_info->q_depth = wq->q_depth;
+	sq_info->wqebb_size = HINIC_SQ_WQEBB_SIZE;
+	sq_info->ci_addr = sq->hw_ci_addr;
+	sq_info->cla_addr = wq->block_paddr;
+	sq_info->slq_handle = wq;
+	sq_info->glb_sq_id = nic_dev->hwdev->func_to_io.global_qpn + queue_id;
+
+	tx_show_sq_info(nic_dev, sq_info);
+
+	kfree(sq_info);
+
+	return 0;
+}
+
+static void tx_show_wqe_info(struct hinic_dev *nic_dev, struct hinic_sq_wqe *wqe)
+{
+	struct hinic_tx_ctrl_section *control = NULL;
+	struct hinic_tx_task_section *task = NULL;
+	struct hinic_tx_sge *bd = NULL;
+	u32 *data = NULL;
+	u16 i;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Sq wqe hex:\n");
+	data = (u32 *)wqe;
+	for (i = 0; i < (sizeof(*wqe) / sizeof(u32)) / DUMP_WQE_PER_LINE; i++) {
+		netif_info(nic_dev, drv, nic_dev->netdev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   data[DUMP_WQE_PER_LINE * i],
+			   data[(DUMP_WQE_PER_LINE * i) + 1U],
+			   data[(DUMP_WQE_PER_LINE * i) + 2U],
+			   data[(DUMP_WQE_PER_LINE * i) + 3U]);
+	}
+
+	control = (struct hinic_tx_ctrl_section *)&wqe->ctrl;
+	netif_info(nic_dev, drv, nic_dev->netdev, "Information about wqe control section:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "ctrl_format: 0x%x\n", control->ctrl_format);
+	netif_info(nic_dev, drv, nic_dev->netdev, "owner: %u\n", control->ctrl_sec.owner);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ctrl_sec_len: %u\n",
+		   control->ctrl_sec.ctrl_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "completion_sec_len: %u\n",
+		   control->ctrl_sec.completion_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "dif_sec_len: %u\n",
+		   control->ctrl_sec.dif_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cr:%u\n", control->ctrl_sec.cr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "df:%u\n", control->ctrl_sec.df);
+	netif_info(nic_dev, drv, nic_dev->netdev, "va:%u\n", control->ctrl_sec.va);
+	netif_info(nic_dev, drv, nic_dev->netdev, "task_sec_len: %u\n",
+		   control->ctrl_sec.task_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cf: %u\n", control->ctrl_sec.cf);
+	netif_info(nic_dev, drv, nic_dev->netdev, "wf: %u\n", control->ctrl_sec.wf);
+	netif_info(nic_dev, drv, nic_dev->netdev, "drv_sec_len: %u\n",
+		   control->ctrl_sec.drv_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "buf_desc_sec_len: %u\n",
+		   control->ctrl_sec.buf_desc_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "queue_info: 0x%x\n", control->queue_info);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pri: %u\n", control->qsf.pri);
+	netif_info(nic_dev, drv, nic_dev->netdev, "uc: %u\n", control->qsf.uc);
+	netif_info(nic_dev, drv, nic_dev->netdev, "sctp: %u\n", control->qsf.sctp);
+	netif_info(nic_dev, drv, nic_dev->netdev, "mss: %u\n", control->qsf.mss);
+	netif_info(nic_dev, drv, nic_dev->netdev, "tcp_udp_cs: %u\n", control->qsf.tcp_udp_cs);
+	netif_info(nic_dev, drv, nic_dev->netdev, "tso: %u\n", control->qsf.tso);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ufo: %u\n", control->qsf.ufo);
+	netif_info(nic_dev, drv, nic_dev->netdev, "payload_offset: %u\n",
+		   control->qsf.payload_offset);
+
+	/* show the task section */
+	task = (struct hinic_tx_task_section *)&wqe->task;
+	netif_info(nic_dev, drv, nic_dev->netdev, "\nInformation about wqe task section:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "il2tag: %u\n", task->bs0.il2tag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "tso: %u\n", task->bs0.tso);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pkt_parse_valid: %u\n",
+		   task->bs0.pkt_parse_valid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l2tag_flag: %u\n", task->bs0.l2tag_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "inner_ip_type: %u\n", task->bs0.inner_ip_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l4_type: %u\n", task->bs0.l4_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "mac_len: %u\n", task->bs0.mac_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "inner_ip_len: %u\n", task->bs1.inner_ip_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "inner_l4_len: %u\n", task->bs1.inner_l4_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "udp_pseudo_head_cs: %u\n",
+		   task->bs1.udp_pseudo_head_cs);
+	netif_info(nic_dev, drv, nic_dev->netdev, "external_ip_type: %u\n",
+		   task->bs2.external_ip_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l4_tunnel_type: %u\n",
+		   task->bs2.l4_tunnel_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "external_ip_len: %u\n",
+		   task->bs2.external_ip_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l4_tunnel_len: %u\n", task->bs2.l4_tunnel_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ip_identify: %u\n", task->ip_identify);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pkt_type: %u\n", task->bs4.pkt_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rsvd4: %u\n", task->bs4.rsvd4);
+
+	bd = (struct hinic_tx_sge *)&wqe->buf_descs[0];
+	netif_info(nic_dev, drv, nic_dev->netdev, "\nInformation about wqe data1 section:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "bd information:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "addr: 0x%llx\n",
+		   (((unsigned long long)bd->dma_addr_high) << 32) | bd->dma_addr_low);
+	netif_info(nic_dev, drv, nic_dev->netdev, "length: %u\n", bd->bs2.length);
+
+	bd = (struct hinic_tx_sge *)&wqe->buf_descs[1];
+	netif_info(nic_dev, drv, nic_dev->netdev, "\nInformation about wqe data2 section:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "bd information:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "addr: 0x%llx\n",
+		   (((unsigned long long)bd->dma_addr_high) << 32) | bd->dma_addr_low);
+	netif_info(nic_dev, drv, nic_dev->netdev, "length: %u\n", bd->bs2.length);
+}
+
+static int hinic_dbg_get_sq_wqe_info(struct hinic_dev *nic_dev,
+				     const char *cmd_buf)
+{
+	struct hinic_sq_wqe sq_wqe = {0};
+	struct hinic_sq_wqe *wqe;
+	struct hinic_sq *sq;
+	char *cmd_buf_tmp;
+	u32 wqebb_idx;
+	u32 queue_id;
+	int cnt;
+
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Netdev is down, can't get sq wqe info\n");
+		return -EPERM;
+	}
+
+	cmd_buf_tmp = strchr(&cmd_buf[12], ' ');
+	if (cmd_buf_tmp)
+		*cmd_buf_tmp = '\0';
+
+	cnt = kstrtouint(&cmd_buf[12], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u, is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	sq = nic_dev->txqs[queue_id].sq;
+
+	if (queue_id < 10)
+		cnt = kstrtouint(&cmd_buf[14], 0, &wqebb_idx);
+	else
+		cnt = kstrtouint(&cmd_buf[15], 0, &wqebb_idx);
+
+	if (cnt)
+		wqebb_idx = 0;
+
+	if (wqebb_idx >= sq->wq->q_depth) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input wqebb idx %u is out of range: 0-%d\n",
+			  wqebb_idx, sq->wq->q_depth - 1);
+		return -EINVAL;
+	}
+
+	wqe = hinic_get_wqebb_addr(sq->wq, wqebb_idx);
+	memcpy(&sq_wqe, wqe, sizeof(sq_wqe));
+	hinic_be32_to_cpu(&sq_wqe, sizeof(sq_wqe));
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Sq: %u wqebb idx: %u info:\n",
+		   queue_id, wqebb_idx);
+	tx_show_wqe_info(nic_dev, &sq_wqe);
+
+	return 0;
+}
+
+static void rx_show_rq_info(struct hinic_dev *nic_dev,
+			    struct hinic_dbg_rq_info *rq_info)
+{
+	netif_info(nic_dev, drv, nic_dev->netdev, "Receive queue %u information:\n",
+		   rq_info->q_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "queue_id: %u\n",
+		   rq_info->q_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "hw_pi: %u\n",
+		   rq_info->hw_pi);
+	netif_info(nic_dev, drv, nic_dev->netdev, "sw_ci: %u\n", rq_info->sw_ci);
+	netif_info(nic_dev, drv, nic_dev->netdev, "sw_pi: %u\n", rq_info->sw_pi);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rq_depth: %u\n",
+		   rq_info->q_depth);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rq_wqebb_size: %u\n",
+		   rq_info->wqebb_size);
+	netif_info(nic_dev, drv, nic_dev->netdev, "buf_len: %u\n",
+		   rq_info->buf_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ci_wqe_page_addr: 0x%llx\n",
+		   rq_info->ci_wqe_page_addr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ci_cla_tbl_addr: 0x%llx\n",
+		   rq_info->ci_cla_tbl_addr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "slq_handle: %p\n",
+		   rq_info->slq_handle);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_qpn: %u\n",
+		   rq_info->glb_rq_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "msix_entry: %u\n",
+		   rq_info->msix_idx);
+	netif_info(nic_dev, drv, nic_dev->netdev, "irq_id: %u\n",
+		   rq_info->msix_vector);
+}
+
+static int hinic_dbg_get_rq_info(struct hinic_dev *nic_dev,
+				 const char *cmd_buf)
+{
+	struct hinic_dbg_rq_info *rq_info;
+	struct hinic_rq *rq;
+	struct hinic_wq *wq;
+	u32 queue_id;
+	int cnt;
+
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Netdev is down, can't get rq info\n");
+		return -EPERM;
+	}
+
+	cnt = kstrtouint(&cmd_buf[8], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u, is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	rq_info = kzalloc(sizeof(*rq_info), GFP_KERNEL);
+	if (!rq_info)
+		return -ENOMEM;
+
+	rq = nic_dev->rxqs[queue_id].rq;
+	wq = rq->wq;
+
+	rq_info->q_id = queue_id;
+	rq_info->glb_rq_id = nic_dev->hwdev->func_to_io.global_qpn + queue_id;
+	rq_info->hw_pi = be16_to_cpu(*(__be16 *)(rq->pi_virt_addr)) & wq->mask;
+	rq_info->sw_ci =  atomic_read(&wq->cons_idx) & wq->mask;
+	rq_info->sw_pi = atomic_read(&wq->prod_idx) & wq->mask;
+	rq_info->wqebb_size = HINIC_RQ_WQE_SIZE;
+	rq_info->q_depth = wq->q_depth;
+	rq_info->buf_len = nic_dev->rxqs[queue_id].buf_len;
+	rq_info->slq_handle = wq;
+	rq_info->ci_wqe_page_addr = be64_to_cpu(*(__be64 *)wq->block_vaddr);
+	rq_info->ci_cla_tbl_addr = wq->block_paddr;
+	rq_info->msix_idx = rq->msix_entry;
+	rq_info->msix_vector = rq->irq;
+
+	rx_show_rq_info(nic_dev, rq_info);
+
+	kfree(rq_info);
+
+	return 0;
+}
+
+static void rx_show_wqe_info(struct hinic_dev *nic_dev,
+			     struct hinic_rq_wqe_info *wqe)
+{
+	u32 *data = NULL;
+	u16 i;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rq wqe hex:\n");
+	data = (u32 *)wqe;
+	for (i = 0; i < (sizeof(*wqe) / sizeof(u32)) / DUMP_WQE_PER_LINE; i++) {
+		netif_info(nic_dev, drv, nic_dev->netdev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   data[DUMP_WQE_PER_LINE * i],
+			   data[(DUMP_WQE_PER_LINE * i) + 1U],
+			   data[(DUMP_WQE_PER_LINE * i) + 2U],
+			   data[(DUMP_WQE_PER_LINE * i) + 3U]);
+	}
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rx wqe control section information:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "dw: 0x%x\n", wqe->rq_wqe_ctrl_sec.dw);
+	netif_info(nic_dev, drv, nic_dev->netdev, "owner: %u\n", wqe->rq_wqe_ctrl_sec.bs.owner);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ctrl_sec_len: %u\n",
+		   wqe->rq_wqe_ctrl_sec.bs.ctrl_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "completion_sec_len: %u\n",
+		   wqe->rq_wqe_ctrl_sec.bs.completion_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cr: %u\n", wqe->rq_wqe_ctrl_sec.bs.cr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "df: %u\n", wqe->rq_wqe_ctrl_sec.bs.df);
+	netif_info(nic_dev, drv, nic_dev->netdev, "task_sec_len: %u\n",
+		   wqe->rq_wqe_ctrl_sec.bs.task_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cf: %u\n", wqe->rq_wqe_ctrl_sec.bs.cf);
+	netif_info(nic_dev, drv, nic_dev->netdev, "drv_sec_len: %u\n",
+		   wqe->rq_wqe_ctrl_sec.bs.drv_sec_len);
+	netif_info(nic_dev, drv, nic_dev->netdev, "buf_desc_sec_len: %u\n",
+		   wqe->rq_wqe_ctrl_sec.bs.buf_desc_sec_len);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "\nInformation about rx wqe sge section:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "dw0: 0x%x\n", wqe->rx_sge.dw0);
+	netif_info(nic_dev, drv, nic_dev->netdev, "wb_buf_len: %u\n", wqe->rx_sge.bs0.length);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "dw1: 0x%x\n", wqe->rx_sge.dw1);
+	netif_info(nic_dev, drv, nic_dev->netdev, "wb_addr_high: 0x%x\n", wqe->rx_sge.wb_addr_high);
+	netif_info(nic_dev, drv, nic_dev->netdev, "wb_addr_low: 0x%x\n", wqe->rx_sge.wb_addr_low);
+}
+
+static int hinic_dbg_get_rq_wqe_info(struct hinic_dev *nic_dev,
+				     const char *cmd_buf)
+{
+	struct hinic_rq_wqe_info rq_wqe = {0};
+	struct hinic_rq *rq;
+	char *cmd_buf_tmp;
+	u32 wqebb_idx;
+	u32 queue_id;
+	void *wqe;
+	int cnt;
+
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Netdev is down, can't get rq wqe info\n");
+		return -EPERM;
+	}
+
+	cmd_buf_tmp = strchr(&cmd_buf[12], ' ');
+	if (cmd_buf_tmp)
+		*cmd_buf_tmp = '\0';
+
+	cnt = kstrtouint(&cmd_buf[12], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	rq = nic_dev->rxqs[queue_id].rq;
+
+	if (queue_id < 10)
+		cnt = kstrtouint(&cmd_buf[14], 0, &wqebb_idx);
+	else
+		cnt = kstrtouint(&cmd_buf[15], 0, &wqebb_idx);
+
+	if (cnt)
+		wqebb_idx = 0;
+
+	if (wqebb_idx >= rq->wq->q_depth) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input wqebb idx %u is out of range: 0-%d\n",
+			  wqebb_idx, rq->wq->q_depth - 1);
+		return -EINVAL;
+	}
+
+	wqe = hinic_get_wqebb_addr(rq->wq, wqebb_idx);
+	memcpy(&rq_wqe, wqe, sizeof(rq_wqe));
+	hinic_be32_to_cpu(&rq_wqe, sizeof(rq_wqe));
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rq: %u wqebb idx: %u info:\n",
+		   queue_id, wqebb_idx);
+	rx_show_wqe_info(nic_dev, &rq_wqe);
+
+	return 0;
+}
+
+static void show_ci_attr_table(struct hinic_dev *nic_dev,
+			       struct hinic_cmd_get_hw_ci_tbl *ci_attr)
+{
+	netif_info(nic_dev, drv, nic_dev->netdev, "ci_addr: 0x%llx\n", ci_attr->ci_addr);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pending_limit: %u\n", ci_attr->pending_limit);
+	netif_info(nic_dev, drv, nic_dev->netdev, "coalescing_time: %u\n", ci_attr->coalesce_time);
+	netif_info(nic_dev, drv, nic_dev->netdev, "dma_attr_off: %u\n", ci_attr->dma_attr_off);
+	netif_info(nic_dev, drv, nic_dev->netdev, "int_en: %u\n", ci_attr->int_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "int_offset: %u\n", ci_attr->int_offset);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l2nic_sqn: %u\n", ci_attr->l2nic_sqn);
+	netif_info(nic_dev, drv, nic_dev->netdev, "version: %u\n", ci_attr->version);
+	netif_info(nic_dev, drv, nic_dev->netdev, "status: %u\n", ci_attr->status);
+	netif_info(nic_dev, drv, nic_dev->netdev, "func_idx: %u\n", ci_attr->func_idx);
+}
+
+static int hinic_dbg_get_ci_table(struct hinic_dev *nic_dev,
+				  const char *cmd_buf)
+{
+	struct hinic_cmd_get_hw_ci_tbl ci_tbl = {0};
+	u32 queue_id;
+	int cnt, err;
+
+	cnt = kstrtouint(&cmd_buf[12], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	ci_tbl.func_idx = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+	ci_tbl.l2nic_sqn = queue_id;
+
+	err = hinic_hwdev_hw_ci_table_get(nic_dev->hwdev, &ci_tbl);
+	if (err)
+		return err;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Sq: %u ci table info:\n",
+		   queue_id);
+	show_ci_attr_table(nic_dev, &ci_tbl);
+
+	return 0;
+}
+
+static void rx_show_cqe(struct hinic_dev *nic_dev,
+			struct hinic_rq_cqe_info *wqe_cs)
+{
+	u32 *data = (u32 *)wqe_cs;
+	u16 i;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rq cqe hex:\n");
+	for (i = 0; i < (sizeof(*wqe_cs) / sizeof(u32)) / DUMP_WQE_PER_LINE; i++)
+		netif_info(nic_dev, drv, nic_dev->netdev, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   data[DUMP_WQE_PER_LINE * i],
+			   data[(DUMP_WQE_PER_LINE * i) + 1U],
+			   data[(DUMP_WQE_PER_LINE * i) + 2U],
+			   data[(DUMP_WQE_PER_LINE * i) + 3U]);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rx wqe info:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "wqe_cs: 0x%p\n", wqe_cs);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cs_dw0: 0x%08x\n",
+		   wqe_cs->dw0.value);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rx_done: 0x%x\n",
+		   wqe_cs->dw0.bs.rx_done);
+	netif_info(nic_dev, drv, nic_dev->netdev, "checksum_err: 0x%x\n",
+		   wqe_cs->dw0.bs.checksum_err);
+	netif_info(nic_dev, drv, nic_dev->netdev, "lro_num: 0x%x\n",
+		   wqe_cs->dw0.bs.lro_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cs_dw1: 0x%08x\n",
+		   wqe_cs->dw1.value);
+	netif_info(nic_dev, drv, nic_dev->netdev, "length: %u\n",
+		   wqe_cs->dw1.bs.length);
+	netif_info(nic_dev, drv, nic_dev->netdev, "vlan: 0x%x\n",
+		   wqe_cs->dw1.bs.vlan);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "cs_dw2: 0x%08x\n",
+		   wqe_cs->dw2.value);
+	netif_info(nic_dev, drv, nic_dev->netdev, "tag_num: 0x%x\n",
+		   wqe_cs->dw2.bs.tag_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "l2tag1p: 0x%x\n",
+		   wqe_cs->dw2.bs.vlan_offload_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "umbcast: 0x%x\n",
+		   wqe_cs->dw2.bs.umbcast);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "loopback: 0x%x\n",
+		   wqe_cs->dw2.bs.loopback);
+	netif_info(nic_dev, drv, nic_dev->netdev, "ipv6_ex_add: 0x%x\n",
+		   wqe_cs->dw2.bs.ipv6_ex_add);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "udp_0: 0x%x\n",
+		   wqe_cs->dw2.bs.udp_0);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rss_type: 0x%x\n",
+		   wqe_cs->dw2.bs.rss_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "pkt_types: 0x%x\n",
+		   wqe_cs->dw2.bs.pkt_types);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rss_hash_value: 0x%08x\n",
+		   wqe_cs->dw3.bs.rss_hash_value);
+	netif_info(nic_dev, drv, nic_dev->netdev, "cs_dw4: 0x%08x\n",
+		   wqe_cs->dw4.value);
+	netif_info(nic_dev, drv, nic_dev->netdev, "if_1588: 0x%x\n",
+		   wqe_cs->dw4.bs.if_1588);
+	netif_info(nic_dev, drv, nic_dev->netdev, "if_tx_ts: 0x%x\n",
+		   wqe_cs->dw4.bs.if_tx_ts);
+	netif_info(nic_dev, drv, nic_dev->netdev, "if_rx_ts: 0x%x\n",
+		   wqe_cs->dw4.bs.if_rx_ts);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "type_1588: 0x%x\n",
+		   wqe_cs->dw4.bs.message_1588_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "offset_1588: 0x%x\n",
+		   wqe_cs->dw4.bs.message_1588_offset);
+	netif_info(nic_dev, drv, nic_dev->netdev, "tx_ts_seq: 0x%x\n",
+		   wqe_cs->dw4.bs.tx_ts_seq);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "ts: 0x%08x\n",
+		   wqe_cs->dw5.bs.ts);
+	netif_info(nic_dev, drv, nic_dev->netdev, "rsc_ts: 0x%08x\n",
+		   wqe_cs->dw6.bs.lro_ts);
+}
+
+static int hinic_dbg_get_rq_cqe_info(struct hinic_dev *nic_dev,
+				     const char *cmd_buf)
+{
+	struct hinic_rq_cqe_info rq_cqe = {0};
+	struct hinic_rq *rq;
+	char *cmd_buf_tmp;
+	u32 queue_id;
+	u32 cqe_id;
+	void *cqe;
+	int cnt;
+
+	if (!(nic_dev->flags & HINIC_INTF_UP)) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Netdev is down, can't get rq cqe info\n");
+		return -EPERM;
+	}
+
+	cmd_buf_tmp = strchr(&cmd_buf[12], ' ');
+	if (cmd_buf_tmp)
+		*cmd_buf_tmp = '\0';
+
+	cnt = kstrtouint(&cmd_buf[12], 0, &queue_id);
+	if (cnt)
+		queue_id = 0;
+
+	if (queue_id >= nic_dev->num_qps) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input queue id %u is is out of range: 0-%d\n",
+			  queue_id, nic_dev->num_qps - 1);
+		return -EINVAL;
+	}
+
+	rq = nic_dev->rxqs[queue_id].rq;
+
+	if (queue_id < 10)
+		cnt = kstrtouint(&cmd_buf[14], 0, &cqe_id);
+	else
+		cnt = kstrtouint(&cmd_buf[15], 0, &cqe_id);
+
+	if (cnt)
+		cqe_id = 0;
+
+	if (cqe_id >= rq->wq->q_depth) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Input cqe idx %u is out of range: 0-%d\n",
+			  cqe_id, rq->wq->q_depth - 1);
+		return -EINVAL;
+	}
+
+	cqe = rq->cqe[cqe_id];
+	memcpy(&rq_cqe, cqe, sizeof(rq_cqe));
+	hinic_be32_to_cpu(&rq_cqe, sizeof(rq_cqe));
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "Rq: %u cqe idx: %u info:\n",
+		   queue_id, cqe_id);
+	rx_show_cqe(nic_dev, &rq_cqe);
+
+	return 0;
+}
+
+static void show_mac_table(struct hinic_dev *nic_dev, u8 *sml_table, u32 cnt)
+{
+	struct mac_table_entry *mte = (struct mac_table_entry *)sml_table;
+	u32 i;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "static_flag\t er_id\t mac\t\t\t vlan_id\t fwd_type\t fwd_id\n");
+
+	for (i = 0; i < cnt; i++) {
+		if (mte[i].valid)
+			netif_info(nic_dev, drv, nic_dev->netdev, "%u\t\t %u\t %02x:%02x:%02x:%02x:%02x:%02x\t %u\t\t %u\t\t %u\n",
+				   mte[i].static_flag, mte[i].er_id,
+				   mte[i].mac[0], mte[i].mac[1], mte[i].mac[2],
+				   mte[i].mac[3], mte[i].mac[4], mte[i].mac[5],
+				   mte[i].vlan_id, mte[i].fwd_type, mte[i].fwd_id);
+	}
+}
+
+#define MAC_TABLE_SIZE (12 * 4096)
+#define MAC_TABLE_TYPE 0
+
+static int hinic_dbg_get_mac_table(struct hinic_dev *nic_dev,
+				   const char *cmd_buf)
+{
+	struct hinic_cmd_dfx_sm_table sml_table_info = {0};
+	u16 out_size = sizeof(sml_table_info);
+	const u32 mac_table_size = 12;
+	u32 table_count = 0;
+	u32 temp_offset;
+	u8 *sml_table;
+	u32 max_cnt;
+	int err;
+
+	sml_table = kzalloc(MAC_TABLE_SIZE, GFP_KERNEL);
+	if (!sml_table)
+		return -ENOMEM;
+
+	do {
+		sml_table_info.tbl_type = MAC_TABLE_TYPE;
+		sml_table_info.args.mac_table_arg.cnt = 64;
+		sml_table_info.args.mac_table_arg.tbl_index = table_count;
+
+		err = hinic_port_msg_cmd(nic_dev->hwdev,
+					 HINIC_PORT_CMD_GET_SML_TABLE,
+					 &sml_table_info,
+					 sizeof(sml_table_info),
+					 &sml_table_info, &out_size);
+		if (err || out_size != sizeof(sml_table_info) ||
+		    sml_table_info.status) {
+			dev_err(&nic_dev->hwdev->hwif->pdev->dev,
+				"Failed to get mac table, err: %d, status: 0x%x, out size: 0x%x\n",
+				err, sml_table_info.status, out_size);
+			kfree(sml_table);
+			return -EIO;
+		}
+
+		temp_offset = sml_table_info.args.mac_table_arg.cnt;
+
+		memcpy(sml_table + (u32)(table_count * mac_table_size),
+		       sml_table_info.tbl_buf,
+		       (u32)(temp_offset * mac_table_size));
+
+		table_count += sml_table_info.args.mac_table_arg.cnt;
+
+		memset(sml_table_info.tbl_buf, 0, DFX_SM_TBL_BUF_MAX);
+
+		max_cnt = sml_table_info.args.mac_table_arg.total_cnt;
+	} while (table_count < max_cnt);
+
+	show_mac_table(nic_dev, sml_table, table_count);
+
+	kfree(sml_table);
+
+	return 0;
+}
+
+static int liner_tbl_get_position_by_type(enum hinic_table_type type, u8 *node,
+					  u8 *instance, u8 *entry_size)
+{
+	switch (type) {
+	case HINIC_GLOBAL_TABLE:
+		*node = TBL_ID_GLOBAL_SM_NODE;
+		*instance = TBL_ID_GLOBAL_SM_INST;
+		*entry_size = HINIC_GLOBAL_TABLE_SIZE;
+		break;
+	case HINIC_FUNCTION_CONFIGURE_TABLE:
+		*node = TBL_ID_FUNC_CFG_SM_NODE;
+		*instance = TBL_ID_FUNC_CFG_SM_INST;
+		*entry_size = HINIC_FUNCTION_CONFIGURE_TABLE_SIZE;
+		break;
+	case HINIC_PORT_CONFIGURE_TABLE:
+		*node = TBL_ID_PORT_CFG_SM_NODE;
+		*instance = TBL_ID_PORT_CFG_SM_INST;
+		*entry_size = HINIC_PORT_CONFIGURE_TABLE_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void print_global_table(struct hinic_dev *nic_dev, u8 entry_size, u8 *data)
+{
+	struct tag_sml_global_table *global_table_elem = (struct tag_sml_global_table *)data;
+	u32 i;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: port_mode           =   %u\n",
+		   global_table_elem->dw0.bs.port_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: dual_plane_en       =   %u\n",
+		   global_table_elem->dw0.bs.dual_plane_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: four_route_en       =   %u\n",
+		   global_table_elem->dw0.bs.four_route_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: hot_update_flag     =   %u\n",
+		   global_table_elem->dw0.bs.hot_update_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: un_mc_mode          =   %u\n",
+		   global_table_elem->dw0.bs.un_mc_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: mac_learn_en        =   %u\n",
+		   global_table_elem->dw0.bs.mac_learn_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: qcn_en              =   %u\n",
+		   global_table_elem->dw0.bs.qcn_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: esl_run_flag        =   %u\n",
+		   global_table_elem->dw0.bs.esl_run_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: special_pro_to_up_flag =   %u\n",
+		   global_table_elem->dw0.bs.special_pro_to_up_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: vf_mask             =   %u\n",
+		   global_table_elem->dw0.bs.vf_mask);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: dif_ser_type        =   %u\n",
+		   global_table_elem->dw0.bs.dif_ser_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: roce_dif            =   %u\n",
+		   global_table_elem->dw0.bs.roce_dif);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: board_num           =   %u\n",
+		   global_table_elem->dw0.bs.board_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: lldp_fwd_en           =   %u\n",
+		   global_table_elem->dw0.bs.lldp_fwd_en);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: bc_offset           =   %u\n",
+		   global_table_elem->dw1.bs.bc_offset);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: mc_offset           =   %u\n",
+		   global_table_elem->dw1.bs.mc_offset);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: net_src_type        =   %u\n",
+		   global_table_elem->dw2.bs.net_src_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: xrc_pl_dec          =   %u\n",
+		   global_table_elem->dw2.bs.xrc_pl_dec);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: sq_cqn              =   %u\n",
+		   global_table_elem->dw2.bs.sq_cqn);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: qpc_stg             =   %u\n",
+		   global_table_elem->dw2.bs.qpc_stg);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: qpc_state_err       =   %u\n",
+		   global_table_elem->dw2.bs.qpc_state_err);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: qpc_wb_flag         =   %u\n",
+		   global_table_elem->dw2.bs.qpc_wb_flag);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: drop_cause_id       =   %u\n",
+		   global_table_elem->dw3.bs.drop_cause_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: PktLen              =   %u\n",
+		   global_table_elem->dw3.bs.pkt_len);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_max_oeid        =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_max_oeid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_mode_init_def_fq_tx =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_mode_init_def_fq_tx);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: enable_stf          =   %u\n",
+		   global_table_elem->fq_mode.bs.enable_stf);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_ngsf_mod        =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_ngsf_mod);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: enable_pro          =   %u\n",
+		   global_table_elem->fq_mode.bs.enable_pro);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: enable_asc          =   %u\n",
+		   global_table_elem->fq_mode.bs.enable_asc);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_psh_msg_en      =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_psh_msg_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_base_init_def_fq =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_base_init_def_fq);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_mode_init_def_fq =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_mode_init_def_fq);
+	netif_info(nic_dev, drv, nic_dev->netdev, "global_table: cfg_mode_pn         =   %u\n",
+		   global_table_elem->fq_mode.bs.cfg_mode_pn);
+
+	for (i = 0; i < 4; i++) {
+		netif_info(nic_dev, drv, nic_dev->netdev, "global_table: task_id_min[%u]      =   %u\n",
+			   i, global_table_elem->port_taskid[i].bs.task_id_min);
+		netif_info(nic_dev, drv, nic_dev->netdev, "global_table: task_id_max[%u]      =   %u\n",
+			   i, global_table_elem->port_taskid[i].bs.task_id_max);
+	}
+
+	for (i = 0; i < 4; i++)
+		netif_info(nic_dev, drv, nic_dev->netdev, "global_table: rsvd[%u]             =   %u\n",
+			   i, global_table_elem->rsvd2[i]);
+}
+
+static void print_funcfg_table(struct hinic_dev *nic_dev, u8 entry_size, u8 *data)
+{
+	struct tag_sml_funcfg_tbl *funcfg_table_elem = (struct tag_sml_funcfg_tbl *)data;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: valid               =   %u\n",
+		   funcfg_table_elem->dw0.bs.valid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: netq_en             =   %u\n",
+		   funcfg_table_elem->dw0.bs.netq_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lli_en              =   %u\n",
+		   funcfg_table_elem->dw0.bs.lli_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rss_en              =   %u\n",
+		   funcfg_table_elem->dw0.bs.rss_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rxvlan_offload_en   =   %u\n",
+		   funcfg_table_elem->dw0.bs.rxvlan_offload_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: tso_local_coalesce  =   %u\n",
+		   funcfg_table_elem->dw0.bs.tso_local_coalesce);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: qos_rx_car_en       =   %u\n",
+		   funcfg_table_elem->dw0.bs.qos_rx_car_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: mac_filter_en       =   %u\n",
+		   funcfg_table_elem->dw0.bs.mac_filter_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: ipmac_filter_en     =   %u\n",
+		   funcfg_table_elem->dw0.bs.ipmac_filter_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: ethtype_filter_en   =   %u\n",
+		   funcfg_table_elem->dw0.bs.ethtype_filter_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: mc_bc_limit_en      =   %u\n",
+		   funcfg_table_elem->dw0.bs.mc_bc_limit_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: acl_tx_en           =   %u\n",
+		   funcfg_table_elem->dw0.bs.acl_tx_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: acl_rx_en           =   %u\n",
+		   funcfg_table_elem->dw0.bs.acl_rx_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: ucapture_en         =   %u\n",
+		   funcfg_table_elem->dw0.bs.ucapture_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: nic_spoofchk_en     =   %u\n",
+		   funcfg_table_elem->dw0.bs.nic_spoofchk_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: tso_en              =   %u\n",
+		   funcfg_table_elem->dw0.bs.tso_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: nic_rx_mode         =   %u\n",
+		   funcfg_table_elem->dw0.bs.nic_rx_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: pcie_bme            =   %u\n",
+		   funcfg_table_elem->dw0.bs.pcie_bme);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: def_pri             =   %u\n",
+		   funcfg_table_elem->dw0.bs.def_pri);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: host_id             =   %u\n",
+		   funcfg_table_elem->dw0.bs.host_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: mtu                 =   %u\n",
+		   funcfg_table_elem->dw1.bs.mtu);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fast_recycled_mode  =   %u\n",
+		   funcfg_table_elem->dw1.bs.fast_recycled_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vlan_mode           =   %u\n",
+		   funcfg_table_elem->dw1.bs.vlan_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vlan_id             =   %u\n",
+		   funcfg_table_elem->dw1.bs.vlan_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lli_mode            =   %u\n",
+		   funcfg_table_elem->dw2.bs.lli_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_fwd_trunk_type   =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_fwd_trunk_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_fwd_trunk_mode   =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_fwd_trunk_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_mode             =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_id               =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_fwd_type         =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_fwd_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: er_fwd_id           =   %u\n",
+		   funcfg_table_elem->dw2.bs.er_fwd_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: pfc_en              =   %u\n",
+		   funcfg_table_elem->dw3.bs.pfc_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fast_local_tso_en   =   %u\n",
+		   funcfg_table_elem->dw3.bs.fast_local_tso_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: roce_valid          =   %u\n",
+		   funcfg_table_elem->dw3.bs.roce_valid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: roce_en             =   %u\n",
+		   funcfg_table_elem->dw3.bs.roce_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: iwarp_en            =   %u\n",
+		   funcfg_table_elem->dw3.bs.iwarp_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fcoe_en             =   %u\n",
+		   funcfg_table_elem->dw3.bs.fcoe_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: toe_en              =   %u\n",
+		   funcfg_table_elem->dw3.bs.toe_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vm_id               =   %u\n",
+		   funcfg_table_elem->dw3.bs.vm_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: ethtype_group_id    =   %u\n",
+		   funcfg_table_elem->dw3.bs.ethtype_group_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: unicast_mac_num     =   %u\n",
+		   funcfg_table_elem->dw4.bs.unicast_mac_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vni                 =   %u\n",
+		   funcfg_table_elem->dw4.bs.vni);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rss_node_id         =   %u\n",
+		   funcfg_table_elem->dw5.bs.rss_node_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rss_group_id        =   %u\n",
+		   funcfg_table_elem->dw5.bs.rss_group_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rss_instance_id     =   %u\n",
+		   funcfg_table_elem->dw5.bs.rss_instance_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: flow_table_aging_time =   %u\n",
+		   funcfg_table_elem->dw5.bs.flow_table_aging_time);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vxlan_check_upcall  =   0x%x\n",
+		   funcfg_table_elem->dw6.bs.vxlan_check_upcall);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rq_thd              =   %u\n",
+		   funcfg_table_elem->dw6.bs.rq_thd);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fm_period_enable    =   %u\n",
+		   funcfg_table_elem->dw6.bs.fm_period_enable);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fm_threshold_enable =   %u\n",
+		   funcfg_table_elem->dw6.bs.fm_threshold_enable);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fm_rule_enable      =   %u\n",
+		   funcfg_table_elem->dw6.bs.fm_rule_enable);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fic_uc_car_id       =   %u\n",
+		   funcfg_table_elem->dw7.fic_bs.fic_uc_car_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fic_mc_car_id       =   %u\n",
+		   funcfg_table_elem->dw7.fic_bs.fic_mc_car_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_en_bitmap       =   0x%x\n",
+		   funcfg_table_elem->dw7.lro_bs.lro_en_bitmap);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_change_bitmap   =   0x%x\n",
+		   funcfg_table_elem->dw7.lro_bs.lro_change_bitmap);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fdir_enable         =   %u\n",
+		   funcfg_table_elem->dw8.bs.fdir_enable);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fdir_io_type        =   %u\n",
+		   funcfg_table_elem->dw8.bs.fdir_io_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fdir_tcam_enable    =   %u\n",
+		   funcfg_table_elem->dw8.bs.fdir_tcam_enable);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: resvd               =   %u\n",
+		   funcfg_table_elem->dw8.bs.resvd);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: drop_en             =   %u\n",
+		   funcfg_table_elem->dw8.bs.drop_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rq_pri_en           =   %u\n",
+		   funcfg_table_elem->dw8.bs.rq_pri_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_queue_en        =   %u\n",
+		   funcfg_table_elem->dw8.bs.lro_queue_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rq_pri_num          =   %u\n",
+		   funcfg_table_elem->dw8.bs.rq_pri_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: rx_wqe_buffer_size  =   %u\n",
+		   funcfg_table_elem->dw8.bs.rx_wqe_buffer_size);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_ipv4_en         =   %u\n",
+		   funcfg_table_elem->dw9.bs.lro_ipv4_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_ipv6_en         =   %u\n",
+		   funcfg_table_elem->dw9.bs.lro_ipv6_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_max_wqe_num     =   %u\n",
+		   funcfg_table_elem->dw9.bs.lro_max_wqe_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vlan_pri_map_group  =   0x%06x\n",
+		   funcfg_table_elem->dw9.bs.vlan_pri_map_group);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lli_frame_size      =   %u\n",
+		   funcfg_table_elem->dw10.bs.lli_frame_size);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: smac_h16            =   0x%04x\n",
+		   funcfg_table_elem->dw10.bs.smac_h16);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vlan_filter_en      =   0x%04x\n",
+		   funcfg_table_elem->dw10.bs.vlan_filter_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: trunk_port_en       =   %u\n",
+		   funcfg_table_elem->dw10.bs.trunk_port_en);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: smac_l32            =   0x%08x\n",
+		   funcfg_table_elem->smac_l32);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: oqid                =   %u\n",
+		   funcfg_table_elem->dw12.bs.oqid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vf_map_pf_id        =   %u\n",
+		   funcfg_table_elem->dw12.bs.vf_map_pf_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: lro_change_flag     =   %u\n",
+		   funcfg_table_elem->dw12.bs.lro_change_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: pf_rx_limit_en   =   0x%04x\n",
+		   funcfg_table_elem->dw12.bs.pf_rx_limit_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: base_qid            =   %u\n",
+		   funcfg_table_elem->dw12.bs.base_qid);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: vhd_type            =   %u\n",
+		   funcfg_table_elem->dw13.bs.vhd_type);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: cfg_rq_depth        =   %u\n",
+		   funcfg_table_elem->dw13.bs.cfg_rq_depth);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: cfg_q_num           =   %u\n",
+		   funcfg_table_elem->dw13.bs.cfg_q_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: dirty_set_en        =   %u\n",
+		   funcfg_table_elem->dw13.bs.ovs_dirty_set_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: is_load_driver      =   %u\n",
+		   funcfg_table_elem->dw13.bs.is_load_driver);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fm_enable           =   %u\n",
+		   funcfg_table_elem->dw13.bs.fm_enable);
+	netif_info(nic_dev, drv, nic_dev->netdev, "funcfg_table: fm_period           =   %u\n",
+		   funcfg_table_elem->dw13.bs.fm_period);
+}
+
+static void print_portcfg_table(struct hinic_dev *nic_dev, u8 entry_size, u8 *data)
+{
+	struct tag_sml_portcfg_tbl *portcfg_table_elem = (struct tag_sml_portcfg_tbl *)data;
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: valid                  =   %u\n",
+		   portcfg_table_elem->dw0.bs.valid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: learn_en               =   %u\n",
+		   portcfg_table_elem->dw0.bs.learn_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_bond_en            =   %u\n",
+		   portcfg_table_elem->dw0.bs.ovs_bond_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: bc_sups_en             =   %u\n",
+		   portcfg_table_elem->dw0.bs.bc_sups_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: un_mc_sups_en          =   %u\n",
+		   portcfg_table_elem->dw0.bs.un_mc_sups_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: un_uc_sups_en          =   %u\n",
+		   portcfg_table_elem->dw0.bs.un_uc_sups_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: net_upcall_limit_flag  =   %u\n",
+		   portcfg_table_elem->dw0.bs.net_upcall_limit_flag);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: sdi_share_net_en       =   %u\n",
+		   portcfg_table_elem->dw0.bs.sdi_share_net_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_flow_flush_en      =   %u\n",
+		   portcfg_table_elem->dw0.bs.ovs_flow_flush_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: qcn_en                 =   %u\n",
+		   portcfg_table_elem->dw0.bs.qcn_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ucapture_en            =   %u\n",
+		   portcfg_table_elem->dw0.bs.ucapture_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: bc_to_all_function     =   %u\n",
+		   portcfg_table_elem->dw0.bs.bc_to_all_function);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: nic_tx_promisc_skip    =   %u\n",
+		   portcfg_table_elem->dw0.bs.nic_tx_promisc_skip);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: def_pri                =   %u\n",
+		   portcfg_table_elem->dw0.bs.def_pri);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: bond_port_vld          =   %u\n",
+		   portcfg_table_elem->dw0.bs.bond_port_vld);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: nic_car_en             =   %u\n",
+		   portcfg_table_elem->dw0.bs.nic_car_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: er_mode                =   %u\n",
+		   portcfg_table_elem->dw0.bs.er_mode);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: er_id                  =   %u\n",
+		   portcfg_table_elem->dw0.bs.er_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: bond_id                =   %u\n",
+		   portcfg_table_elem->dw0.bs.bond_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: rsvd                   =   %u\n",
+		   portcfg_table_elem->dw1.bs.rsvd0);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: qpc_pf_num             =   %u\n",
+		   portcfg_table_elem->dw1.bs.qpc_pf_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_etp_en             =   %u\n",
+		   portcfg_table_elem->dw1.bs.ovs_etp_en);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_capture_en         =   %u\n",
+		   portcfg_table_elem->dw1.bs.ovs_capture_en);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: rsvd                   =   %u\n",
+		   portcfg_table_elem->dw2.bs.rsvd);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_base_pf            =   %u\n",
+		   portcfg_table_elem->dw2.bs.ovs_base_pf);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_lacp_upcall_pf_id  =   %u\n",
+		   portcfg_table_elem->dw3.bs.ovs_lacp_upcall_pf_id);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_lacp_upcall_qid    =   %u\n",
+		   portcfg_table_elem->dw3.bs.ovs_lacp_upcall_qid);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: ovs_flow_upcall_q_num  =   %u\n",
+		   portcfg_table_elem->dw3.bs.ovs_upcall_q_num);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: mtu                    =   %u\n",
+		   portcfg_table_elem->dw3.bs.mtu);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: pf_promiscuous_bitmap  =   %u\n",
+		   portcfg_table_elem->dw4.bs.pf_promiscuous_bitmap);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: rsvd                   =   %u\n",
+		   portcfg_table_elem->dw4.bs.rsvd6);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: start_queue            =   %u\n",
+		   portcfg_table_elem->dw5.ovs_mirror_bs.start_queue);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: queue_size             =   %u\n",
+		   portcfg_table_elem->dw5.ovs_mirror_bs.queue_size);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: mirror_func_id         =   %u\n",
+		   portcfg_table_elem->dw5.ovs_mirror_bs.mirror_func_id);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: vlan                   =   %u\n",
+		   portcfg_table_elem->dw6.fcoe_bs.vlan);
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: dmac_h16               =   0x%04x\n",
+		   portcfg_table_elem->dw6.fcoe_bs.dmac_h16);
+
+	netif_info(nic_dev, drv, nic_dev->netdev, "portcfg_table: dmac_l32               =   0x%08x\n",
+		   portcfg_table_elem->dw7.fcoe_bs.dmac_l32);
+}
+
+static void print_lt_elem_type(struct hinic_dev *nic_dev, enum hinic_table_type table_type,
+			       u8 entry_size, u8 *read_data, u32 tbl_idx)
+{
+	switch (table_type) {
+	case HINIC_GLOBAL_TABLE:
+		print_global_table(nic_dev, entry_size, read_data);
+		break;
+	case HINIC_FUNCTION_CONFIGURE_TABLE:
+		print_funcfg_table(nic_dev, entry_size, read_data);
+		break;
+	case HINIC_PORT_CONFIGURE_TABLE:
+		print_portcfg_table(nic_dev, entry_size, read_data);
+		break;
+	default:
+		netif_err(nic_dev, drv, nic_dev->netdev, "No such LT table_type\n");
+		break;
+	}
+}
+
+static int get_liner_table(struct hinic_dev *nic_dev, enum hinic_table_type sml_table_type,
+			   u32 table_index)
+{
+	struct hinic_cmd_lt_rd *read_data;
+	u16 out_size = sizeof(*read_data);
+	u8 node, instance, entry_size;
+	int err;
+
+	err = liner_tbl_get_position_by_type(sml_table_type, &node, &instance,
+					     &entry_size);
+	if (err) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Get_position_by_tbl_type failed, err: %d\n",
+			  err);
+		return err;
+	}
+
+	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
+	if (!read_data)
+		return -ENOMEM;
+
+	read_data->node = node;
+	read_data->inst = instance;
+	read_data->entry_size = entry_size;
+	read_data->lt_index = table_index;
+	read_data->len = entry_size;
+
+	err = hinic_port_msg_cmd(nic_dev->hwdev, HINIC_PORT_CMD_RD_LINE_TBL,
+				 read_data, sizeof(*read_data),
+				 read_data, &out_size);
+	if (err || out_size != sizeof(*read_data) || read_data->status) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Failed to get liner table %d, err: %d, status: 0x%x, out size: 0x%x\n",
+			   sml_table_type, err, read_data->status, out_size);
+		kfree(read_data);
+		return -EIO;
+	}
+
+	print_lt_elem_type(nic_dev, sml_table_type, entry_size,
+			   read_data->data, table_index);
+
+	kfree(read_data);
+
+	return 0;
+}
+
+static int hinic_dbg_get_global_table(struct hinic_dev *nic_dev,
+				      const char *cmd_buf)
+{
+	u16 func_id = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+
+	return get_liner_table(nic_dev, HINIC_GLOBAL_TABLE, func_id);
+}
+
+static int hinic_dbg_get_function_table(struct hinic_dev *nic_dev,
+					const char *cmd_buf)
+{
+	u16 func_id = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+
+	return get_liner_table(nic_dev, HINIC_FUNCTION_CONFIGURE_TABLE,
+			       func_id);
+}
+
+static int hinic_dbg_get_port_table(struct hinic_dev *nic_dev,
+				    const char *cmd_buf)
+{
+	u16 func_id = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+
+	return get_liner_table(nic_dev, HINIC_PORT_CONFIGURE_TABLE, func_id);
+}
+
+static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer,
+				  size_t count, loff_t *ppos)
+{
+	int len, ret;
+	char *buf;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count < HINIC_DBG_READ_LEN)
+		return -ENOSPC;
+
+	buf = kzalloc(HINIC_DBG_READ_LEN, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len = scnprintf(buf, HINIC_DBG_READ_LEN, "%s\n",
+			"Please echo help to dbg_cmd file to get help information");
+	ret = copy_to_user(buffer, buf, len);
+
+	kfree(buf);
+
+	if (ret)
+		return -EFAULT;
+
+	return (*ppos = len);
+}
+
+static int hinic_dbg_help(struct hinic_dev *nic_dev, const char *cmd_buf)
+{
+	netif_info(nic_dev, drv, nic_dev->netdev, "Available commands:\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "sq info <queue id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "sq wqe info <queue id> <wqe id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "rq info <queue id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "rq wqe info <queue id> <wqe id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "sq ci table <queue id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "rq cqe info <queue id> <cqe id>\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "mac table\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "global table\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "func table\n");
+	netif_info(nic_dev, drv, nic_dev->netdev, "port table\n");
+	return 0;
+}
+
+static const struct hinic_dbg_cmd_info g_hinic_dbg_cmd[] = {
+	{"help", hinic_dbg_help},
+	{"sq info", hinic_dbg_get_sq_info},
+	{"sq wqe info", hinic_dbg_get_sq_wqe_info},
+	{"rq info", hinic_dbg_get_rq_info},
+	{"rq wqe info", hinic_dbg_get_rq_wqe_info},
+	{"sq ci table", hinic_dbg_get_ci_table},
+	{"rq cqe info", hinic_dbg_get_rq_cqe_info},
+	{"mac table", hinic_dbg_get_mac_table},
+	{"global table", hinic_dbg_get_global_table},
+	{"func table", hinic_dbg_get_function_table},
+	{"port table", hinic_dbg_get_port_table},
+};
+
+static ssize_t hinic_dbg_cmd_write(struct file *filp, const char __user *buffer,
+				   size_t count, loff_t *ppos)
+{
+	struct hinic_dev *nic_dev = filp->private_data;
+	char *cmd_buf, *cmd_buf_tmp;
+	int ret = 0;
+	int i;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count > HINIC_DBG_WRITE_LEN)
+		return -ENOSPC;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOMEM;
+
+	ret = copy_from_user(cmd_buf, buffer, count);
+	if (ret) {
+		kfree(cmd_buf);
+		return -EFAULT;
+	}
+
+	cmd_buf[count] = '\0';
+
+	cmd_buf_tmp = strchr(cmd_buf, '\n');
+	if (cmd_buf_tmp) {
+		*cmd_buf_tmp = '\0';
+		count = cmd_buf_tmp - cmd_buf + 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(g_hinic_dbg_cmd); i++) {
+		if (strncmp(cmd_buf, g_hinic_dbg_cmd[i].cmd_name,
+			    strlen(g_hinic_dbg_cmd[i].cmd_name)) == 0) {
+			ret = g_hinic_dbg_cmd[i].dbg_ops(nic_dev, cmd_buf);
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(g_hinic_dbg_cmd)) {
+		netif_err(nic_dev, drv, nic_dev->netdev, "Unsupported debug command\n");
+		hinic_dbg_help(nic_dev, cmd_buf);
+	}
+
+	if (ret)
+		netif_err(nic_dev, drv, nic_dev->netdev, "Failed to excute %s command\n",
+			  cmd_buf);
+
+	kfree(cmd_buf);
+
+	return count;
+}
+
+static const struct file_operations hinic_dbg_cmd_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hinic_dbg_cmd_read,
+	.write = hinic_dbg_cmd_write,
+};
+
+void hinic_dbg_init(struct hinic_dev *nic_dev)
+{
+	const char *name = pci_name(nic_dev->hwdev->hwif->pdev);
+
+	nic_dev->hinic_dbgfs = debugfs_create_dir(name, hinic_dbgfs_root);
+
+	debugfs_create_file("dbg_cmd", 0600, nic_dev->hinic_dbgfs, nic_dev,
+			    &hinic_dbg_cmd_fops);
+}
+
+void hinic_dbg_uninit(struct hinic_dev *nic_dev)
+{
+	debugfs_remove_recursive(nic_dev->hinic_dbgfs);
+	nic_dev->hinic_dbgfs = NULL;
+}
+
+void hinic_dbg_register_debugfs(const char *debugfs_dir_name)
+{
+	hinic_dbgfs_root = debugfs_create_dir(debugfs_dir_name, NULL);
+}
+
+void hinic_dbg_unregister_debugfs(void)
+{
+	debugfs_remove_recursive(hinic_dbgfs_root);
+	hinic_dbgfs_root = NULL;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
new file mode 100644
index 000000000000..a89ff738bf81
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
@@ -0,0 +1,769 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef HINIC_ETHTOOL_H
+#define HINIC_ETHTOOL_H
+
+#include "hinic_dev.h"
+
+#define HINIC_DBG_READ_LEN 256
+#define HINIC_DBG_WRITE_LEN 1024
+
+#define DUMP_WQE_PER_LINE 4U
+
+struct hinic_dbg_cmd_info {
+	char cmd_name[32];
+	int (*dbg_ops)(struct hinic_dev *nic_dev, const char *cmd_buf);
+};
+
+struct hinic_tx_ctrl_section {
+	union {
+		struct {
+			unsigned int buf_desc_sec_len:8;
+			unsigned int drv_sec_len:2;
+			unsigned int rsvd1:4;
+			unsigned int wf:1;
+			unsigned int cf:1;
+			unsigned int task_sec_len:5;
+			unsigned int va:1;
+			unsigned int df:1;
+			unsigned int cr:1;
+			unsigned int dif_sec_len:3;
+			unsigned int completion_sec_len:2;
+			unsigned int ctrl_sec_len:2;
+			unsigned int owner:1;
+		} ctrl_sec;
+		unsigned int ctrl_format;
+	};
+
+	union {
+		struct {
+			unsigned int rsvd2:2;
+			unsigned int payload_offset:8;
+			unsigned int ufo:1;
+			unsigned int tso:1;
+			unsigned int tcp_udp_cs:1;
+			unsigned int mss:14;
+			unsigned int sctp:1;
+			unsigned int uc:1;
+			unsigned int pri:3;
+		} qsf;
+		unsigned int queue_info;
+	};
+};
+
+struct hinic_tx_task_section {
+	union {
+		struct {
+			unsigned int mac_len:8;
+			unsigned int l4_type:2;
+			unsigned int inner_ip_type:2;
+			unsigned int l2tag_flag:1;
+			unsigned int pkt_parse_valid:1;
+			unsigned int rsvd0:1;
+			unsigned int tso:1;
+			unsigned int il2tag:16;
+		} bs0;
+
+		unsigned int dw0;
+	};
+
+	union {
+		struct {
+			unsigned int udp_pseudo_head_cs:16;
+			unsigned int inner_l4_len:8;
+			unsigned int inner_ip_len:8;
+		} bs1;
+		unsigned int dw1;
+	};
+
+	union {
+		struct {
+			unsigned int l4_tunnel_len:8;
+			unsigned int external_ip_len:8;
+			unsigned int l4_tunnel_type:3;
+			unsigned int rsvd2:5;
+			unsigned int external_ip_type:2;
+			unsigned int rsvd1:6;
+		} bs2;
+		unsigned int dw2;
+	};
+
+	union {
+		unsigned int ip_identify;
+		unsigned int dw3;
+	};
+
+	union {
+		struct {
+			unsigned int rsvd4           :31;
+			unsigned int pkt_type        :1;     /* 0:ETH, 1:FC */
+		} bs4;
+		unsigned int dw4;
+	};
+
+	unsigned int rsvd5;
+};
+
+struct hinic_tx_sge {
+	unsigned int dma_addr_high;
+	unsigned int dma_addr_low;
+
+	union {
+		struct {
+			unsigned int length:31;  /* SGE length */
+			unsigned int rsvd:1;
+		} bs2;
+		unsigned int dw2;
+	};
+
+	union {
+		struct {
+			unsigned int key:30; /* key or unused */
+			unsigned int extension:1; /* 0: normal, 1: pointer to next SGE */
+			unsigned int list:1; /* 0: list, 1: last */
+		} bs3;
+		unsigned int dw3;
+	};
+};
+
+struct hinic_wqe_ctrl_sec {
+	union {
+		struct {
+			/* Buffer Descriptors Section Length */
+			u32 buf_desc_sec_len:8;
+			/* Driver Section Length */
+			u32 drv_sec_len:2;
+			/* reserved */
+			u32 rsvd:4;
+			u32 wf:1;
+			/* Completion Format */
+			u32 cf:1;
+			/* Task Section Length */
+			u32 task_sec_len:5;
+			/* Virtual Address */
+			u32 va:1;
+			/* Data Format: format of BDS */
+			u32 df:1;
+			/* Completion is Required: marks CQE generation request per WQE */
+			u32 cr:1;
+			/* DIF Section Length */
+			u32 dif_sec_len:3;
+			/* Completion Section Length */
+			u32 completion_sec_len:2;
+			/* Control Section Length */
+			u32 ctrl_sec_len:2;
+			/* marks ownership of WQE */
+			u32 owner:1;
+		} bs;
+		u32 dw;
+	};
+};
+
+struct hinic_rq_sge_sec {
+	/* packet buffer address high */
+	u32 wb_addr_high;
+	/* packet buffer address low */
+	u32 wb_addr_low;
+
+	union {
+		struct {
+			/* SGE length */
+			u32 length:31;
+			u32 rsvd:1;
+		} bs0;
+		u32 dw0;
+	};
+
+	union {
+		struct {
+			u32 key:30;
+			u32 extension:1;
+			u32 list:1;
+		} bs1;
+		u32 dw1;
+	};
+};
+
+struct hinic_rq_bd_sec {
+	/* packet buffer address high */
+	u32 pkt_buf_addr_high;
+	/* packet buffer address low */
+	u32 pkt_buf_addr_low;
+};
+
+struct hinic_rq_wqe_info {
+	struct hinic_wqe_ctrl_sec rq_wqe_ctrl_sec;
+	u32 rsvd;
+	struct hinic_rq_sge_sec rx_sge;
+	struct hinic_rq_bd_sec pkt_buf_addr;
+};
+
+struct hinic_rq_cqe_info {
+	union {
+		struct {
+			unsigned int checksum_err    :16;
+			unsigned int lro_num         :8;
+			unsigned int rsvd1           :7;
+			unsigned int rx_done         :1;
+		} bs;
+		unsigned int value;
+	} dw0;
+
+	union {
+		struct {
+			unsigned int vlan            :16;
+			unsigned int length          :16;
+		} bs;
+		unsigned int value;
+	} dw1;
+
+	union {
+		struct {
+			unsigned int pkt_types       :12;
+			unsigned int rsvd            :4;
+			unsigned int udp_0           :1;
+			unsigned int ipv6_ex_add     :1;
+			unsigned int loopback        :1;
+			unsigned int umbcast         :2;
+			unsigned int vlan_offload_en :1;
+			unsigned int tag_num         :2;
+			unsigned int rss_type        :8;
+		} bs;
+		unsigned int value;
+	} dw2;
+
+	union {
+		struct {
+			unsigned int rss_hash_value;
+		} bs;
+		unsigned int value;
+	} dw3;
+
+	union {
+		struct {
+			unsigned int tx_ts_seq       :16;
+			unsigned int message_1588_offset :8;
+			unsigned int message_1588_type   :4;
+			unsigned int rsvd            :1;
+			unsigned int if_rx_ts        :1;
+			unsigned int if_tx_ts        :1;
+			unsigned int if_1588         :1;
+		} bs;
+		unsigned int value;
+	} dw4;
+
+	union {
+		struct {
+			unsigned int ts;
+		} bs;
+		unsigned int value;
+	} dw5;
+
+	union {
+		struct {
+			unsigned int lro_ts;
+		} bs;
+		unsigned int value;
+	} dw6;
+
+	union {
+		struct {
+			unsigned int rsvd0;
+		} bs;
+		unsigned int value;
+	} dw7;
+};
+
+union sm_tbl_args {
+	struct {
+		u32 tbl_index;
+		u32 cnt;
+		u32 total_cnt;
+	} mac_table_arg;
+
+	struct {
+		u32 er_id;
+		u32 vlan_id;
+	} vlan_elb_table_arg;
+
+	struct {
+		u32 func_id;
+	} vlan_filter_arg;
+
+	struct {
+		u32 mc_id;
+	} mc_elb_arg;
+
+	struct {
+		u32 func_id;
+	} func_tbl_arg;
+
+	struct {
+		u32 port_id;
+	} port_tbl_arg;
+
+	struct {
+		u32 tbl_index;
+		u32 cnt;
+		u32 total_cnt;
+	} fdir_io_table_arg;
+
+	struct {
+		u32 tbl_index;
+		u32 cnt;
+		u32 total_cnt;
+	} rxq_filter_table_arg;
+
+	u32 args[4];
+};
+
+#define DFX_SM_TBL_BUF_MAX 768
+
+struct hinic_cmd_dfx_sm_table {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u32 tbl_type;
+	union sm_tbl_args args;
+	u8 tbl_buf[DFX_SM_TBL_BUF_MAX];
+};
+
+struct mac_table_entry {
+	u32 static_flag:1;
+	u32 valid:1;
+	u32 er_id:4;
+	u32 vlan_id:12;
+	u32 fwd_id:10;
+	u32 fwd_type:4;
+	u8 mac[6];
+	u8 rsvd[2];
+};
+
+#define    TBL_ID_GLOBAL_SM_NODE                        10
+#define    TBL_ID_GLOBAL_SM_INST                        1
+
+#define    TBL_ID_PORT_CFG_SM_NODE                      10
+#define    TBL_ID_PORT_CFG_SM_INST                      2
+
+#define    TBL_ID_FUNC_CFG_SM_NODE                      11
+#define    TBL_ID_FUNC_CFG_SM_INST                      1
+
+#define HINIC_GLOBAL_TABLE_SIZE                         64
+#define HINIC_FUNCTION_CONFIGURE_TABLE_SIZE             64
+#define HINIC_PORT_CONFIGURE_TABLE_SIZE                 32
+
+enum hinic_table_type {
+	HINIC_GLOBAL_TABLE,
+	HINIC_FUNCTION_CONFIGURE_TABLE,
+	HINIC_PORT_CONFIGURE_TABLE,
+	HINIC_MAC_TABLE,
+};
+
+struct hinic_cmd_lt_rd {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	unsigned char node;
+	unsigned char inst;
+	unsigned char entry_size;
+	unsigned char rsvd;
+	unsigned int lt_index;
+	unsigned int offset;
+	unsigned int len;
+	unsigned char data[100];
+};
+
+struct tag_sml_global_table {
+	union {
+		struct {
+			u32 lldp_fwd_en:8;
+			u32 board_num:8;
+			u32 roce_dif:1;
+			u32 dif_ser_type:2;
+			u32 vf_mask:4;
+			u32 special_pro_to_up_flag:1;
+			u32 esl_run_flag:1;
+			u32 qcn_en:1;
+			u32 mac_learn_en:1;
+			u32 un_mc_mode:1;
+			u32 hot_update_flag:1;
+			u32 four_route_en:1;
+			u32 dual_plane_en:1;
+			u32 port_mode:1;
+		} bs;
+		u32 value;
+	} dw0;
+
+	union {
+		struct {
+		u32 mc_offset:16;
+		u32 bc_offset:16;
+		} bs;
+		u32 value;
+	} dw1;
+
+	union {
+		struct {
+			u32 qpc_wb_flag     :1;
+			u32 qpc_state_err   :1;
+			u32 qpc_stg         :1;
+			u32 sq_cqn          :20;
+			u32 xrc_pl_dec      :1;
+			u32 net_src_type    :8;  /* eth-FWD_PORT, fic-FWD_FIC */
+		} bs;
+		u32 value;
+	} dw2;
+
+	union {
+		struct {
+			u32 pkt_len         :16;
+			u32 drop_cause_id   :16;
+		} bs;
+		u32 value;
+	} dw3;
+
+	u8 fcoe_vf_table[12];
+
+	union {
+		struct {
+			u32 cfg_mode_pn             :2;
+			u32 cfg_mode_init_def_fq    :2;
+			u32 cfg_base_init_def_fq    :12;
+			u32 cfg_psh_msg_en          :1;
+			u32 enable_asc              :1;
+			u32 enable_pro              :1;
+			u32 cfg_ngsf_mod            :1;
+			u32 enable_stf              :1;
+			u32 cfg_mode_init_def_fq_tx :2;
+			u32 cfg_max_oeid            :9;
+		} bs;
+		u32 value;
+	} fq_mode;
+
+	union {
+		struct {
+			u32 task_id_min :16;
+			u32 task_id_max :16;
+		} bs;
+		u32 value;
+	} port_taskid[4];
+
+	u32 rsvd2[4];
+
+};
+
+struct tag_sml_funcfg_tbl {
+	union {
+		struct {
+			u32 host_id             :2;
+			u32 def_pri             :3;
+			u32 ovs_vsmall_en       :1;
+			u32 rsvd                :1;
+			u32 pcie_bme            :1;
+			u32 nic_rx_mode         :5;
+			u32 tso_en              :1;
+			u32 nic_spoofchk_en     :1;
+			u32 ucapture_en         :1;
+			u32 ovs_func_en         :1;
+			u32 acl_rx_en           :1;
+			u32 acl_tx_en           :1;
+			u32 mc_bc_limit_en      :1;
+			u32 ethtype_filter_en   :1;
+			u32 ipmac_filter_en     :1;
+			u32 mac_filter_en       :1;
+			u32 qos_rx_car_en       :1;
+			u32 ovs_upcall_limit_port_en   :1;
+			u32 ovs_upcall_limit_global_en :1;
+			u32 tso_local_coalesce  :1;
+			u32 rxvlan_offload_en   :1;
+			u32 rss_en              :1;
+			u32 lli_en              :1;
+			u32 netq_en             :1;
+			u32 valid               :1;
+		} bs;
+
+		u32 value;
+	} dw0;
+
+	union {
+		struct {
+			u32 vlan_id             :12;
+			u32 vlan_mode           :3;
+			u32 fast_recycled_mode  :1;
+			u32 mtu                 :16;
+		} bs;
+
+		u32 value;
+	} dw1;
+
+	union {
+		struct {
+			u32 er_fwd_id           :16;
+			u32 er_fwd_type         :4;
+			u32 er_id               :4;
+			u32 er_mode             :2;
+			u32 er_fwd_trunk_mode   :4;
+			u32 er_fwd_trunk_type   :1;
+			u32 lli_mode            :1;
+		} bs;
+
+		u32 value;
+	} dw2;
+
+	union {
+		struct {
+			u32 ethtype_group_id    :8;
+			u32 vm_id               :8;
+			u32 toe_en              :1;
+			u32 fcoe_en             :1;
+			u32 iwarp_en            :1;
+			u32 roce_en             :1;
+			u32 roce_valid          :1;
+			u32 ovs_flow_flush_en   :1;
+			u32 ovs_vm_rx_pps_en    :1;
+			u32 ovs_vm_rx_bw_en     :1;
+			u32 ovs_capture_en      :1;
+			u32 ovs_etp_en          :1;
+			u32 ovs_vm_tx_pps_en    :1;
+			u32 ovs_vm_tx_bw_en     :1;
+			u32 ovs_bond_capture_en :1;
+			u32 ovs_bond_etp_en     :1;
+			u32 fast_local_tso_en   :1;
+			u32 pfc_en              :1;
+		} bs;
+
+		u32 value;
+	} dw3;
+
+	union {
+		struct {
+		u32 vni                 :24;
+		u32 unicast_mac_num     :8;
+		} bs;
+
+		u32 value;
+	} dw4;
+
+	union {
+		struct {
+		u32 rss_node_id           : 5;
+		u32 rss_group_id          : 7;
+		u32 rss_instance_id       : 4;
+		u32 flow_table_aging_time : 16;
+		} bs;
+
+		u32 value;
+	} dw5;
+
+	union {
+		struct {
+			u32 rsvd                :6;
+			u32 fm_period_enable    :1;
+			u32 fm_threshold_enable :1;
+			u32 fm_rule_enable      :1;
+			u32 rq_thd              :13;
+			u32 vxlan_check_upcall  :1;
+			u32 action_check        :1;
+			u32 forward_mode        :8;
+		} bs;
+
+		u32 value;
+	} dw6;
+
+	union {
+		struct {
+			u32 fic_mc_car_id       :11;
+			u32 rsvd2               :5;
+			u32 fic_uc_car_id       :11;
+			u32 rsvd1               :5;
+		} fic_bs;
+
+		struct {
+			u16 lro_change_bitmap;
+			u16 lro_en_bitmap;
+		} lro_bs;
+
+		u32 value;
+	} dw7;
+
+	union {
+		struct {
+			u32 rx_wqe_buffer_size  :16;
+			u32 rq_pri_num          :2;
+			u32 lro_queue_en        :1;
+			u32 rq_pri_en           :1;
+			u32 drop_en             :1;
+			u32 resvd               :1;
+			u32 fdir_tcam_enable    :1;
+			u32 fdir_io_type        :8;
+			u32 fdir_enable         :1;
+		} bs;
+
+		u32 value;
+	} dw8;
+
+	union {
+		struct {
+			u32 vlan_pri_map_group  :24;
+			u32 lro_max_wqe_num     :6;
+			u32 lro_ipv6_en         :1;
+			u32 lro_ipv4_en         :1;
+		} bs;
+
+		u32 value;
+	} dw9;
+
+	union {
+		struct {
+			u32 smac_h16            :16;
+			u32 lli_frame_size      :12;
+			u32 rsvd                :2;
+			u32 trunk_port_en       :1;
+			u32 vlan_filter_en      :1;
+		} bs;
+
+		u32 value;
+	} dw10;
+
+	u32 smac_l32;
+
+	union {
+		struct {
+			u32 base_qid            :10;
+			u32 pf_rx_limit_en      :1;
+			u32 lro_change_flag     :1;
+			u32 vf_map_pf_id        :4;
+			u32 oqid                :16;
+		} bs;
+
+		u32 value;
+	} dw12;
+
+	union {
+		struct {
+			u32 rsvd                :1;
+			u32 fm_period           :11;
+			u32 fm_enable           :1;
+			u32 is_load_driver      :1;
+			u32 ovs_dirty_set_en    :1;
+			u32 cfg_q_num           :9;
+			u32 cfg_rq_depth        :6;
+			u32 vhd_type            :2;
+		} bs;
+
+		u32 value;
+	} dw13;
+
+	u32 dw14;
+
+	u32 dw15;
+};
+
+struct tag_sml_portcfg_tbl {
+	union {
+		struct {
+			u32 bond_id             :8;
+			u32 er_id               :4;
+			u32 er_mode             :2;
+			u32 nic_car_en          :1;
+			u32 bond_port_vld       :1;
+			u32 def_pri             :3;
+			u32 nic_tx_promisc_skip :1;
+			u32 bc_to_all_function  :1;
+			u32 ucapture_en         :1;
+			u32 qcn_en              :1;
+			u32 ovs_flow_flush_en   :1;
+			u32 sdi_share_net_en    :1;
+			u32 net_upcall_limit_flag :1;
+			u32 un_uc_sups_en       :1;
+			u32 un_mc_sups_en       :1;
+			u32 bc_sups_en          :1;
+			u32 ovs_bond_en         :1;
+			u32 learn_en            :1;
+			u32 valid               :1;
+		} bs;
+		u32 value;
+	} dw0;
+
+	union {
+		struct {
+		u32 rsvd                :24;
+		u32 qpc_pf_num          :5;
+		u32 rsvd0               :1;
+		u32 ovs_etp_en          :1;
+		u32 ovs_capture_en      :1;
+		} bs;
+		u32 value;
+	} dw1;
+
+	union {
+		struct {
+			u32 rsvd                :28;
+			u32 ovs_base_pf         :4;
+		} bs;
+		u32 value;
+	} dw2;
+
+	union {
+		struct {
+			u32 mtu                      :14;
+			u32 rsvd2                    :2;
+			u32 ovs_upcall_q_num         :4;
+			u32 ovs_lacp_upcall_qid      :6;
+			u32 ovs_lacp_upcall_pf_id    :4;
+			u32 rsvd1                    :2;
+		} bs;
+		u32 value;
+	} dw3;
+
+	union {
+		struct {
+			u32 pf_promiscuous_bitmap   :16;
+			u32 rsvd6                   :16;
+		} bs;
+		u32 value;
+	} dw4;
+
+	union {
+		struct {
+			u32 fc_map;
+		} fcoe_bs;
+		struct {
+			u32 mirror_func_id      :16;
+			u32 queue_size          :8;
+			u32 start_queue         :8;
+		} ovs_mirror_bs;
+		u32 value;
+	} dw5;
+
+	union {
+		struct {
+			u16 dmac_h16;
+			u16 vlan;
+		} fcoe_bs;
+		u32 value;
+	} dw6;
+
+	union {
+		struct {
+			u32 dmac_l32;
+		} fcoe_bs;
+		u32 value;
+	} dw7;
+
+};
+
+void hinic_dbg_init(struct hinic_dev *nic_dev);
+
+void hinic_dbg_uninit(struct hinic_dev *nic_dev);
+
+void hinic_dbg_register_debugfs(const char *debugfs_dir_name);
+
+void hinic_dbg_unregister_debugfs(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 0a1e20edf7cf..00d713974a61 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -97,6 +97,8 @@ struct hinic_dev {
 	int				lb_test_rx_idx;
 	int				lb_pkt_len;
 	u8				*lb_test_rx_buf;
+
+	struct dentry			*hinic_dbgfs;
 	struct devlink			*devlink;
 	bool				cable_unplugged;
 	bool				module_unrecognized;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 0c737765d113..b256eb4b4517 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -465,6 +465,7 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev, u16 sq_depth, u16 rq_depth)
 	func_to_io->hwdev = hwdev;
 	func_to_io->sq_depth = sq_depth;
 	func_to_io->rq_depth = rq_depth;
+	func_to_io->global_qpn = base_qpn;
 
 	err = hinic_io_init(func_to_io, hwif, nic_cap->max_qps, num_ceqs,
 			    ceq_msix_entries);
@@ -1175,6 +1176,30 @@ int hinic_hwdev_hw_ci_addr_set(struct hinic_hwdev *hwdev, struct hinic_sq *sq,
 				 NULL, HINIC_MGMT_MSG_SYNC);
 }
 
+int hinic_hwdev_hw_ci_table_get(struct hinic_hwdev *hwdev,
+				struct hinic_cmd_get_hw_ci_tbl *ci_table)
+{
+	u16 out_size = sizeof(*ci_table);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt,
+				HINIC_MOD_COMM,
+				HINIC_COMM_CMD_SQ_HI_CI_GET,
+				ci_table, sizeof(*ci_table), ci_table,
+				&out_size, HINIC_MGMT_MSG_SYNC);
+
+	if (err || ci_table->status || !out_size) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to get ci table, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, ci_table->status, out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * hinic_hwdev_set_msix_state- set msix state
  * @hwdev: the NIC HW device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 701eb81e09a7..9351e2fcecf9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -96,6 +96,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
 
+	HINIC_PORT_CMD_RD_LINE_TBL	= 57,
+
 	HINIC_PORT_CMD_RSS_CFG		= 66,
 
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
@@ -135,6 +137,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_AUTONEG	= 219,
 
+	HINIC_PORT_CMD_GET_SML_TABLE	= 224,
+
 	HINIC_PORT_CMD_GET_STD_SFP_INFO = 240,
 
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
@@ -291,6 +295,24 @@ struct hinic_cmd_hw_ci {
 	u64     ci_addr;
 };
 
+struct hinic_cmd_get_hw_ci_tbl {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_idx;
+	u8	dma_attr_off;
+	u8	pending_limit;
+
+	u8	coalesce_time;
+	u8	int_en;
+	u16	int_offset;
+
+	u32	l2nic_sqn;
+	u32	rsv;
+	u64	ci_addr; /* bit[63:2] is addr's high 62bit, bit[0] is valid flag */
+};
+
 struct hinic_cmd_l2nic_reset {
 	u8	status;
 	u8	version;
@@ -582,6 +604,9 @@ int hinic_hwdev_msix_set(struct hinic_hwdev *hwdev, u16 msix_index,
 int hinic_hwdev_hw_ci_addr_set(struct hinic_hwdev *hwdev, struct hinic_sq *sq,
 			       u8 pending_limit, u8 coalesc_timer);
 
+int hinic_hwdev_hw_ci_table_get(struct hinic_hwdev *hwdev,
+				struct hinic_cmd_get_hw_ci_tbl *ci_table);
+
 void hinic_hwdev_set_msix_state(struct hinic_hwdev *hwdev, u16 msix_index,
 				enum hinic_msix_state flag);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
index ee6d60762d84..52159a90278a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
@@ -59,6 +59,7 @@ struct hinic_nic_cfg {
 struct hinic_func_to_io {
 	struct hinic_hwif       *hwif;
 	struct hinic_hwdev      *hwdev;
+	u16			global_qpn;
 	struct hinic_ceqs       ceqs;
 
 	struct hinic_wqs        wqs;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 5078c0c73863..501b84014065 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -1357,6 +1357,7 @@ static struct vf_cmd_check_handle hw_cmd_support_vf[] = {
 	{HINIC_COMM_CMD_HWCTXT_SET, check_hwctxt},
 	{HINIC_COMM_CMD_HWCTXT_GET, check_hwctxt},
 	{HINIC_COMM_CMD_SQ_HI_CI_SET, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_SQ_HI_CI_GET, hinic_mbox_check_func_id_8B},
 	{HINIC_COMM_CMD_RES_STATE_SET, hinic_mbox_check_func_id_8B},
 	{HINIC_COMM_CMD_IO_RES_CLEAR, hinic_mbox_check_func_id_8B},
 	{HINIC_COMM_CMD_CEQ_CTRL_REG_WR_BY_UP, hinic_mbox_check_func_id_8B},
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index 4ca81cc838db..4fa1b516054e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -72,6 +72,8 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_SQ_HI_CI_SET     = 0x14,
 
+	HINIC_COMM_CMD_SQ_HI_CI_GET	= 0x15,
+
 	HINIC_COMM_CMD_RES_STATE_SET    = 0x24,
 
 	HINIC_COMM_CMD_IO_RES_CLEAR     = 0x29,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 5dc3743f8091..cf9ca360e493 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -901,3 +901,8 @@ void hinic_write_wqe(struct hinic_wq *wq, struct hinic_hw_wqe *wqe,
 		copy_wqe_from_shadow(wq, shadow_addr, num_wqebbs, prod_idx);
 	}
 }
+
+void *hinic_get_wqebb_addr(struct hinic_wq *wq, u16 index)
+{
+	return WQ_PAGE_ADDR(wq, index) + WQE_PAGE_OFF(wq, index);
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
index b06f8c0255de..7eb6ab21893d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
@@ -108,4 +108,6 @@ struct hinic_hw_wqe *hinic_read_wqe_direct(struct hinic_wq *wq, u16 cons_idx);
 void hinic_write_wqe(struct hinic_wq *wq, struct hinic_hw_wqe *wqe,
 		     unsigned int wqe_size);
 
+void *hinic_get_wqebb_addr(struct hinic_wq *wq, u16 index);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 501056fd32ee..42fc7399b04d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 
+#include "hinic_debugfs.h"
 #include "hinic_hw_qp.h"
 #include "hinic_hw_dev.h"
 #include "hinic_devlink.h"
@@ -1266,6 +1267,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_reg_netdev;
 	}
 
+	hinic_dbg_init(nic_dev);
+
 	return 0;
 
 err_reg_netdev:
@@ -1384,6 +1387,8 @@ static void hinic_remove(struct pci_dev *pdev)
 	struct devlink *devlink = nic_dev->devlink;
 	struct hinic_rx_mode_work *rx_mode_work;
 
+	hinic_dbg_uninit(nic_dev);
+
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
 		wait_sriov_cfg_complete(nic_dev);
 		hinic_pci_sriov_disable(pdev);
@@ -1445,4 +1450,17 @@ static struct pci_driver hinic_driver = {
 	.sriov_configure = hinic_pci_sriov_configure,
 };
 
-module_pci_driver(hinic_driver);
+static int __init hinic_module_init(void)
+{
+	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
+	return pci_register_driver(&hinic_driver);
+}
+
+static void __exit hinic_module_exit(void)
+{
+	pci_unregister_driver(&hinic_driver);
+	hinic_dbg_unregister_debugfs();
+}
+
+module_init(hinic_module_init);
+module_exit(hinic_module_exit);
-- 
2.17.1

