Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F6C4B0CC8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 12:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241158AbiBJLwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 06:52:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241139AbiBJLwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 06:52:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A68DFEA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 03:52:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AAJp9s009567;
        Thu, 10 Feb 2022 03:51:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=FzOm0plyZbi/zPMkEVrR9Wv93AgFIcRMntpV6Ahuzg4=;
 b=EHtqF0SV6bKz1cRtwmLoeTEY/uzBCnyIKZNHS6FB4yyCiA5PbHLthkwZsjfafe00vTaR
 6noCkm44wKZkboCuOiRiBr2AOt13erL7hJeFUKNeEb2FjOufr4pMFK6gBWqQuaaJSXOv
 8eUuuZq87H/zznDop15GAUuDSKlTY59XAyHD2yonPy9gEiZsVY6UAwEraiLG+Tu+ZhXN
 yyKI9aT1T+5Gu7gXRUJcP/8ATSILD7E7zUauwigOYHknD18zxVh3dwd3JKFgxjmp3VUU
 ExBQHG0kpw6DkLidolt+Avxn4hiNCOJg2gniucMo/guY7d5Av6neFCX6dvsQyrGtBPit vQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e50uc8b6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 03:51:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 03:51:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Feb 2022 03:51:50 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 45B163F703F;
        Thu, 10 Feb 2022 03:51:47 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Add TC feature for VFs
Date:   Thu, 10 Feb 2022 17:21:44 +0530
Message-ID: <1644493904-10734-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8F2otmuYmn7D7R4BgAf67gw_Xs3xE1xc
X-Proofpoint-ORIG-GUID: 8F2otmuYmn7D7R4BgAf67gw_Xs3xE1xc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_05,2022-02-09_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds TC feature for VFs also. When MCAM
rules are allocated for a VF then either TC or ntuple
filters can be used. Below are the commands to use
TC feature for a VF(say lbk0):

devlink dev param set pci/0002:01:00.1 name mcam_count value 16 \
 cmode runtime
ethtool -K lbk0 hw-tc-offload on
ifconfig lbk0 up
tc qdisc add dev lbk0 ingress
tc filter add dev lbk0 parent ffff: protocol ip flower skip_sw \
 dst_mac 98:03:9b:83:aa:12 action police rate 100Mbit burst 5000

Also to modify any fields of the hardware context with
NIX_AQ_INSTOP_WRITE command then corresponding masks of those
fields must be set as per hardware. This was missing in
ingress ratelimiting context. This patch sets those masks also.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 50 ++++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 43 +------------------
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  5 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 30 +++++--------
 6 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 73cd39a..0fa625e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -5312,6 +5312,7 @@ int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
 	aq_req.ctype = NIX_AQ_CTYPE_BANDPROF;
 	aq_req.op = NIX_AQ_INSTOP_WRITE;
 	memcpy(&aq_req.prof, &aq_rsp.prof, sizeof(struct nix_bandprof_s));
+	memset((char *)&aq_req.prof_mask, 0xff, sizeof(struct nix_bandprof_s));
 	/* Clear higher layer enable bit in the mid profile, just in case */
 	aq_req.prof.hl_en = 0;
 	aq_req.prof_mask.hl_en = 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 358e5b2..2c97608 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1727,6 +1727,56 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 }
 EXPORT_SYMBOL(otx2_get_max_mtu);
 
