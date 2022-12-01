Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CD963F70E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiLASCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiLASBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:01:17 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35AB5D9F;
        Thu,  1 Dec 2022 10:01:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1DtgiH024643;
        Thu, 1 Dec 2022 10:00:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Rh0uSF8TsggV3/DnlXbmQAucA+aHg5lIDmniZ0MoirU=;
 b=gXYSDqF2CCJUX83EqGgoGa5onvVydy49NplxI4zPjWV2FNbo/KQijE+oVegRfKBS6VyU
 gLE5fyruf8wFrc1OhArgw+qXuW1Xu2X8FfuAojX296IvOj1OkiRjd8IheH7imw+l4+4i
 iqckigL3v8WU6QRApxlryyqubsQ3MQO/dP4fFmZrimuV0o/8LvVfz6uyqTKBR8+3AgYp
 aa3x/eZEWqCvqCdsvgH5T+pCiFtU+5+g6NlV9HvhePNOdN6oUNUe33Br7/2H3Z+jnOEb
 5wI38ZDQhfyPCC74oEOc6igcnBpG6gtBfuEsjfyrnvWstKLs6X9eaHO8OKCMP5R28Jgw ng== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k8k2xms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 10:00:57 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Dec
 2022 10:00:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Dec 2022 10:00:55 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B686E5B6921;
        Thu,  1 Dec 2022 10:00:52 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH v3 3/4] octeontx2-pf: ethtool: Implement get_fec_stats
Date:   Thu, 1 Dec 2022 23:30:39 +0530
Message-ID: <20221201180040.14147-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201180040.14147-1-hkelam@marvell.com>
References: <20221201180040.14147-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 3QMJ-HFO5DXDwQJfzr-loui81ewIto1l
X-Proofpoint-ORIG-GUID: 3QMJ-HFO5DXDwQJfzr-loui81ewIto1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_12,2022-12-01_01,2022-06-22_01
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

 .../marvell/octeontx2/nic/otx2_ethtool.c      | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0eb74e8c553d..85f46e15ac03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1268,6 +1268,45 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
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
@@ -1298,6 +1337,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_ts_info		= otx2_get_ts_info,
+	.get_fec_stats		= otx2_get_fec_stats,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
--
2.17.1
