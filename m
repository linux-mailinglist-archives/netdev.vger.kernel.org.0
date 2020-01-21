Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5015F143DEC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgAUNWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46929 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id n9so1483473pff.13
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1cFKLNzbo+d0q5YaB7czxjFE8oM5g90WxSyoMMG8xho=;
        b=tW47mOJjj8oMYQn8PbsXv2clig9kDiueJjKy+yPUrEoGP/YTQDGw5368mu1c1pREr4
         jDYJr0WQ6mTMsNxAGAlS/nAmWBSW+tBmQNi+jEvaC/Xs8/6oSZJS/LzRjMq/wjY2Tbcm
         Lz9+4k39H9EmOTVn2fXi8xHq9jzbtPczijab9LtBAcPr2Acaz1qxkUT+IZvc/VllOK+L
         Xa2DzoZ/8jHzVIW7LOqfl5AIYI+9XD61HGQ5yQNlhGwOX0g/j11HXFsktbrvNzaA8t9O
         Jh+W1vX4XvSe98RzjIjripNKxkBMh+Niwd4k5m8leTfVG6wYrln2yDb0b9fcVhBssSjA
         aYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1cFKLNzbo+d0q5YaB7czxjFE8oM5g90WxSyoMMG8xho=;
        b=WcHitWhjS2U4H2uowbh0BtsGScg1xLRg+ssx9LSz/EzXi7kDSAtlx5kId6e2zbz+Pa
         u9OggYPW4XSUDejIdjlDOl1mjkxMvnBnUSNgZtYiWHuAkKVdkhY4fxJFgNzhu/lu4Xy6
         2ysu0vIjUI2N/TJwHmu2Fc0XSBmdBfo5aAjHb8nlMRFgoGbQTw/DEVWn6UlPUtO7GAAB
         XwHDwCrtgKsu4vSIlzfdRlpBpyYd3AU9LzJVu4VWff5T6pm07P4vORUnU8yAGzCcEK1K
         zHtmLiWy9rIU+n1MLUBZb1+VdT3JhHzY3vmJTPYgb0vEtAjmyLX9xjK56n+1muTvHY1P
         O4fA==
X-Gm-Message-State: APjAAAV1Bsaw3QQvGv9fVsXDTQwKM2LasugolISVYAwFz9HdK2iELiwZ
        Rx/5v4HJMDZK3QC79vXYtOOHVe64els=
X-Google-Smtp-Source: APXvYqwDfCiT+bU4jgMICg4rydbLicu+WnpxMPxSo3egMuH/HCyCilZrkKSeExhHXQUhCS65Z3rDbg==
X-Received: by 2002:a62:7fcd:: with SMTP id a196mr4418372pfd.208.1579612950568;
        Tue, 21 Jan 2020 05:22:30 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.22.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:22:30 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 11/17] octeontx2-pf: Receive side scaling support
Date:   Tue, 21 Jan 2020 18:51:45 +0530
Message-Id: <1579612911-24497-12-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 738d366..7da9acd 100644
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
@@ -611,6 +731,8 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->rq_cnt = pfvf->hw.rx_queues;
 	nixlf->sq_cnt = pfvf->hw.tx_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
+	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
+	nixlf->rss_grps = 1; /* Single RSS indir table supported, for now */
 	nixlf->xqe_sz = NIX_XQESZ_W16;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4415920..2fd7fcc 100644
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