+int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t features)
+{
+	netdev_features_t changed = features ^ netdev->features;
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	bool ntuple = !!(features & NETIF_F_NTUPLE);
+	bool tc = !!(features & NETIF_F_HW_TC);
+
+	if ((changed & NETIF_F_NTUPLE) && !ntuple)
+		otx2_destroy_ntuple_flows(pfvf);
+
+	if ((changed & NETIF_F_NTUPLE) && ntuple) {
+		if (!pfvf->flow_cfg->max_flows) {
+			netdev_err(netdev,
+				   "Can't enable NTUPLE, MCAM entries not allocated\n");
+			return -EINVAL;
+		}
+	}
+
+	if ((changed & NETIF_F_HW_TC) && tc) {
+		if (!pfvf->flow_cfg->max_flows) {
+			netdev_err(netdev,
+				   "Can't enable TC, MCAM entries not allocated\n");
+			return -EINVAL;
+		}
+	}
+
+	if ((changed & NETIF_F_HW_TC) && !tc &&
+	    pfvf->flow_cfg && pfvf->flow_cfg->nr_flows) {
+		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
+		return -EBUSY;
+	}
+
+	if ((changed & NETIF_F_NTUPLE) && ntuple &&
+	    (netdev->features & NETIF_F_HW_TC) && !(changed & NETIF_F_HW_TC)) {
+		netdev_err(netdev,
+			   "Can't enable NTUPLE when TC is active, disable TC and retry\n");
+		return -EINVAL;
+	}
+
+	if ((changed & NETIF_F_HW_TC) && tc &&
+	    (netdev->features & NETIF_F_NTUPLE) && !(changed & NETIF_F_NTUPLE)) {
+		netdev_err(netdev,
+			   "Can't enable TC when NTUPLE is active, disable NTUPLE and retry\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(otx2_handle_ntuple_tc_features);
+
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
 int __weak								\
 otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b6be978..7724f17 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -871,6 +871,8 @@ int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
+int otx2_handle_ntuple_tc_features(struct net_device *netdev,
+				   netdev_features_t features);
 /* tc support */
 int otx2_init_tc(struct otx2_nic *nic);
 void otx2_shutdown_tc(struct otx2_nic *nic);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ede4df5..a536916 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1863,9 +1863,7 @@ static int otx2_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	netdev_features_t changed = features ^ netdev->features;
-	bool ntuple = !!(features & NETIF_F_NTUPLE);
 	struct otx2_nic *pf = netdev_priv(netdev);
-	bool tc = !!(features & NETIF_F_HW_TC);
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
@@ -1875,46 +1873,7 @@ static int otx2_set_features(struct net_device *netdev,
 		return otx2_enable_rxvlan(pf,
 					  features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	if ((changed & NETIF_F_NTUPLE) && !ntuple)
-		otx2_destroy_ntuple_flows(pf);
-
-	if ((changed & NETIF_F_NTUPLE) && ntuple) {
-		if (!pf->flow_cfg->max_flows) {
-			netdev_err(netdev,
-				   "Can't enable NTUPLE, MCAM entries not allocated\n");
-			return -EINVAL;
-		}
-	}
-
-	if ((changed & NETIF_F_HW_TC) && tc) {
-		if (!pf->flow_cfg->max_flows) {
-			netdev_err(netdev,
-				   "Can't enable TC, MCAM entries not allocated\n");
-			return -EINVAL;
-		}
-	}
-
-	if ((changed & NETIF_F_HW_TC) && !tc &&
-	    pf->flow_cfg && pf->flow_cfg->nr_flows) {
-		netdev_err(netdev, "Can't disable TC hardware offload while flows are active\n");
-		return -EBUSY;
-	}
-
-	if ((changed & NETIF_F_NTUPLE) && ntuple &&
-	    (netdev->features & NETIF_F_HW_TC) && !(changed & NETIF_F_HW_TC)) {
-		netdev_err(netdev,
-			   "Can't enable NTUPLE when TC is active, disable TC and retry\n");
-		return -EINVAL;
-	}
-
-	if ((changed & NETIF_F_HW_TC) && tc &&
-	    (netdev->features & NETIF_F_NTUPLE) && !(changed & NETIF_F_NTUPLE)) {
-		netdev_err(netdev,
-			   "Can't enable TC when NTUPLE is active, disable NTUPLE and retry\n");
-		return -EINVAL;
-	}
-
-	return 0;
+	return otx2_handle_ntuple_tc_features(netdev, features);
 }
 
 static void otx2_reset_task(struct work_struct *work)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 626961a..0593106 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -58,7 +58,7 @@ int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 {
 	struct otx2_tc_info *tc = &nic->tc_info;
 
-	if (!nic->flow_cfg->max_flows || is_otx2_vf(nic->pcifunc))
+	if (!nic->flow_cfg->max_flows)
 		return 0;
 
 	/* Max flows changed, free the existing bitmap */
@@ -1023,6 +1023,7 @@ int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL(otx2_setup_tc);
 
 static const struct rhashtable_params tc_flow_ht_params = {
 	.head_offset = offsetof(struct otx2_tc_flow, node),
@@ -1052,6 +1053,7 @@ int otx2_init_tc(struct otx2_nic *nic)
 	tc->flow_ht_params = tc_flow_ht_params;
 	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
 }
+EXPORT_SYMBOL(otx2_init_tc);
 
 void otx2_shutdown_tc(struct otx2_nic *nic)
 {
@@ -1060,3 +1062,4 @@ void otx2_shutdown_tc(struct otx2_nic *nic)
 	kfree(tc->tc_entries_bitmap);
 	rhashtable_destroy(&tc->flow_table);
 }
+EXPORT_SYMBOL(otx2_shutdown_tc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7814249..a232e20 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -472,23 +472,7 @@ static void otx2vf_reset_task(struct work_struct *work)
 static int otx2vf_set_features(struct net_device *netdev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
-	bool ntuple_enabled = !!(features & NETIF_F_NTUPLE);
-	struct otx2_nic *vf = netdev_priv(netdev);
-
-	if (changed & NETIF_F_NTUPLE) {
-		if (!ntuple_enabled) {
-			otx2_mcam_flow_del(vf);
-			return 0;
-		}
-
-		if (!otx2_get_maxflows(vf->flow_cfg)) {
-			netdev_err(netdev,
-				   "Can't enable NTUPLE, MCAM entries not allocated\n");
-			return -EINVAL;
-		}
-	}
-	return 0;
+	return otx2_handle_ntuple_tc_features(netdev, features);
 }
 
 static const struct net_device_ops otx2vf_netdev_ops = {
@@ -502,6 +486,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
 	.ndo_eth_ioctl	= otx2_ioctl,
+	.ndo_setup_tc = otx2_setup_tc,
 };
 
 static int otx2_wq_init(struct otx2_nic *vf)
@@ -663,6 +648,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_NTUPLE;
 	netdev->hw_features |= NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_HW_TC;
 
 	netif_set_gso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
@@ -698,18 +684,24 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
-	err = otx2_register_dl(vf);
+	err = otx2_init_tc(vf);
 	if (err)
 		goto err_unreg_netdev;
 
+	err = otx2_register_dl(vf);
+	if (err)
+		goto err_shutdown_tc;
+
 #ifdef CONFIG_DCB
 	err = otx2_dcbnl_set_ops(netdev);
 	if (err)
-		goto err_unreg_netdev;
+		goto err_shutdown_tc;
 #endif
 
 	return 0;
 
+err_shutdown_tc:
+	otx2_shutdown_tc(vf);
 err_unreg_netdev:
 	unregister_netdev(netdev);
 err_ptp_destroy:
-- 
2.7.4

