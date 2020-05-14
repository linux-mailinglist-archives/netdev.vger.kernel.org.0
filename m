Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EEE1D2BF7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgENJ6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgENJ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9vGVt030149;
        Thu, 14 May 2020 02:58:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qRtrgN0qk7csVpHTARWD3VFoVYoHLx/NJN/+Zu2U0lM=;
 b=PGXDniN2Hsdl+EEYen7clf8qHMapB/WkMXQVf1bJmg0nHmM8xaIF3NLpaUaeLgUFW/q5
 nnUlj5DGuBFxm/kVIN/RTT2xWedAzK2hwye9PYJ/3Kj2kzYL6Jl+2OZxNOEe1JvMbuKV
 lmpFzkAnbj7dpTEmOgJm90mzEN+lp4BSkQ9V/nBvaVZgqdzIzIF2GsYpXbgZoITGUMnE
 j0a1Jyk27/5CVJAx8H1vw+na0bNjfSGGrMmH90QnjQwX2eN+kNof9B6K/ZLCzn9sClGO
 6SIcX1VVzITeuVweYvxIUQDBvlu0AlIHZWw1+doq3EDeWogsgH5RRXlSTuk17guk8pND CQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1qvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:57:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:57:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:57:57 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 0A4E43F703F;
        Thu, 14 May 2020 02:57:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "Michal Kalderon" <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 02/11] net: qede: add hw err scheduled handler
Date:   Thu, 14 May 2020 12:57:18 +0300
Message-ID: <20200514095727.1361-3-irusskikh@marvell.com>
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

qede (ethernet level driver) registers a callback handler.
This handler maintains eth dev state flags/bits to track error processing.

It implements in place processing part for nonsleeping context (WARN_ON
trigger), and a deferred (delayed work) part which triggers recovery
process for recoverable errors.

In later patches this atomic handler will come with more meat.

We introduce err_flags on ethdevice structure, its being used to record
error handling properties.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      | 13 ++-
 drivers/net/ethernet/qlogic/qede/qede_main.c | 95 +++++++++++++++++++-
 2 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f6f0b51620ab..695d645d9ba9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -278,6 +278,14 @@ struct qede_dev {
 	struct qede_rdma_dev		rdma_info;
 
 	struct bpf_prog *xdp_prog;
+
+	unsigned long err_flags;
+#define QEDE_ERR_IS_HANDLED	31
+#define QEDE_ERR_ATTN_CLR_EN	0
+#define QEDE_ERR_GET_DBG_INFO	1
+#define QEDE_ERR_IS_RECOVERABLE	2
+#define QEDE_ERR_WARN		3
+
 	struct qede_dump_info		dump_info;
 };
 
@@ -485,12 +493,15 @@ struct qede_fastpath {
 
 #define QEDE_SP_RECOVERY		0
 #define QEDE_SP_RX_MODE			1
+#define QEDE_SP_RSVD1                   2
+#define QEDE_SP_RSVD2                   3
+#define QEDE_SP_HW_ERR                  4
+#define QEDE_SP_ARFS_CONFIG             5
 #define QEDE_SP_AER			7
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 		       u16 rxq_index, u32 flow_id);
-#define QEDE_SP_ARFS_CONFIG	4
 #define QEDE_SP_TASK_POLL_DELAY	(5 * HZ)
 #endif
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 300405369c37..e67d5da23792 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -139,10 +139,12 @@ static void qede_shutdown(struct pci_dev *pdev);
 static void qede_link_update(void *dev, struct qed_link_output *link);
 static void qede_schedule_recovery_handler(void *dev);
 static void qede_recovery_handler(struct qede_dev *edev);
+static void qede_schedule_hw_err_handler(void *dev,
+					 enum qed_hw_err_type err_type);
 static void qede_get_eth_tlv_data(void *edev, void *data);
 static void qede_get_generic_tlv_data(void *edev,
 				      struct qed_generic_tlvs *data);
-
+static void qede_generic_hw_err_handler(struct qede_dev *edev);
 #ifdef CONFIG_QED_SRIOV
 static int qede_set_vf_vlan(struct net_device *ndev, int vf, u16 vlan, u8 qos,
 			    __be16 vlan_proto)
