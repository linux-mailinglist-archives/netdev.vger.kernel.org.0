Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6793A128E00
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 14:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfLVNKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 08:10:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48928 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbfLVNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 08:10:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBMD07X3019958;
        Sun, 22 Dec 2019 05:10:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=yN0ZAeOuu1Xt4tClGthJl673x8/K2l39GZodWm88NBI=;
 b=IooU4YBn9Kp00olVSTgTNjGxUnZgNP43ZHrcWGB8A0U+iiCkdZYiyIq2/rFka4MrShY2
 XvHXUQ1XiFMtSGz/hXyJeMIrOLBMbcVtGsBtcm8loygdQgkxApVqBqublNitlNxmdwEh
 kNFsU4Dt9AIvhwM6xZ5tNq8apQmjmF1gH13QtYDUQccpUPwq3bRx8/QUCC3AElQz7qR0
 lFC7I2WwKUWU3Xsw6aT+55Y6sZapBWUJOn45I4S+JzFFsUmMXrARQuAMrBavlRFv4FQA
 bH75U6WCLuZws9ANuykpMtv+3H2uQy1MSoJ3cp5diWSQaXlhy4VXk/49wL04y5mtcSMt UQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2x1kssa69n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Dec 2019 05:10:03 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Dec
 2019 05:10:00 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Dec 2019 05:10:00 -0800
Received: from lb-tlvb-denis.il.qlogic.org (unknown [10.5.220.219])
        by maili.marvell.com (Postfix) with ESMTP id BF8DA3F703F;
        Sun, 22 Dec 2019 05:09:59 -0800 (PST)
From:   Denis Bolotin <dbolotin@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Denis Bolotin <dbolotin@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH net-next] qede: Implement ndo_tx_timeout
Date:   Sun, 22 Dec 2019 16:07:22 +0200
Message-ID: <20191222140722.32304-1-dbolotin@marvell.com>
X-Mailer: git-send-email 2.14.3
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-22_01:2019-12-17,2019-12-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable carrier and print TX queue info on TX timeout.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 -
 drivers/net/ethernet/qlogic/qede/qede_main.c | 32 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index c303a92..6837225 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -519,7 +519,6 @@ u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 netdev_features_t qede_features_check(struct sk_buff *skb,
 				      struct net_device *dev,
 				      netdev_features_t features);
-void qede_tx_log_print(struct qede_dev *edev, struct qede_fastpath *fp);
 int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy);
 int qede_free_tx_pkt(struct qede_dev *edev,
 		     struct qede_tx_queue *txq, int *len);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 481b096..b519688 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -527,6 +527,37 @@ static int qede_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return 0;
 }
 
+static void qede_tx_log_print(struct qede_dev *edev, struct qede_tx_queue *txq)
+{
+	DP_NOTICE(edev,
+		  "Txq[%d]: FW cons [host] %04x, SW cons %04x, SW prod %04x [Jiffies %lu]\n",
+		  txq->index, le16_to_cpu(*txq->hw_cons_ptr),
+		  qed_chain_get_cons_idx(&txq->tx_pbl),
+		  qed_chain_get_prod_idx(&txq->tx_pbl),
+		  jiffies);
+}
+
+static void qede_tx_timeout(struct net_device *dev, unsigned int txqueue)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	struct qede_tx_queue *txq;
+	int cos;
+
+	netif_carrier_off(dev);
+	DP_NOTICE(edev, "TX timeout on queue %u!\n", txqueue);
+
+	if (!(edev->fp_array[txqueue].type & QEDE_FASTPATH_TX))
+		return;
+
+	for_each_cos_in_txq(edev, cos) {
+		txq = &edev->fp_array[txqueue].txq[cos];
+
+		if (qed_chain_get_cons_idx(&txq->tx_pbl) !=
+		    qed_chain_get_prod_idx(&txq->tx_pbl))
+			qede_tx_log_print(edev, txq);
+	}
+}
+
 static int qede_setup_tc(struct net_device *ndev, u8 num_tc)
 {
 	struct qede_dev *edev = netdev_priv(ndev);
@@ -614,6 +645,7 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_change_mtu = qede_change_mtu,
 	.ndo_do_ioctl = qede_ioctl,
+	.ndo_tx_timeout = qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
 	.ndo_set_vf_mac = qede_set_vf_mac,
 	.ndo_set_vf_vlan = qede_set_vf_vlan,
-- 
1.8.3.1

