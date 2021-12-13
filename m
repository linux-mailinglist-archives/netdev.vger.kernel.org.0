Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D487472B3E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 12:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhLMLYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 06:24:05 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:56054 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbhLMLYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 06:24:05 -0500
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2021 06:24:04 EST
Received: from localhost (unknown [192.168.167.70])
        by lucky1.263xmail.com (Postfix) with ESMTP id 7AF02FD888;
        Mon, 13 Dec 2021 19:15:17 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P24780T139929868814080S1639394115775110_;
        Mon, 13 Dec 2021 19:15:16 +0800 (CST)
X-IP-DOMAINF: 1
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: joabreu@synopsys.com
X-RCPT-COUNT: 5
X-LOCAL-RCPT-COUNT: 1
X-MUTI-DOMAIN-COUNT: 0
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-UNIQUE-TAG: <25af46566183a95dcf8dd530c3cecb0c>
X-System-Flag: 0
From:   David Wu <david.wu@rock-chips.com>
To:     joabreu@synopsys.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>
Subject: [PATCH] net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability
Date:   Mon, 13 Dec 2021 19:15:15 +0800
Message-Id: <20211213111515.658351-1-david.wu@rock-chips.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use page_pool_alloc_pages instead of page_pool_dev_alloc_pages, which
can give the gfp parameter, in the case of not supporting 64-bit width,
using 32-bit address memory can reduce a copy from swiotlb.

Signed-off-by: David Wu <david.wu@rock-chips.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index da8306f60730..8ded4be08b00 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1461,16 +1461,20 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 {
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
+
+	if (priv->dma_cap.addr64 <= 32)
+		gfp |= GFP_DMA32;
 
 	if (!buf->page) {
-		buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+		buf->page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 		if (!buf->page)
 			return -ENOMEM;
 		buf->page_offset = stmmac_rx_offset(priv);
 	}
 
 	if (priv->sph && !buf->sec_page) {
-		buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+		buf->sec_page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 		if (!buf->sec_page)
 			return -ENOMEM;
 
@@ -4482,6 +4486,10 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int entry = rx_q->dirty_rx;
+	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
+
+	if (priv->dma_cap.addr64 <= 32)
+		gfp |= GFP_DMA32;
 
 	while (dirty-- > 0) {
 		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[entry];
@@ -4494,13 +4502,13 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 			p = rx_q->dma_rx + entry;
 
 		if (!buf->page) {
-			buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+			buf->page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 			if (!buf->page)
 				break;
 		}
 
 		if (priv->sph && !buf->sec_page) {
-			buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+			buf->sec_page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 			if (!buf->sec_page)
 				break;
 
-- 
2.25.1



