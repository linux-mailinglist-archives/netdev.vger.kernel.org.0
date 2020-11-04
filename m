Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41952A7092
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgKDWeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732162AbgKDWeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:07 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65991C0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:07 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c20so18519503pfr.8
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T4Y3nDGLzMHA66yGPJNoaME43oRNIcZvy5J8hI+97Ds=;
        b=neISJ2ECmPxvt58psg1thJFFYJjoRLJojqw4u7m/OOkZndVJhwAVySxXoZ1DXnVqM9
         0Cf+GQ75cRRmxBKbD0GEFPrA35oey/gW75voTaW9Dyy2utd1C69n6ak14UQQYKwGkVVx
         a5O8xvPdDwfEM2iE6idQeNyD2d3T+x+xLUg8jlI74KyW37yMDJ35ZElZYHE3OR+lFIMW
         6IbWf3lZSOtYqBbxvoTITUP5yAi3l19aZAk+Krsi/E1rZDJABJOkBy2RdEi0FOIW5iLy
         Qvni+LOfEr1QD4OrcTxhIY4qK6vQe6ZRI9yU9fsdAcY+45b6DTNB2droPuRrbX0HJe6+
         T+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T4Y3nDGLzMHA66yGPJNoaME43oRNIcZvy5J8hI+97Ds=;
        b=Lb5CtoQruvnENUisuvuAaOxo3qJuUwUswAKh1X1Ah14VT4+MDxuUkOw1yRq/296BCT
         pgiJvltIzFtOl6SWMR4FQiyvjcibCZHuGKOw/OEHw+CsNUO0z8VkXn1psFrcWgBevT0E
         gLQBR9uBK+KBXuSWi8Au+t19kyY0ZudltnotMSNkrDQCrZH5WzPUG4Eq9pOMAqENV0cb
         o9Afej5xvNwQIJVjc7jvwNrce9bgD26x5pApIR1VAIbkqX9+ILf66suJ0sB2Bq9KiBgC
         M4ibM0teWxCVdUKGbMduZPOj3KBGEkE6+hioJQj8r8uqasEv1LV2c4PNZ7d/MmeAmeoI
         bkKQ==
X-Gm-Message-State: AOAM5332BQt+xUzRt1LKZ7/xZYaP1xl68bZ4cMY/dqO7BwnInWcBM8Pf
        vzRts46L4wSZ5hIrffUN9SHXtSgpmTXwsA==
X-Google-Smtp-Source: ABdhPJzokIcjzJ2zSGjoPbLj3aDG4ktxvYauqdx3D7KVYf6Ma3rrP22KirJj8hYr/SoF0rUCF3fWbw==
X-Received: by 2002:aa7:9f90:0:b029:164:bcf:de16 with SMTP id z16-20020aa79f900000b02901640bcfde16mr17605pfr.3.1604529246715;
        Wed, 04 Nov 2020 14:34:06 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:06 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: batch rx buffer refilling
Date:   Wed,  4 Nov 2020 14:33:52 -0800
Message-Id: <20201104223354.63856-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to refill the rx descriptors on every napi
if only a few were handled.  Waiting until we can batch up
a few together will save us a few Rx cycles.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h    |  4 +++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c   | 18 ++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 6c243b17312c..9064222a087a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -12,8 +12,10 @@
 
 #define IONIC_MAX_TX_DESC		8192
 #define IONIC_MAX_RX_DESC		16384
-#define IONIC_MIN_TXRX_DESC		16
+#define IONIC_MIN_TXRX_DESC		64
 #define IONIC_DEF_TXRX_DESC		4096
+#define IONIC_RX_FILL_THRESHOLD		64
+#define IONIC_RX_FILL_DIV		8
 #define IONIC_LIFS_MAX			1024
 #define IONIC_WATCHDOG_SECS		5
 #define IONIC_ITR_COAL_USEC_DEFAULT	64
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index b3d2250c77d0..9156c9825a16 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -392,11 +392,6 @@ void ionic_rx_fill(struct ionic_queue *q)
 			 q->dbval | q->head_idx);
 }
 
-static void ionic_rx_fill_cb(void *arg)
-{
-	ionic_rx_fill(arg);
-}
-
 void ionic_rx_empty(struct ionic_queue *q)
 {
 	struct ionic_desc_info *desc_info;
@@ -480,6 +475,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *cq = napi_to_cq(napi);
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
+	u16 rx_fill_threshold;
 	u32 work_done = 0;
 	u32 flags = 0;
 
@@ -489,7 +485,9 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	work_done = ionic_cq_service(cq, budget,
 				     ionic_rx_service, NULL, NULL);
 
-	if (work_done)
+	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
+				  cq->num_descs / IONIC_RX_FILL_DIV);
+	if (work_done && ionic_q_space_avail(cq->bound_q) >= rx_fill_threshold)
 		ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -518,6 +516,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
+	u16 rx_fill_threshold;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
@@ -531,8 +530,11 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 
 	rx_work_done = ionic_cq_service(rxcq, budget,
 					ionic_rx_service, NULL, NULL);
-	if (rx_work_done)
-		ionic_rx_fill_cb(rxcq->bound_q);
+
+	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
+				  rxcq->num_descs / IONIC_RX_FILL_DIV);
+	if (rx_work_done && ionic_q_space_avail(rxcq->bound_q) >= rx_fill_threshold)
+		ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
 		ionic_dim_update(qcq);
-- 
2.17.1

