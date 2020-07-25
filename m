Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF08C22D33B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGYAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYAXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:23:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E324C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:35 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k1so6271268pjt.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KYd/RMlBdU9HW5AsgN1QsHGgXc2yotOVv6X0bLRYMJA=;
        b=TRba02OHUQmzOFTYU+demYuux4uy63AkvlUtFOamE0/oLidy2RWloA26AsCk0echf4
         jOXtAoLfiaVkVw0hkE46gfDDfrDG1qfslU101UFq6QnLpZBsMB/nLxg8bom9BYrNIa9n
         XUBg8Au+ol/OuCSJruAqyGpJK9rXWc05N5hrH2CjB/OnvnLMKbVgwrWtpyuun9entMFe
         9WhaNJbuTvERZDOd+yHIfXmi3Owyx6Cw0DKkoyK1s1zCnbKPtueJ3kfAOeanxwWWazWf
         VXu0a++v1c9wPzhfXV2uCH/3p2YRKA5o/X2LnSrI6NLvkefY8d7T8sf99asA56ILfPXR
         fvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KYd/RMlBdU9HW5AsgN1QsHGgXc2yotOVv6X0bLRYMJA=;
        b=pIeb0UTEiCUrB7A4Hk8TtIkVq2Zo0CfhrGx2Ei7pk7Pp7O/r0EZ8dQH9r06JG566Pj
         kYCgmezQ9EfGRsfgGxKCdGag4nBLSO5+cbLPuj+curN0DldDJ6bkDy7q1bYIqK8kaEKf
         wcD0ObL05y4laMi6EdjbYR1MpvJXHjPhfu6mAGW5mcC/NNUE0b+BBINBz+NtCKa1uckZ
         XIsibFQUg9lN3iEUMgl8zf/paByCkonokrHIhuSVHus5QGAk2nO7RVa+BdkUQPDrOtSf
         WynOS3S2s9Vccedns+9lIVWAXKytDbFFMYql5pA0GtUY1RsR/hY/IhVDsQR8PobEPIsa
         U4tQ==
X-Gm-Message-State: AOAM533EIbqxQvPg8YCy16+D6V3QLw1f35A02yEdg0PGSsOrl68sREBh
        6KL7DMaZ2ORkTmfU1/CVNh3WRKbKcE0=
X-Google-Smtp-Source: ABdhPJwwoPlVOw9p2LDe+eivaExYsV2AkgBF25jUK+/bNCu7CdQTH71PRsgDr7tEtWUXr5ZC3i4fag==
X-Received: by 2002:a17:902:a388:: with SMTP id x8mr10224830pla.159.1595636614372;
        Fri, 24 Jul 2020 17:23:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id lr1sm8400368pjb.27.2020.07.24.17.23.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 17:23:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/4] ionic: use fewer firmware doorbells on rx fill
Date:   Fri, 24 Jul 2020 17:23:23 -0700
Message-Id: <20200725002326.41407-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725002326.41407-1-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
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
index b7f900c11834..cbca749d1b7f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -337,9 +337,6 @@ static void ionic_rx_page_free(struct ionic_queue *q, struct page *page,
 	__free_page(page);
 }
 
-#define IONIC_RX_RING_DOORBELL_STRIDE		((1 << 5) - 1)
-#define IONIC_RX_RING_HEAD_BUF_SZ		2048
-
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
@@ -351,7 +348,6 @@ void ionic_rx_fill(struct ionic_queue *q)
 	unsigned int remain_len;
 	unsigned int seg_len;
 	unsigned int nfrags;
-	bool ring_doorbell;
 	unsigned int i, j;
 	unsigned int len;
 
@@ -366,9 +362,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 		page_info = &desc_info->pages[0];
 
 		if (page_info->page) { /* recycle the buffer */
-			ring_doorbell = ((q->head->index + 1) &
-					IONIC_RX_RING_DOORBELL_STRIDE) == 0;
-			ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, NULL);
+			ionic_rxq_post(q, false, ionic_rx_clean, NULL);
 			continue;
 		}
 
@@ -407,10 +401,11 @@ void ionic_rx_fill(struct ionic_queue *q)
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

