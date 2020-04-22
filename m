Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4F1B4611
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDVNQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:16:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726498AbgDVNQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:16:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MDBdCo017618;
        Wed, 22 Apr 2020 06:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MYubdThaf86+KgsvG9/czizAZqn+v3Z6O0Fta5UTmqo=;
 b=U28lMGKBEtDblrYpRlHhhX0KAUfUOC14+RVUStnIRrTjmFYSYH3BqphsUg6j272ZM77I
 o0Ce70MjQ5oQl/pLVq2H1eu8gR1dtiekUWMlaRyJeQYO5W9q27/QX40LEvv0Gxklb+AB
 Qi7bkwkDxLJfu5s/RxuyVmcfHWpClsMpgA7XGk9O0FqS2BIuVckY2hy3mHeEJ9qosmJN
 u0tlmkh+p4xxTv3UhX0s42aRHE+Qqp4bzVB/6KV6DMdlLlf340BHLyhm5VvgS3c6Z3d/
 5FSerNkaDQqxumN2vwpdo6l96bxsqjKQfI6XzWVJeMok7M2WRMyupuRj3r+KW53B1mGS Ag== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwphjsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 06:16:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Apr
 2020 06:16:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Apr 2020 06:16:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A8EAA3F7040;
        Wed, 22 Apr 2020 06:16:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03MDGGxT007307;
        Wed, 22 Apr 2020 06:16:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03MDGGYg007306;
        Wed, 22 Apr 2020 06:16:16 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v2 2/2] qede: Add support for handling the pcie errors.
Date:   Wed, 22 Apr 2020 06:16:07 -0700
Message-ID: <20200422131607.7262-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200422131607.7262-1-skalluru@marvell.com>
References: <20200422131607.7262-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error recovery is handled by management firmware (MFW) with the help of
qed/qede drivers. Upon detecting the errors, driver informs MFW about this
event which in turn starts a recovery process. MFW sends ERROR_RECOVERY
notification to the driver which performs the required cleanup/recovery
from the driver side.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 68 +++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 234c6f3..1a708f9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -485,6 +485,7 @@ struct qede_fastpath {
 
 #define QEDE_SP_RECOVERY		0
 #define QEDE_SP_RX_MODE			1
+#define QEDE_SP_AER			7
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 34fa391..9b45619 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -60,6 +60,7 @@
 #include <net/ip6_checksum.h>
 #include <linux/bitops.h>
 #include <linux/vmalloc.h>
+#include <linux/aer.h>
 #include "qede.h"
 #include "qede_ptp.h"
 
@@ -124,6 +125,8 @@ enum qede_pci_private {
 MODULE_DEVICE_TABLE(pci, qede_pci_tbl);
 
 static int qede_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+static pci_ers_result_t
+qede_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state);
 
 #define TX_TIMEOUT		(5 * HZ)
 
@@ -203,6 +206,10 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 }
 #endif
 
+static const struct pci_error_handlers qede_err_handler = {
+	.error_detected = qede_io_error_detected,
+};
+
 static struct pci_driver qede_pci_driver = {
 	.name = "qede",
 	.id_table = qede_pci_tbl,
@@ -212,6 +219,7 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 #ifdef CONFIG_QED_SRIOV
 	.sriov_configure = qede_sriov_configure,
 #endif
+	.err_handler = &qede_err_handler,
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
@@ -974,7 +982,8 @@ static void qede_sp_task(struct work_struct *work)
 		/* SRIOV must be disabled outside the lock to avoid a deadlock.
 		 * The recovery of the active VFs is currently not supported.
 		 */
-		qede_sriov_configure(edev->pdev, 0);
+		if (pci_num_vf(edev->pdev))
+			qede_sriov_configure(edev->pdev, 0);
 #endif
 		qede_lock(edev);
 		qede_recovery_handler(edev);
@@ -994,6 +1003,17 @@ static void qede_sp_task(struct work_struct *work)
 	}
 #endif
 	__qede_unlock(edev);
+
+	if (test_and_clear_bit(QEDE_SP_AER, &edev->sp_flags)) {
+#ifdef CONFIG_QED_SRIOV
+		/* SRIOV must be disabled outside the lock to avoid a deadlock.
+		 * The recovery of the active VFs is currently not supported.
+		 */
+		if (pci_num_vf(edev->pdev))
+			qede_sriov_configure(edev->pdev, 0);
+#endif
+		edev->ops->common->recovery_process(edev->cdev);
+	}
 }
 
 static void qede_update_pf_params(struct qed_dev *cdev)
@@ -2579,3 +2599,49 @@ static void qede_get_eth_tlv_data(void *dev, void *data)
 	etlv->num_txqs_full_set = true;
 	etlv->num_rxqs_full_set = true;
 }
+
+/**
+ * qede_io_error_detected - called when PCI error is detected
+ * @pdev: Pointer to PCI device
+ * @state: The current pci connection state
+ *
+ * This function is called after a PCI bus error affecting
+ * this device has been detected.
+ */
+static pci_ers_result_t
+qede_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct qede_dev *edev = netdev_priv(dev);
+
+	if (!edev)
+		return PCI_ERS_RESULT_NONE;
+
+	DP_NOTICE(edev, "IO error detected [%d]\n", state);
+
+	__qede_lock(edev);
+	if (edev->state == QEDE_STATE_RECOVERY) {
+		DP_NOTICE(edev, "Device already in the recovery state\n");
+		__qede_unlock(edev);
+		return PCI_ERS_RESULT_NONE;
+	}
+
+	/* PF handles the recovery of its VFs */
+	if (IS_VF(edev)) {
+		DP_VERBOSE(edev, QED_MSG_IOV,
+			   "VF recovery is handled by its PF\n");
+		__qede_unlock(edev);
+		return PCI_ERS_RESULT_RECOVERED;
+	}
+
+	/* Close OS Tx */
+	netif_tx_disable(edev->ndev);
+	netif_carrier_off(edev->ndev);
+
+	set_bit(QEDE_SP_AER, &edev->sp_flags);
+	schedule_delayed_work(&edev->sp_task, 0);
+
+	__qede_unlock(edev);
+
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
-- 
1.8.3.1

