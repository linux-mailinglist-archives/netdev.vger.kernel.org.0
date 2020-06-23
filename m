Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754EF2053F5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgFWNyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:54:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732741AbgFWNxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDjF1V024287;
        Tue, 23 Jun 2020 06:53:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=S37wSmvqIx07DTZh4sdMLTylznmuNY6nhdD735d4Nbg=;
 b=HfM+XX/h4VnxSPCf+jNYhcwsmqBXNDxVdJlXo7mEUrm3v4H3e0sG0LKtmBqqD7KLC79Y
 xTAyHpJorx4rT/FF1bkq1glY3w2YYjPhrX4nrt0q7sN+kkPXHeGGIMwnR0TWDE5ZLUi9
 I1chswyT3jk45g9KaIcfnYHdM8TV0Ta1jPaGxgD7dpbGTLdDHUca+7H61pbpU0lzKmIp
 wz/pkxBAF85EraZXRsco3FmicpjZXpFx0irARdDYQZR9cu//3Ufyz5PLF9YSFdCNdvZK
 OU1V3LRLRXc1n//iCxbkk8sMJ3QNAKV+mldnQSnule9ZW6wGKxyM+60buSPA4qpwX7WQ Pg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31ujw9r0y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:39 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 5CB1C3F703F;
        Tue, 23 Jun 2020 06:53:35 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 6/9] net: qede: fix PTP initialization on recovery
Date:   Tue, 23 Jun 2020 16:51:34 +0300
Message-ID: <20200623135136.3185-7-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
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
2.25.1

