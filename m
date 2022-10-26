Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ECF60E382
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiJZOiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiJZOiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:38:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E033AB7F67
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 130so5124204pfu.8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=gMICKn9JaeTJ2U8eilapX7Uet3mnhi4b6+yY4DzrALdvd7RzqDsLcdD3eVyxN1/Dun
         8KX/SoDTf2irIH1bpCDG1gLkpGOvnrndqsGv3++JHEwVSJoXsAA1dPxqypqFbUiROJW8
         D7kYOFDHs1LV0h1zWiRtZ9t83UFp1rh6Rh0Z0/HHnj04iSzsWMnc6oGMuC00zHdKIjBg
         6tLx0hYZx7oN22siFK1W4Verir4lVJd10x2qH0oFwcrJTMfVgOZTLm0HOSdetsJ3yZi9
         0ElHL3lHR4o3faRUIhMBmKCm/gXV6HEpMAMR08uFSBDrCCc2ZFRFuHvDuH/fZdSlnNdu
         ccVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EVLVwUvbbdRnPXpgkgorL4XSYztL7If2w8Rlat5ya04=;
        b=a/BkljTmjMRL99uueMPRpGksvWoMeTqJ0BVAoqNLEvVNHU91u+crUyiGUcKKFsQrec
         T890fAzdFDeKmmT60OmUbuUY5zUEG4r48cS/xvLelqCEZAZQhxL3VmEuKTF+Z5fTqAyB
         j0IKKa77GoMwJvipJ7rRQo55DtOz2E3VhUpIp+O0akOa0gN5/COwgCoY3Gs8Yc7zm+Oq
         SEKcpqzBHQXOVjMg2CffnsDSnYwqLgGqgFENjnAM1+0LNE7cynAnrEvpZ6+WCWE4cZrv
         3LOPfasqhv2GYWRwp70segNA8AbtfUiUe1+JCMWe9/e16Qk+EeEPayiacQNIGKWjwyZa
         BEpg==
X-Gm-Message-State: ACrzQf1qTro5HygSgeQBp2yMjXSjrWepXLF14iaCoOwX0u1lz6oiEUar
        LFmDVCoUR3JPNSeuBi/KYCWeWg==
X-Google-Smtp-Source: AMsMyM6dbyW4zUpgZ3Xny5v4TofrhVfYY/Vt/2AhzR4mMiL3q2qG8RHaNKBsv66wtEsD06QwWW7FJQ==
X-Received: by 2002:aa7:8896:0:b0:56c:6e7a:a750 with SMTP id z22-20020aa78896000000b0056c6e7aa750mr2331083pfe.19.1666795077314;
        Wed, 26 Oct 2022 07:37:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm3060484pfa.184.2022.10.26.07.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:37:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Neel Patel <neel@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 5/5] ionic: refactor use of ionic_rx_fill()
Date:   Wed, 26 Oct 2022 07:37:44 -0700
Message-Id: <20221026143744.11598-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221026143744.11598-1-snelson@pensando.io>
References: <20221026143744.11598-1-snelson@pensando.io>
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

