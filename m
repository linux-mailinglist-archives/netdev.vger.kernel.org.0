Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CAD3D4022
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhGWRWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhGWRW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD49C061760
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:02 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so4792835pjh.3
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4q9+UofB47+jpzPEjXsjW5c05wZNDiWCQPOX44nA5MU=;
        b=uNL4ay8GIISif++PURIWna3Drq3XHs0+2rJl/+nIWu91FasXDqKAy2V8kM688zolJj
         hY2GUBYZKWMA88RNzMaSbQxKzngv/5IqUt3+JlHdWluongISEXv1+bBEbOsFvo2yNVJF
         Zjn5/sYDqTNES+FuWO8tzAuhKja0GJvLbpWmgjOkBOVqxQRAArxe20d7mID+hLOdnVu/
         RVptWY0crVX3rA2uVWP1gT+wwptlPD4frVQnmTLqQN/U6oHkvaJS9g34mmDQcGxGz4D3
         5aQvHTpcCma/PStEDMlMk1MwKDICKglbPNqMXPPchw1mrciP6eVlqcIvMhrQKUf7ZII6
         CiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4q9+UofB47+jpzPEjXsjW5c05wZNDiWCQPOX44nA5MU=;
        b=Yk0T01KHEV6vk/4VUXgFZYWuOXV6isCWaQpZ9qXFyAvJC4eJG5nj11uW8vwBKkKBJk
         p9mrRobBNVMXVLifkoO0T+vUC1ZK7zCPZ0kYKU9bOVscXxy3VFYynz+h2S+19MsE/Z7Z
         9XsceH51FqsdXfQ5Zcb7n2LUBopAc5Clt2J6sxg4T6WRlZGu1BTKZ9SJoUh74gPJ06I7
         2/8du0Fx1C7DhY2nD7xakaTAK/aooTejX/Xyo+/Ojq6R6BWYCcI40lLZy+WCTQitsmlY
         S30DocLQx5dZz6YADGcIYLFQT3rji70irWTaiwJrQoXujatFym2vZemqP/Ddoc74npCp
         Cp8A==
X-Gm-Message-State: AOAM530wlO1WT2PzbkouYZXa0UjzLUU63aKd1pSaXUg8trePx8ApiBMP
        TH4ZHxyxuNpPQq/WlDV7gGaiXcoHeDTWYw==
X-Google-Smtp-Source: ABdhPJxiEvF7k9DTxPDKybjpL4Y6xXcyUvupnWTGAu6Qf/7I5hfVmHoBvCWBxvVS5010ngNyW2iBwQ==
X-Received: by 2002:a62:8f4a:0:b029:327:6616:410f with SMTP id n71-20020a628f4a0000b02903276616410fmr5561674pfd.68.1627063382417;
        Fri, 23 Jul 2021 11:03:02 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:03:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 3/5] ionic: remove intr coalesce update from napi
Date:   Fri, 23 Jul 2021 11:02:47 -0700
Message-Id: <20210723180249.57599-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
References: <20210723180249.57599-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the interrupt coalesce value update out of the napi
thread and into the dim_work thread and set it only when it
has actually changed.

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 14 +++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |  4 ----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7815e9034fb8..e795fa63ca12 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -53,7 +53,19 @@ static void ionic_dim_work(struct work_struct *work)
 	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
 	qcq = container_of(dim, struct ionic_qcq, dim);
 	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
-	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
+	new_coal = new_coal ? new_coal : 1;
+
+	if (qcq->intr.dim_coal_hw != new_coal) {
+		unsigned int qi = qcq->cq.bound_q->index;
+		struct ionic_lif *lif = qcq->q.lif;
+
+		qcq->intr.dim_coal_hw = new_coal;
+
+		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+				     lif->rxqcqs[qi]->intr.index,
+				     qcq->intr.dim_coal_hw);
+	}
+
 	dim->state = DIM_START_MEASURE;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 08934888575c..9d3a04110685 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -463,10 +463,6 @@ static void ionic_dim_update(struct ionic_qcq *qcq)
 	lif = qcq->q.lif;
 	qi = qcq->cq.bound_q->index;
 
-	ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-			     lif->rxqcqs[qi]->intr.index,
-			     qcq->intr.dim_coal_hw);
-
 	dim_update_sample(qcq->cq.bound_intr->rearm_count,
 			  lif->txqstats[qi].pkts,
 			  lif->txqstats[qi].bytes,
-- 
2.17.1

