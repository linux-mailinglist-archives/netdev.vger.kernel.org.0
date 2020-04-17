Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C721AE376
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgDQRNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729480AbgDQRN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:28 -0400
IronPort-SDR: Co6gCkYcAyKMGGhB4osbRx0MM7Ilaeddxir3axHl4ms8VI1T0jmAHPVwXNJ/3x7DK60FpV34JU
 adgjEngmEt+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:58 -0700
IronPort-SDR: ROUg2ahXXdHAfcSUpKhqV2MtuKEE2BQafkLocmmV1+waO8n80i1IAAguSQgO2ZDNSaOh2Sr4QP
 2xFY6rzTPk+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383743"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility definitions
Date:   Fri, 17 Apr 2020 10:12:47 -0700
Message-Id: <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add miscellaneous utility functions and headers.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/osdep.h  |  105 ++
 drivers/infiniband/hw/irdma/protos.h |   93 +
 drivers/infiniband/hw/irdma/status.h |   69 +
 drivers/infiniband/hw/irdma/utils.c  | 2445 ++++++++++++++++++++++++++
 4 files changed, 2712 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/osdep.h
 create mode 100644 drivers/infiniband/hw/irdma/protos.h
 create mode 100644 drivers/infiniband/hw/irdma/status.h
 create mode 100644 drivers/infiniband/hw/irdma/utils.c

diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
new file mode 100644
index 000000000000..23ddfb8e9568
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/osdep.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_OSDEP_H
+#define IRDMA_OSDEP_H
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <linux/bitops.h>
+#include <linux/pci.h>
+#include <linux/refcount.h>
+#include <net/tcp.h>
+#include <crypto/hash.h>
+/* get readq/writeq support for 32 bit kernels, use the low-first version */
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#define STATS_TIMER_DELAY	60000
+#define rfdev_to_dev(ptr)	(&((ptr)->hw->pdev->dev))
+#define to_ibdev(iwdev)		(&((iwdev)->ibdev))
+#define hw_to_dev(hw)		(&(hw)->pdev->dev)
+#define irdma_debug_buf(dev, prefix, desc, buf, size)	\
+	print_hex_dump_debug(prefix ": " desc " ",	\
+			     DUMP_PREFIX_OFFSET,	\
+			     16, 8, buf, size, false)
+
+struct irdma_dma_info {
+	dma_addr_t *dmaaddrs;
+};
+
+struct irdma_dma_mem {
+	void *va;
+	dma_addr_t pa;
+	u32 size;
+} __packed;
+
+struct irdma_virt_mem {
+	void *va;
+	u32 size;
+} __packed;
+
+struct irdma_sc_vsi;
+struct irdma_sc_dev;
+struct irdma_sc_qp;
+struct irdma_puda_buf;
+struct irdma_puda_cmpl_info;
+struct irdma_update_sds_info;
+struct irdma_hmc_fcn_info;
+struct irdma_virtchnl_work_info;
+struct irdma_manage_vf_pble_info;
+struct irdma_hw;
+struct irdma_pci_f;
+
+u8 __iomem *irdma_get_hw_addr(void *dev);
+void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp);
+enum irdma_status_code irdma_vf_wait_vchnl_resp(struct irdma_sc_dev *dev);
+bool irdma_vf_clear_to_send(struct irdma_sc_dev *dev);
+void irdma_add_dev_ref(struct irdma_sc_dev *dev);
+void irdma_put_dev_ref(struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
+					      void *addr, u32 len, u32 val);
+struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
+				     struct irdma_puda_buf *buf);
+void irdma_send_ieq_ack(struct irdma_sc_qp *qp);
+void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf, u16 len,
+				 u32 seqnum);
+void irdma_free_hash_desc(struct shash_desc *hash_desc);
+enum irdma_status_code irdma_init_hash_desc(struct shash_desc **hash_desc);
+enum irdma_status_code
+irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			  struct irdma_puda_buf *buf);
+enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_update_sds_info *info);
+enum irdma_status_code
+irdma_cqp_manage_hmc_fcn_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_hmc_fcn_info *hmcfcninfo);
+enum irdma_status_code
+irdma_cqp_query_fpm_val_cmd(struct irdma_sc_dev *dev,
+			    struct irdma_dma_mem *val_mem, u8 hmc_fn_id);
+enum irdma_status_code
+irdma_cqp_commit_fpm_val_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_dma_mem *val_mem, u8 hmc_fn_id);
+enum irdma_status_code irdma_alloc_query_fpm_buf(struct irdma_sc_dev *dev,
+						 struct irdma_dma_mem *mem);
+enum irdma_status_code
+irdma_cqp_manage_vf_pble_bp(struct irdma_sc_dev *dev,
+			    struct irdma_manage_vf_pble_info *info);
+void irdma_cqp_spawn_worker(struct irdma_sc_dev *dev,
+			    struct irdma_virtchnl_work_info *work_info,
+			    u32 iw_vf_idx);
+void *irdma_remove_cqp_head(struct irdma_sc_dev *dev);
+void irdma_term_modify_qp(struct irdma_sc_qp *qp, u8 next_state, u8 term,
+			  u8 term_len);
+void irdma_terminate_done(struct irdma_sc_qp *qp, int timeout_occurred);
+void irdma_terminate_start_timer(struct irdma_sc_qp *qp);
+void irdma_terminate_del_timer(struct irdma_sc_qp *qp);
+enum irdma_status_code
+irdma_hw_manage_vf_pble_bp(struct irdma_pci_f *rf,
+			   struct irdma_manage_vf_pble_info *info, bool wait);
+void irdma_hw_stats_start_timer(struct irdma_sc_vsi *vsi);
+void irdma_hw_stats_stop_timer(struct irdma_sc_vsi *vsi);
+void wr32(struct irdma_hw *hw, u32 reg, u32 val);
+u32 rd32(struct irdma_hw *hw, u32 reg);
+u64 rd64(struct irdma_hw *hw, u32 reg);
+#endif /* IRDMA_OSDEP_H */
diff --git a/drivers/infiniband/hw/irdma/protos.h b/drivers/infiniband/hw/irdma/protos.h
new file mode 100644
index 000000000000..b86efb4ecf81
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/protos.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#ifndef IRDMA_PROTOS_H
+#define IRDMA_PROTOS_H
+
+#define PAUSE_TIMER_VAL		0xffff
+#define REFRESH_THRESHOLD	0x7fff
+#define HIGH_THRESHOLD		0x800
+#define LOW_THRESHOLD		0x200
+#define ALL_TC2PFC		0xff
+#define CQP_COMPL_WAIT_TIME_MS	10
+#define CQP_TIMEOUT_THRESHOLD	500
+
+/* init operations */
+enum irdma_status_code irdma_sc_ctrl_init(enum irdma_vers ver,
+					  struct irdma_sc_dev *dev,
+					  struct irdma_device_init_info *info);
+void irdma_sc_rt_init(struct irdma_sc_dev *dev);
+void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp);
+__le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch);
+enum irdma_status_code
+irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
+			  struct irdma_fast_reg_stag_info *info, bool post_sq);
+/* HMC/FPM functions */
+enum irdma_status_code irdma_sc_init_iw_hmc(struct irdma_sc_dev *dev,
+					    u8 hmc_fn_id);
+/* stats misc */
+enum irdma_status_code
+irdma_cqp_gather_stats_cmd(struct irdma_sc_dev *dev,
+			   struct irdma_vsi_pestat *pestat, bool wait);
+enum irdma_status_code
+irdma_cqp_ws_node_cmd(struct irdma_sc_dev *dev, u8 cmd,
+		      struct irdma_ws_node_info *node_info);
+enum irdma_status_code irdma_cqp_up_map_cmd(struct irdma_sc_dev *dev, u8 cmd,
+					    struct irdma_up_info *map_info);
+enum irdma_status_code irdma_cqp_ceq_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_sc_ceq *sc_ceq, u8 op);
+enum irdma_status_code
+irdma_cqp_stats_inst_cmd(struct irdma_sc_vsi *vsi, u8 cmd,
+			 struct irdma_stats_inst_info *stats_info);
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
+void irdma_update_stats(struct irdma_dev_hw_stats *hw_stats,
+			struct irdma_gather_stats *gather_stats,
+			struct irdma_gather_stats *last_gather_stats);
+/* vsi functions */
+enum irdma_status_code irdma_vsi_stats_init(struct irdma_sc_vsi *vsi,
+					    struct irdma_vsi_stats_info *info);
+void irdma_vsi_stats_free(struct irdma_sc_vsi *vsi);
+void irdma_sc_vsi_init(struct irdma_sc_vsi *vsi,
+		       struct irdma_vsi_init_info *info);
+enum irdma_status_code irdma_sc_add_cq_ctx(struct irdma_sc_ceq *ceq,
+					   struct irdma_sc_cq *cq);
+void irdma_sc_remove_cq_ctx(struct irdma_sc_ceq *ceq, struct irdma_sc_cq *cq);
+/* misc L2 param change functions */
+void irdma_change_l2params(struct irdma_sc_vsi *vsi,
+			   struct irdma_l2params *l2params);
+void irdma_sc_suspend_resume_qps(struct irdma_sc_vsi *vsi, u8 suspend);
+enum irdma_status_code irdma_cqp_qp_suspend_resume(struct irdma_sc_qp *qp,
+						   u8 cmd);
+void irdma_qp_add_qos(struct irdma_sc_qp *qp);
+void irdma_qp_rem_qos(struct irdma_sc_qp *qp);
+struct irdma_sc_qp *irdma_get_qp_from_list(struct list_head *head,
+					   struct irdma_sc_qp *qp);
+void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi);
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
+/* terminate functions*/
+void irdma_terminate_send_fin(struct irdma_sc_qp *qp);
+
+void irdma_terminate_connection(struct irdma_sc_qp *qp,
+				struct irdma_aeqe_info *info);
+
+void irdma_terminate_received(struct irdma_sc_qp *qp,
+			      struct irdma_aeqe_info *info);
+/* dynamic memory allocation */
+/* misc */
+u8 irdma_get_encoded_wqe_size(u32 wqsize, bool cqpsq);
+void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp);
+enum irdma_status_code
+irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
+				    u8 hmc_fn_id, bool post_sq,
+				    bool poll_registers);
+enum irdma_status_code irdma_cfg_fpm_val(struct irdma_sc_dev *dev,
+					 u32 qp_count);
+enum irdma_status_code irdma_get_rdma_features(struct irdma_sc_dev *dev);
+void free_sd_mem(struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_process_cqp_cmd(struct irdma_sc_dev *dev,
+					     struct cqp_cmds_info *pcmdinfo);
+enum irdma_status_code irdma_process_bh(struct irdma_sc_dev *dev);
+enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_update_sds_info *info);
+#endif /* IRDMA_PROTOS_H */
diff --git a/drivers/infiniband/hw/irdma/status.h b/drivers/infiniband/hw/irdma/status.h
new file mode 100644
index 000000000000..e894b6b00e89
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/status.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_STATUS_H
+#define IRDMA_STATUS_H
+
+/* Error Codes */
+enum irdma_status_code {
+	IRDMA_SUCCESS				= 0,
+	IRDMA_ERR_NVM				= -1,
+	IRDMA_ERR_NVM_CHECKSUM			= -2,
+	IRDMA_ERR_CFG				= -4,
+	IRDMA_ERR_PARAM				= -5,
+	IRDMA_ERR_DEVICE_NOT_SUPPORTED		= -6,
+	IRDMA_ERR_RESET_FAILED			= -7,
+	IRDMA_ERR_SWFW_SYNC			= -8,
+	IRDMA_ERR_NO_MEMORY			= -9,
+	IRDMA_ERR_BAD_PTR			= -10,
+	IRDMA_ERR_INVALID_PD_ID			= -11,
+	IRDMA_ERR_INVALID_QP_ID			= -12,
+	IRDMA_ERR_INVALID_CQ_ID			= -13,
+	IRDMA_ERR_INVALID_CEQ_ID		= -14,
+	IRDMA_ERR_INVALID_AEQ_ID		= -15,
+	IRDMA_ERR_INVALID_SIZE			= -16,
+	IRDMA_ERR_INVALID_ARP_INDEX		= -17,
+	IRDMA_ERR_INVALID_FPM_FUNC_ID		= -18,
+	IRDMA_ERR_QP_INVALID_MSG_SIZE		= -19,
+	IRDMA_ERR_QP_TOOMANY_WRS_POSTED		= -20,
+	IRDMA_ERR_INVALID_FRAG_COUNT		= -21,
+	IRDMA_ERR_Q_EMPTY			= -22,
+	IRDMA_ERR_INVALID_ALIGNMENT		= -23,
+	IRDMA_ERR_FLUSHED_Q			= -24,
+	IRDMA_ERR_INVALID_PUSH_PAGE_INDEX	= -25,
+	IRDMA_ERR_INVALID_INLINE_DATA_SIZE	= -26,
+	IRDMA_ERR_TIMEOUT			= -27,
+	IRDMA_ERR_OPCODE_MISMATCH		= -28,
+	IRDMA_ERR_CQP_COMPL_ERROR		= -29,
+	IRDMA_ERR_INVALID_VF_ID			= -30,
+	IRDMA_ERR_INVALID_HMCFN_ID		= -31,
+	IRDMA_ERR_BACKING_PAGE_ERROR		= -32,
+	IRDMA_ERR_NO_PBLCHUNKS_AVAILABLE	= -33,
+	IRDMA_ERR_INVALID_PBLE_INDEX		= -34,
+	IRDMA_ERR_INVALID_SD_INDEX		= -35,
+	IRDMA_ERR_INVALID_PAGE_DESC_INDEX	= -36,
+	IRDMA_ERR_INVALID_SD_TYPE		= -37,
+	IRDMA_ERR_MEMCPY_FAILED			= -38,
+	IRDMA_ERR_INVALID_HMC_OBJ_INDEX		= -39,
+	IRDMA_ERR_INVALID_HMC_OBJ_COUNT		= -40,
+	IRDMA_ERR_BUF_TOO_SHORT			= -43,
+	IRDMA_ERR_BAD_IWARP_CQE			= -44,
+	IRDMA_ERR_NVM_BLANK_MODE		= -45,
+	IRDMA_ERR_NOT_IMPL			= -46,
+	IRDMA_ERR_PE_DOORBELL_NOT_ENA		= -47,
+	IRDMA_ERR_NOT_READY			= -48,
+	IRDMA_NOT_SUPPORTED			= -49,
+	IRDMA_ERR_FIRMWARE_API_VER		= -50,
+	IRDMA_ERR_RING_FULL			= -51,
+	IRDMA_ERR_MPA_CRC			= -61,
+	IRDMA_ERR_NO_TXBUFS			= -62,
+	IRDMA_ERR_SEQ_NUM			= -63,
+	IRDMA_ERR_list_empty			= -64,
+	IRDMA_ERR_INVALID_MAC_ADDR		= -65,
+	IRDMA_ERR_BAD_STAG			= -66,
+	IRDMA_ERR_CQ_COMPL_ERROR		= -67,
+	IRDMA_ERR_Q_DESTROYED			= -68,
+	IRDMA_ERR_INVALID_FEAT_CNT		= -69,
+	IRDMA_ERR_REG_CQ_FULL			= -70,
+	IRDMA_ERR_VF_MSG_ERROR			= -71,
+};
+#endif /* IRDMA_STATUS_H */
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
new file mode 100644
index 000000000000..be46d672afc5
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -0,0 +1,2445 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include <linux/mii.h>
+#include <linux/in.h>
+#include <linux/init.h>
+#include <asm/irq.h>
+#include <asm/byteorder.h>
+#include <net/neighbour.h>
+#include "main.h"
+
+/**
+ * irdma_arp_table -manage arp table
+ * @rf: RDMA PCI function
+ * @ip_addr: ip address for device
+ * @ipv4: IPv4 flag
+ * @mac_addr: mac address ptr
+ * @action: modify, delete or add
+ */
+int irdma_arp_table(struct irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
+		    u8 *mac_addr, u32 action)
+{
+	unsigned long flags;
+	int arp_index;
+	u32 ip[4] = {};
+
+	if (ipv4)
+		ip[0] = *ip_addr;
+	else
+		memcpy(ip, ip_addr, sizeof(ip));
+
+	spin_lock_irqsave(&rf->arp_lock, flags);
+	for (arp_index = 0; (u32)arp_index < rf->arp_table_size; arp_index++) {
+		if (!memcmp(rf->arp_table[arp_index].ip_addr, ip, sizeof(ip)))
+			break;
+	}
+
+	switch (action) {
+	case IRDMA_ARP_ADD:
+		if (arp_index != rf->arp_table_size) {
+			arp_index = -1;
+			break;
+		}
+
+		arp_index = 0;
+		if (irdma_alloc_rsrc(rf, rf->allocated_arps, rf->arp_table_size,
+				     (u32 *)&arp_index, &rf->next_arp_index)) {
+			arp_index = -1;
+			break;
+		}
+
+		memcpy(rf->arp_table[arp_index].ip_addr, ip,
+		       sizeof(rf->arp_table[arp_index].ip_addr));
+		ether_addr_copy(rf->arp_table[arp_index].mac_addr, mac_addr);
+		break;
+	case IRDMA_ARP_RESOLVE:
+		if (arp_index == rf->arp_table_size)
+			arp_index = -1;
+		break;
+	case IRDMA_ARP_DELETE:
+		if (arp_index == rf->arp_table_size) {
+			arp_index = -1;
+			break;
+		}
+
+		memset(rf->arp_table[arp_index].ip_addr, 0,
+		       sizeof(rf->arp_table[arp_index].ip_addr));
+		eth_zero_addr(rf->arp_table[arp_index].mac_addr);
+		irdma_free_rsrc(rf, rf->allocated_arps, arp_index);
+		break;
+	default:
+		arp_index = -1;
+		break;
+	}
+
+	spin_unlock_irqrestore(&rf->arp_lock, flags);
+	return arp_index;
+}
+
+/**
+ * irdma_add_arp - add a new arp entry if needed
+ * @rf: RDMA function
+ * @ip: IP address
+ * @ipv4: IPv4 flag
+ * @mac: MAC address
+ */
+int irdma_add_arp(struct irdma_pci_f *rf, u32 *ip, bool ipv4, u8 *mac)
+{
+	int arpidx;
+
+	arpidx = irdma_arp_table(rf, &ip[0], ipv4, NULL, IRDMA_ARP_RESOLVE);
+	if (arpidx >= 0) {
+		if (ether_addr_equal(rf->arp_table[arpidx].mac_addr, mac))
+			return arpidx;
+
+		irdma_manage_arp_cache(rf, rf->arp_table[arpidx].mac_addr, ip,
+				       ipv4, IRDMA_ARP_DELETE);
+	}
+
+	irdma_manage_arp_cache(rf, mac, ip, ipv4, IRDMA_ARP_ADD);
+
+	return irdma_arp_table(rf, ip, ipv4, NULL, IRDMA_ARP_RESOLVE);
+}
+
+/**
+ * wr32 - write 32 bits to hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ * @val: value to write to register
+ */
+inline void wr32(struct irdma_hw *hw, u32 reg, u32 val)
+{
+	writel(val, hw->hw_addr + reg);
+}
+
+/**
+ * rd32 - read a 32 bit hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ *
+ * Return value of register content
+ */
+inline u32 rd32(struct irdma_hw *hw, u32 reg)
+{
+	return readl(hw->hw_addr + reg);
+}
+
+/**
+ * rd64 - read a 64 bit hw register
+ * @hw: hardware information including registers
+ * @reg: register offset
+ *
+ * Return value of register content
+ */
+inline u64 rd64(struct irdma_hw *hw, u32 reg)
+{
+	return readq(hw->hw_addr + reg);
+}
+
+static void irdma_gid_change_event(struct ib_device *ibdev)
+{
+	struct ib_event ib_event;
+
+	ib_event.event = IB_EVENT_GID_CHANGE;
+	ib_event.device = ibdev;
+	ib_event.element.port_num = 1;
+	ib_dispatch_event(&ib_event);
+}
+
+/**
+ * irdma_inetaddr_event - system notifier for ipv4 addr events
+ * @notifier: not used
+ * @event: event for notifier
+ * @ptr: if address
+ */
+int irdma_inetaddr_event(struct notifier_block *notifier, unsigned long event,
+			 void *ptr)
+{
+	struct in_ifaddr *ifa = ptr;
+	struct net_device *netdev = ifa->ifa_dev->dev;
+	struct irdma_device *iwdev;
+	u32 local_ipaddr;
+
+	iwdev = irdma_get_device(netdev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	local_ipaddr = ntohl(ifa->ifa_address);
+	switch (event) {
+	case NETDEV_DOWN:
+		irdma_manage_arp_cache(iwdev->rf, netdev->dev_addr,
+				       &local_ipaddr, true, IRDMA_ARP_DELETE);
+		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, false);
+		irdma_gid_change_event(&iwdev->ibdev);
+		break;
+	case NETDEV_UP:
+		/* Fall through */
+	case NETDEV_CHANGEADDR:
+		irdma_add_arp(iwdev->rf, &local_ipaddr, true, netdev->dev_addr);
+		irdma_if_notify(iwdev, netdev, &local_ipaddr, true, true);
+		irdma_gid_change_event(&iwdev->ibdev);
+		break;
+	default:
+		break;
+	}
+
+	irdma_put_device(iwdev);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_inet6addr_event - system notifier for ipv6 addr events
+ * @notifier: not used
+ * @event: event for notifier
+ * @ptr: if address
+ */
+int irdma_inet6addr_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr)
+{
+	struct inet6_ifaddr *ifa = ptr;
+	struct net_device *netdev = ifa->idev->dev;
+	struct irdma_device *iwdev;
+	u32 local_ipaddr6[4];
+
+	iwdev = irdma_get_device(netdev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	irdma_copy_ip_ntohl(local_ipaddr6, ifa->addr.in6_u.u6_addr32);
+	switch (event) {
+	case NETDEV_DOWN:
+		irdma_manage_arp_cache(iwdev->rf, netdev->dev_addr,
+				       local_ipaddr6, false, IRDMA_ARP_DELETE);
+		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, false);
+		irdma_gid_change_event(&iwdev->ibdev);
+		break;
+	case NETDEV_UP:
+		/* Fall through */
+	case NETDEV_CHANGEADDR:
+		irdma_add_arp(iwdev->rf, local_ipaddr6, false,
+			      netdev->dev_addr);
+		irdma_if_notify(iwdev, netdev, local_ipaddr6, false, true);
+		irdma_gid_change_event(&iwdev->ibdev);
+		break;
+	default:
+		break;
+	}
+
+	irdma_put_device(iwdev);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_net_event - system notifier for net events
+ * @notifier: not used
+ * @event: event for notifier
+ * @ptr: neighbor
+ */
+int irdma_net_event(struct notifier_block *notifier, unsigned long event,
+		    void *ptr)
+{
+	struct neighbour *neigh = ptr;
+	struct irdma_device *iwdev;
+	__be32 *p;
+	u32 local_ipaddr;
+
+	iwdev = irdma_get_device((struct net_device *)neigh->dev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETEVENT_NEIGH_UPDATE:
+		p = (__be32 *)neigh->primary_key;
+		local_ipaddr = ntohl(*p);
+		if (neigh->nud_state & NUD_VALID)
+			irdma_add_arp(iwdev->rf, &local_ipaddr, false,
+				      neigh->ha);
+
+		else
+			irdma_manage_arp_cache(iwdev->rf, neigh->ha,
+					       &local_ipaddr, false,
+					       IRDMA_ARP_DELETE);
+		break;
+	default:
+		break;
+	}
+
+	irdma_put_device(iwdev);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_netdevice_event - system notifier for netdev events
+ * @notifier: not used
+ * @event: event for notifier
+ * @ptr: netdev
+ */
+int irdma_netdevice_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr)
+{
+	struct irdma_device *iwdev;
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+
+	iwdev = irdma_get_device(netdev);
+	if (!iwdev)
+		return NOTIFY_DONE;
+
+	iwdev->iw_status = 1;
+	switch (event) {
+	case NETDEV_DOWN:
+		iwdev->iw_status = 0;
+		/* Fall through */
+	case NETDEV_UP:
+		irdma_port_ibevent(iwdev);
+		break;
+	default:
+		break;
+	}
+	irdma_put_device(iwdev);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * irdma_get_cqp_request - get cqp struct
+ * @cqp: device cqp ptr
+ * @wait: cqp to be used in wait mode
+ */
+struct irdma_cqp_request *irdma_get_cqp_request(struct irdma_cqp *cqp,
+						bool wait)
+{
+	struct irdma_cqp_request *cqp_request = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cqp->req_lock, flags);
+	if (!list_empty(&cqp->cqp_avail_reqs)) {
+		cqp_request = list_entry(cqp->cqp_avail_reqs.next,
+					 struct irdma_cqp_request, list);
+		list_del_init(&cqp_request->list);
+	}
+	spin_unlock_irqrestore(&cqp->req_lock, flags);
+	if (!cqp_request) {
+		cqp_request = kzalloc(sizeof(*cqp_request), GFP_ATOMIC);
+		if (cqp_request) {
+			cqp_request->dynamic = true;
+			if (wait)
+				init_waitqueue_head(&cqp_request->waitq);
+		}
+	}
+	if (!cqp_request) {
+		dev_dbg(rfdev_to_dev(cqp->sc_cqp.dev),
+			"ERR: CQP Request Fail: No Memory");
+		return NULL;
+	}
+
+	if (wait) {
+		refcount_set(&cqp_request->refcnt, 2);
+		cqp_request->waiting = true;
+	} else {
+		refcount_set(&cqp_request->refcnt, 1);
+	}
+	memset(&cqp_request->compl_info, 0, sizeof(cqp_request->compl_info));
+
+	return cqp_request;
+}
+
+/**
+ * irdma_free_cqp_request - free cqp request
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+void irdma_free_cqp_request(struct irdma_cqp *cqp,
+			    struct irdma_cqp_request *cqp_request)
+{
+	unsigned long flags;
+
+	if (cqp_request->dynamic) {
+		kfree(cqp_request);
+	} else {
+		cqp_request->request_done = false;
+		cqp_request->callback_fcn = NULL;
+		cqp_request->waiting = false;
+
+		spin_lock_irqsave(&cqp->req_lock, flags);
+		list_add_tail(&cqp_request->list, &cqp->cqp_avail_reqs);
+		spin_unlock_irqrestore(&cqp->req_lock, flags);
+	}
+	wake_up(&cqp->remove_wq);
+}
+
+/**
+ * irdma_put_cqp_request - dec ref count and free if 0
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+void irdma_put_cqp_request(struct irdma_cqp *cqp,
+			   struct irdma_cqp_request *cqp_request)
+{
+	if (refcount_dec_and_test(&cqp_request->refcnt))
+		irdma_free_cqp_request(cqp, cqp_request);
+}
+
+/**
+ * irdma_free_pending_cqp_request -free pending cqp request objs
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+static void
+irdma_free_pending_cqp_request(struct irdma_cqp *cqp,
+			       struct irdma_cqp_request *cqp_request)
+{
+	if (cqp_request->waiting) {
+		cqp_request->compl_info.error = true;
+		cqp_request->request_done = true;
+		wake_up(&cqp_request->waitq);
+	}
+	wait_event_timeout(cqp->remove_wq,
+			   refcount_read(&cqp_request->refcnt) == 1, 1000);
+	irdma_put_cqp_request(cqp, cqp_request);
+}
+
+/**
+ * irdma_cleanup_pending_cqp_op - clean-up cqp with no
+ * completions
+ * @rf: RDMA PCI function
+ */
+void irdma_cleanup_pending_cqp_op(struct irdma_pci_f *rf)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	struct irdma_cqp *cqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request = NULL;
+	struct cqp_cmds_info *pcmdinfo = NULL;
+	u32 i, pending_work, wqe_idx;
+
+	pending_work = IRDMA_RING_USED_QUANTA(cqp->sc_cqp.sq_ring);
+	wqe_idx = IRDMA_RING_CURRENT_TAIL(cqp->sc_cqp.sq_ring);
+	for (i = 0; i < pending_work; i++) {
+		cqp_request = (struct irdma_cqp_request *)(unsigned long)
+				      cqp->scratch_array[wqe_idx];
+		if (cqp_request)
+			irdma_free_pending_cqp_request(cqp, cqp_request);
+		wqe_idx = (wqe_idx + 1) % IRDMA_RING_SIZE(cqp->sc_cqp.sq_ring);
+	}
+
+	while (!list_empty(&dev->cqp_cmd_head)) {
+		pcmdinfo = irdma_remove_cqp_head(dev);
+		cqp_request =
+			container_of(pcmdinfo, struct irdma_cqp_request, info);
+		if (cqp_request)
+			irdma_free_pending_cqp_request(cqp, cqp_request);
+	}
+}
+
+/**
+ * irdma_free_qp_worker - worker for freeing QP resources
+ * @work: ptr to work struct
+ */
+static void irdma_free_qp_worker(struct work_struct *work)
+{
+	struct irdma_qp *iwqp = container_of(work, struct irdma_qp, work);
+
+	irdma_free_qp_rsrc(iwqp->iwdev, iwqp, iwqp->ibqp.qp_num);
+}
+
+/**
+ * irdma_free_qp - callback after destroy cqp completes
+ * @cqp_request: cqp request for destroy qp
+ */
+static void irdma_free_qp(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_sc_qp *qp = cqp_request->param;
+	struct irdma_qp *iwqp = qp->qp_uk.back_qp;
+	struct irdma_device *iwdev = iwqp->iwdev;
+
+	queue_work(iwdev->cleanup_wq, &iwqp->work);
+}
+
+/**
+ * irdma_wait_event - wait for completion
+ * @rf: RDMA PCI function
+ * @cqp_request: cqp request to wait
+ */
+static int irdma_wait_event(struct irdma_pci_f *rf,
+			    struct irdma_cqp_request *cqp_request)
+{
+	struct cqp_cmds_info *info = &cqp_request->info;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_timeout cqp_timeout = {};
+	bool cqp_error = false;
+	int err_code = 0;
+
+	cqp_timeout.compl_cqp_cmds =
+		rf->sc_dev.cqp_cmd_stats[IRDMA_OP_CMPL_CMDS];
+	do {
+		queue_work(rf->cqp_cmpl_wq, &rf->cqp_cmpl_work);
+		if (wait_event_timeout(cqp_request->waitq,
+				       cqp_request->request_done,
+				       msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
+			break;
+
+		rf->sc_dev.cqp_ops->check_cqp_progress(&cqp_timeout,
+						       &rf->sc_dev);
+
+		if (cqp_timeout.count < CQP_TIMEOUT_THRESHOLD)
+			continue;
+
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: error cqp command 0x%x timed out",
+			info->cqp_cmd);
+		err_code = -ETIME;
+		if (!rf->reset) {
+			rf->reset = true;
+			rf->gen_ops.request_reset(rf);
+		}
+		goto done;
+	} while (1);
+
+	cqp_error = cqp_request->compl_info.error;
+	if (cqp_error) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: error cqp command 0x%x completion maj = 0x%x min=0x%x\n",
+			info->cqp_cmd, cqp_request->compl_info.maj_err_code,
+			cqp_request->compl_info.min_err_code);
+		err_code = -EPROTO;
+		goto done;
+	}
+
+done:
+	irdma_put_cqp_request(iwcqp, cqp_request);
+
+	return err_code;
+}
+
+/**
+ * irdma_handle_cqp_op - process cqp command
+ * @rf: RDMA PCI function
+ * @cqp_request: cqp request to process
+ */
+enum irdma_status_code irdma_handle_cqp_op(struct irdma_pci_f *rf,
+					   struct irdma_cqp_request
+					   *cqp_request)
+{
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	enum irdma_status_code status;
+	struct cqp_cmds_info *info = &cqp_request->info;
+	int err_code = 0;
+
+	if (rf->reset) {
+		irdma_free_cqp_request(&rf->cqp, cqp_request);
+		return IRDMA_ERR_CQP_COMPL_ERROR;
+	}
+
+	status = irdma_process_cqp_cmd(dev, info);
+	if (status == IRDMA_ERR_FLUSHED_Q) {
+		cqp_request->request_done = true;
+		if (cqp_request->waiting)
+			irdma_put_cqp_request(&rf->cqp, cqp_request);
+		status = 0;
+	} else if (status) {
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: error cqp command 0x%x failed\n", info->cqp_cmd);
+		irdma_free_cqp_request(&rf->cqp, cqp_request);
+		return status;
+	}
+
+	if (cqp_request->waiting)
+		err_code = irdma_wait_event(rf, cqp_request);
+	if (err_code)
+		status = IRDMA_ERR_CQP_COMPL_ERROR;
+
+	return status;
+}
+
+/**
+ * irdma_add_ref - add refcount for qp
+ * @ibqp: iqarp qp
+ */
+void irdma_add_ref(struct ib_qp *ibqp)
+{
+	struct irdma_qp *iwqp = (struct irdma_qp *)ibqp;
+
+	refcount_inc(&iwqp->refcnt);
+}
+
+/**
+ * irdma_rem_ref - rem refcount for qp and free if 0
+ * @ibqp: iqarp qp
+ */
+void irdma_rem_ref(struct ib_qp *ibqp)
+{
+	struct irdma_qp *iwqp;
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_device *iwdev;
+	u32 qp_num;
+	unsigned long flags;
+
+	iwqp = to_iwqp(ibqp);
+	iwdev = iwqp->iwdev;
+	spin_lock_irqsave(&iwdev->rf->qptable_lock, flags);
+	if (!refcount_dec_and_test(&iwqp->refcnt)) {
+		spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+		return;
+	}
+
+	qp_num = iwqp->ibqp.qp_num;
+	iwdev->rf->qp_table[qp_num] = NULL;
+	spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+	cqp_request = irdma_get_cqp_request(&iwdev->rf->cqp, false);
+	if (!cqp_request)
+		return;
+
+	INIT_WORK(&iwqp->work, irdma_free_qp_worker);
+	cqp_request->callback_fcn = irdma_free_qp;
+	cqp_request->param = &iwqp->sc_qp;
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_QP_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_destroy.qp = &iwqp->sc_qp;
+	cqp_info->in.u.qp_destroy.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.qp_destroy.remove_hash_idx = true;
+	status = irdma_handle_cqp_op(iwdev->rf, cqp_request);
+	if (status) {
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"ERR: CQP-OP Destroy QP fail");
+		queue_work(iwdev->cleanup_wq, &iwqp->work);
+	}
+}
+
+/**
+ * irdma_get_qp - get qp address
+ * @device: iwarp device
+ * @qpn: qp number
+ */
+struct ib_qp *irdma_get_qp(struct ib_device *device, int qpn)
+{
+	struct irdma_device *iwdev = to_iwdev(device);
+
+	if (qpn < IW_FIRST_QPN || qpn >= iwdev->rf->max_qp)
+		return NULL;
+
+	return &iwdev->rf->qp_table[qpn]->ibqp;
+}
+
+/**
+ * irdma_get_hw_addr - return hw addr
+ * @par: points to shared dev
+ */
+u8 __iomem *irdma_get_hw_addr(void *par)
+{
+	struct irdma_sc_dev *dev = par;
+
+	return dev->hw->hw_addr;
+}
+
+/**
+ * irdma_remove_cqp_head - return head entry and remove
+ * @dev: device
+ */
+void *irdma_remove_cqp_head(struct irdma_sc_dev *dev)
+{
+	struct list_head *entry;
+	struct list_head *list = &dev->cqp_cmd_head;
+
+	if (list_empty(list))
+		return NULL;
+
+	entry = list->next;
+	list_del(entry);
+
+	return entry;
+}
+
+/**
+ * irdma_cqp_sds_cmd - create cqp command for sd
+ * @dev: hardware control device structure
+ * @sdinfo: information for sd cqp
+ *
+ */
+enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_update_sds_info *sdinfo)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memcpy(&cqp_info->in.u.update_pe_sds.info, sdinfo,
+	       sizeof(cqp_info->in.u.update_pe_sds.info));
+	cqp_info->cqp_cmd = IRDMA_OP_UPDATE_PE_SDS;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.update_pe_sds.dev = dev;
+	cqp_info->in.u.update_pe_sds.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP-OP Update SD's fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_qp_suspend_resume - cqp command for suspend/resume
+ * @qp: hardware control qp
+ * @op: suspend or resume
+ */
+enum irdma_status_code irdma_cqp_qp_suspend_resume(struct irdma_sc_qp *qp,
+						   u8 op)
+{
+	struct irdma_sc_dev *dev = qp->dev;
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct irdma_sc_cqp *cqp = dev->cqp;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = op;
+	cqp_info->in.u.suspend_resume.cqp = cqp;
+	cqp_info->in.u.suspend_resume.qp = qp;
+	cqp_info->in.u.suspend_resume.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev),
+			"ERR: CQP-OP QP Suspend/Resume fail");
+
+	return status;
+}
+
+/**
+ * irdma_term_modify_qp - modify qp for term message
+ * @qp: hardware control qp
+ * @next_state: qp's next state
+ * @term: terminate code
+ * @term_len: length
+ */
+void irdma_term_modify_qp(struct irdma_sc_qp *qp, u8 next_state, u8 term,
+			  u8 term_len)
+{
+	struct irdma_qp *iwqp;
+
+	iwqp = qp->qp_uk.back_qp;
+	irdma_next_iw_state(iwqp, next_state, 0, term, term_len);
+};
+
+/**
+ * irdma_terminate_done - after terminate is completed
+ * @qp: hardware control qp
+ * @timeout_occurred: indicates if terminate timer expired
+ */
+void irdma_terminate_done(struct irdma_sc_qp *qp, int timeout_occurred)
+{
+	struct irdma_qp *iwqp;
+	u8 hte = 0;
+	bool first_time;
+	unsigned long flags;
+
+	iwqp = qp->qp_uk.back_qp;
+	spin_lock_irqsave(&iwqp->lock, flags);
+	if (iwqp->hte_added) {
+		iwqp->hte_added = 0;
+		hte = 1;
+	}
+	first_time = !(qp->term_flags & IRDMA_TERM_DONE);
+	qp->term_flags |= IRDMA_TERM_DONE;
+	spin_unlock_irqrestore(&iwqp->lock, flags);
+	if (first_time) {
+		if (!timeout_occurred)
+			irdma_terminate_del_timer(qp);
+
+		irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, hte, 0, 0);
+		irdma_cm_disconn(iwqp);
+	}
+}
+
+static void irdma_terminate_timeout(struct timer_list *t)
+{
+	struct irdma_qp *iwqp = from_timer(iwqp, t, terminate_timer);
+	struct irdma_sc_qp *qp = &iwqp->sc_qp;
+
+	irdma_terminate_done(qp, 1);
+	irdma_rem_ref(&iwqp->ibqp);
+}
+
+/**
+ * irdma_terminate_start_timer - start terminate timeout
+ * @qp: hardware control qp
+ */
+void irdma_terminate_start_timer(struct irdma_sc_qp *qp)
+{
+	struct irdma_qp *iwqp;
+
+	iwqp = qp->qp_uk.back_qp;
+	irdma_add_ref(&iwqp->ibqp);
+	timer_setup(&iwqp->terminate_timer, irdma_terminate_timeout, 0);
+	iwqp->terminate_timer.expires = jiffies + HZ;
+
+	add_timer(&iwqp->terminate_timer);
+}
+
+/**
+ * irdma_terminate_del_timer - delete terminate timeout
+ * @qp: hardware control qp
+ */
+void irdma_terminate_del_timer(struct irdma_sc_qp *qp)
+{
+	struct irdma_qp *iwqp;
+	int ret;
+
+	iwqp = qp->qp_uk.back_qp;
+	ret = del_timer(&iwqp->terminate_timer);
+	if (ret)
+		irdma_rem_ref(&iwqp->ibqp);
+}
+
+/**
+ * irdma_cqp_query_fpm_values_cmd - send cqp command for fpm
+ * @dev: function device struct
+ * @val_mem: buffer for fpm
+ * @hmc_fn_id: function id for fpm
+ */
+enum irdma_status_code
+irdma_cqp_query_fpm_val_cmd(struct irdma_sc_dev *dev,
+			    struct irdma_dma_mem *val_mem, u8 hmc_fn_id)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_request->param = NULL;
+	cqp_info->in.u.query_fpm_val.cqp = dev->cqp;
+	cqp_info->in.u.query_fpm_val.fpm_val_pa = val_mem->pa;
+	cqp_info->in.u.query_fpm_val.fpm_val_va = val_mem->va;
+	cqp_info->in.u.query_fpm_val.hmc_fn_id = hmc_fn_id;
+	cqp_info->cqp_cmd = IRDMA_OP_QUERY_FPM_VAL;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.query_fpm_val.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP-OP Query FPM fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_commit_fpm_values_cmd - commit fpm values in hw
+ * @dev: hardware control device structure
+ * @val_mem: buffer with fpm values
+ * @hmc_fn_id: function id for fpm
+ */
+enum irdma_status_code
+irdma_cqp_commit_fpm_val_cmd(struct irdma_sc_dev *dev,
+			     struct irdma_dma_mem *val_mem, u8 hmc_fn_id)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_request->param = NULL;
+	cqp_info->in.u.commit_fpm_val.cqp = dev->cqp;
+	cqp_info->in.u.commit_fpm_val.fpm_val_pa = val_mem->pa;
+	cqp_info->in.u.commit_fpm_val.fpm_val_va = val_mem->va;
+	cqp_info->in.u.commit_fpm_val.hmc_fn_id = hmc_fn_id;
+	cqp_info->cqp_cmd = IRDMA_OP_COMMIT_FPM_VAL;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.commit_fpm_val.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP-OP Commit FPM fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_cq_create_cmd - create a cq for the cqp
+ * @dev: device pointer
+ * @cq: pointer to created cq
+ */
+enum irdma_status_code irdma_cqp_cq_create_cmd(struct irdma_sc_dev *dev,
+					       struct irdma_sc_cq *cq)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_CQ_CREATE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.cq_create.cq = cq;
+	cqp_info->in.u.cq_create.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP-OP Create CQ fail");
+
+	return status;
+}
+
+/**
+ * irdma_cqp_qp_create_cmd - create a qp for the cqp
+ * @dev: device pointer
+ * @qp: pointer to created qp
+ */
+enum irdma_status_code irdma_cqp_qp_create_cmd(struct irdma_sc_dev *dev,
+					       struct irdma_sc_qp *qp)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_create_qp_info *qp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	qp_info = &cqp_request->info.in.u.qp_create.info;
+	memset(qp_info, 0, sizeof(*qp_info));
+	qp_info->cq_num_valid = true;
+	qp_info->next_iwarp_state = IRDMA_QP_STATE_RTS;
+	cqp_info->cqp_cmd = IRDMA_OP_QP_CREATE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_create.qp = qp;
+	cqp_info->in.u.qp_create.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP-OP QP create fail");
+
+	return status;
+}
+
+/**
+ * irdma_dealloc_push_page - free a push page for qp
+ * @rf: RDMA PCI function
+ * @qp: hardware control qp
+ */
+static void irdma_dealloc_push_page(struct irdma_pci_f *rf,
+				    struct irdma_sc_qp *qp)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX)
+		return;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, false);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_MANAGE_PUSH_PAGE;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.manage_push_page.info.push_idx = qp->push_idx;
+	cqp_info->in.u.manage_push_page.info.qs_handle = qp->qs_handle;
+	cqp_info->in.u.manage_push_page.info.free_page = 1;
+	cqp_info->in.u.manage_push_page.info.push_page_type = 0;
+	cqp_info->in.u.manage_push_page.cqp = &rf->cqp.sc_cqp;
+	cqp_info->in.u.manage_push_page.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (!status)
+		qp->push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
+	else
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP-OP dealloc Push page fail");
+}
+
+/**
+ * irdma_free_qp_rsrc - free up memory resources for qp
+ * @iwdev: iwarp device
+ * @iwqp: qp ptr (user or kernel)
+ * @qp_num: qp number assigned
+ */
+void irdma_free_qp_rsrc(struct irdma_device *iwdev, struct irdma_qp *iwqp,
+			u32 qp_num)
+{
+	struct irdma_pci_f *rf = iwdev->rf;
+
+	irdma_ieq_cleanup_qp(iwdev->vsi.ieq, &iwqp->sc_qp);
+	irdma_dealloc_push_page(rf, &iwqp->sc_qp);
+	if (iwqp->sc_qp.vsi) {
+		irdma_qp_rem_qos(&iwqp->sc_qp);
+		iwqp->sc_qp.dev->ws_remove(iwqp->sc_qp.vsi,
+					   iwqp->sc_qp.user_pri);
+	}
+
+	if (qp_num > 2)
+		irdma_free_rsrc(rf, rf->allocated_qps, qp_num);
+	dma_free_coherent(hw_to_dev(rf->sc_dev.hw), iwqp->q2_ctx_mem.size,
+			  iwqp->q2_ctx_mem.va, iwqp->q2_ctx_mem.pa);
+	iwqp->q2_ctx_mem.va = NULL;
+	dma_free_coherent(hw_to_dev(rf->sc_dev.hw), iwqp->kqp.dma_mem.size,
+			  iwqp->kqp.dma_mem.va, iwqp->kqp.dma_mem.pa);
+	iwqp->kqp.dma_mem.va = NULL;
+	kfree(iwqp->kqp.sq_wrid_mem);
+	iwqp->kqp.sq_wrid_mem = NULL;
+	kfree(iwqp->kqp.rq_wrid_mem);
+	iwqp->kqp.rq_wrid_mem = NULL;
+	kfree(iwqp);
+}
+
+/**
+ * irdma_cq_wq_destroy - send cq destroy cqp
+ * @rf: RDMA PCI function
+ * @cq: hardware control cq
+ */
+void irdma_cq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_cq *cq)
+{
+	enum irdma_status_code status;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = IRDMA_OP_CQ_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.cq_destroy.cq = cq;
+	cqp_info->in.u.cq_destroy.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP-OP Destroy CQ fail");
+}
+
+/**
+ * irdma_hw_modify_qp_callback - handle state for modifyQPs that don't wait
+ * @cqp_request: modify QP completion
+ */
+static void irdma_hw_modify_qp_callback(struct irdma_cqp_request *cqp_request)
+{
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_qp *iwqp;
+
+	cqp_info = &cqp_request->info;
+	iwqp = cqp_info->in.u.qp_modify.qp->qp_uk.back_qp;
+	atomic_dec(&iwqp->hw_mod_qp_pend);
+	wake_up(&iwqp->mod_qp_waitq);
+}
+
+/**
+ * irdma_hw_modify_qp - setup cqp for modify qp
+ * @iwdev: RDMA device
+ * @iwqp: qp ptr (user or kernel)
+ * @info: info for modify qp
+ * @wait: flag to wait or not for modify qp completion
+ */
+enum irdma_status_code irdma_hw_modify_qp(struct irdma_device *iwdev,
+					  struct irdma_qp *iwqp,
+					  struct irdma_modify_qp_info *info,
+					  bool wait)
+{
+	enum irdma_status_code status;
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_modify_qp_info *m_info;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	if (!wait) {
+		cqp_request->callback_fcn = irdma_hw_modify_qp_callback;
+		atomic_inc(&iwqp->hw_mod_qp_pend);
+	}
+	cqp_info = &cqp_request->info;
+	m_info = &cqp_info->in.u.qp_modify.info;
+	memcpy(m_info, info, sizeof(*m_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_MODIFY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_modify.qp = &iwqp->sc_qp;
+	cqp_info->in.u.qp_modify.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		if (rdma_protocol_roce(&iwdev->ibdev, 1))
+			return status;
+		switch (m_info->next_iwarp_state) {
+			struct irdma_gen_ae_info ae_info;
+
+		case IRDMA_QP_STATE_RTS:
+		case IRDMA_QP_STATE_IDLE:
+		case IRDMA_QP_STATE_TERMINATE:
+		case IRDMA_QP_STATE_CLOSING:
+			if (info->curr_iwarp_state == IRDMA_QP_STATE_IDLE)
+				irdma_send_reset(iwqp->cm_node);
+			else
+				iwqp->sc_qp.term_flags = IRDMA_TERM_DONE;
+			if (!wait) {
+				ae_info.ae_code = IRDMA_AE_BAD_CLOSE;
+				ae_info.ae_src = 0;
+				irdma_gen_ae(rf, &iwqp->sc_qp, &ae_info, false);
+			} else {
+				cqp_request = irdma_get_cqp_request(&rf->cqp,
+								    wait);
+				if (!cqp_request)
+					return IRDMA_ERR_NO_MEMORY;
+
+				cqp_info = &cqp_request->info;
+				m_info = &cqp_info->in.u.qp_modify.info;
+				memcpy(m_info, info, sizeof(*m_info));
+				cqp_info->cqp_cmd = IRDMA_OP_QP_MODIFY;
+				cqp_info->post_sq = 1;
+				cqp_info->in.u.qp_modify.qp = &iwqp->sc_qp;
+				cqp_info->in.u.qp_modify.scratch = (uintptr_t)cqp_request;
+				m_info->next_iwarp_state = IRDMA_QP_STATE_ERROR;
+				m_info->reset_tcp_conn = true;
+				irdma_handle_cqp_op(rf, cqp_request);
+			}
+			break;
+		case IRDMA_QP_STATE_ERROR:
+		default:
+			break;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * irdma_cqp_cq_destroy_cmd - destroy the cqp cq
+ * @dev: device pointer
+ * @cq: pointer to cq
+ */
+void irdma_cqp_cq_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_cq *cq)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	irdma_cq_wq_destroy(rf, cq);
+}
+
+/**
+ * irdma_cqp_qp_destroy_cmd - destroy the cqp
+ * @dev: device pointer
+ * @qp: pointer to qp
+ */
+void irdma_cqp_qp_destroy_cmd(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_DESTROY;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_destroy.qp = qp;
+	cqp_info->in.u.qp_destroy.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.qp_destroy.remove_hash_idx = true;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP QP_DESTROY fail");
+}
+
+/**
+ * irdma_ieq_mpa_crc_ae - generate AE for crc error
+ * @dev: hardware control device structure
+ * @qp: hardware control qp
+ */
+void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp)
+{
+	struct irdma_gen_ae_info info = {};
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	dev_dbg(rfdev_to_dev(dev), "AEQ: Generate MPA CRC AE\n");
+	info.ae_code = IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR;
+	info.ae_src = IRDMA_AE_SOURCE_RQ;
+	irdma_gen_ae(rf, qp, &info, false);
+}
+
+/**
+ * irdma_init_hash_desc - initialize hash for crc calculation
+ * @desc: cryption type
+ */
+enum irdma_status_code irdma_init_hash_desc(struct shash_desc **desc)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *tdesc;
+
+	tfm = crypto_alloc_shash("crc32c", 0, 0);
+	if (IS_ERR(tfm))
+		return IRDMA_ERR_MPA_CRC;
+
+	tdesc = kzalloc(sizeof(*tdesc) + crypto_shash_descsize(tfm),
+			GFP_KERNEL);
+	if (!tdesc) {
+		crypto_free_shash(tfm);
+		return IRDMA_ERR_MPA_CRC;
+	}
+
+	tdesc->tfm = tfm;
+	*desc = tdesc;
+
+	return 0;
+}
+
+/**
+ * irdma_free_hash_desc - free hash desc
+ * @desc: to be freed
+ */
+void irdma_free_hash_desc(struct shash_desc *desc)
+{
+	if (desc) {
+		crypto_free_shash(desc->tfm);
+		kfree(desc);
+	}
+}
+
+/**
+ * irdma_ieq_check_mpacrc - check if mpa crc is OK
+ * @desc: desc for hash
+ * @addr: address of buffer for crc
+ * @len: length of buffer
+ * @val: value to be compared
+ */
+enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
+					      void *addr, u32 len, u32 val)
+{
+	u32 crc = 0;
+	int ret;
+	enum irdma_status_code ret_code = 0;
+
+	crypto_shash_init(desc);
+	ret = crypto_shash_update(desc, addr, len);
+	if (!ret)
+		crypto_shash_final(desc, (u8 *)&crc);
+	if (crc != val) {
+		pr_err("mpa crc check fail");
+		ret_code = IRDMA_ERR_MPA_CRC;
+	}
+
+	return ret_code;
+}
+
+/**
+ * irdma_ieq_get_qp - get qp based on quad in puda buffer
+ * @dev: hardware control device structure
+ * @buf: receive puda buffer on exception q
+ */
+struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
+				     struct irdma_puda_buf *buf)
+{
+	struct irdma_qp *iwqp;
+	struct irdma_cm_node *cm_node;
+	struct irdma_device *iwdev = buf->vsi->back_vsi;
+	u32 loc_addr[4] = {};
+	u32 rem_addr[4] = {};
+	u16 loc_port, rem_port;
+	struct ipv6hdr *ip6h;
+	struct iphdr *iph = (struct iphdr *)buf->iph;
+	struct tcphdr *tcph = (struct tcphdr *)buf->tcph;
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct udphdr *udph;
+	struct irdma_bth *bth;
+
+	if (iph->protocol == IPPROTO_UDP) {
+		udph = (struct udphdr *)tcph;
+		bth = (struct irdma_bth *)udph + sizeof(*udph);
+		iwqp = rf->qp_table[be32_to_cpu(bth->qpn)];
+		return &iwqp->sc_qp;
+	}
+
+	if (iph->version == 4) {
+		loc_addr[0] = ntohl(iph->daddr);
+		rem_addr[0] = ntohl(iph->saddr);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		irdma_copy_ip_ntohl(loc_addr, ip6h->daddr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(rem_addr, ip6h->saddr.in6_u.u6_addr32);
+	}
+	loc_port = ntohs(tcph->dest);
+	rem_port = ntohs(tcph->source);
+	cm_node = irdma_find_node(&iwdev->cm_core, rem_port, rem_addr, loc_port,
+				  loc_addr, false, true);
+	if (!cm_node)
+		return NULL;
+
+	iwqp = cm_node->iwqp;
+
+	return &iwqp->sc_qp;
+}
+
+/**
+ * irdma_send_ieq_ack - ACKs for duplicate or OOO partials FPDUs
+ * @qp: qp ptr
+ */
+void irdma_send_ieq_ack(struct irdma_sc_qp *qp)
+{
+	struct irdma_cm_node *cm_node = ((struct irdma_qp *)qp->qp_uk.back_qp)->cm_node;
+	struct irdma_puda_buf *buf = qp->pfpdu.lastrcv_buf;
+	struct tcphdr *tcph = (struct tcphdr *)buf->tcph;
+
+	cm_node->tcp_cntxt.rcv_nxt = qp->pfpdu.nextseqnum;
+	cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
+
+	irdma_send_ack(cm_node);
+}
+
+/**
+ * irdma_puda_ieq_get_ah_info - get AH info from IEQ buffer
+ * @qp: qp pointer
+ * @ah_info: AH info pointer
+ */
+void irdma_puda_ieq_get_ah_info(struct irdma_sc_qp *qp,
+				struct irdma_ah_info *ah_info)
+{
+	struct irdma_puda_buf *buf = qp->pfpdu.ah_buf;
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+
+	memset(ah_info, 0, sizeof(*ah_info));
+	ah_info->do_lpbk = true;
+	ah_info->vlan_tag = buf->vlan_id;
+	ah_info->insert_vlan_tag = buf->vlan_valid;
+	ah_info->ipv4_valid = buf->ipv4;
+	ah_info->vsi = qp->vsi;
+
+	if (buf->smac_valid)
+		ether_addr_copy(ah_info->mac_addr, buf->smac);
+
+	if (buf->ipv4) {
+		ah_info->ipv4_valid = true;
+		iph = (struct iphdr *)buf->iph;
+		ah_info->hop_ttl = iph->ttl;
+		ah_info->tc_tos = iph->tos;
+		ah_info->dest_ip_addr[0] = ntohl(iph->daddr);
+		ah_info->src_ip_addr[0] = ntohl(iph->saddr);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		ah_info->hop_ttl = ip6h->hop_limit;
+		ah_info->tc_tos = ip6h->priority;
+		irdma_copy_ip_ntohl(ah_info->dest_ip_addr,
+				    ip6h->daddr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(ah_info->src_ip_addr,
+				    ip6h->saddr.in6_u.u6_addr32);
+	}
+
+	ah_info->dst_arpindex = irdma_arp_table(qp->dev->back_dev,
+						ah_info->dest_ip_addr,
+						ah_info->ipv4_valid,
+						NULL, IRDMA_ARP_RESOLVE);
+}
+
+/**
+ * irdma_gen1_ieq_update_tcpip_info - update tcpip in the buffer
+ * @buf: puda to update
+ * @len: length of buffer
+ * @seqnum: seq number for tcp
+ */
+static void irdma_gen1_ieq_update_tcpip_info(struct irdma_puda_buf *buf,
+					     u16 len, u32 seqnum)
+{
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	u16 iphlen;
+	u16 pktsize;
+	u8 *addr = buf->mem.va;
+
+	iphlen = (buf->ipv4) ? 20 : 40;
+	iph = (struct iphdr *)(addr + buf->maclen);
+	tcph = (struct tcphdr *)(addr + buf->maclen + iphlen);
+	pktsize = len + buf->tcphlen + iphlen;
+	iph->tot_len = htons(pktsize);
+	tcph->seq = htonl(seqnum);
+}
+
+/**
+ * irdma_ieq_update_tcpip_info - update tcpip in the buffer
+ * @buf: puda to update
+ * @len: length of buffer
+ * @seqnum: seq number for tcp
+ */
+void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf, u16 len,
+				 u32 seqnum)
+{
+	struct tcphdr *tcph;
+	u8 *addr;
+
+	if (buf->vsi->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		return irdma_gen1_ieq_update_tcpip_info(buf, len, seqnum);
+
+	addr = buf->mem.va;
+	tcph = (struct tcphdr *)addr;
+	tcph->seq = htonl(seqnum);
+}
+
+/**
+ * irdma_gen1_puda_get_tcpip_info - get tcpip info from puda
+ * buffer
+ * @info: to get information
+ * @buf: puda buffer
+ */
+static enum irdma_status_code
+irdma_gen1_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			       struct irdma_puda_buf *buf)
+{
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcph;
+	u16 iphlen;
+	u16 pkt_len;
+	u8 *mem = buf->mem.va;
+	struct ethhdr *ethh = buf->mem.va;
+
+	if (ethh->h_proto == htons(0x8100)) {
+		info->vlan_valid = true;
+		buf->vlan_id = ntohs(((struct vlan_ethhdr *)ethh)->h_vlan_TCI) &
+			       VLAN_VID_MASK;
+	}
+
+	buf->maclen = (info->vlan_valid) ? 18 : 14;
+	iphlen = (info->l3proto) ? 40 : 20;
+	buf->ipv4 = (info->l3proto) ? false : true;
+	buf->iph = mem + buf->maclen;
+	iph = (struct iphdr *)buf->iph;
+	buf->tcph = buf->iph + iphlen;
+	tcph = (struct tcphdr *)buf->tcph;
+
+	if (buf->ipv4) {
+		pkt_len = ntohs(iph->tot_len);
+	} else {
+		ip6h = (struct ipv6hdr *)buf->iph;
+		pkt_len = ntohs(ip6h->payload_len) + iphlen;
+	}
+
+	buf->totallen = pkt_len + buf->maclen;
+
+	if (info->payload_len < buf->totallen) {
+		dev_dbg(rfdev_to_dev(buf->vsi->dev),
+			"ERR: payload_len = 0x%x totallen expected0x%x\n",
+			info->payload_len, buf->totallen);
+		return IRDMA_ERR_INVALID_SIZE;
+	}
+
+	buf->tcphlen = tcph->doff << 2;
+	buf->datalen = pkt_len - iphlen - buf->tcphlen;
+	buf->data = buf->datalen ? buf->tcph + buf->tcphlen : NULL;
+	buf->hdrlen = buf->maclen + iphlen + buf->tcphlen;
+	buf->seqnum = ntohl(tcph->seq);
+
+	return 0;
+}
+
+/**
+ * irdma_puda_get_tcpip_info - get tcpip info from puda buffer
+ * @info: to get information
+ * @buf: puda buffer
+ */
+enum irdma_status_code
+irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
+			  struct irdma_puda_buf *buf)
+{
+	struct tcphdr *tcph;
+	u32 pkt_len;
+	u8 *mem;
+
+	if (buf->vsi->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		return irdma_gen1_puda_get_tcpip_info(info, buf);
+
+	mem = buf->mem.va;
+	buf->vlan_valid = info->vlan_valid;
+	if (info->vlan_valid)
+		buf->vlan_id = info->vlan;
+
+	buf->ipv4 = info->ipv4;
+	if (buf->ipv4)
+		buf->iph = mem + IRDMA_IPV4_PAD;
+	else
+		buf->iph = mem;
+
+	buf->tcph = mem + IRDMA_TCP_OFFSET;
+	tcph = (struct tcphdr *)buf->tcph;
+	pkt_len = info->payload_len;
+	buf->totallen = pkt_len;
+	buf->tcphlen = tcph->doff << 2;
+	buf->datalen = pkt_len - IRDMA_TCP_OFFSET - buf->tcphlen;
+	buf->data = buf->datalen ? buf->tcph + buf->tcphlen : NULL;
+	buf->hdrlen = IRDMA_TCP_OFFSET + buf->tcphlen;
+	buf->seqnum = ntohl(tcph->seq);
+
+	if (info->smac_valid) {
+		ether_addr_copy(buf->smac, info->smac);
+		buf->smac_valid = true;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_process_stats - Checking for wrap and update stats
+ *
+ * @pestat: stats structure pointer
+ */
+static void irdma_process_stats(struct irdma_vsi_pestat *pestat)
+{
+	struct irdma_gather_stats *gather_stats =
+		pestat->gather_info.gather_stats;
+	struct irdma_gather_stats *last_gather_stats =
+		pestat->gather_info.last_gather_stats;
+	irdma_update_stats(&pestat->hw_stats, gather_stats, last_gather_stats);
+}
+
+/**
+ * irdma_cqp_gather_stats_gen1 - Gather stats
+ * @dev: pointer to device structure
+ * @pestat: statistics structure
+ */
+static void irdma_cqp_gather_stats_gen1(struct irdma_sc_dev *dev,
+					struct irdma_vsi_pestat *pestat)
+{
+	struct irdma_gather_stats *gather_stats =
+		pestat->gather_info.gather_stats;
+	u32 stats_inst_offset_32;
+	u32 stats_inst_offset_64;
+
+	stats_inst_offset_32 = (pestat->gather_info.use_stats_inst) ?
+				       pestat->gather_info.stats_inst_index :
+				       pestat->hw->hmc.hmc_fn_id;
+	stats_inst_offset_32 *= 4;
+	stats_inst_offset_64 = stats_inst_offset_32 * 2;
+
+	gather_stats->rxvlanerr =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_RXVLANERR]
+		     + stats_inst_offset_32);
+	gather_stats->ip4rxdiscard =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4RXDISCARD]
+		     + stats_inst_offset_32);
+	gather_stats->ip4rxtrunc =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4RXTRUNC]
+		     + stats_inst_offset_32);
+	gather_stats->ip4txnoroute =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP4TXNOROUTE]
+		     + stats_inst_offset_32);
+	gather_stats->ip6rxdiscard =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6RXDISCARD]
+		     + stats_inst_offset_32);
+	gather_stats->ip6rxtrunc =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6RXTRUNC]
+		     + stats_inst_offset_32);
+	gather_stats->ip6txnoroute =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_IP6TXNOROUTE]
+		     + stats_inst_offset_32);
+	gather_stats->tcprtxseg =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_TCPRTXSEG]
+		     + stats_inst_offset_32);
+	gather_stats->tcprxopterr =
+		rd32(dev->hw,
+		     dev->hw_stats_regs_32[IRDMA_HW_STAT_INDEX_TCPRXOPTERR]
+		     + stats_inst_offset_32);
+
+	gather_stats->ip4rxocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4rxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txfrag =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4rxmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4RXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txfrag =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip4txmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP4TXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txfrags =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6rxmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6RXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txocts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXOCTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txfrags =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXFRAGS]
+		     + stats_inst_offset_64);
+	gather_stats->ip6txmcpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_IP6TXMCPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->tcprxsegs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_TCPRXSEGS]
+		     + stats_inst_offset_64);
+	gather_stats->tcptxsegs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_TCPTXSEG]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxrds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXRDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxsnds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXSNDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmarxwrs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMARXWRS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxrds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXRDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxsnds =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXSNDS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmatxwrs =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMATXWRS]
+		     + stats_inst_offset_64);
+	gather_stats->rdmavbn =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMAVBND]
+		     + stats_inst_offset_64);
+	gather_stats->rdmavinv =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_RDMAVINV]
+		     + stats_inst_offset_64);
+	gather_stats->udprxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_UDPRXPKTS]
+		     + stats_inst_offset_64);
+	gather_stats->udptxpkts =
+		rd64(dev->hw,
+		     dev->hw_stats_regs_64[IRDMA_HW_STAT_INDEX_UDPTXPKTS]
+		     + stats_inst_offset_64);
+
+	irdma_process_stats(pestat);
+}
+
+/**
+ * irdma_process_cqp_stats - Checking for wrap and update stats
+ * @cqp_request: cqp_request structure pointer
+ */
+static void irdma_process_cqp_stats(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_vsi_pestat *pestat = cqp_request->param;
+
+	irdma_process_stats(pestat);
+}
+
+/**
+ * irdma_cqp_gather_stats_cmd - Gather stats
+ * @dev: pointer to device structure
+ * @pestat: pointer to stats info
+ * @wait: flag to wait or not wait for stats
+ */
+enum irdma_status_code
+irdma_cqp_gather_stats_cmd(struct irdma_sc_dev *dev,
+			   struct irdma_vsi_pestat *pestat, bool wait)
+
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = IRDMA_OP_STATS_GATHER;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.stats_gather.info = pestat->gather_info;
+	cqp_info->in.u.stats_gather.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.stats_gather.cqp = &rf->cqp.sc_cqp;
+	cqp_request->param = pestat;
+	if (!wait)
+		cqp_request->callback_fcn = irdma_process_cqp_stats;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP STATS_GATHER fail");
+	else if (wait)
+		irdma_process_stats(pestat);
+
+	return status;
+}
+
+/**
+ * irdma_hw_stats_timeout - Stats timer-handler which updates all HW stats
+ * @t: timer_list pointer
+ */
+static void irdma_hw_stats_timeout(struct timer_list *t)
+{
+	struct irdma_vsi_pestat *pf_devstat =
+		from_timer(pf_devstat, t, stats_timer);
+	struct irdma_sc_vsi *sc_vsi = pf_devstat->vsi;
+	struct irdma_device *iwdev = sc_vsi->back_vsi;
+
+	if (iwdev->init_state != RDMA_DEV_REGISTERED)
+		goto exit;
+	if (sc_vsi->dev->hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
+		irdma_cqp_gather_stats_gen1(sc_vsi->dev, sc_vsi->pestat);
+	else
+		irdma_cqp_gather_stats_cmd(sc_vsi->dev, sc_vsi->pestat, false);
+
+exit:
+	mod_timer(&pf_devstat->stats_timer,
+		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
+}
+
+/**
+ * irdma_hw_stats_start_timer - Start periodic stats timer
+ * @vsi: vsi structure pointer
+ */
+void irdma_hw_stats_start_timer(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_vsi_pestat *devstat = vsi->pestat;
+
+	timer_setup(&devstat->stats_timer, irdma_hw_stats_timeout, 0);
+	mod_timer(&devstat->stats_timer,
+		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
+}
+
+/**
+ * irdma_hw_stats_del_timer - Delete periodic stats timer
+ * @vsi: pointer to vsi structure
+ */
+void irdma_hw_stats_stop_timer(struct irdma_sc_vsi *vsi)
+{
+	struct irdma_vsi_pestat *devstat = vsi->pestat;
+
+	del_timer_sync(&devstat->stats_timer);
+}
+
+/**
+ * irdma_cqp_stats_inst_cmd - Allocate/free stats instance
+ * @vsi: pointer to vsi structure
+ * @cmd: command to allocate or free
+ * @stats_info: pointer to allocate stats info
+ */
+enum irdma_status_code
+irdma_cqp_stats_inst_cmd(struct irdma_sc_vsi *vsi, u8 cmd,
+			 struct irdma_stats_inst_info *stats_info)
+{
+	struct irdma_pci_f *rf = vsi->dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+	bool wait = false;
+
+	if (cmd == IRDMA_OP_STATS_ALLOCATE)
+		wait = true;
+	cqp_request = irdma_get_cqp_request(iwcqp, wait);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.stats_manage.info = *stats_info;
+	cqp_info->in.u.stats_manage.scratch = (uintptr_t)cqp_request;
+	cqp_info->in.u.stats_manage.cqp = &rf->cqp.sc_cqp;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(&rf->sc_dev),
+			"ERR: CQP MANAGE_STATS fail");
+	else if (wait)
+		stats_info->stats_idx = cqp_request->compl_info.op_ret_val;
+
+	return status;
+}
+
+/**
+ * irdma_cqp_ceq_cmd - Create/Destroy CEQ's after CEQ 0
+ * @dev: pointer to device info
+ * @sc_ceq: pointer to ceq structure
+ * @op: Create or Destroy
+ */
+enum irdma_status_code irdma_cqp_ceq_cmd(struct irdma_sc_dev *dev,
+					 struct irdma_sc_ceq *sc_ceq, u8 op)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, true);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->post_sq = 1;
+	cqp_info->cqp_cmd = op;
+	cqp_info->in.u.ceq_create.ceq = sc_ceq;
+	cqp_info->in.u.ceq_create.scratch = (uintptr_t)cqp_request;
+
+	return irdma_handle_cqp_op(rf, cqp_request);
+}
+
+/**
+ * irdma_cqp_ws_node_cmd - Add/modify/delete ws node
+ * @dev: pointer to device structure
+ * @cmd: Add, modify or delete
+ * @node_info: pointer to ws node info
+ */
+enum irdma_status_code
+irdma_cqp_ws_node_cmd(struct irdma_sc_dev *dev, u8 cmd,
+		      struct irdma_ws_node_info *node_info)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_sc_cqp *cqp = &iwcqp->sc_cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+	bool poll;
+
+	if (!rf->sc_dev.ceq_valid)
+		poll = true;
+	else
+		poll = false;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, !poll);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.ws_node.info = *node_info;
+	cqp_info->in.u.ws_node.cqp = cqp;
+	cqp_info->in.u.ws_node.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status) {
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP WS_NODE fail\n");
+		return status;
+	}
+
+	if (poll) {
+		struct irdma_ccq_cqe_info compl_info;
+
+		status = cqp->dev->cqp_ops->poll_for_cqp_op_done(cqp,
+								 IRDMA_CQP_OP_WORK_SCHED_NODE,
+								 &compl_info);
+		node_info->qs_handle = compl_info.op_ret_val;
+		dev_dbg(rfdev_to_dev(cqp->dev),
+			"DCB: opcode=%d, compl_info.retval=%d\n",
+			compl_info.op_code, compl_info.op_ret_val);
+	} else {
+		node_info->qs_handle = cqp_request->compl_info.op_ret_val;
+	}
+
+	return status;
+}
+
+/**
+ * irdma_cqp_up_map_cmd - Set the up-up mapping
+ * @dev: pointer to device structure
+ * @cmd: map command
+ * @map_info: pointer to up map info
+ */
+enum irdma_status_code irdma_cqp_up_map_cmd(struct irdma_sc_dev *dev, u8 cmd,
+					    struct irdma_up_info *map_info)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	struct irdma_cqp *iwcqp = &rf->cqp;
+	struct irdma_sc_cqp *cqp = &iwcqp->sc_cqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, false);
+	if (!cqp_request)
+		return IRDMA_ERR_NO_MEMORY;
+
+	cqp_info = &cqp_request->info;
+	memset(cqp_info, 0, sizeof(*cqp_info));
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.up_map.info = *map_info;
+	cqp_info->in.u.up_map.cqp = cqp;
+	cqp_info->in.u.up_map.scratch = (uintptr_t)cqp_request;
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (status)
+		dev_dbg(rfdev_to_dev(dev), "ERR: CQP UP MAP fail\n");
+
+	return status;
+}
+
+/**
+ * irdma_ah_cqp_op - perform an AH cqp operation
+ * @rf: RDMA PCI function
+ * @sc_ah: address handle
+ * @cmd: AH operation
+ * @wait: wait if true
+ * @callback_fcn: Callback function on CQP op completion
+ * @cb_param: parameter for callback function
+ *
+ * returns errno
+ */
+int irdma_ah_cqp_op(struct irdma_pci_f *rf, struct irdma_sc_ah *sc_ah, u8 cmd,
+		    bool wait,
+		    void (*callback_fcn)(struct irdma_cqp_request *),
+		    void *cb_param)
+{
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	enum irdma_status_code status;
+
+	cqp_request = irdma_get_cqp_request(&rf->cqp, wait);
+	if (!cqp_request)
+		return -ENOMEM;
+
+	cqp_info = &cqp_request->info;
+	cqp_info->cqp_cmd = cmd;
+	cqp_info->post_sq = 1;
+	if (cmd == IRDMA_OP_AH_CREATE) {
+		cqp_info->in.u.ah_create.info = sc_ah->ah_info;
+		cqp_info->in.u.ah_create.scratch = (uintptr_t)cqp_request;
+		cqp_info->in.u.ah_create.cqp = &rf->cqp.sc_cqp;
+	} else if (cmd == IRDMA_OP_AH_DESTROY) {
+		cqp_info->in.u.ah_destroy.info = sc_ah->ah_info;
+		cqp_info->in.u.ah_destroy.scratch = (uintptr_t)cqp_request;
+		cqp_info->in.u.ah_destroy.cqp = &rf->cqp.sc_cqp;
+	} else {
+		return -EINVAL;
+	}
+
+	if (!wait) {
+		cqp_request->callback_fcn = callback_fcn;
+		cqp_request->param = cb_param;
+	}
+	status = irdma_handle_cqp_op(rf, cqp_request);
+	if (!status) {
+		if (wait) {
+			if (cmd == IRDMA_OP_AH_CREATE)
+				sc_ah->ah_info.ah_valid = true;
+			else
+				sc_ah->ah_info.ah_valid = false;
+		}
+	} else {
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_ieq_ah_cb - callback after creation of AH for IEQ
+ * @cqp_request: pointer to cqp_request of create AH
+ */
+static void irdma_ieq_ah_cb(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_sc_qp *qp = cqp_request->param;
+	struct irdma_sc_ah *sc_ah = qp->pfpdu.ah;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->pfpdu.lock, flags);
+	if (!cqp_request->compl_info.op_ret_val) {
+		sc_ah->ah_info.ah_valid = true;
+		irdma_ieq_process_fpdus(qp, qp->vsi->ieq);
+	} else {
+		sc_ah->ah_info.ah_valid = false;
+		irdma_ieq_cleanup_qp(qp->vsi->ieq, qp);
+	}
+	spin_unlock_irqrestore(&qp->pfpdu.lock, flags);
+}
+
+/**
+ * irdma_ilq_ah_cb - callback after creation of AH for ILQ
+ * @cqp_request: pointer to cqp_request of create AH
+ */
+static void irdma_ilq_ah_cb(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_cm_node *cm_node = cqp_request->param;
+	struct irdma_sc_ah *sc_ah = cm_node->ah;
+
+	if (!cqp_request->compl_info.op_ret_val)
+		sc_ah->ah_info.ah_valid = true;
+	else
+		sc_ah->ah_info.ah_valid = false;
+}
+
+/**
+ * irdma_puda_create_ah - create AH for ILQ/IEQ qp's
+ * @dev: device pointer
+ * @ah_info: Address handle info
+ * @wait: When true will wait for operation to complete
+ * @type: ILQ/IEQ
+ * @cb_param: Callback param when not waiting
+ * @ah_ret: Returned pointer to address handle if created
+ *
+ */
+enum irdma_status_code irdma_puda_create_ah(struct irdma_sc_dev *dev,
+					    struct irdma_ah_info *ah_info,
+					    bool wait, enum puda_rsrc_type type,
+					    void *cb_param,
+					    struct irdma_sc_ah **ah_ret)
+{
+	struct irdma_sc_ah *ah;
+	struct irdma_pci_f *rf = dev->back_dev;
+	int err;
+
+	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
+	*ah_ret = ah;
+	if (!ah)
+		return IRDMA_ERR_NO_MEMORY;
+
+	err = irdma_alloc_rsrc(rf, rf->allocated_ahs, rf->max_ah,
+			       &ah_info->ah_idx, &rf->next_ah);
+	if (err)
+		goto err_free;
+
+	ah->dev = dev;
+	ah->ah_info = *ah_info;
+
+	if (type == IRDMA_PUDA_RSRC_TYPE_ILQ)
+		err = irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_CREATE, wait,
+				      irdma_ilq_ah_cb, cb_param);
+	else
+		err = irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_CREATE, wait,
+				      irdma_ieq_ah_cb, cb_param);
+
+	if (err)
+		goto error;
+	return 0;
+
+error:
+	irdma_free_rsrc(rf, rf->allocated_ahs, ah->ah_info.ah_idx);
+err_free:
+	kfree(ah);
+	*ah_ret = NULL;
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_puda_free_ah - free a puda address handle
+ * @dev: device pointer
+ * @ah: The address handle to free
+ */
+void irdma_puda_free_ah(struct irdma_sc_dev *dev, struct irdma_sc_ah *ah)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	if (!ah)
+		return;
+
+	if (ah->ah_info.ah_valid) {
+		irdma_ah_cqp_op(rf, ah, IRDMA_OP_AH_DESTROY, false, NULL, NULL);
+		irdma_free_rsrc(rf, rf->allocated_ahs, ah->ah_info.ah_idx);
+	}
+
+	kfree(ah);
+}
+
+/**
+ * irdma_gsi_ud_qp_ah_cb - callback after creation of AH for GSI/ID QP
+ * @cqp_request: pointer to cqp_request of create AH
+ */
+void irdma_gsi_ud_qp_ah_cb(struct irdma_cqp_request *cqp_request)
+{
+	struct irdma_sc_ah *sc_ah = cqp_request->param;
+
+	if (!cqp_request->compl_info.op_ret_val)
+		sc_ah->ah_info.ah_valid = true;
+	else
+		sc_ah->ah_info.ah_valid = false;
+}
+
+/**
+ * irdma_prm_add_pble_mem - add moemory to pble resources
+ * @pprm: pble resource manager
+ * @pchunk: chunk of memory to add
+ */
+enum irdma_status_code irdma_prm_add_pble_mem(struct irdma_pble_prm *pprm,
+					      struct irdma_chunk *pchunk)
+{
+	u64 sizeofbitmap;
+
+	if (pchunk->size & 0xfff)
+		return IRDMA_ERR_PARAM;
+
+	sizeofbitmap = (u64)pchunk->size >> pprm->pble_shift;
+
+	pchunk->bitmapmem.size = sizeofbitmap >> 3;
+	pchunk->bitmapmem.va = kzalloc(pchunk->bitmapmem.size, GFP_ATOMIC);
+
+	if (!pchunk->bitmapmem.va)
+		return IRDMA_ERR_NO_MEMORY;
+
+	pchunk->bitmapbuf = pchunk->bitmapmem.va;
+	bitmap_zero(pchunk->bitmapbuf, sizeofbitmap);
+
+	pchunk->sizeofbitmap = sizeofbitmap;
+	/* each pble is 8 bytes hence shift by 3 */
+	pprm->total_pble_alloc += pchunk->size >> 3;
+	pprm->free_pble_cnt += pchunk->size >> 3;
+
+	return 0;
+}
+
+/**
+ * irdma_prm_add_pble_mem - get pble's from prm
+ * @pprm: pble resource manager
+ * @chunkinfo: nformation about chunk where pble's were acquired
+ * @mem_size: size of pble memory needed
+ * @vaddr: returns virtual address of pble memory
+ * @fpm_addr: returns fpm address of pble memory
+ */
+enum irdma_status_code
+irdma_prm_get_pbles(struct irdma_pble_prm *pprm,
+		    struct irdma_pble_chunkinfo *chunkinfo, u32 mem_size,
+		    u64 *vaddr, u64 *fpm_addr)
+{
+	u64 bits_needed;
+	u64 bit_idx = PBLE_INVALID_IDX;
+	struct irdma_chunk *pchunk = NULL;
+	struct list_head *chunk_entry = pprm->clist.next;
+	u32 offset;
+	unsigned long flags;
+	*vaddr = 0;
+	*fpm_addr = 0;
+
+	bits_needed = (mem_size + (1 << pprm->pble_shift) - 1) >> pprm->pble_shift;
+
+	spin_lock_irqsave(&pprm->prm_lock, flags);
+	while (chunk_entry != &pprm->clist) {
+		pchunk = (struct irdma_chunk *)chunk_entry;
+		bit_idx = bitmap_find_next_zero_area(pchunk->bitmapbuf,
+						     pchunk->sizeofbitmap, 0,
+						     bits_needed, 0);
+		if (bit_idx < pchunk->sizeofbitmap)
+			break;
+
+		/* list.next used macro */
+		chunk_entry = pchunk->list.next;
+	}
+
+	if (!pchunk || bit_idx >= pchunk->sizeofbitmap) {
+		spin_unlock_irqrestore(&pprm->prm_lock, flags);
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	bitmap_set(pchunk->bitmapbuf, bit_idx, bits_needed);
+	offset = bit_idx << pprm->pble_shift;
+	*vaddr = pchunk->vaddr + offset;
+	*fpm_addr = pchunk->fpm_addr + offset;
+
+	chunkinfo->pchunk = pchunk;
+	chunkinfo->bit_idx = bit_idx;
+	chunkinfo->bits_used = bits_needed;
+	/* 3 is sizeof pble divide */
+	pprm->free_pble_cnt -= chunkinfo->bits_used << (pprm->pble_shift - 3);
+	spin_unlock_irqrestore(&pprm->prm_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_prm_return pbles - return pbles back to prm
+ * @pprm: pble resource manager
+ * @chunkinfo: chunk where pble's were acquired and to be freed
+ */
+void irdma_prm_return_pbles(struct irdma_pble_prm *pprm,
+			    struct irdma_pble_chunkinfo *chunkinfo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pprm->prm_lock, flags);
+	pprm->free_pble_cnt += chunkinfo->bits_used << (pprm->pble_shift - 3);
+	bitmap_clear(chunkinfo->pchunk->bitmapbuf, chunkinfo->bit_idx,
+		     chunkinfo->bits_used);
+	spin_unlock_irqrestore(&pprm->prm_lock, flags);
+}
+
+/**
+ * irdma_free_paged_mem - free virtual paged memory back to system
+ * @chunk: chunk to free with paged memory
+ */
+void irdma_pble_free_paged_mem(struct irdma_chunk *chunk)
+{
+	struct pci_dev *pcidev = chunk->dev->hw->pdev;
+	int i;
+
+	if (!chunk->pg_cnt)
+		goto done;
+
+	for (i = 0; i < chunk->pg_cnt; i++)
+		dma_unmap_page(&pcidev->dev, chunk->dmainfo.dmaaddrs[i],
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+done:
+	kfree(chunk->dmainfo.dmaaddrs);
+	chunk->dmainfo.dmaaddrs = NULL;
+	vfree((void *)(uintptr_t)chunk->vaddr);
+	chunk->vaddr = 0;
+	chunk->type = 0;
+}
+
+/**
+ * irdma_pble_get_paged_mem -allocate paged memory for pbles
+ * @chunk: chunk to add for paged memory
+ * @pg_cnt: number of pages needed
+ */
+enum irdma_status_code irdma_pble_get_paged_mem(struct irdma_chunk *chunk,
+						int pg_cnt)
+{
+	struct pci_dev *pcidev = chunk->dev->hw->pdev;
+	struct page *page;
+	u8 *addr;
+	u32 size;
+	int i;
+
+	chunk->dmainfo.dmaaddrs = kzalloc(pg_cnt << 3, GFP_KERNEL);
+	if (!chunk->dmainfo.dmaaddrs)
+		return IRDMA_ERR_NO_MEMORY;
+
+	size = PAGE_SIZE * pg_cnt;
+	chunk->vaddr = (uintptr_t)vmalloc(size);
+	if (!chunk->vaddr) {
+		kfree(chunk->dmainfo.dmaaddrs);
+		chunk->dmainfo.dmaaddrs = NULL;
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	chunk->size = size;
+	addr = (u8 *)(uintptr_t)chunk->vaddr;
+
+	for (i = 0; i < pg_cnt; i++) {
+		page = vmalloc_to_page(addr);
+		if (!page)
+			break;
+
+		chunk->dmainfo.dmaaddrs[i] = dma_map_page(&pcidev->dev, page, 0,
+							  PAGE_SIZE,
+							  DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(&pcidev->dev, chunk->dmainfo.dmaaddrs[i]))
+			break;
+
+		addr += PAGE_SIZE;
+	}
+
+	chunk->pg_cnt = i;
+	chunk->type = PBLE_SD_PAGED;
+	if (i == pg_cnt)
+		return 0;
+
+	irdma_pble_free_paged_mem(chunk);
+
+	return IRDMA_ERR_NO_MEMORY;
+}
+
+/**
+ * irdma_alloc_ws_node_id - Allocate a tx scheduler node ID
+ * @dev: device pointer
+ */
+u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+	u32 next = 1;
+	u32 node_id;
+
+	if (irdma_alloc_rsrc(rf, rf->allocated_ws_nodes, rf->max_ws_node_id,
+			     &node_id, &next))
+		return IRDMA_WS_NODE_INVALID;
+
+	return (u16)node_id;
+}
+
+/**
+ * irdma_free_ws_node_id - Free a tx scheduler node ID
+ * @dev: device pointer
+ * @node_id: Work scheduler node ID
+ */
+void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id)
+{
+	struct irdma_pci_f *rf = dev->back_dev;
+
+	irdma_free_rsrc(rf, rf->allocated_ws_nodes, (u32)node_id);
+}
+
+/**
+ * irdma_modify_qp_to_err - Modify a QP to error
+ * @sc_qp: qp structure
+ */
+void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
+{
+	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
+	struct ib_qp_attr attr;
+
+	attr.qp_state = IB_QPS_ERR;
+	irdma_modify_qp(&qp->ibqp, &attr, IB_QP_STATE, NULL);
+}
+
+static void clear_qp_ctx_addr(__le64 *ctx)
+{
+	u64 tmp;
+
+	get_64bit_val(ctx, 272, &tmp);
+	tmp &= GENMASK_ULL(63, 58);
+	set_64bit_val(ctx, 272, tmp);
+
+	get_64bit_val(ctx, 296, &tmp);
+	tmp &= GENMASK_ULL(7, 0);
+	set_64bit_val(ctx, 296, tmp);
+
+	get_64bit_val(ctx, 312, &tmp);
+	tmp &= GENMASK_ULL(7, 0);
+	set_64bit_val(ctx, 312, tmp);
+
+	set_64bit_val(ctx, 368, 0);
+}
+
+/**
+ * irdma_upload_qp_context - upload raw QP context
+ * @iwqp: QP pointer
+ * @freeze: freeze QP
+ * @raw: raw context flag
+ */
+int irdma_upload_qp_context(struct irdma_qp *iwqp, bool freeze, bool raw)
+{
+	struct irdma_dma_mem dma_mem;
+	struct irdma_sc_dev *dev;
+	struct irdma_sc_qp *qp;
+	struct irdma_cqp *iwcqp;
+	struct irdma_cqp_request *cqp_request;
+	struct cqp_cmds_info *cqp_info;
+	struct irdma_upload_context_info *info;
+	struct irdma_pci_f *rf;
+	int ret;
+	u32 *ctx;
+
+	rf = iwqp->iwdev->rf;
+	if (!rf)
+		return -EINVAL;
+
+	qp = &iwqp->sc_qp;
+	dev = &rf->sc_dev;
+	iwcqp = &rf->cqp;
+
+	cqp_request = irdma_get_cqp_request(iwcqp, true);
+	if (!cqp_request)
+		return -EINVAL;
+
+	cqp_info = &cqp_request->info;
+	info = &cqp_info->in.u.qp_upload_context.info;
+	memset(info, 0, sizeof(struct irdma_upload_context_info));
+	cqp_info->cqp_cmd = IRDMA_OP_QP_UPLOAD_CONTEXT;
+	cqp_info->post_sq = 1;
+	cqp_info->in.u.qp_upload_context.dev = dev;
+	cqp_info->in.u.qp_upload_context.scratch = (u64)cqp_request;
+
+	dma_mem.size = ALIGN(PAGE_SIZE, PAGE_SIZE);
+	dma_mem.va = dma_alloc_coherent(hw_to_dev(dev->hw), dma_mem.size,
+					&dma_mem.pa, GFP_KERNEL);
+	if (!dma_mem.va) {
+		irdma_free_cqp_request(&rf->cqp, cqp_request);
+		return -ENOMEM;
+	}
+
+	ctx = dma_mem.va;
+	info->buf_pa = dma_mem.pa;
+	info->raw_format = raw;
+	info->freeze_qp = freeze;
+	info->qp_type = qp->qp_type;	/* 1 is iWARP and 2 UDA */
+	info->qp_id = qp->qp_uk.qp_id;
+
+	ret = irdma_handle_cqp_op(rf, cqp_request);
+	if (ret)
+		goto error;
+
+	dev_dbg(rfdev_to_dev(dev), "QP: PRINT CONTXT QP [%d]\n", info->qp_id);
+	{
+		u32 i, j;
+
+		clear_qp_ctx_addr(dma_mem.va);
+		for (i = 0, j = 0; i < 32; i++, j += 4)
+			dev_dbg(rfdev_to_dev(dev),
+				"QP: %d:\t [%08X %08x %08X %08X]\n", (j * 4),
+				ctx[j], ctx[j + 1], ctx[j + 2], ctx[j + 3]);
+	}
+error:
+	dma_free_coherent(hw_to_dev(dev->hw), dma_mem.size, dma_mem.va,
+			  dma_mem.pa);
+	dma_mem.va = NULL;
+	return ret;
+}
-- 
2.25.2