@@ -230,6 +232,7 @@ static struct qed_eth_cb_ops qede_ll_ops = {
 #endif
 		.link_update = qede_link_update,
 		.schedule_recovery_handler = qede_schedule_recovery_handler,
+		.schedule_hw_err_handler = qede_schedule_hw_err_handler,
 		.get_generic_tlv_data = qede_get_generic_tlv_data,
 		.get_protocol_tlv_data = qede_get_eth_tlv_data,
 	},
@@ -1009,6 +1012,8 @@ static void qede_sp_task(struct work_struct *work)
 			qede_process_arfs_filters(edev, false);
 	}
 #endif
+	if (test_and_clear_bit(QEDE_SP_HW_ERR, &edev->sp_flags))
+		qede_generic_hw_err_handler(edev);
 	__qede_unlock(edev);
 
 	if (test_and_clear_bit(QEDE_SP_AER, &edev->sp_flags)) {
@@ -2509,6 +2514,94 @@ static void qede_recovery_handler(struct qede_dev *edev)
 	qede_recovery_failed(edev);
 }
 
+static void qede_atomic_hw_err_handler(struct qede_dev *edev)
+{
+	DP_NOTICE(edev,
+		  "Generic non-sleepable HW error handling started - err_flags 0x%lx\n",
+		  edev->err_flags);
+
+	/* Get a call trace of the flow that led to the error */
+	WARN_ON(test_bit(QEDE_ERR_WARN, &edev->err_flags));
+
+	DP_NOTICE(edev, "Generic non-sleepable HW error handling is done\n");
+}
+
+static void qede_generic_hw_err_handler(struct qede_dev *edev)
+{
+	struct qed_dev *cdev = edev->cdev;
+
+	DP_NOTICE(edev,
+		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
+		  edev->err_flags);
+
+	/* Trigger a recovery process.
+	 * This is placed in the sleep requiring section just to make
+	 * sure it is the last one, and that all the other operations
+	 * were completed.
+	 */
+	if (test_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags))
+		edev->ops->common->recovery_process(cdev);
+
+	clear_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags);
+
+	DP_NOTICE(edev, "Generic sleepable HW error handling is done\n");
+}
+
+static void qede_set_hw_err_flags(struct qede_dev *edev,
+				  enum qed_hw_err_type err_type)
+{
+	unsigned long err_flags = 0;
+
+	switch (err_type) {
+	case QED_HW_ERR_DMAE_FAIL:
+		set_bit(QEDE_ERR_WARN, &err_flags);
+		fallthrough;
+	case QED_HW_ERR_MFW_RESP_FAIL:
+	case QED_HW_ERR_HW_ATTN:
+	case QED_HW_ERR_RAMROD_FAIL:
+	case QED_HW_ERR_FW_ASSERT:
+		set_bit(QEDE_ERR_ATTN_CLR_EN, &err_flags);
+		set_bit(QEDE_ERR_GET_DBG_INFO, &err_flags);
+		break;
+
+	default:
+		DP_NOTICE(edev, "Unexpected HW error [%d]\n", err_type);
+		break;
+	}
+
+	edev->err_flags |= err_flags;
+}
+
+static void qede_schedule_hw_err_handler(void *dev,
+					 enum qed_hw_err_type err_type)
+{
+	struct qede_dev *edev = dev;
+
+	/* Fan failure cannot be masked by handling of another HW error or by a
+	 * concurrent recovery process.
+	 */
+	if ((test_and_set_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags) ||
+	     edev->state == QEDE_STATE_RECOVERY) &&
+	     err_type != QED_HW_ERR_FAN_FAIL) {
+		DP_INFO(edev,
+			"Avoid scheduling an error handling while another HW error is being handled\n");
+		return;
+	}
+
+	if (err_type >= QED_HW_ERR_LAST) {
+		DP_NOTICE(edev, "Unknown HW error [%d]\n", err_type);
+		clear_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags);
+		return;
+	}
+
+	qede_set_hw_err_flags(edev, err_type);
+	qede_atomic_hw_err_handler(edev);
+	set_bit(QEDE_SP_HW_ERR, &edev->sp_flags);
+	schedule_delayed_work(&edev->sp_task, 0);
+
+	DP_INFO(edev, "Scheduled a error handler [err_type %d]\n", err_type);
+}
+
 static bool qede_is_txq_full(struct qede_dev *edev, struct qede_tx_queue *txq)
 {
 	struct netdev_queue *netdev_txq;
-- 
2.17.1

