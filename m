Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A102B1A82
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKMMDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgKMLte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 06:49:34 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 522AF22250;
        Fri, 13 Nov 2020 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605268135;
        bh=4gnREmuwSa2XungGUD/o8nxhAxK6wXA9b7cFmNq7Mss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGhEqB9s1Y0KVNZm7HGoUyfGZ/lyrmucu6d4BFODpM23USj9slHfQNxP+W9X+ejaY
         mqaEY73VVTeY07f85yVy+YybOZVhP07YL5fi9kMUnNigJXOx+LHANQLdBQ0rpVME3v
         dSLwYQ2yNqBBhqaFvdmf/GRLpC35Y4+R+Kd/b1Ww=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Subject: [PATCH v6 net-nex 4/5] net: mvpp2: add xdp tx return bulking support
Date:   Fri, 13 Nov 2020 12:48:31 +0100
Message-Id: <0b38c295e58e8ce251ef6b4e2187a2f457f9f7a3.1605267335.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
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

