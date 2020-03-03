Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C784A176C81
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgCCCs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgCCCs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E4024680;
        Tue,  3 Mar 2020 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203705;
        bh=wLAC+afq5HQkAOoxAqMTwr9NAHi/aLACIDJFseyYRps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkoxXMnrNvCpMeir6QrKWjE9s6HfddbPoLyVx4POsPqmSFMR+hvgp/+NoBsLl3Sl+
         kMyv52khUpZU2er9ABr//TShvs/Qr+6IC8iktT+wLboz3DvjXmEYEjizMbLnFs56Q3
         V7IWOwpE+uIJj8HeTJnRpZy3QYX2jRUNfWoCBPnQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 37/58] qede: Fix race between rdma destroy workqueue and link change event
Date:   Mon,  2 Mar 2020 21:47:19 -0500
Message-Id: <20200303024740.9511-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit af6565adb02d3129d3fae4d9d5da945abaf4417a ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h      |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 29 +++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index c303a92d5b06d..1f27f9866b801 100644
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
index ffabc2d2f0824..2d873ae8a234d 100644
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
2.20.1

