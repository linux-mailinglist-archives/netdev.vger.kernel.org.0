Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE2301181
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbhAWAQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:16:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:55257 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbhAVXv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:51:28 -0500
IronPort-SDR: vqws2HlUa2IXCLyUVdmswuYJnpW8Lr6aCi4oRD1l8sc7rGCNANxus41xWc6d2TOOVq9m1tZ+6d
 1zsKbPHZfPuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346871"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346871"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:13 -0800
IronPort-SDR: r1DqBsbtaNaoC/F44EoH/Zm7pzSKIUrvqhaPnZbmJuF+61r3AWunrhgbzf0OVqg4Yap8M6M+vh
 rrgxlFFha/hw==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869443"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:11 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and implement private channel OPs
Date:   Fri, 22 Jan 2021 17:48:12 -0600
Message-Id: <20210122234827.1353-8-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Register irdma as an auxiliary driver which can attach to auxiliary RDMA
devices from Intel PCI netdev drivers i40e and ice. Implement the private
channel ops, add basic devlink support in the driver and register net
notifiers.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/i40iw_if.c | 226 ++++++++++++
 drivers/infiniband/hw/irdma/irdma_if.c | 422 +++++++++++++++++++++++
 drivers/infiniband/hw/irdma/main.c     | 363 +++++++++++++++++++
 drivers/infiniband/hw/irdma/main.h     | 613 +++++++++++++++++++++++++++++++++
 4 files changed, 1624 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h

diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
new file mode 100644
index 0000000..24f1ef5
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#include "main.h"
+#include "i40iw_hw.h"
+#include <linux/net/intel/i40e_client.h>
+
+/**
+ * i40iw_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ *
+ */
+static void i40iw_request_reset(struct irdma_pci_f *rf)
+{
+	struct i40e_info *peer_info = rf->priv_peer_info.peer_info;
+
+	peer_info->ops->request_reset(peer_info, rf->priv_peer_info.client, 1);
+}
+
+/**
+ * i40iw_open - client interface operation open for iwarp/uda device
+ * @peer_info: parent lan device information structure with data/ops
+ * @client: iwarp client information, provided during registration
+ *
+ * Called by the lan driver during the processing of client register
+ * Create device resources, set up queues, pble and hmc objects and
+ * register the device with the ib verbs interface
+ * Return 0 if successful, otherwise return error
+ */
+static int i40iw_open(struct i40e_info *peer_info, struct i40e_client *client)
+{
+	struct irdma_device *iwdev = NULL;
+	struct irdma_handler *hdl = NULL;
+	struct irdma_priv_peer_info *priv_peer_info;
+	struct irdma_sc_dev *dev;
+	struct irdma_pci_f *rf;
+	struct irdma_l2params l2params = {};
+	int err = -EIO;
+	int i;
+	u16 qset;
+	u16 last_qset = IRDMA_NO_QSET;
+
+	hdl = irdma_find_handler(peer_info->pcidev);
+	if (hdl)
+		return 0;
+
+	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
+	if (!hdl)
+		return -ENOMEM;
+
+	rf = &hdl->rf;
+	rf->hdl = hdl;
+	dev = &rf->sc_dev;
+	dev->back_dev = rf;
+	rf->rdma_ver = IRDMA_GEN_1;
+	rf->aux_dev = peer_info->aux_dev;
+	irdma_set_config_params(rf);
+	rf->gen_ops.init_hw = i40iw_init_hw;
+	rf->gen_ops.request_reset = i40iw_request_reset;
+	rf->hw.hw_addr = peer_info->hw_addr;
+	rf->pcidev = peer_info->pcidev;
+	rf->netdev = peer_info->netdev;
+	dev->pci_rev = rf->pcidev->revision;
+
+	priv_peer_info = &rf->priv_peer_info;
+	priv_peer_info->client = client;
+	priv_peer_info->peer_info = peer_info;
+	priv_peer_info->fn_num = peer_info->fid;
+	priv_peer_info->ftype = peer_info->ftype;
+	priv_peer_info->pf_vsi_num = 0;
+	priv_peer_info->msix_count = peer_info->msix_count;
+	priv_peer_info->msix_entries = peer_info->msix_entries;
+
+	if (irdma_ctrl_init_hw(rf)) {
+		err = -EIO;
+		goto err_ctrl_init;
+	}
+
+	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev) {
+		err = -ENOMEM;
+		goto err_ib_alloc;
+	}
+
+	iwdev->rf = rf;
+	iwdev->hdl = hdl;
+	iwdev->init_state = INITIAL_STATE;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = peer_info->netdev;
+	iwdev->vsi_num = 0;
+
+	l2params.mtu =
+		(peer_info->params.mtu) ? peer_info->params.mtu : IRDMA_DEFAULT_MTU;
+	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
+		qset = peer_info->params.qos.prio_qos[i].qs_handle;
+		l2params.up2tc[i] = peer_info->params.qos.prio_qos[i].tc;
+		l2params.qs_handle_list[i] = qset;
+		if (last_qset == IRDMA_NO_QSET)
+			last_qset = qset;
+		else if ((qset != last_qset) && (qset != IRDMA_NO_QSET))
+			iwdev->dcb = true;
+	}
+
+	if (irdma_rt_init_hw(rf, iwdev, &l2params)) {
+		err = -EIO;
+		goto err_rt_init;
+	}
+
+	err = irdma_ib_register_device(iwdev);
+	if (err)
+		goto err_ibreg;
+
+	irdma_add_handler(hdl);
+	irdma_dbg(dev, "INIT: Gen1 VSI open success peer_info=%p\n",
+		  peer_info);
+
+	return 0;
+
+err_ibreg:
+	irdma_rt_deinit_hw(iwdev);
+err_rt_init:
+	ib_dealloc_device(&iwdev->ibdev);
+err_ib_alloc:
+	irdma_ctrl_deinit_hw(rf);
+err_ctrl_init:
+	kfree(hdl);
+
+	return err;
+}
+
+/**
+ * i40iw_l2param_change - handle mss change
+ * @peer_info: parent lan device information structure with data/ops
+ * @client: client for parameter change
+ * @params: new parameters from L2
+ */
+static void i40iw_l2param_change(struct i40e_info *peer_info,
+				 struct i40e_client *client,
+				 struct i40e_params *params)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+
+	iwdev = irdma_get_device(peer_info->netdev);
+	if (!iwdev)
+		return;
+
+	if (iwdev->vsi.mtu != params->mtu) {
+		l2params.mtu_changed = true;
+		l2params.mtu = params->mtu;
+	}
+	irdma_change_l2params(&iwdev->vsi, &l2params);
+	irdma_put_device(iwdev);
+}
+
+/**
+ * i40iw_close - client interface operation close for iwarp/uda device
+ * @peer_info: parent lan device information structure with data/ops
+ * @client: client to close
+ * @reset: flag to indicate close on reset
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void i40iw_close(struct i40e_info *peer_info, struct i40e_client *client,
+			bool reset)
+{
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_device *iwdev;
+
+	hdl = irdma_find_handler(peer_info->pcidev);
+	if (!hdl)
+		return;
+
+	rf = &hdl->rf;
+	iwdev = list_first_entry_or_null(&rf->vsi_dev_list, struct irdma_device,
+					 list);
+	if (!iwdev)
+		return;
+
+	if (reset)
+		iwdev->reset = true;
+
+	irdma_ib_unregister_device(iwdev);
+	irdma_deinit_rf(rf);
+	pr_debug("INIT: Gen1 VSI close complete peer_info=%p\n", peer_info);
+}
+
+/* client interface functions */
+static const struct i40e_client_ops i40e_ops = {
+	.open = i40iw_open,
+	.close = i40iw_close,
+	.l2_param_change = i40iw_l2param_change
+};
+
+static struct i40e_client i40iw_client = {
+	.ops = &i40e_ops,
+	.type = I40E_CLIENT_IWARP,
+};
+
+int i40iw_init_dev(struct auxiliary_device *aux_dev)
+{
+	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
+							       struct i40e_auxiliary_device,
+							       aux_dev);
+	struct i40e_info *peer_info = i40e_adev->ldev;
+
+	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
+	peer_info->client = &i40iw_client;
+	peer_info->aux_dev = aux_dev;
+
+	return peer_info->ops->client_device_register(peer_info);
+}
+
+int i40iw_deinit_dev(struct auxiliary_device *aux_dev)
+{
+	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
+							       struct i40e_auxiliary_device,
+							       aux_dev);
+	struct i40e_info *peer_info = i40e_adev->ldev;
+
+	peer_info->ops->client_device_unregister(peer_info);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/irdma/irdma_if.c b/drivers/infiniband/hw/irdma/irdma_if.c
new file mode 100644
index 0000000..eb58b7e
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/irdma_if.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2018 - 2021 Intel Corporation */
+#include <linux/net/intel/iidc.h>
+#include "main.h"
+#include "ws.h"
+#include "icrdma_hw.h"
+
+/**
+ * irdma_lan_register_qset - Register qset with LAN driver
+ * @vsi: vsi structure
+ * @tc_node: Traffic class node
+ */
+static enum irdma_status_code irdma_lan_register_qset(struct irdma_sc_vsi *vsi,
+						      struct irdma_ws_node *tc_node)
+{
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct iidc_peer_obj *peer_info = iwdev->rf->priv_peer_info.peer_info;
+	struct iidc_res rdma_qset_res = {};
+	int ret;
+
+	rdma_qset_res.cnt_req = 1;
+	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
+	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+	rdma_qset_res.res[0].res.qsets.tc = tc_node->traffic_class;
+	rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+	ret = peer_info->ops->alloc_res(peer_info, &rdma_qset_res, 0);
+	if (ret) {
+		irdma_dbg(vsi->dev, "WS: LAN alloc_res for rdma qset failed.\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	tc_node->l2_sched_node_id = rdma_qset_res.res[0].res.qsets.teid;
+	vsi->qos[tc_node->user_pri].l2_sched_node_id =
+		rdma_qset_res.res[0].res.qsets.teid;
+
+	return 0;
+}
+
+/**
+ * irdma_lan_unregister_qset - Unregister qset with LAN driver
+ * @vsi: vsi structure
+ * @tc_node: Traffic class node
+ */
+static void irdma_lan_unregister_qset(struct irdma_sc_vsi *vsi,
+				      struct irdma_ws_node *tc_node)
+{
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct iidc_peer_obj *peer_info = iwdev->rf->priv_peer_info.peer_info;
+	struct iidc_res rdma_qset_res = {};
+
+	rdma_qset_res.res_allocated = 1;
+	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
+	rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+	rdma_qset_res.res[0].res.qsets.teid = tc_node->l2_sched_node_id;
+	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+
+	if (peer_info->ops->free_res(peer_info, &rdma_qset_res))
+		irdma_dbg(vsi->dev, "WS: LAN free_res for rdma qset failed.\n");
+}
+
+/**
+ * irdma_prep_tc_change - Prepare for TC changes
+ * @peer_info: parent lan device information structure with data/ops
+ */
+static void irdma_prep_tc_change(struct iidc_peer_obj *peer_info)
+{
+	struct irdma_device *iwdev;
+
+	iwdev = irdma_get_device(peer_info->netdev);
+	if (!iwdev)
+		return;
+
+	if (iwdev->vsi.tc_change_pending)
+		goto done;
+
+	iwdev->vsi.tc_change_pending = true;
+	irdma_sc_suspend_resume_qps(&iwdev->vsi, IRDMA_OP_SUSPEND);
+
+	/* Wait for all qp's to suspend */
+	wait_event_timeout(iwdev->suspend_wq,
+			   !atomic_read(&iwdev->vsi.qp_suspend_reqs),
+			   IRDMA_EVENT_TIMEOUT);
+	irdma_ws_reset(&iwdev->vsi);
+done:
+	irdma_put_device(iwdev);
+}
+
+static void irdma_log_invalid_mtu(u16 mtu, struct irdma_sc_dev *dev)
+{
+	if (mtu < IRDMA_MIN_MTU_IPV4)
+		dev_warn(idev_to_dev(dev),
+			 "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 576 for IPv4\n",
+			 mtu);
+	else if (mtu < IRDMA_MIN_MTU_IPV6)
+		dev_warn(idev_to_dev(dev),
+			 "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 1280 for IPv6\\n",
+			 mtu);
+}
+
+/**
+ * irdma_event_handler - Called by LAN driver to notify events
+ * @peer_info: parent lan device information structure with data/ops
+ * @event: event from LAN driver
+ */
+static void irdma_event_handler(struct iidc_peer_obj *peer_info,
+				struct iidc_event *event)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+	int i;
+
+	iwdev = irdma_get_device(peer_info->netdev);
+	if (!iwdev)
+		return;
+
+	if (*event->type & BIT(IIDC_EVENT_LINK_CHANGE)) {
+		irdma_dbg(&iwdev->rf->sc_dev, "CLNT: LINK_CHANGE event\n");
+	} else if (*event->type & BIT(IIDC_EVENT_MTU_CHANGE)) {
+		irdma_dbg(&iwdev->rf->sc_dev, "CLNT: new MTU = %d\n",
+			  event->info.mtu);
+		if (iwdev->vsi.mtu != event->info.mtu) {
+			l2params.mtu = event->info.mtu;
+			l2params.mtu_changed = true;
+			irdma_log_invalid_mtu(l2params.mtu, &iwdev->rf->sc_dev);
+			irdma_change_l2params(&iwdev->vsi, &l2params);
+		}
+	} else if (*event->type & BIT(IIDC_EVENT_TC_CHANGE)) {
+		if (!iwdev->vsi.tc_change_pending)
+			goto done;
+
+		l2params.tc_changed = true;
+		irdma_dbg(&iwdev->rf->sc_dev, "CLNT: TC Change\n");
+		iwdev->dcb = event->info.port_qos.num_tc > 1;
+
+		for (i = 0; i < IIDC_MAX_USER_PRIORITY; ++i)
+			l2params.up2tc[i] = event->info.port_qos.up2tc[i];
+		irdma_change_l2params(&iwdev->vsi, &l2params);
+	} else if (*event->type & BIT(IIDC_EVENT_CRIT_ERR)) {
+		ibdev_warn(&iwdev->ibdev, "ICE OICR event notification: oicr = 0x%08x\n",
+			   event->info.reg);
+		if (event->info.reg & IRDMAPFINT_OICR_PE_CRITERR_M) {
+			u32 pe_criterr;
+
+			pe_criterr = readl(iwdev->rf->sc_dev.hw_regs[IRDMA_GLPE_CRITERR]);
+#define IRDMA_Q1_RESOURCE_ERR 0x0001024d
+			if (pe_criterr != IRDMA_Q1_RESOURCE_ERR) {
+				ibdev_err(&iwdev->ibdev, "critical PE Error, GLPE_CRITERR=0x%08x\n",
+					  pe_criterr);
+				iwdev->rf->reset = true;
+			} else {
+				ibdev_warn(&iwdev->ibdev, "Q1 Resource Check\n");
+			}
+		}
+		if (event->info.reg & IRDMAPFINT_OICR_HMC_ERR_M) {
+			ibdev_err(&iwdev->ibdev, "HMC Error\n");
+			iwdev->rf->reset = true;
+		}
+		if (event->info.reg & IRDMAPFINT_OICR_PE_PUSH_M) {
+			ibdev_err(&iwdev->ibdev, "PE Push Error\n");
+			iwdev->rf->reset = true;
+		}
+		if (iwdev->rf->reset)
+			iwdev->rf->gen_ops.request_reset(iwdev->rf);
+	}
+done:
+	irdma_put_device(iwdev);
+}
+
+/**
+ * irdma_open - client interface operation open for RDMA device
+ * @peer_info: parent lan device information structure with data/ops
+ *
+ * Called by the lan driver during the processing of client
+ * register.
+ */
+static int irdma_open(struct iidc_peer_obj *peer_info)
+{
+	struct irdma_handler *hdl;
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	struct iidc_event events = {};
+	struct irdma_pci_f *rf;
+	struct irdma_priv_peer_info *priv_peer_info;
+	struct irdma_l2params l2params = {};
+	int i, ret;
+
+	hdl = irdma_find_handler(peer_info->pdev);
+	if (!hdl)
+		return -ENODEV;
+
+	rf = &hdl->rf;
+	if (rf->init_state != CEQ0_CREATED)
+		return -EINVAL;
+
+	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
+
+	priv_peer_info = &rf->priv_peer_info;
+	priv_peer_info->pf_vsi_num = peer_info->pf_vsi_num;
+	dev = &hdl->rf.sc_dev;
+
+	iwdev->hdl = hdl;
+	iwdev->rf = rf;
+	iwdev->roce_cwnd = IRDMA_ROCE_CWND_DEFAULT;
+	iwdev->roce_ackcreds = IRDMA_ROCE_ACKCREDS_DEFAULT;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = peer_info->netdev;
+	if (rf->protocol_used == IRDMA_ROCE_PROTOCOL_ONLY)
+		iwdev->roce_mode = true;
+
+	l2params.mtu = peer_info->netdev->mtu;
+	l2params.num_tc = peer_info->initial_qos_info.num_tc;
+	l2params.num_apps = peer_info->initial_qos_info.num_apps;
+	l2params.vsi_prio_type = peer_info->initial_qos_info.vsi_priority_type;
+	l2params.vsi_rel_bw = peer_info->initial_qos_info.vsi_relative_bw;
+	for (i = 0; i < l2params.num_tc; i++) {
+		l2params.tc_info[i].egress_virt_up =
+			peer_info->initial_qos_info.tc_info[i].egress_virt_up;
+		l2params.tc_info[i].ingress_virt_up =
+			peer_info->initial_qos_info.tc_info[i].ingress_virt_up;
+		l2params.tc_info[i].prio_type =
+			peer_info->initial_qos_info.tc_info[i].prio_type;
+		l2params.tc_info[i].rel_bw =
+			peer_info->initial_qos_info.tc_info[i].rel_bw;
+		l2params.tc_info[i].tc_ctx =
+			peer_info->initial_qos_info.tc_info[i].tc_ctx;
+	}
+	for (i = 0; i < IIDC_MAX_USER_PRIORITY; i++)
+		l2params.up2tc[i] = peer_info->initial_qos_info.up2tc[i];
+
+	iwdev->vsi_num = peer_info->pf_vsi_num;
+	peer_info->ops->update_vsi_filter(peer_info, IIDC_RDMA_FILTER_BOTH, true);
+
+	if (irdma_rt_init_hw(rf, iwdev, &l2params)) {
+		ib_dealloc_device(&iwdev->ibdev);
+		return -EIO;
+	}
+
+	ret = irdma_ib_register_device(iwdev);
+	if (ret) {
+		irdma_rt_deinit_hw(iwdev);
+		ib_dealloc_device(&iwdev->ibdev);
+		return ret;
+	}
+
+	events.reporter = peer_info;
+	set_bit(IIDC_EVENT_LINK_CHANGE, events.type);
+	set_bit(IIDC_EVENT_MTU_CHANGE, events.type);
+	set_bit(IIDC_EVENT_TC_CHANGE, events.type);
+	set_bit(IIDC_EVENT_CRIT_ERR, events.type);
+
+	peer_info->ops->reg_for_notification(peer_info, &events);
+	irdma_dbg(dev, "INIT: Gen2 VSI[%d] open success peer_info=%p\n",
+		  peer_info->pf_vsi_num, peer_info);
+
+	return 0;
+}
+
+/**
+ * irdma_close - client interface operation close for iwarp/uda device
+ * @peer_info: parent lan device information structure with data/ops
+ * @reason: reason for closing
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void irdma_close(struct iidc_peer_obj *peer_info, enum iidc_close_reason reason)
+{
+	struct irdma_handler *hdl;
+	struct irdma_device *iwdev;
+	struct irdma_pci_f *rf;
+
+	hdl = irdma_find_handler(peer_info->pdev);
+	if (!hdl)
+		return;
+
+	rf = &hdl->rf;
+	iwdev = list_first_entry_or_null(&rf->vsi_dev_list, struct irdma_device,
+					 list);
+	if (!iwdev)
+		return;
+	if (reason == IIDC_REASON_GLOBR_REQ || reason == IIDC_REASON_CORER_REQ ||
+	    reason == IIDC_REASON_PFR_REQ || rf->reset) {
+		iwdev->reset = true;
+		rf->reset = true;
+	}
+
+	irdma_ib_unregister_device(iwdev);
+	if (!rf->reset)
+		peer_info->ops->update_vsi_filter(peer_info, IIDC_RDMA_FILTER_BOTH, false);
+
+	pr_debug("INIT: Gen2 VSI[%d] close complete peer_info=%p\n",
+		 peer_info->pf_vsi_num, peer_info);
+}
+
+/**
+ * irdma_deinit_dev - GEN_2 device deinit
+ * @aux_dev: auxiliary device
+ *
+ * Called on module unload.
+ */
+int irdma_deinit_dev(struct auxiliary_device *aux_dev)
+{
+	struct iidc_auxiliary_object *vo = container_of(aux_dev,
+							struct iidc_auxiliary_object,
+							adev);
+	struct iidc_peer_obj *peer_info = vo->peer_obj;
+	struct irdma_handler *hdl;
+
+	hdl = irdma_find_handler(peer_info->pdev);
+	if (!hdl)
+		return 0;
+
+	peer_info->ops->peer_unregister(peer_info);
+
+	irdma_deinit_rf(&hdl->rf);
+
+	pr_debug("INIT: Gen2 device remove success peer_info=%p\n", peer_info);
+
+	return 0;
+}
+
+static const struct iidc_peer_ops irdma_peer_ops = {
+	.close = irdma_close,
+	.event_handler = irdma_event_handler,
+	.open = irdma_open,
+	.prep_tc_change = irdma_prep_tc_change,
+};
+
+static struct iidc_peer_drv irdma_peer_drv = {
+	.driver_id = IIDC_PEER_RDMA_DRIVER,
+	.name = KBUILD_MODNAME,
+};
+
+/**
+ * icrdma_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ */
+static void icrdma_request_reset(struct irdma_pci_f *rf)
+{
+	struct iidc_peer_obj *peer_info = rf->priv_peer_info.peer_info;
+
+	dev_warn(idev_to_dev(&rf->sc_dev), "Requesting a reset\n");
+	peer_info->ops->request_reset(peer_info, IIDC_PEER_PFR);
+}
+
+/**
+ * irdma_init_dev - GEN_2 device init
+ * @aux_dev: auxiliary device
+ *
+ * Create device resources, set up queues, pble and hmc objects.
+ * Return 0 if successful, otherwise return error
+ */
+int irdma_init_dev(struct auxiliary_device *aux_dev)
+{
+	struct iidc_auxiliary_object *vo = container_of(aux_dev,
+							struct iidc_auxiliary_object,
+							adev);
+	struct iidc_peer_obj *peer_info = vo->peer_obj;
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_sc_dev *dev;
+	struct irdma_priv_peer_info *priv_peer_info;
+	int err;
+
+	hdl = irdma_find_handler(peer_info->pdev);
+	if (hdl)
+		return -EBUSY;
+
+	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
+	if (!hdl)
+		return -ENOMEM;
+
+	rf = &hdl->rf;
+	priv_peer_info = &rf->priv_peer_info;
+	rf->aux_dev = aux_dev;
+	rf->hdl = hdl;
+	dev = &rf->sc_dev;
+	dev->back_dev = rf;
+	rf->gen_ops.init_hw = icrdma_init_hw;
+	rf->gen_ops.request_reset = icrdma_request_reset;
+	rf->gen_ops.register_qset = irdma_lan_register_qset;
+	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
+	priv_peer_info->peer_info = peer_info;
+	rf->rdma_ver = IRDMA_GEN_2;
+	irdma_set_config_params(rf);
+	dev->pci_rev = peer_info->pdev->revision;
+	rf->default_vsi.vsi_idx = peer_info->pf_vsi_num;
+	/* save information from peer_info to priv_peer_info*/
+	priv_peer_info->fn_num = PCI_FUNC(peer_info->pdev->devfn);
+	rf->hw.hw_addr = peer_info->hw_addr;
+	rf->pcidev = peer_info->pdev;
+	rf->netdev = peer_info->netdev;
+	priv_peer_info->ftype = peer_info->ftype;
+	priv_peer_info->msix_count = peer_info->msix_count;
+	priv_peer_info->msix_entries = peer_info->msix_entries;
+	irdma_add_handler(hdl);
+	if (irdma_ctrl_init_hw(rf)) {
+		err = -EIO;
+		goto err_ctrl_init;
+	}
+	peer_info->peer_ops = &irdma_peer_ops;
+	peer_info->peer_drv = &irdma_peer_drv;
+	err = peer_info->ops->peer_register(peer_info);
+	if (err)
+		goto err_peer_reg;
+
+	irdma_dbg(dev, "INIT: Gen2 device probe success peer_info=%p\n",
+		  peer_info);
+
+	return 0;
+
+err_peer_reg:
+	irdma_ctrl_deinit_hw(rf);
+err_ctrl_init:
+	irdma_del_handler(rf->hdl);
+	kfree(rf->hdl);
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
new file mode 100644
index 0000000..16286e9
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#include "main.h"
+
+bool irdma_upload_context;
+
+MODULE_AUTHOR("Intel Corporation, <e1000-rdma@lists.sourceforge.net>");
+MODULE_DESCRIPTION("Intel(R) Ethernet Protocol Driver for RDMA");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static struct notifier_block irdma_inetaddr_notifier = {
+	.notifier_call = irdma_inetaddr_event
+};
+
+static struct notifier_block irdma_inetaddr6_notifier = {
+	.notifier_call = irdma_inet6addr_event
+};
+
+static struct notifier_block irdma_net_notifier = {
+	.notifier_call = irdma_net_event
+};
+
+static struct notifier_block irdma_netdevice_notifier = {
+	.notifier_call = irdma_netdevice_event
+};
+
+static void irdma_register_notifiers(void)
+{
+	register_inetaddr_notifier(&irdma_inetaddr_notifier);
+	register_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	register_netevent_notifier(&irdma_net_notifier);
+	register_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+static void irdma_unregister_notifiers(void)
+{
+	unregister_netevent_notifier(&irdma_net_notifier);
+	unregister_inetaddr_notifier(&irdma_inetaddr_notifier);
+	unregister_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	unregister_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+/**
+ * set_protocol_used - set protocol_used against HW generation and roce_ena flag
+ * @rf: RDMA PCI function
+ * @roce_ena: RoCE enabled flag
+ */
+static void set_protocol_used(struct irdma_pci_f *rf, bool roce_ena)
+{
+	switch (rf->rdma_ver) {
+	case IRDMA_GEN_2:
+		rf->protocol_used = roce_ena ? IRDMA_ROCE_PROTOCOL_ONLY :
+					       IRDMA_IWARP_PROTOCOL_ONLY;
+		break;
+	case IRDMA_GEN_1:
+		rf->protocol_used = IRDMA_IWARP_PROTOCOL_ONLY;
+		break;
+	}
+}
+
+void irdma_set_config_params(struct irdma_pci_f *rf)
+{
+	struct irdma_drvdata *drvdata = dev_get_drvdata(&rf->aux_dev->dev);
+	struct irdma_dl_priv *dl_priv = devlink_priv(drvdata->dl);
+
+	rf->rsrc_profile = IRDMA_HMC_PROFILE_DEFAULT;
+	rf->limits_sel = dl_priv->limits_sel;
+	set_protocol_used(rf, dl_priv->roce_ena);
+	rf->rst_to = IRDMA_RST_TIMEOUT_HZ;
+}
+
+static int irdma_devlink_rsrc_limits_validate(struct devlink *dl, u32 id,
+					      union devlink_param_value val,
+					      struct netlink_ext_ack *extack)
+{
+	u8 value = val.vu8;
+
+	if (value > 7) {
+		NL_SET_ERR_MSG_MOD(extack, "resource limits selector range is (0-7)");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int irdma_devlink_enable_roce_validate(struct devlink *dl, u32 id,
+					      union devlink_param_value val,
+					      struct netlink_ext_ack *extack)
+{
+	struct irdma_dl_priv *priv = devlink_priv(dl);
+	bool value = val.vbool;
+
+	if (value && priv->drvdata->hw_ver == IRDMA_GEN_1) {
+		NL_SET_ERR_MSG_MOD(extack, "RoCE not supported on device");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int irdma_devlink_upload_ctx_get(struct devlink *devlink, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	ctx->val.vbool = irdma_upload_context;
+	return 0;
+}
+
+static int irdma_devlink_upload_ctx_set(struct devlink *devlink, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	irdma_upload_context = ctx->val.vbool;
+	return 0;
+}
+
+enum irdma_dl_param_id {
+	IRDMA_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
+	IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
+};
+
+static const struct devlink_param irdma_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
+			     "resource_limits_selector", DEVLINK_PARAM_TYPE_U8,
+			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, irdma_devlink_rsrc_limits_validate),
+	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
+			     "upload_context", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     irdma_devlink_upload_ctx_get,
+			     irdma_devlink_upload_ctx_set, NULL),
+	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, irdma_devlink_enable_roce_validate),
+};
+
+static int irdma_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				     enum devlink_reload_action action,
+				     enum devlink_reload_limit limit,
+				     struct netlink_ext_ack *extack)
+{
+	struct irdma_dl_priv *priv = devlink_priv(devlink);
+	struct auxiliary_device *aux_dev = to_auxiliary_dev(devlink->dev);
+
+	if (netns_change) {
+		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	priv->drvdata->deinit_dev(aux_dev);
+
+	return 0;
+}
+
+static int irdma_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				   enum devlink_reload_limit limit, u32 *actions_performed,
+				   struct netlink_ext_ack *extack)
+{
+	struct irdma_dl_priv *priv = devlink_priv(devlink);
+	struct auxiliary_device *aux_dev = to_auxiliary_dev(devlink->dev);
+	union devlink_param_value saved_value;
+	int ret;
+
+	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+
+	devlink_param_driverinit_value_get(devlink,
+				DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+				&saved_value);
+	priv->roce_ena = saved_value.vbool;
+	devlink_param_driverinit_value_get(devlink,
+				IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
+				&saved_value);
+	priv->limits_sel = saved_value.vbool;
+
+	ret = priv->drvdata->init_dev(aux_dev);
+
+	return ret;
+}
+
+static const struct devlink_ops irdma_devlink_ops = {
+	.reload_up = irdma_devlink_reload_up,
+	.reload_down = irdma_devlink_reload_down,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+};
+
+static void irdma_devlink_unregister(struct device *dev)
+{
+	struct irdma_drvdata *drvdata = dev_get_drvdata(dev);
+	struct devlink *devlink = drvdata->dl;
+
+	devlink_reload_disable(devlink);
+	devlink_params_unregister(devlink, irdma_devlink_params,
+				  ARRAY_SIZE(irdma_devlink_params));
+	devlink_unregister(devlink);
+	devlink_free(devlink);
+}
+
+static int irdma_devlink_register(struct device *dev, struct irdma_drvdata *drvdata)
+{
+	struct devlink *devlink;
+	struct irdma_dl_priv *priv;
+	union devlink_param_value value;
+	int ret;
+
+	devlink = devlink_alloc(&irdma_devlink_ops, sizeof(struct irdma_dl_priv));
+	if (!devlink)
+		return -ENOMEM;
+
+	priv = devlink_priv(devlink);
+	priv->limits_sel = (drvdata->hw_ver >= IRDMA_GEN_2) ? 0 : 2;
+	priv->drvdata = drvdata;
+
+	drvdata->dl = devlink;
+
+	ret = devlink_register(devlink, dev);
+	if (ret)
+		goto err_dl_free;
+
+	ret = devlink_params_register(devlink, irdma_devlink_params,
+				      ARRAY_SIZE(irdma_devlink_params));
+	if (ret)
+		goto err_dl_unreg;
+
+	value.vu8 = priv->limits_sel;
+	devlink_param_driverinit_value_set(devlink,
+				IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR, value);
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+				IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT, value);
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+				DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE, value);
+	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
+
+	return 0;
+
+err_dl_unreg:
+	devlink_unregister(devlink);
+err_dl_free:
+	devlink_free(devlink);
+
+	return ret;
+}
+
+static int irdma_probe(struct auxiliary_device *aux_dev,
+		       const struct auxiliary_device_id *id)
+{
+	struct irdma_drvdata *drvdata;
+	int ret;
+
+	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	switch (id->driver_data) {
+	case IRDMA_GEN_2:
+		drvdata->init_dev = irdma_init_dev;
+		drvdata->deinit_dev = irdma_deinit_dev;
+		break;
+	case IRDMA_GEN_1:
+		drvdata->init_dev = i40iw_init_dev;
+		drvdata->deinit_dev = i40iw_deinit_dev;
+		break;
+	default:
+		ret = -ENODEV;
+		goto ver_err;
+	}
+
+	drvdata->hw_ver = id->driver_data;
+	ret = irdma_devlink_register(&aux_dev->dev, drvdata);
+	if (ret)
+		goto ver_err;
+
+	dev_set_drvdata(&aux_dev->dev, drvdata);
+	ret = drvdata->init_dev(aux_dev);
+	if (ret)
+		goto probe_err;
+
+	return 0;
+
+probe_err:
+	irdma_devlink_unregister(&aux_dev->dev);
+ver_err:
+	kfree(drvdata);
+
+	return ret;
+}
+
+static void irdma_remove(struct auxiliary_device *aux_dev)
+{
+	struct irdma_drvdata *drvdata = dev_get_drvdata(&aux_dev->dev);
+
+	drvdata->deinit_dev(aux_dev);
+	irdma_devlink_unregister(&aux_dev->dev);
+
+	kfree(drvdata);
+}
+
+static int irdma_suspend(struct auxiliary_device *aux_dev, pm_message_t state)
+{
+	struct irdma_drvdata *drvdata = dev_get_drvdata(&aux_dev->dev);
+
+	drvdata->deinit_dev(aux_dev);
+
+	return 0;
+}
+
+static int irdma_resume(struct auxiliary_device *aux_dev)
+{
+	struct irdma_drvdata *drvdata = dev_get_drvdata(&aux_dev->dev);
+
+	return drvdata->init_dev(aux_dev);
+}
+
+static const struct auxiliary_device_id irdma_auxiliary_id_table[] = {
+	{.name = IRDMA_ICE_AUXDEV_NAME, .driver_data = IRDMA_GEN_2},
+	{.name = IRDMA_I40E_AUXDEV_NAME, .driver_data = IRDMA_GEN_1},
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, irdma_auxiliary_id_table);
+
+static struct auxiliary_driver irdma_auxiliary_drv = {
+	.id_table = irdma_auxiliary_id_table,
+	.probe = irdma_probe,
+	.remove = irdma_remove,
+	.resume = irdma_resume,
+	.suspend = irdma_suspend,
+};
+
+/**
+ * irdma_init_module - driver initialization function
+ *
+ * First function to call when the driver is loaded
+ * Register the driver as ice client and port mapper client
+ */
+static int __init irdma_init_module(void)
+{
+	int ret;
+
+	ret = auxiliary_driver_register(&irdma_auxiliary_drv);
+	if (ret) {
+		pr_err("Failed irdma auxiliary_driver_register()\n");
+		return ret;
+	}
+	irdma_register_notifiers();
+
+	return 0;
+}
+
+/**
+ * irdma_exit_module - driver exit clean up function
+ *
+ * The function is called just before the driver is unloaded
+ * Unregister the driver as ice client and port mapper client
+ */
+static void __exit irdma_exit_module(void)
+{
+	irdma_unregister_notifiers();
+	auxiliary_driver_unregister(&irdma_auxiliary_drv);
+}
+
+module_init(irdma_init_module);
+module_exit(irdma_exit_module);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
new file mode 100644
index 0000000..8559092
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -0,0 +1,613 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#ifndef IRDMA_MAIN_H
+#define IRDMA_MAIN_H
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/if_vlan.h>
+#include <net/addrconf.h>
+#include <net/netevent.h>
+#include <net/devlink.h>
+#include <net/tcp.h>
+#include <net/ip6_route.h>
+#include <net/flow.h>
+#include <net/secure_seq.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/crc32c.h>
+#include <linux/kthread.h>
+#include <linux/auxiliary_bus.h>
+#include <crypto/hash.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/rdma_cm.h>
+#include <rdma/iw_cm.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_cache.h>
+#include <rdma/uverbs_ioctl.h>
+#include "status.h"
+#include "osdep.h"
+#include "defs.h"
+#include "hmc.h"
+#include "type.h"
+#include "ws.h"
+#include "protos.h"
+#include "pble.h"
+#include "cm.h"
+#include <rdma/irdma-abi.h>
+#include "verbs.h"
+#include "user.h"
+#include "puda.h"
+
+extern struct list_head irdma_handlers;
+extern spinlock_t irdma_handler_lock;
+extern bool irdma_upload_context;
+
+#define IRDMA_FW_VER_DEFAULT	2
+#define IRDMA_HW_VER	        2
+
+#define IRDMA_ARP_ADD		1
+#define IRDMA_ARP_DELETE	2
+#define IRDMA_ARP_RESOLVE	3
+
+#define IRDMA_MACIP_ADD		1
+#define IRDMA_MACIP_DELETE	2
+
+#define IW_CCQ_SIZE	(IRDMA_CQP_SW_SQSIZE_2048 + 1)
+#define IW_CEQ_SIZE	2048
+#define IW_AEQ_SIZE	2048
+
+#define RX_BUF_SIZE	(1536 + 8)
+#define IW_REG0_SIZE	(4 * 1024)
+#define IW_TX_TIMEOUT	(6 * HZ)
+#define IW_FIRST_QPN	1
+
+#define IW_SW_CONTEXT_ALIGN	1024
+
+#define MAX_DPC_ITERATIONS	128
+
+#define IRDMA_EVENT_TIMEOUT		50000
+#define IRDMA_VCHNL_EVENT_TIMEOUT	100000
+#define IRDMA_RST_TIMEOUT_HZ		4
+
+#define	IRDMA_NO_QSET	0xffff
+
+#define IW_CFG_FPM_QP_COUNT		32768
+#define IRDMA_MAX_PAGES_PER_FMR		512
+#define IRDMA_MIN_PAGES_PER_FMR		1
+#define IRDMA_CQP_COMPL_RQ_WQE_FLUSHED	2
+#define IRDMA_CQP_COMPL_SQ_WQE_FLUSHED	3
+
+#define IRDMA_Q_TYPE_PE_AEQ	0x80
+#define IRDMA_Q_INVALID_IDX	0xffff
+#define IRDMA_REM_ENDPOINT_TRK_QPID	3
+
+#define IRDMA_DRV_OPT_ENA_MPA_VER_0		0x00000001
+#define IRDMA_DRV_OPT_DISABLE_MPA_CRC		0x00000002
+#define IRDMA_DRV_OPT_DISABLE_FIRST_WRITE	0x00000004
+#define IRDMA_DRV_OPT_DISABLE_INTF		0x00000008
+#define IRDMA_DRV_OPT_ENA_MSI			0x00000010
+#define IRDMA_DRV_OPT_DUAL_LOGICAL_PORT		0x00000020
+#define IRDMA_DRV_OPT_NO_INLINE_DATA		0x00000080
+#define IRDMA_DRV_OPT_DISABLE_INT_MOD		0x00000100
+#define IRDMA_DRV_OPT_DISABLE_VIRT_WQ		0x00000200
+#define IRDMA_DRV_OPT_ENA_PAU			0x00000400
+#define IRDMA_DRV_OPT_MCAST_LOGPORT_MAP		0x00000800
+
+#define IW_HMC_OBJ_TYPE_NUM	ARRAY_SIZE(iw_hmc_obj_types)
+#define IRDMA_ROCE_CWND_DEFAULT			0x400
+#define IRDMA_ROCE_ACKCREDS_DEFAULT		0x1E
+
+#define IRDMA_FLUSH_SQ		BIT(0)
+#define IRDMA_FLUSH_RQ		BIT(1)
+#define IRDMA_REFLUSH		BIT(2)
+#define IRDMA_FLUSH_WAIT	BIT(3)
+
+#define IRDMA_ICE_AUXDEV_NAME	"ice.intel_rdma"
+#define IRDMA_I40E_AUXDEV_NAME	"i40e.intel_rdma"
+
+enum init_completion_state {
+	INVALID_STATE = 0,
+	INITIAL_STATE,
+	CQP_CREATED,
+	HMC_OBJS_CREATED,
+	HW_RSRC_INITIALIZED,
+	CCQ_CREATED,
+	CEQ0_CREATED, /* Last state of probe */
+	ILQ_CREATED,
+	IEQ_CREATED,
+	CEQS_CREATED,
+	PBLE_CHUNK_MEM,
+	AEQ_CREATED,
+	IP_ADDR_REGISTERED,  /* Last state of open */
+};
+
+struct irdma_rsrc_limits {
+	u32 qplimit;
+	u32 mrlimit;
+	u32 cqlimit;
+};
+
+struct irdma_cqp_err_info {
+	u16 maj;
+	u16 min;
+	const char *desc;
+};
+
+struct irdma_cqp_compl_info {
+	u32 op_ret_val;
+	u16 maj_err_code;
+	u16 min_err_code;
+	bool error;
+	u8 op_code;
+};
+
+struct irdma_cqp_request {
+	struct cqp_cmds_info info;
+	wait_queue_head_t waitq;
+	struct list_head list;
+	refcount_t refcnt;
+	void (*callback_fcn)(struct irdma_cqp_request *cqp_request);
+	void *param;
+	struct irdma_cqp_compl_info compl_info;
+	bool waiting:1;
+	bool request_done:1;
+	bool dynamic:1;
+};
+
+struct irdma_cqp {
+	struct irdma_sc_cqp sc_cqp;
+	spinlock_t req_lock; /* protect CQP request list */
+	spinlock_t compl_lock; /* protect CQP completion processing */
+	wait_queue_head_t waitq;
+	wait_queue_head_t remove_wq;
+	struct irdma_dma_mem sq;
+	struct irdma_dma_mem host_ctx;
+	u64 *scratch_array;
+	struct irdma_cqp_request *cqp_requests;
+	struct list_head cqp_avail_reqs;
+	struct list_head cqp_pending_reqs;
+};
+
+struct irdma_ccq {
+	struct irdma_sc_cq sc_cq;
+	struct irdma_dma_mem mem_cq;
+	struct irdma_dma_mem shadow_area;
+};
+
+struct irdma_ceq {
+	struct irdma_sc_ceq sc_ceq;
+	struct irdma_dma_mem mem;
+	u32 irq;
+	u32 msix_idx;
+	struct irdma_pci_f *rf;
+	struct tasklet_struct dpc_tasklet;
+	spinlock_t ce_lock; /* sync cq destroy with cq completion event notification */
+};
+
+struct irdma_aeq {
+	struct irdma_sc_aeq sc_aeq;
+	struct irdma_dma_mem mem;
+	struct irdma_pble_alloc palloc;
+	bool virtual_map;
+};
+
+struct irdma_arp_entry {
+	u32 ip_addr[4];
+	u8 mac_addr[ETH_ALEN];
+};
+
+struct irdma_msix_vector {
+	u32 idx;
+	u32 irq;
+	u32 cpu_affinity;
+	u32 ceq_id;
+	cpumask_t mask;
+};
+
+struct virtchnl_work {
+	struct work_struct work;
+	union {
+		struct irdma_cqp_request *cqp_request;
+		struct irdma_virtchnl_work_info work_info;
+	};
+};
+
+struct irdma_mc_table_info {
+	u32 mgn;
+	u32 dest_ip[4];
+	bool lan_fwd:1;
+	bool ipv4_valid:1;
+};
+
+struct mc_table_list {
+	struct list_head list;
+	struct irdma_mc_table_info mc_info;
+	struct irdma_mcast_grp_info mc_grp_ctx;
+};
+
+struct irdma_qv_info {
+	u32 v_idx; /* msix_vector */
+	u16 ceq_idx;
+	u16 aeq_idx;
+	u8 itr_idx;
+};
+
+struct irdma_qvlist_info {
+	u32 num_vectors;
+	struct irdma_qv_info qv_info[1];
+};
+
+struct irdma_priv_peer_info {
+	unsigned int fn_num;
+	bool ftype;
+	u16 pf_vsi_num;
+	u16 msix_count;
+	struct msix_entry *msix_entries;
+	void *client;
+	void *peer_info;
+};
+
+struct irdma_dl_priv {
+	struct irdma_drvdata *drvdata;
+	u8 limits_sel;
+	bool roce_ena:1;
+};
+
+struct irdma_drvdata {
+	struct devlink *dl;
+	enum irdma_vers hw_ver;
+	int (*init_dev)(struct auxiliary_device *aux_dev);
+	int (*deinit_dev)(struct auxiliary_device *aux_dev);
+};
+
+struct irdma_gen_ops {
+	void (*init_hw)(struct irdma_sc_dev *dev);
+	void (*request_reset)(struct irdma_pci_f *rf);
+	enum irdma_status_code (*register_qset)(struct irdma_sc_vsi *vsi,
+						struct irdma_ws_node *tc_node);
+	void (*unregister_qset)(struct irdma_sc_vsi *vsi,
+				struct irdma_ws_node *tc_node);
+};
+
+struct irdma_pci_f {
+	bool reset:1;
+	bool rsrc_created:1;
+	bool msix_shared:1;
+	u8 rsrc_profile;
+	u8 max_rdma_vfs;
+	u8 max_ena_vfs;
+	u8 *hmc_info_mem;
+	u8 *mem_rsrc;
+	u8 rdma_ver;
+	u8 rst_to;
+	enum irdma_protocol_used protocol_used;
+	u32 sd_type;
+	u32 msix_count;
+	u32 max_mr;
+	u32 max_qp;
+	u32 max_cq;
+	u32 max_ah;
+	u32 next_ah;
+	u32 max_mcg;
+	u32 next_mcg;
+	u32 max_pd;
+	u32 next_qp;
+	u32 next_cq;
+	u32 next_pd;
+	u32 max_mr_size;
+	u32 max_cqe;
+	u32 mr_stagmask;
+	u32 used_pds;
+	u32 used_cqs;
+	u32 used_mrs;
+	u32 used_qps;
+	u32 arp_table_size;
+	u32 next_arp_index;
+	u32 ceqs_count;
+	u32 next_ws_node_id;
+	u32 max_ws_node_id;
+	u32 limits_sel;
+	unsigned long *allocated_ws_nodes;
+	unsigned long *allocated_qps;
+	unsigned long *allocated_cqs;
+	unsigned long *allocated_mrs;
+	unsigned long *allocated_pds;
+	unsigned long *allocated_mcgs;
+	unsigned long *allocated_ahs;
+	unsigned long *allocated_arps;
+	enum init_completion_state init_state;
+	struct irdma_sc_dev sc_dev;
+	struct list_head vsi_dev_list;
+	struct irdma_priv_peer_info priv_peer_info;
+	struct irdma_dl_priv *dl_priv;
+	struct irdma_handler *hdl;
+	struct auxiliary_device *aux_dev;
+	struct pci_dev *pcidev;
+	struct net_device *netdev;
+	struct irdma_hw hw;
+	struct irdma_cqp cqp;
+	struct irdma_ccq ccq;
+	struct irdma_aeq aeq;
+	struct irdma_ceq *ceqlist;
+	struct irdma_hmc_pble_rsrc *pble_rsrc;
+	struct irdma_arp_entry *arp_table;
+	spinlock_t arp_lock; /*protect ARP table access*/
+	spinlock_t rsrc_lock; /* protect HW resource array access */
+	spinlock_t qptable_lock; /*protect QP table access*/
+	struct irdma_qp **qp_table;
+	spinlock_t qh_list_lock; /* protect mc_qht_list */
+	struct mc_table_list mc_qht_list;
+	struct irdma_msix_vector *iw_msixtbl;
+	struct irdma_qvlist_info *iw_qvlist;
+	struct tasklet_struct dpc_tasklet;
+	struct irdma_dma_mem obj_mem;
+	struct irdma_dma_mem obj_next;
+	atomic_t vchnl_msgs;
+	wait_queue_head_t vchnl_waitq;
+	struct workqueue_struct *cqp_cmpl_wq;
+	struct work_struct cqp_cmpl_work;
+	struct virtchnl_work virtchnl_w[IRDMA_MAX_PE_ENA_VF_COUNT];
+	struct irdma_sc_vsi default_vsi;
+	void *back_fcn;
+	struct irdma_gen_ops gen_ops;
+};
+
+struct irdma_device {
+	struct ib_device ibdev;
+	struct irdma_pci_f *rf;
+	struct irdma_priv_peer_info *priv_peer_info;
+	struct net_device *netdev;
+	struct irdma_handler *hdl;
+	struct workqueue_struct *cleanup_wq;
+	struct irdma_sc_vsi vsi;
+	struct irdma_cm_core cm_core;
+	struct list_head list;
+	u32 roce_cwnd;
+	u32 roce_ackcreds;
+	u32 vendor_id;
+	u32 vendor_part_id;
+	u32 device_cap_flags;
+	u32 push_mode;
+	u32 rcv_wnd;
+	u16 mac_ip_table_idx;
+	u16 vsi_num;
+	u8 rcv_wscale;
+	u8 iw_status;
+	bool roce_mode:1;
+	bool roce_dcqcn_en:1;
+	bool dcb:1;
+	bool reset:1;
+	bool iw_ooo:1;
+	enum init_completion_state init_state;
+
+	wait_queue_head_t suspend_wq;
+};
+
+struct irdma_handler {
+	struct list_head list;
+	struct irdma_pci_f rf;
+	bool shared_res_created;
+};
+
+static inline struct irdma_device *to_iwdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct irdma_device, ibdev);
+}
+
+static inline struct irdma_ucontext *to_ucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct irdma_ucontext, ibucontext);
+}
+
+static inline struct irdma_user_mmap_entry *
+to_irdma_mmap_entry(struct rdma_user_mmap_entry *rdma_entry)
+{
+	return container_of(rdma_entry, struct irdma_user_mmap_entry,
+			    rdma_entry);
+}
+
+static inline struct irdma_pd *to_iwpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct irdma_pd, ibpd);
+}
+
+static inline struct irdma_ah *to_iwah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct irdma_ah, ibah);
+}
+
+static inline struct irdma_mr *to_iwmr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct irdma_mr, ibmr);
+}
+
+static inline struct irdma_mr *to_iwmw(struct ib_mw *ibmw)
+{
+	return container_of(ibmw, struct irdma_mr, ibmw);
+}
+
+static inline struct irdma_cq *to_iwcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct irdma_cq, ibcq);
+}
+
+static inline struct irdma_qp *to_iwqp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct irdma_qp, ibqp);
+}
+
+/**
+ * irdma_alloc_resource - allocate a resource
+ * @iwdev: device pointer
+ * @resource_array: resource bit array:
+ * @max_resources: maximum resource number
+ * @req_resources_num: Allocated resource number
+ * @next: next free id
+ **/
+static inline int irdma_alloc_rsrc(struct irdma_pci_f *rf,
+				   unsigned long *rsrc_array, u32 max_rsrc,
+				   u32 *req_rsrc_num, u32 *next)
+{
+	u32 rsrc_num;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rf->rsrc_lock, flags);
+	rsrc_num = find_next_zero_bit(rsrc_array, max_rsrc, *next);
+	if (rsrc_num >= max_rsrc) {
+		rsrc_num = find_first_zero_bit(rsrc_array, max_rsrc);
+		if (rsrc_num >= max_rsrc) {
+			spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+			irdma_dbg(&rf->sc_dev,
+				  "ERR: resource [%d] allocation failed\n",
+				  rsrc_num);
+			return -EOVERFLOW;
+		}
+	}
+	__set_bit(rsrc_num, rsrc_array);
+	*next = rsrc_num + 1;
+	if (*next == max_rsrc)
+		*next = 0;
+	*req_rsrc_num = rsrc_num;
+	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_free_resource - free a resource
+ * @iwdev: device pointer
+ * @resource_array: resource array for the resource_num
+ * @resource_num: resource number to free
+ **/
+static inline void irdma_free_rsrc(struct irdma_pci_f *rf,
+				   unsigned long *rsrc_array, u32 rsrc_num)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rf->rsrc_lock, flags);
+	__clear_bit(rsrc_num, rsrc_array);
+	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
+}
+
+void irdma_set_config_params(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf);
+void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_rt_init_hw(struct irdma_pci_f *rf,
+					struct irdma_device *iwdev,
+					struct irdma_l2params *l2params);
+void irdma_rt_deinit_hw(struct irdma_device *iwdev);
+void irdma_qp_add_ref(struct ib_qp *ibqp);
+void irdma_qp_rem_ref(struct ib_qp *ibqp);
+void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp);
+struct ib_qp *irdma_get_qp(struct ib_device *ibdev, int qpn);
+void irdma_flush_wqes(struct irdma_qp *iwqp, u32 flush_mask);
+void irdma_manage_arp_cache(struct irdma_pci_f *rf, unsigned char *mac_addr,
+			    u32 *ip_addr, bool ipv4, u32 action);
+struct irdma_apbvt_entry *irdma_add_apbvt(struct irdma_device *iwdev, u16 port);
+void irdma_del_apbvt(struct irdma_device *iwdev,
+		     struct irdma_apbvt_entry *entry);
+struct irdma_cqp_request *irdma_alloc_and_get_cqp_request(struct irdma_cqp *cqp,
+							  bool wait);
+void irdma_free_cqp_request(struct irdma_cqp *cqp,
+			    struct irdma_cqp_request *cqp_request);
+void irdma_put_cqp_request(struct irdma_cqp *cqp,
+			   struct irdma_cqp_request *cqp_request);
+int irdma_alloc_local_mac_entry(struct irdma_pci_f *rf, u16 *mac_tbl_idx);
+int irdma_add_local_mac_entry(struct irdma_pci_f *rf, u8 *mac_addr, u16 idx);
+void irdma_del_local_mac_entry(struct irdma_pci_f *rf, u16 idx);
+
+u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf);
+void irdma_port_ibevent(struct irdma_device *iwdev);
+void irdma_cm_disconn(struct irdma_qp *qp);
+
+bool irdma_cqp_crit_err(struct irdma_sc_dev *dev, u8 cqp_cmd,
+			u16 maj_err_code, u16 min_err_code);
+enum irdma_status_code
+irdma_handle_cqp_op(struct irdma_pci_f *rf,
+		    struct irdma_cqp_request *cqp_request);
+
+int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
+		    struct ib_udata *udata);
+int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			 int attr_mask, struct ib_udata *udata);
+void irdma_cq_wq_destroy(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
+
+void irdma_cleanup_pending_cqp_op(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_hw_modify_qp(struct irdma_device *iwdev,
+					  struct irdma_qp *iwqp,
+					  struct irdma_modify_qp_info *info,
+					  bool wait);
+enum irdma_status_code irdma_qp_suspend_resume(struct irdma_sc_qp *qp,
+					       bool suspend);
+enum irdma_status_code
+irdma_manage_qhash(struct irdma_device *iwdev, struct irdma_cm_info *cminfo,
+		   enum irdma_quad_entry_type etype,
+		   enum irdma_quad_hash_manage_type mtype, void *cmnode,
+		   bool wait);
+void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf);
+void irdma_free_sqbuf(struct irdma_sc_vsi *vsi, void *bufp);
+void irdma_free_qp_rsrc(struct irdma_qp *iwqp);
+enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev, u8 ver);
+void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core);
+void irdma_next_iw_state(struct irdma_qp *iwqp, u8 state, u8 del_hash, u8 term,
+			 u8 term_len);
+int irdma_send_syn(struct irdma_cm_node *cm_node, u32 sendack);
+int irdma_send_reset(struct irdma_cm_node *cm_node);
+struct irdma_cm_node *irdma_find_node(struct irdma_cm_core *cm_core,
+				      u16 rem_port, u32 *rem_addr, u16 loc_port,
+				      u32 *loc_addr);
+enum irdma_status_code irdma_hw_flush_wqes(struct irdma_pci_f *rf,
+					   struct irdma_sc_qp *qp,
+					   struct irdma_qp_flush_info *info,
+					   bool wait);
+void irdma_gen_ae(struct irdma_pci_f *rf, struct irdma_sc_qp *qp,
+		  struct irdma_gen_ae_info *info, bool wait);
+void irdma_copy_ip_ntohl(u32 *dst, __be32 *src);
+void irdma_copy_ip_htonl(__be32 *dst, u32 *src);
+u16 irdma_get_vlan_ipv4(u32 *addr);
+struct net_device *irdma_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *mac);
+struct ib_mr *irdma_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
+				int acc, u64 *iova_start);
+int irdma_upload_qp_context(struct irdma_qp *iwqp, bool freeze, bool raw);
+void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
+int irdma_ah_cqp_op(struct irdma_pci_f *rf, struct irdma_sc_ah *sc_ah, u8 cmd,
+		    bool wait,
+		    void (*callback_fcn)(struct irdma_cqp_request *cqp_request),
+		    void *cb_param);
+void irdma_gsi_ud_qp_ah_cb(struct irdma_cqp_request *cqp_request);
+struct irdma_handler *irdma_find_handler(struct pci_dev *pcidev);
+void irdma_deinit_rf(struct irdma_pci_f *rf);
+int irdma_inetaddr_event(struct notifier_block *notifier, unsigned long event,
+			 void *ptr);
+int irdma_inet6addr_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+int irdma_net_event(struct notifier_block *notifier, unsigned long event,
+		    void *ptr);
+int irdma_netdevice_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+bool irdma_lan_vsi_ready(struct auxiliary_device *aux_dev);
+int i40iw_init_dev(struct auxiliary_device *aux_dev);
+int i40iw_deinit_dev(struct auxiliary_device *aux_dev);
+int ig3rdma_init_dev(struct auxiliary_device *aux_dev);
+int ig3rdma_deinit_dev(struct auxiliary_device *aux_dev);
+int irdma_configfs_init(void);
+void irdma_configfs_exit(void);
+void irdma_add_ip(struct irdma_device *iwdev);
+void irdma_add_handler(struct irdma_handler *hdl);
+void irdma_del_handler(struct irdma_handler *hdl);
+int irdma_init_dev(struct auxiliary_device *aux_dev);
+int irdma_deinit_dev(struct auxiliary_device *aux_dev);
+void cqp_compl_worker(struct work_struct *work);
+#endif /* IRDMA_MAIN_H */
-- 
1.8.3.1

