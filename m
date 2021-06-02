Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900243994D9
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFBUyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:54:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:25929 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhFBUyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:54:40 -0400
IronPort-SDR: GwUuvKtsWtSBzrcOJKFrQGPX0DDyKsxdySHxIBw3MAY0EXx/w1UMVonzF7BI7ZKz5UT7pZrZhb
 1l+D/rQyqw6A==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="289522862"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="289522862"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:52:56 -0700
IronPort-SDR: jjbwQrS0I5l+Ck48UAIgTTSxoTGK0/y5MQGwVqoA6Pei+NDmCgE+9YJoooCUrVho21KcXIRHbt
 PkLSuKtrfrUg==
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="447560956"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.38.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:52:55 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        gustavoars@kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v7 01/16] RDMA/irdma: Register auxiliary driver and implement private channel OPs
Date:   Wed,  2 Jun 2021 15:51:23 -0500
Message-Id: <20210602205138.889-2-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210602205138.889-1-shiraz.saleem@intel.com>
References: <20210602205138.889-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Register auxiliary drivers which can attach to auxiliary RDMA
devices from Intel PCI netdev drivers i40e and ice. Implement the private
channel ops, and register net notifiers.

[flexible array transformation]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/i40iw_if.c | 216 +++++++++++++
 drivers/infiniband/hw/irdma/main.c     | 358 +++++++++++++++++++++
 drivers/infiniband/hw/irdma/main.h     | 555 +++++++++++++++++++++++++++++++++
 3 files changed, 1129 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h

diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
new file mode 100644
index 0000000..bddf881
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#include "main.h"
+#include "i40iw_hw.h"
+#include <linux/net/intel/i40e_client.h>
+
+static struct i40e_client i40iw_client;
+
+/**
+ * i40iw_l2param_change - handle mss change
+ * @cdev_info: parent lan device information structure with data/ops
+ * @client: client for parameter change
+ * @params: new parameters from L2
+ */
+static void i40iw_l2param_change(struct i40e_info *cdev_info,
+				 struct i40e_client *client,
+				 struct i40e_params *params)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+	struct ib_device *ibdev;
+
+	ibdev = ib_device_get_by_netdev(cdev_info->netdev, RDMA_DRIVER_IRDMA);
+	if (!ibdev)
+		return;
+
+	iwdev = to_iwdev(ibdev);
+
+	if (iwdev->vsi.mtu != params->mtu) {
+		l2params.mtu_changed = true;
+		l2params.mtu = params->mtu;
+	}
+	irdma_change_l2params(&iwdev->vsi, &l2params);
+	ib_device_put(ibdev);
+}
+
+/**
+ * i40iw_close - client interface operation close for iwarp/uda device
+ * @cdev_info: parent lan device information structure with data/ops
+ * @client: client to close
+ * @reset: flag to indicate close on reset
+ *
+ * Called by the lan driver during the processing of client unregister
+ * Destroy and clean up the driver resources
+ */
+static void i40iw_close(struct i40e_info *cdev_info, struct i40e_client *client,
+			bool reset)
+{
+	struct irdma_device *iwdev;
+	struct ib_device *ibdev;
+
+	ibdev = ib_device_get_by_netdev(cdev_info->netdev, RDMA_DRIVER_IRDMA);
+	if (WARN_ON(!ibdev))
+		return;
+
+	iwdev = to_iwdev(ibdev);
+	if (reset)
+		iwdev->reset = true;
+
+	iwdev->iw_status = 0;
+	irdma_port_ibevent(iwdev);
+	ib_unregister_device_and_put(ibdev);
+	pr_debug("INIT: Gen1 PF[%d] close complete\n", PCI_FUNC(cdev_info->pcidev->devfn));
+}
+
+static void i40iw_request_reset(struct irdma_pci_f *rf)
+{
+	struct i40e_info *cdev_info = rf->cdev;
+
+	cdev_info->ops->request_reset(cdev_info, &i40iw_client, 1);
+}
+
+static void i40iw_fill_device_info(struct irdma_device *iwdev, struct i40e_info *cdev_info)
+{
+	struct irdma_pci_f *rf = iwdev->rf;
+
+	rf->rdma_ver = IRDMA_GEN_1;
+	rf->gen_ops.request_reset = i40iw_request_reset;
+	rf->pcidev = cdev_info->pcidev;
+	rf->hw.hw_addr = cdev_info->hw_addr;
+	rf->cdev = cdev_info;
+	rf->msix_count = cdev_info->msix_count;
+	rf->msix_entries = cdev_info->msix_entries;
+	rf->limits_sel = 5;
+	rf->protocol_used = IRDMA_IWARP_PROTOCOL_ONLY;
+	rf->iwdev = iwdev;
+
+	iwdev->init_state = INITIAL_STATE;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	iwdev->netdev = cdev_info->netdev;
+	iwdev->vsi_num = 0;
+}
+
+/**
+ * i40iw_open - client interface operation open for iwarp/uda device
+ * @cdev_info: parent lan device information structure with data/ops
+ * @client: iwarp client information, provided during registration
+ *
+ * Called by the lan driver during the processing of client register
+ * Create device resources, set up queues, pble and hmc objects and
+ * register the device with the ib verbs interface
+ * Return 0 if successful, otherwise return error
+ */
+static int i40iw_open(struct i40e_info *cdev_info, struct i40e_client *client)
+{
+	struct irdma_l2params l2params = {};
+	struct irdma_device *iwdev;
+	struct irdma_pci_f *rf;
+	int err = -EIO;
+	int i;
+	u16 qset;
+	u16 last_qset = IRDMA_NO_QSET;
+
+	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
+
+	iwdev->rf = kzalloc(sizeof(*rf), GFP_KERNEL);
+	if (!iwdev->rf) {
+		ib_dealloc_device(&iwdev->ibdev);
+		return -ENOMEM;
+	}
+
+	i40iw_fill_device_info(iwdev, cdev_info);
+	rf = iwdev->rf;
+
+	if (irdma_ctrl_init_hw(rf)) {
+		err = -EIO;
+		goto err_ctrl_init;
+	}
+
+	l2params.mtu = (cdev_info->params.mtu) ? cdev_info->params.mtu : IRDMA_DEFAULT_MTU;
+	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
+		qset = cdev_info->params.qos.prio_qos[i].qs_handle;
+		l2params.up2tc[i] = cdev_info->params.qos.prio_qos[i].tc;
+		l2params.qs_handle_list[i] = qset;
+		if (last_qset == IRDMA_NO_QSET)
+			last_qset = qset;
+		else if ((qset != last_qset) && (qset != IRDMA_NO_QSET))
+			iwdev->dcb = true;
+	}
+
+	if (irdma_rt_init_hw(iwdev, &l2params)) {
+		err = -EIO;
+		goto err_rt_init;
+	}
+
+	err = irdma_ib_register_device(iwdev);
+	if (err)
+		goto err_ibreg;
+
+	ibdev_dbg(&iwdev->ibdev, "INIT: Gen1 PF[%d] open success\n",
+		  PCI_FUNC(rf->pcidev->devfn));
+
+	return 0;
+
+err_ibreg:
+	irdma_rt_deinit_hw(iwdev);
+err_rt_init:
+	irdma_ctrl_deinit_hw(rf);
+err_ctrl_init:
+	kfree(iwdev->rf);
+	ib_dealloc_device(&iwdev->ibdev);
+
+	return err;
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
+static int i40iw_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
+{
+	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
+							       struct i40e_auxiliary_device,
+							       aux_dev);
+	struct i40e_info *cdev_info = i40e_adev->ldev;
+
+	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
+	i40e_client_device_register(cdev_info, &i40iw_client);
+
+	return 0;
+}
+
+static void i40iw_remove(struct auxiliary_device *aux_dev)
+{
+	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
+							       struct i40e_auxiliary_device,
+							       aux_dev);
+	struct i40e_info *cdev_info = i40e_adev->ldev;
+
+	return i40e_client_device_unregister(cdev_info);
+}
+
+static const struct auxiliary_device_id i40iw_auxiliary_id_table[] = {
+	{.name = "i40e.iwarp", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, i40iw_auxiliary_id_table);
+
+struct auxiliary_driver i40iw_auxiliary_drv = {
+	.name = "gen_1",
+	.id_table = i40iw_auxiliary_id_table,
+	.probe = i40iw_probe,
+	.remove = i40iw_remove,
+};
diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
new file mode 100644
index 0000000..ea59432
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2021 Intel Corporation */
+#include "main.h"
+#include "../../../net/ethernet/intel/ice/ice.h"
+
+MODULE_ALIAS("i40iw");
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
+static void irdma_prep_tc_change(struct irdma_device *iwdev)
+{
+	iwdev->vsi.tc_change_pending = true;
+	irdma_sc_suspend_resume_qps(&iwdev->vsi, IRDMA_OP_SUSPEND);
+
+	/* Wait for all qp's to suspend */
+	wait_event_timeout(iwdev->suspend_wq,
+			   !atomic_read(&iwdev->vsi.qp_suspend_reqs),
+			   IRDMA_EVENT_TIMEOUT);
+	irdma_ws_reset(&iwdev->vsi);
+}
+
+static void irdma_log_invalid_mtu(u16 mtu, struct irdma_sc_dev *dev)
+{
+	if (mtu < IRDMA_MIN_MTU_IPV4)
+		ibdev_warn(to_ibdev(dev), "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 576 for IPv4\n", mtu);
+	else if (mtu < IRDMA_MIN_MTU_IPV6)
+		ibdev_warn(to_ibdev(dev), "MTU setting [%d] too low for RDMA traffic. Minimum MTU is 1280 for IPv6\\n", mtu);
+}
+
+static void irdma_fill_qos_info(struct irdma_l2params *l2params,
+				struct iidc_qos_params *qos_info)
+{
+	int i;
+
+	l2params->num_tc = qos_info->num_tc;
+	l2params->vsi_prio_type = qos_info->vport_priority_type;
+	l2params->vsi_rel_bw = qos_info->vport_relative_bw;
+	for (i = 0; i < l2params->num_tc; i++) {
+		l2params->tc_info[i].egress_virt_up =
+			qos_info->tc_info[i].egress_virt_up;
+		l2params->tc_info[i].ingress_virt_up =
+			qos_info->tc_info[i].ingress_virt_up;
+		l2params->tc_info[i].prio_type = qos_info->tc_info[i].prio_type;
+		l2params->tc_info[i].rel_bw = qos_info->tc_info[i].rel_bw;
+		l2params->tc_info[i].tc_ctx = qos_info->tc_info[i].tc_ctx;
+	}
+	for (i = 0; i < IIDC_MAX_USER_PRIORITY; i++)
+		l2params->up2tc[i] = qos_info->up2tc[i];
+}
+
+static void irdma_iidc_event_handler(struct ice_pf *pf, struct iidc_event *event)
+{
+	struct irdma_device *iwdev = dev_get_drvdata(&pf->adev->dev);
+	struct irdma_l2params l2params = {};
+
+	if (*event->type & BIT(IIDC_EVENT_AFTER_MTU_CHANGE)) {
+		ibdev_dbg(&iwdev->ibdev, "CLNT: new MTU = %d\n", iwdev->netdev->mtu);
+		if (iwdev->vsi.mtu != iwdev->netdev->mtu) {
+			l2params.mtu = iwdev->netdev->mtu;
+			l2params.mtu_changed = true;
+			irdma_log_invalid_mtu(l2params.mtu, &iwdev->rf->sc_dev);
+			irdma_change_l2params(&iwdev->vsi, &l2params);
+		}
+	} else if (*event->type & BIT(IIDC_EVENT_BEFORE_TC_CHANGE)) {
+		if (iwdev->vsi.tc_change_pending)
+			return;
+
+		irdma_prep_tc_change(iwdev);
+	} else if (*event->type & BIT(IIDC_EVENT_AFTER_TC_CHANGE)) {
+		struct iidc_qos_params qos_info = {};
+
+		if (!iwdev->vsi.tc_change_pending)
+			return;
+
+		l2params.tc_changed = true;
+		ibdev_dbg(&iwdev->ibdev, "CLNT: TC Change\n");
+		ice_get_qos_params(pf, &qos_info);
+		iwdev->dcb = qos_info.num_tc > 1;
+		irdma_fill_qos_info(&l2params, &qos_info);
+		irdma_change_l2params(&iwdev->vsi, &l2params);
+	} else if (*event->type & BIT(IIDC_EVENT_CRIT_ERR)) {
+		ibdev_warn(&iwdev->ibdev, "ICE OICR event notification: oicr = 0x%08x\n",
+			   event->reg);
+		if (event->reg & IRDMAPFINT_OICR_PE_CRITERR_M) {
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
+		if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
+			ibdev_err(&iwdev->ibdev, "HMC Error\n");
+			iwdev->rf->reset = true;
+		}
+		if (event->reg & IRDMAPFINT_OICR_PE_PUSH_M) {
+			ibdev_err(&iwdev->ibdev, "PE Push Error\n");
+			iwdev->rf->reset = true;
+		}
+		if (iwdev->rf->reset)
+			iwdev->rf->gen_ops.request_reset(iwdev->rf);
+	}
+}
+
+/**
+ * irdma_request_reset - Request a reset
+ * @rf: RDMA PCI function
+ */
+static void irdma_request_reset(struct irdma_pci_f *rf)
+{
+	struct ice_pf *pf = rf->cdev;
+
+	ibdev_warn(&rf->iwdev->ibdev, "Requesting a reset\n");
+	ice_rdma_request_reset(pf, IIDC_PFR);
+}
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
+	struct ice_pf *pf = iwdev->rf->cdev;
+	struct iidc_rdma_qset_params qset = {};
+	int ret;
+
+	qset.qs_handle = tc_node->qs_handle;
+	qset.tc = tc_node->traffic_class;
+	qset.vport_id = vsi->vsi_idx;
+	ret = ice_add_rdma_qset(pf, &qset);
+	if (ret) {
+		ibdev_dbg(&iwdev->ibdev, "WS: LAN alloc_res for rdma qset failed.\n");
+		return IRDMA_ERR_REG_QSET;
+	}
+
+	tc_node->l2_sched_node_id = qset.teid;
+	vsi->qos[tc_node->user_pri].l2_sched_node_id = qset.teid;
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
+	struct ice_pf *pf = iwdev->rf->cdev;
+	struct iidc_rdma_qset_params qset = {};
+
+	qset.qs_handle = tc_node->qs_handle;
+	qset.tc = tc_node->traffic_class;
+	qset.vport_id = vsi->vsi_idx;
+	qset.teid = tc_node->l2_sched_node_id;
+
+	if (ice_del_rdma_qset(pf, &qset))
+		ibdev_dbg(&iwdev->ibdev, "WS: LAN free_res for rdma qset failed.\n");
+}
+
+static void irdma_remove(struct auxiliary_device *aux_dev)
+{
+	struct iidc_auxiliary_dev *iidc_adev = container_of(aux_dev,
+							    struct iidc_auxiliary_dev,
+							    adev);
+	struct ice_pf *pf = iidc_adev->pf;
+	struct irdma_device *iwdev = dev_get_drvdata(&aux_dev->dev);
+
+	irdma_ib_unregister_device(iwdev);
+	ice_rdma_update_vsi_filter(pf, iwdev->vsi_num, false);
+
+	pr_debug("INIT: Gen2 PF[%d] device remove success\n", PCI_FUNC(pf->pdev->devfn));
+}
+
+static void irdma_fill_device_info(struct irdma_device *iwdev, struct ice_pf *pf)
+{
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+
+	rf->cdev = pf;
+	rf->gen_ops.register_qset = irdma_lan_register_qset;
+	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
+	rf->hw.hw_addr = pf->hw.hw_addr;
+	rf->pcidev = pf->pdev;
+	rf->msix_count =  pf->num_rdma_msix;
+	rf->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
+	rf->default_vsi.vsi_idx = vsi->vsi_num;
+	rf->protocol_used = IRDMA_ROCE_PROTOCOL_ONLY;
+	rf->rdma_ver = IRDMA_GEN_2;
+	rf->rsrc_profile = IRDMA_HMC_PROFILE_DEFAULT;
+	rf->rst_to = IRDMA_RST_TIMEOUT_HZ;
+	rf->gen_ops.request_reset = irdma_request_reset;
+	rf->limits_sel = 7;
+	rf->iwdev = iwdev;
+
+	iwdev->netdev = vsi->netdev;
+	iwdev->vsi_num = vsi->vsi_num;
+	iwdev->init_state = INITIAL_STATE;
+	iwdev->roce_cwnd = IRDMA_ROCE_CWND_DEFAULT;
+	iwdev->roce_ackcreds = IRDMA_ROCE_ACKCREDS_DEFAULT;
+	iwdev->rcv_wnd = IRDMA_CM_DEFAULT_RCV_WND_SCALED;
+	iwdev->rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+	if (rf->protocol_used == IRDMA_ROCE_PROTOCOL_ONLY)
+		iwdev->roce_mode = true;
+}
+
+static int irdma_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
+{
+	struct iidc_auxiliary_dev *iidc_adev = container_of(aux_dev,
+							    struct iidc_auxiliary_dev,
+							    adev);
+	struct ice_pf *pf = iidc_adev->pf;
+	struct iidc_qos_params qos_info = {};
+	struct irdma_device *iwdev;
+	struct irdma_pci_f *rf;
+	struct irdma_l2params l2params = {};
+	int err;
+
+	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
+	iwdev->rf = kzalloc(sizeof(*rf), GFP_KERNEL);
+	if (!iwdev->rf) {
+		ib_dealloc_device(&iwdev->ibdev);
+		return -ENOMEM;
+	}
+
+	irdma_fill_device_info(iwdev, pf);
+	rf = iwdev->rf;
+
+	if (irdma_ctrl_init_hw(rf)) {
+		err = -EIO;
+		goto err_ctrl_init;
+	}
+
+	l2params.mtu = iwdev->netdev->mtu;
+	ice_get_qos_params(pf, &qos_info);
+	irdma_fill_qos_info(&l2params, &qos_info);
+	if (irdma_rt_init_hw(iwdev, &l2params)) {
+		err = -EIO;
+		goto err_rt_init;
+	}
+
+	err = irdma_ib_register_device(iwdev);
+	if (err)
+		goto err_ibreg;
+
+	ice_rdma_update_vsi_filter(pf, iwdev->vsi_num, true);
+
+	ibdev_dbg(&iwdev->ibdev, "INIT: Gen2 PF[%d] device probe success\n", PCI_FUNC(rf->pcidev->devfn));
+	dev_set_drvdata(&aux_dev->dev, iwdev);
+
+	return 0;
+
+err_ibreg:
+	irdma_rt_deinit_hw(iwdev);
+err_rt_init:
+	irdma_ctrl_deinit_hw(rf);
+err_ctrl_init:
+	kfree(iwdev->rf);
+	ib_dealloc_device(&iwdev->ibdev);
+
+	return err;
+}
+
+static const struct auxiliary_device_id irdma_auxiliary_id_table[] = {
+	{.name = "ice.iwarp", },
+	{.name = "ice.roce", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, irdma_auxiliary_id_table);
+
+static struct iidc_auxiliary_drv irdma_auxiliary_drv = {
+	.adrv = {
+	    .id_table = irdma_auxiliary_id_table,
+	    .probe = irdma_probe,
+	    .remove = irdma_remove,
+	},
+	.event_handler = irdma_iidc_event_handler,
+};
+
+static int __init irdma_init_module(void)
+{
+	int ret;
+
+	ret = auxiliary_driver_register(&i40iw_auxiliary_drv);
+	if (ret) {
+		pr_err("Failed i40iw(gen_1) auxiliary_driver_register() ret=%d\n",
+		       ret);
+		return ret;
+	}
+
+	ret = auxiliary_driver_register(&irdma_auxiliary_drv.adrv);
+	if (ret) {
+		auxiliary_driver_unregister(&i40iw_auxiliary_drv);
+		pr_err("Failed irdma auxiliary_driver_register() ret=%d\n",
+		       ret);
+		return ret;
+	}
+
+	irdma_register_notifiers();
+
+	return 0;
+}
+
+static void __exit irdma_exit_module(void)
+{
+	irdma_unregister_notifiers();
+	auxiliary_driver_unregister(&irdma_auxiliary_drv.adrv);
+	auxiliary_driver_unregister(&i40iw_auxiliary_drv);
+}
+
+module_init(irdma_init_module);
+module_exit(irdma_exit_module);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
new file mode 100644
index 0000000..743d9e1
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -0,0 +1,555 @@
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
+#include <net/tcp.h>
+#include <net/ip6_route.h>
+#include <net/flow.h>
+#include <net/secure_seq.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
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
+#ifndef CONFIG_64BIT
+#include <linux/io-64-nonatomic-lo-hi.h>
+#endif
+#include <linux/auxiliary_bus.h>
+#include <linux/net/intel/iidc.h>
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
+extern struct auxiliary_driver i40iw_auxiliary_drv;
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
+struct irdma_gen_ops {
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
+	struct pci_dev *pcidev;
+	void *cdev;
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
+	struct msix_entry *msix_entries;
+	struct irdma_dma_mem obj_mem;
+	struct irdma_dma_mem obj_next;
+	atomic_t vchnl_msgs;
+	wait_queue_head_t vchnl_waitq;
+	struct workqueue_struct *cqp_cmpl_wq;
+	struct work_struct cqp_cmpl_work;
+	struct irdma_sc_vsi default_vsi;
+	void *back_fcn;
+	struct irdma_gen_ops gen_ops;
+	struct irdma_device *iwdev;
+};
+
+struct irdma_device {
+	struct ib_device ibdev;
+	struct irdma_pci_f *rf;
+	struct net_device *netdev;
+	struct workqueue_struct *cleanup_wq;
+	struct irdma_sc_vsi vsi;
+	struct irdma_cm_core cm_core;
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
+static inline struct irdma_pci_f *dev_to_rf(struct irdma_sc_dev *dev)
+{
+	return container_of(dev, struct irdma_pci_f, sc_dev);
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
+			ibdev_dbg(&rf->iwdev->ibdev,
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
+enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf);
+void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf);
+enum irdma_status_code irdma_rt_init_hw(struct irdma_device *iwdev,
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
+				      u32 *loc_addr, u16 vlan_id);
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
+int irdma_inetaddr_event(struct notifier_block *notifier, unsigned long event,
+			 void *ptr);
+int irdma_inet6addr_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+int irdma_net_event(struct notifier_block *notifier, unsigned long event,
+		    void *ptr);
+int irdma_netdevice_event(struct notifier_block *notifier, unsigned long event,
+			  void *ptr);
+void irdma_add_ip(struct irdma_device *iwdev);
+void cqp_compl_worker(struct work_struct *work);
+#endif /* IRDMA_MAIN_H */
-- 
1.8.3.1

