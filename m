Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793123F9F4D
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhH0S40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhH0S4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BAFC0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:28 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y11so6414222pfl.13
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4elQmY/V4Npq+q1KxpteukQ6ePQZJcGD7cE3YtVPLGE=;
        b=ZAWJTHkc+Hqq8fVdr1gLV/mmkFI1+rNMGnGYFa92b+xQikB9i3OmnAY7F/azwoqWUu
         etSuSzqJA4O9ssTFlxIpY49s/jtadEiYBTlAdfroBLg/ueVVwfEl9xHyu/v6val9Acpe
         fTw3FIGEt7PQTbsCfpEodghyVIwxIy6GYQArTiPCD7tObUjY7VEQKSABIn3TTFaQ0BuS
         EDmANwiF88qKlptXq2mzEne2MBDAVXiObqw4l5F6Atfu843rkpbpkOgux+Fk2w2tWB2H
         eyZfvNEaOr70SZkD79NWmlSpgLJX/ZIEiVBuJU5Jwf94SWdEgvR2VZr3X9wDxTSIi5VT
         BQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4elQmY/V4Npq+q1KxpteukQ6ePQZJcGD7cE3YtVPLGE=;
        b=sxOaFs6CKOJxq+pKnRLSafIFBIowNgqDWJzs7AgjEUAzNgENqkA2TC7irSHwPyuiD2
         e94lquaSQM6u8QsR4KtW/HpRVvISG33Bi1t5/TB4KSWLtKe2wWhy6xKCd14hCMsw7OFi
         NslCw2bAx5lf/4L5SLniYJJCnWCKmY04O+N6skYFpMmEjNIaVbgAy5DHwewxBX99nJ0u
         aRhkBiBKYby+UC5wTbXi6zPCCk+MoUpOBb4dSXCoiGuyKd6vsVmoK9jxQKuY/fLtrlwT
         SjgOPNzHCzcb06hRytt7hfx/c0cjUPNjj2OJnwvhQqlD75y+JZfD6yUFo772eHmuyA+3
         tdVw==
X-Gm-Message-State: AOAM530JMNF+2SNyiOyX6Dxaqc5fq8cF79QWtY7Ol8SZj2gaB8TFzzVf
        6eEhtlyq3OxZJltkkxOTJ74UvA==
X-Google-Smtp-Source: ABdhPJxCUaenIjQVKqug+64edlBW4SjkN7OH0C7CNvlXx/lMlDEZ1pM/1U4GUk4T6jb4gXNU9put7A==
X-Received: by 2002:a65:5acc:: with SMTP id d12mr9223274pgt.68.1630090527918;
        Fri, 27 Aug 2021 11:55:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/6] ionic: pull hwstamp queue_lock up a level
Date:   Fri, 27 Aug 2021 11:55:11 -0700
Message-Id: <20210827185512.50206-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the hwstamp configuration use of queue_lock up
a level to simplify use and error handling.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++--------------
 drivers/net/ethernet/pensando/ionic/ionic_phc.c |  4 ++++
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1d31b9385849..96e7e289b7d3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -849,10 +849,8 @@ int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif)
 	u64 features;
 	int err;
 
-	mutex_lock(&lif->queue_lock);
-
 	if (lif->hwstamp_txq)
-		goto out;
+		return 0;
 
 	features = IONIC_Q_F_2X_CQ_DESC | IONIC_TXQ_F_HWSTAMP;
 
@@ -894,9 +892,6 @@ int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif)
 		}
 	}
 
-out:
-	mutex_unlock(&lif->queue_lock);
-
 	return 0;
 
 err_qcq_enable:
@@ -907,7 +902,6 @@ int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif)
 	ionic_qcq_free(lif, txq);
 	devm_kfree(lif->ionic->dev, txq);
 err_qcq_alloc:
-	mutex_unlock(&lif->queue_lock);
 	return err;
 }
 
@@ -919,10 +913,8 @@ int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif)
 	u64 features;
 	int err;
 
-	mutex_lock(&lif->queue_lock);
-
 	if (lif->hwstamp_rxq)
-		goto out;
+		return 0;
 
 	features = IONIC_Q_F_2X_CQ_DESC | IONIC_RXQ_F_HWSTAMP;
 
@@ -960,9 +952,6 @@ int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif)
 		}
 	}
 
-out:
-	mutex_unlock(&lif->queue_lock);
-
 	return 0;
 
 err_qcq_enable:
@@ -973,7 +962,6 @@ int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif)
 	ionic_qcq_free(lif, rxq);
 	devm_kfree(lif->ionic->dev, rxq);
 err_qcq_alloc:
-	mutex_unlock(&lif->queue_lock);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index afc45da399d4..c39790a6c436 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -194,7 +194,9 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
+	mutex_lock(&lif->queue_lock);
 	err = ionic_lif_hwstamp_set_ts_config(lif, &config);
+	mutex_unlock(&lif->queue_lock);
 	if (err) {
 		netdev_info(lif->netdev, "hwstamp set failed: %d\n", err);
 		return err;
@@ -213,7 +215,9 @@ void ionic_lif_hwstamp_replay(struct ionic_lif *lif)
 	if (!lif->phc || !lif->phc->ptp)
 		return;
 
+	mutex_lock(&lif->queue_lock);
 	err = ionic_lif_hwstamp_set_ts_config(lif, NULL);
+	mutex_unlock(&lif->queue_lock);
 	if (err)
 		netdev_info(lif->netdev, "hwstamp replay failed: %d\n", err);
 }
-- 
2.17.1

