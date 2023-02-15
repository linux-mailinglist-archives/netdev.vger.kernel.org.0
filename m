Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3034D69861C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjBOUr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBOUrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC54347A;
        Wed, 15 Feb 2023 12:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC675B823BF;
        Wed, 15 Feb 2023 20:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453F5C433EF;
        Wed, 15 Feb 2023 20:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493998;
        bh=poIkIYgz/XPHmp8iv8kF/HMBQWJucD1pFg/cdPeqn9k=;
        h=From:To:Cc:Subject:Date:From;
        b=jkTMGbdUphuMFNXwE8c3VycnbN3T8tDIa1ksfJH4Em3BclxmCfR8I+B4mJBQuTas9
         vibaUig4KcPPZ6oMk3QkZDLdHdWTAhBGnR+dK3D0jZfP5WAbjKEjICv3SAu0svPaME
         0ieGiluc8bizTUOeQIkGhAeBujs0iZcqXQJUBw6JLH3JjQSSDXvjG2IwT3AMFlpMht
         yMv+G6GnCG1SbpnJrJZS7+ULNLlBsCsD5bs5pP1BCVwEjKKCdJ81k1uyaAkna34mH6
         uN3ki/pXGjJ49sAWKXDP0l3LY1T0fAALbSp1waoMFffADDGgYFayI16bgO/4+kSH9S
         PQa8wRTbu+m6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shannon.nelson@amd.com,
        brett.creeley@amd.com, drivers@pensando.io, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/12] ionic: refactor use of ionic_rx_fill()
Date:   Wed, 15 Feb 2023 15:46:23 -0500
Message-Id: <20230215204637.2761073-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neel Patel <neel@pensando.io>

[ Upstream commit e55f0f5befc26e2ba6bb8c1f945ea8e37ee0e334 ]

The same pre-work code is used before each call to
ionic_rx_fill(), so bring it in and make it a part of
the routine.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 37c39581b6599..376f97b4008bb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -353,16 +353,25 @@ void ionic_rx_fill(struct ionic_queue *q)
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
@@ -518,7 +527,6 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *cq = napi_to_cq(napi);
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
-	u16 rx_fill_threshold;
 	u32 work_done = 0;
 	u32 flags = 0;
 
@@ -528,10 +536,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	work_done = ionic_cq_service(cq, budget,
 				     ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  cq->num_descs / IONIC_RX_FILL_DIV);
-	if (work_done && ionic_q_space_avail(cq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(cq->bound_q);
+	ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
@@ -559,7 +564,6 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
-	u16 rx_fill_threshold;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
@@ -574,10 +578,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
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
2.39.0

