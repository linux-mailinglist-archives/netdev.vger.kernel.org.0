Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154DA6560AC
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiLZHNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZHNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:13:34 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC7AA2BF2;
        Sun, 25 Dec 2022 23:13:33 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,274,1665414000"; 
   d="scan'208";a="144515675"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 26 Dec 2022 16:13:33 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 0527D41BAEC7;
        Mon, 26 Dec 2022 16:13:33 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net 2/2] net: ethernet: renesas: rswitch: Fix getting mac address from device tree
Date:   Mon, 26 Dec 2022 16:13:28 +0900
Message-Id: <20221226071328.3895854-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get mac address from device tree which is from each ethernet-port,
fix the first argument of of_get_ethdev_address().

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 473d86bdf97d..6441892636db 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1578,6 +1578,7 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 {
 	struct platform_device *pdev = priv->pdev;
 	struct rswitch_device *rdev;
+	struct device_node *port;
 	struct net_device *ndev;
 	int err;
 
@@ -1606,7 +1607,9 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 
 	netif_napi_add(ndev, &rdev->napi, rswitch_poll);
 
-	err = of_get_ethdev_address(pdev->dev.of_node, ndev);
+	port = rswitch_get_port_node(rdev);
+	err = of_get_ethdev_address(port, ndev);
+	of_node_put(port);
 	if (err) {
 		if (is_valid_ether_addr(rdev->etha->mac_addr))
 			eth_hw_addr_set(ndev, rdev->etha->mac_addr);
-- 
2.25.1

