Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32512A8B29
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbgKFAMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732660AbgKFAMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:36 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AF1C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:35 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g7so2388531pfc.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZTTdvHFepw40UzyfBUYLlofllO40qi0wrEoklyhrPBg=;
        b=WitwLI8UcsLXlRmUrzeq4d9h9ADr5appgpqGPoir5ROBq/8DghMoENFeiQvb1VyNSO
         UTfuzLedFuDoI4L2RGQQ+yvzc9TGyBfey8N7SOAPhQiayXj3aTFb4bP0524mMHhNHxut
         b13tsuuAqCkyKfKX3wYr8udCb5Dfnc7AOPDhw4QV94xMiIbll7qcPHgA2enD+4S/Ady2
         gDQ1TU5S9bLGnZ7aMRkSN7ArHL+jMGOP1IQfs0UysBBiO/blx18jXAwWJLrV2l4icMI/
         eDwvR/BuPXMfYqFS7tzOr/dgL+cLzoYiVy5S/uqSxxDo6tYykNByFL2YZ82Zk5rnuTGi
         XSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZTTdvHFepw40UzyfBUYLlofllO40qi0wrEoklyhrPBg=;
        b=MgyqTKi6U1IxKbbBZTlm6cBdc4DeokKyNkaIENq0ersHFufUYuxY1EAxqMwh/QCrCd
         4bRNvhUZK3UhXBNsAygfUdlEBCBusQTYDCLYlh/sivzXq6L+j0uj9HBDzFGJdo0jmQ4g
         EDWP6i8viI3qkrqqVJ31oJKvHVPgIGxOQ82Jm3DJXJvKEg1L53jcecTHF4kZpD49zOV1
         Li8OSrrfroJvKiOWo1lEJHDtlpeJhV9FWcuF0TObUnA4K8XxA2q7mo25Opdr70yZ7bC8
         t7hlSaHaKH47Xmwn0bBF7Jf19oFx+KHYNY1wksXgZGBYEsxa3P29E3L3udwVCO7LXmCK
         rf9A==
X-Gm-Message-State: AOAM533diTIVfpF4H4pNrNbZD5ljZl2HcVabkGJY9U8+c4lPxCthfx3M
        nXT81zqMwXPAaaesieuLBAjuzr6GPr6Uxw==
X-Google-Smtp-Source: ABdhPJzt0zcfc0dy0aUp+BNiNeKOXgj0oSzBZrcBchlnO+0dYILFg3+6XYvE0cvv1gdRXkGJLGaJuw==
X-Received: by 2002:a17:90b:942:: with SMTP id dw2mr4714450pjb.14.1604621554594;
        Thu, 05 Nov 2020 16:12:34 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:34 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/8] ionic: batch rx buffer refilling
Date:   Thu,  5 Nov 2020 16:12:16 -0800
Message-Id: <20201106001220.68130-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
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

