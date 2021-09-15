Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4126040C957
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhIOQBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:01:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3242 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238370AbhIOQBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:01:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F9e1m0022522;
        Wed, 15 Sep 2021 08:59:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=BMWfp2gns8ANwDlYRkLVjDJreWmbfvH3yMzfZ6bupFo=;
 b=Qh68oos/ZYCakCWY28pvRbGoTwqQVOKm2DwjlEnKt6/GAa7D2tNGTjkP/f4+TE94x1BC
 lBvyYr/pSIJzf/ktuTJyIpW3du9uzQ3jA1MQYbm6IDdP82u7zkNNU9/nO8Jx33+zG97n
 p5HhAptwV4G0xkQ0gWN26dlHqIAfSk1GmijPVW73JFeHVUOkcvUncSHbtuBgKi/QxE9x
 iWfgSexyhccL933moo5EEsENzLKtm8iYR5Iez+VbJOz5bqq4Ve1ioY48oL6kaNDBB02Y
 9xD89mWU3+sHXSw89C/hs0+kse5NwOyuJYOC5hRTBjQ5dsrQ4KH8izG9qgy/DhICeom6 kQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b3ed01dg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 08:59:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Sep
 2021 08:59:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Sep 2021 08:59:50 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id CC5573F706B;
        Wed, 15 Sep 2021 08:59:47 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH v2] octeontx2-pf: CN10K: Hide RPM stats over ethtool
Date:   Wed, 15 Sep 2021 21:29:46 +0530
Message-ID: <20210915155946.23330-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: vdYUw5_N7N7ISobODU1IR70HHwYNLvsg
X-Proofpoint-ORIG-GUID: vdYUw5_N7N7ISobODU1IR70HHwYNLvsg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-15_04,2021-09-15_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10K MAC block (RPM) differs in number of stats compared to Octeontx2
MAC block (CGX). RPM supports stats for each class of PFC and error
packets etc. It would be difficult for user to read stats from ethtool
and map to their definition.

New debugfs file is already added to read RPM stats along with their
definition. This patch adds proper checks such that RPM stats will not
be part of ethtool.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
v2 - add subject prefix as net-next
     update commit msg

 .../marvell/octeontx2/nic/otx2_common.h       |  2 +
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 37 +++++++++++--------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a51ecd771d07..8e51a1db7e29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -223,6 +223,7 @@ struct otx2_hw {
 #define HW_TSO			0
 #define CN10K_MBOX		1
 #define CN10K_LMTST		2
+#define CN10K_RPM		3
 	unsigned long		cap_flag;

 #define LMT_LINE_SIZE		128
@@ -452,6 +453,7 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 	if (!is_dev_otx2(pfvf->pdev)) {
 		__set_bit(CN10K_MBOX, &hw->cap_flag);
 		__set_bit(CN10K_LMTST, &hw->cap_flag);
+		__set_bit(CN10K_RPM, &hw->cap_flag);
 	}
 }

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index dbfa3bc39e34..38e5924ca8e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -121,14 +121,16 @@ static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)

 	otx2_get_qset_strings(pfvf, &data, 0);

-	for (stats = 0; stats < CGX_RX_STATS_COUNT; stats++) {
-		sprintf(data, "cgx_rxstat%d: ", stats);
-		data += ETH_GSTRING_LEN;
-	}
+	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag)) {
+		for (stats = 0; stats < CGX_RX_STATS_COUNT; stats++) {
+			sprintf(data, "cgx_rxstat%d: ", stats);
+			data += ETH_GSTRING_LEN;
+		}

-	for (stats = 0; stats < CGX_TX_STATS_COUNT; stats++) {
-		sprintf(data, "cgx_txstat%d: ", stats);
-		data += ETH_GSTRING_LEN;
+		for (stats = 0; stats < CGX_TX_STATS_COUNT; stats++) {
+			sprintf(data, "cgx_txstat%d: ", stats);
+			data += ETH_GSTRING_LEN;
+		}
 	}

 	strcpy(data, "reset_count");
@@ -205,11 +207,15 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 						[otx2_drv_stats[stat].index]);

 	otx2_get_qset_stats(pfvf, stats, &data);
-	otx2_update_lmac_stats(pfvf);
-	for (stat = 0; stat < CGX_RX_STATS_COUNT; stat++)
-		*(data++) = pfvf->hw.cgx_rx_stats[stat];
-	for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
-		*(data++) = pfvf->hw.cgx_tx_stats[stat];
+
+	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag)) {
+		otx2_update_lmac_stats(pfvf);
+		for (stat = 0; stat < CGX_RX_STATS_COUNT; stat++)
+			*(data++) = pfvf->hw.cgx_rx_stats[stat];
+		for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
+			*(data++) = pfvf->hw.cgx_tx_stats[stat];
+	}
+
 	*(data++) = pfvf->reset_count;

 	fec_corr_blks = pfvf->hw.cgx_fec_corr_blks;
@@ -242,18 +248,19 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 static int otx2_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	int qstats_count;
+	int qstats_count, mac_stats = 0;

 	if (sset != ETH_SS_STATS)
 		return -EINVAL;

 	qstats_count = otx2_n_queue_stats *
 		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
+	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag))
+		mac_stats = CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT;
 	otx2_update_lmac_fec_stats(pfvf);

 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
-	       CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + OTX2_FEC_STATS_CNT
-	       + 1;
+	       mac_stats + OTX2_FEC_STATS_CNT + 1;
 }

 /* Get no of queues device supports and current queue count */
--
2.17.1
