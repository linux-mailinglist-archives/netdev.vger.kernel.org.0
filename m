Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BA13A143
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgANHDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:03:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35749 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgANHDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:03:18 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so5956013pgk.2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sRtd3mAV6+hSeP2/sMndDTxGuHpS1jLsdHMYAl9cgwQ=;
        b=bi0cfi5Uow9HYzIvMawAJ51VQaJicpzMX3Jcm+Sq8OWb17Tj7EtmdQEEQmz8sEyWvX
         N9cVvmTVI4XWS7ydauzH1Ne4+O68h7lzyX15Z+4Gs0eGcikxig6KqHexj6CaNv7S5kBr
         wTArIALX6etK4qcRUcQ7WZTbW5Isu3u/DcFwYB6jiO3+zW2HnuqsavISUnFNrPGKMBnE
         JGtiQq/wUYn60QvsjqjEeuLi/YLRIjPZSBdO1uKrSGU6Hz3EBON+lUV9r0DjBZCff8qr
         Hy5y3Hl027Kq6ef4vB3BZM8Crb04Km6Mc5IBpJji1ouY8AjVOmOkCOA88CjS+j1THvr2
         yIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sRtd3mAV6+hSeP2/sMndDTxGuHpS1jLsdHMYAl9cgwQ=;
        b=p4bvH9Tz72JQ4zLTJxlqaLFb+t2zAa45NdotAkI+sGEWHmIhssJxTrLGi9IHO06oIH
         Vl85iD/gsBv8QixncegfwcEDi0YKlxqTe0U0BSiI6e9fgWajlMAonrqQYcPMjtUY1PaA
         yhDl6ifvvYsg/JreEQhZJs1VlDUcvIS7IxI6dYHdroZdBwo5wHCZzQxGX5MgMxh/wUZD
         b/yo75P4DSPLPzOYeyWPE+j0VDsXRGgWbuY5Q7F9tOuObEDv9gIOlV6Ci6CB2QbfKKRa
         sjy6TkqX3ucriy+Wqy7CO73waV4VIfE9UpB5F4yj5zmMREFJGHjGcD42BQoFwYIe+LnM
         v8dA==
X-Gm-Message-State: APjAAAVGfwMRLJh00YyT0CcMPBeb3sKAkbN4jplAM+44T+UZhubJ1vIi
        fCb8c6u+f8c29DnyYv9o7xiGzxg/Zqk=
X-Google-Smtp-Source: APXvYqwPIZ6QKgpZUksz95NKrZnhszU/4wpcPxMT5e747CSJV777HAxkn1RBg1s9OPdk9TdoLZrCkg==
X-Received: by 2002:a63:eb15:: with SMTP id t21mr26101207pgh.365.1578985397717;
        Mon, 13 Jan 2020 23:03:17 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.03.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:03:17 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 11/17] octeontx2-pf: Receive side scaling support
Date:   Tue, 14 Jan 2020 12:32:14 +0530
Message-Id: <1578985340-28775-12-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Adds receive side scaling (RSS) support to distribute
pkts/flows across multiple queues. Sets up key, indirection
table etc. Also added extraction of HW calculated rxhash and
adding to same to SKB ie NETIF_F_RXHASH offload support.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 115 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  14 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  24 +++++
 4 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 738d366..8585d30 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -106,6 +106,119 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 	return err;
 }
 
