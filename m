Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0518C54F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCTCcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:11 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54767 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgCTCcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:07 -0400
Received: by mail-pj1-f67.google.com with SMTP id np9so1835003pjb.4
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qLfC4IEo6kThpOF/F41+wWQG9McBRedKRA2BMoUFuX0=;
        b=F+Dq6NPE3YUYAB9iSfXCO9SGcpsaO6C9lDA1BnEYE9Rzl8qxXDlKADygj+R1witPh1
         5aIK/mmBL0pLVNuBjvS5XKP2cn5l1NXDxFFbdqPpFwbjz51QNUq7vHHdNO3O9ZdVuli4
         crpF2I/A4LvL9FgzF/YTjUH4Wji32FtvgqTYbdnvkrOk6knyDyCf3QLNwkoiziM1yjKo
         +3z5zqeo6fYhPjm7BRFKLfZRKvCHGo/CfVvi6IDjJCM0Te2XMUy9ZYH2ncsVD2IsU34a
         9SeomoNvs37nCQVdI+v+vGj2+CrNHq1tzvMowqYdVcCm+w/ROBTKLIaabQOa8zKNtwHd
         tipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qLfC4IEo6kThpOF/F41+wWQG9McBRedKRA2BMoUFuX0=;
        b=XZeH6/D2rQc3cTmbwj4imPwUlAYlFtt5bY0T8J1QCzhVW58t/OQeNZjW5EgKLFXv5N
         s1BojpskSg3hu/MnuZ0hkwIsl31L0mCMWN0xlUXx3Nk4/xZLSQ7NSK0pw4yCG62iYH9c
         91QyJ+X4SRQiARrNXmm2UFxfI1hyNyG+Q6aIE+m/IjghKpzrRBjBEoO6c6mXb8OuK8Yl
         Wz2xBLiMvpzOOK4yNCfSRqcYmmB0xlRV1dasPzR1k+lyszmVNOODr+hMkvrmnn0IM0c0
         8sjwMRsruK/LTCQoITTF1xIDBBizTxFGzvNumd7ToRiZo65cYbmRnubH51HVTx6k6WCb
         aNow==
X-Gm-Message-State: ANhLgQ2MFx/6rZ2KJO08mfwbtcq1k005XornT3bQ+yqgzeJV1GLLpWEz
        wEXBmXK1Zy37uv//oxsVxl/utgOsAWA=
X-Google-Smtp-Source: ADFU+vsPb1qz0gHkUFrsnuSU91KnBwq2QkdwZ8egStdeclaGdUu8IL7em0so3NpNaBCDw/7uu6wFcQ==
X-Received: by 2002:a17:902:562:: with SMTP id 89mr6074149plf.249.1584671525717;
        Thu, 19 Mar 2020 19:32:05 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/6] ionic: check for NULL structs on teardown
Date:   Thu, 19 Mar 2020 19:31:53 -0700
Message-Id: <20200320023153.48655-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the queue structs exist before trying to tear
them down to make for safer error recovery.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 26 ++++++++++---------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  7 ++++-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 490f79c82bf1..8b442eb010a2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -320,19 +320,21 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
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
index a0dc100b12e6..c16dbbe54bf7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -243,11 +243,16 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 
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
2.17.1

