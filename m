Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9288B2035A1
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgFVLZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:25:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbgFVLOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB86JK013007;
        Mon, 22 Jun 2020 04:14:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=t97hH25AJUlN19CXzaY6uggLUQfiB/H/kpwPvbxN+JI=;
 b=PJHKamxetZP8wfmIv4h7e7mcJZVMmSm45KJaptTb5DKdZUEA04YOozdU4lwTZ+PVu9MP
 JS2JDWLSOh5VUdN46TPoMWDiK8JTjmZmHQrqtkzBPFxAtukl3wRpcTghwcS2vBq7mpKp
 xdR4cMj0MurmOYVmT5KcNUWvaTy8CndrWmFl7uAMQiQDplV2uB+2lXma/n35uKIDqUBf
 ROTqJ5CtuIR7xf70kABo2sh9BgHvbRnjJwbexZP+EeT01CpFkfQpI5wK9YQozOOzA3Ji
 ALmXJs9b1nkMN8BjkxSj39N3xQR/LeS68I49ExtBv2EYRm15MzEG2FdWY8jqq2auFTcF 1A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqpbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:48 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id CB39B3F703F;
        Mon, 22 Jun 2020 04:14:44 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 6/9] net: qede: fix PTP initialization on recovery
Date:   Mon, 22 Jun 2020 14:14:10 +0300
Message-ID: <20200622111413.7006-7-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PTP cyclecounter and timecounter are initialized only on
the first probing and are cleaned up during removal. This means that
PTP becomes non-functional after device recovery.
Fix this by unconditional PTP initialization on probing and clearing
Tx pending bit on exiting.

Fixes: ccc67ef50b90 ("qede: Error recovery process")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c  | 31 ++++++++------------
 drivers/net/ethernet/qlogic/qede/qede_ptp.h  |  2 +-
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 756c05eb96f3..f6ff31e73ebe 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1229,7 +1229,7 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 
 	/* PTP not supported on VFs */
 	if (!is_vf)
-		qede_ptp_enable(edev, (mode == QEDE_PROBE_NORMAL));
+		qede_ptp_enable(edev);
 
 	edev->ops->register_ops(cdev, &qede_ll_ops, edev);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 4c7f7a7fc151..cd5841a9415e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -412,6 +412,7 @@ void qede_ptp_disable(struct qede_dev *edev)
 	if (ptp->tx_skb) {
 		dev_kfree_skb_any(ptp->tx_skb);
 		ptp->tx_skb = NULL;
+		clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags);
 	}
 
 	/* Disable PTP in HW */
@@ -423,7 +424,7 @@ void qede_ptp_disable(struct qede_dev *edev)
 	edev->ptp = NULL;
 }
 
-static int qede_ptp_init(struct qede_dev *edev, bool init_tc)
+static int qede_ptp_init(struct qede_dev *edev)
 {
 	struct qede_ptp *ptp;
 	int rc;
@@ -444,25 +445,19 @@ static int qede_ptp_init(struct qede_dev *edev, bool init_tc)
 	/* Init work queue for Tx timestamping */
 	INIT_WORK(&ptp->work, qede_ptp_task);
 
-	/* Init cyclecounter and timecounter. This is done only in the first
-	 * load. If done in every load, PTP application will fail when doing
-	 * unload / load (e.g. MTU change) while it is running.
-	 */
-	if (init_tc) {
-		memset(&ptp->cc, 0, sizeof(ptp->cc));
-		ptp->cc.read = qede_ptp_read_cc;
-		ptp->cc.mask = CYCLECOUNTER_MASK(64);
-		ptp->cc.shift = 0;
-		ptp->cc.mult = 1;
-
-		timecounter_init(&ptp->tc, &ptp->cc,
-				 ktime_to_ns(ktime_get_real()));
-	}
+	/* Init cyclecounter and timecounter */
+	memset(&ptp->cc, 0, sizeof(ptp->cc));
+	ptp->cc.read = qede_ptp_read_cc;
+	ptp->cc.mask = CYCLECOUNTER_MASK(64);
+	ptp->cc.shift = 0;
+	ptp->cc.mult = 1;
 
-	return rc;
+	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+
+	return 0;
 }
 
-int qede_ptp_enable(struct qede_dev *edev, bool init_tc)
+int qede_ptp_enable(struct qede_dev *edev)
 {
 	struct qede_ptp *ptp;
 	int rc;
@@ -483,7 +478,7 @@ int qede_ptp_enable(struct qede_dev *edev, bool init_tc)
 
 	edev->ptp = ptp;
 
-	rc = qede_ptp_init(edev, init_tc);
+	rc = qede_ptp_init(edev);
 	if (rc)
 		goto err1;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.h b/drivers/net/ethernet/qlogic/qede/qede_ptp.h
index 691a14c4b2c5..89c7f3cf3ee2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.h
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.h
@@ -41,7 +41,7 @@ void qede_ptp_rx_ts(struct qede_dev *edev, struct sk_buff *skb);
 void qede_ptp_tx_ts(struct qede_dev *edev, struct sk_buff *skb);
 int qede_ptp_hw_ts(struct qede_dev *edev, struct ifreq *req);
 void qede_ptp_disable(struct qede_dev *edev);
-int qede_ptp_enable(struct qede_dev *edev, bool init_tc);
+int qede_ptp_enable(struct qede_dev *edev);
 int qede_ptp_get_ts_info(struct qede_dev *edev, struct ethtool_ts_info *ts);
 
 static inline void qede_ptp_record_rx_ts(struct qede_dev *edev,
-- 
2.21.0

