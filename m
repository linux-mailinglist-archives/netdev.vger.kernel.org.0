Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D23DA251
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhG2LnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:43:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45746 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233949AbhG2LnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:43:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TBeWv1031429;
        Thu, 29 Jul 2021 04:43:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=9j2hBJ+4DOURcrYXjXlrKslGyC8de7rrtmRyZ2NgQwE=;
 b=CO7wJdMw2GEo0kTajdlAOJs1Vot2AQ7Tebzmu2R+1yr2aqpEJwgSij1OJ/nCG0KN+0rX
 hWWB8ZmrU+/yd9Rv15inTU/FmooKMVgIQknuUsxm5kY4tn7jDgcjgyofD8ztp282vHS5
 +Wg2VgE1c9jB+qpxzSKbiJPvgnnxKHKDHQs3dpl+IBZWrncct9uZL9g3gghFmirhFKDL
 TfacXS3840E3UAjSJZmadt2Ho4WoVXll8IEUA41ANDfwPA7VuTn+ZbOdzJb/vcVWpqVf
 Zq1Am4ugl2OwyPYVvaF3JQBCmuit0rmv2o4cWHO21bp3pDOseaGXUQz7Dkv/3NaI97p5 Kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a35pr4fu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 04:43:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 29 Jul
 2021 04:43:14 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 29 Jul 2021 04:43:11 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <smalin@marvell.com>, <aelior@marvell.com>,
        <pkushwaha@marvell.com>, <prabhakar.pkin@gmail.com>,
        <malin1024@gmail.com>, Alok Prasad <palok@marvell.com>
Subject: [PATCH] qede: fix crash in rmmod qede while automatic debug collection
Date:   Thu, 29 Jul 2021 14:43:06 +0300
Message-ID: <20210729114306.21624-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XBK4NhEeaj9HmB-hKVRg7Mlk3hCyL1am
X-Proofpoint-GUID: XBK4NhEeaj9HmB-hKVRg7Mlk3hCyL1am
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A crash has been observed if rmmod is done while automatic debug
collection in progress. It is due to a race  condition between
both of them.

To fix stop the sp_task during unload to avoid running qede_sp_task
even if they are schedule during removal process.

Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      | 1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c4eb63..5630008f38b7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -501,6 +501,7 @@ struct qede_fastpath {
 #define QEDE_SP_HW_ERR                  4
 #define QEDE_SP_ARFS_CONFIG             5
 #define QEDE_SP_AER			7
+#define QEDE_SP_DISABLE			8
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 173878696143..6a4bc7652d2e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1009,6 +1009,13 @@ static void qede_sp_task(struct work_struct *work)
 	struct qede_dev *edev = container_of(work, struct qede_dev,
 					     sp_task.work);
 
+	/* Disable execution of this deferred work once
+	 * qede removal is in progress, this stop any future
+	 * scheduling of sp_task.
+	 */
+	if (test_bit(QEDE_SP_DISABLE, &edev->sp_flags))
+		return;
+
 	/* The locking scheme depends on the specific flag:
 	 * In case of QEDE_SP_RECOVERY, acquiring the RTNL lock is required to
 	 * ensure that ongoing flows are ended and new ones are not started.
@@ -1300,6 +1307,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	qede_rdma_dev_remove(edev, (mode == QEDE_REMOVE_RECOVERY));
 
 	if (mode != QEDE_REMOVE_RECOVERY) {
+		set_bit(QEDE_SP_DISABLE, &edev->sp_flags);
 		unregister_netdev(ndev);
 
 		cancel_delayed_work_sync(&edev->sp_task);
-- 
2.24.1