+static int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct nix_rss_flowkey_cfg *req;
+	int err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_nix_rss_flowkey_cfg(&pfvf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+	req->mcam_index = -1; /* Default or reserved index */
+	req->flowkey_cfg = rss->flowkey_cfg;
+	req->group = DEFAULT_RSS_CONTEXT_GROUP;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+	return err;
+}
+
+static int otx2_set_rss_table(struct otx2_nic *pfvf)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct mbox *mbox = &pfvf->mbox;
+	struct nix_aq_enq_req *aq;
+	int idx, err;
+
+	otx2_mbox_lock(mbox);
+	/* Get memory to put this msg */
+	for (idx = 0; idx < rss->rss_size; idx++) {
+		aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
+		if (!aq) {
+			/* The shared memory buffer can be full.
+			 * Flush it and retry
+			 */
+			err = otx2_sync_mbox_msg(mbox);
+			if (err) {
+				otx2_mbox_unlock(mbox);
+				return err;
+			}
+			aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
+			if (!aq) {
+				otx2_mbox_unlock(mbox);
+				return -ENOMEM;
+			}
+		}
+
+		aq->rss.rq = rss->ind_tbl[idx];
+
+		/* Fill AQ info */
+		aq->qidx = idx;
+		aq->ctype = NIX_AQ_CTYPE_RSS;
+		aq->op = NIX_AQ_INSTOP_INIT;
+	}
+	err = otx2_sync_mbox_msg(mbox);
+	otx2_mbox_unlock(mbox);
+	return err;
+}
+
+static void otx2_set_rss_key(struct otx2_nic *pfvf)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	u64 *key = (u64 *)&rss->key[4];
+	int idx;
+
+	/* 352bit or 44byte key needs to be configured as below
+	 * NIX_LF_RX_SECRETX0 = key<351:288>
+	 * NIX_LF_RX_SECRETX1 = key<287:224>
+	 * NIX_LF_RX_SECRETX2 = key<223:160>
+	 * NIX_LF_RX_SECRETX3 = key<159:96>
+	 * NIX_LF_RX_SECRETX4 = key<95:32>
+	 * NIX_LF_RX_SECRETX5<63:32> = key<31:0>
+	 */
+	otx2_write64(pfvf, NIX_LF_RX_SECRETX(5),
+		     (u64)(*((u32 *)&rss->key)) << 32);
+	idx = sizeof(rss->key) / sizeof(u64);
+	while (idx > 0) {
+		idx--;
+		otx2_write64(pfvf, NIX_LF_RX_SECRETX(idx), *key++);
+	}
+}
+
+int otx2_rss_init(struct otx2_nic *pfvf)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	int idx, ret = 0;
+
+	/* Enable RSS */
+	rss->enable = true;
+	rss->rss_size = sizeof(rss->ind_tbl);
+
+	/* Init RSS key here */
+	netdev_rss_key_fill(rss->key, sizeof(rss->key));
+	otx2_set_rss_key(pfvf);
+
+	/* Default indirection table */
+	for (idx = 0; idx < rss->rss_size; idx++)
+		rss->ind_tbl[idx] =
+			ethtool_rxfh_indir_default(idx, pfvf->hw.rx_queues);
+
+	ret = otx2_set_rss_table(pfvf);
+	if (ret)
+		return ret;
+
+	/* Default flowkey or hash config to be used for generating flow tag */
+	rss->flowkey_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
+			   NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
+			   NIX_FLOW_KEY_TYPE_SCTP;
+
+	return otx2_set_flowkey_cfg(pfvf);
+}
+
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 {
 	/* Configure CQE interrupt coalescing parameters
@@ -611,6 +724,8 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->rq_cnt = pfvf->hw.rx_queues;
 	nixlf->sq_cnt = pfvf->hw.tx_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
+	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
+	nixlf->rss_grps = 1; /* Single RSS indir table supported, for now */
 	nixlf->xqe_sz = NIX_XQESZ_W16;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a843dc3..c032210 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -41,6 +41,16 @@ enum arua_mapped_qtypes {
 #define NIX_LF_ERR_VEC				0x81
 #define NIX_LF_POISON_VEC			0x82
 
+/* RSS configuration */
+struct otx2_rss_info {
+	u8 enable;
+	u32 flowkey_cfg;
+	u16 rss_size;
+	u8  ind_tbl[MAX_RSS_INDIR_TBL_SIZE];
+#define RSS_HASH_KEY_SIZE	44   /* 352 bit key */
+	u8  key[RSS_HASH_KEY_SIZE];
+};
+
 /* NIX (or NPC) RX errors */
 enum otx2_errlvl {
 	NPC_ERRLVL_RE,
@@ -95,6 +105,7 @@ struct  mbox {
 
 struct otx2_hw {
 	struct pci_dev		*pdev;
+	struct otx2_rss_info	rss_info;
 	u16                     rx_queues;
 	u16                     tx_queues;
 	u16			max_queues;
@@ -510,6 +521,9 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
+/* RSS configuration APIs*/
+int otx2_rss_init(struct otx2_nic *pfvf);
+
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
 			      struct msix_offset_rsp *rsp);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 557f86b..fe5b3de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -838,6 +838,11 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_disable_napi;
 
+	/* Initialize RSS */
+	err = otx2_rss_init(pf);
+	if (err)
+		goto err_disable_napi;
+
 	/* Register Queue IRQ handlers */
 	vec = pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START;
 	irq_name = &pf->hw.irq_name[vec * NAME_SIZE];
@@ -1249,7 +1254,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
 	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			       NETIF_F_IPV6_CSUM | NETIF_F_SG);
+			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
+			       NETIF_F_SG);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index cf2bbb7..f2de352 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -119,6 +119,28 @@ static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 			    pfvf->rbsize, DMA_FROM_DEVICE);
 }
 
+static void otx2_set_rxhash(struct otx2_nic *pfvf,
+			    struct nix_cqe_rx_s *cqe, struct sk_buff *skb)
+{
+	enum pkt_hash_types hash_type = PKT_HASH_TYPE_NONE;
+	struct otx2_rss_info *rss;
+	u32 hash = 0;
+
+	if (!(pfvf->netdev->features & NETIF_F_RXHASH))
+		return;
+
+	rss = &pfvf->hw.rss_info;
+	if (rss->flowkey_cfg) {
+		if (rss->flowkey_cfg &
+		    ~(NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6))
+			hash_type = PKT_HASH_TYPE_L4;
+		else
+			hash_type = PKT_HASH_TYPE_L3;
+		hash = cqe->hdr.flow_tag;
+	}
+	skb_set_hash(skb, hash, hash_type);
+}
+
 static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 				  struct nix_cqe_rx_s *cqe, int qidx)
 {
@@ -199,6 +221,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 			  cqe->sg.seg_size, parse);
 	cq->pool_ptrs++;
 
+	otx2_set_rxhash(pfvf, cqe, skb);
+
 	skb_record_rx_queue(skb, cq->cq_idx);
 	if (pfvf->netdev->features & NETIF_F_RXCSUM)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.7.4

