Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB7718074F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCJSrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:47:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34460 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgCJSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:47:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so6712372pgn.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=18p8x0IZpTSlUlxihtqYXzJzypL8qp2u7toMXERn78Q=;
        b=H99qoHgf1Sqp1RfvK9Ec2o1R/4bUmNMKCBe7bCAJMZBg5nsk34JVkif6S3oegMgr8i
         NdpCwonYXcdF9Hgz4Pi3UPyWzz9+zFjGOGzoZXOWX/Ix80qKsbwaMPcs+0svVWU+tJrN
         eFE2HeoNJgzetDwcHOUgMS2rCQnK7DMdRdqhkKJqg52hym2NCx2fQxDuokntN6G/9GiU
         LWZu0HfdIZQ1C4PePFus00zZGRHGOfwqaHRW/5wHJs2ANnkdjP8ApRnSVgMEsDDKjiNY
         CBwK3VEK7fTY2tOrVeHYlPonZOawfVPVf6TnQNCq0XlDvxxQR/h0O4OJ9NaNGhUqyRmO
         X6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=18p8x0IZpTSlUlxihtqYXzJzypL8qp2u7toMXERn78Q=;
        b=JQVUCgSBlCQ9sIrf42tXbv3qQvbMtB1kFE+iJT5HQ9MNHXp5JDi6W8KlC7UWr9gPbb
         kfjsPOXpfDyS3Rg+6CJnTjqJkWfDUzKgosD4ANwSUBVGqJctn6Jx113Brk4JvaHdGRcV
         x3axFBJ8H6QvOuNbUuqQaalp+4fuQRumCDPtGqTvELdcqzI6/2ZVd8raKsqts7R9X1Hz
         8Ksa0wx+wNdYW8DbrdFnIeL57Dvk6heIlmk96b6gXrp0abwuP4q7gm7ppoG0SnpZJRg5
         8HlRYqNoO+uqGsacT2sJ6EfqJGd8KCu6yMl4t0hv+jDzuvIpObAU+Mf3ltYj+Agck/Lg
         zsrA==
X-Gm-Message-State: ANhLgQ3NDUe7Bb3ejkPFZDwMYCjmbAAW4lnDQ/0GFT5iY3pCXRkomWTU
        HBv6mHMtGzQJ96JdR67MzuKAn17/d7k=
X-Google-Smtp-Source: ADFU+vtp6Pz4Ier0jZJ94G1mZ5ZwXabRoM8f+04NE5pBnnbNxvewk9+HSk2Wg2zRkysPEr3fKd/g+w==
X-Received: by 2002:a63:b515:: with SMTP id y21mr22348628pge.148.1583866069184;
        Tue, 10 Mar 2020 11:47:49 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm4240490pfc.120.2020.03.10.11.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 11:47:48 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 5/6] octeontx2-vf: Link event notification support
Date:   Wed, 11 Mar 2020 00:17:24 +0530
Message-Id: <1583866045-7129-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
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
index a70a50a..5d5929a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -716,6 +716,8 @@ static int otx2_register_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
 static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 				       struct mbox_msghdr *msg)
 {
+	int devid;
+
 	if (msg->id >= MBOX_MSG_MAX) {
 		dev_err(pf->dev,
 			"Mbox msg with unknown ID 0x%x\n", msg->id);
@@ -729,6 +731,26 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
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
@@ -810,9 +832,22 @@ int otx2_mbox_up_handler_cgx_link_event(struct otx2_nic *pf,
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
 
 	if (numvfs > pf->total_vfs)
 		numvfs = pf->total_vfs;
@@ -1946,9 +2009,23 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
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
@@ -1963,6 +2040,8 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	otx2_disable_flr_me_intr(pf);
 free_flr:
 	otx2_flr_wq_destroy(pf);
+free_configs:
+	kfree(pf->vf_configs);
 free_intr:
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 free_mbox:
@@ -1975,12 +2054,17 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
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

