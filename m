Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9563141F33B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355350AbhJARkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355219AbhJARkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22575C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:33 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g14so8604460pfm.1
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eeoQ+f/yotSWbwWyXV8VLI9o0qIYNZxrh88pRzZ1F6k=;
        b=WhCL8b+OAfUUgIss7yjC+wOF8ZGyXA7RaW9JpaogRg6WkaE6S0Gb4DpmfCXSqmgLid
         aq1tLn8RhWKlluqqKwCoZsFxXc9chEogIzpkyuqP7KPEJ70wpueUWGt/rW1wJOorjk9i
         HdaAfIeFarRWE49yzpNubX8lcFIZNil/ilbhNdTVKZCY79MbNvnumIoWhZLFTeNiL7G8
         lpGwS4s3RZRUaX47UJNmlVZK3PI6TTGZ+BY0X190211Wx2wh9HLdavW/u//96pPivFOH
         mn7IwR2ow7q9bn2MOvf5ghxLPPruMjdLMWUG9sb4U5eD8jUfKxyComqoD2BKevQETuw5
         SmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eeoQ+f/yotSWbwWyXV8VLI9o0qIYNZxrh88pRzZ1F6k=;
        b=TNl2iA+ucAIgJHykN+0yhJiad/7HkPamu0UpUaffzXd+/WRyG4qaTwGObjm6XtMJVC
         po1Lwsf4UPROM4CGybtnmWiL+KBXC+cZSESbYdlkUEGctq4OAK9KhYHxtbO2Hdw0Jh9V
         fY1NmlylJ8CZOibfcmWt2BqsL7QOyvyq9d9gsU3MhtfIrkklvpbL+bejmsM0FnFqLnDo
         Cv4zdawDN931NDL8Ed6wMPBXXIpWXenuO8H7mtCjhT/lCHMXCzU4V/4DE1gy96ewz2HJ
         xIeEZgrYx3pL4hv9F1kkfeq6xDVzWpoTV3alVGrPM++RfuFA/d845k4PI+6Usp6Nevp6
         UmEw==
X-Gm-Message-State: AOAM5318ESUUO2llq9np4AwTUabFn0tBnmB2FDybB71LHxCJkTnbIFXy
        fIYw6U0KTujz79ey3EOHb9EXhw==
X-Google-Smtp-Source: ABdhPJx9bLeg61601n8j+fapZ0gsR7G47iHTMMDGUDlp4quhxl260Fo7rKFWvQRZ0QiRbqkG/f2E9g==
X-Received: by 2002:a63:6845:: with SMTP id d66mr10635176pgc.121.1633109912710;
        Fri, 01 Oct 2021 10:38:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/7] ionic: have ionic_qcq_disable decide on sending to hardware
Date:   Fri,  1 Oct 2021 10:37:57 -0700
Message-Id: <20211001173758.22072-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code a little by keeping the send_to_hw decision
inside of ionic_qcq_disable rather than in the callers.  Also,
add ENXIO to the decision expression.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 39 ++++++++++---------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5efa9f168830..16d98bb55178 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -287,11 +287,10 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
-static int ionic_qcq_disable(struct ionic_qcq *qcq, bool send_to_hw)
+static int ionic_qcq_disable(struct ionic_qcq *qcq, int fw_err)
 {
 	struct ionic_queue *q;
 	struct ionic_lif *lif;
-	int err = 0;
 
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
@@ -318,17 +317,19 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq, bool send_to_hw)
 		napi_disable(&qcq->napi);
 	}
 
-	if (send_to_hw) {
-		ctx.cmd.q_control.lif_index = cpu_to_le16(lif->index);
-		ctx.cmd.q_control.type = q->type;
-		ctx.cmd.q_control.index = cpu_to_le32(q->index);
-		dev_dbg(lif->ionic->dev, "q_disable.index %d q_disable.qtype %d\n",
-			ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+	/* If there was a previous fw communcation error, don't bother with
+	 * sending the adminq command and just return the same error value.
+	 */
+	if (fw_err == -ETIMEDOUT || fw_err == -ENXIO)
+		return fw_err;
 
-		err = ionic_adminq_post_wait(lif, &ctx);
-	}
+	ctx.cmd.q_control.lif_index = cpu_to_le16(lif->index);
+	ctx.cmd.q_control.type = q->type;
+	ctx.cmd.q_control.index = cpu_to_le32(q->index);
+	dev_dbg(lif->ionic->dev, "q_disable.index %d q_disable.qtype %d\n",
+		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
-	return err;
+	return ionic_adminq_post_wait(lif, &ctx);
 }
 
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -1947,19 +1948,19 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 
 	if (lif->txqcqs) {
 		for (i = 0; i < lif->nxqs; i++)
-			err = ionic_qcq_disable(lif->txqcqs[i], (err != -ETIMEDOUT));
+			err = ionic_qcq_disable(lif->txqcqs[i], err);
 	}
 
 	if (lif->hwstamp_txq)
-		err = ionic_qcq_disable(lif->hwstamp_txq, (err != -ETIMEDOUT));
+		err = ionic_qcq_disable(lif->hwstamp_txq, err);
 
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++)
-			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
+			err = ionic_qcq_disable(lif->rxqcqs[i], err);
 	}
 
 	if (lif->hwstamp_rxq)
-		err = ionic_qcq_disable(lif->hwstamp_rxq, (err != -ETIMEDOUT));
+		err = ionic_qcq_disable(lif->hwstamp_rxq, err);
 
 	ionic_lif_quiesce(lif);
 }
@@ -2159,7 +2160,7 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 		err = ionic_qcq_enable(lif->txqcqs[i]);
 		if (err) {
-			derr = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
+			derr = ionic_qcq_disable(lif->rxqcqs[i], err);
 			goto err_out;
 		}
 	}
@@ -2181,13 +2182,13 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out_hwstamp_tx:
 	if (lif->hwstamp_rxq)
-		derr = ionic_qcq_disable(lif->hwstamp_rxq, (derr != -ETIMEDOUT));
+		derr = ionic_qcq_disable(lif->hwstamp_rxq, derr);
 err_out_hwstamp_rx:
 	i = lif->nxqs;
 err_out:
 	while (i--) {
-		derr = ionic_qcq_disable(lif->txqcqs[i], (derr != -ETIMEDOUT));
-		derr = ionic_qcq_disable(lif->rxqcqs[i], (derr != -ETIMEDOUT));
+		derr = ionic_qcq_disable(lif->txqcqs[i], derr);
+		derr = ionic_qcq_disable(lif->rxqcqs[i], derr);
 	}
 
 	return err;
-- 
2.17.1

