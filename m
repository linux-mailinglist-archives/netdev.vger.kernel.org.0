Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4E2194B4E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgCZWKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgCZWKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 18:10:32 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990E220719;
        Thu, 26 Mar 2020 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585260631;
        bh=p6pplGsnOOMYfkvMk/cT7Swp4gNnc+bkd4sevMPGhjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa8EU7cJh9qJBmb0gfEJsdtV7fO+TC1ecFrHsuIbzBxMuoyuu3crJtAQIiFwhBh55
         nsUYsWhPOfEsmECJRSgyN+lHFyF/dpvtQxOOilqDq0npYENUmnyWgfBT5odWM+bpsj
         9tPQ+3iiwAMYHc8q6iXNj+hXkFuoVzUSEicMj2Z4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH v2 net-next 1/2] veth: rely on veth_rq in veth_xdp_flush_bq signature
Date:   Thu, 26 Mar 2020 23:10:19 +0100
Message-Id: <ba0eac5b0d41096f2946875151752265d13243ca.1585260407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1585260407.git.lorenzo@kernel.org>
References: <cover.1585260407.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Substitute net_device point with veth_rq one in veth_xdp_flush_bq,
veth_xdp_flush and veth_xdp_tx signature. This is a preliminary patch
to account xdp_xmit counter on 'receiving' veth_rq

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b6505a6c7102..2041152da716 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -468,46 +468,46 @@ static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
 	return veth_xdp_xmit(dev, n, frames, flags, true);
 }
 
-static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp_tx_bq *bq)
+static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 {
 	int sent, i, err = 0;
 
-	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0, false);
+	sent = veth_xdp_xmit(rq->dev, bq->count, bq->q, 0, false);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
 		for (i = 0; i < bq->count; i++)
 			xdp_return_frame(bq->q[i]);
 	}
-	trace_xdp_bulk_tx(dev, sent, bq->count - sent, err);
+	trace_xdp_bulk_tx(rq->dev, sent, bq->count - sent, err);
 
 	bq->count = 0;
 }
 
-static void veth_xdp_flush(struct net_device *dev, struct veth_xdp_tx_bq *bq)
+static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 {
-	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
+	struct veth_priv *rcv_priv, *priv = netdev_priv(rq->dev);
 	struct net_device *rcv;
-	struct veth_rq *rq;
+	struct veth_rq *rcv_rq;
 
 	rcu_read_lock();
-	veth_xdp_flush_bq(dev, bq);
+	veth_xdp_flush_bq(rq, bq);
 	rcv = rcu_dereference(priv->peer);
 	if (unlikely(!rcv))
 		goto out;
 
 	rcv_priv = netdev_priv(rcv);
-	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
+	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
 		goto out;
 
-	__veth_xdp_flush(rq);
+	__veth_xdp_flush(rcv_rq);
 out:
 	rcu_read_unlock();
 }
 
-static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
+static int veth_xdp_tx(struct veth_rq *rq, struct xdp_buff *xdp,
 		       struct veth_xdp_tx_bq *bq)
 {
 	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
@@ -516,7 +516,7 @@ static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
 		return -EOVERFLOW;
 
 	if (unlikely(bq->count == VETH_XDP_TX_BULK_SIZE))
-		veth_xdp_flush_bq(dev, bq);
+		veth_xdp_flush_bq(rq, bq);
 
 	bq->q[bq->count++] = frame;
 
@@ -559,7 +559,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			orig_frame = *frame;
 			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
-			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
+			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
 				stats->rx_drops++;
@@ -692,7 +692,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		get_page(virt_to_page(xdp.data));
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
-		if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
+		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
 			stats->rx_drops++;
 			goto err_xdp;
@@ -817,7 +817,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (stats.xdp_tx > 0)
-		veth_xdp_flush(rq->dev, &bq);
+		veth_xdp_flush(rq, &bq);
 	if (stats.xdp_redirect > 0)
 		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
-- 
2.25.1

