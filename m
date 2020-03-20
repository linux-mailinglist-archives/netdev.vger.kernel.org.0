Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C20118D803
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCTS5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:57:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40549 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTS5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:57:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id t24so3533535pgj.7
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Z2eZqW9PXtOz96yfMyObol/2pRuvB05mkkRtVWKshE=;
        b=MN+bnt1KRXyn86re+SN6j1BQRbuokFvphED5fJlsoiGOMWu7L8LYo2pZq4QY/6srHD
         VLNm5oYEKsBU8gYAz2ipuIJj+f7JYiaT6a9diw7tzwlm7eWDIFm0XY1sSoo1Xhqnq5wI
         6ZrW8EUJXB6HTbMd+6IVMEoFXZS+ur8Ro/FqlxvGhoiOltKxSQg9llaYSn3KrsI1uMQC
         dNv0Mr+6kDk1TZRhOxNd7VjWsTmS6zV/t/9BhNJr6CfyXZNupj2DtFWnQ9EPjcdQcufo
         fbVw9vdRUHt9E87jN5EnS0rxu/TYo2517Z3AzSDkbWV0BR+PTlMsbAoX4EeK8B+A6pIs
         VRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Z2eZqW9PXtOz96yfMyObol/2pRuvB05mkkRtVWKshE=;
        b=ahCFy/VTD4Unk6ro0mNugbzk+HPFDwffMb/6A3KkQEbGQz4TMpUdfW5sMSK+HFIeMC
         pjc666NBOoCbW29F5b3ssDfz150eimaxJPNTxot5F0OHE+oUetseWJfwhobuhZEZCEX3
         Sf7cueSjJC5jNVF3FGR3sTN2PtmXiVSYRz506NHZDsokQVHrViRj9Vs+HQJj2Yb01COB
         Gwj8oQ9RL3dvoFyOZsXnzd909E8RZvg3RfKqlOv5SsTDx7bEUoPpo4Nn2PCtfkTYFwZc
         NdO23AeRbhUuQrJPRYO+Lq3QvNvATd0S2ejH10TdmAsQO5eyuL9uIL8ZyboSu0seWpi+
         a77w==
X-Gm-Message-State: ANhLgQ0CLYqQ4FEn6NwdZCmRtWWXLh6yQFNpsyOaBwZunLP5rRXi/M5T
        T+VgOuHxejarXrkA0sPA/Hs9/00J3Cs=
X-Google-Smtp-Source: ADFU+vvvb7O83alE6Iz/560T0AZu4n/BfeDMnVNObpLklZT2xUZrdg5sj/u9JQFLVjaZZaNlejSRQA==
X-Received: by 2002:aa7:9511:: with SMTP id b17mr11493472pfp.243.1584730663651;
        Fri, 20 Mar 2020 11:57:43 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:57:42 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 2/8] octeontx2-pf: Handle VF function level reset
Date:   Sat, 21 Mar 2020 00:27:20 +0530
Message-Id: <1584730646-15953-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

When FLR is initiated for a VF (PCI function level reset),
the parent PF gets a interrupt. PF then sends a message to
admin function (AF), which then cleanups all resources attached
to that VF.

Also handled IRQs triggered when master enable bit is cleared
or set for VFs. This handler just clears the transaction pending
ie TRPEND bit.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 235 ++++++++++++++++++++-
 2 files changed, 239 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 74439e1..c0a9693 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -191,6 +191,11 @@ struct otx2_hw {
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
 };
 
