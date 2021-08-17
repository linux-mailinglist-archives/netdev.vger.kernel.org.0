Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982073EE5CC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhHQEqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237616AbhHQEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lc5s006745;
        Mon, 16 Aug 2021 21:45:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=7fodwde1ZCJ56+ZUpGjGytDgsRSxpX4rW7/UBDNyIX0=;
 b=hrTUznIYXITaftDxDc5HHkR5AgvaNHlDTsa23OH3DnyFiMkF+zuU4621zDOsnAWGQ1nj
 PfJRCbOWIWZ/Tgd4ofDUlSwz4Xabe7zrEL+XZXi5Uj4JG+ciOwv45+1BOU/4+tgkfn/x
 OCiqocCEcP/1syHwQRHjCbr8Kk0coPdS9dYBVSnXlLXduRI2PfyZniQIIRVc8nAxtRQL
 WgFj3sY1YGBqwecfSj8vivFIXPvQ6LAOEmYDplhWtOgMfv4zPT+fXQwY3xWyqy3dKb7h
 eUgppzZZOPKvP1l1b/kasMLi72gB6vaxggjInBjZDUjkSf+XbRDuFGqSpXQ8Y4ZaPsGC ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:22 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 4431F3F70A9;
        Mon, 16 Aug 2021 21:45:19 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 08/11] octeontx2-pf: devlink params support to set mcam entry count
Date:   Tue, 17 Aug 2021 10:14:50 +0530
Message-ID: <1629175493-4895-9-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HU0t7xyu6XTQ352ROVdntbfX_xitwI7m
X-Proofpoint-ORIG-GUID: HU0t7xyu6XTQ352ROVdntbfX_xitwI7m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added support for setting or modifying MCAM entry count at
runtime via devlink params.

commands:
  devlink dev param show
pci/0002:02:00.0:
  name mcam_count type driver-specific
    values:
      cmode runtime value 16

  devlink dev param set pci/0002:02:00.0 name mcam_count
				value 64 cmode runtime

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   5 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 156 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.h  |  20 +++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  31 ++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   5 +
 8 files changed, 221 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 3254b02..fcaa7df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -7,7 +7,8 @@ obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-               otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o
-rvu_nicvf-y := otx2_vf.o
+               otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
+               otx2_devlink.o
+rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index fc3447a..c4147b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -19,11 +19,13 @@
 #include <linux/timecounter.h>
 #include <linux/soc/marvell/octeontx2/asm.h>
 #include <net/pkt_cls.h>
+#include <net/devlink.h>
 
 #include <mbox.h>
 #include <npc.h>
 #include "otx2_reg.h"
 #include "otx2_txrx.h"
+#include "otx2_devlink.h"
 #include <rvu_trace.h>
 
 /* PCI device IDs */
@@ -376,6 +378,9 @@ struct otx2_nic {
 	struct hwtstamp_config	tstamp;
 
 	unsigned long		rq_bmap;
+
+	/* Devlink */
+	struct otx2_devlink	*dl;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
@@ -818,7 +823,7 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 /* MCAM filter related APIs */
 int otx2_mcam_flow_init(struct otx2_nic *pf);
 int otx2vf_mcam_flow_init(struct otx2_nic *pfvf);
-int otx2_alloc_mcam_entries(struct otx2_nic *pfvf);
+int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count);
 void otx2_mcam_flow_del(struct otx2_nic *pf);
 int otx2_destroy_ntuple_flows(struct otx2_nic *pf);
 int otx2_destroy_mcam_flows(struct otx2_nic *pfvf);
@@ -843,6 +848,7 @@ int otx2_init_tc(struct otx2_nic *nic);
 void otx2_shutdown_tc(struct otx2_nic *nic);
 int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		  void *type_data);
+int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic);
 /* CGX/RPM DMAC filters support */
 int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf);
 int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
