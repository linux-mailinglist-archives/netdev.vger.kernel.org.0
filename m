Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851C9FBC8B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfKMX0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfKMX0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 18:26:10 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D936206D3;
        Wed, 13 Nov 2019 23:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573687570;
        bh=xAlv00x5LoZ9klv73cSIvStKyiKSJT8NTJalmD+P/gE=;
        h=From:To:Cc:Subject:Date:From;
        b=2OSx2q9qHnE3zy5NJiIg1AU9jsBKkvQibP7xsbuZEwuAGcCGwiTCaxm6ckB7eZ1aB
         K9JdfGlOwN/fC9QXfjRvXMBvi+49IvAKtKCtQYaiV7xm23C/xfupAfM7yTbdjIJIgt
         pu3n5iz+rSi6tOXllERqPPtuUCudH72HBGr8WTkA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: mvneta: fix build skb for bm capable devices
Date:   Thu, 14 Nov 2019 01:25:55 +0200
Message-Id: <2369ff5a16ac160d8130612e4299efe072f53d80.1573686984.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build_skb for bm capable devices when they fall-back using swbm path
(e.g. when bm properties are configured in device tree but
CONFIG_MVNETA_BM_ENABLE is not set). In this case rx_offset_correction is
overwritten so we need to use it building skb instead of
MVNETA_SKB_HEADROOM directly

Fixes: 8dc9a0888f4c ("net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine")
Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 274ac39c0f0f..12e03b15f0ab 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2154,7 +2154,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
 
 	xdp->data_hard_start = data;
-	xdp->data = data + MVNETA_SKB_HEADROOM + MVNETA_MH_SIZE;
+	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
 	xdp->data_end = xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
 
@@ -2219,7 +2219,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		/* refill descriptor with new buffer later */
 		skb_add_rx_frag(rxq->skb,
 				skb_shinfo(rxq->skb)->nr_frags,
-				page, MVNETA_SKB_HEADROOM, data_len,
+				page, pp->rx_offset_correction, data_len,
 				PAGE_SIZE);
 	}
 	page_pool_release_page(rxq->page_pool, page);
-- 
2.21.0

