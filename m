Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097EB3D4033
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhGWRgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:36:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40566 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229455AbhGWRga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:36:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NIAuO5009424;
        Fri, 23 Jul 2021 11:17:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ZEfZDZ4DcpI02CvcRF53MrrzPSf8Mf+Au9d8KXvdwsA=;
 b=XvHXRe21aQYa6fa6mnLyEDjKaj5kxgLvGPvyuAQnC408kgfzw+mkta3Q+Wfj5TtArrdk
 ZJmDJ3JDezsYukadW5QGNg4hWloQdqJl+rlk+kuCR2vKBfbRY6wRogkUJ8nBfXhLTOsX
 fk+XMXqB8qIgTL13s2q4kW1fFwF7PFdO9HUlN9gyIrj1eBJbS+olZOxzHK0LayQe7qam
 wG3ukZ41elmybUmgIbikSxwyIS5MNwMHdMwbQ6ZytSaMtnwaUUqcC5c3ZB7o/x/39MwA
 vM+KVUKf5G33crGS1qLz+/+NyfFH/fbWpdqinidaYHUXF6G8PUYrj2mi9M1rGD1DzeIE mw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39ys15j6ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 11:17:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 23 Jul
 2021 11:17:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 23 Jul 2021 11:17:01 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id AAEFC3F7061;
        Fri, 23 Jul 2021 11:16:59 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 2/2] octeontx2-pf: Support setting ntuple rule count
Date:   Fri, 23 Jul 2021 23:46:46 +0530
Message-ID: <1627064206-16032-3-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
References: <1627064206-16032-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OmPjVglyKMVXvln6Bt6Omg9RrlRYFxqe
X-Proofpoint-GUID: OmPjVglyKMVXvln6Bt6Omg9RrlRYFxqe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 8fd58cd..6fe2bf7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -825,6 +825,7 @@ int otx2_get_all_flows(struct otx2_nic *pfvf,
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
index 4d9de52..ea2626c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -123,12 +123,29 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 	if (allocated != count)
 		netdev_info(pfvf->netdev,
-			    "Unable to allocate %d MCAM entries for ntuple, got %d\n",
-			    count, allocated);
+			    "Unable to allocate %d MCAM entries above default rules' "
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
@@ -923,6 +940,12 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	int err = 0;
 	u32 ring;
 
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