new file mode 100644
index 0000000..7ac3ef2
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU PF/VF Netdev Devlink
+ *
+ * Copyright (C) 2021 Marvell.
+ */
+
+#include "otx2_common.h"
+
+/* Devlink Params APIs */
+static int otx2_dl_mcam_count_validate(struct devlink *devlink, u32 id,
+				       union devlink_param_value val,
+				       struct netlink_ext_ack *extack)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+	struct otx2_flow_config *flow_cfg;
+
+	if (!pfvf->flow_cfg) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "pfvf->flow_cfg not initialized");
+		return -EINVAL;
+	}
+
+	flow_cfg = pfvf->flow_cfg;
+	if (flow_cfg && flow_cfg->nr_flows) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot modify count when there are active rules");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int otx2_dl_mcam_count_set(struct devlink *devlink, u32 id,
+				  struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	if (!pfvf->flow_cfg)
+		return 0;
+
+	otx2_alloc_mcam_entries(pfvf, ctx->val.vu16);
+	otx2_tc_alloc_ent_bitmap(pfvf);
+
+	return 0;
+}
+
+static int otx2_dl_mcam_count_get(struct devlink *devlink, u32 id,
+				  struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+	struct otx2_flow_config *flow_cfg;
+
+	if (!pfvf->flow_cfg) {
+		ctx->val.vu16 = 0;
+		return 0;
+	}
+
+	flow_cfg = pfvf->flow_cfg;
+	ctx->val.vu16 = flow_cfg->max_flows;
+
+	return 0;
+}
+
+enum otx2_dl_param_id {
+	OTX2_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
+};
+
+static const struct devlink_param otx2_dl_params[] = {
+	DEVLINK_PARAM_DRIVER(OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
+			     "mcam_count", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_dl_mcam_count_get, otx2_dl_mcam_count_set,
+			     otx2_dl_mcam_count_validate),
+};
+
+/* Devlink OPs */
+static int otx2_devlink_info_get(struct devlink *devlink,
+				 struct devlink_info_req *req,
+				 struct netlink_ext_ack *extack)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	if (is_otx2_vf(pfvf->pcifunc))
+		return devlink_info_driver_name_put(req, "rvu_nicvf");
+
+	return devlink_info_driver_name_put(req, "rvu_nicpf");
+}
+
+static const struct devlink_ops otx2_devlink_ops = {
+	.info_get = otx2_devlink_info_get,
+};
+
+int otx2_register_dl(struct otx2_nic *pfvf)
+{
+	struct otx2_devlink *otx2_dl;
+	struct devlink *dl;
+	int err;
+
+	dl = devlink_alloc(&otx2_devlink_ops,
+			   sizeof(struct otx2_devlink), pfvf->dev);
+	if (!dl) {
+		dev_warn(pfvf->dev, "devlink_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	err = devlink_register(dl);
+	if (err) {
+		dev_err(pfvf->dev, "devlink register failed with error %d\n", err);
+		devlink_free(dl);
+		return err;
+	}
+
+	otx2_dl = devlink_priv(dl);
+	otx2_dl->dl = dl;
+	otx2_dl->pfvf = pfvf;
+	pfvf->dl = otx2_dl;
+
+	err = devlink_params_register(dl, otx2_dl_params,
+				      ARRAY_SIZE(otx2_dl_params));
+	if (err) {
+		dev_err(pfvf->dev,
+			"devlink params register failed with error %d", err);
+		goto err_dl;
+	}
+
+	devlink_params_publish(dl);
+
+	return 0;
+
+err_dl:
+	devlink_unregister(dl);
+	devlink_free(dl);
+	return err;
+}
+
+void otx2_unregister_dl(struct otx2_nic *pfvf)
+{
+	struct otx2_devlink *otx2_dl = pfvf->dl;
+	struct devlink *dl;
+
+	if (!otx2_dl || !otx2_dl->dl)
+		return;
+
+	dl = otx2_dl->dl;
+
+	devlink_params_unregister(dl, otx2_dl_params,
+				  ARRAY_SIZE(otx2_dl_params));
+
+	devlink_unregister(dl);
+	devlink_free(dl);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h
new file mode 100644
index 0000000..c7bd4f3
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell RVU PF/VF Netdev Devlink
+ *
+ * Copyright (C) 2021 Marvell.
+ *
+ */
+
+#ifndef	OTX2_DEVLINK_H
+#define	OTX2_DEVLINK_H
+
+struct otx2_devlink {
+	struct devlink *dl;
+	struct otx2_nic *pfvf;
+};
+
+/* Devlink APIs */
+int otx2_register_dl(struct otx2_nic *pfvf);
+void otx2_unregister_dl(struct otx2_nic *pfvf);
+
+#endif /* RVU_DEVLINK_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index de6ef32..86c305e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -11,6 +11,8 @@
 
 #define OTX2_DEFAULT_ACTION	0x1
 
+static int otx2_mcam_entry_init(struct otx2_nic *pfvf);
+
 struct otx2_flow {
 	struct ethtool_rx_flow_spec flow_spec;
 	struct list_head list;
@@ -66,7 +68,7 @@ static int mcam_entry_cmp(const void *a, const void *b)
 	return *(u16 *)a - *(u16 *)b;
 }
 
-static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
+int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
 	struct npc_mcam_alloc_entry_req *req;
@@ -81,8 +83,12 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 	flow_cfg->flow_ent = devm_kmalloc_array(pfvf->dev, count,
 						sizeof(u16), GFP_KERNEL);
-	if (!flow_cfg->flow_ent)
+	if (!flow_cfg->flow_ent) {
+		netdev_err(pfvf->netdev,
+			   "%s: Unable to allocate memory for flow entries\n",
+			    __func__);
 		return -ENOMEM;
+	}
 
 	mutex_lock(&pfvf->mbox.lock);
 
@@ -139,8 +145,10 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 	flow_cfg->max_flows = allocated;
 
-	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
-	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+	if (allocated) {
+		pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
+		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+	}
 
 	if (allocated != count)
 		netdev_info(pfvf->netdev,
@@ -148,8 +156,9 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 			    count, allocated);
 	return allocated;
 }
+EXPORT_SYMBOL(otx2_alloc_mcam_entries);
 
-int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
+static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
 	struct npc_mcam_alloc_entry_req *req;
@@ -209,7 +218,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 
 	/* Allocate entries for Ntuple filters */
-	count = otx2_alloc_ntuple_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
+	count = otx2_alloc_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
 	if (count <= 0) {
 		otx2_clear_ntuple_flow_info(pfvf, flow_cfg);
 		return 0;
@@ -223,7 +232,6 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg;
-	int count;
 
 	pfvf->flow_cfg = devm_kzalloc(pfvf->dev,
 				      sizeof(struct otx2_flow_config),
@@ -235,10 +243,6 @@ int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 	INIT_LIST_HEAD(&flow_cfg->flow_list);
 	flow_cfg->max_flows = 0;
 
-	count = otx2_alloc_ntuple_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
-	if (count <= 0)
-		return -ENOMEM;
-
 	return 0;
 }
 EXPORT_SYMBOL(otx2vf_mcam_flow_init);
@@ -254,7 +258,10 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
 
-	err = otx2_alloc_mcam_entries(pf);
+	/* Allocate bare minimum number of MCAM entries needed for
+	 * unicast and ntuple filters.
+	 */
+	err = otx2_mcam_entry_init(pf);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index de8b45e..7dd56c9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2626,6 +2626,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_mcam_flow_del;
 
+	err = otx2_register_dl(pf);
+	if (err)
+		goto err_mcam_flow_del;
+
 	/* Initialize SR-IOV resources */
 	err = otx2_sriov_vfcfg_init(pf);
 	if (err)
@@ -2783,6 +2787,7 @@ static void otx2_remove(struct pci_dev *pdev)
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
 
+	otx2_unregister_dl(pf);
 	unregister_netdev(netdev);
 	otx2_sriov_disable(pf->pdev);
 	otx2_sriov_vfcfg_cleanup(pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 77cf3dc..81840b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -52,13 +52,16 @@ struct otx2_tc_flow {
 	bool				is_act_police;
 };
 
-static int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
+int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 {
 	struct otx2_tc_info *tc = &nic->tc_info;
 
-	if (!nic->flow_cfg->max_flows)
+	if (!nic->flow_cfg->max_flows || is_otx2_vf(nic->pcifunc))
 		return 0;
 
+	/* Max flows changed, free the existing bitmap */
+	kfree(tc->tc_entries_bitmap);
+
 	tc->tc_entries_bitmap =
 			kcalloc(BITS_TO_LONGS(nic->flow_cfg->max_flows),
 				sizeof(long), GFP_KERNEL);
@@ -70,6 +73,7 @@ static int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 
 	return 0;
 }
+EXPORT_SYMBOL(otx2_tc_alloc_ent_bitmap);
 
 static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
 				      u32 *burst_mantissa)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 83a76d2..58b9126 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -687,6 +687,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
+	err = otx2_register_dl(vf);
+	if (err)
+		goto err_unreg_netdev;
+
 	/* Enable pause frames by default */
 	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
@@ -724,6 +728,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	vf = netdev_priv(netdev);
 
 	cancel_work_sync(&vf->reset_task);
+	otx2_unregister_dl(vf);
 	unregister_netdev(netdev);
 	if (vf->otx2_wq)
 		destroy_workqueue(vf->otx2_wq);
-- 
2.7.4

