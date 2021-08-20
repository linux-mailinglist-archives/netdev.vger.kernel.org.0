Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02593F2839
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhHTIS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:18:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20036 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231419AbhHTIS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:18:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17K5u3RB024648;
        Fri, 20 Aug 2021 01:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=izCjavDkVBkbw9F831Bf3Da14+hauAOzbNAzU83zKrA=;
 b=YVI1ocbx82vkO+umXma5PmBHUGnVCkOWQr7jUUXsO5pnWepLmLREvChrsEk0U7Z53LGl
 0l9zZotM/RPMM0tXuanFKwP3Jt+a/cQ2Kgg34plc4y9hfsm5b/HKxp0Wq098DzF6+T90
 9hKpu9RLiirGJjPWNDM/hOJS6QjFFM7jshA/RSK5F6floD4uONmk6hMvplyXZx91I7IH
 RdOvpsgizkbSvhW+6Wev2YcriyMrMvRyeIOnZy7PIBVtMiaMFBbXxpMNSd0iXFlsgGmS
 YH33DJqOcFKMhHV8UyX+y01nfyX3pcbJCb0M8BgRV4nVxuDiSajatL01fTZOXVITwBk/ +w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ahu702uqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 01:17:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 20 Aug
 2021 01:17:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 20 Aug 2021 01:17:47 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id C18683F7065;
        Fri, 20 Aug 2021 01:17:45 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH] octeontx2-pf: Add check for non zero mcam flows
Date:   Fri, 20 Aug 2021 13:47:39 +0530
Message-ID: <1629447459-3898-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: KWko4-0nGVN1AO_nIWDxSMopwyuiRFP9
X-Proofpoint-ORIG-GUID: KWko4-0nGVN1AO_nIWDxSMopwyuiRFP9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_02,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch ensures that mcam flows are allocated
before adding or destroying the flows.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c |  9 +++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 2a25588..55802b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -972,6 +972,12 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	int err = 0;
 	u32 ring;
 
+	if (!flow_cfg->max_flows) {
+		netdev_err(pfvf->netdev,
+			   "Ntuple rule count is 0, allocate and retry\n");
+		return -EINVAL;
+	}
+
 	ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
 	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
 		return -ENOMEM;
@@ -1183,6 +1189,9 @@ int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
 	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
 		return 0;
 
+	if (!flow_cfg->max_flows)
+		return 0;
+
 	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_npc_delete_flow(&pfvf->mbox);
 	if (!req) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 7dd56c9..6fe6b8d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1860,6 +1860,22 @@ static int otx2_set_features(struct net_device *netdev,
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
+	if ((changed & NETIF_F_NTUPLE) && ntuple) {
+		if (!pf->flow_cfg->max_flows) {
+			netdev_err(netdev,
+				   "Can't enable NTUPLE, MCAM entries not allocated\n");
+			return -EINVAL;
+		}
+	}
+
+	if ((changed & NETIF_F_HW_TC) && tc) {
+		if (!pf->flow_cfg->max_flows) {
+			netdev_err(netdev,
+				   "Can't enable TC, MCAM entries not allocated\n");
+			return -EINVAL;
+		}
+	}
+
 	if ((changed & NETIF_F_HW_TC) && !tc &&
 	    pf->flow_cfg && pf->flow_cfg->nr_flows) {
 		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
-- 
2.7.4

