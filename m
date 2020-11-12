Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50982B0C7E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKLSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgKLSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:21 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C6DC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:21 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id y7so5280687pfq.11
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hr6aj6JtxGducKoxvMPXrY7OCt+4LEbjDkNLR4EhT44=;
        b=o3pzVPKWpsml5L5vhv35FBu2gb87nep/gJOBHOmE2c+KlITQzAhRKF+mizncCcdYkd
         z2fj55AV4XwM695Ch9E6XGPPRZkrJfC6g/npagzUyyDehgEYToX80Jg0phfuansxprJO
         GGr6dIdopVhAh2MYDZTUY3h4ndy5D9zC2rQyimgyf+0c7qjsKdlQevNFCk2sYMafZUrV
         VBY2l3R2Hs10FA/j9VNqSrJWujtx45D+RNfQPdaLZ0mF/mtcmB2Zoo7teRpPb7Tu1X5o
         PIM36LU+XgDA94wEi+r2S/S6UDs9RcJQSPYTwwexsrlePvDt9obKH63u10xjAlPkU6S+
         ZBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hr6aj6JtxGducKoxvMPXrY7OCt+4LEbjDkNLR4EhT44=;
        b=WTEi0akPY+C7PFKL/6dnu1ur+8pQIYz5yMLTTTWobSaUrvGKSV7L7TKg/IVUwYEXXO
         5JMHkxB4HSVg2xmOmd1e3oAgirlDnmYDI/f+1jtOneGOzZU7sJZtRrGLHnvDNXnw+j9P
         ArUQYiXsXLDzknueRe59QUQav3cGk5oyppcD44xhPC33Botd/omzuWEj72YUlwiYkGv6
         4KFjpU1ij+l00BrAxv727qzDs4zuGGiV97rVHSUaI1TIJaEeGxY7wkwV0S7dVsAW3vyi
         Xpq25oZb+CGdtONlHlQRTKn9lKggO6WaxAd7mrpPV9PcE+iRFhFtgTBx6jEj5BkQuade
         G4tg==
X-Gm-Message-State: AOAM533WzRDZJGDY/bHgFH59ybqSHGzPCjmuXj+F2YrvDhjkqTjDLFbK
        /kCooEqc2DbvTtXc70F3u8SvAEZx5OoYDQ==
X-Google-Smtp-Source: ABdhPJxa5h+8z9qX1Ccq6CoaiI+jr2rpxuFPk5itrb1oC2ptB69duV1U9yIVIX4bPj9BcttXMgJDVw==
X-Received: by 2002:a62:804d:0:b029:18b:9bf:2979 with SMTP id j74-20020a62804d0000b029018b09bf2979mr534793pfd.11.1605205341110;
        Thu, 12 Nov 2020 10:22:21 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:20 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 4/8] ionic: batch rx buffer refilling
Date:   Thu, 12 Nov 2020 10:22:04 -0800
Message-Id: <20201112182208.46770-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to refill the rx descriptors on every napi
if only a few were handled.  Waiting until we can batch up
a few together will save us a few Rx cycles.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h    |  4 +++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c   | 18 ++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 6c243b17312c..690768ff0143 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -12,8 +12,10 @@
 
 #define IONIC_MAX_TX_DESC		8192
 #define IONIC_MAX_RX_DESC		16384
-#define IONIC_MIN_TXRX_DESC		16
+#define IONIC_MIN_TXRX_DESC		64
 #define IONIC_DEF_TXRX_DESC		4096
+#define IONIC_RX_FILL_THRESHOLD		16
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

