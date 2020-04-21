Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F1D1B2A97
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgDUPA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:00:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgDUPA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:00:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LEtXcv022739;
        Tue, 21 Apr 2020 08:00:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=SK7reews4BlppN7F/B8XOmE+BbOJjmiXbdW9q19r1HY=;
 b=XjrCZDN4Tmikp1GtOCqqgqC3SFZAVyy1djkamBBh2+Yk0F3e1eUngu7nINAgyE26C8NJ
 BiK3KETUhS3Mx3AJjm5TDjWQ3dfgcWuoKqSZrF9e5dEdpDrqDCxRzqEALUNBwmidVTvt
 3/DWoYYNOTQTHlaXjj+q1ywYoLAQbkvM78Dr5/huATuyYC6cBwRQZhdLX8oMkCFzkrRp
 eOVfTIIH6oI2VFNeksdCpbeWDcIDc2cim0HLYSNYdTo8gxTw/ph/xKueSJegUQyJFdZT
 OMkBU9bWAlNGqr+kUd5T4tq+nCfae5m39tLa+GSOrD1Ti3B+zVtiGf3xfMWJGFi/wTsP 6Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwpcqx5-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:00:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 07:53:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Apr 2020 07:53:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F31D93F703F;
        Tue, 21 Apr 2020 07:53:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03LErWTk016335;
        Tue, 21 Apr 2020 07:53:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03LErW5G016334;
        Tue, 21 Apr 2020 07:53:32 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 3/3] qede: Add support for handling the pcie errors.
Date:   Tue, 21 Apr 2020 07:53:00 -0700
Message-ID: <20200421145300.16278-4-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200421145300.16278-1-skalluru@marvell.com>
References: <20200421145300.16278-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_05:2020-04-20,2020-04-21 signatures=0
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
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 68 +++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index bf8b8ad..bacc58f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -486,6 +486,7 @@ struct qede_fastpath {
 
 #define QEDE_SP_RECOVERY		0
 #define QEDE_SP_RX_MODE			1
+#define QEDE_SP_AER			7
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9c4d9cd..4adfe2f 100644
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
 
@@ -206,6 +209,10 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 }
 #endif
 
+static const struct pci_error_handlers qede_err_handler = {
+	.error_detected = qede_io_error_detected,
+};
+
 static struct pci_driver qede_pci_driver = {
 	.name = "qede",
 	.id_table = qede_pci_tbl,
@@ -215,6 +222,7 @@ static int qede_sriov_configure(struct pci_dev *pdev, int num_vfs_param)
 #ifdef CONFIG_QED_SRIOV
 	.sriov_configure = qede_sriov_configure,
 #endif
+	.err_handler = &qede_err_handler,
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
@@ -977,7 +985,8 @@ static void qede_sp_task(struct work_struct *work)
 		/* SRIOV must be disabled outside the lock to avoid a deadlock.
 		 * The recovery of the active VFs is currently not supported.
 		 */
-		qede_sriov_configure(edev->pdev, 0);
+		if (edev->num_vfs)
+			qede_sriov_configure(edev->pdev, 0);
 #endif
 		qede_lock(edev);
 		qede_recovery_handler(edev);
@@ -997,6 +1006,17 @@ static void qede_sp_task(struct work_struct *work)
 	}
 #endif
 	__qede_unlock(edev);
+
+	if (test_and_clear_bit(QEDE_SP_AER, &edev->sp_flags)) {
+#ifdef CONFIG_QED_SRIOV
+		/* SRIOV must be disabled outside the lock to avoid a deadlock.
+		 * The recovery of the active VFs is currently not supported.
+		 */
+		if (edev->num_vfs)
+			qede_sriov_configure(edev->pdev, 0);
+#endif
+		edev->ops->common->recovery_process(edev->cdev);
+	}
 }
 
 static void qede_update_pf_params(struct qed_dev *cdev)
@@ -2582,3 +2602,49 @@ static void qede_get_eth_tlv_data(void *dev, void *data)
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

