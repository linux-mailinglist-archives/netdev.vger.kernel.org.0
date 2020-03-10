Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2418074B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCJSro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:47:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38123 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbgCJSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:47:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so5799466plz.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+tenvmPQwO4NQKigmubHHBkdsR4fnA7ZEXJsJ1biyz4=;
        b=QJQtu38ZnB2S6oT/qJFUejK93aXeB6w13hUHP1Os0W+oXikQ+YQM0aSBk8b7h/gR1l
         HJXpHo614nVbxQRt+RN5VZ6RYXQcnuKsqqsKhShZ/uYgWYkrugNWNp+mbxGxzovloZVY
         lTT8JMJrtYZdj5vuP1l+rgvG+iIjsb2daPHBfeiPdz0GoIuV4agJw0nRmYotef5lkPud
         ifbvjvxPvAcGtqhfkDXRiFJghK9fndZQf5IAwy/DkZtNEAo5FQ29lcbPpAG+z4xG66Bf
         G1Og3qsHqql+MCa9ZmVS8AU1DYbOPwF+TDwomosE77aDXZkZENfO/pPitgZS5rAzTj/w
         NBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+tenvmPQwO4NQKigmubHHBkdsR4fnA7ZEXJsJ1biyz4=;
        b=G+h9BAnwrCk6d7TWypzc2/zekXwae/GU70TsSev99+s81U7BpWQQh6v2fWJxhZPmig
         GFCqnp+oZ18lqvzwn3nphOOTs0dFB3fUycTc2S+/ywE/bMuxq/0/PXi1RXO1yHyn+E7d
         VsmXV0b20Hct/V1qfoyr6JruOhnhMK2+FGw5/BgRS/cXY2z1+Qlc7+AIokvd+PcUXDg5
         nP8cJ3iM0ARf3y6C0VIbGRYgD2s4LZD9WWp7NbX35QM1QvsvEbsESNsF28ImvqhwH4TG
         KXxF48/kbEBU7sfbprsqzI8pHp69cVGik9mPcZYrp/fuEf6xfWDzwcdePmnfnLrg3xJ1
         Rk0Q==
X-Gm-Message-State: ANhLgQ0WJR+eUxax1an0omsRwyBOB73aYi5mdU2z0S6OH+ZJc1Gv4cnG
        q7bzQBdWbrQEZHFuWN4kLra746e9KBg=
X-Google-Smtp-Source: ADFU+vuBKJkGlpED3uxbck0U+3ZtmR+S7CrH2AXrH9ja2UdwQMihFrskkwvUXWATybBWYgn5066CJQ==
X-Received: by 2002:a17:902:7c0d:: with SMTP id x13mr21642511pll.93.1583866061191;
        Tue, 10 Mar 2020 11:47:41 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm4240490pfc.120.2020.03.10.11.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 11:47:40 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 2/6] octeontx2-pf: Handle VF function level reset
Date:   Wed, 11 Mar 2020 00:17:21 +0530
Message-Id: <1583866045-7129-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 233 ++++++++++++++++++++-
 2 files changed, 239 insertions(+), 1 deletion(-)

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
index fba8f38..cb3c834 100644
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
+	flush_workqueue(pf->flr_wq);
+	destroy_workqueue(pf->flr_wq);
+	pf->flr_wq = NULL;
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
+	pf->flr_wq = alloc_workqueue("otx2_pf_flr_wq", WQ_UNBOUND | WQ_HIGHPRI
+				     | WQ_MEM_RECLAIM, 1);
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
@@ -1719,11 +1936,23 @@ static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
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
@@ -1742,6 +1971,8 @@ static int otx2_sriov_disable(struct pci_dev *pdev)
 
 	pci_disable_sriov(pdev);
 
+	otx2_disable_flr_me_intr(pf);
+	otx2_flr_wq_destroy(pf);
 	otx2_disable_pfvf_mbox_intr(pf, numvfs);
 	otx2_pfvf_mbox_destroy(pf);
 
-- 
2.7.4

