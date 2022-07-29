Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027D8584CAA
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiG2HdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiG2HdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:04 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2A97B37F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:03 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f7so4180972pjp.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VdV2WBdLv2Rqn9KEbE5gARCWHWcca5+mdWom9/fO9HE=;
        b=UBRR+tix0d3RwgpOfTRwrJNlMpgxcpRuTMP2aP+69Uj/vymtAQuuy2ShuHPEdHtUgx
         Zf7+KoQJ0ER22T9kSG15WVzn4KFTbuPrRoeQGDldKNj+03opM+LKBUaYMSTVUdXOlhhe
         m/l+vmKXreb2QKhi905kaIBfPPi00R42l6y+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VdV2WBdLv2Rqn9KEbE5gARCWHWcca5+mdWom9/fO9HE=;
        b=RFv1T++PR57733PLHIUtl7Fye+MFDeDadyLXPiN7yiILqkwRjyS0gKOiZhwl0ZEq4L
         lRsKkjAy3g99AOh4f3pKZFSY7wplsu8t31r9DecbbVTwkGpiTr8pOGe0aBMbc99pBrBc
         fZrT4zOmohIBeYX+QHJDOzt5FSVbxgON1VICHivoYVnJlS9ABV6YK4x7kvhgHGLHKCLr
         gRfO45t5U6+UgxfvAdA0o317HQj6Fq3Bai8FDBiR5FzkKSCOKLKHV0SIrlo9/uLbyjB9
         K0pE1pKREyj8BSe+CJmUkrCGhMm4Y74/IWaGqlmJSZFq6BgHiqoqXFtic7uIigGSjHSW
         2ABQ==
X-Gm-Message-State: ACgBeo1FkRqN3zIV5yd6weZprCnBPZff7ie8pCHPfNIiR6i11McYI4oZ
        ag/q0ZfAcLjTXu5XIqw5BojgDA==
X-Google-Smtp-Source: AA6agR4B61PmVIf6KgntYRNJc2WAk2YbkCN+REBshIZC5W2Io15ltGX/6vPpVVe12+nd6CJ62GP9oQ==
X-Received: by 2002:a17:90b:2791:b0:1f3:c48:19d5 with SMTP id pw17-20020a17090b279100b001f30c4819d5mr2627475pjb.219.1659079983070;
        Fri, 29 Jul 2022 00:33:03 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b005289ffefe82sm2074226pfc.130.2022.07.29.00.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:33:02 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Subject: [PATCH net-next 2/4] net/funeth: Unify skb/XDP gather list writing.
Date:   Fri, 29 Jul 2022 00:32:55 -0700
Message-Id: <20220729073257.2721-3-dmichail@fungible.com>
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

Extract the Tx gather list writing code that skbs use into a utility
function and use it also for XDP.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 46 +++++++++++++------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 83fe825ce11d..a815432a3d3a 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -71,6 +71,33 @@ static unsigned int tx_req_ndesc(const struct fun_eth_tx_req *req)
 	return DIV_ROUND_UP(req->len8, FUNETH_SQE_SIZE / 8);
 }
 
+/* Write a gather list to the Tx descriptor at @req from @ngle address/length
+ * pairs.
+ */
+static struct fun_dataop_gl *fun_write_gl(const struct funeth_txq *q,
+					  struct fun_eth_tx_req *req,
+					  const dma_addr_t *addrs,
+					  const unsigned int *lens,
+					  unsigned int ngle)
+{
+	struct fun_dataop_gl *gle;
+	unsigned int i;
+
+	req->len8 = (sizeof(*req) + ngle * sizeof(*gle)) / 8;
+
+	for (i = 0, gle = (struct fun_dataop_gl *)req->dataop.imm;
+	     i < ngle && txq_to_end(q, gle); i++, gle++)
+		fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
+
+	if (txq_to_end(q, gle) == 0) {
+		gle = (struct fun_dataop_gl *)q->desc;
+		for ( ; i < ngle; i++, gle++)
+			fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
+	}
+
+	return gle;
+}
+
 static __be16 tcp_hdr_doff_flags(const struct tcphdr *th)
 {
 	return *(__be16 *)&tcp_flag_word(th);
@@ -129,8 +156,8 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 	struct fun_eth_tx_req *req;
 	struct fun_dataop_gl *gle;
 	const struct tcphdr *th;
-	unsigned int ngle, i;
 	unsigned int l4_hlen;
+	unsigned int ngle;
 	u16 flags;
 
 	if (unlikely(map_skb(skb, q->dma_dev, addrs, lens))) {
@@ -243,18 +270,9 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 	}
 
 	ngle = shinfo->nr_frags + 1;
-	req->len8 = (sizeof(*req) + ngle * sizeof(*gle)) / 8;
 	req->dataop = FUN_DATAOP_HDR_INIT(ngle, 0, ngle, 0, skb->len);
 
-	for (i = 0, gle = (struct fun_dataop_gl *)req->dataop.imm;
-	     i < ngle && txq_to_end(q, gle); i++, gle++)
-		fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
-
-	if (txq_to_end(q, gle) == 0) {
-		gle = (struct fun_dataop_gl *)q->desc;
-		for ( ; i < ngle; i++, gle++)
-			fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
-	}
+	gle = fun_write_gl(q, req, addrs, lens, ngle);
 
 	if (IS_ENABLED(CONFIG_TLS_DEVICE) && unlikely(tls_len)) {
 		struct fun_eth_tls *tls = (struct fun_eth_tls *)gle;
@@ -495,7 +513,6 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
 	struct fun_eth_tx_req *req;
-	struct fun_dataop_gl *gle;
 	unsigned int idx, len;
 	dma_addr_t dma;
 
@@ -517,7 +534,7 @@ bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 	idx = q->prod_cnt & q->mask;
 	req = fun_tx_desc_addr(q, idx);
 	req->op = FUN_ETH_OP_TX;
-	req->len8 = (sizeof(*req) + sizeof(*gle)) / 8;
+	req->len8 = 0;
 	req->flags = 0;
 	req->suboff8 = offsetof(struct fun_eth_tx_req, dataop);
 	req->repr_idn = 0;
@@ -525,8 +542,7 @@ bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 	fun_eth_offload_init(&req->offload, 0, 0, 0, 0, 0, 0, 0, 0);
 	req->dataop = FUN_DATAOP_HDR_INIT(1, 0, 1, 0, len);
 
-	gle = (struct fun_dataop_gl *)req->dataop.imm;
-	fun_dataop_gl_init(gle, 0, 0, len, dma);
+	fun_write_gl(q, req, &dma, &len, 1);
 
 	q->info[idx].xdpf = xdpf;
 
-- 
2.25.1

