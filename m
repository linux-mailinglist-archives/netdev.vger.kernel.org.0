Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC42918B43D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgCSNHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:07:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36076 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgCSNHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:07:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id g2so1047644plo.3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8HQv72Jk+Z7XmcQffbFmB7+WXLE/tPu6kTTYuyox2gg=;
        b=AEpWW3q3lT+vaePuYJkUboFRYtxRpKY3u0+0C+hTAQ2GSxSp7sH/vc+8OQj0h4WkM9
         WXPyT2IR7Y5hzIerQ1ES4JuKZcKfoHJ/zNqxul1uV+YKBrMToY9YjvQYRalSfmxMeBeh
         E5pwf7MFJVy8bBwl9vplbvbu50tOdK9YkW7tlMTDaCGglgdSEXOZNDHSAT5uMoZMz0oS
         Zta3wOEOqX/D5cLnVeQTUQiYSALE5LS3KPwL94Ajib8rKq8vY6PsThUXPahA2bo5MrJT
         gutUZXHR/tumjzjLJH3HHPrkdNx+CkOA9qCl2ayUwo86KMtm017H2GYzO+Ql97uCv0Fw
         1kLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8HQv72Jk+Z7XmcQffbFmB7+WXLE/tPu6kTTYuyox2gg=;
        b=YbqWf0Sc9DEbMuhzmlzTemqkM9ZUx5oB4kC2ftRVTdiTnreGsCnpR/zjpnft608JmL
         5t4lRpziVYcbyrBUG5r0FlYkCT1dsPcNZg256RIa2OlSGKiG67cXrvjaA/yka7PzLZhj
         +GLGYYj6Bq58HD7B2hXK07mVTzRu4W3KHi8yZrLR/l9lzKpQMjjTjKVeP9jt+XBGNkB2
         zz3sGfAvcUFg2KVKhSNomZCt0v6w4/Dc6q0sYg8gakDeZBQGAzJJYD/URJhGqYa1/gkI
         /W0wa+StRNh3xP4uUTGTiWEZkW/E0H16Ge40J4XRYgn/CsVHrR2VNGOnvgqaZTthcCLK
         of3w==
X-Gm-Message-State: ANhLgQ0M6auKlQda6fYE9+Cwmy1QJ9pXpMZ98Bv3gA/dpRii63gBpGoN
        W0PgjL1k7RMrCtg7eaPsw76czzIym7g=
X-Google-Smtp-Source: ADFU+vs9bJjpo033m3gvPmKgBRB9hW5skuPRPGBUtXIRZ8KixbEdwjW2csOSHWld3dpcmNmFhTCl7g==
X-Received: by 2002:a17:902:6acc:: with SMTP id i12mr3174928plt.87.1584623267754;
        Thu, 19 Mar 2020 06:07:47 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm2336292pgk.66.2020.03.19.06.07.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Mar 2020 06:07:46 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: [PATCH v3 net-next 1/8] octeontx2-pf: Enable SRIOV and added VF mbox handling
Date:   Thu, 19 Mar 2020 18:37:21 +0530
Message-Id: <1584623248-27508-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added 'sriov_configure' to enable/disable virtual functions (VFs).
Also added handling of mailbox messages from these VFs.

Admin function (AF) is the only one with all priviliges to configure
HW, alloc resources etc etc, PFs and it's VFs have to request AF
via mbox for all their needs. But unlike PFs, their VFs cannot
send a mbox request directly. A VF shares a mailbox region with
it's parent PF, so VF sends a mailbox msg to PF and then PF forwards
it to AF. Then AF after processing sends response to PF which it
again forwards to VF.

This patch adds support for this 'VF <=> PF <=> AF' mailbox
communication.

Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 443 +++++++++++++++++++++
 2 files changed, 446 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 885c3dc..74439e1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -215,8 +215,11 @@ struct otx2_nic {
 
 	/* Mbox */
 	struct mbox		mbox;
+	struct mbox		*mbox_pfvf;
 	struct workqueue_struct *mbox_wq;
+	struct workqueue_struct *mbox_pfvf_wq;
 
+	u8			total_vfs;
 	u16			pcifunc; /* RVU PF_FUNC */
 	u16			bpid[NIX_MAX_BPID_CHAN];
 	struct cgx_link_user_info linfo;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 22f9a32..967ef7b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -115,6 +115,387 @@ static void otx2_queue_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
 	}
 }
 
