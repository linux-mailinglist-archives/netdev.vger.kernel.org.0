Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C4F6EEDAA
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbjDZFtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbjDZFtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:49:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCDF2134;
        Tue, 25 Apr 2023 22:48:44 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PKuKbU025609;
        Tue, 25 Apr 2023 22:48:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=syT/F4i0UTiSv1pXqwKX8DGCIcI+SGGzfmriqqhfSNY=;
 b=TjhiHUsQk9vfPutbzvkLCBudS1qN3fCHbvASV+honZqK8r5sO4XUWCwXPUNS/QBVoXDP
 +a4zK0ix1vwVxXZXFmM+2LwirtASX0XK4kIjgmxZe+F3LFXu2Oy1A77sqIgJ4hLbWSwT
 32dhE3Zeu166q0r9pX4SnfciCiuhYi8eGOB6Q+m7oMkakev9a0QA7EkStC6nzcZXt6Mf
 LuyW0deGW2bRGD//9ymnwM8FL6LHd7xSqp6TylJsVl0XzBsL4zRyLkNXmOIUbjY1fdlc
 GisouxS6kWsrVrbfR0XblwvXrMDLZOMg0Myo3ZIzbq17PbphhmGOEgqXZX0SDNC/syGb Ng== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pd9m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 22:48:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 22:48:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 22:48:20 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BFA313F7075;
        Tue, 25 Apr 2023 22:48:14 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v10 7/8] octeontx2-pf: ethtool expose qos stats
Date:   Wed, 26 Apr 2023 11:17:30 +0530
Message-ID: <20230426054731.5720-8-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426054731.5720-1-hkelam@marvell.com>
References: <20230426054731.5720-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IKdLB-auGAQsHkzlqMZUUHz6_98-KSp0
X-Proofpoint-GUID: IKdLB-auGAQsHkzlqMZUUHz6_98-KSp0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends ethtool stats support for QoS send queues as well.
upon the number of transmit channels change request, Ensures the real
number of transmit queues are equal to active QoS send queues plus
configured transmit queues.

    ethtool -S eth0
    txq_qos0: bytes: 3021391800
    txq_qos0: frames: 1998275
    txq_qos1: bytes: 4619766312
    txq_qos1: frames: 3055401
    ...
    ...

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 29 +++++++++++++------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0f8d1a69139f..c47d91da32dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -92,10 +92,16 @@ static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
 			*data += ETH_GSTRING_LEN;
 		}
 	}
-	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+
+	for (qidx = 0; qidx < otx2_get_total_tx_queues(pfvf); qidx++) {
 		for (stats = 0; stats < otx2_n_queue_stats; stats++) {
-			sprintf(*data, "txq%d: %s", qidx + start_qidx,
-				otx2_queue_stats[stats].name);
+			if (qidx >= pfvf->hw.non_qos_queues)
+				sprintf(*data, "txq_qos%d: %s",
+					qidx + start_qidx - pfvf->hw.non_qos_queues,
+					otx2_queue_stats[stats].name);
+			else
+				sprintf(*data, "txq%d: %s", qidx + start_qidx,
+					otx2_queue_stats[stats].name);
 			*data += ETH_GSTRING_LEN;
 		}
 	}
@@ -159,7 +165,7 @@ static void otx2_get_qset_stats(struct otx2_nic *pfvf,
 				[otx2_queue_stats[stat].index];
 	}
 
-	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+	for (qidx = 0; qidx < otx2_get_total_tx_queues(pfvf); qidx++) {
 		if (!otx2_update_sq_stats(pfvf, qidx)) {
 			for (stat = 0; stat < otx2_n_queue_stats; stat++)
 				*((*data)++) = 0;
@@ -254,7 +260,7 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 		return -EINVAL;
 
 	qstats_count = otx2_n_queue_stats *
-		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
+		       (pfvf->hw.rx_queues + otx2_get_total_tx_queues(pfvf));
 	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag))
 		mac_stats = CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT;
 	otx2_update_lmac_fec_stats(pfvf);
@@ -282,7 +288,7 @@ static int otx2_set_channels(struct net_device *dev,
 {
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	bool if_up = netif_running(dev);
-	int err = 0;
+	int err, qos_txqs;
 
 	if (!channel->rx_count || !channel->tx_count)
 		return -EINVAL;
@@ -296,14 +302,19 @@ static int otx2_set_channels(struct net_device *dev,
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
 
 	pfvf->hw.rx_queues = channel->rx_count;
 	pfvf->hw.tx_queues = channel->tx_count;
-	pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
+	if (pfvf->xdp_prog)
+		pfvf->hw.xdp_queues = channel->rx_count;
+	pfvf->hw.non_qos_queues =  pfvf->hw.tx_queues + pfvf->hw.xdp_queues;
 
 	if (if_up)
 		err = dev->netdev_ops->ndo_open(dev);
@@ -1405,7 +1416,7 @@ static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
 		return -EINVAL;
 
 	qstats_count = otx2_n_queue_stats *
-		       (vf->hw.rx_queues + vf->hw.tx_queues);
+		       (vf->hw.rx_queues + otx2_get_total_tx_queues(vf));
 
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
 }
-- 
2.17.1

