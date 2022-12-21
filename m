Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084B1652D35
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiLUHSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiLUHSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:18:02 -0500
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C8420BF0
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:17:59 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 7tMQp7QGOyEjG7tMQpZrZE; Wed, 21 Dec 2022 08:17:57 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 21 Dec 2022 08:17:57 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Krzysztof Halasa <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] ixp4xx_eth: Fix an error handling path in ixp4xx_eth_probe()
Date:   Wed, 21 Dec 2022 08:17:52 +0100
Message-Id: <3ab37c3934c99066a124f99e73c0fc077fcb69b4.1671607040.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a successful ixp4xx_mdio_register() call, it
should be undone by a corresponding ixp4xx_mdio_remove().

Add the missing call in the error handling path, as already done in the
remove function.

Fixes: 2098c18d6cf6 ("IXP4xx: Add PHYLIB support to Ethernet driver.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 3b0c5f177447..007d68b385a5 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1490,8 +1490,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	netif_napi_add_weight(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id))))
-		return -EIO;
+	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
+		err = -EIO;
+		goto err_remove_mdio;
+	}
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
@@ -1530,6 +1532,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 err_free_mem:
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
+err_remove_mdio:
+	ixp4xx_mdio_remove();
 	return err;
 }
 
-- 
2.34.1

