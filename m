Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4985143DE3
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgAUNWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:09 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53524 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:08 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so1366287pjc.3
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OumDVWjwb3bJBcOFZwfQTtqb0eMrq8atcBh1dxmlZzw=;
        b=Ocu8FM+/vCutGo3iVk1an1KURY6sWSDc5D7Q0lHW8Vp8K/S4w45h2arJ1lBwaOFMNP
         dFUb2pW4Ko220SUkrrGY0v2E4z19zMYqjcqDKkbUmK6QTW5khEL10pMtn93Z5LHXCyhx
         pvRfjd/tK5NPnTpCJGebHIcYJR9izoQ1N3JwSyMUnnAmef59PPBOcF08ySe9qWs2rf7E
         y6zkxBkpqGrUC6phWUuXae0T1TbSGtOd0QLLd1Drp/xIzqioA+Gw3qPSEXRgy1/nEIVm
         NPe8wNkkmtc7+2eO+r0+3ZSoQL8spmr3jHwSmG/n8DetfiiXY84BQttJCe/fCuhJEky3
         kFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OumDVWjwb3bJBcOFZwfQTtqb0eMrq8atcBh1dxmlZzw=;
        b=KTVhy+8CiZupokeKjK32AJoSSrvsBu2TETZjx9pZzSo+mA7OJjT9OoAKDlnoiajmGG
         ixcTo/aNc2VsE+7O/d2mm3upjUQL9xANHHGsnJU1cKIsFLs9XN1fuVmd5FI+4+TCIu+K
         zp8fzvYq7lvI930RJk7o24X4kJxRH/fNB7soDc7HKLF5i6o5QOg8zJieza7rEleSJA0J
         r4T4pZJIdZJrOM5J8latRQjC1rE88uC4YDeCpHporPEGicB+s4Ju572Tmn1GbhWMg+cN
         gZQZHe8hOgZ4KquDTNLDBLNiDfoJQuLO28duF4jIfW6iqXNQiHx6cxieA6ZdqzGR920d
         PuyA==
X-Gm-Message-State: APjAAAV4YqNaDYx2UMxsiL8f5DzODJ6uKjH7DzfkTVGFi81VPS+qjJzs
        dEM01P5jwP2U/E+BlJfGTpEa7Givfe0=
X-Google-Smtp-Source: APXvYqwLZ/y3fT6Qqq6ZtOKC82B5Of9yhrrkHzF5Qy6pEHQcse/a4y6wmpuwWrIgh0jUyGOpHNowNw==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr5707347plv.194.1579612927612;
        Tue, 21 Jan 2020 05:22:07 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.22.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:22:07 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 03/17] octeontx2-pf: Attach NIX and NPA block LFs
Date:   Tue, 21 Jan 2020 18:51:37 +0530
Message-Id: <1579612911-24497-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

For a PF to function as a NIC, NPA (for Rx buffers, Tx descriptors etc)
and NIX (for rcv, send and completion queues) are the minimum resources
needed. So request admin function (AF) to attach one each of NIX and NPA
block LFs (local functions).

Only AF can configure a LF's contexts, so request AF to allocate memory
for NPA aura/pool and NIX RQ/SQ/CQ HW contexts. Upon receiving response,
save some of the HW constants like number of pointers per stack page,
size of send queue buffer (SQBs, where SQEs are queued by HW) e.t.c which
are later used to initialize queues.

