Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F7428C10F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391369AbgJLTIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389111AbgJLTDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7973B20BED;
        Mon, 12 Oct 2020 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529395;
        bh=MSdwjkHc6Z6nI5vbQtbZZfbAjbZSo+bCnmXs5P1NJhc=;
        h=From:To:Cc:Subject:Date:From;
        b=LzoTrBzh8X45QPBKQ1Fv/tmnT68CpTyf/sNSsOtkpOt9Fg69ImM2xvG2eC5R/SPUb
         IX2IM1xE1q56nToL12hr1psr34Nr7Y7HqM/aBguUOhyneELJ+lUrjCGQniL7bcx+dN
         pKmuMk3DsKpsUIXYvPkBs9yyN5OUSXC+BYk0cXxE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/15] net: lantiq: Add locking for TX DMA channel
Date:   Mon, 12 Oct 2020 15:02:58 -0400
Message-Id: <20201012190313.3279397-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit f9317ae5523f99999fb54c513ebabbb2bc887ddf ]

The TX DMA channel data is accessed by the xrx200_start_xmit() and the
xrx200_tx_housekeeping() function from different threads. Make sure the
accesses are synchronized by acquiring the netif_tx_lock() in the
xrx200_tx_housekeeping() function too. This lock is acquired by the
kernel before calling xrx200_start_xmit().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 96948276b2bc3..4e44a39267eb3 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -245,6 +245,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	int pkts = 0;
 	int bytes = 0;
 
+	netif_tx_lock(net_dev);
 	while (pkts < budget) {
 		struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->tx_free];
 
@@ -268,6 +269,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	net_dev->stats.tx_bytes += bytes;
 	netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
+	netif_tx_unlock(net_dev);
 	if (netif_queue_stopped(net_dev))
 		netif_wake_queue(net_dev);
 
-- 
2.25.1

