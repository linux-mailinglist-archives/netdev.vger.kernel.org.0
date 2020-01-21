Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5CE143DE8
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAUNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52661 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:23 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so1367590pjh.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H9vWZ6ZFy9W0TBAwLuystzKc1v1pRIlEUYEEf13ejdk=;
        b=QKI14cQAgc5j7DjthpVfVsN6sR54G/VW1SrbcM9OaA7H3ZMha9xb/LqCsJJ1XX2Rj7
         yQ5rYod5BBzmyOHF/UCw74xfoVW826VvJFpQSHc/2nkMFJM7g3fY1/4w1o4GsqGJ5e8T
         fzvlVqtlYwfLqIAPkJsg80N8CNcTysJe+uOWdhzAxXm+oLd0Oqf4SbSAs6m0PY4KjMXX
         gA9gau3RspMTD7M/6VTlm6GLU0daz2G5sZt+kqFYRD7cXc4ur/vBHPIVZHn0I7Y84NVj
         P+1qcdABWNZ3NP6pB5evDZmhGJV9/rvnGhV3YwnvemAjcLYveogicSI8tFdHFaeNAv4H
         f1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H9vWZ6ZFy9W0TBAwLuystzKc1v1pRIlEUYEEf13ejdk=;
        b=DgsTeFZ/xIWeYRPd9eNO+IL8B9GxsE+xxqRskFTYafEE9l4Cd38mIh7OqmpD9vYEba
         9TjP8RwWrmYOzNj+r61E1/3pWk2eCV7ygoomltpnl21FH/gLuHsMYuyP6PxXXkM/M7Qc
         hPnLXjMLV7QDGExUMVmR7uL1IWd8kAd1qDTspC3VHAYO0mGuWk5Oe2v+FyAgGftsRwbY
         49gb2mGQYLQeQrL+W+v/B2T4jZUUuQZTYxLpEMfWHsVh8/XhlsYTT8z/zrELhxAnXWH8
         4bppF89UVDXjN+3OZyyHbNP/USpJUx+5VKnLy2RaPLvT6bsrsmw+b6QpxPt0Y+hqrxyr
         6FcQ==
X-Gm-Message-State: APjAAAX2TtuFdTJ/z98iemezoetXBlBPLQEUeeGnIgouU6I3LtJ89MFI
        dvISm5n3iFGM/iEmtUTuX2As0TYKPok=
X-Google-Smtp-Source: APXvYqwe5MXcYxQuuA03eYOxdn136xN5uL7sZv5C7G9wv/S+dDgZ58ddbDxnS/2Bth3xOn2LnpaArw==
X-Received: by 2002:a17:90a:cc02:: with SMTP id b2mr5133987pju.137.1579612942015;
        Tue, 21 Jan 2020 05:22:22 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.22.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:22:21 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Linu Cherian <lcherian@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 08/17] octeontx2-pf: Register and handle link notifications
Date:   Tue, 21 Jan 2020 18:51:42 +0530
Message-Id: <1579612911-24497-9-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

PF and AF (admin function) shares 64KB of reserved memory region for
communication. This region is shared for
 - Messages sent by PF and responses sent by AF.
 - Notifications sent by AF and ACKs sent by PF.

This patch adds infrastructure to handle notifications sent
by AF and adds handlers to process them.

One of the main usecase of notifications from AF is physical
link changes. So this patch adds registration of PF with AF
to receive link status change notifications and also adds
the handler for that notification.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  5 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 79 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 25 +++++++
 3 files changed, 109 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 88a1a2d..888003e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -135,6 +135,9 @@ struct otx2_nic {
 	void			*iommu_domain;
 	u16			rbsize; /* Receive buffer size */
 
+#define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
+	u64			flags;
+
 	struct otx2_qset	qset;
 	struct otx2_hw		hw;
 	struct pci_dev		*pdev;
@@ -145,6 +148,7 @@ struct otx2_nic {
 	struct workqueue_struct *mbox_wq;
 
 	u16			pcifunc; /* RVU PF_FUNC */
+	struct cgx_link_user_info linfo;
 
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
@@ -485,6 +489,7 @@ int otx2_txschq_stop(struct otx2_nic *pfvf);
 void otx2_sqb_flush(struct otx2_nic *pfvf);
 dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			   gfp_t gfp);
+int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 11e3446..baa264e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -167,6 +167,38 @@ static void otx2_pfaf_mbox_handler(struct work_struct *work)
 	otx2_mbox_reset(mbox, 0);
 }
 
