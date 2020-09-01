Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C78259E04
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgIASVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgIASUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:38 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D1FC061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id np15so980026pjb.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IiN+v9uzS1MIl2xbDXaV9FYs3HkOjRzyqudFSsdwrj4=;
        b=gJngleMLP24C35VVlrKIabcMJtxx8qykpof6e6/cEkZ19zhwpv2OcnfiHtwXc0hxum
         pluJ1j3Wt3VHxGLas2YqwfEMQBsE9A9xbx0Ri96gXsmFReAofnzh7J2c0lKPfCzUo9el
         66fVH/bs7l89F1DlZhDZmbiL8ZCrU47QeKdEWyF4pwWIIetOABlmYbqx/7ULGnwwwLuO
         eJZypa2XQIWnmgS+zUix7nR3/Z2lICGFM3oUnCze0ImYEgFE6W/bQkarbgjLdJhQDKOQ
         tlyinnqlibKnMPaYtfkgE16sAN9La4npPOviLgEhUw9ugVURweNA3UA3rlFlPm4etKtt
         G74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IiN+v9uzS1MIl2xbDXaV9FYs3HkOjRzyqudFSsdwrj4=;
        b=IvJB6lBoIW84A32OjvUyUl3j+UxQLcelg+6ferLbhV2c2l3fuPLDvpS25YEdx1lags
         qhPYgce3KFBMYMUINWmSo/JXaMt3qI61BFtS0VENzeL1ay64yDdRAQ/ytO6pk2Huheqz
         9nt/Y9YWr9H9xrRc2rBPjrsRFK1MSIjKZYMQzRFV3vsPy5R/FulRPJPl8VAh7fwSrAnv
         AE4ZUj8Qv+ICebs19PS9Hb9lmdk5WmljOVI6cQvu3YQR2be/NXSsp8y/Ux419k+YiTmX
         0RWNQ5hW52GOHN9W+OMzTzi2BXpOOMVnE8Z1MeqbkwL7QJtmce0qdzbhjA1Ky7QXKJAC
         OgKQ==
X-Gm-Message-State: AOAM531Kk3/ruSHJ5bejt+H0J+MXucqyf9n7B4B/ZF5oLfxVuBbnU2xJ
        BWQaO90G7UFwNK+rkxV3hN5OK9mqzdUqdg==
X-Google-Smtp-Source: ABdhPJwbbv//1scQfVLm3vOrCpuMxu7b7wDReyfu8UbRGWmlR1q2zm50Y30YL+bs72BzG6PuBwfckA==
X-Received: by 2002:a17:902:7b83:: with SMTP id w3mr2522977pll.28.1598984435561;
        Tue, 01 Sep 2020 11:20:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/6] ionic: clean adminq service routine
Date:   Tue,  1 Sep 2020 11:20:22 -0700
Message-Id: <20200901182024.64101-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing calling ionic_napi any more is the adminq
processing, so combine and simplify.

Co-developed-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 --
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_main.c  | 26 -----------
 3 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index f699ed19eb4f..084a924431d5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -64,9 +64,6 @@ struct ionic_admin_ctx {
 	union ionic_adminq_comp comp;
 };
 
-int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
-	       ionic_cq_done_cb done_cb, void *done_arg);
-
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index eeaa73650986..ee683cb142a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -800,21 +800,6 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	return true;
 }
 
-static int ionic_notifyq_clean(struct ionic_lif *lif, int budget)
-{
-	struct ionic_dev *idev = &lif->ionic->idev;
-	struct ionic_cq *cq = &lif->notifyqcq->cq;
-	u32 work_done;
-
-	work_done = ionic_cq_service(cq, budget, ionic_notifyq_service,
-				     NULL, NULL);
-	if (work_done)
-		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
-				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
-
-	return work_done;
-}
-
 static bool ionic_adminq_service(struct ionic_cq *cq,
 				 struct ionic_cq_info *cq_info)
 {
@@ -830,15 +815,36 @@ static bool ionic_adminq_service(struct ionic_cq *cq,
 
 static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 {
+	struct ionic_intr_info *intr = napi_to_cq(napi)->bound_intr;
 	struct ionic_lif *lif = napi_to_cq(napi)->lif;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	unsigned int flags = 0;
 	int n_work = 0;
 	int a_work = 0;
+	int work_done;
+
+	if (lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED)
+		n_work = ionic_cq_service(&lif->notifyqcq->cq, budget,
+					  ionic_notifyq_service, NULL, NULL);
 
-	if (likely(lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED))
-		n_work = ionic_notifyq_clean(lif, budget);
-	a_work = ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+	if (lif->adminqcq && lif->adminqcq->flags & IONIC_QCQ_F_INITED)
+		a_work = ionic_cq_service(&lif->adminqcq->cq, budget,
+					  ionic_adminq_service, NULL, NULL);
+
+	work_done = max(n_work, a_work);
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(intr);
+	}
 
-	return max(n_work, a_work);
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(idev->intr_ctrl,
+				   intr->index,
+				   n_work + a_work, flags);
+	}
+
+	return work_done;
 }
 
 void ionic_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2b72a51be1d0..cfb90bf605fe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -305,32 +305,6 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
 }
 
-int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
-	       ionic_cq_done_cb done_cb, void *done_arg)
-{
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
-	struct ionic_cq *cq = &qcq->cq;
-	u32 work_done, flags = 0;
-
-	work_done = ionic_cq_service(cq, budget, cb, done_cb, done_arg);
-
-	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
-	}
-
-	if (work_done || flags) {
-		flags |= IONIC_INTR_CRED_RESET_COALESCE;
-		ionic_intr_credits(cq->lif->ionic->idev.intr_ctrl,
-				   cq->bound_intr->index,
-				   work_done, flags);
-	}
-
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
-
-	return work_done;
-}
-
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
 	union ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
-- 
2.17.1

