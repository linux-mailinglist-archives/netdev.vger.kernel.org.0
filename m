Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4A196351
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgC1DO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:14:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45897 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgC1DO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:58 -0400
Received: by mail-pl1-f194.google.com with SMTP id b9so4211576pls.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oo+fcUD4R29RbLhunzC9hcanAW0dvpquy2WKlMreYu8=;
        b=Y82a4kle3y0kHrY2O1usVJ6Ft8sz+DSU+AJYe0tpWxWJ6ynvsvga6CC5nZVITpJahp
         +gakf+T1szeTM8D7NVrdPVSaMGD87BAQXp/DoWfK6HtKYdSekPWgcOU7Q8nRhBx5NrK1
         KNnTazv19HWHXg3ts/vDjfZYYLJkDf9Y6wrUPT2srfnDUGoCJu2XerPn7QvngzXnZoeX
         CghxbeycD3Vo8Gx6pDobJj+wQp8gJATGNexlvutN/+E9EBMen+c7QzPpWH4KW5inICNv
         csRJ0TBN6zvYbQu0Cp1K1dCs3eFFfTFqdYexBtRuzLtbc+gMiBnOab3d7jbASXVfuGPV
         vlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oo+fcUD4R29RbLhunzC9hcanAW0dvpquy2WKlMreYu8=;
        b=CkZ836Ijic0QTc4Fk98SQgaXWIduhQoStxwI/vfAD7LTu3/kDgiJFSiZwQ68iYAe5u
         IQd7WUTEct1U3/nJ+ws+6BSRnRoMCEXXdAO/bysuafvyt84HYkGx1iLtz9oRaL+PTk8k
         xxcuEMFG1HebbJ77mgQHVZEBLKqVcW9uCU5HFovu7z3N0dfjY4GNOMwXan4PIYdJy4uW
         pRy05ssbTj/jjWrD+0RohvvzkjmygDbG3KnIRN9foj8SY3/ke2zj9PZLDz0AxQ+UaWp8
         X7c8RNuFkJX/GD87IT9BPT7OJ9Dd9sR3w1dljsthG9MxPIq3d38DU6WbHhEyeOu5EkGE
         3zdw==
X-Gm-Message-State: ANhLgQ3Ef9zQPykfdPJ8F/tyq2CKiIO/j9NitDZYJoVph0r6MBXX7ZXa
        7Tcqe7ECMCS0G0AbWY3Yafom4g==
X-Google-Smtp-Source: ADFU+vscWHRv0s+7TxVJLe1TmLw1oGO4fnPoX7Kh7F5eO+Z3PhSbc1nV6aN33ZA7liu8ktQbVsWzFA==
X-Received: by 2002:a17:90b:1b05:: with SMTP id nu5mr2718058pjb.110.1585365296918;
        Fri, 27 Mar 2020 20:14:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/8] ionic: move debugfs add/delete to match alloc/free
Date:   Fri, 27 Mar 2020 20:14:43 -0700
Message-Id: <20200328031448.50794-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the qcq debugfs add to the queue alloc, and likewise move
the debugfs delete to the queue free.  The LIF debugfs add
also needs to be moved, but the del is already in the LIF free.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ddbff44cda89..4ade43219256 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -271,8 +271,6 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (!qcq)
 		return;
 
-	ionic_debugfs_del_qcq(qcq);
-
 	if (!(qcq->flags & IONIC_QCQ_F_INITED))
 		return;
 
@@ -295,6 +293,8 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (!qcq)
 		return;
 
+	ionic_debugfs_del_qcq(qcq);
+
 	dma_free_coherent(dev, qcq->total_size, qcq->base, qcq->base_pa);
 	qcq->base = NULL;
 	qcq->base_pa = 0;
@@ -509,6 +509,7 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 			      0, lif->kern_pid, &lif->adminqcq);
 	if (err)
 		return err;
+	ionic_debugfs_add_qcq(lif, lif->adminqcq);
 
 	if (lif->ionic->nnqs_per_lif) {
 		flags = IONIC_QCQ_F_NOTIFYQ;
@@ -519,6 +520,7 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 				      0, lif->kern_pid, &lif->notifyqcq);
 		if (err)
 			goto err_out_free_adminqcq;
+		ionic_debugfs_add_qcq(lif, lif->notifyqcq);
 
 		/* Let the notifyq ride on the adminq interrupt */
 		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
@@ -616,8 +618,6 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
-	ionic_debugfs_add_qcq(lif, qcq);
-
 	return 0;
 }
 
@@ -672,8 +672,6 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
-	ionic_debugfs_add_qcq(lif, qcq);
-
 	return 0;
 }
 
@@ -1490,6 +1488,7 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 			goto err_out;
 
 		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
+		ionic_debugfs_add_qcq(lif, lif->txqcqs[i].qcq);
 	}
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
@@ -1510,6 +1509,7 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 				     lif->rx_coalesce_hw);
 		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
 					  lif->txqcqs[i].qcq);
+		ionic_debugfs_add_qcq(lif, lif->rxqcqs[i].qcq);
 	}
 
 	return 0;
@@ -1974,6 +1974,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 		goto err_out_free_netdev;
 	}
 
+	ionic_debugfs_add_lif(lif);
+
 	/* allocate queues */
 	err = ionic_qcqs_alloc(lif);
 	if (err)
@@ -2154,8 +2156,6 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
-	ionic_debugfs_add_qcq(lif, qcq);
-
 	return 0;
 }
 
@@ -2203,8 +2203,6 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
-	ionic_debugfs_add_qcq(lif, qcq);
-
 	return 0;
 }
 
@@ -2258,8 +2256,6 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	int dbpage_num;
 	int err;
 
-	ionic_debugfs_add_lif(lif);
-
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
 	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
-- 
2.17.1