A HW context here is like a state machine maintained for a descriptor
queue. eg size, head/tail pointers, irq etc etc. HW maintains this in
memory.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 170 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  36 +++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  72 ++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  20 +++
 4 files changed, 295 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cbab325..96e044c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -13,6 +13,176 @@
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
+#include "otx2_struct.h"
+
+int otx2_config_nix(struct otx2_nic *pfvf)
+{
+	struct nix_lf_alloc_req  *nixlf;
+	struct nix_lf_alloc_rsp *rsp;
+	int err;
+
+	pfvf->qset.xqe_size = NIX_XQESZ_W16 ? 128 : 512;
+
+	/* Get memory to put this msg */
+	nixlf = otx2_mbox_alloc_msg_nix_lf_alloc(&pfvf->mbox);
+	if (!nixlf)
+		return -ENOMEM;
+
+	/* Set RQ/SQ/CQ counts */
+	nixlf->rq_cnt = pfvf->hw.rx_queues;
+	nixlf->sq_cnt = pfvf->hw.tx_queues;
+	nixlf->cq_cnt = pfvf->qset.cq_cnt;
+	nixlf->xqe_sz = NIX_XQESZ_W16;
+	/* We don't know absolute NPA LF idx attached.
+	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
+	 * NPA LF attached to this RVU PF/VF.
+	 */
+	nixlf->npa_func = RVU_DEFAULT_PF_FUNC;
+	/* Disable alignment pad, enable L2 length check,
+	 * enable L4 TCP/UDP checksum verification.
+	 */
+	nixlf->rx_cfg = BIT_ULL(33) | BIT_ULL(35) | BIT_ULL(37);
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		return err;
+
+	rsp = (struct nix_lf_alloc_rsp *)otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0,
+							   &nixlf->hdr);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	if (rsp->qints < 1)
+		return -ENXIO;
+
+	return rsp->hdr.rc;
+}
+
+int otx2_config_npa(struct otx2_nic *pfvf)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct npa_lf_alloc_req  *npalf;
+	struct otx2_hw *hw = &pfvf->hw;
+	int aura_cnt, err;
+
+	/* Pool - Stack of free buffer pointers
+	 * Aura - Alloc/frees pointers from/to pool for NIX DMA.
+	 */
+
+	if (!hw->pool_cnt)
+		return -EINVAL;
+
+	qset->pool = devm_kzalloc(pfvf->dev, sizeof(struct otx2_pool) *
+				  hw->pool_cnt, GFP_KERNEL);
+	if (!qset->pool)
+		return -ENOMEM;
+
+	/* Get memory to put this msg */
+	npalf = otx2_mbox_alloc_msg_npa_lf_alloc(&pfvf->mbox);
+	if (!npalf)
+		return -ENOMEM;
+
+	/* Set aura and pool counts */
+	npalf->nr_pools = hw->pool_cnt;
+	aura_cnt = ilog2(roundup_pow_of_two(hw->pool_cnt));
+	npalf->aura_sz = (aura_cnt >= ilog2(128)) ? (aura_cnt - 6) : 1;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		return err;
+	return 0;
+}
+
+int otx2_detach_resources(struct mbox *mbox)
+{
+	struct rsrc_detach *detach;
+
+	otx2_mbox_lock(mbox);
+	detach = otx2_mbox_alloc_msg_detach_resources(mbox);
+	if (!detach) {
+		otx2_mbox_unlock(mbox);
+		return -ENOMEM;
+	}
+
+	/* detach all */
+	detach->partial = false;
+
+	/* Send detach request to AF */
+	otx2_mbox_msg_send(&mbox->mbox, 0);
+	otx2_mbox_unlock(mbox);
+	return 0;
+}
+
+int otx2_attach_npa_nix(struct otx2_nic *pfvf)
+{
+	struct rsrc_attach *attach;
+	struct msg_req *msix;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	/* Get memory to put this msg */
+	attach = otx2_mbox_alloc_msg_attach_resources(&pfvf->mbox);
+	if (!attach) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	attach->npalf = true;
+	attach->nixlf = true;
+
+	/* Send attach request to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return err;
+	}
+
+	/* Get NPA and NIX MSIX vector offsets */
+	msix = otx2_mbox_alloc_msg_msix_offset(&pfvf->mbox);
+	if (!msix) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return err;
+	}
+	otx2_mbox_unlock(&pfvf->mbox);
+
+	if (pfvf->hw.npa_msixoff == MSIX_VECTOR_INVALID ||
+	    pfvf->hw.nix_msixoff == MSIX_VECTOR_INVALID) {
+		dev_err(pfvf->dev,
+			"RVUPF: Invalid MSIX vector offset for NPA/NIX\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Mbox message handlers */
+void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
+			       struct npa_lf_alloc_rsp *rsp)
+{
+	pfvf->hw.stack_pg_ptrs = rsp->stack_pg_ptrs;
+	pfvf->hw.stack_pg_bytes = rsp->stack_pg_bytes;
+}
+
+void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
+			       struct nix_lf_alloc_rsp *rsp)
+{
+	pfvf->hw.sqb_size = rsp->sqb_size;
+	pfvf->hw.rx_chan_base = rsp->rx_chan_base;
+	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
+}
+
+void mbox_handler_msix_offset(struct otx2_nic *pfvf,
+			      struct msix_offset_rsp *rsp)
+{
+	pfvf->hw.npa_msixoff = rsp->npa_msixoff;
+	pfvf->hw.nix_msixoff = rsp->nix_msixoff;
+}
 
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
 int __weak								\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f194082..dcd768b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -25,6 +25,17 @@
 
 #define NAME_SIZE                               32
 
