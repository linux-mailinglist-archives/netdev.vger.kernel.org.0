Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B75227298
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGTXAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgGTXAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:00:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF9C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 1so9803774pfn.9
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hgGJxNpxNWjIMuIZiMd01yWl7Sc2S5Kf3lt0Xgc4yUQ=;
        b=pq+yiVK1TX8pphNl+PYePvucprTa3zdzyMbWcTp0fSEvHySs/4ipydJs4PAXEw833G
         JV+o2dySitWZYLBvZYIS8bjnogpmV4Ld6lVTbVV6mJyn5F3Q6tWmNKmkUfX8CESXmS5s
         W6PuaxaH+LLty25xLLLuBrNDT+mDzhQcldWk6q1kHpYldTHROQbN2hCiJByxMDEn0zZl
         B8z6SF3Ucu/Aor3jwHHesdH+Kj3P5O/t/7J+AuTPUk+nCJS1JVqMSx0VquLq2I0rGq1J
         7Zi1VeS73fY/5Mi4aIROq4zicUnRZ9QasSgca36D3yfSBirqLNMF70S1FO6/10WqPR9a
         l0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hgGJxNpxNWjIMuIZiMd01yWl7Sc2S5Kf3lt0Xgc4yUQ=;
        b=DlywdGoz9kWj4HtSyuLES8p3Moq/+02ea4UPb8tEQKCl/y+jnkSAOdj67vbgFxXp/5
         YLdZw4ELTnBJfq0B1ptPiN38htdLhB6rgVkO1eDBwDPb0loPViSJ6KSqhJX/fXB96mCS
         9FvBcw8U2Qw+rzCb9fe+hlAsoWRGarJezrJavnVbmf1UP81W3f9FPk8I9D2w3so44jc2
         4sEj9xDedTVeq5ATFfNCXyVsoiFLVMqywfOPTf+GQTNWKgQmcTQ33nkNP4m0d1+H2oz0
         d/tDwmrAAMj/9fWl0yPQQsr0PKLVNjlIHS/ddvpcJvLDNSVL4MEsvf6IE1uMjLIIo8AU
         0Fcg==
X-Gm-Message-State: AOAM5304/uVJqb5jmqOp9frqFE/6BttrE+ZAuFz92wU8mUVnAAkWGzx3
        +54Hl7x4THk2wuXe/70R9lGpL95hFmc=
X-Google-Smtp-Source: ABdhPJz387FSd08CtI2X0IEQ3WC1dI1ONjkNsQ8abotSUWVElwRMdDL5HmOkaBANqRHF159R0Y03Kg==
X-Received: by 2002:a63:d1f:: with SMTP id c31mr19510950pgl.27.1595286032952;
        Mon, 20 Jul 2020 16:00:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n9sm606738pjo.53.2020.07.20.16.00.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:00:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 4/5] ionic: keep rss hash after fw update
Date:   Mon, 20 Jul 2020 16:00:16 -0700
Message-Id: <20200720230017.20419-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720230017.20419-1-snelson@pensando.io>
References: <20200720230017.20419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the RSS hash key is kept across a fw update by not
de-initing it when an update is happening.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 41e86d6b76b6..ddb9ad5b294c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2277,11 +2277,10 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 		cancel_work_sync(&lif->deferred.work);
 		cancel_work_sync(&lif->tx_timeout_work);
 		ionic_rx_filters_deinit(lif);
+		if (lif->netdev->features & NETIF_F_RXHASH)
+			ionic_lif_rss_deinit(lif);
 	}
 
-	if (lif->netdev->features & NETIF_F_RXHASH)
-		ionic_lif_rss_deinit(lif);
-
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
-- 
2.17.1

