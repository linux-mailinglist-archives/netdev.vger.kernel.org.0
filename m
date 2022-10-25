Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1B60CADD
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiJYLYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiJYLYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3139A11DAB8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q9-20020a17090a178900b00212fe7c6bbeso5711255pja.4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=B+PjiOXl3uyRro39W/RmHy6rmv8Ru3iBDmXuMq/Zbc4Ctz2ySTsqhpCapMgLP7qbHk
         oRvpAZS6jUO272k2c4+7mkAzboUbr4aHKDNK8qwVqBlk9TSdKHgKOK8ju+24h4m12jUQ
         384ae+rXjL0XotL9jhCMp0N/JLR5VlkRXld2mScUm8XFmPqeiauuYYgGWLbzq5z4OIQk
         DT1eUcR/NVZp8GyWxoe5YDrmrN0WZ3S7WLQOdw00EpaddOWDstWLPFjNJ5Xv0YKmeMp/
         4Or1PUQsLSTOP7vMQ6ijLHJx8f7uju9UlyJ6BwAShoR5GvWahldxUpx1arvsQYV5Bhvn
         +dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=OlTOHmNQuwybWu8Vexh8eOGcL5n4a8oiJY13x2MR/87oh6qnpCYrp6O7wgHXKCKAJM
         xmPqwAjpgV8MLtNKT8shetE35NU4GlWUffeXw8ZSkQnd3JbomqSfR6/k9ERg0yEGsphu
         r7QmZY0myMWc20Vt56YE9aNFBNA3HSbmgzmAtxzug8wN6gVtevT4sv2/8Qj65qLigk0c
         /WLCcCcO9XPK75nQXLQiW2afZKjOXGxbifzfI4M6lFQgdGzvgHAIVnkPA+D6MYXfDcag
         raB+kqq1uxBQmZh7pqZa0ld2noL/CHMhV4+AT1zVe1ph7Iopg4lvqqSE1Ewwnp27Ct05
         eN9A==
X-Gm-Message-State: ACrzQf39lBAy5V2FJBrF9lCEwDOCH+9aQ+eBwBQPSFrlTRCynA3MDW5A
        OO8TJTh9mNlzz7TS659IHYZNag==
X-Google-Smtp-Source: AMsMyM7dGFlYKwlhHXWEh+DWwenDj4Nb4ymEUMYayoi9BLqaDzfWSBSE+2YFKOXoVdDNG8c7kFmNxg==
X-Received: by 2002:a17:903:2307:b0:17f:78a5:5484 with SMTP id d7-20020a170903230700b0017f78a55484mr38323295plh.15.1666697081691;
        Tue, 25 Oct 2022 04:24:41 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/5] ionic: refactor use of ionic_rx_fill()
Date:   Tue, 25 Oct 2022 04:24:26 -0700
Message-Id: <20221025112426.8954-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221025112426.8954-1-snelson@pensando.io>
References: <20221025112426.8954-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neel Patel <neel@pensando.io>

The same pre-work code is used before each call to
ionic_rx_fill(), so bring it in and make it a part of
the routine.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 190681aa7187..0c3977416cd1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -348,16 +348,25 @@ void ionic_rx_fill(struct ionic_queue *q)
 	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_buf_info *buf_info;
+	unsigned int fill_threshold;
 	struct ionic_rxq_desc *desc;
 	unsigned int remain_len;
 	unsigned int frag_len;
 	unsigned int nfrags;
+	unsigned int n_fill;
 	unsigned int i, j;
 	unsigned int len;
 
+	n_fill = ionic_q_space_avail(q);
+
+	fill_threshold = min_t(unsigned int, IONIC_RX_FILL_THRESHOLD,
+			       q->num_descs / IONIC_RX_FILL_DIV);
+	if (n_fill < fill_threshold)
+		return;
+
 	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 
-	for (i = ionic_q_space_avail(q); i; i--) {
+	for (i = n_fill; i; i--) {
 		nfrags = 0;
 		remain_len = len;
 		desc_info = &q->info[q->head_idx];
@@ -511,7 +520,6 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *cq = napi_to_cq(napi);
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
-	u16 rx_fill_threshold;
 	u32 work_done = 0;
 	u32 flags = 0;
 
@@ -521,10 +529,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	work_done = ionic_cq_service(cq, budget,
 				     ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  cq->num_descs / IONIC_RX_FILL_DIV);
-	if (work_done && ionic_q_space_avail(cq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(cq->bound_q);
+	ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
@@ -550,7 +555,6 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
-	u16 rx_fill_threshold;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
@@ -565,10 +569,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	rx_work_done = ionic_cq_service(rxcq, budget,
 					ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  rxcq->num_descs / IONIC_RX_FILL_DIV);
-	if (rx_work_done && ionic_q_space_avail(rxcq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(rxcq->bound_q);
+	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
 		ionic_dim_update(qcq, 0);
-- 
2.17.1

