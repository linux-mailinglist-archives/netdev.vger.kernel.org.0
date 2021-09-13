Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774234085A5
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 09:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbhIMHv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 03:51:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237782AbhIMHv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 03:51:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18D1JGwO015906;
        Mon, 13 Sep 2021 00:50:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=wRUxxwWk01TQUMSzVN81lvVtywo773SmMRIWq6LO3Yo=;
 b=dOw51FVmIhAom2GA/eWbQAnJDZhSSGAl5wzhUqSSNb5xSjZ7OWURFc5qZgK8obuAI0pG
 TIOPwKg/UAyeVB/T5ShmGSJI5C/rKSi9OrAg8G8jUImtN7LBYsKon5ebqgCHu9Nt+Dq0
 T0hchE1kIaw01CpYhKhRRd+lyLGtorg4Kuvx4gfzfRnL9HhoyO8pzEtjBdJpLKDXQtzs
 YAshxlrEgQpTuzSd+/lwYS6RXSdmdVcl+vONVLBwfcRjaebb1r3/SSIHh0fdgxWErntO
 9a0lfUZvEh70a6nQCwFdVZHHwFYgntLm7yRhSjN4H2EbLwBPe0z8unyJXseWHfXC2Rxg xQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b1vvkgwa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 00:50:36 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 00:50:35 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Mon, 13 Sep 2021 00:50:33 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <naresh.kamboju@linaro.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH net-next] qed: Improve the stack space of filter_config()
Date:   Mon, 13 Sep 2021 10:50:24 +0300
Message-ID: <20210913075024.17571-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Fygj76D-04scFH7tN6yvDydJUORPMOS7
X-Proofpoint-ORIG-GUID: Fygj76D-04scFH7tN6yvDydJUORPMOS7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_03,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it was reported and discussed in: https://lore.kernel.org/lkml/CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com/
This patch improves the stack space of qede_config_rx_mode() by
splitting filter_config() to 3 functions and removing the
union qed_filter_type_params.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c      | 23 ++-------
 .../net/ethernet/qlogic/qede/qede_filter.c    | 47 ++++++++-----------
 include/linux/qed/qed_eth_if.h                | 21 ++++-----
 3 files changed, 30 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index dfaf10edfabf..ba8c7a31cce1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2763,25 +2763,6 @@ static int qed_configure_filter_mcast(struct qed_dev *cdev,
 	return qed_filter_mcast_cmd(cdev, &mcast, QED_SPQ_MODE_CB, NULL);
 }
 