+struct flr_work {
+	struct work_struct work;
+	struct otx2_nic *pf;
+};
+
 struct refill_work {
 	struct delayed_work pool_refill_work;
 	struct otx2_nic *pf;
@@ -226,6 +231,8 @@ struct otx2_nic {
 
 	u64			reset_count;
 	struct work_struct	reset_task;
+	struct workqueue_struct	*flr_wq;
+	struct flr_work		*flr_wrk;
 	struct refill_work	*refill_wrk;
 
 	/* Ethtool stuff */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 967ef7b..a3b15a6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -61,6 +61,223 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
+static void otx2_disable_flr_me_intr(struct otx2_nic *pf)
+{
+	int irq, vfs = pf->total_vfs;
+
+	/* Disable VFs ME interrupts */
+	otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(0), INTR_MASK(vfs));
+	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME0);
+	free_irq(irq, pf);
+
+	/* Disable VFs FLR interrupts */
+	otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(0), INTR_MASK(vfs));
+	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR0);
+	free_irq(irq, pf);
+
+	if (vfs <= 64)
+		return;
+
+	otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
+	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME1);
+	free_irq(irq, pf);
+
+	otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
+	irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR1);
+	free_irq(irq, pf);
+}
+
+static void otx2_flr_wq_destroy(struct otx2_nic *pf)
+{
+	if (!pf->flr_wq)
+		return;
+	destroy_workqueue(pf->flr_wq);
+	pf->flr_wq = NULL;
+	devm_kfree(pf->dev, pf->flr_wrk);
+}
+
+static void otx2_flr_handler(struct work_struct *work)
+{
+	struct flr_work *flrwork = container_of(work, struct flr_work, work);
+	struct otx2_nic *pf = flrwork->pf;
+	struct msg_req *req;
+	int vf, reg = 0;
+
+	vf = flrwork - pf->flr_wrk;
+
+	otx2_mbox_lock(&pf->mbox);
+	req = otx2_mbox_alloc_msg_vf_flr(&pf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pf->mbox);
+		return;
+	}
+	req->hdr.pcifunc &= RVU_PFVF_FUNC_MASK;
+	req->hdr.pcifunc |= (vf + 1) & RVU_PFVF_FUNC_MASK;
+
+	if (!otx2_sync_mbox_msg(&pf->mbox)) {
+		if (vf >= 64) {
+			reg = 1;
+			vf = vf - 64;
+		}
+		/* clear transcation pending bit */
+		otx2_write64(pf, RVU_PF_VFTRPENDX(reg), BIT_ULL(vf));
+		otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1SX(reg), BIT_ULL(vf));
+	}
+
+	otx2_mbox_unlock(&pf->mbox);
+}
+
+static irqreturn_t otx2_pf_flr_intr_handler(int irq, void *pf_irq)
+{
+	struct otx2_nic *pf = (struct otx2_nic *)pf_irq;
+	int reg, dev, vf, start_vf, num_reg = 1;
+	u64 intr;
+
+	if (pf->total_vfs > 64)
+		num_reg = 2;
+
+	for (reg = 0; reg < num_reg; reg++) {
+		intr = otx2_read64(pf, RVU_PF_VFFLR_INTX(reg));
+		if (!intr)
+			continue;
+		start_vf = 64 * reg;
+		for (vf = 0; vf < 64; vf++) {
+			if (!(intr & BIT_ULL(vf)))
+				continue;
+			dev = vf + start_vf;
+			queue_work(pf->flr_wq, &pf->flr_wrk[dev].work);
+			/* Clear interrupt */
+			otx2_write64(pf, RVU_PF_VFFLR_INTX(reg), BIT_ULL(vf));
+			/* Disable the interrupt */
+			otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(reg),
+				     BIT_ULL(vf));
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t otx2_pf_me_intr_handler(int irq, void *pf_irq)
+{
+	struct otx2_nic *pf = (struct otx2_nic *)pf_irq;
+	int vf, reg, num_reg = 1;
+	u64 intr;
+
+	if (pf->total_vfs > 64)
+		num_reg = 2;
+
+	for (reg = 0; reg < num_reg; reg++) {
+		intr = otx2_read64(pf, RVU_PF_VFME_INTX(reg));
+		if (!intr)
+			continue;
+		for (vf = 0; vf < 64; vf++) {
+			if (!(intr & BIT_ULL(vf)))
+				continue;
+			/* clear trpend bit */
+			otx2_write64(pf, RVU_PF_VFTRPENDX(reg), BIT_ULL(vf));
+			/* clear interrupt */
+			otx2_write64(pf, RVU_PF_VFME_INTX(reg), BIT_ULL(vf));
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+static int otx2_register_flr_me_intr(struct otx2_nic *pf, int numvfs)
+{
+	struct otx2_hw *hw = &pf->hw;
+	char *irq_name;
+	int ret;
+
+	/* Register ME interrupt handler*/
+	irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFME0 * NAME_SIZE];
+	snprintf(irq_name, NAME_SIZE, "RVUPF%d_ME0", rvu_get_pf(pf->pcifunc));
+	ret = request_irq(pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME0),
+			  otx2_pf_me_intr_handler, 0, irq_name, pf);
+	if (ret) {
+		dev_err(pf->dev,
+			"RVUPF: IRQ registration failed for ME0\n");
+	}
+
+	/* Register FLR interrupt handler */
+	irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFFLR0 * NAME_SIZE];
+	snprintf(irq_name, NAME_SIZE, "RVUPF%d_FLR0", rvu_get_pf(pf->pcifunc));
+	ret = request_irq(pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR0),
+			  otx2_pf_flr_intr_handler, 0, irq_name, pf);
+	if (ret) {
+		dev_err(pf->dev,
+			"RVUPF: IRQ registration failed for FLR0\n");
+		return ret;
+	}
+
+	if (numvfs > 64) {
+		irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFME1 * NAME_SIZE];
+		snprintf(irq_name, NAME_SIZE, "RVUPF%d_ME1",
+			 rvu_get_pf(pf->pcifunc));
+		ret = request_irq(pci_irq_vector
+				  (pf->pdev, RVU_PF_INT_VEC_VFME1),
+				  otx2_pf_me_intr_handler, 0, irq_name, pf);
+		if (ret) {
+			dev_err(pf->dev,
+				"RVUPF: IRQ registration failed for ME1\n");
+		}
+		irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFFLR1 * NAME_SIZE];
+		snprintf(irq_name, NAME_SIZE, "RVUPF%d_FLR1",
+			 rvu_get_pf(pf->pcifunc));
+		ret = request_irq(pci_irq_vector
+				  (pf->pdev, RVU_PF_INT_VEC_VFFLR1),
+				  otx2_pf_flr_intr_handler, 0, irq_name, pf);
+		if (ret) {
+			dev_err(pf->dev,
+				"RVUPF: IRQ registration failed for FLR1\n");
+			return ret;
+		}
+	}
+
+	/* Enable ME interrupt for all VFs*/
+	otx2_write64(pf, RVU_PF_VFME_INTX(0), INTR_MASK(numvfs));
+	otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1SX(0), INTR_MASK(numvfs));
+
+	/* Enable FLR interrupt for all VFs*/
+	otx2_write64(pf, RVU_PF_VFFLR_INTX(0), INTR_MASK(numvfs));
+	otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1SX(0), INTR_MASK(numvfs));
+
+	if (numvfs > 64) {
+		numvfs -= 64;
+
+		otx2_write64(pf, RVU_PF_VFME_INTX(1), INTR_MASK(numvfs));
+		otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1SX(1),
+			     INTR_MASK(numvfs));
+
+		otx2_write64(pf, RVU_PF_VFFLR_INTX(1), INTR_MASK(numvfs));
+		otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1SX(1),
+			     INTR_MASK(numvfs));
+	}
+	return 0;
+}
+
+static int otx2_pf_flr_init(struct otx2_nic *pf, int num_vfs)
+{
+	int vf;
+
+	pf->flr_wq = alloc_workqueue("otx2_pf_flr_wq",
+				     WQ_UNBOUND | WQ_HIGHPRI, 1);
+	if (!pf->flr_wq)
+		return -ENOMEM;
+
+	pf->flr_wrk = devm_kcalloc(pf->dev, num_vfs,
+				   sizeof(struct flr_work), GFP_KERNEL);
+	if (!pf->flr_wrk) {
+		destroy_workqueue(pf->flr_wq);
+		return -ENOMEM;
+	}
+
+	for (vf = 0; vf < num_vfs; vf++) {
+		pf->flr_wrk[vf].pf = pf;
+		INIT_WORK(&pf->flr_wrk[vf].work, otx2_flr_handler);
+	}
+
+	return 0;
+}
+
 static void otx2_queue_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
 			    int first, int mdevs, u64 intr, int type)
 {
@@ -406,7 +623,6 @@ static void otx2_pfvf_mbox_destroy(struct otx2_nic *pf)
 		return;
 
 	if (pf->mbox_pfvf_wq) {
-		flush_workqueue(pf->mbox_pfvf_wq);
 		destroy_workqueue(pf->mbox_pfvf_wq);
 		pf->mbox_pfvf_wq = NULL;
 	}
@@ -749,7 +965,6 @@ static void otx2_pfaf_mbox_destroy(struct otx2_nic *pf)
 	struct mbox *mbox = &pf->mbox;
 
 	if (pf->mbox_wq) {
-		flush_workqueue(pf->mbox_wq);
 		destroy_workqueue(pf->mbox_wq);
 		pf->mbox_wq = NULL;
 	}
@@ -1716,11 +1931,23 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		goto free_mbox;
 
-	ret = pci_enable_sriov(pdev, numvfs);
+	ret = otx2_pf_flr_init(pf, numvfs);
 	if (ret)
 		goto free_intr;
 
+	ret = otx2_register_flr_me_intr(pf, numvfs);
+	if (ret)
+		goto free_flr;
+
+	ret = pci_enable_sriov(pdev, numvfs);
+	if (ret)
+		goto free_flr_intr;
+
 	return numvfs;
+free_flr_intr:
+	otx2_disable_flr_me_intr(pf);
+free_flr:
+	otx2_flr_wq_destroy(pf);
 free_intr:
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 free_mbox:
@@ -1739,6 +1966,8 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
 
 	pci_disable_sriov(pdev);
 
+	otx2_disable_flr_me_intr(pf);
+	otx2_flr_wq_destroy(pf);
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 	otx2_pfvf_mbox_destroy(pf);
 
-- 
2.7.4

