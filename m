Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FDA6302B3
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbiKRXOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiKRXNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:14 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09AFCC156
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k7so5807145pll.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R63/sUQS/1yAPrePYnp8mZ5j3XHO5ipTyaNidk4x20A=;
        b=1fmI8FvDmrZcluSGIY8rTw4ZL69tGf2NONbaUflDPDRRRPwI+Rj/G2Dng+1508Vuri
         xIiYHzCkYMIHzDAHaakeq21cKk19XEBt28gtFZhfOnWkvbHyEBCLOH9ERJORHSHfqctj
         s8CsoW98VxkGWWPr42I5uUSWdMmkP5o36yYNldaxh6Kb04Jv+jjoEuGjI37ZnKjKJzVc
         sh/HX/WNZebbxsWrwinrOLzt/XYS98tixUOnayDcBPdue4xbqZazLe6YqOmPLJ8yP8GL
         PYHDuVvM2/6Mzo/6PgY0Jz5ctZhsuD6tHNDwsgT6oaf8ubEwUabFVltGv9Rkx3n9RMeD
         GGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R63/sUQS/1yAPrePYnp8mZ5j3XHO5ipTyaNidk4x20A=;
        b=z6Z6HLfLkYYd4oTihSTUoprmNA4D0QSvH5e4Y6Fgx9aWfLc56VhXwZ5XLVyIqvcACz
         le/uOLJN87FqbNd9DZ1j5utvHX9i0Bjk2vQKCfI/tbpf1ZiI+DwptwQd17xiBwN0uBtT
         kqrnTFSo7gfyGgrVSYTHr2LKWtkbIK6jE5PoePWD/tv4529g3TGkK4Uqd1Fm9WS8XPf5
         G1PsCjhEnGPFA3nRpUOAMu6drECLca+9nG2LspM4tkOuIjo21+CZiEsqiuiwMdDa+5uo
         v8XDgAhwTVKlo06aWXbRCp8mAO4dkkUc2bsTQuJuVGtxLLLCilObOumqk1dOg+Cp5G0x
         0ctw==
X-Gm-Message-State: ANoB5pndZUW6tpMdAzFi+iiCVNOPjhqIXFrSqxY/pc8guz90l3EP1LAb
        lBsq0N5UK+gblKNzanadffNyecXvO9g1Rw==
X-Google-Smtp-Source: AA0mqf5z7tFGDAiY5T2h9xlbKjWn1OKIhvaiRdvyhnrjuLJ3oZRpGZDjxtN0dvaIxp6fShGNFYOJLA==
X-Received: by 2002:a17:90b:804:b0:213:de70:9eb5 with SMTP id bk4-20020a17090b080400b00213de709eb5mr15680548pjb.145.1668812243152;
        Fri, 18 Nov 2022 14:57:23 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Date:   Fri, 18 Nov 2022 14:56:45 -0800
Message-Id: <20221118225656.48309-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to manage the VFs associated with thie Core PF we
need a PF netdev.  This netdev is a simple representor to make
available the "ip link set <if> vf ..." commands that are useful
for setting attributes used by the vDPA VF.  There is no packet
handling in this netdev as the Core device has no Tx/Rx queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   1 +
 drivers/net/ethernet/pensando/pds_core/core.c |  17 +
 drivers/net/ethernet/pensando/pds_core/core.h |  24 +
 drivers/net/ethernet/pensando/pds_core/main.c |  65 +++
 .../net/ethernet/pensando/pds_core/netdev.c   | 504 ++++++++++++++++++
 5 files changed, 611 insertions(+)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/netdev.c

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index 06bd3da8c38b..ee794cc08fda 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -8,6 +8,7 @@ pds_core-y := main.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
+	      netdev.o \
 	      fw.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index 203a27a0fc5c..202f1a6b4605 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -449,6 +449,12 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (init)
 		pdsc_debugfs_add_viftype(pdsc);
 
+	if (init) {
+		err = pdsc_init_netdev(pdsc);
+		if (err)
+			goto err_out_teardown;
+	}
+
 	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
 	return 0;
 
@@ -461,6 +467,12 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
 	int i;
 
+	if (removing && pdsc->netdev) {
+		unregister_netdev(pdsc->netdev);
+		free_netdev(pdsc->netdev);
+		pdsc->netdev = NULL;
+	}
+
 	pdsc_devcmd_reset(pdsc);
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
@@ -528,6 +540,7 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	netif_device_detach(pdsc->netdev);
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 
@@ -554,8 +567,12 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	netif_device_attach(pdsc->netdev);
+
 	mutex_unlock(&pdsc->config_lock);
 
