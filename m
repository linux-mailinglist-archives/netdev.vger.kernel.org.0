Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50C62803CD
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgJAQXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732026AbgJAQXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:23:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13594C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:23:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so4998989pff.6
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ClIUYr4iNr71p0PkfukRICrUdDDVofFV6FT0DKMV7Js=;
        b=h9VtCFxAHqLWKRn/E1phWHaqAeqr7qJqzo1TBJ1xALwj18D9YIEOR3FuQFTkrgK57V
         AxoGiVa30ObXEC08ykwyBM1UeNseo2jpMqJus1PvZdPMhx3RFVLw9Ge0HWd/4J1ocIO/
         24rPtn0pRugds+Sg5nH4qvZosIv4X/149VfmNcMnUTFpARdNPD7ST3e0dSlEH/zCV5eH
         oAaSbzuJjUl2wm2a/JE31lLtr72UFVExaiDbemz+/vBqT7FFt4+PubPA52b6LCaA9CuR
         QCerDcDfXu9Ee+f4gIrDs050He1wtv/AGCwtXKY93Hdrf4+0SLbZo7+KfqhzTycenzuf
         QVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ClIUYr4iNr71p0PkfukRICrUdDDVofFV6FT0DKMV7Js=;
        b=XZWYRqxO1U3akcDI72QNXLc43/7ogebZWQgYEs7hrkEA51+5HyWJJN4TyPsCMRoJVK
         E9OSOyFgBu0LgFSmQTUeG2/DUqNWmGEbV5oQByuH0s9xQBp5UqaI4gdXo80J+22SxNY5
         tSvp4fJbqFC/E7cRFf1haBag3Np/w8TmwzgAbQbwUMZPFp+5xHxmP3Zw5lgYRTFYw1YB
         HxDc7zjiFuoNN0b9/FBGYRtVaOrpb1NVJSTqLjyrOquD561j7ap6BBrgfcWvCgEV04eG
         QuQYS13kOZS2sjlbHRAKHZTccyE7sOmlXfJSr/g2Rd3RY3z1eyK8u8mc3PCGM9jNVuli
         3aVg==
X-Gm-Message-State: AOAM5311njxhVgCxOJBElTiAnJvfB20AwNCMVUI+xNlCDIFqPKFdiNp2
        7mEV3zcj/anCzmwRhNBkvrjD10Zz4bbhaA==
X-Google-Smtp-Source: ABdhPJwvD0YcdUGtp3sTzDOLV/Rp6ccloF16ehKufy8UwL8oRgpvIdWtgKajo5MdUZTBNgS33pTXvw==
X-Received: by 2002:a17:902:9884:b029:d2:4276:1b64 with SMTP id s4-20020a1709029884b02900d242761b64mr7957383plp.76.1601569379317;
        Thu, 01 Oct 2020 09:22:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/8] ionic: check qcq ptr in ionic_qcq_disable
Date:   Thu,  1 Oct 2020 09:22:42 -0700
Message-Id: <20201001162246.18508-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a couple of error recovery paths that can come through
ionic_qcq_disable() without having set up the qcq, so we need
to make sure we have a valid qcq pointer before using it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5906145e4585..efffdfe18406 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -266,29 +266,26 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 
 static int ionic_qcq_disable(struct ionic_qcq *qcq)
 {
-	struct ionic_queue *q = &qcq->q;
-	struct ionic_lif *lif = q->lif;
-	struct ionic_dev *idev;
-	struct device *dev;
+	struct ionic_queue *q;
+	struct ionic_lif *lif;
 
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
 		.cmd.q_control = {
 			.opcode = IONIC_CMD_Q_CONTROL,
-			.lif_index = cpu_to_le16(lif->index),
-			.type = q->type,
-			.index = cpu_to_le32(q->index),
 			.oper = IONIC_Q_DISABLE,
 		},
 	};
 
-	idev = &lif->ionic->idev;
-	dev = lif->ionic->dev;
+	if (!qcq)
+		return -ENXIO;
 
-	dev_dbg(dev, "q_disable.index %d q_disable.qtype %d\n",
-		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+	q = &qcq->q;
+	lif = q->lif;
 
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		struct ionic_dev *idev = &lif->ionic->idev;
+
 		cancel_work_sync(&qcq->dim.work);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
@@ -297,6 +294,12 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 		napi_disable(&qcq->napi);
 	}
 
+	ctx.cmd.q_control.lif_index = cpu_to_le16(lif->index);
+	ctx.cmd.q_control.type = q->type;
+	ctx.cmd.q_control.index = cpu_to_le32(q->index);
+	dev_dbg(lif->ionic->dev, "q_disable.index %d q_disable.qtype %d\n",
+		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
@@ -1794,6 +1797,12 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 	int i, err;
 
 	for (i = 0; i < lif->nxqs; i++) {
+		if (!(lif->rxqcqs[i] && lif->txqcqs[i])) {
+			dev_err(lif->ionic->dev, "%s: bad qcq %d\n", __func__, i);
+			err = -ENXIO;
+			goto err_out;
+		}
+
 		ionic_rx_fill(&lif->rxqcqs[i]->q);
 		err = ionic_qcq_enable(lif->rxqcqs[i]);
 		if (err)
-- 
2.17.1

