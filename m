Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974EA584CAC
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiG2HdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiG2HdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BB47C1B4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:02 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r186so3405072pgr.2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yFHFgyPkmeP63Zp6lsFBIOMH+WFI4z2Il/CBc4HwPPw=;
        b=Gaycs6hUp21BQ+pfnv/oplxHvaB3avAszaxPyn0whnxSTAUjZzqyNEsfp6yG0B/yfJ
         zFVvtqmpTbjt4iUi7AxNEYCKWGgiKaPsSoQT34xi2ZUpT3b4FHwvrRuuYbmWgLOcMhD0
         ZE8FOcTOQ0J4fH9rFzgMD0NLbwTgbcO5lseoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFHFgyPkmeP63Zp6lsFBIOMH+WFI4z2Il/CBc4HwPPw=;
        b=43eFqyYIJvxLJRAM5rQer3JyfQpJ7vXbKY5XTFnu6x9jtso471dA+d5hhdKoHfpdw2
         Mjw8tgxFuTtj3O4/Fc9axE+Ar1Nc+5F61ll6p1EUeAuWla3vKdXjBkbZ76kH2rfu4eev
         AR6f/5Edl5r0DyTL8fSxfoWk7A+hhZW4ET1sJ5CZCepsMktZ38B+LD+oUOBu+oP/x2Rk
         G6jm0Ow+Xubk/W0fpLYa7xH+T6zPxD/YImcIRvPPkgoayUZS17rN81jGHSQ5cLCVV9Ch
         wnhTzQ1glsDv5MHIRDXbzaGWYhPwZurm9RmppzU5XLCrkf6uRZO6w8cpO72telbyrTqP
         uSVg==
X-Gm-Message-State: AJIora/We77fBTFxWNqxzcRQD77tngTKWD5fJrQIpfbCLYrUen8RU4Id
        i5f5wXP6WxLh+jvpUx/7CQuvfw==
X-Google-Smtp-Source: AGRyM1upa+E4uQwOAQPa0hiS96AH1BxKX6JSE2JMy8LqwSrgPbQ6S978B729TP38S6Xgee8o/2Aa2A==
X-Received: by 2002:a05:6a00:1948:b0:525:45e3:2eb7 with SMTP id s8-20020a056a00194800b0052545e32eb7mr2510721pfk.77.1659079981773;
        Fri, 29 Jul 2022 00:33:01 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b005289ffefe82sm2074226pfc.130.2022.07.29.00.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:33:01 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Subject: [PATCH net-next 1/4] net/funeth: Unify skb/XDP Tx packet unmapping.
Date:   Fri, 29 Jul 2022 00:32:54 -0700
Message-Id: <20220729073257.2721-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729073257.2721-1-dmichail@fungible.com>
References: <20220729073257.2721-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current XDP unmapping is a subset of its skb analog, dealing with
only one buffer. In preparation for multi-frag XDP rename the skb
function and use it also for XDP. The XDP version is removed.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 33 +++++++------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 54bdeb65a2bd..83fe825ce11d 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -371,7 +371,7 @@ static u16 txq_hw_head(const struct funeth_txq *q)
 /* Unmap the Tx packet starting at the given descriptor index and
  * return the number of Tx descriptors it occupied.
  */
-static unsigned int unmap_skb(const struct funeth_txq *q, unsigned int idx)
+static unsigned int fun_unmap_pkt(const struct funeth_txq *q, unsigned int idx)
 {
 	const struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);
 	unsigned int ngle = req->dataop.ngather;
@@ -419,7 +419,7 @@ static bool fun_txq_reclaim(struct funeth_txq *q, int budget)
 		rmb();
 
 		do {
-			unsigned int pkt_desc = unmap_skb(q, reclaim_idx);
+			unsigned int pkt_desc = fun_unmap_pkt(q, reclaim_idx);
 			struct sk_buff *skb = q->info[reclaim_idx].skb;
 
 			trace_funeth_tx_free(q, reclaim_idx, pkt_desc, head);
@@ -461,20 +461,10 @@ int fun_txq_napi_poll(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-static void fun_xdp_unmap(const struct funeth_txq *q, unsigned int idx)
-{
-	const struct fun_eth_tx_req *req = fun_tx_desc_addr(q, idx);
-	const struct fun_dataop_gl *gle;
-
-	gle = (const struct fun_dataop_gl *)req->dataop.imm;
-	dma_unmap_single(q->dma_dev, be64_to_cpu(gle->sgl_data),
-			 be32_to_cpu(gle->sgl_len), DMA_TO_DEVICE);
-}
-
-/* Reclaim up to @budget completed Tx descriptors from a TX XDP queue. */
+/* Reclaim up to @budget completed Tx packets from a TX XDP queue. */
 static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 {
-	unsigned int npkts = 0, head, reclaim_idx;
+	unsigned int npkts = 0, ndesc = 0, head, reclaim_idx;
 
 	for (head = txq_hw_head(q), reclaim_idx = q->cons_cnt & q->mask;
 	     head != reclaim_idx && npkts < budget; head = txq_hw_head(q)) {
@@ -486,17 +476,19 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 		rmb();
 
 		do {
-			fun_xdp_unmap(q, reclaim_idx);
+			unsigned int pkt_desc = fun_unmap_pkt(q, reclaim_idx);
+
 			xdp_return_frame(q->info[reclaim_idx].xdpf);
 
-			trace_funeth_tx_free(q, reclaim_idx, 1, head);
+			trace_funeth_tx_free(q, reclaim_idx, pkt_desc, head);
 
-			reclaim_idx = (reclaim_idx + 1) & q->mask;
+			reclaim_idx = (reclaim_idx + pkt_desc) & q->mask;
+			ndesc += pkt_desc;
 			npkts++;
 		} while (reclaim_idx != head && npkts < budget);
 	}
 
-	q->cons_cnt += npkts;
+	q->cons_cnt += ndesc;
 	return npkts;
 }
 
@@ -584,7 +576,7 @@ static void fun_txq_purge(struct funeth_txq *q)
 	while (q->cons_cnt != q->prod_cnt) {
 		unsigned int idx = q->cons_cnt & q->mask;
 
-		q->cons_cnt += unmap_skb(q, idx);
+		q->cons_cnt += fun_unmap_pkt(q, idx);
 		dev_kfree_skb_any(q->info[idx].skb);
 	}
 	netdev_tx_reset_queue(q->ndq);
@@ -595,9 +587,8 @@ static void fun_xdpq_purge(struct funeth_txq *q)
 	while (q->cons_cnt != q->prod_cnt) {
 		unsigned int idx = q->cons_cnt & q->mask;
 
-		fun_xdp_unmap(q, idx);
+		q->cons_cnt += fun_unmap_pkt(q, idx);
 		xdp_return_frame(q->info[idx].xdpf);
-		q->cons_cnt++;
 	}
 }
 
-- 
2.25.1

