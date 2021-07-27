Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313E23D7C6B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhG0Rnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhG0Rns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E31C061765
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e21so12124898pla.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iBOFT9vekrGt2zzCd6raJgApOv9Ft7mTrTQxJhe9jpw=;
        b=ueQcnHYZdG/Y7bMFUdw07F/yMxuhA98lnRpXm/9tWOzTHCFkLDnJDXVlgDLTQjGgxb
         VfOiSz6k7DaR4oNKU+gZ+Xmu4JXLWZfGOTsl30Isk7/+JRsPdoTs8Wz7FW9m3E23PRqo
         zKQ9x42zgbQwAkNTainGzMiK4ONPlONXuGx9c93jvx3auHOh+kpWq/bHEHXu2raQj9Di
         EOWW93jsQO1T+lfGZ+BW6RSCX4NnerOnk4TcKubPbKbYkIWEpfXyCGSV9QcddfdyevQl
         ixuATaFs9iT38cQstJpfG9o/aQWbqDvrSO7GefOyganNthxlLU+GfumeRNaoIdSFFga+
         2fZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iBOFT9vekrGt2zzCd6raJgApOv9Ft7mTrTQxJhe9jpw=;
        b=XXb+2JvcO5IgGGpEy/HxhJtWyRZPXveSG8oFTpC8/+qm936SHlClRPsh2kNDbtJuZ3
         gVIoTitwd1bD+d4VL5ZYRbtwtt9h7pONnIBibR8KlboLMb1w7R4hGpVsEqlHlW8wK5hf
         3kZdFPnJmdZmfqRid/9rsCrbiiXimy1cGp+0gfouRyOg/IBQL1o8S40MTEH8qKrfDkBZ
         /eLVEltNPffTyD4lmDJoeUcsvzBjpeS9gYXsijg06tC7rAy/JRNIZq0XLzrxZ3fyaFFE
         iPpplQEwtpHImdVL+xP009NaKTnlU7ef1rW3/jKKDOfplf8cZLBwd3+4t6sV3QWbg6Vn
         krmw==
X-Gm-Message-State: AOAM532SDOawhzixtfMLlBldeht31HKB+ocjSXmdzAS6RYOLKNd98BE5
        TuajeyNXs5HCehcYV5WVLLmtweR9+YfnZw==
X-Google-Smtp-Source: ABdhPJzu/7hM+mHpRVItxYf45BEjWrQuxuBCN/tCQzKHHWxWorVRik4XNXXFbskL4wfgx77pPyFWTw==
X-Received: by 2002:a63:5f55:: with SMTP id t82mr24758452pgb.226.1627407827277;
        Tue, 27 Jul 2021 10:43:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 04/10] ionic: init reconfig err to 0
Date:   Tue, 27 Jul 2021 10:43:28 -0700
Message-Id: <20210727174334.67931-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize err to 0 instead of ENOMEM, and specifically set
err to ENOMEM in the devm_kcalloc() failure cases.

Also, add an error message to the end of reconfig.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e839680070ba..3a72403cf4df 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2588,22 +2588,26 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	struct ionic_qcq **tx_qcqs = NULL;
 	struct ionic_qcq **rx_qcqs = NULL;
 	unsigned int flags, i;
-	int err = -ENOMEM;
+	int err = 0;
 
 	/* allocate temporary qcq arrays to hold new queue structs */
 	if (qparam->nxqs != lif->nxqs || qparam->ntxq_descs != lif->ntxq_descs) {
 		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->ntxqs_per_lif,
 				       sizeof(struct ionic_qcq *), GFP_KERNEL);
-		if (!tx_qcqs)
+		if (!tx_qcqs) {
+			err = -ENOMEM;
 			goto err_out;
+		}
 	}
 	if (qparam->nxqs != lif->nxqs ||
 	    qparam->nrxq_descs != lif->nrxq_descs ||
 	    qparam->rxq_features != lif->rxq_features) {
 		rx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->nrxqs_per_lif,
 				       sizeof(struct ionic_qcq *), GFP_KERNEL);
-		if (!rx_qcqs)
+		if (!rx_qcqs) {
+			err = -ENOMEM;
 			goto err_out;
+		}
 	}
 
 	/* allocate new desc_info and rings, but leave the interrupt setup
@@ -2782,6 +2786,9 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 		ionic_qcq_free(lif, lif->rxqcqs[i]);
 	}
 
+	if (err)
+		netdev_info(lif->netdev, "%s: failed %d\n", __func__, err);
+
 	return err;
 }
 
-- 
2.17.1

