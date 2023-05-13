Return-Path: <netdev+bounces-2357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBD070168A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 14:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9E5C1C210C2
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 12:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9294A46B5;
	Sat, 13 May 2023 12:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F26E4408
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 12:07:17 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40361FEB;
	Sat, 13 May 2023 05:07:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34DBrIM2004545;
	Sat, 13 May 2023 05:06:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=syT/F4i0UTiSv1pXqwKX8DGCIcI+SGGzfmriqqhfSNY=;
 b=aAv7eM4nYmfUr+SW7dUf19XDo0ffggC//td8VRaYvKT8sQHwjxXGUg2FdKTiMd/LTFYD
 j/uuK6RA2NzSN6RvDTv68ILQQ0Qm0zBdRl/0eM60Hf5nmEyKyxBfMOFE2WXrSPS+CCql
 Hz3dlPanwyFTyu7Svi2QtN4T8waYKFEE41Z8YbveBCGZ7TpcQuNPQITnhsv3IaHXWoii
 G8/2V73j61MvdIDUqr1l+/Y+BbSBDzP+VG+Kij/RgHk8+1Ku1BHaQxXOhHg7hV4Tdb+g
 EGJ6p1MHuEp86m7ww8GaJdytQW5LvJ6xOTqn/WxkqLy0oxQSsxWfGBkG7pOz43dF7y/d LQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qja2jg0uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sat, 13 May 2023 05:06:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 13 May
 2023 05:06:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sat, 13 May 2023 05:06:55 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
	by maili.marvell.com (Postfix) with ESMTP id 470CF5B77DF;
	Sat, 13 May 2023 01:52:36 -0700 (PDT)
From: Hariprasad Kelam <hkelam@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>
Subject: [net-next Patch v10 7/8] octeontx2-pf: ethtool expose qos stats
Date: Sat, 13 May 2023 14:21:42 +0530
Message-ID: <20230513085143.3289-8-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230513085143.3289-1-hkelam@marvell.com>
References: <20230513085143.3289-1-hkelam@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8ZHC1jwgFsTukrSkPy-0AkCUzETee2Lb
X-Proofpoint-ORIG-GUID: 8ZHC1jwgFsTukrSkPy-0AkCUzETee2Lb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-13_08,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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


