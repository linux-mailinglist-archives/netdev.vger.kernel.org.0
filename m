Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9FD63B957
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiK2FOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiK2FOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:14:35 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87FB4F1B6;
        Mon, 28 Nov 2022 21:14:34 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASNXEwV020462;
        Mon, 28 Nov 2022 21:14:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6cMv2gb/XejobRwpmGnNvEmAgEUA/gQhA0f+TzNRL8s=;
 b=OzlB+wdAwLV7jAGJdEDEWh8lwaUN0q6Rq+ACH38l6RtpMRzfyfuM4TvxLGNE2MmH3TPS
 RSTfUZ7uf7mmgEcmaQwB8oSLXD7y6O7o20jV/LS+HZQvyHrcbL4/PkMEB/d12bV4sefm
 9l69Brspyb3WPW7cIdwi6rTK0xzcHpYaFJDcKqe8Chu8w4TkhP3q9UTwh/E2nN2iCS0B
 /tJ+TEyqUGvVE62qBSeR73IJ9waebFVCuqACwRs1TDUl3uFtsH6mYI2EoJYnB4glTHeh
 f5s4HU3OTl8+tmDwwx/f4hK0/emygkgGsoQTW89VaAEH7mtHnSybAUVxBOWk3TByJK8U uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6w9qx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 21:14:28 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Nov
 2022 21:14:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Nov 2022 21:14:25 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 2B0603F7088;
        Mon, 28 Nov 2022 21:14:21 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH V2 3/4] octeontx2-pf: ethtool: Implement get_fec_stats
Date:   Tue, 29 Nov 2022 10:44:08 +0530
Message-ID: <20221129051409.20034-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221129051409.20034-1-hkelam@marvell.com>
References: <20221129051409.20034-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: jmu04xIAB9bIkzDnuTLCG5kfJUZXc_il
X-Proofpoint-ORIG-GUID: jmu04xIAB9bIkzDnuTLCG5kfJUZXc_il
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_04,2022-11-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation is such that FEC statistics are reported as
part of ethtool statistics that is the user can fetch them from the
below command

"ethtool -S eth0"

Fec Corrected Errors:
Fec Uncorrected Errors:

This patch removes this logic and registers a callback for get_fec_stats
such that FEC stats can be queried from the below command
"ethtool -I --show-fec eth0"

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 75 ++++++++++---------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0eb74e8c553d..0dd7bce2b866 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -135,10 +135,6 @@ static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 
 	strcpy(data, "reset_count");
 	data += ETH_GSTRING_LEN;
-	sprintf(data, "Fec Corrected Errors: ");
-	data += ETH_GSTRING_LEN;
-	sprintf(data, "Fec Uncorrected Errors: ");
-	data += ETH_GSTRING_LEN;
 }
 
 static void otx2_get_qset_stats(struct otx2_nic *pfvf,
@@ -193,8 +189,6 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 				   struct ethtool_stats *stats, u64 *data)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	u64 fec_corr_blks, fec_uncorr_blks;
-	struct cgx_fw_data *rsp;
 	int stat;
 
 	otx2_get_dev_stats(pfvf);
@@ -217,32 +211,6 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 	}
 
 	*(data++) = pfvf->reset_count;
-
-	fec_corr_blks = pfvf->hw.cgx_fec_corr_blks;
-	fec_uncorr_blks = pfvf->hw.cgx_fec_uncorr_blks;
-
-	rsp = otx2_get_fwdata(pfvf);
-	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
-	    !otx2_get_phy_fec_stats(pfvf)) {
-		/* Fetch fwdata again because it's been recently populated with
-		 * latest PHY FEC stats.
-		 */
-		rsp = otx2_get_fwdata(pfvf);
-		if (!IS_ERR(rsp)) {
-			struct fec_stats_s *p = &rsp->fwdata.phy.fec_stats;
-
-			if (pfvf->linfo.fec == OTX2_FEC_BASER) {
-				fec_corr_blks   = p->brfec_corr_blks;
-				fec_uncorr_blks = p->brfec_uncorr_blks;
-			} else {
-				fec_corr_blks   = p->rsfec_corr_cws;
-				fec_uncorr_blks = p->rsfec_uncorr_cws;
-			}
-		}
-	}
-
-	*(data++) = fec_corr_blks;
-	*(data++) = fec_uncorr_blks;
 }
 
 static int otx2_get_sset_count(struct net_device *netdev, int sset)
@@ -257,10 +225,9 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
 	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag))
 		mac_stats = CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT;
-	otx2_update_lmac_fec_stats(pfvf);
 
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
-	       mac_stats + OTX2_FEC_STATS_CNT + 1;
+	       mac_stats + 1;
 }
 
 /* Get no of queues device supports and current queue count */
@@ -1268,6 +1235,45 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
+static void otx2_get_fec_stats(struct net_device *netdev,
+			       struct ethtool_fec_stats *fec_stats)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp;
+
+	otx2_update_lmac_fec_stats(pfvf);
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
+	    !otx2_get_phy_fec_stats(pfvf)) {
+		/* Fetch fwdata again because it's been recently populated with
+		 * latest PHY FEC stats.
+		 */
+		rsp = otx2_get_fwdata(pfvf);
+		if (!IS_ERR(rsp)) {
+			struct fec_stats_s *p = &rsp->fwdata.phy.fec_stats;
+
+			if (pfvf->linfo.fec == OTX2_FEC_BASER) {
+				fec_stats->corrected_blocks.total     =
+					p->brfec_corr_blks;
+				fec_stats->uncorrectable_blocks.total =
+					p->brfec_uncorr_blks;
+			} else {
+				fec_stats->corrected_blocks.total     =
+					p->rsfec_corr_cws;
+				fec_stats->uncorrectable_blocks.total =
+					p->rsfec_uncorr_cws;
+			}
+		}
+	} else {
+		/* Report MAC FEC stats */
+		fec_stats->corrected_blocks.total     =
+			pfvf->hw.cgx_fec_corr_blks;
+		fec_stats->uncorrectable_blocks.total =
+			pfvf->hw.cgx_fec_uncorr_blks;
+	}
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1298,6 +1304,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_ts_info		= otx2_get_ts_info,
+	.get_fec_stats		= otx2_get_fec_stats,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
-- 
2.17.1

