Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE3161137
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 12:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgBQLha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 06:37:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728312AbgBQLha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 06:37:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HBRguO005555;
        Mon, 17 Feb 2020 03:37:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5iLt2WSWBadvKXVfyqIZKFReFIOMiJW2ZSOSUhU2RqM=;
 b=nPgcsM6+xCeG1PCSaf5/4i4d+bR31vEZwD44gdFxrvjWCOJjvRe82TH7Rs9ktES8fZNY
 Uv/Z90UuoIjou3C2XgG5y45dnxvAsmg/Y9R+hsbKp88s0M7AL5LYnl79/rCJg9FGI7fy
 lvPezpII9tNjMBwX91pSJPs5qVzD1kjJQ2gnJsI/ixwxKsSL5y9ijFZRQHKcG5YANmzk
 IOl/n6u28wAIiwDD8x9/yx/ZEtzb2JiFned2QTLAP8YNMCfJug1WO8RYXuCRGPSuLEeL
 aIrIPFNhHEtdu2VHsUpWYD09Or0wLuv3VGCzamPW5zC2i7DHYh1r3vRbEh9RFA0K6b75 GA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y6h1sxtt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 03:37:27 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 03:37:25 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 Feb 2020 03:37:25 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 450433F703F;
        Mon, 17 Feb 2020 03:37:24 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <aelior@marvell.com>, <michal.kalderon@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Ariel Elior <ariel.elior@marvell.com>
Subject: [PATCH net] qede: Fix race between rdma destroy workqueue and link change event
Date:   Mon, 17 Feb 2020 13:37:18 +0200
Message-ID: <20200217113718.32207-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_06:2020-02-17,2020-02-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an event is added while the rdma workqueue is being destroyed
it could lead to several races, list corruption, null pointer
dereference during queue_work or init_queue.
This fixes the race between the two flows which can occur during
shutdown.

A kref object and a completion object are added to the rdma_dev
structure, these are initialized before the workqueue is created.
The refcnt is used to indicate work is being added to the
workqueue and ensures the cleanup flow won't start while we're in
the middle of adding the event.
Once the work is added, the refcnt is decreased and the cleanup flow
is safe to run.

Fixes: cee9fbd8e2e ("qede: Add qedr framework")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 29 +++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index e8a1b27db84d..234c6f30effb 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -163,6 +163,8 @@ struct qede_rdma_dev {
 	struct list_head entry;
 	struct list_head rdma_event_list;
 	struct workqueue_struct *rdma_wq;
+	struct kref refcnt;
+	struct completion event_comp;
 	bool exp_recovery;
 };
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index ffabc2d2f082..2d873ae8a234 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -59,6 +59,9 @@ static void _qede_rdma_dev_add(struct qede_dev *edev)
 static int qede_rdma_create_wq(struct qede_dev *edev)
 {
 	INIT_LIST_HEAD(&edev->rdma_info.rdma_event_list);
+	kref_init(&edev->rdma_info.refcnt);
+	init_completion(&edev->rdma_info.event_comp);
+
 	edev->rdma_info.rdma_wq = create_singlethread_workqueue("rdma_wq");
 	if (!edev->rdma_info.rdma_wq) {
 		DP_NOTICE(edev, "qedr: Could not create workqueue\n");
@@ -83,8 +86,23 @@ static void qede_rdma_cleanup_event(struct qede_dev *edev)
 	}
 }
 
+static void qede_rdma_complete_event(struct kref *ref)
+{
+	struct qede_rdma_dev *rdma_dev =
+		container_of(ref, struct qede_rdma_dev, refcnt);
+
+	/* no more events will be added after this */
+	complete(&rdma_dev->event_comp);
+}
+
 static void qede_rdma_destroy_wq(struct qede_dev *edev)
 {
+	/* Avoid race with add_event flow, make sure it finishes before
+	 * we start accessing the list and cleaning up the work
+	 */
+	kref_put(&edev->rdma_info.refcnt, qede_rdma_complete_event);
+	wait_for_completion(&edev->rdma_info.event_comp);
+
 	qede_rdma_cleanup_event(edev);
 	destroy_workqueue(edev->rdma_info.rdma_wq);
 }
@@ -310,15 +328,24 @@ static void qede_rdma_add_event(struct qede_dev *edev,
 	if (!edev->rdma_info.qedr_dev)
 		return;
 
+	/* We don't want the cleanup flow to start while we're allocating and
+	 * scheduling the work
+	 */
+	if (!kref_get_unless_zero(&edev->rdma_info.refcnt))
+		return; /* already being destroyed */
+
 	event_node = qede_rdma_get_free_event_node(edev);
 	if (!event_node)
-		return;
+		goto out;
 
 	event_node->event = event;
 	event_node->ptr = edev;
 
 	INIT_WORK(&event_node->work, qede_rdma_handle_event);
 	queue_work(edev->rdma_info.rdma_wq, &event_node->work);
+
+out:
+	kref_put(&edev->rdma_info.refcnt, qede_rdma_complete_event);
 }
 
 void qede_rdma_dev_event_open(struct qede_dev *edev)
-- 
2.14.5

