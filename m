Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B2A1A58D6
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgDKXJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbgDKXJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8261520757;
        Sat, 11 Apr 2020 23:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646595;
        bh=f0MLmxKj97w5GJet4LAXzq2Mdbp63LVfDH/sg/PQ8cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEvLZ+Bdz6JONCijsuGShYhOQepSeaZ5Pg9SQ0Sc9j8B/FyTykEmwX5UA5Uhg+xGY
         FvozwZnOfx/M93L5cBZ26iU7U9BNn9iLjX+kR+2wcUdjpAQMy/y3Bc5Hosud9Wb6vg
         MSWz8yf4c8WgM39TlTh+7eP/bB5sQcf3wEfpN/QA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 009/108] ionic: check for NULL structs on teardown
Date:   Sat, 11 Apr 2020 19:08:04 -0400
Message-Id: <20200411230943.24951-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
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
index 134640412d7b7..21e126708cc20 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -303,19 +303,21 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
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
index aab3114134128..20a384964fc52 100644
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

