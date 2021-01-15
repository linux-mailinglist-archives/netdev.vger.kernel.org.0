Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6510A2F74E2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbhAOJHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:07:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbhAOJHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:07:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F8xbJC013544;
        Fri, 15 Jan 2021 01:06:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PxvV52RAe3ey3uQBB7fjLd0tto6rfqlTF3yG/HlNby4=;
 b=lIjSK/QQ86YAsA3xKVqslDufe3WT8XakDHSgwYEEM1JlCaLaP+1jFUg1r9t4K1vjXGjk
 EILHr1ua8csL4bvdaph5O31iEuoAoO9dNeQsWYx3y23TSWXV32ahUImB0sQcTx1+6cVo
 ukVvioezM4dQ07sKF4B/Npk4YumGucVe4YtenT5woPe5l6udIdVtxfaGXA8tfTCkv5OO
 flKwhUAYMEUieXPirsDHCeUsSEr0H+H+OrKWonFDKVurv/MMbps0eV78NsdiCV7ybuko
 5o1jVNpHgJkGe0jRwxHu+A4WF9rR6W/WXglNTk8E623BSINCzhfoBy86QRwDVN2bYNHS oA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvq2310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 01:06:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Jan
 2021 01:06:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Jan 2021 01:06:22 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 4EF7A3F7043;
        Fri, 15 Jan 2021 01:06:22 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <bupadhaya@marvell.com>
Subject: [PATCH net-next 2/3] qede: add per queue coalesce support for qede driver
Date:   Fri, 15 Jan 2021 01:06:09 -0800
Message-ID: <1610701570-29496-3-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_06:2021-01-15,2021-01-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

per queue coalescing allows better and more finegrained control
over interrupt rates.

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index bedbb85a179a..522736968496 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -2105,6 +2105,125 @@ static int qede_get_dump_data(struct net_device *dev,
 	return rc;
 }
 
+static int qede_set_per_coalesce(struct net_device *dev,
+				 u32 queue,
+				 struct ethtool_coalesce *coal)
+{
+	struct qede_dev *edev = netdev_priv(dev);
+	struct qede_fastpath *fp;
+	u16 rxc, txc;
+	int rc = 0;
+
+	if (coal->rx_coalesce_usecs > QED_COALESCE_MAX ||
+	    coal->tx_coalesce_usecs > QED_COALESCE_MAX) {
+		DP_INFO(edev,
+			"Can't support requested %s coalesce value [max supported value %d]\n",
+			coal->rx_coalesce_usecs > QED_COALESCE_MAX ? "rx"
+								   : "tx",
+			QED_COALESCE_MAX);
+		return -EINVAL;
+	}
+
+	rxc = (u16)coal->rx_coalesce_usecs;
+	txc = (u16)coal->tx_coalesce_usecs;
+
+	__qede_lock(edev);
+	if (queue >= edev->num_queues) {
+		DP_INFO(edev, "Invalid queue\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (edev->state != QEDE_STATE_OPEN) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	fp = &edev->fp_array[queue];
+
+	if (edev->fp_array[queue].type & QEDE_FASTPATH_RX) {
+		rc = edev->ops->common->set_coalesce(edev->cdev,
+						     rxc, 0,
+						     fp->rxq->handle);
+		if (rc) {
+			DP_INFO(edev,
+				"Set RX coalesce error, rc = %d\n", rc);
+			goto out;
+		}
+	}
+
+	if (edev->fp_array[queue].type & QEDE_FASTPATH_TX) {
+		rc = edev->ops->common->set_coalesce(edev->cdev,
+						     0, txc,
+						     fp->txq->handle);
+		if (rc) {
+			DP_INFO(edev,
+				"Set TX coalesce error, rc = %d\n", rc);
+			goto out;
+		}
+	}
+out:
+	__qede_unlock(edev);
+
+	return rc;
+}
+
+static int qede_get_per_coalesce(struct net_device *dev,
+				 u32 queue,
+				 struct ethtool_coalesce *coal)
+{
+	void *rx_handle = NULL, *tx_handle = NULL;
+	struct qede_dev *edev = netdev_priv(dev);
+	u16 rx_coal, tx_coal, rc = 0;
+	struct qede_fastpath *fp;
+
+	rx_coal = QED_DEFAULT_RX_USECS;
+	tx_coal = QED_DEFAULT_TX_USECS;
+
+	memset(coal, 0, sizeof(struct ethtool_coalesce));
+
+	__qede_lock(edev);
+	if (queue >= edev->num_queues) {
+		DP_INFO(edev, "Invalid queue\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (edev->state != QEDE_STATE_OPEN) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	fp = &edev->fp_array[queue];
+
+	if (fp->type & QEDE_FASTPATH_RX)
+		rx_handle = fp->rxq->handle;
+
+	rc = edev->ops->get_coalesce(edev->cdev, &rx_coal,
+				     rx_handle);
+	if (rc) {
+		DP_INFO(edev, "Read Rx coalesce error\n");
+		goto out;
+	}
+
+	fp = &edev->fp_array[queue];
+	if (fp->type & QEDE_FASTPATH_TX)
+		tx_handle = fp->txq->handle;
+
+	rc = edev->ops->get_coalesce(edev->cdev, &tx_coal,
+				      tx_handle);
+	if (rc)
+		DP_INFO(edev, "Read Tx coalesce error\n");
+
+out:
+	__qede_unlock(edev);
+
+	coal->rx_coalesce_usecs = rx_coal;
+	coal->tx_coalesce_usecs = tx_coal;
+
+	return rc;
+}
+
 static const struct ethtool_ops qede_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS,
 	.get_link_ksettings		= qede_get_link_ksettings,
@@ -2148,6 +2267,8 @@ static const struct ethtool_ops qede_ethtool_ops = {
 	.set_fecparam			= qede_set_fecparam,
 	.get_tunable			= qede_get_tunable,
 	.set_tunable			= qede_set_tunable,
+	.get_per_queue_coalesce		= qede_get_per_coalesce,
+	.set_per_queue_coalesce		= qede_set_per_coalesce,
 	.flash_device			= qede_flash_device,
 	.get_dump_flag			= qede_get_dump_flag,
 	.get_dump_data			= qede_get_dump_data,
@@ -2177,6 +2298,8 @@ static const struct ethtool_ops qede_vf_ethtool_ops = {
 	.set_rxfh			= qede_set_rxfh,
 	.get_channels			= qede_get_channels,
 	.set_channels			= qede_set_channels,
+	.get_per_queue_coalesce		= qede_get_per_coalesce,
+	.set_per_queue_coalesce		= qede_set_per_coalesce,
 	.get_tunable			= qede_get_tunable,
 	.set_tunable			= qede_set_tunable,
 };
-- 
2.17.1

