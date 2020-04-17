Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2011AE388
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgDQRQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:16:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:38151 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgDQRQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:16:34 -0400
IronPort-SDR: iR+n2nPri+lcYYcw06vaepwnHJI/MfNmD1aQBfiFOtQBbKupKStwX1DqvbXtHuGInvHfEYnzq7
 /ApfcwtKze9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:53 -0700
IronPort-SDR: UqC6cbJwZOSbSvkKn1EkXnYNiCMnrdxEX2pvwF7Eq9mQS5+BgG8gZuUfp0slsOjWGBqXq4WRWw
 Pe2mHj8Pj0ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383698"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Date:   Fri, 17 Apr 2020 10:12:36 -0700
Message-Id: <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
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

Register irdma as a virtbus driver capable of supporting virtbus
devices from multi-generation RDMA capable Intel HW. Establish the
interface with all supported netdev peer drivers and initialize HW.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
 drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
 drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
 drivers/infiniband/hw/irdma/main.h     | 599 +++++++++++++++++++++++++
 4 files changed, 1849 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h

diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
new file mode 100644
index 000000000000..1dba860be163
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/net/intel/i40e_client.h>
+#include <net/addrconf.h>
+#include "main.h"
+#include "i40iw_hw.h"
+
+/**
+ * i40iw_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ *
+ */
+static void i40iw_request_reset(struct irdma_pci_f *rf)
+{
+	struct i40e_info *ldev = rf->ldev.if_ldev;
+
+	ldev->ops->request_reset(ldev, rf->ldev.if_client, 1);
+}
+
+/**
+ * i40iw_open - client interface operation open for iwarp/uda device
+ * @ldev: LAN device information
+ * @client: iwarp client information, provided during registration
+ *
+ * Called by the LAN driver during the processing of client
+ * register Create device resources, set up queues, pble and hmc
+ * objects and register the device with the ib verbs interface
+ * Return 0 if successful, otherwise return error
+ */
+static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
+{
+	struct irdma_device *iwdev = NULL;
+	struct irdma_handler *hdl = NULL;
+	struct irdma_priv_ldev *pldev;
+	struct irdma_sc_dev *dev;
+	struct irdma_pci_f *rf;
+	struct irdma_l2params l2params = {};
+	int err = -EIO;
+	int i;
+	u16 qset;
+	u16 last_qset = IRDMA_NO_QSET;
+
+	hdl = irdma_find_handler(ldev->pcidev);
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
+	hdl->vdev = ldev->vdev;
+	irdma_init_rf_config_params(rf);
+	rf->gen_ops.init_hw = i40iw_init_hw;
+	rf->gen_ops.request_reset = i40iw_request_reset;
+	rf->hw.hw_addr = ldev->hw_addr;
+	rf->pdev = ldev->pcidev;
+	rf->netdev = ldev->netdev;
+	dev->pci_rev = rf->pdev->revision;
+
+	pldev = &rf->ldev;
+	hdl->ldev = pldev;
+	pldev->if_client = client;
+	pldev->if_ldev = ldev;
+	pldev->fn_num = ldev->fid;
+	pldev->ftype = ldev->ftype;
+	pldev->pf_vsi_num = 0;
+	pldev->msix_count = ldev->msix_count;
+	pldev->msix_entries = ldev->msix_entries;
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
+	iwdev->ldev = &rf->ldev;
+	iwdev->init_state = INITIAL_STATE;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = ldev->netdev;
+	iwdev->create_ilq = true;
+	iwdev->vsi_num = 0;
+
+	l2params.mtu =
+		(ldev->params.mtu) ? ldev->params.mtu : IRDMA_DEFAULT_MTU;
+	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
+		qset = ldev->params.qos.prio_qos[i].qs_handle;
+		l2params.up2tc[i] = ldev->params.qos.prio_qos[i].tc;
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
+	dev_dbg(rfdev_to_dev(dev), "INIT: Gen1 VSI open success ldev=%p\n",
+		ldev);
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
+ * @ldev: lan device information
+ * @client: client for parameter change
+ * @params: new parameters from L2
+ */
+static void i40iw_l2param_change(struct i40e_info *ldev,
+				 struct i40e_client *client,
+				 struct i40e_params *params)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+
+	iwdev = irdma_get_device(ldev->netdev);
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
+ * @ldev: lan device information
+ * @client: client to close
+ * @reset: flag to indicate close on reset
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void i40iw_close(struct i40e_info *ldev, struct i40e_client *client,
+			bool reset)
+{
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_device *iwdev;
+
+	hdl = irdma_find_handler(ldev->pcidev);
+	if (!hdl)
+		return;
+
+	rf = &hdl->rf;
+	iwdev = list_first_entry_or_null(&rf->vsi_dev_list, struct irdma_device,
+					 list);
+	if (reset)
+		iwdev->reset = true;
+
+	irdma_ib_unregister_device(iwdev);
+	irdma_deinit_rf(rf);
+	pr_debug("INIT: Gen1 VSI close complete ldev=%p\n", ldev);
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
+	.name = "irdma",
+	.ops = &i40e_ops,
+	.type = I40E_CLIENT_IWARP,
+};
+
+int i40iw_probe_dev(struct virtbus_device *vdev)
+{
+	struct i40e_virtbus_device *i40e_vdev =
+			container_of(vdev, struct i40e_virtbus_device, vdev);
+	struct i40e_info *ldev = i40e_vdev->ldev;
+
+	ldev->client = &i40iw_client;
+
+	return ldev->ops->client_device_register(ldev);
+}
+
+int i40iw_remove_dev(struct virtbus_device *vdev)
+{
+	struct i40e_virtbus_device *i40e_vdev =
+			container_of(vdev, struct i40e_virtbus_device, vdev);
+	struct i40e_info *ldev = i40e_vdev->ldev;
+
+	ldev->ops->client_device_unregister(ldev);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/irdma/irdma_if.c b/drivers/infiniband/hw/irdma/irdma_if.c
new file mode 100644
index 000000000000..87079b916537
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/irdma_if.c
@@ -0,0 +1,449 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019 Intel Corporation */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
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
+	struct iidc_peer_dev *ldev = iwdev->ldev->if_ldev;
+	struct iidc_res rdma_qset_res = {};
+	int ret;
+
+	rdma_qset_res.cnt_req = 1;
+	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
+	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+	rdma_qset_res.res[0].res.qsets.tc = tc_node->traffic_class;
+	rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+	ret = ldev->ops->alloc_res(ldev, &rdma_qset_res, 0);
+	if (ret) {
+		dev_dbg(rfdev_to_dev(vsi->dev),
+			"WS: LAN alloc_res for rdma qset failed.\n");
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
+	struct iidc_peer_dev *ldev = iwdev->ldev->if_ldev;
+	struct iidc_res rdma_qset_res = {};
+
+	rdma_qset_res.res_allocated = 1;
+	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
+	rdma_qset_res.res[0].res.qsets.vsi_id = vsi->vsi_idx;
+	rdma_qset_res.res[0].res.qsets.teid = tc_node->l2_sched_node_id;
+	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
+
+	if (ldev->ops->free_res(ldev, &rdma_qset_res))
+		dev_dbg(rfdev_to_dev(vsi->dev),
+			"WS: LAN free_res for rdma qset failed.\n");
+}
+
+/**
+ * irdma_prep_tc_change - Prepare for TC changes
+ * @ldev: Peer device structure
+ */
+static void irdma_prep_tc_change(struct iidc_peer_dev *ldev)
+{
+	struct irdma_device *iwdev;
+
+	iwdev = irdma_get_device(ldev->netdev);
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
+		dev_warn(rfdev_to_dev(dev),
+			 "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 576 for IPv4\n",
+			 mtu);
+	else if (mtu < IRDMA_MIN_MTU_IPV6)
+		dev_warn(rfdev_to_dev(dev),
+			 "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 1280 for IPv6\\n",
+			 mtu);
+}
+
+/**
+ * irdma_event_handler - Called by LAN driver to notify events
+ * @ldev: Peer device structure
+ * @event: event from LAN driver
+ */
+static void irdma_event_handler(struct iidc_peer_dev *ldev,
+				struct iidc_event *event)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+	int i;
+
+	iwdev = irdma_get_device(ldev->netdev);
+	if (!iwdev)
+		return;
+
+	if (*event->type & BIT(IIDC_EVENT_LINK_CHANGE)) {
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"CLNT: LINK_CHANGE event\n");
+	} else if (*event->type & BIT(IIDC_EVENT_MTU_CHANGE)) {
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"CLNT: new MTU = %d\n", event->info.mtu);
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
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev), "CLNT: TC Change\n");
+		iwdev->dcb = event->info.port_qos.num_tc > 1;
+
+		for (i = 0; i < IIDC_MAX_USER_PRIORITY; ++i)
+			l2params.up2tc[i] = event->info.port_qos.up2tc[i];
+		irdma_change_l2params(&iwdev->vsi, &l2params);
+	} else if (*event->type & BIT(IIDC_EVENT_API_CHANGE)) {
+		dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+			"CLNT: API_CHANGE\n");
+	}
+
+done:
+	irdma_put_device(iwdev);
+}
+
+/**
+ * irdma_open - client interface operation open for RDMA device
+ * @ldev: LAN device information
+ *
+ * Called by the LAN driver during the processing of client
+ * register.
+ */
+static int irdma_open(struct iidc_peer_dev *ldev)
+{
+	struct irdma_handler *hdl;
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	struct iidc_event events = {};
+	struct irdma_pci_f *rf;
+	struct irdma_priv_ldev *pldev;
+	struct irdma_l2params l2params = {};
+	int i, ret;
+
+	hdl = irdma_find_handler(ldev->pdev);
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
+	pldev = &rf->ldev;
+	pldev->pf_vsi_num = ldev->pf_vsi_num;
+	dev = &hdl->rf.sc_dev;
+
+	iwdev->hdl = hdl;
+	iwdev->rf = rf;
+	iwdev->ldev = &rf->ldev;
+	iwdev->push_mode = 0;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = ldev->netdev;
+	iwdev->create_ilq = true;
+	if (rf->protocol_used == IRDMA_ROCE_PROTOCOL_ONLY) {
+		iwdev->roce_mode = true;
+		iwdev->create_ilq = false;
+	}
+	l2params.mtu = ldev->netdev->mtu;
+	l2params.num_tc = ldev->initial_qos_info.num_tc;
+	l2params.num_apps = ldev->initial_qos_info.num_apps;
+	l2params.vsi_prio_type = ldev->initial_qos_info.vsi_priority_type;
+	l2params.vsi_rel_bw = ldev->initial_qos_info.vsi_relative_bw;
+	for (i = 0; i < l2params.num_tc; i++) {
+		l2params.tc_info[i].egress_virt_up =
+			ldev->initial_qos_info.tc_info[i].egress_virt_up;
+		l2params.tc_info[i].ingress_virt_up =
+			ldev->initial_qos_info.tc_info[i].ingress_virt_up;
+		l2params.tc_info[i].prio_type =
+			ldev->initial_qos_info.tc_info[i].prio_type;
+		l2params.tc_info[i].rel_bw =
+			ldev->initial_qos_info.tc_info[i].rel_bw;
+		l2params.tc_info[i].tc_ctx =
+			ldev->initial_qos_info.tc_info[i].tc_ctx;
+	}
+	for (i = 0; i < IIDC_MAX_USER_PRIORITY; i++)
+		l2params.up2tc[i] = ldev->initial_qos_info.up2tc[i];
+
+	iwdev->vsi_num = ldev->pf_vsi_num;
+	ldev->ops->update_vsi_filter(ldev, IIDC_RDMA_FILTER_BOTH, true);
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
+	events.reporter = ldev;
+	set_bit(IIDC_EVENT_LINK_CHANGE, events.type);
+	set_bit(IIDC_EVENT_MTU_CHANGE, events.type);
+	set_bit(IIDC_EVENT_TC_CHANGE, events.type);
+	set_bit(IIDC_EVENT_API_CHANGE, events.type);
+
+	ldev->ops->reg_for_notification(ldev, &events);
+	dev_dbg(rfdev_to_dev(dev),
+		"INIT: Gen2 VSI[%d] open success ldev=%p\n", ldev->pf_vsi_num,
+		ldev);
+
+	return 0;
+}
+
+/**
+ * irdma_close - client interface operation close for iwarp/uda device
+ * @ldev: LAN device information
+ * @reason: reason for closing
+ *
+ * Called by the LAN driver during the processing of client
+ * unregister Destroy and clean up the driver resources
+ */
+static void irdma_close(struct iidc_peer_dev *ldev,
+			enum iidc_close_reason reason)
+{
+	struct irdma_handler *hdl;
+	struct irdma_device *iwdev;
+	struct irdma_pci_f *rf;
+
+	hdl = irdma_find_handler(ldev->pdev);
+	if (!hdl)
+		return;
+
+	rf = &hdl->rf;
+	iwdev = list_first_entry_or_null(&rf->vsi_dev_list, struct irdma_device,
+					 list);
+	if (!iwdev)
+		return;
+
+	if (reason == IIDC_REASON_GLOBR_REQ || reason == IIDC_REASON_CORER_REQ ||
+	    reason == IIDC_REASON_PFR_REQ || rf->reset) {
+		iwdev->reset = true;
+		rf->reset = true;
+	}
+
+	irdma_ib_unregister_device(iwdev);
+	ldev->ops->update_vsi_filter(ldev, IIDC_RDMA_FILTER_BOTH, false);
+	if (rf->reset)
+		schedule_delayed_work(&rf->rst_work, rf->rst_to * HZ);
+
+	pr_debug("INIT: Gen2 VSI[%d] close complete ldev=%p\n",
+		 ldev->pf_vsi_num, ldev);
+}
+
+/**
+ * irdma_remove_dev - GEN_2 device remove()
+ * @vdev: virtbus device
+ *
+ * Called on module unload.
+ */
+int irdma_remove_dev(struct virtbus_device *vdev)
+{
+	struct iidc_virtbus_object *vo =
+			container_of(vdev, struct iidc_virtbus_object, vdev);
+	struct iidc_peer_dev *ldev = vo->peer_dev;
+	struct irdma_handler *hdl;
+
+	hdl = irdma_find_handler(ldev->pdev);
+	if (!hdl)
+		return 0;
+
+	cancel_delayed_work_sync(&hdl->rf.rst_work);
+	ldev->ops->peer_unregister(ldev);
+
+	irdma_deinit_rf(&hdl->rf);
+	pr_debug("INIT: Gen2 device remove success ldev=%p\n", ldev);
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
+	struct iidc_peer_dev *ldev = rf->ldev.if_ldev;
+
+	dev_warn(rfdev_to_dev(&rf->sc_dev), "Requesting a a reset\n");
+	ldev->ops->request_reset(ldev, IIDC_PEER_PFR);
+}
+
+/**
+ * irdma_probe_dev - GEN_2 device probe()
+ * @vdev: virtbus device
+ *
+ * Create device resources, set up queues, pble and hmc objects.
+ * Return 0 if successful, otherwise return error
+ */
+int irdma_probe_dev(struct virtbus_device *vdev)
+{
+	struct iidc_virtbus_object *vo =
+			container_of(vdev, struct iidc_virtbus_object, vdev);
+	struct iidc_peer_dev *ldev = vo->peer_dev;
+	struct irdma_handler *hdl;
+	struct irdma_pci_f *rf;
+	struct irdma_sc_dev *dev;
+	struct irdma_priv_ldev *pldev;
+	int err;
+
+	hdl = irdma_find_handler(ldev->pdev);
+	if (hdl)
+		return -EBUSY;
+
+	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
+	if (!hdl)
+		return -ENOMEM;
+
+	rf = &hdl->rf;
+	pldev = &rf->ldev;
+	hdl->ldev = pldev;
+	hdl->vdev = vdev;
+	rf->hdl = hdl;
+	dev = &rf->sc_dev;
+	dev->back_dev = rf;
+	rf->gen_ops.init_hw = icrdma_init_hw;
+	rf->gen_ops.request_reset = icrdma_request_reset;
+	rf->gen_ops.register_qset = irdma_lan_register_qset;
+	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
+	pldev->if_ldev = ldev;
+	rf->rdma_ver = IRDMA_GEN_2;
+	irdma_init_rf_config_params(rf);
+	INIT_DELAYED_WORK(&rf->rst_work, irdma_reset_task);
+	dev->pci_rev = ldev->pdev->revision;
+	rf->default_vsi.vsi_idx = ldev->pf_vsi_num;
+	/* save information from ldev to priv_ldev*/
+	pldev->fn_num = PCI_FUNC(ldev->pdev->devfn);
+	rf->hw.hw_addr = ldev->hw_addr;
+	rf->pdev = ldev->pdev;
+	rf->netdev = ldev->netdev;
+	pldev->ftype = ldev->ftype;
+	pldev->msix_count = ldev->msix_count;
+	pldev->msix_entries = ldev->msix_entries;
+	irdma_add_handler(hdl);
+	if (irdma_ctrl_init_hw(rf)) {
+		err = -EIO;
+		goto err_ctrl_init;
+	}
+	ldev->peer_ops = &irdma_peer_ops;
+	ldev->peer_drv = &irdma_peer_drv;
+	err = ldev->ops->peer_register(ldev);
+	if (err)
+		goto err_peer_reg;
+
+	dev_dbg(rfdev_to_dev(dev),
+		"INIT: Gen2 device probe success ldev=%p\n", ldev);
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
+
+/*
+ * irdma_lan_vsi_ready - check to see if lan reset done
+ * @vdev: virtbus device
+ */
+bool irdma_lan_vsi_ready(struct virtbus_device *vdev)
+{
+	struct iidc_virtbus_object *vo =
+			container_of(vdev, struct iidc_virtbus_object, vdev);
+	struct iidc_peer_dev *ldev = vo->peer_dev;
+
+	return ldev->ops->is_vsi_ready(ldev) ? true : false;
+}
+
+/**
+ * irdma_reset_task: worker for reset recovery
+ * @work: work_struct pointer
+ */
+void irdma_reset_task(struct work_struct *work)
+{
+	struct irdma_pci_f *rf = container_of(to_delayed_work(work),
+					      struct irdma_pci_f, rst_work);
+	struct virtbus_device *vdev = rf->hdl->vdev;
+
+	/* Reset Recovery */
+	irdma_probe_dev(vdev);
+	if (!irdma_lan_vsi_ready(vdev))
+		goto reschd;
+
+	irdma_remove_dev(vdev);
+	return;
+
+reschd:
+	if (!rf->rst_to)
+		pr_err("RF rebuild after reset timed out\n");
+	else
+		schedule_delayed_work(&rf->rst_work, --rf->rst_to * HZ);
+}
diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
new file mode 100644
index 000000000000..8075b7bf6ae8
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -0,0 +1,573 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include "main.h"
+
+bool irdma_upload_context;
+
+MODULE_ALIAS("i40iw");
+MODULE_AUTHOR("Intel Corporation, <e1000-rdma@lists.sourceforge.net>");
+MODULE_DESCRIPTION("Intel(R) Ethernet Protocol Driver for RDMA");
+MODULE_LICENSE("Dual BSD/GPL");
+
+LIST_HEAD(irdma_handlers);
+DEFINE_SPINLOCK(irdma_handler_lock);
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
+void irdma_init_rf_config_params(struct irdma_pci_f *rf)
+{
+	struct irdma_dl_priv *dl_priv;
+
+	rf->rsrc_profile = IRDMA_HMC_PROFILE_DEFAULT;
+	dl_priv = dev_get_drvdata(&rf->hdl->vdev->dev);
+	rf->limits_sel = dl_priv->limits_sel;
+	set_protocol_used(rf, dl_priv->roce_ena);
+	rf->rst_to = IRDMA_RST_TIMEOUT_HZ;
+}
+
+/*
+ * irdma_deinit_rf - Clean up resources allocated for RF
+ * @rf: RDMA PCI function
+ */
+void irdma_deinit_rf(struct irdma_pci_f *rf)
+{
+	irdma_ctrl_deinit_hw(rf);
+	irdma_del_handler(rf->hdl);
+	kfree(rf->hdl);
+}
+
+/**
+ * irdma_find_ice_handler - find a handler given a client info
+ * @pdev: pointer to pci dev info
+ */
+struct irdma_handler *irdma_find_handler(struct pci_dev *pdev)
+{
+	struct irdma_handler *hdl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_for_each_entry (hdl, &irdma_handlers, list) {
+		if (hdl->rf.pdev->devfn == pdev->devfn &&
+		    hdl->rf.pdev->bus->number == pdev->bus->number) {
+			spin_unlock_irqrestore(&irdma_handler_lock, flags);
+			return hdl;
+		}
+	}
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+
+	return NULL;
+}
+
+/**
+ * irdma_add_handler - add a handler to the list
+ * @hdl: handler to be added to the handler list
+ */
+void irdma_add_handler(struct irdma_handler *hdl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_add(&hdl->list, &irdma_handlers);
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+}
+
+/**
+ * irdma_del_handler - delete a handler from the list
+ * @hdl: handler to be deleted from the handler list
+ */
+void irdma_del_handler(struct irdma_handler *hdl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irdma_handler_lock, flags);
+	list_del(&hdl->list);
+	spin_unlock_irqrestore(&irdma_handler_lock, flags);
+}
+
+/**
+ * irdma_register_notifiers - register tcp ip notifiers
+ */
+void irdma_register_notifiers(void)
+{
+	register_inetaddr_notifier(&irdma_inetaddr_notifier);
+	register_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	register_netevent_notifier(&irdma_net_notifier);
+	register_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+void irdma_unregister_notifiers(void)
+{
+	unregister_netevent_notifier(&irdma_net_notifier);
+	unregister_inetaddr_notifier(&irdma_inetaddr_notifier);
+	unregister_inet6addr_notifier(&irdma_inetaddr6_notifier);
+	unregister_netdevice_notifier(&irdma_netdevice_notifier);
+}
+
+/**
+ * irdma_add_ipv6_addr - add ipv6 address to the hw arp table
+ * @iwdev: irdma device
+ */
+static void irdma_add_ipv6_addr(struct irdma_device *iwdev)
+{
+	struct net_device *ip_dev;
+	struct inet6_dev *idev;
+	struct inet6_ifaddr *ifp, *tmp;
+	u32 local_ipaddr6[4];
+
+	rcu_read_lock();
+	for_each_netdev_rcu (&init_net, ip_dev) {
+		if (((rdma_vlan_dev_vlan_id(ip_dev) < 0xFFFF &&
+		      rdma_vlan_dev_real_dev(ip_dev) == iwdev->netdev) ||
+		      ip_dev == iwdev->netdev) &&
+		      (READ_ONCE(ip_dev->flags) & IFF_UP)) {
+			idev = __in6_dev_get(ip_dev);
+			if (!idev) {
+				dev_err(rfdev_to_dev(&iwdev->rf->sc_dev),
+					"ipv6 inet device not found\n");
+				break;
+			}
+			list_for_each_entry_safe (ifp, tmp, &idev->addr_list,
+						  if_list) {
+				dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+					"INIT: IP=%pI6, vlan_id=%d, MAC=%pM\n",
+					&ifp->addr,
+					rdma_vlan_dev_vlan_id(ip_dev),
+					ip_dev->dev_addr);
+
+				irdma_copy_ip_ntohl(local_ipaddr6,
+						    ifp->addr.in6_u.u6_addr32);
+				irdma_manage_arp_cache(iwdev->rf,
+						       ip_dev->dev_addr,
+						       local_ipaddr6, false,
+						       IRDMA_ARP_ADD);
+			}
+		}
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * irdma_add_ipv4_addr - add ipv4 address to the hw arp table
+ * @iwdev: irdma device
+ */
+static void irdma_add_ipv4_addr(struct irdma_device *iwdev)
+{
+	struct net_device *dev;
+	struct in_device *idev;
+	u32 ip_addr;
+
+	rcu_read_lock();
+	for_each_netdev_rcu (&init_net, dev) {
+		if (((rdma_vlan_dev_vlan_id(dev) < 0xFFFF &&
+		      rdma_vlan_dev_real_dev(dev) == iwdev->netdev) ||
+		      dev == iwdev->netdev) && (READ_ONCE(dev->flags) & IFF_UP)) {
+			const struct in_ifaddr *ifa;
+
+			idev = __in_dev_get_rcu(dev);
+			if (!idev)
+				continue;
+			in_dev_for_each_ifa_rcu(ifa, idev) {
+				dev_dbg(rfdev_to_dev(&iwdev->rf->sc_dev),
+					"CM: IP=%pI4, vlan_id=%d, MAC=%pM\n",
+					&ifa->ifa_address,
+					rdma_vlan_dev_vlan_id(dev),
+					dev->dev_addr);
+
+				ip_addr = ntohl(ifa->ifa_address);
+				irdma_manage_arp_cache(iwdev->rf, dev->dev_addr,
+						       &ip_addr, true,
+						       IRDMA_ARP_ADD);
+			}
+		}
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * irdma_add_ip - add ip addresses
+ * @iwdev: irdma device
+ *
+ * Add ipv4/ipv6 addresses to the arp cache
+ */
+void irdma_add_ip(struct irdma_device *iwdev)
+{
+	irdma_add_ipv4_addr(iwdev);
+	irdma_add_ipv6_addr(iwdev);
+}
+
+static int irdma_devlink_rsrc_limits_validate(struct devlink *dl, u32 id,
+					      union devlink_param_value val,
+					      struct netlink_ext_ack *extack)
+{
+	u8 value = val.vu8;
+
+	if (value > 5) {
+		NL_SET_ERR_MSG_MOD(extack, "resource limits selector range is (0-5)");
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
+	if (value && priv->hw_ver == IRDMA_GEN_1) {
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
+			      NULL, NULL, irdma_devlink_enable_roce_validate)
+};
+
+static int  irdma_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				      struct netlink_ext_ack *extack)
+{
+	struct irdma_dl_priv *priv = devlink_priv(devlink);
+
+	if (netns_change) {
+		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	switch (priv->hw_ver) {
+	case IRDMA_GEN_2:
+		irdma_remove_dev(priv->vdev);
+		break;
+	case IRDMA_GEN_1:
+		i40iw_remove_dev(priv->vdev);
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int irdma_devlink_reload_up(struct devlink *devlink,
+				   struct netlink_ext_ack *extack)
+{
+	struct irdma_dl_priv *priv = devlink_priv(devlink);
+	union devlink_param_value saved_value;
+	int ret;
+
+	devlink_param_driverinit_value_get(devlink,
+				DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+				&saved_value);
+	priv->roce_ena = saved_value.vbool;
+	devlink_param_driverinit_value_get(devlink,
+				IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
+				&saved_value);
+	priv->limits_sel = saved_value.vu8;
+
+	switch (priv->hw_ver) {
+	case IRDMA_GEN_2:
+		ret = irdma_probe_dev(priv->vdev);
+		break;
+	case IRDMA_GEN_1:
+		ret = i40iw_probe_dev(priv->vdev);
+		break;
+	default:
+		ret = -ENODEV;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct devlink_ops irdma_devlink_ops = {
+	.reload_up = irdma_devlink_reload_up,
+	.reload_down = irdma_devlink_reload_down,
+};
+
+static void irdma_devlink_unregister(struct virtbus_device *vdev,
+				     enum irdma_vers hw_ver)
+{
+	struct irdma_dl_priv *priv = dev_get_drvdata(&vdev->dev);
+	struct devlink *devlink = priv_to_devlink(priv);
+
+	devlink_reload_disable(devlink);
+	devlink_params_unregister(devlink, irdma_devlink_params,
+				  ARRAY_SIZE(irdma_devlink_params));
+	devlink_unregister(devlink);
+	devlink_free(devlink);
+}
+
+static int irdma_devlink_register(struct virtbus_device *vdev,
+				  enum irdma_vers hw_ver)
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
+	priv->vdev = vdev;
+	priv->hw_ver = hw_ver;
+	dev_set_drvdata(&vdev->dev, priv);
+
+	ret = devlink_register(devlink, &vdev->dev);
+	if (ret)
+		goto err_dl_free;
+
+	ret = devlink_params_register(devlink, irdma_devlink_params,
+				      ARRAY_SIZE(irdma_devlink_params));
+	if (ret)
+		goto err_dl_unreg;
+
+	priv->limits_sel = (hw_ver == IRDMA_GEN_1) ? 2 : 0;
+	value.vu8 = priv->limits_sel;
+	devlink_param_driverinit_value_set(devlink,
+					   IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
+					   value);
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+					   IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
+					   value);
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					   value);
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
+static int irdma_init_dev(struct virtbus_device *vdev, enum irdma_vers hw_ver)
+{
+	int ret = -ENODEV;
+
+	switch (hw_ver) {
+	case IRDMA_GEN_2:
+		ret = irdma_probe_dev(vdev);
+		break;
+	case IRDMA_GEN_1:
+		ret = i40iw_probe_dev(vdev);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static void irdma_deinit_dev(struct virtbus_device *vdev, enum irdma_vers hw_ver)
+{
+	switch (hw_ver) {
+	case IRDMA_GEN_2:
+		irdma_remove_dev(vdev);
+		break;
+	case IRDMA_GEN_1:
+		i40iw_remove_dev(vdev);
+		break;
+	default:
+		break;
+	}
+}
+
+static enum irdma_vers irdma_get_hw_version(struct virtbus_device *vdev)
+{
+	enum irdma_vers hw_ver = IRDMA_GEN_RSVD;
+
+	if (!strcmp(vdev->name, IRDMA_I40E_VDEV_NAME))
+		hw_ver = IRDMA_GEN_1;
+	else if (!strcmp(vdev->name, IRDMA_ICE_VDEV_NAME))
+		hw_ver = IRDMA_GEN_2;
+
+	return hw_ver;
+}
+
+static int irdma_probe(struct virtbus_device *vdev)
+{
+	int ret;
+	enum irdma_vers hw_ver = irdma_get_hw_version(vdev);
+
+	if (!hw_ver)
+		return -ENODEV;
+
+	ret = irdma_devlink_register(vdev, hw_ver);
+	if (ret)
+		return ret;
+
+	ret = irdma_init_dev(vdev, hw_ver);
+	if (ret)
+		irdma_devlink_unregister(vdev, hw_ver);
+
+	return ret;
+}
+
+static int irdma_remove(struct virtbus_device *vdev)
+{
+	enum irdma_vers hw_ver = irdma_get_hw_version(vdev);
+
+	if (!hw_ver)
+		return -ENODEV;
+
+	irdma_deinit_dev(vdev, hw_ver);
+	irdma_devlink_unregister(vdev, hw_ver);
+
+	return 0;
+}
+
+static void irdma_shutdown(struct virtbus_device *vdev)
+{
+	irdma_remove(vdev);
+}
+
+static int irdma_suspend(struct virtbus_device *vdev, pm_message_t state)
+{
+	enum irdma_vers hw_ver = irdma_get_hw_version(vdev);
+
+	if (!hw_ver)
+		return -ENODEV;
+
+	irdma_deinit_dev(vdev, hw_ver);
+
+	return 0;
+}
+
+static int irdma_resume(struct virtbus_device *vdev)
+{
+	enum irdma_vers hw_ver = irdma_get_hw_version(vdev);
+
+	if (!hw_ver)
+		return -ENODEV;
+
+	return irdma_init_dev(vdev, hw_ver);
+}
+
+static const struct virtbus_dev_id irdma_virtbus_id_table[] = {
+	{.name = IRDMA_ICE_VDEV_NAME},
+	{.name = IRDMA_I40E_VDEV_NAME},
+	{},
+};
+
+static struct virtbus_driver irdma_vdrv = {
+	.driver = {
+		   .name = "irdma",
+		   .owner = THIS_MODULE,
+		  },
+	.id_table = irdma_virtbus_id_table,
+	.probe = irdma_probe,
+	.remove = irdma_remove,
+	.resume = irdma_resume,
+	.suspend = irdma_suspend,
+	.shutdown = irdma_shutdown,
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
+	ret = virtbus_register_driver(&irdma_vdrv);
+	if (ret) {
+		pr_err("Failed irdma virtual driver register()\n");
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
+	virtbus_unregister_driver(&irdma_vdrv);
+}
+
+module_init(irdma_init_module);
+module_exit(irdma_exit_module);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
new file mode 100644
index 000000000000..dac0af3fab28
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -0,0 +1,599 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_MAIN_H
+#define IRDMA_MAIN_H
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/if_vlan.h>
+#include <net/addrconf.h>
+#include <net/netevent.h>
+#include <net/devlink.h>
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
+#include <linux/virtual_bus.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_pack.h>
+#include <rdma/rdma_cm.h>
+#include <rdma/iw_cm.h>
+#include <crypto/hash.h>
+#include "status.h"
+#include "osdep.h"
+#include "defs.h"
+#include "hmc.h"
+#include "type.h"
+#include "ws.h"
+#include "protos.h"
+#include "pble.h"
+#include "verbs.h"
+#include "cm.h"
+#include "user.h"
+#include "puda.h"
+#include <rdma/irdma-abi.h>
+
+extern struct list_head irdma_handlers;
+extern spinlock_t irdma_handler_lock;
+extern bool irdma_upload_context;
+
+#define IRDMA_FW_VER_DEFAULT	2
+#define IRDMA_HW_VER		2
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
+#define IRDMA_EVENT_TIMEOUT		100000
+#define IRDMA_VCHNL_EVENT_TIMEOUT	100000
+#define IRDMA_RST_TIMEOUT_HZ		4
+
+#define IRDMA_NO_QSET	0xffff
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
+
+#define IRDMA_FLUSH_SQ		BIT(0)
+#define IRDMA_FLUSH_RQ		BIT(1)
+#define IRDMA_REFLUSH		BIT(2)
+#define IRDMA_FLUSH_WAIT	BIT(3)
+
+#define IRDMA_ICE_VDEV_NAME	"intel,ice,rdma"
+#define IRDMA_I40E_VDEV_NAME	"intel,i40e,rdma"
+
+enum init_completion_state {
+	INVALID_STATE = 0,
+	INITIAL_STATE,
+	CQP_CREATED,
+	HMC_OBJS_CREATED,
+	HW_RSRC_INITIALIZED,
+	CCQ_CREATED,
+	AEQ_CREATED,
+	CEQ0_CREATED, /* Last state of probe */
+	CEQS_CREATED,
+	ILQ_CREATED,
+	IEQ_CREATED,
+	PBLE_CHUNK_MEM,
+	IP_ADDR_REGISTERED,
+	RDMA_DEV_REGISTERED, /* Last state of open */
+};
+
+enum irdma_mmap_flag {
+	IRDMA_MMAP_IO_NC,
+	IRDMA_MMAP_IO_WC,
+};
+
+struct irdma_rsrc_limits {
+	u32 qplimit;
+	u32 mrlimit;
+	u32 cqlimit;
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
+};
+
+struct irdma_aeq {
+	struct irdma_sc_aeq sc_aeq;
+	struct irdma_dma_mem mem;
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
+struct irdma_priv_ldev {
+	unsigned int fn_num;
+	bool ftype;
+	u16 pf_vsi_num;
+	u16 msix_count;
+	struct msix_entry *msix_entries;
+	void *if_client;
+	void *if_ldev;
+};
+
+struct irdma_dl_priv {
+	struct virtbus_device *vdev;
+	enum irdma_vers hw_ver;
+	u8 limits_sel;
+	bool roce_ena;
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
+	bool ooo:1;
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
+	struct irdma_priv_ldev ldev;
+	struct irdma_handler *hdl;
+	struct pci_dev *pdev;
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
+	struct delayed_work rst_work;
+	struct virtchnl_work virtchnl_w[IRDMA_MAX_PE_ENA_VF_COUNT];
+	struct irdma_sc_vsi default_vsi;
+	void *back_fcn;
+	struct irdma_gen_ops gen_ops;
+};
+
+struct irdma_device {
+	struct ib_device ibdev;
+	struct irdma_pci_f *rf;
+	struct irdma_priv_ldev *ldev;
+	struct net_device *netdev;
+	struct irdma_handler *hdl;
+	struct workqueue_struct *cleanup_wq;
+	struct irdma_sc_vsi vsi;
+	struct irdma_cm_core cm_core;
+	struct list_head list;
+	u32 vendor_id;
+	u32 vendor_part_id;
+	u32 device_cap_flags;
+	u32 push_mode;
+	u32 rcv_wnd;
+	u16 mac_ip_table_idx;
+	u16 vsi_num;
+	u8 rcv_wscale;
+	u8 iw_status;
+	bool create_ilq:1;
+	bool roce_mode:1;
+	bool dcb:1;
+	bool reset:1;
+	struct tasklet_struct dpc_tasklet;
+	enum init_completion_state init_state;
+
+	wait_queue_head_t suspend_wq;
+};
+
+struct irdma_handler {
+	struct list_head list;
+	struct irdma_pci_f rf;
+	struct irdma_priv_ldev *ldev;
+	struct virtbus_device *vdev;
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
+static inline struct irdma_mr *to_iwmr_from_ibfmr(struct ib_fmr *ibfmr)
+{
+	return container_of(ibfmr, struct irdma_mr, ibfmr);
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
+			dev_dbg(rfdev_to_dev(&rf->sc_dev),
+				"ERR: resource [%d] allocation failed\n",
+				rsrc_num);
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
+void irdma_init_rf_config_params(struct irdma_pci_f *rf);
+void irdma_reset_task(struct work_struct *work);
+enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf);
+void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_rt_init_hw(struct irdma_pci_f *rf,
+					struct irdma_device *iwdev,
+					struct irdma_l2params *l2params);
+void irdma_rt_deinit_hw(struct irdma_device *iwdev);
+void irdma_add_ref(struct ib_qp *ibqp);
+void irdma_rem_ref(struct ib_qp *ibqp);
+void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp);
+struct ib_qp *irdma_get_qp(struct ib_device *ibdev, int qpn);
+void irdma_flush_wqes(struct irdma_qp *iwqp, u32 flush_mask);
+void irdma_manage_arp_cache(struct irdma_pci_f *rf, unsigned char *mac_addr,
+			    u32 *ip_addr, bool ipv4, u32 action);
+int irdma_manage_apbvt(struct irdma_device *iwdev, u16 accel_local_port,
+		       bool add_port);
+struct irdma_cqp_request *irdma_get_cqp_request(struct irdma_cqp *cqp,
+						bool wait);
+void irdma_free_cqp_request(struct irdma_cqp *cqp,
+			    struct irdma_cqp_request *cqp_request);
+void irdma_put_cqp_request(struct irdma_cqp *cqp,
+			   struct irdma_cqp_request *cqp_request);
+struct irdma_handler *irdma_find_handler(struct pci_dev *pdev);
+void irdma_add_handler(struct irdma_handler *hdl);
+void irdma_del_handler(struct irdma_handler *hdl);
+void irdma_add_ip(struct irdma_device *iwdev);
+void irdma_deinit_rf(struct irdma_pci_f *rf);
+int irdma_alloc_local_mac_entry(struct irdma_pci_f *rf, u16 *mac_tbl_idx);
+int irdma_add_local_mac_entry(struct irdma_pci_f *rf, u8 *mac_addr, u16 idx);
+void irdma_del_local_mac_entry(struct irdma_pci_f *rf, u16 idx);
+
+u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf);
+void irdma_port_ibevent(struct irdma_device *iwdev);
+void irdma_cm_disconn(struct irdma_qp *qp);
+
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
+void irdma_free_qp_rsrc(struct irdma_device *iwdev, struct irdma_qp *iwqp,
+			u32 qp_num);
+enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev, u8 ver);
+void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core);
+void irdma_next_iw_state(struct irdma_qp *iwqp, u8 state, u8 del_hash, u8 term,
+			 u8 term_len);
+int irdma_send_syn(struct irdma_cm_node *cm_node, u32 sendack);
+int irdma_send_reset(struct irdma_cm_node *cm_node);
+struct irdma_cm_node *irdma_find_node(struct irdma_cm_core *cm_core,
+				      u16 rem_port, u32 *rem_addr, u16 loc_port,
+				      u32 *loc_addr, bool add_refcnt,
+				      bool accelerated_list);
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
+void cqp_compl_worker(struct work_struct *work);
+int irdma_inetaddr_event(struct notifier_block *notifier, unsigned long event,
+			 void *ptr);
+int irdma_inet6addr_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+int irdma_net_event(struct notifier_block *notifier, unsigned long event,
+		    void *ptr);
+int irdma_netdevice_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+bool irdma_lan_vsi_ready(struct virtbus_device *vdev);
+int irdma_probe_dev(struct virtbus_device *vdev);
+int irdma_remove_dev(struct virtbus_device *vdev);
+int i40iw_probe_dev(struct virtbus_device *vdev);
+int i40iw_remove_dev(struct virtbus_device *vdev);
+void irdma_register_notifiers(void);
+void irdma_unregister_notifiers(void);
+void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq);
+int irdma_ah_cqp_op(struct irdma_pci_f *rf, struct irdma_sc_ah *sc_ah, u8 cmd,
+		    bool wait,
+		    void (*callback_fcn)(struct irdma_cqp_request *cqp_request),
+		    void *cb_param);
+void irdma_gsi_ud_qp_ah_cb(struct irdma_cqp_request *cqp_request);
+int irdma_configfs_init(void);
+void irdma_configfs_exit(void);
+#endif /* IRDMA_MAIN_H */
-- 
2.25.2

