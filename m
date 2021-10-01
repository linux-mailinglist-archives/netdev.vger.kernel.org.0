Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E4B41F339
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355221AbhJARkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354843AbhJARkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02CCC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:29 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id n18so10044274pgm.12
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VHi0FGi5BNMtMMLCrl7W3BvEhWF3YSB2couJYk4G4rc=;
        b=EVl2RtmdmlknZbfzvThVbgb1CGhQcKmty3bvxttgZZtXWX8uD3dLusNvYMTyq0kxvs
         OqxpnHG1MKW3YykwDPJCj8Sf0dSEZf7HMiyhz9wZ7WTLAKtQ8Oo/LNRYNgMIRtMY0gMU
         PW/rwesWz8ax/Qyr2mwttZRMo+P+ZCgUy0/QENpfkWJve+lQ7VLShCAfYrG8Mv8N27cJ
         nkFS4a27TfblepEyaGwTT/WMsPNrMLWuFpId0fIHJuhlX0fNxe+MZNThDIBLARyASCnR
         gmpjaWZ/4j5MLPC5rgd5UNOKIRlc2H/KYf3XRsixeo7WwqQDbDCHvo5sAkpCayyNoyQa
         P/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VHi0FGi5BNMtMMLCrl7W3BvEhWF3YSB2couJYk4G4rc=;
        b=HZm65ZPLPyNHfEOrqayy+TyCAY8urthTktSDkSQeydOApotfTQlybKeHilVwn+2zK8
         wZET1goBSLn3/ArW+y+Zl+imJMs4JuS+YLusi48iLkj5dVeazMQRiEYlj0/vEunwZTs2
         BMxD5AZFJlSuBh/99Ixpnz2AjCiaxxCTojFwDjC7UBCz2lsM15YN3wspfEXnpDSaTcbW
         +vfDJtn/TlOicJNpf3XeYPG9241zijUYeFfLkHhcwOWICUQw9secrvk3XYIsPTYNpwJF
         MUtj+noC+Po6k95ehgnpp27jHsV0WKc7Qid2O7+Nj6mXwi6GKwSTduCDkzDrZICASAEq
         z7dA==
X-Gm-Message-State: AOAM530lDNWYz+41Qx1bzxu5TDpKrAnrkUcoW9zfXXZKUtzYTVQZkeiL
        kqpJJMU3oWevzh+Nt6ffKv/LIg==
X-Google-Smtp-Source: ABdhPJyRCfyIBja8g+ScJN/7BPvj0arqZU7uABtbc8MkgRRSLECYYFHD6tbDV0jcnFw7rXMKYmUw6A==
X-Received: by 2002:a63:7941:: with SMTP id u62mr10816117pgc.461.1633109909347;
        Fri, 01 Oct 2021 10:38:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/7] ionic: move lif mutex setup and delete
Date:   Fri,  1 Oct 2021 10:37:54 -0700
Message-Id: <20211001173758.22072-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
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