-static int qed_configure_filter(struct qed_dev *cdev,
-				struct qed_filter_params *params)
-{
-	enum qed_filter_rx_mode_type accept_flags;
-
-	switch (params->type) {
-	case QED_FILTER_TYPE_UCAST:
-		return qed_configure_filter_ucast(cdev, &params->filter.ucast);
-	case QED_FILTER_TYPE_MCAST:
-		return qed_configure_filter_mcast(cdev, &params->filter.mcast);
-	case QED_FILTER_TYPE_RX_MODE:
-		accept_flags = params->filter.accept_flags;
-		return qed_configure_filter_rx_mode(cdev, accept_flags);
-	default:
-		DP_NOTICE(cdev, "Unknown filter type %d\n", (int)params->type);
-		return -EINVAL;
-	}
-}
-
 static int qed_configure_arfs_searcher(struct qed_dev *cdev,
 				       enum qed_filter_config_mode mode)
 {
@@ -2904,7 +2885,9 @@ static const struct qed_eth_ops qed_eth_ops_pass = {
 	.q_rx_stop = &qed_stop_rxq,
 	.q_tx_start = &qed_start_txq,
 	.q_tx_stop = &qed_stop_txq,
-	.filter_config = &qed_configure_filter,
+	.filter_config_rx_mode = &qed_configure_filter_rx_mode,
+	.filter_config_ucast = &qed_configure_filter_ucast,
+	.filter_config_mcast = &qed_configure_filter_mcast,
 	.fastpath_stop = &qed_fastpath_stop,
 	.eth_cqe_completion = &qed_fp_cqe_completion,
 	.get_vport_stats = &qed_get_vport_stats,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index a2e4dfb5cb44..f99b085b56a5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -619,30 +619,28 @@ static int qede_set_ucast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char mac[ETH_ALEN])
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.mac_valid = 1;
-	ether_addr_copy(filter_cmd.filter.ucast.mac, mac);
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.mac_valid = 1;
+	ether_addr_copy(ucast.mac, mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_set_ucast_rx_vlan(struct qede_dev *edev,
 				  enum qed_filter_xcast_params_type opcode,
 				  u16 vid)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.vlan_valid = 1;
-	filter_cmd.filter.ucast.vlan = vid;
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.vlan_valid = 1;
+	ucast.vlan = vid;
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_config_accept_any_vlan(struct qede_dev *edev, bool action)
@@ -1057,18 +1055,17 @@ static int qede_set_mcast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char *mac, int num_macs)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_mcast_params mcast;
 	int i;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_MCAST;
-	filter_cmd.filter.mcast.type = opcode;
-	filter_cmd.filter.mcast.num = num_macs;
+	memset(&mcast, 0, sizeof(mcast));
+	mcast.type = opcode;
+	mcast.num = num_macs;
 
 	for (i = 0; i < num_macs; i++, mac += ETH_ALEN)
-		ether_addr_copy(filter_cmd.filter.mcast.mac[i], mac);
+		ether_addr_copy(mcast.mac[i], mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_mcast(edev->cdev, &mcast);
 }
 
 int qede_set_mac_addr(struct net_device *ndev, void *p)
@@ -1194,7 +1191,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 {
 	enum qed_filter_rx_mode_type accept_flags;
 	struct qede_dev *edev = netdev_priv(ndev);
-	struct qed_filter_params rx_mode;
 	unsigned char *uc_macs, *temp;
 	struct netdev_hw_addr *ha;
 	int rc, uc_count;
@@ -1220,10 +1216,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 
 	netif_addr_unlock_bh(ndev);
 
-	/* Configure the struct for the Rx mode */
-	memset(&rx_mode, 0, sizeof(struct qed_filter_params));
-	rx_mode.type = QED_FILTER_TYPE_RX_MODE;
-
 	/* Remove all previous unicast secondary macs and multicast macs
 	 * (configure / leave the primary mac)
 	 */
@@ -1271,8 +1263,7 @@ void qede_config_rx_mode(struct net_device *ndev)
 		qede_config_accept_any_vlan(edev, false);
 	}
 
-	rx_mode.filter.accept_flags = accept_flags;
-	edev->ops->filter_config(edev->cdev, &rx_mode);
+	edev->ops->filter_config_rx_mode(edev->cdev, accept_flags);
 out:
 	kfree(uc_macs);
 }
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index 812a4d751163..4df0bf0a0864 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -145,12 +145,6 @@ struct qed_filter_mcast_params {
 	unsigned char mac[64][ETH_ALEN];
 };
 
-union qed_filter_type_params {
-	enum qed_filter_rx_mode_type accept_flags;
-	struct qed_filter_ucast_params ucast;
-	struct qed_filter_mcast_params mcast;
-};
-
 enum qed_filter_type {
 	QED_FILTER_TYPE_UCAST,
 	QED_FILTER_TYPE_MCAST,
@@ -158,11 +152,6 @@ enum qed_filter_type {
 	QED_MAX_FILTER_TYPES,
 };
 
-struct qed_filter_params {
-	enum qed_filter_type type;
-	union qed_filter_type_params filter;
-};
-
 struct qed_tunn_params {
 	u16 vxlan_port;
 	u8 update_vxlan_port;
@@ -314,8 +303,14 @@ struct qed_eth_ops {
 
 	int (*q_tx_stop)(struct qed_dev *cdev, u8 rss_id, void *handle);
 
-	int (*filter_config)(struct qed_dev *cdev,
-			     struct qed_filter_params *params);
+	int (*filter_config_rx_mode)(struct qed_dev *cdev,
+				     enum qed_filter_rx_mode_type type);
+
+	int (*filter_config_ucast)(struct qed_dev *cdev,
+				   struct qed_filter_ucast_params *params);
+
+	int (*filter_config_mcast)(struct qed_dev *cdev,
+				   struct qed_filter_mcast_params *params);
 
 	int (*fastpath_stop)(struct qed_dev *cdev);
 
-- 
2.22.0

