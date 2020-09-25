Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9922784A8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgIYKCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgIYKCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 06:02:21 -0400
Received: from lore-desk.redhat.com (unknown [151.66.98.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30AD720BED;
        Fri, 25 Sep 2020 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601028140;
        bh=e8/Q+UIY7zzX9mq9zwfBe5UpqsZBr0KiAslth0//+4I=;
        h=From:To:Cc:Subject:Date:From;
        b=d1yr7AqWQBhv6fj/C3YbS68coziOV5OhOVu7FFyUXI1jj4MMmfAavlcTCZ8OShAbJ
         ndeonpMrpT3GQV8IkkkO3Q3jgLJ7ppobIv/n7j4DSfH7oUE9BF1Yn5xTbSyUfi/JnP
         ELLnP47pg8LYiIOComkBbai0RGqPRGelGsNMn0os=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next] net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_free
Date:   Fri, 25 Sep 2020 12:01:32 +0200
Message-Id: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Try to recycle the xdp tx buffer into the in-irq page_pool cache if
mvneta_txq_bufs_free is executed in the NAPI context.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 14df3aec285d..646fbf4ed638 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1831,7 +1831,7 @@ static struct mvneta_tx_queue *mvneta_tx_done_policy(struct mvneta_port *pp,
 /* Free tx queue skbuffs */
 static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 				 struct mvneta_tx_queue *txq, int num,
-				 struct netdev_queue *nq)
+				 struct netdev_queue *nq, bool napi)
 {
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	int i;
@@ -1854,7 +1854,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			dev_kfree_skb_any(buf->skb);
 		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
 			   buf->type == MVNETA_TYPE_XDP_NDO) {
-			xdp_return_frame(buf->xdpf);
+			if (napi)
+				xdp_return_frame_rx_napi(buf->xdpf);
+			else
+				xdp_return_frame(buf->xdpf);
 		}
 	}
 
@@ -1872,7 +1875,7 @@ static void mvneta_txq_done(struct mvneta_port *pp,
 	if (!tx_done)
 		return;
 
-	mvneta_txq_bufs_free(pp, txq, tx_done, nq);
+	mvneta_txq_bufs_free(pp, txq, tx_done, nq, true);
 
 	txq->count -= tx_done;
 
@@ -2859,7 +2862,7 @@ static void mvneta_txq_done_force(struct mvneta_port *pp,
 	struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
 	int tx_done = txq->count;
 
-	mvneta_txq_bufs_free(pp, txq, tx_done, nq);
+	mvneta_txq_bufs_free(pp, txq, tx_done, nq, false);
 
 	/* reset txq */
 	txq->count = 0;
-- 
2.26.2