+struct otx2_pool {
+	struct qmem		*stack;
+};
+
+struct otx2_qset {
+#define OTX2_MAX_CQ_CNT		64
+	u16			cq_cnt;
+	u16			xqe_size; /* Size of CQE i.e 128 or 512 bytes*/
+	struct otx2_pool	*pool;
+};
+
 struct  mbox {
 	struct otx2_mbox	mbox;
 	struct work_struct	mbox_wrk;
@@ -42,8 +53,19 @@ struct otx2_hw {
 	u16                     rx_queues;
 	u16                     tx_queues;
 	u16			max_queues;
+	u16			pool_cnt;
+
+	/* NPA */
+	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
+	u32			stack_pg_bytes; /* Size of stack page */
+	u16			sqb_size;
+
+	u16			rx_chan_base;
+	u16			tx_chan_base;
 
 	/* MSI-X*/
+	u16			npa_msixoff; /* Offset of NPA vectors */
+	u16			nix_msixoff; /* Offset of NIX vectors */
 	char			*irq_name;
 	cpumask_var_t           *affinity_mask;
 };
@@ -52,6 +74,7 @@ struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
 
+	struct otx2_qset	qset;
 	struct otx2_hw		hw;
 	struct pci_dev		*pdev;
 	struct device		*dev;
@@ -240,4 +263,17 @@ MBOX_UP_CGX_MESSAGES
 #define	RVU_PFVF_FUNC_SHIFT	0
 #define	RVU_PFVF_FUNC_MASK	0x3FF
 
+/* RVU block related APIs */
+int otx2_attach_npa_nix(struct otx2_nic *pfvf);
+int otx2_detach_resources(struct mbox *mbox);
+int otx2_config_npa(struct otx2_nic *pfvf);
+int otx2_config_nix(struct otx2_nic *pfvf);
+
+/* Mbox handlers */
+void mbox_handler_msix_offset(struct otx2_nic *pfvf,
+			      struct msix_offset_rsp *rsp);
+void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
+			       struct npa_lf_alloc_rsp *rsp);
+void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
+			       struct nix_lf_alloc_rsp *rsp);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index eb8cf20..4ba1d39 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -114,6 +114,15 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 	case MBOX_MSG_READY:
 		pf->pcifunc = msg->pcifunc;
 		break;
