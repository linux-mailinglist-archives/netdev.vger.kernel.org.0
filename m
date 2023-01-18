Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825B36719DC
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjARK6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjARK46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:56:58 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF613654D6;
        Wed, 18 Jan 2023 02:05:03 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8nRE3009074;
        Wed, 18 Jan 2023 02:04:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Eo1RMtwaFMIVdHLLmwjorB3djHpB1atj+BihX8si2SU=;
 b=VLTOoxvvYlyEiNVH3BXznwn4zHWAbgNZESAuj2+9ZD4DTLjzBfrxZ9Bhdnk9eah0Zr1E
 2ynJ6zQC5ENK6OSWKVISsWk0QhJ6bt2h3cAu2+U9YwjSa3SUSyqqQJLXaqVJ+fII8Hyb
 L+vZsbiiLT4kVyzunmcaxsiutRGVbivos+lDiZRgCZW7D78iWdOlrfxL7lQLrejQY8mp
 r2gkZDwoVcr5PuEcnNPJjTZQdojJoVaDplqnoOiTqDsRkNS/vxRP0CXmApbaM6aJN0PB
 Hrey2UxNqliFoc+MnQenrpqxVnaO8fUP4OjqtKhRzenhWhWh73XBYSAjTIHJbyFbycfV wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgau2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:04:50 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:04:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:04:48 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 793105B6938;
        Wed, 18 Jan 2023 02:04:42 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <maximmi@nvidia.com>, <tariqt@nvidia.com>, <moshet@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <maxtram95@gmail.com>
Subject: [net-next Patch v2 5/5] octeontx2-pf: Add support for HTB offload
Date:   Wed, 18 Jan 2023 15:34:10 +0530
Message-ID: <20230118100410.8834-6-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118100410.8834-1-hkelam@marvell.com>
References: <20230118100410.8834-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: n_3SiSut-X2cyDr0IBHYa_Ef6YuQY2p0
X-Proofpoint-GUID: n_3SiSut-X2cyDr0IBHYa_Ef6YuQY2p0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

This patch registers callbacks to support HTB offload.

Below are features supported,

- supports traffic shaping on the given class by honoring rate and ceil
configuration.

- supports traffic scheduling,  which prioritizes different types of
traffic based on strict priority values.

- supports the creation of leaf to inner classes such that parent node
rate limits apply to all child nodes.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   37 +-
 .../marvell/octeontx2/nic/otx2_common.h       |    7 +
 .../marvell/octeontx2/nic/otx2_devlink.c      |    6 +
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   47 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1547 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   56 +-
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
 11 files changed, 1749 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 3d31ddf7c652..5664f768cb0c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o otx2_ptp.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
                otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
-               otx2_devlink.o qos_sq.o
+               otx2_devlink.o qos_sq.o qos.o
 rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
 rvu_nicpf-$(CONFIG_DCB) += otx2_dcbnl.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 96132cfe2141..322b65c9e202 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -89,6 +89,11 @@ int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx)
 	if (!pfvf->qset.sq)
 		return 0;
 
+	if (qidx >= pfvf->hw.tot_tx_queues) {
+		if (!test_bit(qidx - pfvf->hw.tot_tx_queues, pfvf->qos.qos_sq_bmap))
+			return 0;
+	}
+
 	otx2_nix_sq_op_stats(&sq->stats, pfvf, qidx);
 	return 1;
 }
@@ -748,29 +753,49 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
 	return 0;
 }
 
-int otx2_txschq_stop(struct otx2_nic *pfvf)
+void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq)
 {
 	struct nix_txsch_free_req *free_req;
-	int lvl, schq, err;
+	int err;
 
 	mutex_lock(&pfvf->mbox.lock);
-	/* Free the transmit schedulers */
+
 	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
 	if (!free_req) {
 		mutex_unlock(&pfvf->mbox.lock);
-		return -ENOMEM;
+		netdev_err(pfvf->netdev,
+			   "Failed alloc txschq free req\n");
+		return;
 	}
 
-	free_req->flags = TXSCHQ_FREE_ALL;
+	free_req->schq_lvl = lvl;
+	free_req->schq = schq;
+
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err) {
+		netdev_err(pfvf->netdev,
+			   "Failed stop txschq %d at level %d\n", lvl, schq);
+	}
+
 	mutex_unlock(&pfvf->mbox.lock);
+}
+
+int otx2_txschq_stop(struct otx2_nic *pfvf)
+{
+	int lvl, schq;
+
+	/* free non QOS TLx nodes */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		otx2_txschq_free_one(pfvf, lvl,
+				     pfvf->hw.txschq_list[lvl][0]);
 
 	/* Clear the txschq list */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
 			pfvf->hw.txschq_list[lvl][schq] = 0;
 	}
-	return err;
+
+	return 0;
 }
 
 void otx2_sqb_flush(struct otx2_nic *pfvf)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 3e09f52f2dc6..c5e125e8d00b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -253,6 +253,7 @@ struct otx2_hw {
 #define CN10K_RPM		3
 #define CN10K_PTP_ONESTEP	4
 #define CN10K_HW_MACSEC		5
+#define QOS_CIR_PIR_SUPPORT	6
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
@@ -587,6 +588,7 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		__set_bit(CN10K_LMTST, &hw->cap_flag);
 		__set_bit(CN10K_RPM, &hw->cap_flag);
 		__set_bit(CN10K_PTP_ONESTEP, &hw->cap_flag);
+		__set_bit(QOS_CIR_PIR_SUPPORT, &hw->cap_flag);
 	}
 
 	if (is_dev_cn10kb(pfvf->pdev))
@@ -948,6 +950,7 @@ int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 		   int stack_pages, int numptrs, int buf_size);
 int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 		   int pool_id, int numptrs);
+void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq);
 
 /* RSS configuration APIs*/
 int otx2_rss_init(struct otx2_nic *pfvf);
@@ -1059,4 +1062,8 @@ static inline void cn10k_handle_mcs_event(struct otx2_nic *pfvf,
 void otx2_qos_sq_setup(struct otx2_nic *pfvf);
 u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 		      struct net_device *sb_dev);
+int otx2_get_txq_by_classid(struct otx2_nic *pfvf, u16 classid);
+void otx2_qos_config_txschq(struct otx2_nic *pfvf);
+int otx2_clean_qos_queues(struct otx2_nic *pfvf);
+bool otx2_is_qos_configured(struct otx2_nic *pfvf);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index b6bb6945f08a..8b26232f7a8b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -77,6 +77,12 @@ static int otx2_dl_tl1_rr_prio_validate(struct devlink *devlink, u32 id,
 		return -EOPNOTSUPP;
 	}
 
+	if (otx2_is_qos_configured(pf)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TL1RR PRIORITY setting not allowed after QOS config");
+		return -EOPNOTSUPP;
+	}
+
 	if (pci_num_vf(pf->pdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "TL1RR PRIORITY setting not allowed as VFs are already attached");
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0f8d1a69139f..0816fe19a2c3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -80,6 +80,11 @@ static void otx2_get_drvinfo(struct net_device *netdev,
 	strscpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
 }
 
+static int otx2_get_total_txq_count(struct otx2_nic *pfvf)
+{
+	return pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues;
+}
+
 static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
 {
 	int start_qidx = qset * pfvf->hw.rx_queues;
@@ -92,10 +97,15 @@ static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
 			*data += ETH_GSTRING_LEN;
 		}
 	}
-	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+	for (qidx = 0; qidx < otx2_get_total_txq_count(pfvf); qidx++) {
 		for (stats = 0; stats < otx2_n_queue_stats; stats++) {
-			sprintf(*data, "txq%d: %s", qidx + start_qidx,
-				otx2_queue_stats[stats].name);
+			if (qidx >= pfvf->hw.tot_tx_queues)
+				sprintf(*data, "txq_qos%d: %s",
+					qidx + start_qidx - pfvf->hw.tot_tx_queues,
+					otx2_queue_stats[stats].name);
+			else
+				sprintf(*data, "txq%d: %s", qidx + start_qidx,
+					otx2_queue_stats[stats].name);
 			*data += ETH_GSTRING_LEN;
 		}
 	}
@@ -159,7 +169,7 @@ static void otx2_get_qset_stats(struct otx2_nic *pfvf,
 				[otx2_queue_stats[stat].index];
 	}
 
-	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+	for (qidx = 0; qidx <  otx2_get_total_txq_count(pfvf); qidx++) {
 		if (!otx2_update_sq_stats(pfvf, qidx)) {
 			for (stat = 0; stat < otx2_n_queue_stats; stat++)
 				*((*data)++) = 0;
@@ -254,7 +264,8 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 		return -EINVAL;
 
 	qstats_count = otx2_n_queue_stats *
-		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
+		       (pfvf->hw.rx_queues + pfvf->hw.tot_tx_queues +
+			pfvf->hw.tc_tx_queues);
 	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag))
 		mac_stats = CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT;
 	otx2_update_lmac_fec_stats(pfvf);