+	pdsc_vf_attr_replay(pdsc);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 46d10afb0bde..07499a8aae21 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -30,6 +30,22 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_vf {
+	u16     index;
+	u8      macaddr[6];
+	__le32  maxrate;
+	__le16  vlanid;
+	u8      spoofchk;
+	u8      trusted;
+	u8      linkstate;
+	__le16  vif_types[PDS_DEV_TYPE_MAX];
+
+	struct pds_core_vf_stats stats;
+	dma_addr_t               stats_pa;
+
+	struct pds_auxiliary_dev *padev;
+};
+
 struct pdsc_devinfo {
 	u8 asic_type;
 	u8 asic_rev;
@@ -153,6 +169,7 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	struct pdsc_vf *vfs;
 	int num_vfs;
 	int hw_index;
 	int id;
@@ -172,6 +189,8 @@ struct pdsc {
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
 	struct workqueue_struct *wq;
+	struct net_device *netdev;
+	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
 
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
@@ -309,4 +328,9 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
 
+int pdsc_init_netdev(struct pdsc *pdsc);
+int pdsc_set_vf_config(struct pdsc *pdsc, int vf,
+		       struct pds_core_vf_setattr_cmd *vfc);
+void pdsc_vf_attr_replay(struct pdsc *pdsc);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 856704f8827a..36e330c49360 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -165,6 +165,67 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
 			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
 }
 
+static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_STATSADDR };
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct device *dev = pdsc->dev;
+	struct pdsc_vf *v;
+	int ret = 0;
+	int i;
+
+	if (num_vfs > 0) {
+		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf), GFP_KERNEL);
+		if (!pdsc->vfs)
+			return -ENOMEM;
+		pdsc->num_vfs = num_vfs;
+
+		for (i = 0; i < num_vfs; i++) {
+			v = &pdsc->vfs[i];
+			v->stats_pa = dma_map_single(pdsc->dev, &v->stats,
+						     sizeof(v->stats), DMA_FROM_DEVICE);
+			if (dma_mapping_error(pdsc->dev, v->stats_pa)) {
+				dev_err(pdsc->dev, "DMA mapping failed for vf[%d] stats\n", i);
+				v->stats_pa = 0;
+			} else {
+				vfc.stats.len = cpu_to_le32(sizeof(v->stats));
+				vfc.stats.pa = cpu_to_le64(v->stats_pa);
+				pdsc_set_vf_config(pdsc, i, &vfc);
+			}
+		}
+
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot enable SRIOV: %pe\n", ERR_PTR(ret));
+			goto no_vfs;
+		}
+
+		return num_vfs;
+	}
+
+no_vfs:
+	pci_disable_sriov(pdev);
+
+	for (i = pdsc->num_vfs - 1; i >= 0; i--) {
+		v = &pdsc->vfs[i];
+
+		if (v->stats_pa) {
+			vfc.stats.len = 0;
+			vfc.stats.pa = 0;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			dma_unmap_single(pdsc->dev, v->stats_pa,
+					 sizeof(v->stats), DMA_FROM_DEVICE);
+			v->stats_pa = 0;
+		}
+	}
+
+	kfree(pdsc->vfs);
+	pdsc->vfs = NULL;
+	pdsc->num_vfs = 0;
+
+	return ret;
+}
+
 static DEFINE_IDA(pdsc_pf_ida);
 
 #define PDSC_WQ_NAME_LEN 24
@@ -237,6 +298,7 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&pdsc->adminq_lock);
 
 	mutex_lock(&pdsc->config_lock);
+	init_rwsem(&pdsc->vf_op_lock);
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err)
 		goto err_out_unmap_bars;
