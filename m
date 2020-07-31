Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61B1233C5D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgGaAB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730767AbgGaAB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:01:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129DBC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r4so5084162pls.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ji45wpS231u5wkVoxPXZFgb0WawlUJO4xkSAUebuYLA=;
        b=kSM2NiH+8CRvyj0pRQ16h8vlgcmB4ONAIB96M5+L0NIcyWP2+WLB1gnhPKGPA2fz3H
         lg5jVOKW7GwxZLLnkCYtXH70H6d655DYlmjZ1YjNdd7yXQqkbCB1nwxhu6f7IvvHGzpF
         UmAM0N04/LwXAIfw2blsP1hey9/DNdIQQtAs1VYcx6autoPLDQltUyFGol2sf0BeF/Cj
         hfD9FAYeqvqXw5suacuQuUJXY/m/KzszzBcLpSYf86KQKZHX40U2sYWI5OMSv551yYTQ
         JncaM2aR0R5l+kMr64Rzbs+jSHodlDWSvFnTLQ44Q9sTFux+skoYxt5WlZU40vV/+RkA
         9Ocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ji45wpS231u5wkVoxPXZFgb0WawlUJO4xkSAUebuYLA=;
        b=X5M1Y4iHAm7KDPVPi5niUqaLGS1bhKyWX3q3CsSUzNC0P2gIRxftHW6UJaKfgB6s56
         yKk0gysahW95B8VaV9dFe8kf3G9k3vWaKKpo4UjCYMUxdI/hnzlD2PVMW31hudF6lSbH
         jCUGL7mHOzaeCPN0rCiQhoTOU2LZUvhbkY75NaUgiaPzous3cpR2UpIXoIFr0RANIFTJ
         McXxPmU/sYgTxisjxo4sU20QNhDIobpp+ZnOXNObNFO79a67GQ/jwcY/tYa4fMtDW6cA
         DG++mWlGbRtYdcu+7+OFiP2z2pNcxk/W99wA3Q25w5doM/7dmmqr1XJDchRg4dwf5ee6
         2NNw==
X-Gm-Message-State: AOAM531b7sT2YVU81ofKNWn8KPEvISXudye3ssZzU9MXlStgb+o2o2k5
        iq7OkR1033heaozY3srgReVJiAuEeps=
X-Google-Smtp-Source: ABdhPJzzjX3g+4JDrzP+E39hr4pt7zhDhBedj45P4Ft1dvNligNPTuEQwHyoqDKf9BrVqrOnGfgaHg==
X-Received: by 2002:a62:3246:: with SMTP id y67mr1224142pfy.131.1596153685341;
        Thu, 30 Jul 2020 17:01:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm7592436pgf.53.2020.07.30.17.01.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 17:01:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/3] ionic: use fewer firmware doorbells on rx fill
Date:   Thu, 30 Jul 2020 17:00:56 -0700
Message-Id: <20200731000058.37344-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731000058.37344-1-snelson@pensando.io>
References: <20200731000058.37344-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We really don't need to hit the Rx queue doorbell so many times,
we can wait to the end and cause a little less thrash.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 85eb8f276a37..e660cd66f9a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -331,9 +331,6 @@ static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
 	__free_page(page);
 }
 
-#define IONIC_RX_RING_DOORBELL_STRIDE		((1 << 5) - 1)
-#define IONIC_RX_RING_HEAD_BUF_SZ		2048
-
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
@@ -345,7 +342,6 @@ void ionic_rx_fill(struct ionic_queue *q)
 	unsigned int remain_len;
 	unsigned int seg_len;
 	unsigned int nfrags;
-	bool ring_doorbell;
 	unsigned int i, j;
 	unsigned int len;
 
@@ -360,9 +356,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 		page_info = &desc_info->pages[0];
 
 		if (page_info->page) { /* recycle the buffer */
-			ring_doorbell = ((q->head->index + 1) &
-					IONIC_RX_RING_DOORBELL_STRIDE) == 0;
-			ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, NULL);
+			ionic_rxq_post(q, false, ionic_rx_clean, NULL);
 			continue;
 		}
 
@@ -401,10 +395,11 @@ void ionic_rx_fill(struct ionic_queue *q)
 			page_info++;
 		}
 
-		ring_doorbell = ((q->head->index + 1) &
-				IONIC_RX_RING_DOORBELL_STRIDE) == 0;
-		ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, NULL);
+		ionic_rxq_post(q, false, ionic_rx_clean, NULL);
 	}
+
+	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+			 q->dbval | q->head->index);
 }
 
 static void ionic_rx_fill_cb(void *arg)
-- 
2.17.1

