Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F9314A47D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgA0NGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:20 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35867 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:20 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so3745256plm.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fu20tkm/XvlrDfpxzT9cVU+8pU2wHNmuXy21bYlFB7A=;
        b=g+wiXijHEFt4Q5n+FI6g7T8XHcUHf2UqmlGmT5j309B/ir2VjHOyUNPy9fRTSbHZQF
         2I3rJAndqBrWjno6Cb2WFQOZI2r+MERv+tHEXRCIEQISyzdtXwg1M2715hp02WOHoLV0
         LRaYw0yUeoaAshp0dqdpgrT3qowRp+OQyvbTXK970sZt4MeYvDbfvL8zAJonZGpg86CS
         fBE0SeOgvlRUyeOXeAnVR6yo7PyO/v4EEDNT8WBAzmrFRcXu7jq+jcOvfs+UrdIkNc77
         wXXev/q4DFS1vPqo69ZKX8w6JJ3u49ax3gtWidS0xL3dS03c7DNxEGeLv5oB6o6YkqBv
         mqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fu20tkm/XvlrDfpxzT9cVU+8pU2wHNmuXy21bYlFB7A=;
        b=KDjawuUNeNujQyyjVs/2b6KDZLnWPlUjZ3WFeFp4jzkOdw9/RJJcsRYb8aFj7tfzqY
         hVR3/bXybr6JMzPN/07Dt4FKhPjh4QCYCUZU1hgNH+UnvPycnurX1bnAbWDrBEpbMOdL
         3Ivy6Rmb0i2BHKFw4Ljo3emYAn83bpaDQrvoOnqq4qp5AipzecUNtt+JIkNY7Gh+33I+
         sw0J5IxvzMvHiIaVes+bLK35XjSxQ5GMKGkezqFmTwI4BSVuxl9zvLmeikfm8YTQwcjr
         aBTztbWajt3/EsV1rSlbmXQQqrnNVqSa0N4keaUWTL5+wj46O7muMZ4NgqRWzpXFVPSF
         PXiA==
X-Gm-Message-State: APjAAAVeXOB3E/fUW0JdZYk7suUVq1Gp0cfuHUuJ0QyWhVHueGatkeq1
        yTDlTGw0oVdXAhPnM5J0mU7ZpZseaOI=
X-Google-Smtp-Source: APXvYqwt/d3BGmPoQihpez7ZcSsv9yU++GOHO69u8K0L8oRR65nNpohsRE1/w7m0LL5Fq+idSnrVnA==
X-Received: by 2002:a17:902:d90f:: with SMTP id c15mr17737317plz.248.1580130379386;
        Mon, 27 Jan 2020 05:06:19 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:18 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 11/17] octeontx2-pf: Receive side scaling support
Date:   Mon, 27 Jan 2020 18:35:25 +0530
Message-Id: <1580130331-8964-12-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 122 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  14 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  24 ++++
 4 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2b50306..9675158 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -106,6 +106,126 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
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
+	rss->rss_size = sizeof(rss->ind_tbl);
+
+	/* Init RSS key if it is not setup already */
+	if (!rss->enable)
+		netdev_rss_key_fill(rss->key, sizeof(rss->key));
+	otx2_set_rss_key(pfvf);
+
+	if (!netif_is_rxfh_configured(pfvf->netdev)) {
+		/* Default indirection table */
+		for (idx = 0; idx < rss->rss_size; idx++)
+			rss->ind_tbl[idx] =
+				ethtool_rxfh_indir_default(idx,
+							   pfvf->hw.rx_queues);
+	}
+	ret = otx2_set_rss_table(pfvf);
+	if (ret)
+		return ret;
+
+	/* Flowkey or hash config to be used for generating flow tag */
+	rss->flowkey_cfg = rss->enable ? rss->flowkey_cfg :
+			   NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
+			   NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
+			   NIX_FLOW_KEY_TYPE_SCTP;
+
+	ret = otx2_set_flowkey_cfg(pfvf);
+	if (ret)
+		return ret;
+
+	rss->enable = true;
+	return 0;
+}
+
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 {
 	/* Configure CQE interrupt coalescing parameters
@@ -608,6 +728,8 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->rq_cnt = pfvf->hw.rx_queues;
 	nixlf->sq_cnt = pfvf->hw.tx_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
+	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
+	nixlf->rss_grps = 1; /* Single RSS indir table supported, for now */
 	nixlf->xqe_sz = NIX_XQESZ_W16;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 2a81211..f9149ef 100644
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
@@ -95,6 +105,7 @@ struct mbox {
 
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
index 171bab0..5f78215 100644
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
@@ -1237,7 +1242,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
 	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			       NETIF_F_IPV6_CSUM | NETIF_F_SG);
+			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
+			       NETIF_F_SG);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 94dac84..513b126 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -115,6 +115,28 @@ static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
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
@@ -194,6 +216,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size);
 	cq->pool_ptrs++;
 
+	otx2_set_rxhash(pfvf, cqe, skb);
+
 	skb_record_rx_queue(skb, cq->cq_idx);
 	if (pfvf->netdev->features & NETIF_F_RXCSUM)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.7.4