+static void otx2_forward_msg_pfvf(struct otx2_mbox_dev *mdev,
+				  struct otx2_mbox *pfvf_mbox, void *bbuf_base,
+				  int devid)
+{
+	struct otx2_mbox_dev *src_mdev = mdev;
+	int offset;
+
+	/* Msgs are already copied, trigger VF's mbox irq */
+	smp_wmb();
+
+	offset = pfvf_mbox->trigger | (devid << pfvf_mbox->tr_shift);
+	writeq(1, (void __iomem *)pfvf_mbox->reg_base + offset);
+
+	/* Restore VF's mbox bounce buffer region address */
+	src_mdev->mbase = bbuf_base;
+}
+
+static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
+				     struct otx2_mbox *src_mbox,
+				     int dir, int vf, int num_msgs)
+{
+	struct otx2_mbox_dev *src_mdev, *dst_mdev;
+	struct mbox_hdr *mbox_hdr;
+	struct mbox_hdr *req_hdr;
+	struct mbox *dst_mbox;
+	int dst_size, err;
+
+	if (dir == MBOX_DIR_PFAF) {
+		/* Set VF's mailbox memory as PF's bounce buffer memory, so
+		 * that explicit copying of VF's msgs to PF=>AF mbox region
+		 * and AF=>PF responses to VF's mbox region can be avoided.
+		 */
+		src_mdev = &src_mbox->dev[vf];
+		mbox_hdr = src_mbox->hwbase +
+				src_mbox->rx_start + (vf * MBOX_SIZE);
+
+		dst_mbox = &pf->mbox;
+		dst_size = dst_mbox->mbox.tx_size -
+				ALIGN(sizeof(*mbox_hdr), MBOX_MSG_ALIGN);
+		/* Check if msgs fit into destination area */
+		if (mbox_hdr->msg_size > dst_size)
+			return -EINVAL;
+
+		dst_mdev = &dst_mbox->mbox.dev[0];
+
+		otx2_mbox_lock(&pf->mbox);
+		dst_mdev->mbase = src_mdev->mbase;
+		dst_mdev->msg_size = mbox_hdr->msg_size;
+		dst_mdev->num_msgs = num_msgs;
+		err = otx2_sync_mbox_msg(dst_mbox);
+		if (err) {
+			dev_warn(pf->dev,
+				 "AF not responding to VF%d messages\n", vf);
+			/* restore PF mbase and exit */
+			dst_mdev->mbase = pf->mbox.bbuf_base;
+			otx2_mbox_unlock(&pf->mbox);
+			return err;
+		}
+		/* At this point, all the VF messages sent to AF are acked
+		 * with proper responses and responses are copied to VF
+		 * mailbox hence raise interrupt to VF.
+		 */
+		req_hdr = (struct mbox_hdr *)(dst_mdev->mbase +
+					      dst_mbox->mbox.rx_start);
+		req_hdr->num_msgs = num_msgs;
+
+		otx2_forward_msg_pfvf(dst_mdev, &pf->mbox_pfvf[0].mbox,
+				      pf->mbox.bbuf_base, vf);
+		otx2_mbox_unlock(&pf->mbox);
+	} else if (dir == MBOX_DIR_PFVF_UP) {
+		src_mdev = &src_mbox->dev[0];
+		mbox_hdr = src_mbox->hwbase + src_mbox->rx_start;
+		req_hdr = (struct mbox_hdr *)(src_mdev->mbase +
+					      src_mbox->rx_start);
+		req_hdr->num_msgs = num_msgs;
+
+		dst_mbox = &pf->mbox_pfvf[0];
+		dst_size = dst_mbox->mbox_up.tx_size -
+				ALIGN(sizeof(*mbox_hdr), MBOX_MSG_ALIGN);
+		/* Check if msgs fit into destination area */
+		if (mbox_hdr->msg_size > dst_size)
+			return -EINVAL;
+
+		dst_mdev = &dst_mbox->mbox_up.dev[vf];
+		dst_mdev->mbase = src_mdev->mbase;
+		dst_mdev->msg_size = mbox_hdr->msg_size;
+		dst_mdev->num_msgs = mbox_hdr->num_msgs;
+		err = otx2_sync_mbox_up_msg(dst_mbox, vf);
+		if (err) {
+			dev_warn(pf->dev,
+				 "VF%d is not responding to mailbox\n", vf);
+			return err;
+		}
+	} else if (dir == MBOX_DIR_VFPF_UP) {
+		req_hdr = (struct mbox_hdr *)(src_mbox->dev[0].mbase +
+					      src_mbox->rx_start);
+		req_hdr->num_msgs = num_msgs;
+		otx2_forward_msg_pfvf(&pf->mbox_pfvf->mbox_up.dev[vf],
+				      &pf->mbox.mbox_up,
+				      pf->mbox_pfvf[vf].bbuf_base,
+				      0);
+	}
+
+	return 0;
+}
+
+static void otx2_pfvf_mbox_handler(struct work_struct *work)
+{
+	struct mbox_msghdr *msg = NULL;
+	int offset, vf_idx, id, err;
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *req_hdr;
+	struct otx2_mbox *mbox;
+	struct mbox *vf_mbox;
+	struct otx2_nic *pf;
+
+	vf_mbox = container_of(work, struct mbox, mbox_wrk);
+	pf = vf_mbox->pfvf;
+	vf_idx = vf_mbox - pf->mbox_pfvf;
+
+	mbox = &pf->mbox_pfvf[0].mbox;
+	mdev = &mbox->dev[vf_idx];
+	req_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+
+	offset = ALIGN(sizeof(*req_hdr), MBOX_MSG_ALIGN);
+
+	for (id = 0; id < vf_mbox->num_msgs; id++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + mbox->rx_start +
+					     offset);
+
+		if (msg->sig != OTX2_MBOX_REQ_SIG)
+			goto inval_msg;
+
+		/* Set VF's number in each of the msg */
+		msg->pcifunc &= RVU_PFVF_FUNC_MASK;
+		msg->pcifunc |= (vf_idx + 1) & RVU_PFVF_FUNC_MASK;
+		offset = msg->next_msgoff;
+	}
+	err = otx2_forward_vf_mbox_msgs(pf, mbox, MBOX_DIR_PFAF, vf_idx,
+					vf_mbox->num_msgs);
+	if (err)
+		goto inval_msg;
+	return;
+
+inval_msg:
+	otx2_reply_invalid_msg(mbox, vf_idx, 0, msg->id);
+	otx2_mbox_msg_send(mbox, vf_idx);
+}
+
+static void otx2_pfvf_mbox_up_handler(struct work_struct *work)
+{
+	struct mbox *vf_mbox = container_of(work, struct mbox, mbox_up_wrk);
+	struct otx2_nic *pf = vf_mbox->pfvf;
+	struct otx2_mbox_dev *mdev;
+	int offset, id, vf_idx = 0;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+
+	vf_idx = vf_mbox - pf->mbox_pfvf;
+	mbox = &pf->mbox_pfvf[0].mbox_up;
+	mdev = &mbox->dev[vf_idx];
+
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+
+	for (id = 0; id < vf_mbox->up_num_msgs; id++) {
+		msg = mdev->mbase + offset;
+
+		if (msg->id >= MBOX_MSG_MAX) {
+			dev_err(pf->dev,
+				"Mbox msg with unknown ID 0x%x\n", msg->id);
+			goto end;
+		}
+
+		if (msg->sig != OTX2_MBOX_RSP_SIG) {
+			dev_err(pf->dev,
+				"Mbox msg with wrong signature %x, ID 0x%x\n",
+				msg->sig, msg->id);
+			goto end;
+		}
+
+		switch (msg->id) {
+		case MBOX_MSG_CGX_LINK_EVENT:
+			break;
+		default:
+			if (msg->rc)
+				dev_err(pf->dev,
+					"Mbox msg response has err %d, ID 0x%x\n",
+					msg->rc, msg->id);
+			break;
+		}
+
+end:
+		offset = mbox->rx_start + msg->next_msgoff;
+		mdev->msgs_acked++;
+	}
+
+	otx2_mbox_reset(mbox, vf_idx);
+}
+
+static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
+{
+	struct otx2_nic *pf = (struct otx2_nic *)(pf_irq);
+	int vfs = pf->total_vfs;
+	struct mbox *mbox;
+	u64 intr;
+
+	mbox = pf->mbox_pfvf;
+	/* Handle VF interrupts */
+	if (vfs > 64) {
+		intr = otx2_read64(pf, RVU_PF_VFPF_MBOX_INTX(1));
+		otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(1), intr);
+		otx2_queue_work(mbox, pf->mbox_pfvf_wq, 64, vfs, intr,
+				TYPE_PFVF);
+		vfs -= 64;
+	}
+
+	intr = otx2_read64(pf, RVU_PF_VFPF_MBOX_INTX(0));
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(0), intr);
+
+	otx2_queue_work(mbox, pf->mbox_pfvf_wq, 0, vfs, intr, TYPE_PFVF);
+
+	return IRQ_HANDLED;
+}
+
+static int otx2_pfvf_mbox_init(struct otx2_nic *pf, int numvfs)
+{
+	void __iomem *hwbase;
+	struct mbox *mbox;
+	int err, vf;
+	u64 base;
+
+	if (!numvfs)
+		return -EINVAL;
+
+	pf->mbox_pfvf = devm_kcalloc(&pf->pdev->dev, numvfs,
+				     sizeof(struct mbox), GFP_KERNEL);
+	if (!pf->mbox_pfvf)
+		return -ENOMEM;
+
+	pf->mbox_pfvf_wq = alloc_workqueue("otx2_pfvf_mailbox",
+					   WQ_UNBOUND | WQ_HIGHPRI |
+					   WQ_MEM_RECLAIM, 1);
+	if (!pf->mbox_pfvf_wq)
+		return -ENOMEM;
+
+	base = readq((void __iomem *)((u64)pf->reg_base + RVU_PF_VF_BAR4_ADDR));
+	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
+
+	if (!hwbase) {
+		err = -ENOMEM;
+		goto free_wq;
+	}
+
+	mbox = &pf->mbox_pfvf[0];
+	err = otx2_mbox_init(&mbox->mbox, hwbase, pf->pdev, pf->reg_base,
+			     MBOX_DIR_PFVF, numvfs);
+	if (err)
+		goto free_iomem;
+
+	err = otx2_mbox_init(&mbox->mbox_up, hwbase, pf->pdev, pf->reg_base,
+			     MBOX_DIR_PFVF_UP, numvfs);
+	if (err)
+		goto free_iomem;
+
+	for (vf = 0; vf < numvfs; vf++) {
+		mbox->pfvf = pf;
+		INIT_WORK(&mbox->mbox_wrk, otx2_pfvf_mbox_handler);
+		INIT_WORK(&mbox->mbox_up_wrk, otx2_pfvf_mbox_up_handler);
+		mbox++;
+	}
+
+	return 0;
+
+free_iomem:
+	if (hwbase)
+		iounmap(hwbase);
+free_wq:
+	destroy_workqueue(pf->mbox_pfvf_wq);
+	return err;
+}
+
+static void otx2_pfvf_mbox_destroy(struct otx2_nic *pf)
+{
+	struct mbox *mbox = &pf->mbox_pfvf[0];
+
+	if (!mbox)
+		return;
+
+	if (pf->mbox_pfvf_wq) {
+		flush_workqueue(pf->mbox_pfvf_wq);
+		destroy_workqueue(pf->mbox_pfvf_wq);
+		pf->mbox_pfvf_wq = NULL;
+	}
+
+	if (mbox->mbox.hwbase)
+		iounmap(mbox->mbox.hwbase);
+
+	otx2_mbox_destroy(&mbox->mbox);
+}
+
+static void otx2_enable_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
+{
+	/* Clear PF <=> VF mailbox IRQ */
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(0), ~0ull);
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(1), ~0ull);
+
+	/* Enable PF <=> VF mailbox IRQ */
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INT_ENA_W1SX(0), INTR_MASK(numvfs));
+	if (numvfs > 64) {
+		numvfs -= 64;
+		otx2_write64(pf, RVU_PF_VFPF_MBOX_INT_ENA_W1SX(1),
+			     INTR_MASK(numvfs));
+	}
+}
+
+static void otx2_disable_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
+{
+	int vector;
+
+	/* Disable PF <=> VF mailbox IRQ */
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INT_ENA_W1CX(0), ~0ull);
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INT_ENA_W1CX(1), ~0ull);
+
+	otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(0), ~0ull);
+	vector = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFPF_MBOX0);
+	free_irq(vector, pf);
+
+	if (numvfs > 64) {
+		otx2_write64(pf, RVU_PF_VFPF_MBOX_INTX(1), ~0ull);
+		vector = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
+		free_irq(vector, pf);
+	}
+}
+
+static int otx2_register_pfvf_mbox_intr(struct otx2_nic *pf, int numvfs)
+{
+	struct otx2_hw *hw = &pf->hw;
+	char *irq_name;
+	int err;
+
+	/* Register MBOX0 interrupt handler */
+	irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFPF_MBOX0 * NAME_SIZE];
+	if (pf->pcifunc)
+		snprintf(irq_name, NAME_SIZE,
+			 "RVUPF%d_VF Mbox0", rvu_get_pf(pf->pcifunc));
+	else
+		snprintf(irq_name, NAME_SIZE, "RVUPF_VF Mbox0");
+	err = request_irq(pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFPF_MBOX0),
+			  otx2_pfvf_mbox_intr_handler, 0, irq_name, pf);
+	if (err) {
+		dev_err(pf->dev,
+			"RVUPF: IRQ registration failed for PFVF mbox0 irq\n");
+		return err;
+	}
+
+	if (numvfs > 64) {
+		/* Register MBOX1 interrupt handler */
+		irq_name = &hw->irq_name[RVU_PF_INT_VEC_VFPF_MBOX1 * NAME_SIZE];
+		if (pf->pcifunc)
+			snprintf(irq_name, NAME_SIZE,
+				 "RVUPF%d_VF Mbox1", rvu_get_pf(pf->pcifunc));
+		else
+			snprintf(irq_name, NAME_SIZE, "RVUPF_VF Mbox1");
+		err = request_irq(pci_irq_vector(pf->pdev,
+						 RVU_PF_INT_VEC_VFPF_MBOX1),
+						 otx2_pfvf_mbox_intr_handler,
+						 0, irq_name, pf);
+		if (err) {
+			dev_err(pf->dev,
+				"RVUPF: IRQ registration failed for PFVF mbox1 irq\n");
+			return err;
+		}
+	}
+
+	otx2_enable_pfvf_mbox_intr(pf, numvfs);
+
+	return 0;
+}
+
 static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 				       struct mbox_msghdr *msg)
 {
@@ -286,6 +667,12 @@ static void otx2_pfaf_mbox_up_handler(struct work_struct *work)
 			otx2_process_mbox_msg_up(pf, msg);
 		offset = mbox->rx_start + msg->next_msgoff;
 	}
