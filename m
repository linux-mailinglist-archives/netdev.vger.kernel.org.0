Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A54AFF395
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbfKPQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfKPPlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:55 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D02F2075E;
        Sat, 16 Nov 2019 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918914;
        bh=cTbj6kOszfLz/oxz/9GOU8X8ThfPuqYFmp+Zf3cX2vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMJUzoFbOLWkXF0tTeIoqeDFDDnmQ0yWTv8ggkMJt7zaC9CWZxQdcuUV8Xv1vtqBJ
         VxWjyh6Ft+mTsuewIDyV4c360LsoArH50cd9psPugFare7Zj462IoZeSBo8ZHorCKB
         TSlwSnD9IsUWPUFcRBU5xXXTfG+MOEGh14SQtRKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 037/237] net: ethernet: ti: cpsw: fix lost of mcast packets while rx_mode update
Date:   Sat, 16 Nov 2019 10:37:52 -0500
Message-Id: <20191116154113.7417-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit 5da1948969bc1991920987ce4361ea56046e5a98 ]

Whenever kernel or user decides to call rx mode update, it clears
every multicast entry from forwarding table and in some time adds
it again. This time can be enough to drop incoming multicast packets.

That's why clear only staled multicast entries and update or add new
one afterwards.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 46 +++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 1afed85550c0a..ef79d2b6070b9 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -570,7 +570,7 @@ static inline int cpsw_get_slave_port(u32 slave_num)
 	return slave_num + 1;
 }
 
-static void cpsw_add_mcast(struct cpsw_priv *priv, u8 *addr)
+static void cpsw_add_mcast(struct cpsw_priv *priv, const u8 *addr)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 
@@ -662,16 +662,35 @@ static void cpsw_set_promiscious(struct net_device *ndev, bool enable)
 	}
 }
 
-static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
+static int cpsw_add_mc_addr(struct net_device *ndev, const u8 *addr)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+
+	cpsw_add_mcast(priv, addr);
+	return 0;
+}
+
+static int cpsw_del_mc_addr(struct net_device *ndev, const u8 *addr)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	int vid;
+	int vid, flags;
 
-	if (cpsw->data.dual_emac)
+	if (cpsw->data.dual_emac) {
 		vid = cpsw->slaves[priv->emac_port].port_vlan;
-	else
-		vid = cpsw->data.default_vlan;
+		flags = ALE_VLAN;
+	} else {
+		vid = 0;
+		flags = 0;
+	}
+
+	cpsw_ale_del_mcast(cpsw->ale, addr, 0, flags, vid);
+	return 0;
+}
+
+static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
+{
+	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 
 	if (ndev->flags & IFF_PROMISC) {
 		/* Enable promiscuous mode */
@@ -684,19 +703,9 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 	}
 
 	/* Restore allmulti on vlans if necessary */
-	cpsw_ale_set_allmulti(cpsw->ale, priv->ndev->flags & IFF_ALLMULTI);
-
-	/* Clear all mcast from ALE */
-	cpsw_ale_flush_multicast(cpsw->ale, ALE_ALL_PORTS, vid);
+	cpsw_ale_set_allmulti(cpsw->ale, ndev->flags & IFF_ALLMULTI);
 
-	if (!netdev_mc_empty(ndev)) {
-		struct netdev_hw_addr *ha;
-
-		/* program multicast address list into ALE register */
-		netdev_for_each_mc_addr(ha, ndev) {
-			cpsw_add_mcast(priv, ha->addr);
-		}
-	}
+	__dev_mc_sync(ndev, cpsw_add_mc_addr, cpsw_del_mc_addr);
 }
 
 static void cpsw_intr_enable(struct cpsw_common *cpsw)
@@ -1956,6 +1965,7 @@ static int cpsw_ndo_stop(struct net_device *ndev)
 	struct cpsw_common *cpsw = priv->cpsw;
 
 	cpsw_info(priv, ifdown, "shutting down cpsw device\n");
+	__dev_mc_unsync(priv->ndev, cpsw_del_mc_addr);
 	netif_tx_stop_all_queues(priv->ndev);
 	netif_carrier_off(priv->ndev);
 
-- 
2.20.1

