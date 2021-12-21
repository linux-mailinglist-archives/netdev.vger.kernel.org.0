Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C56447B72B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhLUB6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhLUB6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F3C061574;
        Mon, 20 Dec 2021 17:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0815A61348;
        Tue, 21 Dec 2021 01:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A93CC36AE5;
        Tue, 21 Dec 2021 01:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051895;
        bh=VCC9Rz9bKe9caBpGx6Wx7E+PHaTmlL44LWegavyat7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STAW+KdXKCcw2upA3RiEbvp66ChQKeYQ9EcN1xE9lV87YCI8KukKiuO+EnSxNF9hZ
         25rfKFausvNo3oVbIGLkjVBH5SXwciqQj6CMPX20hThr4fLNFo1SrmSy+kn4nMx7+X
         v8UrBEknqCTEyK1rkFNWS6jcvsAD/KGqGEYlrcudWg58sLcpQtAijxXmsDz7KKn4nP
         KRqOaJcoRJ++51CSPiT2DtBlTEAGMsl66IY1gceuNltZRZFJ5HSljxhO6hRbnaKxRT
         WoUsuLsxw6OLukUXwLKsoc/0IwU9GGGjUq6uqG0Nqj+3hykp+VV8jxaSfuX0lcbsRk
         d1zU55jstXU2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        vigneshr@ti.com, grygorii.strashko@ti.com, vladimir.oltean@nxp.com,
        leon@kernel.org, peter.ujfalusi@ti.com, michael@walle.cc,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/29] net: ethernet: ti: add missing of_node_put before return
Date:   Mon, 20 Dec 2021 20:57:34 -0500
Message-Id: <20211221015751.116328-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit be565ec71d1d59438bed0c7ed0a252a327e0b0ef ]

Fix following coccicheck warning:
WARNING: Function "for_each_child_of_node"
should have of_node_put() before return.

Early exits from for_each_child_of_node should decrement the
node reference counter.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 29 ++++++++++++++++--------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 130346f74ee8a..8829926e2c676 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1844,13 +1844,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret < 0) {
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		if (!port_id || port_id > common->port_num) {
 			dev_err(dev, "%pOF has invalid port_id %u %s\n",
 				port_np, port_id, port_np->name);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto of_node_put;
 		}
 
 		port = am65_common_get_port(common, port_id);
@@ -1866,8 +1867,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
+		if (IS_ERR(port->slave.mac_sl)) {
+			ret = PTR_ERR(port->slave.mac_sl);
+			goto of_node_put;
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled) {
@@ -1880,7 +1883,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		port->slave.mac_only =
@@ -1889,10 +1892,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret)
-				return dev_err_probe(dev, ret,
+			if (ret) {
+				ret = dev_err_probe(dev, ret,
 						     "failed to register fixed-link phy %pOF\n",
 						     port_np);
+				goto of_node_put;
+			}
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -1902,14 +1907,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (!port->slave.phy_node) {
 			dev_err(dev,
 				"slave[%d] no phy found\n", port_id);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto of_node_put;
 		}
 
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
@@ -1932,6 +1938,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	}
 
 	return 0;
+
+of_node_put:
+	of_node_put(port_np);
+	of_node_put(node);
+	return ret;
 }
 
 static void am65_cpsw_pcpu_stats_free(void *data)
-- 
2.34.1

