Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62C2196352
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgC1DO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:14:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39762 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgC1DO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id m1so4221143pll.6
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8zpLZGeY/nDEk9TNsWLfD77fTIVdwMlPAKq4K8bCeR0=;
        b=YhAh4Yw2MxOBMJDfC+ypzrt5gRFWx8BJWGMsfFeAfaSLtKxWOzbAy3Zj2XRLe5JpU3
         IUNtsWGKx3aklBsO9K6jGiNB0V6wO+XlDQ49+y50P5T/CTYpjuNZyry/DULR2Y//SR10
         8P+t3x2qQxasq7uFGW5qCfjGX8lC8xKI+1ZnpG/+vv/z6LfksBuk8RLhrLg9m5CJoWct
         YvmFIXZmE+u87f17vwxu22cGE17B4ztmylJP7bvVhI2wczcQZ38jM9i1ESrhdvyCArXk
         D2jE0NkJDjTnhGI3O4aSDmiJzxnpXe8BDfHEMgkyCL4BOFUb4r1qfLZD4WmmIVD+p67a
         toaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8zpLZGeY/nDEk9TNsWLfD77fTIVdwMlPAKq4K8bCeR0=;
        b=a+FbV5/egnZVm6iLwKYOB313TDky6j7aoGx51fwQG0YJx1qfRoY1L+MJMxDqJ4vMxd
         Ye8Iqi5PyocaKDdns1bxDpDdq87yMu1gC9ehaQcG6FjhU5MClR5DDwGyxyxdAWSfPiAU
         1pZmz4T+jjAgRV8d2LLoUtjU9kBTbFFzNb3ZYxSVbfSU0L+/AUYazudfc42Yva6cX5Hy
         JbPM5OinEFvpcnt+W9pjKwx1SvqWiPhNDhfLqXer88YvEcwE3bVGveZkG//yohGzt+h0
         zTNGQ68AT8MGTXBRVwioI3UhSVjDRksq4aC3PUdNIxtIU7bfNDNuQBMpNed6HMuKB2d6
         n/SQ==
X-Gm-Message-State: ANhLgQ2x3yrmS22gswsh7Zq2n4kRLIRNgh9Nq5gpD4/+F9SEcZ+mhaEm
        +Wq0qblxJD6cTWOLBZHv63H/tA==
X-Google-Smtp-Source: ADFU+vvQXaKgBY2VTM19+HALSAiLfBihhRLs6AZKediiR0pLtrO96Ho5r895lRVkD4CrT4CbO45fzQ==
X-Received: by 2002:a17:90a:fb47:: with SMTP id iq7mr2805268pjb.191.1585365297887;
        Fri, 27 Mar 2020 20:14:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/8] ionic: move irq request to qcq alloc
Date:   Fri, 27 Mar 2020 20:14:44 -0700
Message-Id: <20200328031448.50794-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the irq request and free out of the qcq_init and deinit
and into the alloc and free routines where they belong for
better resource management.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 +++++++++----------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4ade43219256..b3f568356824 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -266,7 +266,6 @@ static void ionic_lif_quiesce(struct ionic_lif *lif)
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
-	struct device *dev = lif->ionic->dev;
 
 	if (!qcq)
 		return;
@@ -277,10 +276,7 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
-		irq_set_affinity_hint(qcq->intr.vector, NULL);
-		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		netif_napi_del(&qcq->napi);
-		qcq->intr.vector = 0;
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
@@ -299,8 +295,12 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	qcq->base = NULL;
 	qcq->base_pa = 0;
 
-	if (qcq->flags & IONIC_QCQ_F_INTR)
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
+		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
+		qcq->intr.vector = 0;
 		ionic_intr_free(lif, qcq->intr.index);
+	}
 
 	devm_kfree(dev, qcq->cq.info);
 	qcq->cq.info = NULL;
@@ -432,6 +432,12 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
 				       IONIC_INTR_MASK_SET);
 
+		err = ionic_request_irq(lif, new);
+		if (err) {
+			netdev_warn(lif->netdev, "irq request failed %d\n", err);
+			goto err_out_free_intr;
+		}
+
 		new->intr.cpu = cpumask_local_spread(new->intr.index,
 						     dev_to_node(dev));
 		if (new->intr.cpu != -1)
@@ -446,13 +452,13 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (!new->cq.info) {
 		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
 		err = -ENOMEM;
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
 	if (err) {
 		netdev_err(lif->netdev, "Cannot initialize completion queue\n");
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	new->base = dma_alloc_coherent(dev, total_size, &new->base_pa,
@@ -460,7 +466,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (!new->base) {
 		netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
 		err = -ENOMEM;
-		goto err_out_free_intr;
+		goto err_out_free_irq;
 	}
 
 	new->total_size = total_size;
@@ -486,8 +492,12 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 	return 0;
 
+err_out_free_irq:
+	if (flags & IONIC_QCQ_F_INTR)
+		devm_free_irq(dev, new->intr.vector, &new->napi);
 err_out_free_intr:
-	ionic_intr_free(lif, new->intr.index);
+	if (flags & IONIC_QCQ_F_INTR)
+		ionic_intr_free(lif, new->intr.index);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
@@ -664,12 +674,6 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
-	if (err) {
-		netif_napi_del(&qcq->napi);
-		return err;
-	}
-
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -2141,13 +2145,6 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
-	if (err) {
-		netdev_warn(lif->netdev, "adminq irq request failed %d\n", err);
-		netif_napi_del(&qcq->napi);
-		return err;
-	}
-
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
-- 
2.17.1