+static void otx2_handle_link_event(struct otx2_nic *pf)
+{
+	struct cgx_link_user_info *linfo = &pf->linfo;
+	struct net_device *netdev = pf->netdev;
+
+	pr_info("%s NIC Link is %s %d Mbps %s duplex\n", netdev->name,
+		linfo->link_up ? "UP" : "DOWN", linfo->speed,
+		linfo->full_duplex ? "Full" : "Half");
+	if (linfo->link_up) {
+		netif_carrier_on(netdev);
+		netif_tx_start_all_queues(netdev);
+	} else {
+		netif_tx_stop_all_queues(netdev);
+		netif_carrier_off(netdev);
+	}
+}
+
+int otx2_mbox_up_handler_cgx_link_event(struct otx2_nic *pf,
+					struct cgx_link_info_msg *msg,
+					struct msg_rsp *rsp)
+{
+	/* Copy the link info sent by AF */
+	pf->linfo = msg->link_info;
+
+	/* interface has not been fully configured yet */
+	if (pf->flags & OTX2_FLAG_INTF_DOWN)
+		return 0;
+
+	otx2_handle_link_event(pf);
+	return 0;
+}
+
 static int otx2_process_mbox_msg_up(struct otx2_nic *pf,
 				    struct mbox_msghdr *req)
 {
@@ -367,6 +399,27 @@ static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
 	return err;
 }
 
+static int otx2_cgx_config_linkevents(struct otx2_nic *pf, bool enable)
+{
+	struct msg_req *msg;
+	int err;
+
+	otx2_mbox_lock(&pf->mbox);
+	if (enable)
+		msg = otx2_mbox_alloc_msg_cgx_start_linkevents(&pf->mbox);
+	else
+		msg = otx2_mbox_alloc_msg_cgx_stop_linkevents(&pf->mbox);
+
+	if (!msg) {
+		otx2_mbox_unlock(&pf->mbox);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	otx2_mbox_unlock(&pf->mbox);
+	return err;
+}
+
 static int otx2_set_real_num_queues(struct net_device *netdev,
 				    int tx_queues, int rx_queues)
 {
@@ -690,6 +743,18 @@ static int otx2_open(struct net_device *netdev)
 
 	otx2_set_cints_affinity(pf);
 
+	pf->flags &= ~OTX2_FLAG_INTF_DOWN;
+	/* 'intf_down' may be checked on any cpu */
+	smp_wmb();
+
+	/* we have already received link status notification */
+	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
+		otx2_handle_link_event(pf);
+
+	err = otx2_rxtx_enable(pf, true);
+	if (err)
+		goto err_free_cints;
+
 	return 0;
 
 err_free_cints:
@@ -713,6 +778,13 @@ static int otx2_stop(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
+	pf->flags |= OTX2_FLAG_INTF_DOWN;
+	/* 'intf_down' may be checked on any cpu */
+	smp_wmb();
+
+	/* First stop packet Rx/Tx */
+	otx2_rxtx_enable(pf, false);
+
 	/* Cleanup CQ NAPI and IRQ */
 	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
 	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
@@ -879,6 +951,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pf->netdev = netdev;
 	pf->pdev = pdev;
 	pf->dev = dev;
+	pf->flags |= OTX2_FLAG_INTF_DOWN;
 
 	hw = &pf->hw;
 	hw->pdev = pdev;
@@ -971,6 +1044,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_detach_rsrc;
 	}
 
+	/* Enable link notifications */
+	otx2_cgx_config_linkevents(pf, true);
+
 	return 0;
 
 err_detach_rsrc:
@@ -999,6 +1075,9 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	pf = netdev_priv(netdev);
 
+	/* Disable link notifications */
+	otx2_cgx_config_linkevents(pf, false);
+
 	unregister_netdev(netdev);
 	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f416603..364fdbd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -324,6 +324,10 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 	otx2_write64(pfvf, NIX_LF_CINTX_INT(cq_poll->cint_idx), BIT_ULL(0));
 
 	if (workdone < budget && napi_complete_done(napi, workdone)) {
+		/* If interface is going down, don't re-enable IRQ */
+		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
+			return workdone;
+
 		/* Re-enable interrupts */
 		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
 			     BIT_ULL(0));
@@ -544,3 +548,24 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
 		     ((u64)cq->cq_idx << 32) | processed_cqe);
 }
+
+int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable)
+{
+	struct msg_req *msg;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	if (enable)
+		msg = otx2_mbox_alloc_msg_nix_lf_start_rx(&pfvf->mbox);
+	else
+		msg = otx2_mbox_alloc_msg_nix_lf_stop_rx(&pfvf->mbox);
+
+	if (!msg) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+	return err;
+}
-- 
2.7.4

