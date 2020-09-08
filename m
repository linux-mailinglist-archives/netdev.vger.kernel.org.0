Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F699261A10
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbgIHSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731580AbgIHSaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:30:30 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D2F207DE;
        Tue,  8 Sep 2020 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599589425;
        bh=9HAfgj9b1/rx/eZXwtXQApy94OcwWxjKlukNRbG4yCo=;
        h=From:To:Cc:Subject:Date:From;
        b=KV8sqegkEClsKqQg8vQjGX0ExilGvpeKQVr3jQGlyRlzyErzHAe4MCJOt5HLV4dRI
         MMG3aHJi9iS8pzxJ7B7cFT/U7feUzNG+UV/7ZhCrs5Bz14ebKLP3Uq1qEim8spOhPi
         4io/dce/wTCnoG4+hvrqsbJ2CVN0UTwR1shFlhbc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: [PATCH net-next] net: mvneta: rely on MVNETA_MAX_RX_BUF_SIZE for pkt split in mvneta_swbm_rx_frame()
Date:   Tue,  8 Sep 2020 20:23:31 +0200
Message-Id: <7b417a96a147d88ffdabc8e906d26d5adf39170d.1599588966.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to easily change the rx buffer size, rely on
MVNETA_MAX_RX_BUF_SIZE instead of PAGE_SIZE in mvneta_swbm_rx_frame
routine for rx buffer split. Currently this is not an issue since we set
MVNETA_MAX_RX_BUF_SIZE to PAGE_SIZE - MVNETA_SKB_PAD but it is a good to
have to configure a different rx buffer size.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index dfcb1767acbb..fa3c0b9f69fe 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -330,7 +330,6 @@
 #define MVNETA_SKB_HEADROOM	ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
-#define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
 #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
 
 #define IS_TSO_HEADER(txq, addr) \
@@ -2236,7 +2235,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	enum dma_data_direction dma_dir;
 	struct skb_shared_info *sinfo;
 
-	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
+	if (rx_desc->data_size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
 		data_len += len;
 	} else {
-- 
2.26.2

