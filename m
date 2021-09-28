Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDBB41B955
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242952AbhI1Vfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242943AbhI1Vfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A1F6135F;
        Tue, 28 Sep 2021 21:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632864843;
        bh=2hOPqcyqypMpKLqdAQNJCW9CnAKsvTzqaAiKGYi0Y+Q=;
        h=Date:From:To:Cc:Subject:From;
        b=GH0E0UAGigSBp79hPgAZBz1cOI8i1bRzNKg8vSXYptJ1gc05+KL9u+CIokrcwwJxo
         CAmGmAgKMB1fpwC5esV78h1pZAKX8KKFKJM1+iXxHpxhINm+lYEjz0n3JbZrwTGq0M
         Ed1zzTr8OuyiwecoOLx80FIi1P8JhPBVTVIeNDOI2Y0r29PDZVkkgZYrx8sWojasuU
         +wl84HpWV0rvBMHb+WlGHnaolqjIDvs9fJozXC0OND2IPsSjueIkvIlWzLZZBW3xac
         7cJlyyyoXPMw/Gfen2xB9JE9/KHnYnPUmzvKiSS+POdndIznLZjOoSYqTad0rnGaTX
         ffRry30oczBQQ==
Date:   Tue, 28 Sep 2021 16:38:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] gve: Use kvcalloc() instead of kvzalloc()
Message-ID: <20210928213805.GA273413@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 099a2bc5ae67..cd9df68cc01e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -268,7 +268,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 	int i, j;
 	int err;
 
-	priv->msix_vectors = kvzalloc(num_vecs_requested *
+	priv->msix_vectors = kvcalloc(num_vecs_requested,
 				      sizeof(*priv->msix_vectors), GFP_KERNEL);
 	if (!priv->msix_vectors)
 		return -ENOMEM;
@@ -628,7 +628,7 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	int err;
 
 	/* Setup tx rings */
-	priv->tx = kvzalloc(priv->tx_cfg.num_queues * sizeof(*priv->tx),
+	priv->tx = kvcalloc(priv->tx_cfg.num_queues, sizeof(*priv->tx),
 			    GFP_KERNEL);
 	if (!priv->tx)
 		return -ENOMEM;
@@ -641,7 +641,7 @@ static int gve_alloc_rings(struct gve_priv *priv)
 		goto free_tx;
 
 	/* Setup rx rings */
-	priv->rx = kvzalloc(priv->rx_cfg.num_queues * sizeof(*priv->rx),
+	priv->rx = kvcalloc(priv->rx_cfg.num_queues, sizeof(*priv->rx),
 			    GFP_KERNEL);
 	if (!priv->rx) {
 		err = -ENOMEM;
@@ -764,12 +764,11 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 
 	qpl->id = id;
 	qpl->num_entries = 0;
-	qpl->pages = kvzalloc(pages * sizeof(*qpl->pages), GFP_KERNEL);
+	qpl->pages = kvcalloc(pages, sizeof(*qpl->pages), GFP_KERNEL);
 	/* caller handles clean up */
 	if (!qpl->pages)
 		return -ENOMEM;
-	qpl->page_buses = kvzalloc(pages * sizeof(*qpl->page_buses),
-				   GFP_KERNEL);
+	qpl->page_buses = kvcalloc(pages, sizeof(*qpl->page_buses), GFP_KERNEL);
 	/* caller handles clean up */
 	if (!qpl->page_buses)
 		return -ENOMEM;
@@ -828,7 +827,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	if (priv->queue_format == GVE_GQI_RDA_FORMAT)
 		return 0;
 
-	priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
+	priv->qpls = kvcalloc(num_qpls, sizeof(*priv->qpls), GFP_KERNEL);
 	if (!priv->qpls)
 		return -ENOMEM;
 
@@ -847,7 +846,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 
 	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
 				     sizeof(unsigned long) * BITS_PER_BYTE;
-	priv->qpl_cfg.qpl_id_map = kvzalloc(BITS_TO_LONGS(num_qpls) *
+	priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(num_qpls),
 					    sizeof(unsigned long), GFP_KERNEL);
 	if (!priv->qpl_cfg.qpl_id_map) {
 		err = -ENOMEM;
-- 
2.27.0

