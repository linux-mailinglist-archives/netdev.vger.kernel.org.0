Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB591D2BFD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgENJ6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61242 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgENJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9v2eP029382;
        Thu, 14 May 2020 02:58:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=M07JSDDaXuMfaVMWuHRRgZJf+f3xQpFFwHwCx1upP8Q=;
 b=wKa6djPnIuuwX3YFMVtsIuFS+VleArZe0tEGtIMyZXEdSTMD/gONzn44FwbUj4UpdOcZ
 h40h1+L0SSj6GMS5iSEOhBopZIdNGOx4ayR179ZKssGWyskdsG1H/5diXQG6OiP79vvF
 cEAIJqGPVU5t2BZmLdmY8uO5J4aOHVDRrF9+AxoNwbxGGoNp3egRpp+iU28Bk/QpM65c
 fA3I2CrzOS9o08WasVBTMZ1c1lF30Cxqv8CgF6R4HQFl3wJ2wOYVrzv7M3GKUcQxnw9a
 gS4j66AnpS6FKWzBMtvs16Ell4aYKwa0ZkhCubFV/6u+mhydD0WNi4S1mfDzIWQF09Kr tQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1qwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:58:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:58:17 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 963293F7043;
        Thu, 14 May 2020 02:58:14 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 08/11] net: qede: Implement ndo_tx_timeout
Date:   Thu, 14 May 2020 12:57:24 +0300
Message-ID: <20200514095727.1361-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Bolotin <dbolotin@marvell.com>

Upon tx timeout detection we do disable carrier and print TX queue
info on TX timeout. We then raise hw error condition and trigger
service task to handle this.

This handler will capture extra debug info and then optionally
trigger recovery procedure to try restore function.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 -
 drivers/net/ethernet/qlogic/qede/qede_main.c | 46 ++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 695d645d9ba9..8857da1208d7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -533,7 +533,6 @@ u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 netdev_features_t qede_features_check(struct sk_buff *skb,
 				      struct net_device *dev,
 				      netdev_features_t features);
-void qede_tx_log_print(struct qede_dev *edev, struct qede_fastpath *fp);
 int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy);
 int qede_free_tx_pkt(struct qede_dev *edev,
 		     struct qede_tx_queue *txq, int *len);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index ee7662da6413..f50d9a9b76be 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -539,6 +539,51 @@ static int qede_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
+
+	if (IS_VF(edev))
+		return;
+
+	if (test_and_set_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags) ||
+	    edev->state == QEDE_STATE_RECOVERY) {
+		DP_INFO(edev,
+			"Avoid handling a Tx timeout while another HW error is being handled\n");
+		return;
+	}
+
+	set_bit(QEDE_ERR_GET_DBG_INFO, &edev->err_flags);
+	set_bit(QEDE_SP_HW_ERR, &edev->sp_flags);
+	schedule_delayed_work(&edev->sp_task, 0);
+}
+
 static int qede_setup_tc(struct net_device *ndev, u8 num_tc)
 {
 	struct qede_dev *edev = netdev_priv(ndev);
@@ -626,6 +671,7 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_change_mtu = qede_change_mtu,
 	.ndo_do_ioctl = qede_ioctl,
+	.ndo_tx_timeout = qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
 	.ndo_set_vf_mac = qede_set_vf_mac,
 	.ndo_set_vf_vlan = qede_set_vf_vlan,
-- 
2.17.1

