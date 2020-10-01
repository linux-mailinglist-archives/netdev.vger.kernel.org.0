Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792FA2803CC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbgJAQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732230AbgJAQXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:23:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E3CC0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:23:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so4394956pgm.11
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Crr7PSXFTq9YbjqXq0TxN69wsQ1MyA79mkwEfR5jo/U=;
        b=XEKdo+iGzWV313bExsECKolsqHALXhhHNMcoNWJ//yb+iA5EKH4WDK/kxFC/mOEwgd
         Aglxt/0ZYcQvTlvNAJR2BA3uo6rQyTsmeMETYKFOZVzu3Pboj2hrp7CsrLUn9ocMcPXJ
         u779c7nCSzfdz5/7VBz7AmYbk5eNab11ncFQqS5tqZaR2wMPKfXuEKK7a3IOWLOmkFGb
         nrvzXMxdWdHsK3kQIM06rOlvBmcgyTHGZ3iZSe2HAL3AptPU7IQHSd5Hq9GsQLFF8yzD
         qh6PwwClKY6BDrnMEuKFmond0OIiTkOPErlh9//JCZn/LnqFClKztxls/bA8+oJ6SzdB
         xpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Crr7PSXFTq9YbjqXq0TxN69wsQ1MyA79mkwEfR5jo/U=;
        b=cRe712zK2y5zEl9jWmTHzMCyh4BAJ4Le0Jnk/5FYdqfr5hjoE1glvPmHlKyXoe4Zi7
         AWKxP0WUtbgsH2TWENgZqitSwMA9VE7qdGqu4WlSF/m4zWHYslkp2prdCM03gOkTZxVF
         unuIvTJiZ56FWPCf4qgHysqLtbstsODD9eL+LrKQ8etgC9Ske4+bkUjPMDJfNSrc6n+h
         lU7qEET7r9blk3STq5qebbendkNv2npz6mvom12xuJsRmOzOd1sQt+t5lwCZ7cNDTMgt
         q5vte3YNLzvJ45ME5cN0ePlDteM4HDBoP1U3hf+s7CVAguvVv5Rr7wZJa1hCYS0fN3j8
         2nKA==
X-Gm-Message-State: AOAM532YfMhWUOHyhn6OfUrWgm2SxRQi3opaxVdKlIN966yo+9t6NsOr
        Bvah69GsUEVX6m2cMkTu8UueH0c2NAVytw==
X-Google-Smtp-Source: ABdhPJw9PfGL+2dkEUCtigzkbCi5YYWzc2S/zyFyQj9WSzBB7tl3pz3Oj0rJZqUrw8jM6quxotl+iA==
X-Received: by 2002:a63:5966:: with SMTP id j38mr6702895pgm.187.1601569380274;
        Thu, 01 Oct 2020 09:23:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/8] ionic: disable all queue napi contexts on timeout
Date:   Thu,  1 Oct 2020 09:22:43 -0700
Message-Id: <20201001162246.18508-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some time ago we short-circuited the queue disables on a timeout
error in order to not have to wait on every queue when we already
know it will time out.  However, this meant that we're not
properly stopping all the interrupts and napi contexts.  This
changes queue disable to always call ionic_qcq_disable() and to
give it an argument to know when to not do the adminq request.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 47 +++++++++----------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index efffdfe18406..2b6cd60095b1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -264,10 +264,11 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
-static int ionic_qcq_disable(struct ionic_qcq *qcq)
+static int ionic_qcq_disable(struct ionic_qcq *qcq, bool send_to_hw)
 {
 	struct ionic_queue *q;
 	struct ionic_lif *lif;
+	int err = 0;
 
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
@@ -294,13 +295,17 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 		napi_disable(&qcq->napi);
 	}
 
-	ctx.cmd.q_control.lif_index = cpu_to_le16(lif->index);
-	ctx.cmd.q_control.type = q->type;
-	ctx.cmd.q_control.index = cpu_to_le32(q->index);
-	dev_dbg(lif->ionic->dev, "q_disable.index %d q_disable.qtype %d\n",
-		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+	if (send_to_hw) {
+		ctx.cmd.q_control.lif_index = cpu_to_le16(lif->index);
+		ctx.cmd.q_control.type = q->type;
+		ctx.cmd.q_control.index = cpu_to_le32(q->index);
+		dev_dbg(lif->ionic->dev, "q_disable.index %d q_disable.qtype %d\n",
+			ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
-	return ionic_adminq_post_wait(lif, &ctx);
+		err = ionic_adminq_post_wait(lif, &ctx);
+	}
+
+	return err;
 }
 
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -1627,22 +1632,16 @@ static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
-	int err;
+	int err = 0;
 
 	if (lif->txqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
-			err = ionic_qcq_disable(lif->txqcqs[i]);
-			if (err == -ETIMEDOUT)
-				break;
-		}
+		for (i = 0; i < lif->nxqs; i++)
+			err = ionic_qcq_disable(lif->txqcqs[i], (err != -ETIMEDOUT));
 	}
 
 	if (lif->rxqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
-			err = ionic_qcq_disable(lif->rxqcqs[i]);
-			if (err == -ETIMEDOUT)
-				break;
-		}
+		for (i = 0; i < lif->nxqs; i++)
+			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 	}
 }
 
@@ -1794,6 +1793,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 
 static int ionic_txrx_enable(struct ionic_lif *lif)
 {
+	int derr = 0;
 	int i, err;
 
 	for (i = 0; i < lif->nxqs; i++) {
@@ -1810,8 +1810,7 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 		err = ionic_qcq_enable(lif->txqcqs[i]);
 		if (err) {
-			if (err != -ETIMEDOUT)
-				ionic_qcq_disable(lif->rxqcqs[i]);
+			derr = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 			goto err_out;
 		}
 	}
@@ -1820,12 +1819,8 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		err = ionic_qcq_disable(lif->txqcqs[i]);
-		if (err == -ETIMEDOUT)
-			break;
-		err = ionic_qcq_disable(lif->rxqcqs[i]);
-		if (err == -ETIMEDOUT)
-			break;
+		derr = ionic_qcq_disable(lif->txqcqs[i], (derr != -ETIMEDOUT));
+		derr = ionic_qcq_disable(lif->rxqcqs[i], (derr != -ETIMEDOUT));
 	}
 
 	return err;
-- 
2.17.1

