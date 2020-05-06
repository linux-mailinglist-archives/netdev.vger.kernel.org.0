Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6871C6F6D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgEFLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58572 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727909AbgEFLeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BX4kw010782;
        Wed, 6 May 2020 04:34:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fj0EAUD+R0Je7+CUtaVXywZdfnFyKP4vkObfOCR4/OE=;
 b=WWiTUAdhp/af1irhCFmDI1TCIJHJXVVOP5WjzoAqn3GqCtzvnbcGrw9Ee2OdxY3qxv/3
 IKJk8gIcWGdcDfQ/PykQ59xe3BZhYM7TNyUcOoTzVMtf34LjqPG9NMsCyMKzHB1dxJHL
 jl6Cp4x8uhNf5OHmmGJdTGQZRPeBBXh+tUJvCmM6w4y78ocBfysT6O+Oqrc964I7qYIR
 +O4lFZ3PntNY+v+JeqVuGrOs/H9dwpspefeUAphghwoPlHOzUCdwHQ52qh/Rp8+Bwi0A
 tkMomNzpo/qO/g019OEL7o7Z/bUTZjSGWyhGT4L+ADvD1Q7SuFzmWUZQdi1qZ89BSILr Ug== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukvqn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:13 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 5A1303F7040;
        Wed,  6 May 2020 04:34:11 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 09/12] net: qede: Implement ndo_tx_timeout
Date:   Wed, 6 May 2020 14:33:11 +0300
Message-ID: <9772d48f7b5734d2c263ddfabd5200ccfffd2d6b.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
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
index 904b2872db45..3b185c876538 100644
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
index 0f7c4d34a91e..7ed94d80f500 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -538,6 +538,51 @@ static int qede_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
@@ -625,6 +670,7 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_change_mtu = qede_change_mtu,
 	.ndo_do_ioctl = qede_ioctl,
+	.ndo_tx_timeout = qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
 	.ndo_set_vf_mac = qede_set_vf_mac,
 	.ndo_set_vf_vlan = qede_set_vf_vlan,
-- 
2.25.1

