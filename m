Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5653609ED3
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJXKRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiJXKRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:17:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E72696FC
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m2so3793667pjr.3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=HsM2iTUaK/TxgpF5+Y/D+LQff6N5qH5RyBb2smeNJLtiD8Y7WKLhpjyWimEK4CrrKW
         n8+DBXe/PMzWlAU0DTkgVpXZD0V5qrelGyhQhgwQhyDUoRn8mjwjNt58JZhGNh+etTS8
         Zfje15i7R8LL1ZSjbLr/S4Z5KG8x/c4lFkmw5qDn9pi268XjpKY+t9N0WH6L4LhJocjk
         HIb0wRunxb7i7btjc8Y1o2hwCTA7MA6E9QNjfJXX1BoAxBj3+XtqmkCUBpig77TWRu0n
         eLRUUcjAHhi1A8PyKNZZyA38FX7/c030jFYvOF2zairCRYPVt1RRi3b8VkOz3QAWoEV/
         m+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=Rg5nJkbl/0qOEjSlZjTApzCKEF1cXkC61ukzbIdns2jo0BrgOcHCPyMfpdFTPOSCEO
         erGGM1RtN9YtgoHUb8a/681dgJjBqHkrNsLMPff4SjvK7uqhE8pVe1YIgMIVJBvS+TpR
         Ll6LgJmZCeT63a5Vh1c4eBHXKzFZtpfiF6xy44UbFJ0CVEK99Fd+2yItWPycG2xIpR0c
         DbIZWdO78GINJivfIR5r/5WhFQOX7AkHSewl33HP9Vo0jzSHK/BeeryYY8Co/qw94QH/
         giGYxfCoKgVTNGHjO9QtYio87O11V0iM5vfTPpX4xoW0xn3m83IRIDd22QaVxZgkG4yH
         X5Qw==
X-Gm-Message-State: ACrzQf2WqxrieLumxzmufPBn4JqPOYsxrPjd4Jr5iR2bh6KbAK1Btu1F
        Ds/340eev/fD85s0kTDr/D0OKw==
X-Google-Smtp-Source: AMsMyM6VjvcwZoaDonxPg8stqCgO+61T1wPsYYSZXVWgBjZaJeiW2tzC7wxfvkch8hvKJVjBUSSewg==
X-Received: by 2002:a17:902:ebc5:b0:186:b848:c6a with SMTP id p5-20020a170902ebc500b00186b8480c6amr476894plg.46.1666606652389;
        Mon, 24 Oct 2022 03:17:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h197-20020a6283ce000000b0056bf6cd44cdsm586290pfe.91.2022.10.24.03.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 03:17:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/5] ionic: refactor use of ionic_rx_fill()
Date:   Mon, 24 Oct 2022 03:17:17 -0700
Message-Id: <20221024101717.458-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221024101717.458-1-snelson@pensando.io>
References: <20221024101717.458-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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

