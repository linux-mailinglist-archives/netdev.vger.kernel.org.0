Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7EB2ADA91
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732520AbgKJPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbgKJPi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:38:28 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091212068D;
        Tue, 10 Nov 2020 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605022707;
        bh=4gnREmuwSa2XungGUD/o8nxhAxK6wXA9b7cFmNq7Mss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X89BvV6E07wqZD05WNT/S5k0Ft6NnYbr4LvpkoDwfzmBxz5Zctt6qgc6O4nNQ9bQV
         sHQgMsWWqaSVhPOTva8taUl/W1TN8YammBSjo5BdJD+xS0eKK1FcLUM9ClneNyeaBi
         r1TA8GJJIElmRMeT5PLf5DGjMU95kycOU0ncIgUA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v5 net-nex 4/5] net: mvpp2: add xdp tx return bulking support
Date:   Tue, 10 Nov 2020 16:37:59 +0100
Message-Id: <46c77bc9ae56f7dd5c9ae047b78ed54ac9e3b42a.1605020963.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605020963.git.lorenzo@kernel.org>
References: <cover.1605020963.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 driver to xdp_return_frame_bulk APIs.

XDP_REDIRECT (upstream codepath): 1.79Mpps
XDP_REDIRECT (upstream codepath + bulking APIs): 1.93Mpps

Tested-by: Matteo Croce <mcroce@microsoft.com>
Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..3069e192d773 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2440,8 +2440,13 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
 				struct mvpp2_tx_queue *txq,
 				struct mvpp2_txq_pcpu *txq_pcpu, int num)
 {
+	struct xdp_frame_bulk bq;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
+
 	for (i = 0; i < num; i++) {
 		struct mvpp2_txq_pcpu_buf *tx_buf =
 			txq_pcpu->buffs + txq_pcpu->txq_get_index;
@@ -2454,10 +2459,13 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
 			dev_kfree_skb_any(tx_buf->skb);
 		else if (tx_buf->type == MVPP2_TYPE_XDP_TX ||
 			 tx_buf->type == MVPP2_TYPE_XDP_NDO)
-			xdp_return_frame(tx_buf->xdpf);
+			xdp_return_frame_bulk(tx_buf->xdpf, &bq);
 
 		mvpp2_txq_inc_get(txq_pcpu);
 	}
+	xdp_flush_frame_bulk(&bq);
+
+	rcu_read_unlock();
 }
 
 static inline struct mvpp2_rx_queue *mvpp2_get_rx_queue(struct mvpp2_port *port,
-- 
2.26.2

