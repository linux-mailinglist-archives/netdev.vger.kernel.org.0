Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA284F623D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfKJClU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfKJClU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708DD214E0;
        Sun, 10 Nov 2019 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353679;
        bh=JAbrtaSL+QK41Axroq+rf9albIjpZv9Etw0phcmZYG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDd03eYJ6ETMTDZaGSOdHijULjJf1R7U5kuD7/dCRewrFHIar9ftklsJu3/YJSCkj
         EifKxuLIWvDNL/JhUaT8fa/3ZwibOGDXhe2ToqnrX+fuqkr/UbqEqRs8DQfcJH9ho3
         9jDH4foOZOw8KcSQyI7tIl5CaEVKGTA8EzzaTX28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/191] net: marvell: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:37:42 -0500
Message-Id: <20191110024013.29782-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit f03508ce3f9650148262c176e0178413e16c902b ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c           | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c       | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 28762314353f9..4313bbb2396f4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2394,7 +2394,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 }
 
 /* Main tx processing */
-static int mvneta_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 	u16 txq_id = skb_get_queue_mapping(skb);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 29f1260535325..1cc0e8fda4d5e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2901,7 +2901,7 @@ static int mvpp2_tx_tso(struct sk_buff *skb, struct net_device *dev,
 }
 
 /* Main tx processing */
-static int mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	struct mvpp2_tx_queue *txq, *aggr_txq;
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 3a9730612a704..ff2fea0f8b751 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1260,7 +1260,8 @@ static int pxa168_rx_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static int pxa168_eth_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+pxa168_eth_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
-- 
2.20.1

