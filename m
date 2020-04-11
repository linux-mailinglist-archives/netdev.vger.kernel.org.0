Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4391A5B76
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDKXED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgDKXEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D76420CC7;
        Sat, 11 Apr 2020 23:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646242;
        bh=WC5mlF3RZoMAhnfZdMrvYguSUQNy45NeVegxFt7B9y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuLcr9ru8vvy7xQ0ctNJ7xXUoROelR0az9lKCpEpzbos0Z88VeWwyha4mRj59Unbg
         D95gCFTQEUD0hQbO4qGmzXSpUt9Fy1NeqS8Bpel4JAYjOshv/50lvtz7RBLKE1lig6
         YjcDzL5WpliwoXW73PHDNgFeNi6DIBeKVgpzVcec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 011/149] ionic: check for NULL structs on teardown
Date:   Sat, 11 Apr 2020 19:01:28 -0400
Message-Id: <20200411230347.22371-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
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
index 938e19ee0bcd2..1a569d9b0c3a0 100644
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
index a8e3fb73b4650..ee690f8f381ca 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -240,11 +240,16 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 
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

