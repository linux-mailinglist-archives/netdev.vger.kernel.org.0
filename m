Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCB2584CAB
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbiG2HdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbiG2HdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:06 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB518049C
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o14-20020a17090a4b4e00b001f2f2b61be5so4462731pjl.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aoRspL2CzLa1KmMEczzCf80IIXkBL7hQgE8psDki5Wo=;
        b=PkG9q1UxgWVzsp6h2MUVEhrFgShuMeEM6V7ZT2R5B6LW/GFVtvt+TpvKB3Nx+2iCPi
         7F299UKQWWpWVjsqjJoS7FVZTX3mTW4qA7TFKbWVS9AyTDTcJwEcv7xxwc22s5IqiAVL
         1zyZtVqaCWACjmeJQfmysX/LJSdjQYcRvtmuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aoRspL2CzLa1KmMEczzCf80IIXkBL7hQgE8psDki5Wo=;
        b=MPYOLlqeo8ZK5Z3aZ0AKKOKc0uzyfMbZ9Nl+LZGTpyFwJ2OxRLMJLprFAz8yH0E3/R
         q2Jf9LhvWpsp6mQgZs1SH4FfMuD0PMsAAezPlm4H/cC7WJ6fgnRvO9YrZnXSItQUY4rt
         vkyJlEMKaKF/Dm3p1e2vJeFIPLTx60R9pcdhRv2PdzyhmNESRPy1Xxdd0hI0irHZjJKB
         a+G2W4oXuaeqSuz6/3VLeXuba/GG5lrgKLTJD5CegCYEDvp1Ry9d7vJ/N3to0UfyjKl+
         hs11yqgpiyJ51CII9aE9ZHrKSapogykV613J1/zxqkcZJ5TjpEzjfQrmPMCCVvkGghmK
         yayQ==
X-Gm-Message-State: ACgBeo2t6twNOPSvhuL/5YLCTYoJDCeF1LdMVx94ENDaZBYCpmXlMZ02
        YFMVVCXoDgIKHzPE4VIM3LA35Q==
X-Google-Smtp-Source: AA6agR6Q4dljgMgZX9kzG88o1qNXDlAv2XNPMUxS6k7+fIlvZ0E8MA8AuPnJPDDe2o33qSU6UqaSZA==
X-Received: by 2002:a17:902:9b97:b0:16d:5fba:57d7 with SMTP id y23-20020a1709029b9700b0016d5fba57d7mr2549122plp.109.1659079985598;
        Fri, 29 Jul 2022 00:33:05 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b005289ffefe82sm2074226pfc.130.2022.07.29.00.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:33:05 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Subject: [PATCH net-next 4/4] net/funeth: Tx handling of XDP with fragments.
Date:   Fri, 29 Jul 2022 00:32:57 -0700
Message-Id: <20220729073257.2721-5-dmichail@fungible.com>
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

By now all the functions fun_xdp_tx() calls are shared with the skb path
and thus are fragment-capable. Update fun_xdp_tx(), that up to now has
been passing just one buffer, to check for fragments and call
accordingly.  This makes XDP_TX and ndo_xdp_xmit fragment-capable.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 30 ++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 3128db8586ef..706d81e39a54 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -514,21 +514,31 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 
 bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
+	unsigned int idx, nfrags = 1, ndesc = 1, tot_len = xdpf->len;
 	const struct skb_shared_info *si = NULL;
+	unsigned int lens[MAX_SKB_FRAGS + 1];
+	dma_addr_t dma[MAX_SKB_FRAGS + 1];
 	struct fun_eth_tx_req *req;
-	unsigned int idx, len;
-	dma_addr_t dma;
 
 	if (fun_txq_avail(q) < FUN_XDP_CLEAN_THRES)
 		fun_xdpq_clean(q, FUN_XDP_CLEAN_BATCH);
 
-	if (!unlikely(fun_txq_avail(q))) {
+	if (unlikely(xdp_frame_has_frags(xdpf))) {
+		si = xdp_get_shared_info_from_frame(xdpf);
+		tot_len = xdp_get_frame_len(xdpf);
+		nfrags += si->nr_frags;
+		ndesc = DIV_ROUND_UP((sizeof(*req) + nfrags *
+				      sizeof(struct fun_dataop_gl)),
+				     FUNETH_SQE_SIZE);
+	}
+
+	if (unlikely(fun_txq_avail(q) < ndesc)) {
 		FUN_QSTAT_INC(q, tx_xdp_full);
 		return false;
 	}
 
-	if (unlikely(fun_map_pkt(q->dma_dev, si, xdpf->data, xdpf->len, &dma,
-				 &len))) {
+	if (unlikely(fun_map_pkt(q->dma_dev, si, xdpf->data, xdpf->len, dma,
+				 lens))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return false;
 	}
@@ -542,19 +552,19 @@ bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 	req->repr_idn = 0;
 	req->encap_proto = 0;
 	fun_eth_offload_init(&req->offload, 0, 0, 0, 0, 0, 0, 0, 0);
-	req->dataop = FUN_DATAOP_HDR_INIT(1, 0, 1, 0, len);
+	req->dataop = FUN_DATAOP_HDR_INIT(nfrags, 0, nfrags, 0, tot_len);
 
-	fun_write_gl(q, req, &dma, &len, 1);
+	fun_write_gl(q, req, dma, lens, nfrags);
 
 	q->info[idx].xdpf = xdpf;
 
 	u64_stats_update_begin(&q->syncp);
-	q->stats.tx_bytes += len;
+	q->stats.tx_bytes += tot_len;
 	q->stats.tx_pkts++;
 	u64_stats_update_end(&q->syncp);
 
-	trace_funeth_tx(q, len, idx, 1);
-	q->prod_cnt++;
+	trace_funeth_tx(q, tot_len, idx, nfrags);
+	q->prod_cnt += ndesc;
 
 	return true;
 }
-- 
2.25.1

