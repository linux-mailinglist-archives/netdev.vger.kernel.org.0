Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C362B41F457
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355710AbhJASIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355689AbhJASI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7EC06177D
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:43 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e7so10170250pgk.2
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a56tnI90wkoptumCKz8cROuiPJZwxaVfKx9BzSDrql8=;
        b=13R7a1BAsTgFExL1et9S2v4JEXPauB0mTZLvJI5g88cnkPa7FQDRZhw5m4hm/33Wr6
         ezu+AFgpvWITDhUoO9A0g3/iKpB0oDOCQ6nL15rQKW5dueOs7qVgdR7IIaZwf1e7F+P3
         14/oYYJ4s2e9w+AvBieCE++R/FY90eASe4mDLuLL2OOA85kC9JOGeFF43M6G9WUw5HkS
         3NNmcnr9KRx0UbQMYKHPE/+rV/N8owxWgC2balbWmd4mqTzzxu64BRWbJH2tj7xVFM0R
         pGVB3pH4iH9qU+D5WRObEME6DhLFMMXnW5ZCdvC+EOPL19SYus7QZR6UaGElrYkhgN2M
         3SRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a56tnI90wkoptumCKz8cROuiPJZwxaVfKx9BzSDrql8=;
        b=ZgP+KpEkD1uBIs7wBNUexLN/fOYwVU41p+L6BCdOzAwo9/3iSpkNVLXasx1SrGl3L9
         ih1gT75iCAY/hCsdGC+QKWdPCh733qPAKpNDfcRunRgOJO+upUjVlxJPu9b72D/9L/H4
         LrMPy2Ka9ShTfC4ZLhOLTLMoSxHGWD+lDvVcY4WSmm5P32IbqdZInmmvY6Echc7AwAxt
         Syv2HthLO4nf22eKoB7BjODs3L6PSvNHfiCPr1YV4UsXr1lH+OQqq5E85OjvS0RdNqJV
         8QYg1MHaKXMkgeTaxVnPGGvmumly9C1vYoo8rTg4LfNcF9PfP/jEjIlIu8L3scS3TyTY
         pxVA==
X-Gm-Message-State: AOAM532U51JZTfYsFeZz3/WYF7Eg7mZk9XZQlfkT0SI05EL0UEwvXofc
        ZS0IP5yhGybCMnCMHrY/Rngnzw==
X-Google-Smtp-Source: ABdhPJxVksy9mfWwMcr+lvQMeSuypKsSAVxtmDlM+hkhIYvRtPf3SUIoQvAqUOyiS+SaDIcz+7dWGA==
X-Received: by 2002:aa7:82ce:0:b0:44b:436b:b171 with SMTP id f14-20020aa782ce000000b0044b436bb171mr12753851pfn.21.1633111602989;
        Fri, 01 Oct 2021 11:06:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:42 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/7] ionic: widen queue_lock use around lif init and deinit
Date:   Fri,  1 Oct 2021 11:05:54 -0700
Message-Id: <20211001180557.23464-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Widen the coverage of the queue_lock to be sure the lif init
and lif deinit actions are protected.  This addresses a hang
seen when a Tx Timeout action was attempted at the same time
as a FW Reset was started.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4f28cd3ea454..5efa9f168830 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2974,11 +2974,10 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	netif_device_detach(lif->netdev);
 
+	mutex_lock(&lif->queue_lock);
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
-		mutex_lock(&lif->queue_lock);
 		ionic_stop_queues(lif);
-		mutex_unlock(&lif->queue_lock);
 	}
 
 	if (netif_running(lif->netdev)) {
@@ -2989,6 +2988,8 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 	ionic_reset(ionic);
 	ionic_qcqs_free(lif);
 
+	mutex_unlock(&lif->queue_lock);
+
 	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
 }
 
@@ -3012,9 +3013,12 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	err = ionic_port_init(ionic);
 	if (err)
 		goto err_out;
+
+	mutex_lock(&lif->queue_lock);
+
 	err = ionic_qcqs_alloc(lif);
 	if (err)
-		goto err_out;
+		goto err_unlock;
 
 	err = ionic_lif_init(lif);
 	if (err)
@@ -3035,6 +3039,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 			goto err_txrx_free;
 	}
 
+	mutex_unlock(&lif->queue_lock);
+
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
 	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
@@ -3051,6 +3057,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	ionic_lif_deinit(lif);
 err_qcqs_free:
 	ionic_qcqs_free(lif);
+err_unlock:
+	mutex_unlock(&lif->queue_lock);
 err_out:
 	dev_err(ionic->dev, "FW Up: LIFs restart failed - err %d\n", err);
 }
-- 
2.17.1