+	case MBOX_MSG_MSIX_OFFSET:
+		mbox_handler_msix_offset(pf, (struct msix_offset_rsp *)msg);
+		break;
+	case MBOX_MSG_NPA_LF_ALLOC:
+		mbox_handler_npa_lf_alloc(pf, (struct npa_lf_alloc_rsp *)msg);
+		break;
+	case MBOX_MSG_NIX_LF_ALLOC:
+		mbox_handler_nix_lf_alloc(pf, (struct nix_lf_alloc_rsp *)msg);
+		break;
 	default:
 		if (msg->rc)
 			dev_err(pf->dev,
@@ -372,8 +381,23 @@ static int otx2_set_real_num_queues(struct net_device *netdev,
 
 static int otx2_open(struct net_device *netdev)
 {
+	struct otx2_nic *pf = netdev_priv(netdev);
+	int err = 0;
+
 	netif_carrier_off(netdev);
 
+	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tx_queues;
+
+	/* NPA init */
+	err = otx2_config_npa(pf);
+	if (err)
+		return err;
+
+	/* NIX init */
+	err = otx2_config_nix(pf);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -405,6 +429,34 @@ static int otx2_check_pf_usable(struct otx2_nic *nic)
 	return 0;
 }
 
+static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
+{
+	struct otx2_hw *hw = &pf->hw;
+	int num_vec, err;
+
+	/* NPA interrupts are inot registered, so alloc only
+	 * upto NIX vector offset.
+	 */
+	num_vec = hw->nix_msixoff;
+#define NIX_LF_CINT_VEC_START			0x40
+	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
+
+	otx2_disable_mbox_intr(pf);
+	pci_free_irq_vectors(hw->pdev);
+	pci_free_irq_vectors(hw->pdev);
+	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(pf->dev, "%s: Failed to realloc %d IRQ vectors\n",
+			__func__, num_vec);
+		return err;
+	}
+
+	err = otx2_register_mbox_intr(pf, false);
+	if (err)
+		return err;
+	return 0;
+}
+
 static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -441,7 +493,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	/* Set number of queues */
-	qcount = min_t(int, num_online_cpus(), num_online_cpus());
+	qcount = min_t(int, num_online_cpus(), OTX2_MAX_CQ_CNT);
 
 	netdev = alloc_etherdev_mqs(sizeof(*pf), qcount, qcount);
 	if (!netdev) {
@@ -503,20 +555,33 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_mbox_destroy;
 
-	err = otx2_set_real_num_queues(netdev, hw->tx_queues, hw->rx_queues);
+	/* Request AF to attach NPA and NIX LFs to this PF.
+	 * NIX and NPA LFs are needed for this PF to function as a NIC.
+	 */
+	err = otx2_attach_npa_nix(pf);
 	if (err)
 		goto err_disable_mbox_intr;
 
+	err = otx2_realloc_msix_vectors(pf);
+	if (err)
+		goto err_detach_rsrc;
+
+	err = otx2_set_real_num_queues(netdev, hw->tx_queues, hw->rx_queues);
+	if (err)
+		goto err_detach_rsrc;
+
 	netdev->netdev_ops = &otx2_netdev_ops;
 
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_disable_mbox_intr;
+		goto err_detach_rsrc;
 	}
 
 	return 0;
 
+err_detach_rsrc:
+	otx2_detach_resources(&pf->mbox);
 err_disable_mbox_intr:
 	otx2_disable_mbox_intr(pf);
 err_mbox_destroy:
@@ -542,6 +607,7 @@ static void otx2_remove(struct pci_dev *pdev)
 	pf = netdev_priv(netdev);
 
 	unregister_netdev(netdev);
+	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
 	pci_free_irq_vectors(pf->pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
new file mode 100644
index 0000000..e37f89f
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef OTX2_STRUCT_H
+#define OTX2_STRUCT_H
+
+/* NIX WQE/CQE size 128 byte or 512 byte */
+enum nix_cqesz_e {
+	NIX_XQESZ_W64 = 0x0,
+	NIX_XQESZ_W16 = 0x1,
+};
+
+#endif /* OTX2_STRUCT_H */
-- 
2.7.4

