Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F54C581BDF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiGZV7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZV7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:59:31 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A76A20F45
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:59:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q16so14278469pgq.6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eXL+KEREjQanEzcoKfmWQg9rMeBrmFP9jyxnWoyTPGw=;
        b=ev0DWA8f47NFP2xgc7vIAdZHz5p8r0Kzh9yJoGeeFTBAHZ7w+mOAsZop+RJOuK0avQ
         1jqfG+LDOGidTAXHZh/Cip+9D8rNz6hrbg2G54kXtzZBftq3VrU7U4ePqLFyrb31EhVY
         JFHYffkhdkTucdHSj/Iqm7ZMiLe5ZFV9wgm5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eXL+KEREjQanEzcoKfmWQg9rMeBrmFP9jyxnWoyTPGw=;
        b=L3XNKb2eeZYvAnXItHQ3XMB26Gd1AfHIrtCduBVRZ6vBiEJ07AXjCeEdcNDY2UiFwp
         1YSmKTu7PlQwbBGDZan/6JF3qNtV9+jfemtJvU6ct2WX6hie5A5dtZitAVwIEMZf57y4
         AsEjgIgdy54c7ZTBqxpUIxjO47pGKv269sOJ8ln1YVvIIfTgISux07nmnK7J2/r1dZ+L
         Ll8DN3k1MzcWkxMTlVfNPDo7cO1gaVCIeHLye60m9X8QwIP//+6+Kr6blXAqy3h3Ogra
         O6l/1Igjggr+/5o5JHpKz3rvX6VS+Grb9sbESvgMshTPbmbLGF7UbYnoc4K+3qvq1Iic
         ksJg==
X-Gm-Message-State: AJIora9ePi+xLJxEjWYpy/0j7qpNeV1cFcIFovtJNUDfnWZHa4AiITo9
        660hk35vhSIVzO1QtKtszS4JeA==
X-Google-Smtp-Source: AGRyM1sDc0wFtPiiyQSQr9jhA3IVhQyiIfxHFyKzGQoVo2uuJ1n8NFJc+KnD4c/Q1TQ50MCSp+uXxA==
X-Received: by 2002:a63:1848:0:b0:416:1821:aa0b with SMTP id 8-20020a631848000000b004161821aa0bmr16513445pgy.394.1658872766110;
        Tue, 26 Jul 2022 14:59:26 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id m18-20020a170902bb9200b0016c36b368d1sm11906881pls.150.2022.07.26.14.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:59:25 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, d.michailidis@fungible.com
Subject: [PATCH net] net/funeth: Fix fun_xdp_tx() and XDP packet reclaim
Date:   Tue, 26 Jul 2022 14:59:23 -0700
Message-Id: <20220726215923.7887-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
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

The current implementation of fun_xdp_tx(), used for XPD_TX, is
incorrect in that it takes an address/length pair and later releases it
with page_frag_free(). It is OK for XDP_TX but the same code is used by
ndo_xdp_xmit. In that case it loses the XDP memory type and releases the
packet incorrectly for some of the types. Assorted breakage follows.

Change fun_xdp_tx() to take xdp_frame and rely on xdp_return_frame() in
reclaim.

Fixes: db37bc177dae ("net/funeth: add the data path")
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  5 ++++-
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 20 +++++++++----------
 .../ethernet/fungible/funeth/funeth_txrx.h    |  6 +++---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 0f6a549b9f67..29a6c2ede43a 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -142,6 +142,7 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 			 int ref_ok, struct funeth_txq *xdp_q)
 {
 	struct bpf_prog *xdp_prog;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -163,7 +164,9 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 	case XDP_TX:
 		if (unlikely(!ref_ok))
 			goto pass;
-		if (!fun_xdp_tx(xdp_q, xdp.data, xdp.data_end - xdp.data))
+
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf || !fun_xdp_tx(xdp_q, xdpf))
 			goto xdp_error;
 		FUN_QSTAT_INC(q, xdp_tx);
 		q->xdp_flush |= FUN_XDP_FLUSH_TX;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index ff6e29237253..2f6698b98b03 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -466,7 +466,7 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 
 		do {
 			fun_xdp_unmap(q, reclaim_idx);
-			page_frag_free(q->info[reclaim_idx].vaddr);
+			xdp_return_frame(q->info[reclaim_idx].xdpf);
 
 			trace_funeth_tx_free(q, reclaim_idx, 1, head);
 
@@ -479,11 +479,11 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 	return npkts;
 }
 
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
 	struct fun_eth_tx_req *req;
 	struct fun_dataop_gl *gle;
-	unsigned int idx;
+	unsigned int idx, len;
 	dma_addr_t dma;
 
 	if (fun_txq_avail(q) < FUN_XDP_CLEAN_THRES)
@@ -494,7 +494,8 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 		return false;
 	}
 
-	dma = dma_map_single(q->dma_dev, data, len, DMA_TO_DEVICE);
+	len = xdpf->len;
+	dma = dma_map_single(q->dma_dev, xdpf->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(q->dma_dev, dma))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return false;
@@ -514,7 +515,7 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 	gle = (struct fun_dataop_gl *)req->dataop.imm;
 	fun_dataop_gl_init(gle, 0, 0, len, dma);
 
-	q->info[idx].vaddr = data;
+	q->info[idx].xdpf = xdpf;
 
 	u64_stats_update_begin(&q->syncp);
 	q->stats.tx_bytes += len;
@@ -545,12 +546,9 @@ int fun_xdp_xmit_frames(struct net_device *dev, int n,
 	if (unlikely(q_idx >= fp->num_xdpqs))
 		return -ENXIO;
 
-	for (q = xdpqs[q_idx], i = 0; i < n; i++) {
-		const struct xdp_frame *xdpf = frames[i];
-
-		if (!fun_xdp_tx(q, xdpf->data, xdpf->len))
+	for (q = xdpqs[q_idx], i = 0; i < n; i++)
+		if (!fun_xdp_tx(q, frames[i]))
 			break;
-	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		fun_txq_wr_db(q);
@@ -577,7 +575,7 @@ static void fun_xdpq_purge(struct funeth_txq *q)
 		unsigned int idx = q->cons_cnt & q->mask;
 
 		fun_xdp_unmap(q, idx);
-		page_frag_free(q->info[idx].vaddr);
+		xdp_return_frame(q->info[idx].xdpf);
 		q->cons_cnt++;
 	}
 }
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
index 04c9f91b7489..8708e2895946 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -95,8 +95,8 @@ struct funeth_txq_stats {  /* per Tx queue SW counters */
 
 struct funeth_tx_info {      /* per Tx descriptor state */
 	union {
-		struct sk_buff *skb; /* associated packet */
-		void *vaddr;         /* start address for XDP */
+		struct sk_buff *skb;    /* associated packet (sk_buff path) */
+		struct xdp_frame *xdpf; /* associated XDP frame (XDP path) */
 	};
 };
 
@@ -245,7 +245,7 @@ static inline int fun_irq_node(const struct fun_irq *p)
 int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
 int fun_txq_napi_poll(struct napi_struct *napi, int budget);
 netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len);
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf);
 int fun_xdp_xmit_frames(struct net_device *dev, int n,
 			struct xdp_frame **frames, u32 flags);
 
-- 
2.25.1

