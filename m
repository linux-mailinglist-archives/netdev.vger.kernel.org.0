Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5091362DBFF
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiKQMwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbiKQMwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:52:45 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C965802B
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:52:41 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCfvP4vvzzRpLS;
        Thu, 17 Nov 2022 20:52:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 20:52:38 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <bjarni.jonasson@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <liujian56@huawei.com>
Subject: [PATCH net] net: sparx5: fix error handling in sparx5_port_open()
Date:   Thu, 17 Nov 2022 20:59:18 +0800
Message-ID: <20221117125918.203997-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If phylink_of_phy_connect() fails, the port should be disabled.
If sparx5_serdes_set()/phy_power_on() fails, the port should be
disabled and the phylink should be stopped and disconnected.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 19516ccad533..d078156581d5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -104,7 +104,7 @@ static int sparx5_port_open(struct net_device *ndev)
 	err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
 	if (err) {
 		netdev_err(ndev, "Could not attach to PHY\n");
-		return err;
+		goto err_connect;
 	}
 
 	phylink_start(port->phylink);
@@ -116,10 +116,20 @@ static int sparx5_port_open(struct net_device *ndev)
 			err = sparx5_serdes_set(port->sparx5, port, &port->conf);
 		else
 			err = phy_power_on(port->serdes);
-		if (err)
+		if (err) {
 			netdev_err(ndev, "%s failed\n", __func__);
+			goto out_power;
+		}
 	}
 
+	return 0;
+
+out_power:
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+err_connect:
+	sparx5_port_enable(port, false);
+
 	return err;
 }
 
-- 
2.17.1

