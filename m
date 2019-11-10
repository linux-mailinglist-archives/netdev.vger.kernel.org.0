Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEEDF62A3
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfKJCo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfKJCoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C612215EA;
        Sun, 10 Nov 2019 02:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353864;
        bh=3ru+fbk/QufQ0XE+ob/8DRC3fwJaVsL7W6sXvD+nWdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTneBXWIyZ6l63Y94mJGrUHds7iXltE01h36VcEW+ae8tURh+k2mYzT/95DLOYc//
         iynlYtdB9cjIli+GETqdZEU3jpsWGDtN+iUQvbWDC/L80jTTsAsjdFlyDJuS79Ro4/
         zhnSiKUJ8ep4kTvys1/ZQfYf2noAPyR4+zf3g2Hw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 144/191] net: faraday: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:39:26 -0500
Message-Id: <20191110024013.29782-144-sashal@kernel.org>
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

[ Upstream commit 0a715156656bddf4aa92d9868f850aeeb0465fd0 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 4 ++--
 drivers/net/ethernet/faraday/ftmac100.c  | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ed6c76d20b45b..4f49825d41ea5 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -712,8 +712,8 @@ static bool ftgmac100_prep_tx_csum(struct sk_buff *skb, u32 *csum_vlan)
 	return skb_checksum_help(skb) == 0;
 }
 
-static int ftgmac100_hard_start_xmit(struct sk_buff *skb,
-				     struct net_device *netdev)
+static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
+					     struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 	struct ftgmac100_txdes *txdes, *first;
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 9015bd911bee9..084f24daf2b5a 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -634,8 +634,8 @@ static void ftmac100_tx_complete(struct ftmac100 *priv)
 		;
 }
 
-static int ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
-			 dma_addr_t map)
+static netdev_tx_t ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
+				 dma_addr_t map)
 {
 	struct net_device *netdev = priv->netdev;
 	struct ftmac100_txdes *txdes;
@@ -1015,7 +1015,8 @@ static int ftmac100_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int ftmac100_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+ftmac100_hard_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct ftmac100 *priv = netdev_priv(netdev);
 	dma_addr_t map;
-- 
2.20.1

