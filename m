Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4172625B294
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgIBRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:01:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728352AbgIBQ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GuSbY018301;
        Wed, 2 Sep 2020 09:58:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=C+RDGBYgpz5MhKdzZbgztC+AUiF2z9IGvBfdpNyD0X0=;
 b=VJ7clISYCYh2ePzcK0q0325DspjddVmPuB8iJN7H44CzAPnvAWkCAofSlDy4A6e47RBF
 AEkb1TtiKU4j+apBI1HGX9ANSS1qrRq96BeD+mHbYOfL5VF7Or/wf+h1nIgp6vrZTggT
 U/JtKsFXxNvYzp7TJoM+cLfdWJLGyimUsfYituLpqO/zTupdw3utpPcx8wtf0w6/VKvF
 RrrmgHmPARoJ1/RVLguFVP0Du8UHtifq8gyinTCFHunNxsAiXhtDUONoa1VP08Q6gTZT
 ndSGeTWonSIGrmqMH6LVCjF7oNbf4ihCu5Pp+TKLrI5l1/82v66cnAwnXK9ICPjHBkm4 Xg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqgbg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:23 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:21 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 811DB3F703F;
        Wed,  2 Sep 2020 09:58:19 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 5/8] qede: Notify qedr when mtu has changed
Date:   Wed, 2 Sep 2020 19:57:38 +0300
Message-ID: <20200902165741.8355-6-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MTU change on ethtool is currently not supported for iWARP.
Notify qedr driver so that appropriate logging can take
place.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c |  4 +++-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c    | 17 +++++++++++++++++
 include/linux/qed/qede_rdma.h                   |  4 +++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index b9aa6384563b..bedbb85a179a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1026,7 +1026,9 @@ int qede_change_mtu(struct net_device *ndev, int new_mtu)
 	args.u.mtu = new_mtu;
 	args.func = &qede_update_mtu;
 	qede_reload(edev, &args, false);
-
+#if IS_ENABLED(CONFIG_QED_RDMA)
+	qede_rdma_event_change_mtu(edev);
+#endif
 	edev->ops->common->update_mtu(edev->cdev, new_mtu);
 
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 769ec2f4d0b7..2f6598086d9b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -234,6 +234,15 @@ static void qede_rdma_changeaddr(struct qede_dev *edev)
 		qedr_drv->notify(edev->rdma_info.qedr_dev, QEDE_CHANGE_ADDR);
 }
 
+static void qede_rdma_change_mtu(struct qede_dev *edev)
+{
+	if (qede_rdma_supported(edev)) {
+		if (qedr_drv && edev->rdma_info.qedr_dev && qedr_drv->notify)
+			qedr_drv->notify(edev->rdma_info.qedr_dev,
+					 QEDE_CHANGE_MTU);
+	}
+}
+
 static struct qede_rdma_event_work *
 qede_rdma_get_free_event_node(struct qede_dev *edev)
 {
@@ -287,6 +296,9 @@ static void qede_rdma_handle_event(struct work_struct *work)
 	case QEDE_CHANGE_ADDR:
 		qede_rdma_changeaddr(edev);
 		break;
+	case QEDE_CHANGE_MTU:
+		qede_rdma_change_mtu(edev);
+		break;
 	default:
 		DP_NOTICE(edev, "Invalid rdma event %d", event);
 	}
@@ -338,3 +350,8 @@ void qede_rdma_event_changeaddr(struct qede_dev *edev)
 {
 	qede_rdma_add_event(edev, QEDE_CHANGE_ADDR);
 }
+
+void qede_rdma_event_change_mtu(struct qede_dev *edev)
+{
+	qede_rdma_add_event(edev, QEDE_CHANGE_MTU);
+}
diff --git a/include/linux/qed/qede_rdma.h b/include/linux/qed/qede_rdma.h
index 072da2f6da37..0d5564a59a59 100644
--- a/include/linux/qed/qede_rdma.h
+++ b/include/linux/qed/qede_rdma.h
@@ -20,7 +20,8 @@ enum qede_rdma_event {
 	QEDE_UP,
 	QEDE_DOWN,
 	QEDE_CHANGE_ADDR,
-	QEDE_CLOSE
+	QEDE_CLOSE,
+	QEDE_CHANGE_MTU,
 };
 
 struct qede_rdma_event_work {
@@ -54,6 +55,7 @@ void qede_rdma_dev_event_open(struct qede_dev *dev);
 void qede_rdma_dev_event_close(struct qede_dev *dev);
 void qede_rdma_dev_remove(struct qede_dev *dev, bool recovery);
 void qede_rdma_event_changeaddr(struct qede_dev *edr);
+void qede_rdma_event_change_mtu(struct qede_dev *edev);
 
 #else
 static inline int qede_rdma_dev_add(struct qede_dev *dev,
-- 
2.14.5