+	if (devid) {
+		otx2_forward_vf_mbox_msgs(pf, &pf->mbox.mbox_up,
+					  MBOX_DIR_PFVF_UP, devid - 1,
+					  af_mbox->up_num_msgs);
+		return;
+	}
 
 	otx2_mbox_msg_send(mbox, 0);
 }
@@ -1184,6 +1571,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pf->netdev = netdev;
 	pf->pdev = pdev;
 	pf->dev = dev;
+	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
 	pf->flags |= OTX2_FLAG_INTF_DOWN;
 
 	hw = &pf->hw;
@@ -1313,6 +1701,58 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return err;
 }
 
+static int otx2_sriov_enable(struct pci_dev *pdev, int numvfs)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct otx2_nic *pf = netdev_priv(netdev);
+	int ret;
+
+	/* Init PF <=> VF mailbox stuff */
+	ret = otx2_pfvf_mbox_init(pf, numvfs);
+	if (ret)
+		return ret;
+
+	ret = otx2_register_pfvf_mbox_intr(pf, numvfs);
+	if (ret)
+		goto free_mbox;
+
+	ret = pci_enable_sriov(pdev, numvfs);
+	if (ret)
+		goto free_intr;
+
+	return numvfs;
+free_intr:
+	otx2_disable_pfvf_mbox_intr(pf, numvfs);
+free_mbox:
+	otx2_pfvf_mbox_destroy(pf);
+	return ret;
+}
+
+static int otx2_sriov_disable(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct otx2_nic *pf = netdev_priv(netdev);
+	int numvfs = pci_num_vf(pdev);
+
+	if (!numvfs)
+		return 0;
+
+	pci_disable_sriov(pdev);
+
+	otx2_disable_pfvf_mbox_intr(pf, numvfs);
+	otx2_pfvf_mbox_destroy(pf);
+
+	return 0;
+}
+
+static int otx2_sriov_configure(struct pci_dev *pdev, int numvfs)
+{
+	if (numvfs == 0)
+		return otx2_sriov_disable(pdev);
+	else
+		return otx2_sriov_enable(pdev, numvfs);
+}
+
 static void otx2_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -1327,6 +1767,8 @@ static void otx2_remove(struct pci_dev *pdev)
 	otx2_cgx_config_linkevents(pf, false);
 
 	unregister_netdev(netdev);
+	otx2_sriov_disable(pf->pdev);
+
 	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
@@ -1343,6 +1785,7 @@ static struct pci_driver otx2_pf_driver = {
 	.probe = otx2_probe,
 	.shutdown = otx2_remove,
 	.remove = otx2_remove,
+	.sriov_configure = otx2_sriov_configure
 };
 
 static int __init otx2_rvupf_init_module(void)
-- 
2.7.4

