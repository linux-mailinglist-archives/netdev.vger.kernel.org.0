Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7402287C0
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgGURqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgGURqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82646C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d1so10584468plr.8
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hgGJxNpxNWjIMuIZiMd01yWl7Sc2S5Kf3lt0Xgc4yUQ=;
        b=JI762jpbP82js1gwc+gvE73xcCORM8WdqLgbcw1LBKE/Jr6814dxTueQ6kTQQkd5gp
         B3Au2UxBA60/d7oey6eNeRn+8MhzR7nFwWj2ZUFJ4jSL6x4ppcgwCMf91/YlQwA5Hsrt
         Pdf2keWI1futrfxbIafnpYWG/SZSYIiMipGelJu+PTE61TTrb77+fOc+aBmSpJoLXMve
         PU3gKdzt/AZsbxHzcDBOgEh4EDEXEjPXwEbZOUQQg/x4U0E2vjeTDzDfb+eEqlQZIO6n
         wczQKpPvRjNuxQ9FwgsBiaFjh7bVYEMr02OwRqOpUA0KWbrKgIMo7pnarF+z9iAd6yVJ
         n2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hgGJxNpxNWjIMuIZiMd01yWl7Sc2S5Kf3lt0Xgc4yUQ=;
        b=qsthO3UW7BBULbvWlbMsfR2i8QE1rQHSszTDyQ9ZkeQf9gAUk5Z+Poix0YUf8nuQpj
         NKFFpE0Y/tHEaCZFBXpLo8dVq+I1TDYJNxXotFJ2tsh5nWIBBwW1sdSQ65+TFY9XYpYP
         UWUh22JZ2aud7xMvSyX/9rfcgbdtDcpsCZMHyLBVb2GNOTLA5A8DxRBR6upwEWzLvK48
         akCATZ2xb+2/N/GG8g85wjilIfVrYenbOs6dsZX9cFeo0lSGCtD8jA1PVPJmya8DfsST
         9ZcO2vFDmy9aBrenn87qq9uEuEN7dyvWNQwS+ZXXhAmR2j9PNf+OVWcCRz6Cynw6x+sW
         U0QQ==
X-Gm-Message-State: AOAM5336qRwIge7cuCgZPSviPyRkycqqo5t6kyBE1l5ZEOkp445a6ErV
        EGkP/PvU5MnSXyhGNKCRUXADFIWQmFU=
X-Google-Smtp-Source: ABdhPJz8TTYjGk2lLVWUHURNwMm0xuW768Mk7QJdsd631mGZrGK/8UfBeBW8RvhWVW0C+v5cq9zNFw==
X-Received: by 2002:a17:902:bb8a:: with SMTP id m10mr5380341pls.248.1595353593377;
        Tue, 21 Jul 2020 10:46:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 5/6] ionic: keep rss hash after fw update
Date:   Tue, 21 Jul 2020 10:46:18 -0700
Message-Id: <20200721174619.39860-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
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

