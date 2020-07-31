Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7732E234C09
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgGaUPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgGaUPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 16:15:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14B7C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:45 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b9so17931547plx.6
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ji45wpS231u5wkVoxPXZFgb0WawlUJO4xkSAUebuYLA=;
        b=ZbojopEtoUGyayK7VxO6fOUgReSKzXUAFG2+XY/VVILYezrpcq8khMiaZ0A7HsAg7+
         wl0Cvi3nFqk1f8T9y2tl+qLSCzI9wzTZaVlZ6KgZZV1CH41fLVbUievfU3eqJtib7AL2
         5dgOOgKMPzg5VQtcQ9tTQle43ppbkgxhENl2l3W601iE8Wt8X+KR4LNjF4WdSVRwdQ7u
         YVcdrl3hnaQOBRvqjHue55Fc/QaIp0fanHiRvU62eO8dC+Cb4ZptqgspLQonmIrlpNSx
         9StzHuCFxm2AqF5PQ8be766GxHSc64n0rV9KBffHoK5JOVzN5ELIhVbh9WPiDlR1R1Th
         R3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ji45wpS231u5wkVoxPXZFgb0WawlUJO4xkSAUebuYLA=;
        b=s1fS2k4iDqvNYFoZMqX6os887O9TdU4U1fFOLxBY9+EY5A3P859nNSCDcd9tXKWsOn
         aF5gOE6PlRPhdYcr72YAz5/Ko6HAACJ6UU3po4rnrdZkjApaFlWkJbonrN9gcu50I/3e
         sUZhXQmfVT7NB/4QMv++TFVYGs8g/WAXcAL23kG+V66eAAm0yCChMwdN83jseTZozlOc
         9oZmOqaYYOsRItEe//AXVfCDbgArZxWPneqXzrxrocpxqLxCJzGO2IJ/bWFpmKKTGYCe
         95oInXv9FqTMWrE+3bTIBoZJWVMIkHJ+EL28lBdCgnTnMVXeXTqI4O/MNJPLy5cJnxMJ
         cJJg==
X-Gm-Message-State: AOAM531u6YF5zTAe+IbThMTXAe0XBLw+gL/KA1sL3zS+b4cedbbnSSLH
        RoxV0KnmECtPxkEbfujwQKJUfp2ym/Y=
X-Google-Smtp-Source: ABdhPJzOkZocrJE4zmPog3mGHXj3vDHlXES+p//OvllFHFMcAVTPVI34ZXwHGpAQWGzPLejmoM4hcw==
X-Received: by 2002:a17:902:7787:: with SMTP id o7mr5034307pll.327.1596226544813;
        Fri, 31 Jul 2020 13:15:44 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h1sm11470513pgn.41.2020.07.31.13.15.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 13:15:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/3] ionic: use fewer firmware doorbells on rx fill
Date:   Fri, 31 Jul 2020 13:15:34 -0700
Message-Id: <20200731201536.18246-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731201536.18246-1-snelson@pensando.io>
References: <20200731201536.18246-1-snelson@pensando.io>
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

