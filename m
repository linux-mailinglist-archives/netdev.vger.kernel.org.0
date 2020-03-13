Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35A41843F9
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCMJnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:43:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43342 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMJnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:43:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id f8so3981891plt.10
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O7sNt7LwTrFTH29C5t2tIDkD6tWDevgSSM91H6HHj5I=;
        b=sigkyUuZytoq48QYq2xB6ppYoMLcs3+PrR/w3ucjHlPdw8+it+0EuzwWtDujy0mDiN
         39ZacpDO+/3qL1T+CvymY1qhn32EaS4bDkFB/vvbV4LQliYFuHCNfkgf7Ajzy1A+SQ9/
         8BvY5no6oR3/P76xhtasf2yVprPeUNpGf94rl4lJ+1A7xnwyzL1kVpFa8MjZQBgp14y7
         eRDsRaFH/EsmbxXcG2e1fdP+neS9FddLBl6y5vLuwXJTUFGbFvYSCbeuQ1LVQnrlegmC
         BLXXU18CT2m50IrORsVuZmuLJDvhYp3J2xUTbJNoW42fxYGf767/uikvQ5lkhffundoO
         PAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O7sNt7LwTrFTH29C5t2tIDkD6tWDevgSSM91H6HHj5I=;
        b=AasLg9E+yGkzE/Cc9dGjSLhYR8hsTIYKNffMSOKcLdwEaOejj8s+/npjU0+h7TLRZ9
         +G3ewzyeA4KC2hEit2afEYHIQbITX3+wDIHX2Vihu1N93xB1JT3IgMm3wQQOVoNq1MZC
         NoMgrw+PGD+cHh1UVkev99GJhTM6UkGnFFoR2yXcA+rGQK8V2zIAlOmy6nhG90GTduak
         DDoug8CeHgt+Trc9cV9v03OxvyEb6Vl2mnJU9Vt3SxtoducwMh8MuIFtbIEumR5zMOyB
         a8/z2t0Gh8snNGgEdBILcECtUbpDDpuUfdw4ULBC9xHJbTuRMGNgCirWsTHpf4DWDcJ1
         TeaQ==
X-Gm-Message-State: ANhLgQ3JKZAq8VIM3qQCbArXPN+o3+z1hq5j8R99d1pdrv41XPVoUMNP
        TQ8Z7Kc+Df7ul+CHI4h1xA8AWE1swIo=
X-Google-Smtp-Source: ADFU+vte4SQM1noXRypmP2QHEjZ7OKY8vkHEv9CfDs4aZUw6L6wOJ0aJsJiH/rB37BzE2ssP/pH7kg==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr8775407pjv.19.1584092599158;
        Fri, 13 Mar 2020 02:43:19 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm13896386pfc.120.2020.03.13.02.43.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Mar 2020 02:43:18 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 net-next 5/7] octeontx2-vf: Link event notification support
Date:   Fri, 13 Mar 2020 15:12:44 +0530
Message-Id: <1584092566-4793-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tomasz Duszynski <tduszynski@marvell.com>

VF shares physical link with PF. Admin function (AF) sends
notification to PF whenever a link change event happens. PF
has to forward the same notification to each of the enabled VF.

PF traps START/STOP_RX messages sent by VF to AF to keep track of
VF's enabled/disabled state.

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  7 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 88 +++++++++++++++++++++-
 2 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 95b8f1e..5c96fee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -193,6 +193,12 @@ struct otx2_hw {
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
 };
 
