Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B73A16071D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBPXMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:10 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46295 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPXMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:09 -0500
Received: by mail-pg1-f193.google.com with SMTP id b35so7904009pgm.13
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zfyxFEADa7ihRXxwfBj+JXn1jrPrOKaorvfAcQsM3yo=;
        b=vHJuNJZPYW9gMCdu8b3hJHX6hUkWEPxwKXz6QUCtE7iR5P6feTnyMPbaQwHh1LRVks
         MIypwsqtH5qQzXWlxJRj/bnX9EKMgeeQ7xZXMAjWfiRPuptQP+op21YLnPwCqwgDQMey
         DmEeUXzp9+ZDwXeNij5fQvOZQLlyyrfrPcKHrMD6IMPzoBMx4uDI1hGHJedxD2z+zAts
         exX07sMUCpTTS2sfrjld4YzoJMUuf/VOo9zST+MbI4Az8YpMbENPkHy2/IucuTcJ13gH
         ZN7BkPhOIkQZCqgMR6Yb4I9QHNUN0IOm4VD6N+qQMuUM/ubC/W2hgKwC4CL6bnXjTdAb
         gdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zfyxFEADa7ihRXxwfBj+JXn1jrPrOKaorvfAcQsM3yo=;
        b=mRz2cQxugBZlgQ5Ppeh+S0rgMzutH9dqZlItV5Mqj04MehPOnUC80wGD96j9AKYqkw
         5pX0MS6rVI7WXyN4+879fPovjxjb//mMJFTkr7DxNWXZJqcIkBSjkNrnmDb5cQhbFGRA
         SAB1f96latG1R6m6cGpWrdj5B3avgC5wrDmfaIP6iGYqgnLBlFOUZPj3eD4buh0RnZJ/
         haH2YEZ81XaAetgKWGw1ZQPxcYCvZEWA8EHzw3HCI0wBvxseCt1dKKkhmky6NyxaLqqS
         EaHt56KfSlPagQnCdzjp2+P3sZjMuwXxOW70vcyMkO/qipSQqxu2JVkEGsz2IDSGrjpe
         cMUw==
X-Gm-Message-State: APjAAAWemrSa4qfSuKJYK102Cn3W3xaWdOYR7/igZqEAqLybmxxYsFyi
        M0y4VwyplbDc1Yg54+b/eSEqef2dXFJQDw==
X-Google-Smtp-Source: APXvYqwN1CaGajg6ynhD/GDBTwMvypL8UYs5F5Oy+CQd8gTWJP7/Cd7Xtl62JFw+KnodjcwiuBSnDg==
X-Received: by 2002:a62:36c2:: with SMTP id d185mr14562903pfa.203.1581894729160;
        Sun, 16 Feb 2020 15:12:09 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:08 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/9] ionic: change param from lif to ionic
Date:   Sun, 16 Feb 2020 15:11:50 -0800
Message-Id: <20200216231158.5678-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an ionic pointer rather than the lif in ionic_intr_alloc()
and ionic_intr_free() so that in the future we can allocate
interrupts before we have a lif.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 191271f6260d..15d5b24d89a1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -149,15 +149,14 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 				0, intr->name, &qcq->napi);
 }
 
-static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
+static int ionic_intr_alloc(struct ionic *ionic, struct ionic_intr_info *intr)
 {
-	struct ionic *ionic = lif->ionic;
 	int index;
 
 	index = find_first_zero_bit(ionic->intrs, ionic->nintrs);
 	if (index == ionic->nintrs) {
-		netdev_warn(lif->netdev, "%s: no intr, index=%d nintrs=%d\n",
-			    __func__, index, ionic->nintrs);
+		dev_warn(ionic->dev, "%s: no intr, index=%d nintrs=%d\n",
+			 __func__, index, ionic->nintrs);
 		return -ENOSPC;
 	}
 
@@ -167,10 +166,10 @@ static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
 	return 0;
 }
 
-static void ionic_intr_free(struct ionic_lif *lif, int index)
+static void ionic_intr_free(struct ionic *ionic, int index)
 {
-	if (index != INTR_INDEX_NOT_ASSIGNED && index < lif->ionic->nintrs)
-		clear_bit(index, lif->ionic->intrs);
+	if (index != INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
+		clear_bit(index, ionic->intrs);
 }
 
 static int ionic_qcq_enable(struct ionic_qcq *qcq)
@@ -294,7 +293,7 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	qcq->base_pa = 0;
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
-		ionic_intr_free(lif, qcq->intr.index);
+		ionic_intr_free(lif->ionic, qcq->intr.index);
 
 	devm_kfree(dev, qcq->cq.info);
 	qcq->cq.info = NULL;
@@ -337,7 +336,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 				      struct ionic_qcq *n_qcq)
 {
 	if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
-		ionic_intr_free(n_qcq->cq.lif, n_qcq->intr.index);
+		ionic_intr_free(n_qcq->cq.lif->ionic, n_qcq->intr.index);
 		n_qcq->flags &= ~IONIC_QCQ_F_INTR;
 	}
 
@@ -407,7 +406,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	}
 
 	if (flags & IONIC_QCQ_F_INTR) {
-		err = ionic_intr_alloc(lif, &new->intr);
+		err = ionic_intr_alloc(lif->ionic, &new->intr);
 		if (err) {
 			netdev_warn(lif->netdev, "no intr for %s: %d\n",
 				    name, err);
@@ -478,7 +477,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	return 0;
 
 err_out_free_intr:
-	ionic_intr_free(lif, new->intr.index);
+	ionic_intr_free(lif->ionic, new->intr.index);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
-- 
2.17.1

