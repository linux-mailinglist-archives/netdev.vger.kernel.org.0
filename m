Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EC817545B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCBHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45721 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCBHUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so3834326pls.12
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CKNrkDp7iR8h9inR3+aDpmEppR/ZgUPbIIJYolEmrOs=;
        b=AX14KWhMPZG20ACfW6HGNQ70UEPjmOLleZtCrzx8YCIQL+3FQL/JTkGzIWoQzgpXPF
         e/uRMutNXSlUlYbGSmwsQIL6Usx9nLfbZ6ZL9paNC8rss+0esnhQYg9coHOVYGjCqWO5
         EGZYjbdpNP7MvD55BWBsJw1SXqS2UcmHO5N8tiuiCBTkZjwdnngUYksqyrPHCdr8so5R
         8L9QXylRz34JaFHOZ7z/Hu2idWsOpBXnhjtQaOFCZPFl2dqrhCGUXh2NGsIuCA9CYf2a
         oh5bRflxy+S6BovR/5xOYJYcY+chqCCtC5eh+Z2XolM0wtWz9HW08/i5nImzLvTO44pH
         mQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CKNrkDp7iR8h9inR3+aDpmEppR/ZgUPbIIJYolEmrOs=;
        b=jWC+JsI2fAIcwHLuhCzjcwRE8DcfqSG/t54V38urC96UgOq/P2oMbBXpwdUmNI4o55
         +nbEkRdbB89BEKfHroMsAgl62hg3WZGAm8EnOshWddM2oboQ0dykz1AytUt4jcX1n2+j
         emeoEBZOHebB/uQXKgMW1qtvE+291DhqYdP3AHLXL/NEptu+QVqLliE9EQlgKZC9I3ve
         h1gcB3hPJlmwqHQJLZnW2CPrDBicB7bdr/+6IY6I71dRWixyy4rZk05iFDiVWgm1FY2v
         2dilP+t2MwN5USWjpGwKDBe5Ea2yTxqiVp0JufYZTi5KtZGS9tBPt/XC/3XNK4ic6KJK
         uLSg==
X-Gm-Message-State: APjAAAXY1s7JnoK57FBv/J5nZvW4tOpf2n0Ir1IKHzNmY355TA3LERtC
        69OnMzNARLRoCMEumocRHW5qsbRuARk=
X-Google-Smtp-Source: APXvYqyCAfZN2PtJqlngzyCuD+PFS3XKjFmmkiSwJ4pwHivvNcYWhI4gwyxd1yIqyyIWDwclMIeLzQ==
X-Received: by 2002:a17:902:bf4b:: with SMTP id u11mr16493256pls.324.1583133610502;
        Sun, 01 Mar 2020 23:20:10 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:09 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 3/7] octeontx2-pf: Support to enable/disable pause frames via ethtool
Date:   Mon,  2 Mar 2020 12:49:24 +0530
Message-Id: <1583133568-5674-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Added mailbox requests to retrieve backpressure IDs from AF and Aura,
CQ contexts are configured with these BPIDs. So that when resource
levels reach configured thresholds they assert backpressure on the
interface which is also mapped to same BPID.

Also added support to enable/disable pause frames generation via ethtool.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 65 ++++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  7 +++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 41 ++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 12 ++++
 4 files changed, 125 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index b945bd3..af4437d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -220,6 +220,25 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 	return err;
 }
 
+int otx2_config_pause_frm(struct otx2_nic *pfvf)
+{
+	struct cgx_pause_frm_cfg *req;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->rx_pause = !!(pfvf->flags & OTX2_FLAG_RX_PAUSE_ENABLED);
+	req->tx_pause = !!(pfvf->flags & OTX2_FLAG_TX_PAUSE_ENABLED);
+	req->set = 1;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+	return err;
+}
+
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
@@ -580,6 +599,7 @@ void otx2_sqb_flush(struct otx2_nic *pfvf)
  * RED accepts pkts if free pointers > 102 & <= 205.
  * Drops pkts if free pointers < 102.
  */
+#define RQ_BP_LVL_AURA   (255 - ((85 * 256) / 100)) /* BP when 85% is full */
 #define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
 #define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
 
@@ -741,6 +761,13 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	if (qidx < pfvf->hw.rx_queues) {
 		aq->cq.drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, cq->cqe_cnt);
 		aq->cq.drop_ena = 1;
+
+		/* Enable receive CQ backpressure */
+		aq->cq.bp_ena = 1;
+		aq->cq.bpid = pfvf->bpid[0];
+
+		/* Set backpressure level is same as cq pass level */
+		aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
 	}
 
 	/* Fill AQ info */
@@ -996,6 +1023,14 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	aq->aura.fc_addr = pool->fc_addr->iova;
 	aq->aura.fc_hyst_bits = 0; /* Store count on all updates */
 
+	/* Enable backpressure for RQ aura */
+	if (aura_id < pfvf->hw.rqpool_cnt) {
+		aq->aura.bp_ena = 0;
+		aq->aura.nix0_bpid = pfvf->bpid[0];
+		/* Set backpressure level for RQ's Aura */
+		aq->aura.bp = RQ_BP_LVL_AURA;
+	}
+
 	/* Fill AQ info */
 	aq->ctype = NPA_AQ_CTYPE_AURA;
 	aq->op = NPA_AQ_INSTOP_INIT;
@@ -1307,6 +1342,25 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 	otx2_mbox_unlock(mbox);
 }
 