@@ -282,7 +293,7 @@ static int otx2_set_channels(struct net_device *dev,
 {
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	bool if_up = netif_running(dev);
-	int err = 0;
+	int err = 0, qos_txqs;
 
 	if (!channel->rx_count || !channel->tx_count)
 		return -EINVAL;
@@ -296,7 +307,10 @@ static int otx2_set_channels(struct net_device *dev,
 	if (if_up)
 		dev->netdev_ops->ndo_stop(dev);
 
-	err = otx2_set_real_num_queues(dev, channel->tx_count,
+	qos_txqs = bitmap_weight(pfvf->qos.qos_sq_bmap,
+				 OTX2_QOS_MAX_LEAF_NODES);
+
+	err = otx2_set_real_num_queues(dev, channel->tx_count + qos_txqs,
 				       channel->rx_count);
 	if (err)
 		return err;
@@ -1405,7 +1419,8 @@ static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
 		return -EINVAL;
 
 	qstats_count = otx2_n_queue_stats *
-		       (vf->hw.rx_queues + vf->hw.tx_queues);
+		       (vf->hw.rx_queues + vf->hw.tx_queues +
+			vf->hw.tc_tx_queues);
 
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 92e41d2d5398..331b2b554d75 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1386,6 +1386,9 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	otx2_sq_free_sqbs(pf);
 	for (qidx = 0; qidx < pf->hw.tot_tx_queues + pf->hw.tc_tx_queues; qidx++) {
 		sq = &qset->sq[qidx];
+		/* Skip freeing Qos queues if they are not initialized */
+		if (!sq->sqe)
+			continue;
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
 		kfree(sq->sg);
@@ -1568,6 +1571,8 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 		otx2_pfc_txschq_stop(pf);
 #endif
 
+	otx2_clean_qos_queues(pf);
+
 	mutex_lock(&mbox->lock);
 	/* Disable backpressure */
 	if (!(pf->pcifunc & RVU_PFVF_FUNC_MASK))
@@ -1834,6 +1839,9 @@ int otx2_open(struct net_device *netdev)
 	/* 'intf_down' may be checked on any cpu */
 	smp_wmb();
 
+	/* Enable QoS configuration before starting tx queues */
+	otx2_qos_config_txschq(pf);
+
 	/* we have already received link status notification */
 	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
 		otx2_handle_link_event(pf);
@@ -1979,14 +1987,45 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+static int otx2_qos_select_htb_queue(struct otx2_nic *pf, struct sk_buff *skb,
+				     u16 htb_maj_id)
+{
+	u16 classid;
+
+	if ((TC_H_MAJ(skb->priority) >> 16) == htb_maj_id)
+		classid = TC_H_MIN(skb->priority);
+	else
+		classid = READ_ONCE(pf->qos.defcls);
+
+	if (!classid)
+		return 0;
+
+	return otx2_get_txq_by_classid(pf, classid);
+}
+
 u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 		      struct net_device *sb_dev)
 {
-#ifdef CONFIG_DCB
 	struct otx2_nic *pf = netdev_priv(netdev);
+	bool qos_enabled;
+#ifdef CONFIG_DCB
 	u8 vlan_prio;
 #endif
+	int txq;
+
+	qos_enabled = (netdev->real_num_tx_queues > pf->hw.tx_queues) ? true : false;
+	if (unlikely(qos_enabled)) {
+		u16 htb_maj_id = smp_load_acquire(&pf->qos.maj_id); /* barrier */
 
+		if (unlikely(htb_maj_id)) {
+			txq = otx2_qos_select_htb_queue(pf, skb, htb_maj_id);
+			if (txq > 0)
+				return txq;
+			goto process_pfc;
+		}
+	}
+
+process_pfc:
 #ifdef CONFIG_DCB
 	if (!skb_vlan_tag_present(skb))
 		goto pick_tx;
@@ -2000,7 +2039,11 @@ u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 
 pick_tx:
 #endif
-	return netdev_pick_tx(netdev, skb, NULL);
+	txq = netdev_pick_tx(netdev, skb, NULL);
+	if (unlikely(qos_enabled))
+		return txq % pf->hw.tx_queues;
+
+	return txq;
 }
 EXPORT_SYMBOL(otx2_select_queue);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1b967eaf948b..45a32e4b49d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -145,12 +145,25 @@
 #define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
 #define NIX_AF_TL2X_PARENT(a)		(0xE88 | (a) << 16)
 #define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (a) << 16)
+#define NIX_AF_TL2X_TOPOLOGY(a)		(0xE80 | (a) << 16)
+#define NIX_AF_TL2X_CIR(a)              (0xE20 | (a) << 16)
+#define NIX_AF_TL2X_PIR(a)              (0xE30 | (a) << 16)
 #define NIX_AF_TL3X_PARENT(a)		(0x1088 | (a) << 16)
 #define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
+#define NIX_AF_TL3X_SHAPE(a)		(0x1010 | (a) << 16)
+#define NIX_AF_TL3X_CIR(a)		(0x1020 | (a) << 16)
+#define NIX_AF_TL3X_PIR(a)		(0x1030 | (a) << 16)
+#define NIX_AF_TL3X_TOPOLOGY(a)		(0x1080 | (a) << 16)
 #define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
 #define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
+#define NIX_AF_TL4X_SHAPE(a)		(0x1210 | (a) << 16)
+#define NIX_AF_TL4X_CIR(a)		(0x1220 | (a) << 16)
 #define NIX_AF_TL4X_PIR(a)		(0x1230 | (a) << 16)
+#define NIX_AF_TL4X_TOPOLOGY(a)		(0x1280 | (a) << 16)
 #define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
+#define NIX_AF_MDQX_SHAPE(a)		(0x1410 | (a) << 16)
+#define NIX_AF_MDQX_CIR(a)		(0x1420 | (a) << 16)
+#define NIX_AF_MDQX_PIR(a)		(0x1430 | (a) << 16)
 #define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
 #define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3)
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 044cc211424e..42c49249f4e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -19,6 +19,7 @@
 
 #include "cn10k.h"
 #include "otx2_common.h"
+#include "qos.h"
 
 /* Egress rate limiting definitions */
 #define MAX_BURST_EXPONENT		0x0FULL
@@ -147,8 +148,8 @@ static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 	}
 }
 
-static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
-				       u64 maxrate, u32 burst)
+u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
+				u64 maxrate, u32 burst)
 {
 	u32 burst_exp, burst_mantissa;
 	u32 exp, mantissa, div_exp;
@@ -1127,6 +1128,8 @@ int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return otx2_setup_tc_block(netdev, type_data);
+	case TC_SETUP_QDISC_HTB:
+		return otx2_setup_tc_htb(netdev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
new file mode 100644
index 000000000000..dc829c210845
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -0,0 +1,1547 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
+ *
+ */
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/bitfield.h>
+
+#include "otx2_common.h"
+#include "cn10k.h"
+#include "qos.h"
+
+#define OTX2_QOS_QID_INNER		0xFFFFU
+#define OTX2_QOS_QID_NONE		0xFFFEU
+#define OTX2_QOS_ROOT_CLASSID		0xFFFFFFFF
+#define OTX2_QOS_CLASS_NONE		0
+#define OTX2_QOS_DEFAULT_PRIO		0xF
+#define OTX2_QOS_INVALID_SQ		0xFFFF
+
+/* Egress rate limiting definitions */
+#define MAX_BURST_EXPONENT		0x0FULL
+#define MAX_BURST_MANTISSA		0xFFULL
+#define MAX_BURST_SIZE			130816ULL
+#define MAX_RATE_DIVIDER_EXPONENT	12ULL
+#define MAX_RATE_EXPONENT		0x0FULL
+#define MAX_RATE_MANTISSA		0xFFULL
+
+/* Bitfields in NIX_TLX_PIR register */
+#define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
+#define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
+#define TLX_RATE_DIVIDER_EXPONENT	GENMASK_ULL(16, 13)
+#define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
+#define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
+
+static int otx2_qos_update_tx_netdev_queues(struct otx2_nic *pfvf)
+{
+	int tx_queues, err, qos_txqs = 0;
+	struct otx2_hw *hw = &pfvf->hw;
+
+	qos_txqs = bitmap_weight(pfvf->qos.qos_sq_bmap,
+				 OTX2_QOS_MAX_LEAF_NODES);
+
+	tx_queues = hw->tx_queues + qos_txqs;
+
+	err = netif_set_real_num_tx_queues(pfvf->netdev, tx_queues);
+	if (err) {
+		netdev_err(pfvf->netdev,
+			   "Failed to set no of Tx queues: %d\n", tx_queues);
+		return err;
+	}
+
+	return 0;
+}
+
+static u64 otx2_qos_convert_rate(u64 rate)
+{
+	u64 converted_rate;
+
+	/* convert bytes per second to Mbps */
+	converted_rate = rate * 8;
+	converted_rate = max_t(u64, converted_rate / 1000000, 1);
+
+	return converted_rate;
+}
+
+static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
+				  struct otx2_qos_node *node,
+				  struct nix_txschq_config *cfg)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int num_regs = 0;
+	u64 maxrate;
+	u8 level;
+
+	level = node->level;
+
+	/* program txschq registers */
+	if (level == NIX_TXSCH_LVL_SMQ) {
+		cfg->reg[num_regs] = NIX_AF_SMQX_CFG(node->schq);
+		cfg->regval[num_regs] = ((u64)pfvf->tx_max_pktlen << 8) |
+					OTX2_MIN_MTU;
+		cfg->regval[num_regs] |= (0x20ULL << 51) | (0x80ULL << 39) |
+					 (0x2ULL << 36);
+		num_regs++;
+
+		/* configure parent txschq */
+		cfg->reg[num_regs] = NIX_AF_MDQX_PARENT(node->schq);
+		cfg->regval[num_regs] = node->parent->schq << 16;
+		num_regs++;
+
+		/* configure prio/quantum */
+		if (node->qid == OTX2_QOS_QID_NONE) {
+			cfg->reg[num_regs] = NIX_AF_MDQX_SCHEDULE(node->schq);
+			cfg->regval[num_regs] =  node->prio << 24 |
+						 mtu_to_dwrr_weight(pfvf,
+								    pfvf->tx_max_pktlen);
+			num_regs++;
+			goto txschq_cfg_out;
+		}
+
+		/* configure prio */
+		cfg->reg[num_regs] = NIX_AF_MDQX_SCHEDULE(node->schq);
+		cfg->regval[num_regs] = (node->schq -
+					 node->parent->prio_anchor) << 24;
+		num_regs++;
+
+		/* configure PIR */
+		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
+
+		cfg->reg[num_regs] = NIX_AF_MDQX_PIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
+		num_regs++;
+
+		/* configure CIR */
+		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
+			/* Don't configure CIR when both CIR+PIR not supported
+			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
+			 */
+			goto txschq_cfg_out;
+		}
+
+		cfg->reg[num_regs] = NIX_AF_MDQX_CIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
+		num_regs++;
+	} else if (level == NIX_TXSCH_LVL_TL4) {
+		/* configure parent txschq */
+		cfg->reg[num_regs] = NIX_AF_TL4X_PARENT(node->schq);
+		cfg->regval[num_regs] = node->parent->schq << 16;
+		num_regs++;
+
+		/* return if not htb node */
+		if (node->qid == OTX2_QOS_QID_NONE) {
+			cfg->reg[num_regs] = NIX_AF_TL4X_SCHEDULE(node->schq);
+			cfg->regval[num_regs] =  node->prio << 24 |
+						 mtu_to_dwrr_weight(pfvf,
+								    pfvf->tx_max_pktlen);
+			num_regs++;
+			goto txschq_cfg_out;
+		}
+
+		/* configure priority */
+		cfg->reg[num_regs] = NIX_AF_TL4X_SCHEDULE(node->schq);
+		cfg->regval[num_regs] = (node->schq -
+					 node->parent->prio_anchor) << 24;
+		num_regs++;
+
+		/* configure PIR */
+		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
+		cfg->reg[num_regs] = NIX_AF_TL4X_PIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
+		num_regs++;
+
+		/* configure CIR */
+		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
+			/* Don't configure CIR when both CIR+PIR not supported
+			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
+			 */
+			goto txschq_cfg_out;
+		}
+
+		cfg->reg[num_regs] = NIX_AF_TL4X_CIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
+		num_regs++;
+	} else if (level == NIX_TXSCH_LVL_TL3) {
+		/* configure parent txschq */
+		cfg->reg[num_regs] = NIX_AF_TL3X_PARENT(node->schq);
+		cfg->regval[num_regs] = node->parent->schq << 16;
+		num_regs++;
+
+		/* configure link cfg */
+		if (level == pfvf->qos.link_cfg_lvl) {
+			cfg->reg[num_regs] = NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
+			cfg->regval[num_regs] = BIT_ULL(13) | BIT_ULL(12);
+			num_regs++;
+		}
+
+		/* return if not htb node */
+		if (node->qid == OTX2_QOS_QID_NONE) {
+			cfg->reg[num_regs] = NIX_AF_TL3X_SCHEDULE(node->schq);
+			cfg->regval[num_regs] =  node->prio << 24 |
+						 mtu_to_dwrr_weight(pfvf,
+								    pfvf->tx_max_pktlen);
+			num_regs++;
+			goto txschq_cfg_out;
+		}
+
+		/* configure priority */
+		cfg->reg[num_regs] = NIX_AF_TL3X_SCHEDULE(node->schq);
+		cfg->regval[num_regs] = (node->schq -
+					 node->parent->prio_anchor) << 24;
+		num_regs++;
+
+		/* configure PIR */
+		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
+		cfg->reg[num_regs] = NIX_AF_TL3X_PIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
+		num_regs++;
+
+		/* configure CIR */
+		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
+			/* Don't configure CIR when both CIR+PIR not supported
+			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
+			 */
+			goto txschq_cfg_out;
+		}
+
+		cfg->reg[num_regs] = NIX_AF_TL3X_CIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
+		num_regs++;
+	} else if (level == NIX_TXSCH_LVL_TL2) {
+		/* configure parent txschq */
+		cfg->reg[num_regs] = NIX_AF_TL2X_PARENT(node->schq);
+		cfg->regval[num_regs] = hw->tx_link << 16;
+		num_regs++;
+
+		/* configure link cfg */
+		if (level == pfvf->qos.link_cfg_lvl) {
+			cfg->reg[num_regs] = NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
+			cfg->regval[num_regs] = BIT_ULL(13) | BIT_ULL(12);
+			num_regs++;
+		}
+
+		/* return if not htb node */
+		if (node->qid == OTX2_QOS_QID_NONE) {
+			cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
+			cfg->regval[num_regs] =  node->prio << 24 |
+						 mtu_to_dwrr_weight(pfvf,
+								    pfvf->tx_max_pktlen);
+			num_regs++;
+			goto txschq_cfg_out;
+		}
+
+		/* check if node is root */
+		if (node->qid == OTX2_QOS_QID_INNER && !node->parent) {
+			cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
+			cfg->regval[num_regs] =  hw->txschq_aggr_lvl_rr_prio << 24 |
+						 mtu_to_dwrr_weight(pfvf,
+								    pfvf->tx_max_pktlen);
+			num_regs++;
+			goto txschq_cfg_out;
+		}
+
+		/* configure priority/quantum */
+		cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
+		cfg->regval[num_regs] = (node->schq -
+					 node->parent->prio_anchor) << 24;
+		num_regs++;
+
+		/* configure PIR */
+		maxrate = (node->rate > node->ceil) ? node->rate : node->ceil;
+		cfg->reg[num_regs] = NIX_AF_TL2X_PIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
+		num_regs++;
+
+		/* configure CIR */
+		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
+			/* Don't configure CIR when both CIR+PIR not supported
+			 * On 96xx, CIR + PIR + RED_ALGO=STALL causes deadlock
+			 */
+			goto txschq_cfg_out;
+		}
+
+		cfg->reg[num_regs] = NIX_AF_TL2X_CIR(node->schq);
+		cfg->regval[num_regs] =
+			otx2_get_txschq_rate_regval(pfvf, node->rate, 65536);
+		num_regs++;
+	}
+
+txschq_cfg_out:
+	cfg->num_regs = num_regs;
+}
+
+static int otx2_qos_txschq_set_parent_topology(struct otx2_nic *pfvf,
+					       struct otx2_qos_node *parent)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct nix_txschq_config *cfg;
+	int rc;
+
+	if (parent->level == NIX_TXSCH_LVL_MDQ)
+		return 0;
+
+	mutex_lock(&mbox->lock);
+
+	cfg = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
+	if (!cfg)
+		return -ENOMEM;
+
+	cfg->lvl = parent->level;
+
+	if (parent->level == NIX_TXSCH_LVL_TL4)
+		cfg->reg[0] = NIX_AF_TL4X_TOPOLOGY(parent->schq);
+	else if (parent->level == NIX_TXSCH_LVL_TL3)
+		cfg->reg[0] = NIX_AF_TL3X_TOPOLOGY(parent->schq);
+	else if (parent->level == NIX_TXSCH_LVL_TL2)
+		cfg->reg[0] = NIX_AF_TL2X_TOPOLOGY(parent->schq);
+	else if (parent->level == NIX_TXSCH_LVL_TL1)
+		cfg->reg[0] = NIX_AF_TL1X_TOPOLOGY(parent->schq);
+
+	cfg->regval[0] = (u64)parent->prio_anchor << 32;
+	cfg->num_regs++;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+
+	mutex_unlock(&mbox->lock);
+
+	return rc;
+}
+
+static void otx2_qos_free_hw_node_schq(struct otx2_nic *pfvf,
+				       struct otx2_qos_node *parent)
+{
+	struct otx2_qos_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &parent->child_schq_list, list)
+		otx2_txschq_free_one(pfvf, node->level, node->schq);
+}
+
+static void otx2_qos_free_hw_node(struct otx2_nic *pfvf,
+				  struct otx2_qos_node *parent)
+{
+	struct otx2_qos_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &parent->child_list, list) {
+		otx2_qos_free_hw_node(pfvf, node);
+		otx2_txschq_free_one(pfvf, node->level, node->schq);
+		otx2_qos_free_hw_node_schq(pfvf, node);
+	}
+}
+
+static void otx2_qos_free_hw_cfg(struct otx2_nic *pfvf,
+				 struct otx2_qos_node *node)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+
+	/* free child node hw mappings */
+	otx2_qos_free_hw_node(pfvf, node);
+	otx2_qos_free_hw_node_schq(pfvf, node);
+
+	/* free node hw mappings */
+	otx2_txschq_free_one(pfvf, node->level, node->schq);
+
+	mutex_unlock(&pfvf->qos.qos_lock);
+}
+
+static void otx2_qos_sw_node_delete(struct otx2_nic *pfvf,
+				    struct otx2_qos_node *node)
+{
+	hash_del(&node->hlist);
+
+	if (node->qid != OTX2_QOS_QID_INNER && node->qid != OTX2_QOS_QID_NONE) {
+		__clear_bit(node->qid, pfvf->qos.qos_sq_bmap);
+		otx2_qos_update_tx_netdev_queues(pfvf);
+	}
+
+	list_del(&node->list);
+	kfree(node);
+}
+
+static void otx2_qos_free_sw_node_schq(struct otx2_nic *pfvf,
+				       struct otx2_qos_node *parent)
+{
+	struct otx2_qos_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &parent->child_schq_list, list) {
+		list_del(&node->list);
+		kfree(node);
+	}
+}
+
+static void __otx2_qos_free_sw_node(struct otx2_nic *pfvf,
+				    struct otx2_qos_node *parent)
+{
+	struct otx2_qos_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &parent->child_list, list) {
+		__otx2_qos_free_sw_node(pfvf, node);
+		otx2_qos_free_sw_node_schq(pfvf, node);
+		otx2_qos_sw_node_delete(pfvf, node);
+	}
+}
+
+static void otx2_qos_free_sw_node(struct otx2_nic *pfvf,
+				  struct otx2_qos_node *node)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+
+	__otx2_qos_free_sw_node(pfvf, node);
+	otx2_qos_free_sw_node_schq(pfvf, node);
+	otx2_qos_sw_node_delete(pfvf, node);
+
+	mutex_unlock(&pfvf->qos.qos_lock);
+}
+
+static void otx2_qos_destroy_node(struct otx2_nic *pfvf,
+				  struct otx2_qos_node *node)
+{
+	otx2_qos_free_hw_cfg(pfvf, node);
+	otx2_qos_free_sw_node(pfvf, node);
+}
+
+static void otx2_qos_fill_cfg_schq(struct otx2_qos_node *parent,
+				   struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *node;
+
+	list_for_each_entry(node, &parent->child_schq_list, list)
+		cfg->schq[node->level]++;
+}
+
+static void otx2_qos_fill_cfg_tl(struct otx2_qos_node *parent,
+				 struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *node;
+
+	list_for_each_entry(node, &parent->child_list, list) {
+		otx2_qos_fill_cfg_tl(node, cfg);
+		cfg->schq_contig[node->level]++;
+		otx2_qos_fill_cfg_schq(node, cfg);
+	}
+}
+
+static void otx2_qos_prepare_txschq_cfg(struct otx2_nic *pfvf,
+					struct otx2_qos_node *parent,
+					struct otx2_qos_cfg *cfg)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+	otx2_qos_fill_cfg_tl(parent, cfg);
+	mutex_unlock(&pfvf->qos.qos_lock);
+}
+
+static void otx2_qos_read_txschq_cfg_schq(struct otx2_qos_node *parent,
+					  struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *node;
+	int cnt;
+
+	list_for_each_entry(node, &parent->child_schq_list, list) {
+		cnt = cfg->dwrr_node_pos[node->level];
+		cfg->schq_list[node->level][cnt] = node->schq;
+		cfg->schq[node->level]++;
+		cfg->dwrr_node_pos[node->level]++;
+	}
+}
+
+static void otx2_qos_read_txschq_cfg_tl(struct otx2_qos_node *parent,
+					struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *node;
+	int cnt;
+
+	list_for_each_entry(node, &parent->child_list, list) {
+		otx2_qos_read_txschq_cfg_tl(node, cfg);
+		cnt = cfg->static_node_pos[node->level];
+		cfg->schq_contig_list[node->level][cnt] = node->schq;
+		cfg->schq_contig[node->level]++;
+		cfg->static_node_pos[node->level]++;
+		otx2_qos_read_txschq_cfg_schq(node, cfg);
+	}
+}
+
+static void otx2_qos_read_txschq_cfg(struct otx2_nic *pfvf,
+				     struct otx2_qos_node *node,
+				     struct otx2_qos_cfg *cfg)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+	otx2_qos_read_txschq_cfg_tl(node, cfg);
+	mutex_unlock(&pfvf->qos.qos_lock);
+}
+
+static struct otx2_qos_node *
+otx2_qos_alloc_root(struct otx2_nic *pfvf)
+{
+	struct otx2_qos_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->parent = NULL;
+	if (!is_otx2_vf(pfvf->pcifunc))
+		node->level = NIX_TXSCH_LVL_TL1;
+	else
+		node->level = NIX_TXSCH_LVL_TL2;
+
+	node->qid = OTX2_QOS_QID_INNER;
+	node->classid = OTX2_QOS_ROOT_CLASSID;
+
+	hash_add(pfvf->qos.qos_hlist, &node->hlist, node->classid);
+	list_add_tail(&node->list, &pfvf->qos.qos_tree);
+	INIT_LIST_HEAD(&node->child_list);
+	INIT_LIST_HEAD(&node->child_schq_list);
+
+	return node;
+}
+
+static int otx2_qos_add_child_node(struct otx2_qos_node *parent,
+				   struct otx2_qos_node *node)
+{
+	struct list_head *head = &parent->child_list;
+	struct otx2_qos_node *tmp_node;
+	struct list_head *tmp;
+
+	for (tmp = head->next; tmp != head; tmp = tmp->next) {
+		tmp_node = list_entry(tmp, struct otx2_qos_node, list);
+		if (tmp_node->prio == node->prio)
+			return -EEXIST;
+		if (tmp_node->prio > node->prio) {
+			list_add_tail(&node->list, tmp);
+			return 0;
+		}
+	}
+
+	list_add_tail(&node->list, head);
+	return 0;
+}
+
+static int otx2_qos_alloc_txschq_node(struct otx2_nic *pfvf,
+				      struct otx2_qos_node *node)
+{
+	struct otx2_qos_node *txschq_node, *parent, *tmp;
+	int lvl;
+
+	parent = node;
+	for (lvl = node->level - 1; lvl >= NIX_TXSCH_LVL_MDQ; lvl--) {
+		txschq_node = kzalloc(sizeof(*txschq_node), GFP_KERNEL);
+		if (!txschq_node)
+			goto err_out;
+
+		txschq_node->parent = parent;
+		txschq_node->level = lvl;
+		txschq_node->classid = OTX2_QOS_CLASS_NONE;
+		txschq_node->qid = OTX2_QOS_QID_NONE;
+		txschq_node->rate = 0;
+		txschq_node->ceil = 0;
+		txschq_node->prio = 0;
+
+		mutex_lock(&pfvf->qos.qos_lock);
+		list_add_tail(&txschq_node->list, &node->child_schq_list);
+		mutex_unlock(&pfvf->qos.qos_lock);
+
+		INIT_LIST_HEAD(&txschq_node->child_list);
+		INIT_LIST_HEAD(&txschq_node->child_schq_list);
+		parent = txschq_node;
+	}
+
+	return 0;
+
+err_out:
+	list_for_each_entry_safe(txschq_node, tmp, &node->child_schq_list,
+				 list) {
+		list_del(&txschq_node->list);
+		kfree(txschq_node);
+	}
+	return -ENOMEM;
+}
+
+static struct otx2_qos_node *
+otx2_qos_sw_create_leaf_node(struct otx2_nic *pfvf,
+			     struct otx2_qos_node *parent,
+			     u16 classid, u32 prio, u64 rate, u64 ceil,
+			     u16 qid)
+{
+	struct otx2_qos_node *node;
+	int err;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	node->parent = parent;
+	node->level = parent->level - 1;
+	node->classid = classid;
+	node->qid = qid;
+	node->rate = otx2_qos_convert_rate(rate);
+	node->ceil = otx2_qos_convert_rate(ceil);
+	node->prio = prio;
+
+	__set_bit(qid, pfvf->qos.qos_sq_bmap);
+
+	hash_add(pfvf->qos.qos_hlist, &node->hlist, classid);
+
+	mutex_lock(&pfvf->qos.qos_lock);
+	err = otx2_qos_add_child_node(parent, node);
+	if (err) {
+		mutex_unlock(&pfvf->qos.qos_lock);
+		return ERR_PTR(err);
+	}
+	mutex_unlock(&pfvf->qos.qos_lock);
+
+	INIT_LIST_HEAD(&node->child_list);
+	INIT_LIST_HEAD(&node->child_schq_list);
+
+	err = otx2_qos_alloc_txschq_node(pfvf, node);
+	if (err) {
+		otx2_qos_sw_node_delete(pfvf, node);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return node;
+}
+
+static struct otx2_qos_node
+*otx2_sw_node_find_by_qid(struct otx2_nic *pfvf, u16 qid)
+{
+	struct otx2_qos_node *node = NULL;
+	int bkt;
+
+	hash_for_each(pfvf->qos.qos_hlist, bkt, node, hlist) {
+		if (node->qid == qid)
+			break;
+	}
+
+	return node;
+}
+
+static struct otx2_qos_node *
+otx2_sw_node_find(struct otx2_nic *pfvf, u32 classid)
+{
+	struct otx2_qos_node *node = NULL;
+
+	hash_for_each_possible(pfvf->qos.qos_hlist, node, hlist, classid) {
+		if (node->classid == classid)
+			break;
+	}
+
+	return node;
+}
+
+int otx2_get_txq_by_classid(struct otx2_nic *pfvf, u16 classid)
+{
+	struct otx2_qos_node *node;
+	u16 qid;
+	int res;
+
+	node = otx2_sw_node_find(pfvf, classid);
+	if (!node) {
+		res = -ENOENT;
+		goto out;
+	}
+	qid = READ_ONCE(node->qid);
+	if (qid == OTX2_QOS_QID_INNER) {
+		res = -EINVAL;
+		goto out;
+	}
+	res = pfvf->hw.tx_queues + qid;
+out:
+	return res;
+}
+
+static int
+otx2_qos_txschq_config(struct otx2_nic *pfvf, struct otx2_qos_node *node)
+{
+	struct mbox *mbox = &pfvf->mbox;
+	struct nix_txschq_config *req;
+	int rc;
+
+	mutex_lock(&mbox->lock);
+
+	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->lvl = node->level;
+	__otx2_qos_txschq_cfg(pfvf, node, req);
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+
+	mutex_unlock(&mbox->lock);
+
+	return rc;
+}
+
+static int otx2_qos_txschq_alloc(struct otx2_nic *pfvf,
+				 struct otx2_qos_cfg *cfg)
+{
+	struct nix_txsch_alloc_req *req;
+	struct nix_txsch_alloc_rsp *rsp;
+	struct mbox *mbox = &pfvf->mbox;
+	int lvl, rc, schq;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		req->schq[lvl] = cfg->schq[lvl];
+		req->schq_contig[lvl] = cfg->schq_contig[lvl];
+	}
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	rsp = (struct nix_txsch_alloc_rsp *)
+	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		for (schq = 0; schq < rsp->schq_contig[lvl]; schq++) {
+			cfg->schq_contig_list[lvl][schq] =
+				rsp->schq_contig_list[lvl][schq];
+		}
+	}
+
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		for (schq = 0; schq < rsp->schq[lvl]; schq++) {
+			cfg->schq_list[lvl][schq] =
+				rsp->schq_list[lvl][schq];
+		}
+	}
+
+	pfvf->qos.link_cfg_lvl = rsp->link_cfg_lvl;
+	pfvf->hw.txschq_aggr_lvl_rr_prio = rsp->aggr_lvl_rr_prio;
+
+	mutex_unlock(&mbox->lock);
+
+	return rc;
+}
+
+static void otx2_qos_txschq_fill_cfg_schq(struct otx2_nic *pfvf,
+					  struct otx2_qos_node *node,
+					  struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *tmp;
+	int cnt;
+
+	list_for_each_entry(tmp, &node->child_schq_list, list) {
+		cnt = cfg->dwrr_node_pos[tmp->level];
+		tmp->schq = cfg->schq_list[tmp->level][cnt];
+		cfg->dwrr_node_pos[tmp->level]++;
+	}
+}
+
+static void otx2_qos_txschq_fill_cfg_tl(struct otx2_nic *pfvf,
+					struct otx2_qos_node *node,
+					struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *tmp;
+	int cnt;
+
+	list_for_each_entry(tmp, &node->child_list, list) {
+		otx2_qos_txschq_fill_cfg_tl(pfvf, tmp, cfg);
+		cnt = cfg->static_node_pos[tmp->level];
+		tmp->schq = cfg->schq_contig_list[tmp->level][cnt];
+		if (cnt == 0)
+			node->prio_anchor = tmp->schq;
+		cfg->static_node_pos[tmp->level]++;
+		otx2_qos_txschq_fill_cfg_schq(pfvf, tmp, cfg);
+	}
+}
+
+static void otx2_qos_txschq_fill_cfg(struct otx2_nic *pfvf,
+				     struct otx2_qos_node *node,
+				     struct otx2_qos_cfg *cfg)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+	otx2_qos_txschq_fill_cfg_tl(pfvf, node, cfg);
+	otx2_qos_txschq_fill_cfg_schq(pfvf, node, cfg);
+	mutex_unlock(&pfvf->qos.qos_lock);
+}
+
+static int otx2_qos_txschq_push_cfg_schq(struct otx2_nic *pfvf,
+					 struct otx2_qos_node *node,
+					 struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *tmp;
+	int ret = 0;
+
+	list_for_each_entry(tmp, &node->child_schq_list, list) {
+		ret = otx2_qos_txschq_config(pfvf, tmp);
+		if (ret)
+			return -EIO;
+		ret = otx2_qos_txschq_set_parent_topology(pfvf, tmp->parent);
+		if (ret)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static int otx2_qos_txschq_push_cfg_tl(struct otx2_nic *pfvf,
+				       struct otx2_qos_node *node,
+				       struct otx2_qos_cfg *cfg)
+{
+	struct otx2_qos_node *tmp;
+	int ret = 0;
+
+	list_for_each_entry(tmp, &node->child_list, list) {
+		ret = otx2_qos_txschq_push_cfg_tl(pfvf, tmp, cfg);
+		if (ret)
+			return -EIO;
+		ret = otx2_qos_txschq_config(pfvf, tmp);
+		if (ret)
+			return -EIO;
+		ret = otx2_qos_txschq_push_cfg_schq(pfvf, tmp, cfg);
+		if (ret)
+			return -EIO;
+	}
+
+	ret = otx2_qos_txschq_set_parent_topology(pfvf, node);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int otx2_qos_txschq_push_cfg(struct otx2_nic *pfvf,
+				    struct otx2_qos_node *node,
+				    struct otx2_qos_cfg *cfg)
+{
+	int ret = 0;
+
+	mutex_lock(&pfvf->qos.qos_lock);
+	ret = otx2_qos_txschq_push_cfg_tl(pfvf, node, cfg);
+	if (ret)
+		goto out;
+	ret = otx2_qos_txschq_push_cfg_schq(pfvf, node, cfg);
+out:
+	mutex_unlock(&pfvf->qos.qos_lock);
+	return ret;
+}
+
+static int otx2_qos_txschq_update_config(struct otx2_nic *pfvf,
+					 struct otx2_qos_node *node,
+					 struct otx2_qos_cfg *cfg)
+{
+	int ret = 0;
+
+	otx2_qos_txschq_fill_cfg(pfvf, node, cfg);
+	ret = otx2_qos_txschq_push_cfg(pfvf, node, cfg);
+
+	return ret;
+}
+
+static int otx2_qos_txschq_update_root_cfg(struct otx2_nic *pfvf,
+					   struct otx2_qos_node *root,
+					   struct otx2_qos_cfg *cfg)
+{
+	int ret = 0;
+
+	root->schq = cfg->schq_list[root->level][0];
+	ret = otx2_qos_txschq_config(pfvf, root);
+
+	return ret;
+}
+
+static void otx2_qos_free_cfg(struct otx2_nic *pfvf, struct otx2_qos_cfg *cfg)
+{
+	int lvl, idx, schq;
+
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		for (idx = 0; idx < cfg->schq_contig[lvl]; idx++) {
+			schq = cfg->schq_contig_list[lvl][idx];
+			otx2_txschq_free_one(pfvf, lvl, schq);
+		}
+	}
+
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		for (idx = 0; idx < cfg->schq[lvl]; idx++) {
+			schq = cfg->schq_list[lvl][idx];
+			otx2_txschq_free_one(pfvf, lvl, schq);
+		}
+	}
+}
+
+static void otx2_qos_enadis_sq(struct otx2_nic *pfvf,
+			       struct otx2_qos_node *node,
+			       u16 qid)
+{
+	if (pfvf->qos.qid_to_sqmap[qid] != OTX2_QOS_INVALID_SQ)
+		otx2_qos_disable_sq(pfvf, qid);
+
+	pfvf->qos.qid_to_sqmap[qid] = node->schq;
+	otx2_qos_enable_sq(pfvf, qid);
+}
+
+static void otx2_qos_update_smq_schq(struct otx2_nic *pfvf,
+				     struct otx2_qos_node *node,
+				     bool action)
+{
+	struct otx2_qos_node *tmp;
+
+	if (node->qid == OTX2_QOS_QID_INNER)
+		return;
+
+	list_for_each_entry(tmp, &node->child_schq_list, list) {
+		if (tmp->level == NIX_TXSCH_LVL_MDQ) {
+			if (action == QOS_SMQ_FLUSH)
+				otx2_smq_flush(pfvf, tmp->schq);
+			else
+				otx2_qos_enadis_sq(pfvf, tmp, node->qid);
+		}
+	}
+}
+
+static void __otx2_qos_update_smq(struct otx2_nic *pfvf,
+				  struct otx2_qos_node *node,
+				  bool action)
+{
+	struct otx2_qos_node *tmp;
+
+	list_for_each_entry(tmp, &node->child_list, list) {
+		__otx2_qos_update_smq(pfvf, tmp, action);
+		if (tmp->qid == OTX2_QOS_QID_INNER)
+			continue;
+		if (tmp->level == NIX_TXSCH_LVL_MDQ) {
+			if (action == QOS_SMQ_FLUSH)
+				otx2_smq_flush(pfvf, tmp->schq);
+			else
+				otx2_qos_enadis_sq(pfvf, tmp, tmp->qid);
+		} else {
+			otx2_qos_update_smq_schq(pfvf, tmp, action);
+		}
+	}
+}
+
+static int otx2_qos_update_smq(struct otx2_nic *pfvf,
+			       struct otx2_qos_node *node,
+			       bool action)
+{
+	mutex_lock(&pfvf->qos.qos_lock);
+	__otx2_qos_update_smq(pfvf, node, action);
+	otx2_qos_update_smq_schq(pfvf, node, action);
+	mutex_unlock(&pfvf->qos.qos_lock);
+
+	return 0;
+}
+
+static int otx2_qos_push_txschq_cfg(struct otx2_nic *pfvf,
+				    struct otx2_qos_node *node,
+				    struct otx2_qos_cfg *cfg)
+{
+	int ret = 0;
+
+	ret = otx2_qos_txschq_alloc(pfvf, cfg);
+	if (ret)
+		return -ENOSPC;
+
+	if (!(pfvf->netdev->flags & IFF_UP)) {
+		otx2_qos_txschq_fill_cfg(pfvf, node, cfg);
+		return 0;
+	}
+
+	ret = otx2_qos_txschq_update_config(pfvf, node, cfg);
+	if (ret) {
+		otx2_qos_free_cfg(pfvf, cfg);
+		return -EIO;
+	}
+
+	ret = otx2_qos_update_smq(pfvf, node, QOS_CFG_SQ);
+	if (ret) {
+		otx2_qos_free_cfg(pfvf, cfg);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int otx2_qos_update_tree(struct otx2_nic *pfvf,
+				struct otx2_qos_node *node,
+				struct otx2_qos_cfg *cfg)
+{
+	int ret = 0;
+
+	otx2_qos_prepare_txschq_cfg(pfvf, node->parent, cfg);
+	ret = otx2_qos_push_txschq_cfg(pfvf, node->parent, cfg);
+
+	return ret;
+}
+
+static int otx2_qos_root_add(struct otx2_nic *pfvf, u16 htb_maj_id, u16 htb_defcls,
+			     struct netlink_ext_ack *extack)
+{
+	struct otx2_qos_cfg *new_cfg;
+	struct otx2_qos_node *root;
+	int err;
+
+	netdev_dbg(pfvf->netdev,
+		   "TC_HTB_CREATE: handle=0x%x defcls=0x%x\n",
+		   htb_maj_id, htb_defcls);
+
+	INIT_LIST_HEAD(&pfvf->qos.qos_tree);
+	mutex_init(&pfvf->qos.qos_lock);
+
+	root = otx2_qos_alloc_root(pfvf);
+	if (IS_ERR(root)) {
+		mutex_destroy(&pfvf->qos.qos_lock);
+		err = PTR_ERR(root);
+		return err;
+	}
+
+	/* allocate txschq queue */
+	new_cfg = kzalloc(sizeof(*new_cfg), GFP_KERNEL);
+	if (!new_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		mutex_destroy(&pfvf->qos.qos_lock);
+		return -ENOMEM;
+	}
+	/* allocate htb root node */
+	new_cfg->schq[root->level] = 1;
+	err = otx2_qos_txschq_alloc(pfvf, new_cfg);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Error allocating txschq");
+		goto free_root_node;
+	}
+
+	if (!(pfvf->netdev->flags & IFF_UP) ||
+	    root->level == NIX_TXSCH_LVL_TL1) {
+		root->schq = new_cfg->schq_list[root->level][0];
+		goto out;
+	}
+
+	/* update the txschq configuration in hw */
+	err = otx2_qos_txschq_update_root_cfg(pfvf, root, new_cfg);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Error updating txschq configuration");
+		goto txschq_free;
+	}
+
+out:
+	WRITE_ONCE(pfvf->qos.defcls, htb_defcls);
+	smp_store_release(&pfvf->qos.maj_id, htb_maj_id); /* barrier */
+	kfree(new_cfg);
+	return 0;
+
+txschq_free:
+	otx2_qos_free_cfg(pfvf, new_cfg);
+free_root_node:
+	kfree(new_cfg);
+	otx2_qos_sw_node_delete(pfvf, root);
+	mutex_destroy(&pfvf->qos.qos_lock);
+	return err;
+}
+
+static int otx2_qos_root_destroy(struct otx2_nic *pfvf)
+{
+	struct otx2_qos_node *root;
+
+	netdev_dbg(pfvf->netdev, "TC_HTB_DESTROY\n");
+
+	/* find root node */
+	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
+	if (!root)
+		return -ENOENT;
+
+	/* free the hw mappings */
+	otx2_qos_destroy_node(pfvf, root);
+	mutex_destroy(&pfvf->qos.qos_lock);
+
+	return 0;
+}
+
+static int otx2_qos_validate_configuration(struct otx2_qos_node *parent,
+					   struct netlink_ext_ack *extack,
+					   struct otx2_nic *pfvf,
+					   u64 prio)
+{
+	if (test_bit(prio, parent->prio_bmap)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Static priority child with same priority exists");
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
+static int otx2_qos_leaf_alloc_queue(struct otx2_nic *pfvf, u16 classid,
+				     u32 parent_classid, u64 rate, u64 ceil,
+				     u64 prio, struct netlink_ext_ack *extack)
+{
+	struct otx2_qos_cfg *old_cfg, *new_cfg;
+	struct otx2_qos_node *node, *parent;
+	int qid, ret, err;
+
+	netdev_dbg(pfvf->netdev,
+		   "TC_HTB_LEAF_ALLOC_QUEUE: classid=0x%x parent_classid=0x%x rate=%lld ceil=%lld prio=%lld\n",
+		   classid, parent_classid, rate, ceil, prio);
+
+	if (prio > OTX2_QOS_MAX_PRIO) {
+		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to 7");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* get parent node */
+	parent = otx2_sw_node_find(pfvf, parent_classid);
+	if (!parent) {
+		NL_SET_ERR_MSG_MOD(extack, "parent node not found");
+		ret = -ENOENT;
+		goto out;
+	}
+	if (parent->level == NIX_TXSCH_LVL_MDQ) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB qos max levels reached");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = otx2_qos_validate_configuration(parent, extack, pfvf, prio);
+	if (ret)
+		goto out;
+
+	set_bit(prio, parent->prio_bmap);
+
+	/* read current txschq configuration */
+	old_cfg = kzalloc(sizeof(*old_cfg), GFP_KERNEL);
+	if (!old_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		ret = -ENOMEM;
+		goto out;
+	}
+	otx2_qos_read_txschq_cfg(pfvf, parent, old_cfg);
+
+	/* allocate a new sq */
+	qid = otx2_qos_get_qid(pfvf);
+	if (qid < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Reached max supported QOS SQ's");
+		ret = -ENOMEM;
+		goto free_old_cfg;
+	}
+
+	/* Actual SQ mapping will be updated after SMQ alloc */
+	pfvf->qos.qid_to_sqmap[qid] = OTX2_QOS_INVALID_SQ;
+
+	/* allocate and initialize a new child node */
+	node = otx2_qos_sw_create_leaf_node(pfvf, parent, classid, prio, rate,
+					    ceil, qid);
+	if (IS_ERR(node)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to allocate leaf node");
+		ret = PTR_ERR(node);
+		goto free_old_cfg;
+	}
+
+	/* push new txschq config to hw */
+	new_cfg = kzalloc(sizeof(*new_cfg), GFP_KERNEL);
+	if (!new_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		ret = -ENOMEM;
+		goto free_node;
+	}
+	ret = otx2_qos_update_tree(pfvf, node, new_cfg);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration error");
+		kfree(new_cfg);
+		otx2_qos_sw_node_delete(pfvf, node);
+		/* restore the old qos tree */
+		err = otx2_qos_txschq_update_config(pfvf, parent, old_cfg);
+		if (err) {
+			netdev_err(pfvf->netdev,
+				   "Failed to restore txcshq configuration");
+			goto free_old_cfg;
+		}
+		err = otx2_qos_update_smq(pfvf, parent, QOS_CFG_SQ);
+		if (err)
+			netdev_err(pfvf->netdev,
+				   "Failed to restore smq configuration");
+		goto free_old_cfg;
+	}
+
+	/* update tx_real_queues */
+	otx2_qos_update_tx_netdev_queues(pfvf);
+
+	/* free new txschq config */
+	kfree(new_cfg);
+
+	/* free old txschq config */
+	otx2_qos_free_cfg(pfvf, old_cfg);
+	kfree(old_cfg);
+
+	return pfvf->hw.tx_queues + qid;
+
+free_node:
+	otx2_qos_sw_node_delete(pfvf, node);
+free_old_cfg:
+	kfree(old_cfg);
+out:
+	return ret;
+}
+
+static int otx2_qos_leaf_to_inner(struct otx2_nic *pfvf, u16 classid,
+				  u16 child_classid, u64 rate, u64 ceil, u64 prio,
+				  struct netlink_ext_ack *extack)
+{
+	struct otx2_qos_cfg *old_cfg, *new_cfg;
+	struct otx2_qos_node *node, *child;
+	int ret, err;
+	u16 qid;
+
+	netdev_dbg(pfvf->netdev,
+		   "TC_HTB_LEAF_TO_INNER classid %04x, child %04x, rate %llu, ceil %llu\n",
+		   classid, child_classid, rate, ceil);
+
+	if (prio > OTX2_QOS_MAX_PRIO) {
+		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to 7");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* find node related to classid */
+	node = otx2_sw_node_find(pfvf, classid);
+	if (!node) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
+		ret = -ENOENT;
+		goto out;
+	}
+	/* check max qos txschq level */
+	if (node->level == NIX_TXSCH_LVL_MDQ) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB qos level not supported");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	set_bit(prio, node->prio_bmap);
+
+	/* store the qid to assign to leaf node */
+	qid = node->qid;
+
+	/* read current txschq configuration */
+	old_cfg = kzalloc(sizeof(*old_cfg), GFP_KERNEL);
+	if (!old_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		ret = -ENOMEM;
+		goto out;
+	}
+	otx2_qos_read_txschq_cfg(pfvf, node, old_cfg);
+
+	/* delete the txschq nodes allocated for this node */
+	otx2_qos_free_sw_node_schq(pfvf, node);
+
+	/* mark this node as htb inner node */
+	node->qid = OTX2_QOS_QID_INNER;
+
+	/* allocate and initialize a new child node */
+	child = otx2_qos_sw_create_leaf_node(pfvf, node, child_classid,
+					     prio, rate, ceil, qid);
+	if (IS_ERR(child)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to allocate leaf node");
+		ret = PTR_ERR(child);
+		goto free_old_cfg;
+	}
+
+	/* push new txschq config to hw */
+	new_cfg = kzalloc(sizeof(*new_cfg), GFP_KERNEL);
+	if (!new_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		ret = -ENOMEM;
+		goto free_node;
+	}
+	ret = otx2_qos_update_tree(pfvf, child, new_cfg);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration error");
+		kfree(new_cfg);
+		otx2_qos_sw_node_delete(pfvf, child);
+		/* restore the old qos tree */
+		node->qid = qid;
+		err = otx2_qos_alloc_txschq_node(pfvf, node);
+		if (err) {
+			netdev_err(pfvf->netdev,
+				   "Failed to restore old leaf node");
+			goto free_old_cfg;
+		}
+		err = otx2_qos_txschq_update_config(pfvf, node, old_cfg);
+		if (err) {
+			netdev_err(pfvf->netdev,
+				   "Failed to restore txcshq configuration");
+			goto free_old_cfg;
+		}
+		err = otx2_qos_update_smq(pfvf, node, QOS_CFG_SQ);
+		if (err)
+			netdev_err(pfvf->netdev,
+				   "Failed to restore smq configuration");
+		goto free_old_cfg;
+	}
+
+	/* free new txschq config */
+	kfree(new_cfg);
+
+	/* free old txschq config */
+	otx2_qos_free_cfg(pfvf, old_cfg);
+	kfree(old_cfg);
+
+	return 0;
+
+free_node:
+	otx2_qos_sw_node_delete(pfvf, child);
+free_old_cfg:
+	kfree(old_cfg);
+out:
+	return ret;
+}
+
+static int otx2_qos_cur_leaf_nodes(struct otx2_nic *pfvf)
+{
+	int last = find_last_bit(pfvf->qos.qos_sq_bmap, pfvf->hw.tc_tx_queues);
+
+	return last ==  pfvf->hw.tc_tx_queues ? 0 : last + 1;
+}
+
+static void otx2_reset_qdisc(struct net_device *dev, u16 qid)
+{
+	struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, qid);
+	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+
+	if (!qdisc)
+		return;
+
+	spin_lock_bh(qdisc_lock(qdisc));
+	qdisc_reset(qdisc);
+	spin_unlock_bh(qdisc_lock(qdisc));
+}
+
+static void otx2_cfg_smq(struct otx2_nic *pfvf, struct otx2_qos_node *node, int qid)
+{
+	struct otx2_qos_node *tmp;
+
+	list_for_each_entry(tmp, &node->child_schq_list, list)
+		if (tmp->level == NIX_TXSCH_LVL_MDQ) {
+			otx2_qos_txschq_config(pfvf, tmp);
+			pfvf->qos.qid_to_sqmap[qid] = tmp->schq;
+		}
+}
+
+static int otx2_qos_leaf_del(struct otx2_nic *pfvf, u16 *classid,
+			     struct netlink_ext_ack *extack)
+{
+	struct otx2_qos_node *node, *parent;
+	u16 qid, moved_qid;
+	u64 prio;
+
+	netdev_dbg(pfvf->netdev, "TC_HTB_LEAF_DEL classid %04x\n", *classid);
+
+	/* find node related to classid */
+	node = otx2_sw_node_find(pfvf, *classid);
+	if (!node) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
+		return -ENOENT;
+	}
+	parent = node->parent;
+	prio   = node->prio;
+	qid    = node->qid;
+
+	otx2_qos_disable_sq(pfvf, node->qid);
+
+	otx2_qos_destroy_node(pfvf, node);
+	pfvf->qos.qid_to_sqmap[qid] = OTX2_QOS_INVALID_SQ;
+
+	clear_bit(prio, parent->prio_bmap);
+
+	moved_qid = otx2_qos_cur_leaf_nodes(pfvf);
+
+	if (moved_qid == 0 || moved_qid == qid)
+		return 0;
+
+	moved_qid--;
+
+	node = otx2_sw_node_find_by_qid(pfvf, moved_qid);
+	if (!node)
+		return 0;
+
+	node->qid =  OTX2_QOS_QID_INNER;
+	__clear_bit(moved_qid, pfvf->qos.qos_sq_bmap);
+	otx2_qos_disable_sq(pfvf, moved_qid);
+
+	otx2_reset_qdisc(pfvf->netdev, pfvf->hw.tx_queues + moved_qid);
+
+	otx2_cfg_smq(pfvf, node, qid);
+
+	otx2_qos_enable_sq(pfvf, qid);
+	__set_bit(qid, pfvf->qos.qos_sq_bmap);
+	node->qid = qid;
+
+	*classid = node->classid;
+
+	return 0;
+}
+
+static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force,
+				  struct netlink_ext_ack *extack)
+{
+	struct otx2_qos_node *node, *parent;
+	struct otx2_qos_cfg *new_cfg;
+	u64 prio;
+	int err;
+	u16 qid;
+
+	netdev_dbg(pfvf->netdev,
+		   "TC_HTB_LEAF_DEL_LAST classid %04x\n", classid);
+
+	/* find node related to classid */
+	node = otx2_sw_node_find(pfvf, classid);
+	if (!node) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
+		return -ENOENT;
+	}
+
+	/* save qid for use by parent */
+	qid = node->qid;
+	prio = node->prio;
+
+	parent = otx2_sw_node_find(pfvf, node->parent->classid);
+	if (!parent) {
+		NL_SET_ERR_MSG_MOD(extack, "parent node not found");
+		return -ENOENT;
+	}
+
+	/* destroy the leaf node */
+	otx2_qos_destroy_node(pfvf, node);
+	pfvf->qos.qid_to_sqmap[qid] = OTX2_QOS_INVALID_SQ;
+
+	clear_bit(prio, parent->prio_bmap);
+
+	/* create downstream txschq entries to parent */
+	otx2_qos_alloc_txschq_node(pfvf, parent);
+	parent->qid = qid;
+	__set_bit(qid, pfvf->qos.qos_sq_bmap);
+
+	/* push new txschq config to hw */
+	new_cfg = kzalloc(sizeof(*new_cfg), GFP_KERNEL);
+	if (!new_cfg) {
+		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");
+		return -ENOMEM;
+	}
+	/* fill txschq cfg and push txschq cfg to hw */
+	otx2_qos_fill_cfg_schq(parent, new_cfg);
+	err = otx2_qos_push_txschq_cfg(pfvf, parent, new_cfg);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration error");
+		kfree(new_cfg);
+		return err;
+	}
+	kfree(new_cfg);
+
+	/* update tx_real_queues */
+	otx2_qos_update_tx_netdev_queues(pfvf);
+
+	return 0;
+}
+
+int otx2_clean_qos_queues(struct otx2_nic *pfvf)
+{
+	struct otx2_qos_node *root;
+
+	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
+	if (!root)
+		return 0;
+
+	return otx2_qos_update_smq(pfvf, root, QOS_SMQ_FLUSH);
+}
+
+void otx2_qos_config_txschq(struct otx2_nic *pfvf)
+{
+	struct otx2_qos_node *root;
+	int err;
+
+	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
+	if (!root)
+		return;
+
+	err = otx2_qos_txschq_config(pfvf, root);
+	if (err) {
+		netdev_err(pfvf->netdev, "Error update txschq configuration\n");
+		goto root_destroy;
+	}
+
+	err = otx2_qos_txschq_push_cfg_tl(pfvf, root, NULL);
+	if (err) {
+		netdev_err(pfvf->netdev, "Error update txschq configuration\n");
+		goto root_destroy;
+	}
+
+	err = otx2_qos_update_smq(pfvf, root, QOS_CFG_SQ);
+	if (err) {
+		netdev_err(pfvf->netdev, "Error update smq configuration\n");
+		goto root_destroy;
+	}
+
+	return;
+
+root_destroy:
+	otx2_qos_root_destroy(pfvf);
+}
+
+bool otx2_is_qos_configured(struct otx2_nic *pfvf)
+{
+	struct otx2_qos_node *root;
+
+	root = otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
+	if (!root)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(otx2_is_qos_configured);
+
+int otx2_setup_tc_htb(struct net_device *ndev, struct tc_htb_qopt_offload *htb)
+{
+	struct otx2_nic *pfvf = netdev_priv(ndev);
+	int res;
+
+	switch (htb->command) {
+	case TC_HTB_CREATE:
+		return otx2_qos_root_add(pfvf, htb->parent_classid,
+					 htb->classid, htb->extack);
+	case TC_HTB_DESTROY:
+		return otx2_qos_root_destroy(pfvf);
+	case TC_HTB_LEAF_ALLOC_QUEUE:
+		res = otx2_qos_leaf_alloc_queue(pfvf, htb->classid,
+						htb->parent_classid,
+						htb->rate, htb->ceil,
+						htb->prio, htb->extack);
+		if (res < 0)
+			return res;
+		htb->qid = res;
+		return 0;
+	case TC_HTB_LEAF_TO_INNER:
+		return otx2_qos_leaf_to_inner(pfvf, htb->parent_classid,
+					      htb->classid, htb->rate,
+					      htb->ceil, htb->prio,
+					      htb->extack);
+	case TC_HTB_LEAF_DEL:
+		return otx2_qos_leaf_del(pfvf, &htb->classid, htb->extack);
+	case TC_HTB_LEAF_DEL_LAST:
+	case TC_HTB_LEAF_DEL_LAST_FORCE:
+		return otx2_qos_leaf_del_last(pfvf, htb->classid,
+				htb->command == TC_HTB_LEAF_DEL_LAST_FORCE,
+					      htb->extack);
+	case TC_HTB_LEAF_QUERY_QUEUE:
+		res = otx2_get_txq_by_classid(pfvf, htb->classid);
+		htb->qid = res;
+		return 0;
+	case TC_HTB_NODE_MODIFY:
+		fallthrough;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
index ef8c99a6b2d0..d8e32a6e541d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
@@ -7,13 +7,65 @@
 #ifndef OTX2_QOS_H
 #define OTX2_QOS_H
 
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/rhashtable.h>
+
+#define OTX2_QOS_MAX_LVL		4
+#define OTX2_QOS_MAX_PRIO		7
 #define OTX2_QOS_MAX_LEAF_NODES		16
 
-int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq);
-void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq);
+enum qos_smq_operations {
+	QOS_CFG_SQ,
+	QOS_SMQ_FLUSH,
+};
+
+u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic, u64 maxrate, u32 burst);
+
+int otx2_setup_tc_htb(struct net_device *ndev, struct tc_htb_qopt_offload *htb);
+int otx2_qos_get_qid(struct otx2_nic *pfvf);
+void otx2_qos_free_qid(struct otx2_nic *pfvf, int qidx);
+int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx);
+void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx);
+
+struct otx2_qos_cfg {
+	u16 schq[NIX_TXSCH_LVL_CNT];
+	u16 schq_contig[NIX_TXSCH_LVL_CNT];
+	u16 schq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+	u16 schq_contig_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+	int static_node_pos[NIX_TXSCH_LVL_CNT];
+	int dwrr_node_pos[NIX_TXSCH_LVL_CNT];
+};
 
 struct otx2_qos {
+	DECLARE_HASHTABLE(qos_hlist, order_base_2(OTX2_QOS_MAX_LEAF_NODES));
+	DECLARE_BITMAP(qos_sq_bmap, OTX2_QOS_MAX_LEAF_NODES);
 	u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
+	u16 maj_id;
+	u16 defcls;
+	struct list_head qos_tree;
+	struct mutex qos_lock; /* child list lock */
+	u8  link_cfg_lvl; /* LINKX_CFG CSRs mapped to TL3 or TL2's index ? */
+};
+
+struct otx2_qos_node {
+	/* htb params */
+	u32 classid;
+	u64 rate;
+	u64 ceil;
+	u32 prio;
+	/* hw txschq */
+	u8 level;
+	u16 schq;
+	u16 qid;
+	u16 prio_anchor;
+	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
+	/* list management */
+	struct hlist_node hlist;
+	struct otx2_qos_node *parent;	/* parent qos node */
+	struct list_head list;
+	struct list_head child_list;
+	struct list_head child_schq_list;
 };
 
 #endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
