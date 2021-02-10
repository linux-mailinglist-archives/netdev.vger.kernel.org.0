Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996E2317169
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhBJUaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:30:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233383AbhBJU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:29:36 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AKP9CT020784;
        Wed, 10 Feb 2021 12:28:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UkgdiTwRnZdoiNGDO9grsaE7NlXbfwVDnpMYrRoXdLw=;
 b=M2py7+MGC4/pIrAa1RTZtLLVhLuFzyxrCRU0vnrgySjsGYEFmYty8Lo+V4YeAKPtk7xv
 NOWYyw8bca2OGTzwHAdHO2MMxkBeevDSZsqy+eRF+ifRI62nMznIzxnSwvpglLOOKLXf
 x8Pz1hSVtZHAoOkTP4eaMaGHbL2DXMlo7k3dMl3R0f27VR4pzm7OeDMlArvnsfl3Qz5D
 PKkteVnnUHLCgp3jqrUYIaWgncnw8yk1rr6J0WQH2TeY0NwoEZ2lcnC9xq73B9bz9s49
 q7GyrlCpVdpUYatsjuIvRahju66SErbDBsUhKaxzhcvvF6g6PJ+jd8U+AlmpeSYhh9bJ 7w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqcwaj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 12:28:52 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:43 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 12:28:42 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id BB01E3F7045;
        Wed, 10 Feb 2021 12:28:42 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH v3 net-next 3/3] qede: preserve per queue stats across up/down of interface
Date:   Wed, 10 Feb 2021 12:28:31 -0800
Message-ID: <1612988911-10799-4-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
References: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we do the initialization of coalescing values on load.
per queue coalesce values are also restored across up/down of
ethernet interface.

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h       | 10 +++++++
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 16 ++++++----
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 29 +++++++++++++++++--
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 3efc5899f656..2e62a2c4eb63 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -168,6 +168,12 @@ struct qede_dump_info {
 	u32 args[QEDE_DUMP_MAX_ARGS];
 };
 
+struct qede_coalesce {
+	bool isvalid;
+	u16 rxc;
+	u16 txc;
+};
+
 struct qede_dev {
 	struct qed_dev			*cdev;
 	struct net_device		*ndev;
@@ -194,6 +200,7 @@ struct qede_dev {
 	((edev)->dev_info.common.dev_type == QED_DEV_TYPE_AH)
 
 	struct qede_fastpath		*fp_array;
+	struct qede_coalesce            *coal_entry;
 	u8				req_num_tx;
 	u8				fp_num_tx;
 	u8				req_num_rx;
@@ -581,6 +588,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f);
 
 void qede_forced_speed_maps_init(void);
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal);
+int qede_set_per_coalesce(struct net_device *dev, u32 queue,
+			  struct ethtool_coalesce *coal);
 
 #define RX_RING_SIZE_POW	13
 #define RX_RING_SIZE		((u16)BIT(RX_RING_SIZE_POW))
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 78ed5adee022..1560ad3d9290 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -819,8 +819,7 @@ static int qede_get_coalesce(struct net_device *dev,
 	return rc;
 }
 
-static int qede_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_fastpath *fp;
@@ -855,6 +854,8 @@ static int qede_set_coalesce(struct net_device *dev,
 					"Set RX coalesce error, rc = %d\n", rc);
 				return rc;
 			}
+			edev->coal_entry[i].rxc = rxc;
+			edev->coal_entry[i].isvalid = true;
 		}
 
 		if (edev->fp_array[i].type & QEDE_FASTPATH_TX) {
@@ -874,6 +875,8 @@ static int qede_set_coalesce(struct net_device *dev,
 					"Set TX coalesce error, rc = %d\n", rc);
 				return rc;
 			}
+			edev->coal_entry[i].txc = txc;
+			edev->coal_entry[i].isvalid = true;
 		}
 	}
 
@@ -2105,9 +2108,8 @@ static int qede_get_dump_data(struct net_device *dev,
 	return rc;
 }
 
-static int qede_set_per_coalesce(struct net_device *dev,
-				 u32 queue,
-				 struct ethtool_coalesce *coal)
+int qede_set_per_coalesce(struct net_device *dev, u32 queue,
+			  struct ethtool_coalesce *coal)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_fastpath *fp;
@@ -2150,6 +2152,8 @@ static int qede_set_per_coalesce(struct net_device *dev,
 				"Set RX coalesce error, rc = %d\n", rc);
 			goto out;
 		}
+		edev->coal_entry[queue].rxc = rxc;
+		edev->coal_entry[queue].isvalid = true;
 	}
 
 	if (edev->fp_array[queue].type & QEDE_FASTPATH_TX) {
@@ -2161,6 +2165,8 @@ static int qede_set_per_coalesce(struct net_device *dev,
 				"Set TX coalesce error, rc = %d\n", rc);
 			goto out;
 		}
+		edev->coal_entry[queue].txc = txc;
+		edev->coal_entry[queue].isvalid = true;
 	}
 out:
 	__qede_unlock(edev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 4bf94797aac5..4d952036ba82 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -904,6 +904,7 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 {
 	u8 fp_combined, fp_rx = edev->fp_num_rx;
 	struct qede_fastpath *fp;
+	void *mem;
 	int i;
 
 	edev->fp_array = kcalloc(QEDE_QUEUE_CNT(edev),
@@ -913,6 +914,15 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 		goto err;
 	}
 
+	mem = krealloc(edev->coal_entry, QEDE_QUEUE_CNT(edev) *
+		       sizeof(*edev->coal_entry), GFP_KERNEL);
+	if (!mem) {
+		DP_ERR(edev, "coalesce entry allocation failed\n");
+		kfree(edev->coal_entry);
+		goto err;
+	}
+	edev->coal_entry = mem;
+
 	fp_combined = QEDE_QUEUE_CNT(edev) - fp_rx - edev->fp_num_tx;
 
 	/* Allocate the FP elements for Rx queues followed by combined and then
@@ -1320,8 +1330,10 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	 * [e.g., QED register callbacks] won't break anything when
 	 * accessing the netdevice.
 	 */
-	if (mode != QEDE_REMOVE_RECOVERY)
+	if (mode != QEDE_REMOVE_RECOVERY) {
+		kfree(edev->coal_entry);
 		free_netdev(ndev);
+	}
 
 	dev_info(&pdev->dev, "Ending qede_remove successfully\n");
 }
@@ -2328,8 +2340,9 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 		     bool is_locked)
 {
 	struct qed_link_params link_params;
+	struct ethtool_coalesce coal = {};
 	u8 num_tc;
-	int rc;
+	int rc, i;
 
 	DP_INFO(edev, "Starting qede load\n");
 
@@ -2390,6 +2403,18 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 
 	edev->state = QEDE_STATE_OPEN;
 
+	coal.rx_coalesce_usecs = QED_DEFAULT_RX_USECS;
+	coal.tx_coalesce_usecs = QED_DEFAULT_TX_USECS;
+
+	for_each_queue(i) {
+		if (edev->coal_entry[i].isvalid) {
+			coal.rx_coalesce_usecs = edev->coal_entry[i].rxc;
+			coal.tx_coalesce_usecs = edev->coal_entry[i].txc;
+		}
+		__qede_unlock(edev);
+		qede_set_per_coalesce(edev->ndev, i, &coal);
+		__qede_lock(edev);
+	}
 	DP_INFO(edev, "Ending successfully qede load\n");
 
 	goto out;
-- 
2.17.1

