Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BD03A9B0C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhFPMxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:53:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17080 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233065AbhFPMxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:53:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCkGCA009765;
        Wed, 16 Jun 2021 05:51:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ht6NUbClPoYToQ+eOLOkoGv/Ugfew8ZjdTNfLSNODP4=;
 b=gTxV9sdmhD8+kDOxHPpKmmfL1p7RfnmcGbHqV/W6lUmuh461FWt/PfW/hbenZLP7htU6
 JL4qJX95mFss4Md/LL2RAp04XPbImdXQGIwallN8uWydRDj/ecal9EWmJRu/jgoIRPcD
 X/+gmBLQyn1kxq7KCfFiTfFHvOqzWPJPDI0x45XkZk7UZpS83TrKhP80eMBmcj9iXoh5
 iE7oLphMW/fQkY90pvhwjJ6UjZ/XtyxRkcU03VNu8Xr8RnPtIFbvxjDy/ds8EdzbyVDH
 ex8wj+TuPXmVhnKhuBhkMn6vMnHOSyBEr/bTY0SRXPEmCjoNxFTRV5wQh5q8JwmPlHnu BA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 397auvhkkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 05:51:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 05:51:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 05:51:32 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id C09803F704B;
        Wed, 16 Jun 2021 05:51:30 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 2/2] octeontx2-pf: Support setting ntuple rule count
Date:   Wed, 16 Jun 2021 18:21:22 +0530
Message-ID: <1623847882-16744-3-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
References: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ezARarr-4vhRHwopheetFMlDKk0cFPdZ
X-Proofpoint-GUID: ezARarr-4vhRHwopheetFMlDKk0cFPdZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added support for changing ethtool ntuple filter count.
Rule count change is supported only when there are no
ntuple filters installed.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  3 +++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 27 ++++++++++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 234b330..5420aca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -820,6 +820,7 @@ int otx2_get_all_flows(struct otx2_nic *pfvf,
 int otx2_add_flow(struct otx2_nic *pfvf,
 		  struct ethtool_rxnfc *nfc);
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
+int otx2_set_flow_rule_count(struct otx2_nic *pfvf, int count);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
 void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 8df748e..753a8cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -690,6 +690,9 @@ static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 		if (netif_running(dev) && ntuple)
 			ret = otx2_remove_flow(pfvf, nfc->fs.location);
 		break;
+	case ETHTOOL_SRXCLSRLCNT:
+		ret = otx2_set_flow_rule_count(pfvf, nfc->rule_cnt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 8c97106..61530c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -117,12 +117,29 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 	if (allocated != count)
 		netdev_info(pfvf->netdev,
-			    "Unable to allocate %d MCAM entries for ntuple, got %d\n",
-			    count, allocated);
+			    "Unable to allocate %d MCAM entries above default rules "
+			    "start index %d, got only %d\n",
+			    count, flow_cfg->def_ent[0], allocated);
 
 	return allocated;
 }
 
+int otx2_set_flow_rule_count(struct otx2_nic *pfvf, int count)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+
+	if (!flow_cfg)
+		return 0;
+
+	if (flow_cfg->nr_flows) {
+		netdev_err(pfvf->netdev,
+			   "Cannot change count when there are active rules\n");
+		return 0;
+	}
+
+	return otx2_alloc_ntuple_mcam_entries(pfvf, count);
+}
+
 int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
@@ -827,6 +844,12 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	u32 ring;
 	int err;
 
+	if (!flow_cfg->ntuple_max_flows) {
+		netdev_err(pfvf->netdev,
+			   "Ntuple rule count is 0, allocate and retry\n");
+		return -EINVAL;
+	}
+
 	ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
 	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
 		return -ENOMEM;
-- 
2.7.4

