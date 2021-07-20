Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724B53CF65B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGTIMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233450AbhGTIFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626770704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3nihVrCeguHyBNQbGuE6hxa4OWJzGC8KcsyXzfT9A8=;
        b=FMPhvtcTvuhhYVrD04w1Lr5TZI5ysdkLPpbAmrRTGNUwM8YybTYu3ELGw8o3rXSKAcA/Tx
        O5WgI58JmlfArSqlB4tVgb2nftec14VLqvoqXe52C2iK0jBQS//3s56Z/RViMNv33QrfC5
        P2VEInGY1UMVeBpYU1cZughVSaepJwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-JGRQU18UOeS68gLwoqQG-Q-1; Tue, 20 Jul 2021 04:45:03 -0400
X-MC-Unique: JGRQU18UOeS68gLwoqQG-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EBF5802928;
        Tue, 20 Jul 2021 08:45:02 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECFCC60BD8;
        Tue, 20 Jul 2021 08:45:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, toke@redhat.com
Subject: [PATCH net-next 2/5] veth: factor out initialization helper
Date:   Tue, 20 Jul 2021 10:41:49 +0200
Message-Id: <7a8829c1dee8ddbe3fc40c43067ed1bafbe8d7e7.1626768072.git.pabeni@redhat.com>
In-Reply-To: <cover.1626768072.git.pabeni@redhat.com>
References: <cover.1626768072.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract in simpler helpers the code to enable and disable a
range of xdp/napi instance, with the common property that
"disable" helpers can't fail.

Will be used by the next patch. No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 141 +++++++++++++++++++++++++++++----------------
 1 file changed, 92 insertions(+), 49 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 4b3e2617fdb5..9eb8c1034e98 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -926,12 +926,12 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	return done;
 }
 
-static int __veth_napi_enable(struct net_device *dev)
+static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
 		err = ptr_ring_init(&rq->xdp_ring, VETH_RING_SIZE, GFP_KERNEL);
@@ -939,7 +939,7 @@ static int __veth_napi_enable(struct net_device *dev)
 			goto err_xdp_ring;
 	}
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
 		napi_enable(&rq->xdp_napi);
@@ -947,19 +947,25 @@ static int __veth_napi_enable(struct net_device *dev)
 	}
 
 	return 0;
+
 err_xdp_ring:
-	for (i--; i >= 0; i--)
+	for (i--; i >= start; i--)
 		ptr_ring_cleanup(&priv->rq[i].xdp_ring, veth_ptr_free);
 
 	return err;
 }
 
-static void veth_napi_del(struct net_device *dev)
+static int __veth_napi_enable(struct net_device *dev)
+{
+	return __veth_napi_enable_range(dev, 0, dev->real_num_rx_queues);
+}
+
+static void veth_napi_del_range(struct net_device *dev, int start, int end)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
 		rcu_assign_pointer(priv->rq[i].napi, NULL);
@@ -968,7 +974,7 @@ static void veth_napi_del(struct net_device *dev)
 	}
 	synchronize_net();
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
 		rq->rx_notify_masked = false;
@@ -976,41 +982,90 @@ static void veth_napi_del(struct net_device *dev)
 	}
 }
 
+static void veth_napi_del(struct net_device *dev)
+{
+	veth_napi_del_range(dev, 0, dev->real_num_rx_queues);
+}
+
 static bool veth_gro_requested(const struct net_device *dev)
 {
 	return !!(dev->wanted_features & NETIF_F_GRO);
 }
 
-static int veth_enable_xdp(struct net_device *dev)
+static int veth_enable_xdp_range(struct net_device *dev, int start, int end,
+				 bool napi_already_on)
 {
-	bool napi_already_on = veth_gro_requested(dev) && (dev->flags & IFF_UP);
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
 
-	if (!xdp_rxq_info_is_reg(&priv->rq[0].xdp_rxq)) {
-		for (i = 0; i < dev->real_num_rx_queues; i++) {
-			struct veth_rq *rq = &priv->rq[i];
+	for (i = start; i < end; i++) {
+		struct veth_rq *rq = &priv->rq[i];
 
-			if (!napi_already_on)
-				netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
-			err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i, rq->xdp_napi.napi_id);
-			if (err < 0)
-				goto err_rxq_reg;
+		if (!napi_already_on)
+			netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
+		err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i, rq->xdp_napi.napi_id);
+		if (err < 0)
+			goto err_rxq_reg;
 
-			err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
-							 MEM_TYPE_PAGE_SHARED,
-							 NULL);
-			if (err < 0)
-				goto err_reg_mem;
+		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED,
+						 NULL);
+		if (err < 0)
+			goto err_reg_mem;
 
