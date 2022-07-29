Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD18584CAE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiG2HdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiG2HdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52FE7C1B4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v18so3861373plo.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u8OlrK9CxkZkoEa+ZDP5BCimtxxw5V1cQqD54DOitVI=;
        b=S/wq1nqmNQBZhA/uSa7ry5CaNu+PCZidQaYTFXTWzjCA47rwy2ARYblCqiopj+g2ZG
         +GchPXZekrVrUS4F7585pci98xOSa8Iaz0bTjFGPrFk+/8tu1g3psfXuygnHUTsVgc3+
         ciH2PQKPuTJSuhXLlUmXFf3Xln+2WBTfyXqMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u8OlrK9CxkZkoEa+ZDP5BCimtxxw5V1cQqD54DOitVI=;
        b=QM4fCRHITEQ8p1htYw+Pg9kgI6FXal8Gx36x/U/r7YUvXoJX2Los01CylWgwywlQfB
         yHK5GpEU7oyAeXzUXiItZX/5lwo3yb/FxrsnaM0MkSIhwwCwZP7clmJbzjZ+lJAFJPqN
         OUy+j24C9U5MdpzTWn+NUpoV+PYLxEU/SD6j6ADQ0IX+ppp4vFbZNDxVxCtNDMKJ8P5L
         av5IImdMoBmzCHLYU2NbhFt1aqOVEfX/+qfa+sJgixgcbV5b38AA8t8vx345TptVFLPh
         +i7VujsEjdZVzkmPoxCSSDTGQ34tsH/UypbZUnErV+TciUgEoNcb0X+mqUHLeNbZE5e5
         RrdQ==
X-Gm-Message-State: ACgBeo33+LynKWWg+ZBnKHkHNEhVYvhBDaOQ9b9pUAImthgsWxDsOrkV
        Y3+VJD2P9fQQ3OZ6zV2gAeKfSA==
X-Google-Smtp-Source: AA6agR7o44Uyv9IfJiuRqLe1tmovIuT/RSq2umHTfK0aMy913JLWBNSZleK5RGMjYaVzv2plw0DFGQ==
X-Received: by 2002:a17:902:7c88:b0:16c:5301:8a52 with SMTP id y8-20020a1709027c8800b0016c53018a52mr2681023pll.95.1659079984354;
        Fri, 29 Jul 2022 00:33:04 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b005289ffefe82sm2074226pfc.130.2022.07.29.00.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:33:03 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Subject: [PATCH net-next 3/4] net/funeth: Unify skb/XDP packet mapping.
Date:   Fri, 29 Jul 2022 00:32:56 -0700
Message-Id: <20220729073257.2721-4-dmichail@fungible.com>
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

Instead of passing an skb to the mapping function pass an
skb_shared_info plus an additional address/length pair. This makes it
usable for both skbs and XDP. Call it from the XDP path and adjust the
skb path.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/funeth_tx.c  | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index a815432a3d3a..3128db8586ef 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -16,23 +16,24 @@
 #define FUN_XDP_CLEAN_BATCH 16
 
 /* DMA-map a packet and return the (length, DMA_address) pairs for its
- * segments. If a mapping error occurs -ENOMEM is returned.
+ * segments. If a mapping error occurs -ENOMEM is returned. The packet
+ * consists of an skb_shared_info and one additional address/length pair.
  */
-static int map_skb(const struct sk_buff *skb, struct device *dev,
-		   dma_addr_t *addr, unsigned int *len)
+static int fun_map_pkt(struct device *dev, const struct skb_shared_info *si,
+		       void *data, unsigned int data_len,
+		       dma_addr_t *addr, unsigned int *len)
 {
-	const struct skb_shared_info *si;
 	const skb_frag_t *fp, *end;
 
-	*len = skb_headlen(skb);
-	*addr = dma_map_single(dev, skb->data, *len, DMA_TO_DEVICE);
+	*len = data_len;
+	*addr = dma_map_single(dev, data, *len, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, *addr))
 		return -ENOMEM;
 
-	si = skb_shinfo(skb);
-	end = &si->frags[si->nr_frags];
+	if (!si)
+		return 0;
 
-	for (fp = si->frags; fp < end; fp++) {
+	for (fp = si->frags, end = fp + si->nr_frags; fp < end; fp++) {
 		*++len = skb_frag_size(fp);
 		*++addr = skb_frag_dma_map(dev, fp, 0, *len, DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, *addr))
@@ -44,7 +45,7 @@ static int map_skb(const struct sk_buff *skb, struct device *dev,
 	while (fp-- > si->frags)
 		dma_unmap_page(dev, *--addr, skb_frag_size(fp), DMA_TO_DEVICE);
 
-	dma_unmap_single(dev, addr[-1], skb_headlen(skb), DMA_TO_DEVICE);
+	dma_unmap_single(dev, addr[-1], data_len, DMA_TO_DEVICE);
 	return -ENOMEM;
 }
 
@@ -160,7 +161,9 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 	unsigned int ngle;
 	u16 flags;
 
-	if (unlikely(map_skb(skb, q->dma_dev, addrs, lens))) {
+	shinfo = skb_shinfo(skb);
+	if (unlikely(fun_map_pkt(q->dma_dev, shinfo, skb->data,
+				 skb_headlen(skb), addrs, lens))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return 0;
 	}
@@ -173,7 +176,6 @@ static unsigned int write_pkt_desc(struct sk_buff *skb, struct funeth_txq *q,
 	req->repr_idn = 0;
 	req->encap_proto = 0;
 
-	shinfo = skb_shinfo(skb);
 	if (likely(shinfo->gso_size)) {
 		if (skb->encapsulation) {
 			u16 ol4_ofst;
@@ -512,6 +514,7 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 
 bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
+	const struct skb_shared_info *si = NULL;
 	struct fun_eth_tx_req *req;
 	unsigned int idx, len;
 	dma_addr_t dma;
@@ -524,9 +527,8 @@ bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 		return false;
 	}
 
-	len = xdpf->len;
-	dma = dma_map_single(q->dma_dev, xdpf->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(q->dma_dev, dma))) {
+	if (unlikely(fun_map_pkt(q->dma_dev, si, xdpf->data, xdpf->len, &dma,
+				 &len))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return false;
 	}
-- 
2.25.1

