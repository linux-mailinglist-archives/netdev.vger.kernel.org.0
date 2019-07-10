Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02464331
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfGJIBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:01:20 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:58975 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJIBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:01:20 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MEmEf-1hjCXe129D-00GH64; Wed, 10 Jul 2019 10:01:09 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] davinci_cpdma: don't cast dma_addr_t to pointer
Date:   Wed, 10 Jul 2019 10:00:33 +0200
Message-Id: <20190710080106.24237-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:bVw50YUbhjFNSqvDn/znOtxBYy7U05crbm2ZJFpSW93N8gDGrY2
 yKhDAkxa6B5UngkG8J++bupdMXKAjnX9PHJwkm+zkAu2qTUmEV5nOY49KM3Nes9yxylLLEV
 5iQyfVxZhDiGLMksi129JmvYYelDIcijh561gabfmUVDKi43U8rQuQiXXQ6Xd3/navYEhM8
 dKhSyeFnqVaIh+8H13JWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QjAE6gGIOb0=:GN1HHSywOl6HwnAlqtqh7h
 i3XIBXMRr+FpyoWZREjuI7rk21TyJYdAJgaNETV8BG+OOQxldQsl/RD8LTtt2rAEvILKiSAlv
 d5lzmt7BV5+71CASfpdeV+U7mexqSZBAXxIbkqFdkIrGEouKifBUItxtT9zQ5i8BQ9JekTxCv
 BYgTqnoAhk+f1DuWO/7X3k+QJ/Zpvm8MafBRh3k3XxQwtIAg4hLckpViIzUqKDjzk22EYF0gY
 j04ObnkBw1PPoIOA311jVL9HuOc9w5e7JZHOH5AdrQw/vZuI2Pnv1S0rLHaxqgwMo13nc8ZXK
 qeDHbKPBuj643K+D88+77Bq0cCfPSHgyIOZGyBEs+muhhaysFM+LqqYC1lC0hJzF9/d6ZZwUC
 5sX53TJkeeG9bIEVWbwerBjvBWsBewrxn3SYelRkQ3N/WWON2w6Ajf6jMF9SXlySmU50ngR5m
 D7CInxsl+UlCvc13XJ393biG53/lXr5L5joH9pNLkBKn3TS76sYdWnQclni8mlwNSADvBCUfY
 zf6FVyUgjln/0T+LWqsLI9BFRD+yWLx5h1b+91SxbJJ9sgaUx++D3R8JJBresLxnH6CQ6RgYe
 Izu/GI+levnfXGCwWB0561pyXasWyPxRU0ecQi3sCpTGTwXh37vrMISoPzt37ad3MG+hEX80m
 HxISHIrMXPYqf3KQtwCD85ahn5TpVz7LxqJMcDqoLC329rfXAenE6N7E+Izgv+rUaxFYcNZGV
 9iKk6fyd2wuBaBEkeaHEBYHVkr1wKjnOTBMspA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_addr_t may be 64-bit wide on 32-bit architectures, so it is not
valid to cast between it and a pointer:

drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_submit_si':
drivers/net/ethernet/ti/davinci_cpdma.c:1047:12: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_idle_submit_mapped':
drivers/net/ethernet/ti/davinci_cpdma.c:1114:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_submit_mapped':
drivers/net/ethernet/ti/davinci_cpdma.c:1164:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]

Solve this by using two separate members in 'struct submit_info'.
Since this avoids the use of the 'flag' member, the structure does
not even grow in typical configurations.

Fixes: 6670acacd59e ("net: ethernet: ti: davinci_cpdma: add dma mapped submit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 26 ++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 0ca2a1a254de..a65edd2770e6 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -138,8 +138,8 @@ struct submit_info {
 	struct cpdma_chan *chan;
 	int directed;
 	void *token;
-	void *data;
-	int flags;
+	void *data_virt;
+	dma_addr_t data_dma;
 	int len;
 };
 
@@ -1043,12 +1043,12 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
 	cpdma_desc_to_port(chan, mode, si->directed);
 
-	if (si->flags & CPDMA_DMA_EXT_MAP) {
-		buffer = (dma_addr_t)si->data;
+	if (si->data_dma) {
+		buffer = si->data_dma;
 		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
 		swlen |= CPDMA_DMA_EXT_MAP;
 	} else {
-		buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
+		buffer = dma_map_single(ctlr->dev, si->data_virt, len, chan->dir);
 		ret = dma_mapping_error(ctlr->dev, buffer);
 		if (ret) {
 			cpdma_desc_free(ctlr->pool, desc, 1);
@@ -1086,10 +1086,10 @@ int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
 
 	si.chan = chan;
 	si.token = token;
-	si.data = data;
+	si.data_virt = data;
+	si.data_dma = 0;
 	si.len = len;
 	si.directed = directed;
-	si.flags = 0;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state == CPDMA_STATE_TEARDOWN) {
@@ -1111,10 +1111,10 @@ int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
 
 	si.chan = chan;
 	si.token = token;
-	si.data = (void *)data;
+	si.data_virt = NULL;
+	si.data_dma = data;
 	si.len = len;
 	si.directed = directed;
-	si.flags = CPDMA_DMA_EXT_MAP;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state == CPDMA_STATE_TEARDOWN) {
@@ -1136,10 +1136,10 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 
 	si.chan = chan;
 	si.token = token;
-	si.data = data;
+	si.data_virt = data;
+	si.data_dma = 0;
 	si.len = len;
 	si.directed = directed;
-	si.flags = 0;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state != CPDMA_STATE_ACTIVE) {
@@ -1161,10 +1161,10 @@ int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
 
 	si.chan = chan;
 	si.token = token;
-	si.data = (void *)data;
+	si.data_virt = NULL;
+	si.data_dma = data;
 	si.len = len;
 	si.directed = directed;
-	si.flags = CPDMA_DMA_EXT_MAP;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state != CPDMA_STATE_ACTIVE) {
-- 
2.20.0