index 96e53d5d1778..66d2de8e7544 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
@@ -225,7 +225,22 @@ static int otx2_qos_ctx_disable(struct otx2_nic *pfvf, u16 qidx, int aura_id)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
-int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq)
+int otx2_qos_get_qid(struct otx2_nic *pfvf)
+{
+	int qidx;
+
+	qidx = find_first_zero_bit(pfvf->qos.qos_sq_bmap,
+				   pfvf->hw.tc_tx_queues);
+
+	return qidx == pfvf->hw.tc_tx_queues ? -ENOSPC : qidx;
+}
+
+void otx2_qos_free_qid(struct otx2_nic *pfvf, int qidx)
+{
+	clear_bit(qidx, pfvf->qos.qos_sq_bmap);
+}
+
+int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx)
 {
 	struct otx2_hw *hw = &pfvf->hw;
 	int pool_id, sq_idx, err;
@@ -241,7 +256,6 @@ int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq)
 		goto out;
 
 	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, sq_idx);
-	pfvf->qos.qid_to_sqmap[qidx] = smq;
 	err = otx2_sq_init(pfvf, sq_idx, pool_id);
 	if (err)
 		goto out;
@@ -250,7 +264,7 @@ int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq)
 	return err;
 }
 
-void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq)
+void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx)
 {
 	struct otx2_qset *qset = &pfvf->qset;
 	struct otx2_hw *hw = &pfvf->hw;
-- 
2.17.1

