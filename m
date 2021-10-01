Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C66041F459
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355716AbhJASId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355700AbhJASIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5503DC0613E8
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2426651pjb.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eeoQ+f/yotSWbwWyXV8VLI9o0qIYNZxrh88pRzZ1F6k=;
        b=MsTTBo+XHYiO6YXofm/ZY5m8oEickevOegGqwAumJRzgPgCz4YLKUrDrt8v7N0nZ1z
         0qZFid1TCFGJ366munfYxDOzo/XDPy6Ue36e5mIe3gu81scj/dNu3qwVlGyAuSMh9LVz
         3P9ZRtNqQI4CM//t0wlzXE8In6p7UNMVVm5QOKZAk9nO9VlUsV4iMqiT9ZaeNfOt2+7k
         eMcP0zNpK7a+Y338CzQ2zfzDzWtYLzkNsL5PdX4oQ+CAQZ37dUH31wHfge+ei3T6EU0v
         JELtz5y8GYraZ6AHVCqrW5jpCm693kQtQ8w48DiK1dXPAToPlXParGV+cLg7y9D+kguR
         IE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eeoQ+f/yotSWbwWyXV8VLI9o0qIYNZxrh88pRzZ1F6k=;
        b=ezWPq1X7TOABCyS/m7btBqsAmobVmyo1mkFdEJtlea8zxIpien3XsezLk65NjfTCy5
         pf1gF0lfrEUicyWHsoWdb+bQKu61hFb1agr4GkHR/tbnQX2ReMtOkpF7+S/X0Tp632dp
         DY9HRrwmc462lZn3JNFgwsf1hOdmO5egOeYutctbvciz7L/1GpWfFN+Z1uu3bQUbCfQc
         kFhAKnQtZfLU7/erl5g7Q7GWzHDgkol+CB6UthXzFETtvJfBxAfQX9donivhDBeB0dQ6
         JWxY8h6Mv68uYdHgG4ufDNwPsOEgNhFM9cgpNl9VvCcVCe3mFWbyritYkZmZGif0YUsk
         PEYg==
X-Gm-Message-State: AOAM531VjcaswMh/tClEZG5/0PRWlCyhzANhuopdDwJnJbC3kshE4XeY
        aK2rRWzXstttHleW73Sw7FvT+w==
X-Google-Smtp-Source: ABdhPJwG1BuO4u8/SEXWH8gPHZfVmQT0ky0rFfdp5RR4assZi4F3jrionHY38aTy3KakRMmuAQxxHA==
X-Received: by 2002:a17:90b:17cd:: with SMTP id me13mr13755942pjb.115.1633111604925;
        Fri, 01 Oct 2021 11:06:44 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/7] ionic: have ionic_qcq_disable decide on sending to hardware
Date:   Fri,  1 Oct 2021 11:05:56 -0700
Message-Id: <20211001180557.23464-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
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

