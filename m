Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C9DC2EEB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfJAIeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfJAIeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:34:09 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C7BC215EA;
        Tue,  1 Oct 2019 08:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569918848;
        bh=67Feyd3R+UjbbJI3+f4QE0aXFLDXlibmxH2PWCyFoHE=;
        h=From:To:Cc:Subject:Date:From;
        b=F3S48x1fSQo0IuxmPqVjkt4UZ1vtlI4lIW2VnZy6yxjC9IgRkyErYQeXw26UJs4g6
         Nr/94jCfaIBGZLlxAhx84j2vF1LLDW0bbJYsxDv2Fn9pZva5Kj4QWjsKLL+X6kYpgF
         anjrBqphLxFl5+gLx5x2VFQf810JoOfBK0ycxQ2k=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net] net: socionext: netsec: always grab descriptor lock
Date:   Tue,  1 Oct 2019 10:33:51 +0200
Message-Id: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always acquire tx descriptor spinlock even if a xdp program is not loaded
on the netsec device since ndo_xdp_xmit can run concurrently with
netsec_netdev_start_xmit and netsec_clean_tx_dring. This can happen
loading a xdp program on a different device (e.g virtio-net) and
xdp_do_redirect_map/xdp_do_redirect_slow can redirect to netsec even if
we do not have a xdp program on it.

Fixes: ba2b232108d3 ("net: netsec: add XDP support")
Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 30 ++++++-------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 55db7fbd43cc..f9e6744d8fd6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -282,7 +282,6 @@ struct netsec_desc_ring {
 	void *vaddr;
 	u16 head, tail;
 	u16 xdp_xmit; /* netsec_xdp_xmit packets */
-	bool is_xdp;
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
 	spinlock_t lock; /* XDP tx queue locking */
@@ -634,8 +633,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 	unsigned int bytes;
 	int cnt = 0;
 
-	if (dring->is_xdp)
-		spin_lock(&dring->lock);
+	spin_lock(&dring->lock);
 
 	bytes = 0;
 	entry = dring->vaddr + DESC_SZ * tail;
@@ -682,8 +680,8 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 		entry = dring->vaddr + DESC_SZ * tail;
 		cnt++;
 	}
-	if (dring->is_xdp)
-		spin_unlock(&dring->lock);
+
+	spin_unlock(&dring->lock);
 
 	if (!cnt)
 		return false;
@@ -799,9 +797,6 @@ static void netsec_set_tx_de(struct netsec_priv *priv,
 	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
 	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
 	de->attr = attr;
-	/* under spin_lock if using XDP */
-	if (!dring->is_xdp)
-		dma_wmb();
 
 	dring->desc[idx] = *desc;
 	if (desc->buf_type == TYPE_NETSEC_SKB)
@@ -1123,12 +1118,10 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	u16 tso_seg_len = 0;
 	int filled;
 
-	if (dring->is_xdp)
-		spin_lock_bh(&dring->lock);
+	spin_lock_bh(&dring->lock);
 	filled = netsec_desc_used(dring);
 	if (netsec_check_stop_tx(priv, filled)) {
-		if (dring->is_xdp)
-			spin_unlock_bh(&dring->lock);
+		spin_unlock_bh(&dring->lock);
 		net_warn_ratelimited("%s %s Tx queue full\n",
 				     dev_name(priv->dev), ndev->name);
 		return NETDEV_TX_BUSY;
@@ -1161,8 +1154,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	tx_desc.dma_addr = dma_map_single(priv->dev, skb->data,
 					  skb_headlen(skb), DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->dev, tx_desc.dma_addr)) {
-		if (dring->is_xdp)
-			spin_unlock_bh(&dring->lock);
+		spin_unlock_bh(&dring->lock);
 		netif_err(priv, drv, priv->ndev,
 			  "%s: DMA mapping failed\n", __func__);
 		ndev->stats.tx_dropped++;
@@ -1177,8 +1169,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 	netdev_sent_queue(priv->ndev, skb->len);
 
 	netsec_set_tx_de(priv, dring, &tx_ctrl, &tx_desc, skb);
-	if (dring->is_xdp)
-		spin_unlock_bh(&dring->lock);
+	spin_unlock_bh(&dring->lock);
 	netsec_write(priv, NETSEC_REG_NRM_TX_PKTCNT, 1); /* submit another tx */
 
 	return NETDEV_TX_OK;
@@ -1262,7 +1253,6 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 static void netsec_setup_tx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
-	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
 	int i;
 
 	for (i = 0; i < DESC_NUM; i++) {
@@ -1275,12 +1265,6 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
 		 */
 		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
 	}
-
-	if (xdp_prog)
-		dring->is_xdp = true;
-	else
-		dring->is_xdp = false;
-
 }
 
 static int netsec_setup_rx_dring(struct netsec_priv *priv)
-- 
2.21.0