+struct otx2_vf_config {
+	struct otx2_nic *pf;
+	struct delayed_work link_event_work;
+	bool intf_down; /* interface was either configured or not */
+};
+
 struct flr_work {
 	struct work_struct work;
 	struct otx2_nic *pf;
@@ -229,6 +235,7 @@ struct otx2_nic {
 	u8			total_vfs;
 	u16			pcifunc; /* RVU PF_FUNC */
 	u16			bpid[NIX_MAX_BPID_CHAN];
+	struct otx2_vf_config	*vf_configs;
 	struct cgx_link_user_info linfo;
 
 	u64			reset_count;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 89644d5..6564f45 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -717,6 +717,8 @@ static int otx2_register_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
 static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 				       struct mbox_msghdr *msg)
 {
+	int devid;
+
 	if (msg->id >= MBOX_MSG_MAX) {
 		dev_err(pf->dev,
 			"Mbox msg with unknown ID 0x%x\n", msg->id);
@@ -730,6 +732,26 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 		return;
 	}
 
+	/* message response heading VF */
+	devid = msg->pcifunc & RVU_PFVF_FUNC_MASK;
+	if (devid) {
+		struct otx2_vf_config *config = &pf->vf_configs[devid - 1];
+		struct delayed_work *dwork;
+
+		switch (msg->id) {
+		case MBOX_MSG_NIX_LF_START_RX:
+			config->intf_down = false;
+			dwork = &config->link_event_work;
+			schedule_delayed_work(dwork, msecs_to_jiffies(100));
+			break;
+		case MBOX_MSG_NIX_LF_STOP_RX:
+			config->intf_down = true;
+			break;
+		}
+
+		return;
+	}
+
 	switch (msg->id) {
 	case MBOX_MSG_READY:
 		pf->pcifunc = msg->pcifunc;
@@ -811,9 +833,22 @@ int otx2_mbox_up_handler_cgx_link_event(struct otx2_nic *pf,
 					struct cgx_link_info_msg *msg,
 					struct msg_rsp *rsp)
 {
+	int i;
+
 	/* Copy the link info sent by AF */
 	pf->linfo = msg->link_info;
 
+	/* notify VFs about link event */
+	for (i = 0; i < pci_num_vf(pf->pdev); i++) {
+		struct otx2_vf_config *config = &pf->vf_configs[i];
+		struct delayed_work *dwork = &config->link_event_work;
+
+		if (config->intf_down)
+			continue;
+
+		schedule_delayed_work(dwork, msecs_to_jiffies(100));
+	}
+
 	/* interface has not been fully configured yet */
 	if (pf->flags & OTX2_FLAG_INTF_DOWN)
 		return 0;
@@ -1928,11 +1963,39 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return err;
 }
 
+static void otx2_vf_link_event_task(struct work_struct *work)
+{
+	struct otx2_vf_config *config;
+	struct cgx_link_info_msg *req;
+	struct mbox_msghdr *msghdr;
+	struct otx2_nic *pf;
+	int vf_idx;
+
+	config = container_of(work, struct otx2_vf_config,
+			      link_event_work.work);
+	vf_idx = config - config->pf->vf_configs;
+	pf = config->pf;
+
+	msghdr = otx2_mbox_alloc_msg_rsp(&pf->mbox_pfvf[0].mbox_up, vf_idx,
+					 sizeof(*req), sizeof(struct msg_rsp));
+	if (!msghdr) {
+		dev_err(pf->dev, "Failed to create VF%d link event\n", vf_idx);
+		return;
+	}
+
+	req = (struct cgx_link_info_msg *)msghdr;
+	req->hdr.id = MBOX_MSG_CGX_LINK_EVENT;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	memcpy(&req->link_info, &pf->linfo, sizeof(req->link_info));
+
+	otx2_sync_mbox_up_msg(&pf->mbox_pfvf[0], vf_idx);
+}
+
 static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct otx2_nic *pf = netdev_priv(netdev);
-	int ret;
+	int ret, i;
 
 	/* Init PF <=> VF mailbox stuff */
 	ret = otx2_pfvf_mbox_init(pf, numvfs);
@@ -1943,9 +2006,23 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		goto free_mbox;
 
+	pf->vf_configs = kcalloc(numvfs, sizeof(struct otx2_vf_config),
+				 GFP_KERNEL);
+	if (!pf->vf_configs) {
+		ret = -ENOMEM;
+		goto free_intr;
+	}
+
+	for (i = 0; i < numvfs; i++) {
+		pf->vf_configs[i].pf = pf;
+		pf->vf_configs[i].intf_down = true;
+		INIT_DELAYED_WORK(&pf->vf_configs[i].link_event_work,
+				  otx2_vf_link_event_task);
+	}
+
 	ret = otx2_pf_flr_init(pf, numvfs);
 	if (ret)
-		goto free_intr;
+		goto free_configs;
 
 	ret = otx2_register_flr_me_intr(pf, numvfs);
 	if (ret)
@@ -1960,6 +2037,8 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	otx2_disable_flr_me_intr(pf);
 free_flr:
 	otx2_flr_wq_destroy(pf);
+free_configs:
+	kfree(pf->vf_configs);
 free_intr:
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 free_mbox:
@@ -1972,12 +2051,17 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct otx2_nic *pf = netdev_priv(netdev);
 	int numvfs = pci_num_vf(pdev);
+	int i;
 
 	if (!numvfs)
 		return 0;
 
 	pci_disable_sriov(pdev);
 
+	for (i = 0; i < pci_num_vf(pdev); i++)
+		cancel_delayed_work_sync(&pf->vf_configs[i].link_event_work);
+	kfree(pf->vf_configs);
+
 	otx2_disable_flr_me_intr(pf);
 	otx2_flr_wq_destroy(pf);
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
-- 
2.7.4

