Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E000018D806
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCTS56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:57:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36058 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTS56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:57:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id g2so2899203plo.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vc4EyuWYkxbTF5P/JV0NMsQrWbgIYD4NDwxWceIlw9E=;
        b=PoIhJs7J85c2lO6z9IglBYCx1VLrPbUVfyqlKtaTexEWCfrbgUyOxQ/Vk9g0Yx1D9N
         7ZMU4CY4nsskg3TCdo+k/w40XYQwQSVTuZcaNmU5vsN3Qxh0xwaouCaEerFiCWuVi29H
         IuQGEPvHje4UFSJUty3mAlhe9LlXN4mD/fgfmxPruuA4OHL23roSoZA7H6OkSD6u2H4B
         9fFJzTeEwLaUlP2GiQwuoyNRmym0Kruq5eiEYIfMRKU2tuZhnYbT6gT0I8J6wARiqTUp
         N66LTYsyfw0FkasHUYKxoS3SU8QJRH7xK+uE8Q0ZAUeXV8mOik4mvcIrnKayS+xjbF4e
         X5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vc4EyuWYkxbTF5P/JV0NMsQrWbgIYD4NDwxWceIlw9E=;
        b=QlEV2Kr/hYh+ktW5/TFnvFzm3GFbqDFUbm1CP+8YpmZNNcI1G7QoVLUBzvfcc1/f+l
         9r1qU78ci6HOE/x6YPg24+1nxlIcqSxNvIFZx0wOlR3lKWtzGxIObpL02EaFO/WOLfSv
         ST9OrMLOHfJJ+kSJbAhe3ZuO6OBfyRdN5PE4xjvsqLjn1SiCMK/jQ8vo5fnOsnOmH009
         C3A2q6QVyi0XrBILdro1PnmtHrL2ug3RwXox+T9PMu8X6//RaiHm+0gynQdcx/JE1/zI
         6vjD7t6PNIw6vyW58wYCrkXqtmtpRMe5NvC4qVjM1BPgOZyG8yjfVjBba9nn1h1tp04j
         MuUg==
X-Gm-Message-State: ANhLgQ2F/ge83xICQwgB9xl6ek1w5lftugERnPJD3u2qrS5CccMKPLBz
        sbDHZluBodtm7SMI8KQeEcrqW3ARtvM=
X-Google-Smtp-Source: ADFU+vskHc23QmI7kW7cQFTjb7NKkOYBIQ5ct/C+O6f+2axdeiIWLgHv5LlQ+0E+Ilu6uvXEN+SX3w==
X-Received: by 2002:a17:90a:c001:: with SMTP id p1mr11315350pjt.86.1584730674662;
        Fri, 20 Mar 2020 11:57:54 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.57.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:57:53 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 5/8] octeontx2-vf: Link event notification support
Date:   Sat, 21 Mar 2020 00:27:23 +0530
Message-Id: <1584730646-15953-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 701bdfa..f51a29c 100644
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
index bc421f1..d491819 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -715,6 +715,8 @@ static int otx2_register_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
 static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 				       struct mbox_msghdr *msg)
 {
+	int devid;
+
 	if (msg->id >= MBOX_MSG_MAX) {
 		dev_err(pf->dev,
 			"Mbox msg with unknown ID 0x%x\n", msg->id);
@@ -728,6 +730,26 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
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
@@ -809,9 +831,22 @@ int otx2_mbox_up_handler_cgx_link_event(struct otx2_nic *pf,
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
@@ -1925,11 +1960,39 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1940,9 +2003,23 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
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
@@ -1957,6 +2034,8 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	otx2_disable_flr_me_intr(pf);
 free_flr:
 	otx2_flr_wq_destroy(pf);
+free_configs:
+	kfree(pf->vf_configs);
 free_intr:
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 free_mbox:
@@ -1969,12 +2048,17 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
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

