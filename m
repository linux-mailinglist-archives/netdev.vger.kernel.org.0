Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009E41A5A1A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgDKXkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbgDKXHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F19F720708;
        Sat, 11 Apr 2020 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646437;
        bh=s9qANytsOfkyFxVEfILbbK+MZLjEYum/Vx6saCO1g3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6SAiB4nu3PXh451RAPIEvLeDwXFUUzaoJB3W4yQH5eAt4z24YsviP5LHwV5NWxKq
         Itq3EHPcn4BWGDHZk9k4/ewCNwgZpjwZ7gmYl1Gs92FCru4m4TxznCzb8roGcCI2V5
         sGcyo9XDy08FpxKo2WbH5eRbZiKg5jQMFPH4ZH1o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 009/121] ionic: check for NULL structs on teardown
Date:   Sat, 11 Apr 2020 19:05:14 -0400
Message-Id: <20200411230706.23855-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit a4674f34711b96b65bdc4d54eca88d2fd123bbc6 ]

Make sure the queue structs exist before trying to tear
them down to make for safer error recovery.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 26 ++++++++++---------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  7 ++++-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ef82587133696..f3b164e4585eb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -318,19 +318,21 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 		lif->adminqcq = NULL;
 	}
 
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->rxqcqs[i].stats)
-			devm_kfree(dev, lif->rxqcqs[i].stats);
-
-	devm_kfree(dev, lif->rxqcqs);
-	lif->rxqcqs = NULL;
-
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->txqcqs[i].stats)
-			devm_kfree(dev, lif->txqcqs[i].stats);
+	if (lif->rxqcqs) {
+		for (i = 0; i < lif->nxqs; i++)
+			if (lif->rxqcqs[i].stats)
+				devm_kfree(dev, lif->rxqcqs[i].stats);
+		devm_kfree(dev, lif->rxqcqs);
+		lif->rxqcqs = NULL;
+	}
 
-	devm_kfree(dev, lif->txqcqs);
-	lif->txqcqs = NULL;
+	if (lif->txqcqs) {
+		for (i = 0; i < lif->nxqs; i++)
+			if (lif->txqcqs[i].stats)
+				devm_kfree(dev, lif->txqcqs[i].stats);
+		devm_kfree(dev, lif->txqcqs);
+		lif->txqcqs = NULL;
+	}
 }
 
 static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 3590ea7fd88a3..ab30448176c26 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -236,11 +236,16 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 
 static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
-	struct ionic_queue *adminq = &lif->adminqcq->q;
+	struct ionic_queue *adminq;
 	int err = 0;
 
 	WARN_ON(in_interrupt());
 
+	if (!lif->adminqcq)
+		return -EIO;
+
+	adminq = &lif->adminqcq->q;
+
 	spin_lock(&lif->adminq_lock);
 	if (!ionic_q_has_space(adminq, 1)) {
 		err = -ENOSPC;
-- 
2.20.1