-			/* Save original mem info as it can be overwritten */
-			rq->xdp_mem = rq->xdp_rxq.mem;
-		}
+		/* Save original mem info as it can be overwritten */
+		rq->xdp_mem = rq->xdp_rxq.mem;
+	}
+	return 0;
+
+err_reg_mem:
+	xdp_rxq_info_unreg(&priv->rq[i].xdp_rxq);
+err_rxq_reg:
+	for (i--; i >= start; i--) {
+		struct veth_rq *rq = &priv->rq[i];
+
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+		if (!napi_already_on)
+			netif_napi_del(&rq->xdp_napi);
+	}
+
+	return err;
+}
+
+static void veth_disable_xdp_range(struct net_device *dev, int start, int end,
+				   bool delete_napi)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	int i;
+
+	for (i = start; i < end; i++) {
+		struct veth_rq *rq = &priv->rq[i];
+
+		rq->xdp_rxq.mem = rq->xdp_mem;
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+
+		if (delete_napi)
+			netif_napi_del(&rq->xdp_napi);
+	}
+}
+
+static int veth_enable_xdp(struct net_device *dev)
+{
+	bool napi_already_on = veth_gro_requested(dev) && (dev->flags & IFF_UP);
+	struct veth_priv *priv = netdev_priv(dev);
+	int err, i;
+
+	if (!xdp_rxq_info_is_reg(&priv->rq[0].xdp_rxq)) {
+		err = veth_enable_xdp_range(dev, 0, dev->real_num_rx_queues, napi_already_on);
+		if (err)
+			return err;
 
 		if (!napi_already_on) {
 			err = __veth_napi_enable(dev);
-			if (err)
-				goto err_rxq_reg;
+			if (err) {
+				veth_disable_xdp_range(dev, 0, dev->real_num_rx_queues, true);
+				return err;
+			}
 
 			if (!veth_gro_requested(dev)) {
 				/* user-space did not require GRO, but adding XDP
@@ -1028,18 +1083,6 @@ static int veth_enable_xdp(struct net_device *dev)
 	}
 
 	return 0;
-err_reg_mem:
-	xdp_rxq_info_unreg(&priv->rq[i].xdp_rxq);
-err_rxq_reg:
-	for (i--; i >= 0; i--) {
-		struct veth_rq *rq = &priv->rq[i];
-
-		xdp_rxq_info_unreg(&rq->xdp_rxq);
-		if (!napi_already_on)
-			netif_napi_del(&rq->xdp_napi);
-	}
-
-	return err;
 }
 
 static void veth_disable_xdp(struct net_device *dev)
@@ -1062,28 +1105,23 @@ static void veth_disable_xdp(struct net_device *dev)
 		}
 	}
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		struct veth_rq *rq = &priv->rq[i];
-
-		rq->xdp_rxq.mem = rq->xdp_mem;
-		xdp_rxq_info_unreg(&rq->xdp_rxq);
-	}
+	veth_disable_xdp_range(dev, 0, dev->real_num_rx_queues, false);
 }
 
-static int veth_napi_enable(struct net_device *dev)
+static int veth_napi_enable_range(struct net_device *dev, int start, int end)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
 
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
+	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
 		netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
 	}
 
-	err = __veth_napi_enable(dev);
+	err = __veth_napi_enable_range(dev, start, end);
 	if (err) {
-		for (i = 0; i < dev->real_num_rx_queues; i++) {
+		for (i = start; i < end; i++) {
 			struct veth_rq *rq = &priv->rq[i];
 
 			netif_napi_del(&rq->xdp_napi);
@@ -1093,6 +1131,11 @@ static int veth_napi_enable(struct net_device *dev)
 	return err;
 }
 
+static int veth_napi_enable(struct net_device *dev)
+{
+	return veth_napi_enable_range(dev, 0, dev->real_num_rx_queues);
+}
+
 static int veth_open(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-- 
2.26.3

