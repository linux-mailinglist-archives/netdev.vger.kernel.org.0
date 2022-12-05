Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55488642358
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiLEHGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiLEHF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:05:56 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8680612773;
        Sun,  4 Dec 2022 23:05:46 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B4NglHr004633;
        Sun, 4 Dec 2022 23:05:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=o178hs8EWCD0IbOg9ahb5PN61oe8D6hlFxhmtoqx+qk=;
 b=M1BLrjk5VWLAgD1Y/Bj8EOY36OHw35UKrlTlQfT5vbudCne34TzYk54s4iGjQAJyn/dF
 wCI9ShtJLV7P+uSBCpIWtcGK318/44DXK90kaQs8HAxxNs5tPa1gmUOtUoYG1ms8mp+V
 hm1U2WqjVZDqKr9C+8di8kF1m4k+I9Q6s3FaVQCE8+cgl9P9nWd91xa9DFlXxjFNRaif
 XDY1/VDVVtATZ+EjWexo80DNDK1DhqKGeWhOi7up1TnrA4rZwOst50xPnwz4/XEE2RbI
 u1xQWI80AM1tG49v1UxnUv8hFG4KZQ1eTrAijWTovsK4qrxvpfABLCK9toTQ1gi6TFd/ Ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m84pumnwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Dec 2022 23:05:38 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Dec
 2022 23:05:36 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 4 Dec 2022 23:05:36 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6A4B73F709C;
        Sun,  4 Dec 2022 23:05:33 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next Patch v4 3/4] octeontx2-pf: ethtool: Implement get_fec_stats
Date:   Mon, 5 Dec 2022 12:35:20 +0530
Message-ID: <20221205070521.21860-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221205070521.21860-1-hkelam@marvell.com>
References: <20221205070521.21860-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Bmg5bieOkwz3cBr2VPBGdCJMhQGy9qAF
X-Proofpoint-GUID: Bmg5bieOkwz3cBr2VPBGdCJMhQGy9qAF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch registers a callback for get_fec_stats such that
FEC stats can be queried from the below command

"ethtool -I --show-fec eth0"

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v3 * Dont remove existing FEC stats support over
     ethtool statistics (ethtool -S)
v4 * Update MAC fec stats first instead of updating
     them on otx2_get_fwdata failure.

 .../marvell/octeontx2/nic/otx2_ethtool.c      | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0eb74e8c553d..0f8d1a69139f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1268,6 +1268,39 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
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
+	/* Report MAC FEC stats */
+	fec_stats->corrected_blocks.total     = pfvf->hw.cgx_fec_corr_blks;
+	fec_stats->uncorrectable_blocks.total = pfvf->hw.cgx_fec_uncorr_blks;
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
+				fec_stats->corrected_blocks.total = p->brfec_corr_blks;
+				fec_stats->uncorrectable_blocks.total = p->brfec_uncorr_blks;
+			} else {
+				fec_stats->corrected_blocks.total = p->rsfec_corr_cws;
+				fec_stats->uncorrectable_blocks.total = p->rsfec_uncorr_cws;
+			}
+		}
+	}
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1298,6 +1331,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_ts_info		= otx2_get_ts_info,
+	.get_fec_stats		= otx2_get_fec_stats,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
--
2.17.1
