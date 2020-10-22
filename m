Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C580A2967C2
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373644AbgJVXz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373630AbgJVXzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 19:55:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A3AC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e15so2328147pfh.6
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jRLTvXXWxxm1oTRZxFy/Nx+xnD8pQIKiy6bO0kS1ddY=;
        b=gua+ljTga9Ve8g5FqyRbi3YbduuK40hT5tIUBCciqOlxGv+lp9DkaRB0dDIDHaD1WE
         YUmRbgex7dA7yKpzoeyoIeW4vvnnSefwCckd6alJypKu9VctpJfCTtGF7U9kF6lgftmd
         cKJ8umQsHLaJGjBFuQqxJERdIoKpwSRPdLTG6GFTaTG5UoV8qBp0t+Ykk3aC9OXXa7mV
         2BD1lI80N/k4Fm5OsxK3gbfNuwALGGOQmQc0k5wOGQvbCdb/0h2JJGkZ5QyhSUX62OPw
         XmUX40rosT+3yGWvLcpIAf8fNl1wh3d9omdN3xcIdhxM87yH26MM0fqECiKHQ/jdQVMA
         wBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jRLTvXXWxxm1oTRZxFy/Nx+xnD8pQIKiy6bO0kS1ddY=;
        b=Lj6H6o5AXfLGVgOUG6qPWgVR3MWHZ1+DYKC5icnWeHnzDK2LrVJlvzw4NZFV8R2Yn9
         hhLwg81u50eP6UMOPVthLMAu2GiG0rMGPcpSjtdg+R3pIHoR3+jWndDDB27auPFUFJm0
         wgBuqeAi8Dkd3hg7diV6s2+PyarLHEsm6AzUSdXyXLlUdbH1NZEpkX3U7JL5cZEk27TU
         sXJFPQQQr0itVLLQHjnhb3PoxMTuykqD9AddYI5fMysWgYlK8SwzJidiNi3Z0Xl9AlSa
         Wwkf2xWAKFfmlsmRhDXQOhMkZgW01nEsipuZfpdMg6ez2UhOOYPL05+hDhNdpSaijijh
         0P2w==
X-Gm-Message-State: AOAM531JjS07Zmpdoxo2psGhzzM9LImGdsQ3rXUujB2/mKF0FNBJPkj3
        hNtMVPrraROsDuj4Q2+eF1SJYVSaCyl4Tg==
X-Google-Smtp-Source: ABdhPJy4Muug7dF5zqz6rYrBHayQ1PyKsYneMGghZBuOtoMabFNwG/EpVARp41y9jV08Xh3W2HN1iQ==
X-Received: by 2002:aa7:9a87:0:b029:156:5806:b478 with SMTP id w7-20020aa79a870000b02901565806b478mr4676161pfi.8.1603410953811;
        Thu, 22 Oct 2020 16:55:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v3sm3167244pfu.165.2020.10.22.16.55.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 16:55:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/3] ionic: no rx flush in deinit
Date:   Thu, 22 Oct 2020 16:55:30 -0700
Message-Id: <20201022235531.65956-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201022235531.65956-1-snelson@pensando.io>
References: <20201022235531.65956-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kmemleak pointed out to us that ionic_rx_flush() is sending
skbs into napi_gro_XXX with a disabled napi context, and these
end up getting lost and leaked.  We can safely remove the flush.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  |  1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 13 -------------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h |  1 -
 3 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 591c644b8e69..a12df3946a07 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1656,7 +1656,6 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs && lif->rxqcqs[i]; i++) {
 			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i]);
-			ionic_rx_flush(&lif->rxqcqs[i]->cq);
 			ionic_rx_empty(&lif->rxqcqs[i]->q);
 		}
 	}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 8f6fc7142bc5..35acb4d66e31 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -253,19 +253,6 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
-void ionic_rx_flush(struct ionic_cq *cq)
-{
-	struct ionic_dev *idev = &cq->lif->ionic->idev;
-	u32 work_done;
-
-	work_done = ionic_cq_service(cq, cq->num_descs,
-				     ionic_rx_service, NULL, NULL);
-
-	if (work_done)
-		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
-				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
-}
-
 static int ionic_rx_page_alloc(struct ionic_queue *q,
 			       struct ionic_page_info *page_info)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index a5883be0413f..7667b72232b8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -4,7 +4,6 @@
 #ifndef _IONIC_TXRX_H_
 #define _IONIC_TXRX_H_
 
-void ionic_rx_flush(struct ionic_cq *cq);
 void ionic_tx_flush(struct ionic_cq *cq);
 
 void ionic_rx_fill(struct ionic_queue *q);
-- 
2.17.1

