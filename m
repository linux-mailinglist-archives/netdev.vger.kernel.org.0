Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1079E41F33A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355328AbhJARkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354937AbhJARkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:15 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037FBC06177D
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w14so8601855pfu.2
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a56tnI90wkoptumCKz8cROuiPJZwxaVfKx9BzSDrql8=;
        b=1GKgE3wQiXB6avg/sCEhXCV9kUS2L2DQ8B6zXBinKSswUNfxq9aY0jhhoHsKsJUH8W
         jyF3XdMSrWkpnXZ0LD7LR8rph1ENZBedSkNQe0CL5vxwpjL84fwrgmAYeWp3Z/oyuzwF
         Yj2WmQAnpw0T8NsvyJxO2RLM9MNKz7mT9GtL6VLCj6UwZxlOdJOGGELxw79EYsCVj1sV
         KZGohW4PqiAOITsgYa6evbNqyAZriBI8+xSUScFEQP/UMuCoJfwgIb7jTg8dDprIbht4
         jU4b1oQS8C9uD/RoSxtATXtHOstrE5ytoxhxYjOVJAJkv5PL5wW5CRlb1JQPalx6Xx9/
         2wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a56tnI90wkoptumCKz8cROuiPJZwxaVfKx9BzSDrql8=;
        b=vC9tsaxRfUiz2G3Mn/HpBZF0AEjDfNlhRk/Z81BbJp2r4vV6BknMF67v0XQT4sdWtk
         Dx6D2yCTtj5jJOievM+ozB0yJdPkvwNy0+9pdjoJC9Gb9mPpIGtkib7FBbOCBrAotPZp
         asv/8ZwSISb+V3JYVCbR3dCT2kHkDKkx8SJwg0qnNbobV2OuN0Cof0ctktJYkdRwWJaW
         ePGH9rB7yLE0TzaPZP6dFrbABT5diATtLvSK5Nq1LjvkqK8Ql3GdfnKzf8TQAEz8f2hc
         rOwVHLnfUHDS3Vzb4mrmKRAhB886j8wRX79k3gLE+MAkox0z49U8xvqkwVbHST4PeLvl
         lYeA==
X-Gm-Message-State: AOAM530HjOP054+sfCCrxNVaNY+OyXcFWr6yHOUDB98ZomL1NbCNtrhA
        UWa7SBrGibqFdItjs/h2S3M4NQ==
X-Google-Smtp-Source: ABdhPJxofZOPD1hJV4/xEgyl/Yjsurpw7F4MSuSAg7snzBSM5g5iGqRAkvHxuFWb1RuXwFza5/yIXQ==
X-Received: by 2002:a63:4a18:: with SMTP id x24mr10667460pga.209.1633109910278;
        Fri, 01 Oct 2021 10:38:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/7] ionic: widen queue_lock use around lif init and deinit
Date:   Fri,  1 Oct 2021 10:37:55 -0700
Message-Id: <20211001173758.22072-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
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

