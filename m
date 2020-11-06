Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ADC2A9BC1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgKFSTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:19:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgKFSTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 13:19:39 -0500
Received: from localhost.localdomain (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FE3121D46;
        Fri,  6 Nov 2020 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604686778;
        bh=CEqASvpURooVyTo2fuJKqWW0pHRASjrmZUlThXYDT4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXZEU1Jq80oTB0VfHSXCh3DuSkoAlRKaqpE/1BS048fTvi1o1oTUEIE2F2qZqL8he
         udwUYJFKX0tU4MJxVv8SLOBk9scVUeX2QbXWRlH2jxM3P+ci3tDRp6v+eiCHY9dAHt
         155Xw0Lj04zyAgnWFcQio4youA5Xa4HAtkIptLOU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v4 net-next 4/5] net: mvpp2: add xdp tx return bulking support
Date:   Fri,  6 Nov 2020 19:19:10 +0100
Message-Id: <95e2f35e391e5fb7852c94c03142cec08a02910b.1604686496.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604686496.git.lorenzo@kernel.org>
References: <cover.1604686496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 driver to xdp_return_frame_bulk APIs.

XDP_REDIRECT (upstream codepath): 1.79Mpps
XDP_REDIRECT (upstream codepath + bulking APIs): 1.93Mpps

Tested-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..04f24d1d72ab 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2440,8 +2440,10 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
 				struct mvpp2_tx_queue *txq,
 				struct mvpp2_txq_pcpu *txq_pcpu, int num)
 {
+	struct xdp_frame_bulk bq;
 	int i;
 
+	bq.xa = NULL;
 	for (i = 0; i < num; i++) {
 		struct mvpp2_txq_pcpu_buf *tx_buf =
 			txq_pcpu->buffs + txq_pcpu->txq_get_index;
@@ -2454,10 +2456,11 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
 			dev_kfree_skb_any(tx_buf->skb);
 		else if (tx_buf->type == MVPP2_TYPE_XDP_TX ||
 			 tx_buf->type == MVPP2_TYPE_XDP_NDO)
-			xdp_return_frame(tx_buf->xdpf);
+			xdp_return_frame_bulk(tx_buf->xdpf, &bq);
 
 		mvpp2_txq_inc_get(txq_pcpu);
 	}
+	xdp_flush_frame_bulk(&bq);
 }
 
 static inline struct mvpp2_rx_queue *mvpp2_get_rx_queue(struct mvpp2_port *port,
-- 
2.26.2

