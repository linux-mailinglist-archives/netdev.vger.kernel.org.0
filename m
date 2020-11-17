Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7512B5BD8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKQJfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgKQJfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 04:35:42 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 554EA24671;
        Tue, 17 Nov 2020 09:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605605741;
        bh=weUsGWseMGZ1myobxnEq3l3zaOTcZaVkbYeT9VaDWoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=sJPYFRikPKfppT8Xo6LPvbsyDRpYB3NseS2jyQMfMFOOFt3bFC7pUkvAOHKju9fPD
         UWMGkeiLOxnmmdaGtinFv4CWtgymFvMC+xVWEPTJKoi6fSQeyxzs+pQhVzxPqa/U0T
         VaC8Dgb0+RdE8jm3RAt7MjycFDOUIFawVHhB1Bn8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org
Subject: [PATCH net-next] net: netsec: add xdp tx return bulking support
Date:   Tue, 17 Nov 2020 10:35:28 +0100
Message-Id: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert netsec driver to xdp_return_frame_bulk APIs.
Rely on xdp_return_frame_rx_napi for XDP_TX in order to try to recycle
the page in the "in-irq" page_pool cache.

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch is just compile tested, I have not carried out any run test
---
 drivers/net/ethernet/socionext/netsec.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1503cc9ec6e2..536aa8961dc6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -631,6 +631,7 @@ static void netsec_set_rx_de(struct netsec_priv *priv,
 static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
+	struct xdp_frame_bulk bq;
 	struct netsec_de *entry;
 	int tail = dring->tail;
 	unsigned int bytes;
@@ -639,8 +640,11 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 	spin_lock(&dring->lock);
 
 	bytes = 0;
+	xdp_frame_bulk_init(&bq);
 	entry = dring->vaddr + DESC_SZ * tail;
 
+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
+
 	while (!(entry->attr & (1U << NETSEC_TX_SHIFT_OWN_FIELD)) &&
 	       cnt < DESC_NUM) {
 		struct netsec_desc *desc;
@@ -665,7 +669,10 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 			dev_kfree_skb(desc->skb);
 		} else {
 			bytes += desc->xdpf->len;
-			xdp_return_frame(desc->xdpf);
+			if (desc->buf_type == TYPE_NETSEC_XDP_TX)
+				xdp_return_frame_rx_napi(desc->xdpf);
+			else
+				xdp_return_frame_bulk(desc->xdpf, &bq);
 		}
 next:
 		/* clean up so netsec_uninit_pkt_dring() won't free the skb
@@ -684,6 +691,9 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 		entry = dring->vaddr + DESC_SZ * tail;
 		cnt++;
 	}
+	xdp_flush_frame_bulk(&bq);
+
+	rcu_read_unlock();
 
 	spin_unlock(&dring->lock);
 
-- 
2.26.2