@@ -300,6 +362,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	pdsc_sriov_configure(pdev, 0);
+
 	/* Now we can lock it up and tear it down */
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
@@ -337,6 +401,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
diff --git a/drivers/net/ethernet/pensando/pds_core/netdev.c b/drivers/net/ethernet/pensando/pds_core/netdev.c
new file mode 100644
index 000000000000..0d7f9c2c7df8
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/netdev.c
@@ -0,0 +1,504 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <net/devlink.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+
+#include "core.h"
+
+static const char *pdsc_vf_attr_to_str(enum pds_core_vf_attr attr)
+{
+	switch (attr) {
+	case PDS_CORE_VF_ATTR_SPOOFCHK:
+		return "PDS_CORE_VF_ATTR_SPOOFCHK";
+	case PDS_CORE_VF_ATTR_TRUST:
+		return "PDS_CORE_VF_ATTR_TRUST";
+	case PDS_CORE_VF_ATTR_LINKSTATE:
+		return "PDS_CORE_VF_ATTR_LINKSTATE";
+	case PDS_CORE_VF_ATTR_MAC:
+		return "PDS_CORE_VF_ATTR_MAC";
+	case PDS_CORE_VF_ATTR_VLAN:
+		return "PDS_CORE_VF_ATTR_VLAN";
+	case PDS_CORE_VF_ATTR_RATE:
+		return "PDS_CORE_VF_ATTR_RATE";
+	case PDS_CORE_VF_ATTR_STATSADDR:
+		return "PDS_CORE_VF_ATTR_STATSADDR";
+	default:
+		return "PDS_CORE_VF_ATTR_UNKNOWN";
+	}
+}
+
+static int pdsc_get_vf_stats(struct net_device *netdev, int vf,
+			     struct ifla_vf_stats *vf_stats)
+{
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	struct pds_core_vf_stats *vs;
+	int err = 0;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_read(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		memset(vf_stats, 0, sizeof(*vf_stats));
+		vs = &pdsc->vfs[vf].stats;
+
+		vf_stats->rx_packets = le64_to_cpu(vs->rx_ucast_packets);
+		vf_stats->tx_packets = le64_to_cpu(vs->tx_ucast_packets);
+		vf_stats->rx_bytes   = le64_to_cpu(vs->rx_ucast_bytes);
+		vf_stats->tx_bytes   = le64_to_cpu(vs->tx_ucast_bytes);
+		vf_stats->broadcast  = le64_to_cpu(vs->rx_bcast_packets);
+		vf_stats->multicast  = le64_to_cpu(vs->rx_mcast_packets);
+		vf_stats->rx_dropped = le64_to_cpu(vs->rx_ucast_drop_packets) +
+				       le64_to_cpu(vs->rx_mcast_drop_packets) +
+				       le64_to_cpu(vs->rx_bcast_drop_packets);
+		vf_stats->tx_dropped = le64_to_cpu(vs->tx_ucast_drop_packets) +
+				       le64_to_cpu(vs->tx_mcast_drop_packets) +
+				       le64_to_cpu(vs->tx_bcast_drop_packets);
+	}
+
+	up_read(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_get_fw_vf_config(struct pdsc *pdsc, int vf, struct pdsc_vf *vfdata)
+{
+	struct pds_core_vf_getattr_comp comp = { 0 };
+	int err;
+	u8 attr;
+
+	attr = PDS_CORE_VF_ATTR_VLAN;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		vfdata->vlanid = comp.vlanid;
+
+	attr = PDS_CORE_VF_ATTR_SPOOFCHK;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		vfdata->spoofchk = comp.spoofchk;
+
+	attr = PDS_CORE_VF_ATTR_LINKSTATE;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err) {
+		switch (comp.linkstate) {
+		case PDS_CORE_VF_LINK_STATUS_UP:
+			vfdata->linkstate = IFLA_VF_LINK_STATE_ENABLE;
+			break;
+		case PDS_CORE_VF_LINK_STATUS_DOWN:
+			vfdata->linkstate = IFLA_VF_LINK_STATE_DISABLE;
+			break;
+		case PDS_CORE_VF_LINK_STATUS_AUTO:
+			vfdata->linkstate = IFLA_VF_LINK_STATE_AUTO;
+			break;
+		default:
+			dev_warn(pdsc->dev, "Unexpected link state %u\n", comp.linkstate);
+			break;
+		}
+	}
+
+	attr = PDS_CORE_VF_ATTR_RATE;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		vfdata->maxrate = comp.maxrate;
+
+	attr = PDS_CORE_VF_ATTR_TRUST;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		vfdata->trusted = comp.trust;
+
+	attr = PDS_CORE_VF_ATTR_MAC;
+	err = pdsc_dev_cmd_vf_getattr(pdsc, vf, attr, &comp);
+	if (err && comp.status != PDS_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ether_addr_copy(vfdata->macaddr, comp.macaddr);
+
+err_out:
+	if (err)
+		dev_err(pdsc->dev, "Failed to get %s for VF %d\n",
+			pdsc_vf_attr_to_str(attr), vf);
+
+	return err;
+}
+
+static int pdsc_get_vf_config(struct net_device *netdev,
+			      int vf, struct ifla_vf_info *ivf)
+{
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	struct pdsc_vf vfdata = { 0 };
+	int err = 0;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_read(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		ivf->vf = vf;
+		ivf->qos = 0;
+
+		err = pdsc_get_fw_vf_config(pdsc, vf, &vfdata);
+		if (!err) {
+			ivf->vlan         = le16_to_cpu(vfdata.vlanid);
+			ivf->spoofchk     = vfdata.spoofchk;
+			ivf->linkstate    = vfdata.linkstate;
+			ivf->max_tx_rate  = le32_to_cpu(vfdata.maxrate);
+			ivf->trusted      = vfdata.trusted;
+			ether_addr_copy(ivf->mac, vfdata.macaddr);
+		}
+	}
+
+	up_read(&pdsc->vf_op_lock);
+	return err;
+}
+
+int pdsc_set_vf_config(struct pdsc *pdsc, int vf,
+		       struct pds_core_vf_setattr_cmd *vfc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.vf_setattr.opcode = PDS_CORE_CMD_VF_SETATTR,
+		.vf_setattr.attr = vfc->attr,
+		.vf_setattr.vf_index = cpu_to_le16(vf),
+	};
+	int err;
+
+	if (vf >= pdsc->num_vfs)
+		return -EINVAL;
+
+	memcpy(cmd.vf_setattr.pad, vfc->pad, sizeof(vfc->pad));
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+
+	return err;
+}
+
+static int pdsc_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_MAC };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	int err;
+
+	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
+		return -EINVAL;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		ether_addr_copy(vfc.macaddr, mac);
+		dev_dbg(pdsc->dev, "%s: vf %d macaddr %pM\n",
+			__func__, vf, vfc.macaddr);
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			ether_addr_copy(pdsc->vfs[vf].macaddr, mac);
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
+			    u8 qos, __be16 proto)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_VLAN };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	int err;
+
+	/* until someday when we support qos */
+	if (qos)
+		return -EINVAL;
+
+	if (vlan > 4095)
+		return -EINVAL;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		vfc.vlanid = cpu_to_le16(vlan);
+		dev_dbg(pdsc->dev, "%s: vf %d vlan %d\n",
+			__func__, vf, le16_to_cpu(vfc.vlanid));
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			pdsc->vfs[vf].vlanid = cpu_to_le16(vlan);
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_set_vf_trust(struct net_device *netdev, int vf, bool set)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_TRUST };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int err;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		vfc.trust = set;
+		dev_dbg(pdsc->dev, "%s: vf %d trust %d\n",
+			__func__, vf, vfc.trust);
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			pdsc->vfs[vf].trusted = data;
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_set_vf_rate(struct net_device *netdev, int vf,
+			    int tx_min, int tx_max)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_RATE };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	int err;
+
+	/* setting the min just seems silly */
+	if (tx_min)
+		return -EINVAL;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		vfc.maxrate = cpu_to_le32(tx_max);
+		dev_dbg(pdsc->dev, "%s: vf %d maxrate %d\n",
+			__func__, vf, le32_to_cpu(vfc.maxrate));
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			pdsc->vfs[vf].maxrate = cpu_to_le32(tx_max);
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_SPOOFCHK };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int err;
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		vfc.spoofchk = set;
+		dev_dbg(pdsc->dev, "%s: vf %d spoof %d\n",
+			__func__, vf, vfc.spoofchk);
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			pdsc->vfs[vf].spoofchk = data;
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static int pdsc_set_vf_link_state(struct net_device *netdev, int vf, int set)
+{
+	struct pds_core_vf_setattr_cmd vfc = { .attr = PDS_CORE_VF_ATTR_LINKSTATE };
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+	u8 data;
+	int err;
+
+	switch (set) {
+	case IFLA_VF_LINK_STATE_ENABLE:
+		data = PDS_CORE_VF_LINK_STATUS_UP;
+		break;
+	case IFLA_VF_LINK_STATE_DISABLE:
+		data = PDS_CORE_VF_LINK_STATUS_DOWN;
+		break;
+	case IFLA_VF_LINK_STATE_AUTO:
+		data = PDS_CORE_VF_LINK_STATUS_AUTO;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
+	down_write(&pdsc->vf_op_lock);
+
+	if (vf >= pci_num_vf(pdsc->pdev) || !pdsc->vfs) {
+		err = -EINVAL;
+	} else {
+		vfc.linkstate = data;
+		dev_dbg(pdsc->dev, "%s: vf %d linkstate %d\n",
+			__func__, vf, vfc.linkstate);
+
+		err = pdsc_set_vf_config(pdsc, vf, &vfc);
+		if (!err)
+			pdsc->vfs[vf].linkstate = set;
+	}
+
+	up_write(&pdsc->vf_op_lock);
+	return err;
+}
+
+static const struct net_device_ops pdsc_netdev_ops = {
+	.ndo_set_vf_vlan	= pdsc_set_vf_vlan,
+	.ndo_set_vf_mac		= pdsc_set_vf_mac,
+	.ndo_set_vf_trust	= pdsc_set_vf_trust,
+	.ndo_set_vf_rate	= pdsc_set_vf_rate,
+	.ndo_set_vf_spoofchk	= pdsc_set_vf_spoofchk,
+	.ndo_set_vf_link_state	= pdsc_set_vf_link_state,
+	.ndo_get_vf_config	= pdsc_get_vf_config,
+	.ndo_get_vf_stats       = pdsc_get_vf_stats,
+};
+
+static void pdsc_get_drvinfo(struct net_device *netdev,
+			     struct ethtool_drvinfo *drvinfo)
+{
+	struct pdsc *pdsc = *(struct pdsc **)netdev_priv(netdev);
+
+	strscpy(drvinfo->driver, PDS_CORE_DRV_NAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->fw_version, pdsc->dev_info.fw_version, sizeof(drvinfo->fw_version));
+	strscpy(drvinfo->bus_info, pci_name(pdsc->pdev), sizeof(drvinfo->bus_info));
+}
+
+static const struct ethtool_ops pdsc_ethtool_ops = {
+	.get_drvinfo = pdsc_get_drvinfo,
+};
+
+int pdsc_init_netdev(struct pdsc *pdsc)
+{
+	struct pdsc **p;
+
+	pdsc->netdev = alloc_netdev(sizeof(struct pdsc *), "pdsc%d",
+				    NET_NAME_UNKNOWN, ether_setup);
+	SET_NETDEV_DEV(pdsc->netdev, pdsc->dev);
+	pdsc->netdev->netdev_ops = &pdsc_netdev_ops;
+	pdsc->netdev->ethtool_ops = &pdsc_ethtool_ops;
+
+	p = netdev_priv(pdsc->netdev);
+	*p = pdsc;
+
+	netif_carrier_off(pdsc->netdev);
+
+	return register_netdev(pdsc->netdev);
+}
+
+void pdsc_vf_attr_replay(struct pdsc *pdsc)
+{
+	struct pds_core_vf_setattr_cmd vfc;
+	struct pdsc_vf *v;
+	int i;
+
+	if (!pdsc->vfs)
+		return;
+
+	down_read(&pdsc->vf_op_lock);
+
+	for (i = 0; i < pdsc->num_vfs; i++) {
+		v = &pdsc->vfs[i];
+
+		if (v->stats_pa) {
+			vfc.attr = PDS_CORE_VF_ATTR_STATSADDR;
+			vfc.stats.len = cpu_to_le32(sizeof(v->stats_pa));
+			vfc.stats.pa = cpu_to_le64(v->stats_pa);
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.stats.pa = 0;
+			vfc.stats.len = 0;
+		}
+
+		if (!is_zero_ether_addr(v->macaddr)) {
+			vfc.attr = PDS_CORE_VF_ATTR_MAC;
+			ether_addr_copy(vfc.macaddr, v->macaddr);
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			eth_zero_addr(vfc.macaddr);
+		}
+
+		if (v->vlanid) {
+			vfc.attr = PDS_CORE_VF_ATTR_VLAN;
+			vfc.vlanid = v->vlanid;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.vlanid = 0;
+		}
+
+		if (v->maxrate) {
+			vfc.attr = PDS_CORE_VF_ATTR_RATE;
+			vfc.maxrate = v->maxrate;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.maxrate = 0;
+		}
+
+		if (v->spoofchk) {
+			vfc.attr = PDS_CORE_VF_ATTR_SPOOFCHK;
+			vfc.spoofchk = v->spoofchk;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.spoofchk = 0;
+		}
+
+		if (v->trusted) {
+			vfc.attr = PDS_CORE_VF_ATTR_TRUST;
+			vfc.trust = v->trusted;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.trust = 0;
+		}
+
+		if (v->linkstate) {
+			vfc.attr = PDS_CORE_VF_ATTR_LINKSTATE;
+			vfc.linkstate = v->linkstate;
+			pdsc_set_vf_config(pdsc, i, &vfc);
+			vfc.linkstate = 0;
+		}
+	}
+
+	up_read(&pdsc->vf_op_lock);
+
+	pds_devcmd_vf_start(pdsc);
+}
-- 
2.17.1

