Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42251B49FA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgDVQNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDVQNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:13:47 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE57C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g11so2071565pgd.20
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MgkgMi3UlskwclrsH+Z+NA0uAr5Tp+J+iQr6ZG85W34=;
        b=q3TJM+oe3rMQgd/JbPNpnL5mmBYL8e0c22ZazJyQD3ZmQ20IT3HA0QFdBsjigZCWD1
         w+umEfdkwba/C/Nbl4scv9lFu1ZsqWEi+RVnsIBBbcndj+YnTybCAfp6uva0tbUgwUOC
         gcLWsJyHhQ2deANu1wAvvSoWi7uKG5WWZbeQlLl1Y5f/XNvYr6rXuZkOiV6kF8UrHzvh
         +yelZsswY8lK/EvSg4pSYcZRel3vWUK8Jn59WNrxiqoEZSc4e7TKfuqngoKYxgegfKGw
         QG/jy0V66nAtW0c+y6ip5uiPnDWaf5+a/2hoJodX3X4R/3BdG+A2lSFk8cechOWXq84v
         iG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MgkgMi3UlskwclrsH+Z+NA0uAr5Tp+J+iQr6ZG85W34=;
        b=e26WRg0+1fUV43g4z0c5afWer8reGXGrCpy6eCuQAqzRDNqSW0UMXX5H6/c8IqAOsg
         7tzvEfiCDG2NXFnTM/GpZlTUPs8cjSL/wd/pAbRTV0w/JreCiCBoOXX20bQhFd68KRBn
         554bMJsklkebXxLahih07fZtUSCZMv2uwOTCfa/irWC5jDvOlPFdP56ZtWbBbkJeuJej
         kmInOf3xkg950BktvqjCfOdGiE1v0dN8pj5EMz14xd0JrjEOwDcO1F8VPk02zA+ar0Ot
         xkPRhzf8FXmd5KQ1EHaRDsPBzJYvI8XXpjFqm4AzBj7DkVe+miG0kldSSeAsIPXcA0yM
         YMaA==
X-Gm-Message-State: AGi0PuZkn23gJxK2dVE1lRWkV5caE0tpI3RyHcScbH8NUZmd8v6tx0LT
        8jFW/D1jWJ4Fu3NQmB4v1nXxTIFlQioBBQ==
X-Google-Smtp-Source: APiQypLtB6PtZeYj/9pos4Qc/OOJo2p/5+S/I2f59j+mxDar7z8C8KBaR13whkoWGbyz4pitTxfE46+9pdoYKA==
X-Received: by 2002:a17:90b:1104:: with SMTP id gi4mr13102137pjb.115.1587572026806;
 Wed, 22 Apr 2020 09:13:46 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:13:29 -0700
In-Reply-To: <20200422161329.56026-1-edumazet@google.com>
Message-Id: <20200422161329.56026-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200422161329.56026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net-next 3/3] net/mlx4_en: use napi_complete_done() in TX completion
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to benefit from the new napi_defer_hard_irqs feature,
we need to use napi_complete_done() variant in this driver.

RX path is already using it, this patch implements TX completion side.

mlx4_en_process_tx_cq() now returns the amount of retired packets,
instead of a boolean, so that mlx4_en_poll_tx_cq() can pass
this value to napi_complete_done().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 20 ++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index db3552f2d0877e37ce8dcf215d4c273e91c2326c..7871392198130fa7d1a09baf26a0a00f1bf2e1f5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -946,7 +946,7 @@ int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget)
 		xdp_tx_cq = priv->tx_cq[TX_XDP][cq->ring];
 		if (xdp_tx_cq->xdp_busy) {
 			clean_complete = mlx4_en_process_tx_cq(dev, xdp_tx_cq,
-							       budget);
+							       budget) < budget;
 			xdp_tx_cq->xdp_busy = !clean_complete;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 4d5ca302c067126b8627cb4809485b45c10e2460..a99d3ed49ed684db5d5b90e78e0767f97ee6cc9d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -382,8 +382,8 @@ int mlx4_en_free_tx_buf(struct net_device *dev, struct mlx4_en_tx_ring *ring)
 	return cnt;
 }
 
-bool mlx4_en_process_tx_cq(struct net_device *dev,
-			   struct mlx4_en_cq *cq, int napi_budget)
+int mlx4_en_process_tx_cq(struct net_device *dev,
+			  struct mlx4_en_cq *cq, int napi_budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_cq *mcq = &cq->mcq;
@@ -405,7 +405,7 @@ bool mlx4_en_process_tx_cq(struct net_device *dev,
 	u32 ring_cons;
 
 	if (unlikely(!priv->port_up))
-		return true;
+		return 0;
 
 	netdev_txq_bql_complete_prefetchw(ring->tx_queue);
 
@@ -480,7 +480,7 @@ bool mlx4_en_process_tx_cq(struct net_device *dev,
 	WRITE_ONCE(ring->cons, ring_cons + txbbs_skipped);
 
 	if (cq->type == TX_XDP)
-		return done < budget;
+		return done;
 
 	netdev_tx_completed_queue(ring->tx_queue, packets, bytes);
 
@@ -492,7 +492,7 @@ bool mlx4_en_process_tx_cq(struct net_device *dev,
 		ring->wake_queue++;
 	}
 
-	return done < budget;
+	return done;
 }
 
 void mlx4_en_tx_irq(struct mlx4_cq *mcq)
@@ -512,14 +512,14 @@ int mlx4_en_poll_tx_cq(struct napi_struct *napi, int budget)
 	struct mlx4_en_cq *cq = container_of(napi, struct mlx4_en_cq, napi);
 	struct net_device *dev = cq->dev;
 	struct mlx4_en_priv *priv = netdev_priv(dev);
-	bool clean_complete;
+	int work_done;
 
-	clean_complete = mlx4_en_process_tx_cq(dev, cq, budget);
-	if (!clean_complete)
+	work_done = mlx4_en_process_tx_cq(dev, cq, budget);
+	if (work_done >= budget)
 		return budget;
 
-	napi_complete(napi);
-	mlx4_en_arm_cq(priv, cq);
+	if (napi_complete_done(napi, work_done))
+		mlx4_en_arm_cq(priv, cq);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 630f15977f091c1e28eceb7b6bc33414a69d5694..9f5603612960303c5d9f37603d8f7e51ddee9ac6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -737,8 +737,8 @@ int mlx4_en_process_rx_cq(struct net_device *dev,
 			  int budget);
 int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget);
 int mlx4_en_poll_tx_cq(struct napi_struct *napi, int budget);
-bool mlx4_en_process_tx_cq(struct net_device *dev,
-			   struct mlx4_en_cq *cq, int napi_budget);
+int mlx4_en_process_tx_cq(struct net_device *dev,
+			  struct mlx4_en_cq *cq, int napi_budget);
 u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 			 struct mlx4_en_tx_ring *ring,
 			 int index, u64 timestamp,
-- 
2.26.1.301.g55bc3eb7cb9-goog

