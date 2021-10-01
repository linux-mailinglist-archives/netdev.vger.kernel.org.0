Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB8041F456
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355685AbhJASI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355679AbhJASI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9DEC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 187so4224112pfc.10
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VHi0FGi5BNMtMMLCrl7W3BvEhWF3YSB2couJYk4G4rc=;
        b=F/D57FWt3QWmIC+8yHjUz73UjgsHDYYU8uzXNCkchTnCEgTarhZw07IGlIxYLGY6Id
         QdL4KDAlFpK3oFhKfw9FkpKNPhfGhVz22lWwy2aXQSduFqVGOCx60akoc1jvFMtY1Rys
         Xfz1s/k+KOQnC52v/helwpW+M+nhppeg/NAQzN/2ooYwkfU7SEjqfFEhnquqJ91ONopA
         pusL17i5tPO6PQCM+j486LR4zdRyvwdG+S86lrNxIzKAQwaSJRydBLANlv+620kuu5P/
         XIE2hd+HHPf6FV4O4CIm2pHFOrOv7yQ5374MmHoNv5wCNnp6H18ua0iDw4dI8uaWSRN5
         J4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VHi0FGi5BNMtMMLCrl7W3BvEhWF3YSB2couJYk4G4rc=;
        b=Vua3c6V+Ysu4fiB8pdH/DQwhBrAH9sgImE/hLLd9ektPA0oz/Kj2Q9LC1ybzP9DgAr
         mgWFHo99FwnWrJIg/YuSZBWwl3bfLmFQ4s7Q5xNnzxDlV0V3gM8mn6DmKzwqjkHJaGaG
         UpNDU99dMasFGTa89mvmnTFHWZknn7oOGYk/mkYry/CaykF8dLgYoBLJYidb+2tC8SHR
         utSUc572As2ZlDuErkQc1KFHMu4NQN9Q/xzUYrxQzLkZzhU8qWrCFC1wgjI7oHQL5IaV
         OGdoL62dq1DUNTqlBGgAoq5OA6EI+IPOjyLdjXIHJ15fb3x+MMcclYBINvCgnVkx5jEn
         aHJQ==
X-Gm-Message-State: AOAM531UA7RdoXNWDrMA7KaxYsoKLk2RUjsWqNi/ZlqBc2MdWZvrqFN6
        xI0svbItLsCGXopa9bDWZ5qUhg==
X-Google-Smtp-Source: ABdhPJww8I4jje5qUWdUFGWWgZSD5whs4JBxgyXe6rDif4bjWqDm18aafzJXurLv1wsxH2E9NKKkRw==
X-Received: by 2002:aa7:8116:0:b0:44b:e0d1:25e9 with SMTP id b22-20020aa78116000000b0044be0d125e9mr12628924pfi.53.1633111601703;
        Fri, 01 Oct 2021 11:06:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/7] ionic: move lif mutex setup and delete
Date:   Fri,  1 Oct 2021 11:05:53 -0700
Message-Id: <20211001180557.23464-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move creation and deletion of lif mutex a level out to
lif creation and delete, rather than in init and deinit.
This assures that nothing will get hung if anything is waiting
on the mutex while the driver is clearing the lif while handling
the fw_down/fw_up cycle.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 381966e8f557..4f28cd3ea454 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2890,6 +2890,9 @@ int ionic_lif_alloc(struct ionic *ionic)
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", lif->index);
 
+	mutex_init(&lif->queue_lock);
+	mutex_init(&lif->config_lock);
+
 	spin_lock_init(&lif->adminq_lock);
 
 	spin_lock_init(&lif->deferred.lock);
@@ -2903,7 +2906,7 @@ int ionic_lif_alloc(struct ionic *ionic)
 	if (!lif->info) {
 		dev_err(dev, "Failed to allocate lif info, aborting\n");
 		err = -ENOMEM;
-		goto err_out_free_netdev;
+		goto err_out_free_mutex;
 	}
 
 	ionic_debugfs_add_lif(lif);
@@ -2938,6 +2941,9 @@ int ionic_lif_alloc(struct ionic *ionic)
 	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
 	lif->info = NULL;
 	lif->info_pa = 0;
+err_out_free_mutex:
+	mutex_destroy(&lif->config_lock);
+	mutex_destroy(&lif->queue_lock);
 err_out_free_netdev:
 	free_netdev(lif->netdev);
 	lif = NULL;
@@ -3078,6 +3084,9 @@ void ionic_lif_free(struct ionic_lif *lif)
 	kfree(lif->dbid_inuse);
 	lif->dbid_inuse = NULL;
 
+	mutex_destroy(&lif->config_lock);
+	mutex_destroy(&lif->queue_lock);
+
 	/* free netdev & lif */
 	ionic_debugfs_del_lif(lif);
 	free_netdev(lif->netdev);
@@ -3100,8 +3109,6 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
-	mutex_destroy(&lif->config_lock);
-	mutex_destroy(&lif->queue_lock);
 	ionic_lif_reset(lif);
 }
 
@@ -3267,8 +3274,6 @@ int ionic_lif_init(struct ionic_lif *lif)
 		return err;
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
-	mutex_init(&lif->queue_lock);
-	mutex_init(&lif->config_lock);
 
 	/* now that we have the hw_index we can figure out our doorbell page */
 	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
-- 
2.17.1