+int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
+{
+	struct nix_bp_cfg_req *req;
+
+	if (enable)
+		req = otx2_mbox_alloc_msg_nix_bp_enable(&pfvf->mbox);
+	else
+		req = otx2_mbox_alloc_msg_nix_bp_disable(&pfvf->mbox);
+
+	if (!req)
+		return -ENOMEM;
+
+	req->chan_base = 0;
+	req->chan_cnt = 1;
+	req->bpid_per_chan = 0;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
 /* Mbox message handlers */
 void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 			    struct cgx_stats_rsp *rsp)
@@ -1355,6 +1409,17 @@ void mbox_handler_msix_offset(struct otx2_nic *pfvf,
 	pfvf->hw.nix_msixoff = rsp->nix_msixoff;
 }
 
+void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
+				struct nix_bp_cfg_rsp *rsp)
+{
+	int chan, chan_id;
+
+	for (chan = 0; chan < rsp->chan_cnt; chan++) {
+		chan_id = ((rsp->chan_bpid[chan] >> 10) & 0x7F);
+		pfvf->bpid[chan_id] = rsp->chan_bpid[chan] & 0x3FF;
+	}
+}
+
 void otx2_free_cints(struct otx2_nic *pfvf, int n)
 {
 	struct otx2_qset *qset = &pfvf->qset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 320f3b7..885c3dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -204,6 +204,8 @@ struct otx2_nic {
 	u16			rbsize; /* Receive buffer size */
 
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
+#define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
+#define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
 
 	struct otx2_qset	qset;
@@ -216,6 +218,7 @@ struct otx2_nic {
 	struct workqueue_struct *mbox_wq;
 
 	u16			pcifunc; /* RVU PF_FUNC */
+	u16			bpid[NIX_MAX_BPID_CHAN];
 	struct cgx_link_user_info linfo;
 
 	u64			reset_count;
@@ -558,6 +561,7 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu);
 void otx2_tx_timeout(struct net_device *netdev, unsigned int txq);
 void otx2_get_mac_from_af(struct net_device *netdev);
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
+int otx2_config_pause_frm(struct otx2_nic *pfvf);
 
 /* RVU block related APIs */
 int otx2_attach_npa_nix(struct otx2_nic *pfvf);
@@ -578,6 +582,7 @@ dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			   gfp_t gfp);
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
+int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
@@ -598,6 +603,8 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
 void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 			    struct cgx_stats_rsp *rsp);
+void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
+				struct nix_bp_cfg_rsp *rsp);
 
 /* Device stats APIs */
 void otx2_get_dev_stats(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 60fcf82..f450111 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -253,6 +253,45 @@ static int otx2_set_channels(struct net_device *dev,
 	return err;
 }
 
+static void otx2_get_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_pause_frm_cfg *req, *rsp;
+
+	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
+	if (!req)
+		return;
+
+	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
+		rsp = (struct cgx_pause_frm_cfg *)
+		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		pause->rx_pause = rsp->rx_pause;
+		pause->tx_pause = rsp->tx_pause;
+	}
+}
+
+static int otx2_set_pauseparam(struct net_device *netdev,
+			       struct ethtool_pauseparam *pause)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	if (pause->autoneg)
+		return -EOPNOTSUPP;
+
+	if (pause->rx_pause)
+		pfvf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
+	else
+		pfvf->flags &= ~OTX2_FLAG_RX_PAUSE_ENABLED;
+
+	if (pause->tx_pause)
+		pfvf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
+	else
+		pfvf->flags &= ~OTX2_FLAG_TX_PAUSE_ENABLED;
+
+	return otx2_config_pause_frm(pfvf);
+}
+
 static void otx2_get_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
@@ -654,6 +693,8 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.set_rxfh		= otx2_set_rxfh,
 	.get_msglevel		= otx2_get_msglevel,
 	.set_msglevel		= otx2_set_msglevel,
+	.get_pauseparam		= otx2_get_pauseparam,
+	.set_pauseparam		= otx2_set_pauseparam,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 85f9b9b..22f9a32 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -148,6 +148,9 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 		mbox_handler_nix_txsch_alloc(pf,
 					     (struct nix_txsch_alloc_rsp *)msg);
 		break;
+	case MBOX_MSG_NIX_BP_ENABLE:
+		mbox_handler_nix_bp_enable(pf, (struct nix_bp_cfg_rsp *)msg);
+		break;
 	case MBOX_MSG_CGX_STATS:
 		mbox_handler_cgx_stats(pf, (struct cgx_stats_rsp *)msg);
 		break;
@@ -654,6 +657,9 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	if (err)
 		goto err_free_npa_lf;
 
+	/* Enable backpressure */
+	otx2_nix_config_bp(pf, true);
+
 	/* Init Auras and pools used by NIX RQ, for free buffer ptrs */
 	err = otx2_rq_aura_pool_init(pf);
 	if (err) {
@@ -737,6 +743,12 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (err)
 		dev_err(pf->dev, "RVUPF: Failed to stop/free TX schedulers\n");
 
+	otx2_mbox_lock(mbox);
+	/* Disable backpressure */
+	if (!(pf->pcifunc & RVU_PFVF_FUNC_MASK))
+		otx2_nix_config_bp(pf, false);
+	otx2_mbox_unlock(mbox);
+
 	/* Disable RQs */
 	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
 
-- 
2.7.4

