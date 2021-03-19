Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105E03411A0
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhCSAt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhCSAs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62763C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l1so2144738plg.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VcL2PRC649t7/2/e96ZBhHWaTie3wVSR1kURoD0b1Fg=;
        b=eWN8Acv2AHpW4fKApNqZyl3idPds9cemFoUN/0YyQyXITEFGFps3WZYeMyh8hAfPTb
         /VTIYih4wC60XvCPLRKFhGgXEyCyiglaZAj6+oqNLH8xDCLUlLNdXipH4qZ0ZtYLNs0B
         EUgp+O5igx9mvYD6uRirgVfW/1GDICUE1kzxPWpKDb2OfDPTvsYZkk3m8U27hPt3B1Jf
         lAbO/NmqogN7DHHIfNhNmSeux00oZ09CiTyp4B5OLvnNhWgpfYvVtN2eZc584cHDav7y
         bN+p+cGLn7gFnweXMmjAC4tCHNZmfRChdYck5yDXMBc5SCc1L6cawsqk2Xxbne/rARmF
         Acog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VcL2PRC649t7/2/e96ZBhHWaTie3wVSR1kURoD0b1Fg=;
        b=flo9g9NhNU38VRqeaqBo3iHUliCzbGo4HqskZDWnPyFYQKoyVDlCilAUHJbF19L7u1
         uPWHg+e+Wou83ZAP5NIJWuRGOEOXhJ4ECshxXyxmUJcwL8DoH/9QPgza3rQGj7/q8K55
         AA/QIlGy3j51IJk3m3bvjyYl+vQMia0+bdDtAyo2Z9LO1wuO1Odqj4b6miXKIhSxl8Jk
         zQurcB9pPwnt9mbNhVxYBN2+2HPBifK1VVWqt7KEqbYR0HATCJoj0swwd/fV+Vk0OzvI
         RUOFGGDh/T2ibw7i1lIAMIDJVUS7AT1ShYA1Jr/2Z+QZ/TLEgJcu/xsNrqHBG+ZW2Ebw
         8/gg==
X-Gm-Message-State: AOAM533ZpYVl8gtiTt08pn/GCFEQlextHpYCnOkCK1kb7QeAHbN8R5/M
        EC33REkKn+QxGi41gEOgJCobhWmQCCqj5A==
X-Google-Smtp-Source: ABdhPJz76PBdetiB1hTzeC9KaBb4ulVJXpNplBdElbYjwqGNYZc1moMLVTtpFMx4RKCKmvP4nSluDQ==
X-Received: by 2002:a17:902:b7c9:b029:e6:3d74:5dc5 with SMTP id v9-20020a170902b7c9b02900e63d745dc5mr12102692plz.16.1616114936277;
        Thu, 18 Mar 2021 17:48:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/7] ionic: protect adminq from early destroy
Date:   Thu, 18 Mar 2021 17:48:10 -0700
Message-Id: <20210319004810.4825-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't destroy the adminq while there is an outstanding request.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 14 ++++++++++--
 .../net/ethernet/pensando/ionic/ionic_main.c  | 22 ++++++++++++++-----
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9b3afedbc083..889d234e2ffa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -393,6 +393,8 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 static void ionic_qcqs_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
+	struct ionic_qcq *adminqcq;
+	unsigned long irqflags;
 
 	if (lif->notifyqcq) {
 		ionic_qcq_free(lif, lif->notifyqcq);
@@ -401,9 +403,14 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 	}
 
 	if (lif->adminqcq) {
-		ionic_qcq_free(lif, lif->adminqcq);
-		devm_kfree(dev, lif->adminqcq);
+		spin_lock_irqsave(&lif->adminq_lock, irqflags);
+		adminqcq = READ_ONCE(lif->adminqcq);
 		lif->adminqcq = NULL;
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		if (adminqcq) {
+			ionic_qcq_free(lif, adminqcq);
+			devm_kfree(dev, adminqcq);
+		}
 	}
 
 	if (lif->rxqcqs) {
@@ -886,6 +893,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_intr_info *intr = napi_to_cq(napi)->bound_intr;
 	struct ionic_lif *lif = napi_to_cq(napi)->lif;
 	struct ionic_dev *idev = &lif->ionic->idev;
+	unsigned long irqflags;
 	unsigned int flags = 0;
 	int n_work = 0;
 	int a_work = 0;
@@ -895,9 +903,11 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 		n_work = ionic_cq_service(&lif->notifyqcq->cq, budget,
 					  ionic_notifyq_service, NULL, NULL);
 
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
 	if (lif->adminqcq && lif->adminqcq->flags & IONIC_QCQ_F_INITED)
 		a_work = ionic_cq_service(&lif->adminqcq->cq, budget,
 					  ionic_adminq_service, NULL, NULL);
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 
 	work_done = max(n_work, a_work);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 14ece909a451..c4b2906a2ae6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -187,10 +187,17 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 
 static void ionic_adminq_flush(struct ionic_lif *lif)
 {
-	struct ionic_queue *q = &lif->adminqcq->q;
 	struct ionic_desc_info *desc_info;
+	unsigned long irqflags;
+	struct ionic_queue *q;
+
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+	if (!lif->adminqcq) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		return;
+	}
 
-	spin_lock(&lif->adminq_lock);
+	q = &lif->adminqcq->q;
 
 	while (q->tail_idx != q->head_idx) {
 		desc_info = &q->info[q->tail_idx];
@@ -199,7 +206,7 @@ static void ionic_adminq_flush(struct ionic_lif *lif)
 		desc_info->cb_arg = NULL;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 	}
-	spin_unlock(&lif->adminq_lock);
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 }
 
 static int ionic_adminq_check_err(struct ionic_lif *lif,
@@ -252,15 +259,18 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
+	unsigned long irqflags;
 	struct ionic_queue *q;
 	int err = 0;
 
-	if (!lif->adminqcq)
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+	if (!lif->adminqcq) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 		return -EIO;
+	}
 
 	q = &lif->adminqcq->q;
 
-	spin_lock(&lif->adminq_lock);
 	if (!ionic_q_has_space(q, 1)) {
 		err = -ENOSPC;
 		goto err_out;
@@ -280,7 +290,7 @@ static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	ionic_q_post(q, true, ionic_adminq_cb, ctx);
 
 err_out:
-	spin_unlock(&lif->adminq_lock);
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 
 	return err;
 }
-- 
2.17.1

