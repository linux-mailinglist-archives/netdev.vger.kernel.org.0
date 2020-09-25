Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00316278A70
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgIYOJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgIYOJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:09:25 -0400
Received: from lore-desk.redhat.com (unknown [151.66.98.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FDD1208A9;
        Fri, 25 Sep 2020 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601042964;
        bh=x46ZxXXAbuoXn4xaE8AKhV7/n/wHF76Ca3nxs64Ign4=;
        h=From:To:Cc:Subject:Date:From;
        b=0TGgbShoieFz/DAmHLyaDPpo7bQ6DSMbVw7jaI9WEWrP+72EuFO00BFN70hPRwZCU
         oMYJNE6IkFjYr/hk188d1LkKegEs7JbqEnVGt5+Nx1H5e5owmXwwxP5KcA6EU33G72
         uGbv6HKC93WmqfDvQPqE6XEAEXAgO4q+nA2VIAgk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com,
        thomas.petazzoni@bootlin.com
Subject: [PATCH v2 net-next] net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_free
Date:   Fri, 25 Sep 2020 16:09:11 +0200
Message-Id: <d1fd2d8908c949c7469b78d0d6b6a4b9ac43aa94.1601042644.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Try to recycle the xdp tx buffer into the in-irq page_pool cache if
mvneta_txq_bufs_free is executed in the NAPI context for XDP_TX use case

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- run xdp_return_frame_rx_napi for XDP_TX only
---
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 14df3aec285d..bb485745b72a 100644
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
+			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
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

