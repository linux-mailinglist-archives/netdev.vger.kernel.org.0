Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA7F196353
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgC1DPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:15:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37621 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgC1DPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:15:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id x1so4224206plm.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MgUcrpqNSmqFO0JH+4v3tmB8rfiwibCBHNsCMcSszRo=;
        b=l2np7HKlbFxVkK3dpSmhVIS0Y5bfDKK8sp7ur/D8Qh3BXopxfaVwA9BIkvrvL6gM4L
         mKr/EOgyS+nLbxk/jTLPT2nGe/m4rCeWfN4KHHtY5IyzVxBWJYVHBeMtUq/OvKt489u4
         mhQgGy7+WEGYpdbLCOOS6BRLT0iGIyy/d1to7i/BxhsoOsu6mpT5RTR+SyUXkK7KDSEw
         MMvfYHFu14MFXZG7TMV9OueIW99oZuuvHw4/XOjJiHkoQ3sDq6+TxCT0y4lc8tOoLWBd
         50id4PJjv335IiZBRbLDnlgBWLh1psNglKELq3HNZJkTakGQ5/pc8UNGWKVA+95ZOZks
         Ckgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MgUcrpqNSmqFO0JH+4v3tmB8rfiwibCBHNsCMcSszRo=;
        b=MBRQAml1HtTI1W+CnOQotbFAi8tEKUCVeJ6CcZ2sbRDjdYxJQI3S7Mdv9fKMhxt/7n
         zONRjj2YKIWS2+xBGGo+zf3IL4/t11vpS/yOuyakl4fx+d/gZgBc44TsZhoJTrFgFFKt
         oRYM3sqjnU7MisaoB8BumDfQcO9oNzBtaYAUAm20O1CL+qsSW98sCDe0KDFfNqNOogjm
         XowsUFkXhJpzW2xMhDQLN4mTqIyMPOsUJkuOA/dovOMPiLoFtJpewf8hCSSb8i5lGggp
         Zr221aAt3WkJNp8HPPe3uCYqe7ZL8BanyqBoOxIpUs6fPgaug7zBaSYzReTia1TCeDmE
         LNVw==
X-Gm-Message-State: ANhLgQ1laNqkJidljAnmt2OdzUpkvrEYQpJkoCTIl9yLJhGN+aNX6MDY
        4cZa+BpRriJtwOPG91yeOZSySw==
X-Google-Smtp-Source: ADFU+vug+A5Ne07DAd2XwI54uL1GxRZBfT45mnf9vOiuSa3DJf+wt7U1VgvdrJsD5GNEuyIQhHpmog==
X-Received: by 2002:a17:90a:730b:: with SMTP id m11mr2755115pjk.195.1585365299726;
        Fri, 27 Mar 2020 20:14:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/8] ionic: check for queues before deleting
Date:   Fri, 27 Mar 2020 20:14:46 -0700
Message-Id: <20200328031448.50794-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the queue structures exist before trying
to delete them.  This addresses a couple of error
recovery issues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 57 ++++++++++++-------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2804690657fd..e2281542644b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1437,13 +1437,20 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 	unsigned int i;
 	int err;
 
-	for (i = 0; i < lif->nxqs; i++) {
-		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
-		if (err == -ETIMEDOUT)
-			break;
-		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
-		if (err == -ETIMEDOUT)
-			break;
+	if (lif->txqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+			if (err == -ETIMEDOUT)
+				break;
+		}
+	}
+
+	if (lif->rxqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+			if (err == -ETIMEDOUT)
+				break;
+		}
 	}
 }
 
@@ -1451,14 +1458,20 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 {
 	unsigned int i;
 
-	for (i = 0; i < lif->nxqs; i++) {
-		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
-		ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
-		ionic_tx_empty(&lif->txqcqs[i].qcq->q);
+	if (lif->txqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+			ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
+			ionic_tx_empty(&lif->txqcqs[i].qcq->q);
+		}
+	}
 
-		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
-		ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
-		ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
+	if (lif->rxqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
+			ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
+			ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
+		}
 	}
 }
 
@@ -1466,12 +1479,18 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 {
 	unsigned int i;
 
-	for (i = 0; i < lif->nxqs; i++) {
-		ionic_qcq_free(lif, lif->txqcqs[i].qcq);
-		lif->txqcqs[i].qcq = NULL;
+	if (lif->txqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			ionic_qcq_free(lif, lif->txqcqs[i].qcq);
+			lif->txqcqs[i].qcq = NULL;
+		}
+	}
 
-		ionic_qcq_free(lif, lif->rxqcqs[i].qcq);
-		lif->rxqcqs[i].qcq = NULL;
+	if (lif->rxqcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			ionic_qcq_free(lif, lif->rxqcqs[i].qcq);
+			lif->rxqcqs[i].qcq = NULL;
+		}
 	}
 }
 
-- 
2.17.1

