Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFA84C155B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbiBWOYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiBWOYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:24:39 -0500
Received: from mailserv1.kapsi.fi (mailserv1.kapsi.fi [IPv6:2001:67c:1be8::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02012B1A87;
        Wed, 23 Feb 2022 06:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ext.kapsi.fi; s=20161220; h=Subject:Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=alNyl1KfQO+V+SfyCQrXRZU0CihhZAB4Wnp96QyBXCk=; b=0IsdVDpsDh+adcMgpwSaRULTtn
        AzomItLdY/7BbevphqzhFBifn7pmtFalbvNVdPabj73MJSPouu7DgUTVKIHWwkEgT7yXikKTseuL/
        VfIlFeKdcUIfyPe9HqzR+WdGWd65/CIG6VzC1uqvsAXQWaZKtV7YyXvDlfMP7JeRKmdh2fKeJIoVV
        aGTQAEWTgY1MI1p8/dRBok006vVn67cZ34ZmBPYWeDK8g8TdLJ8u1TKebLvUiU1NNwabudXK2Kt4n
        hO2wPBh4imuGtc2emHPDRN1GVguuj+PxU12fP7Z3RirP8ssXl7KOM41wDuJ8N/yJcYRhOPBTC9Xh/
        EmfT6E/Q==;
Received: from 201-31-196-88.dyn.estpak.ee ([88.196.31.201]:56813 helo=localhost)
        by mailserv1.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <maukka@ext.kapsi.fi>)
        id 1nMsYm-0002Zi-Vl; Wed, 23 Feb 2022 16:24:07 +0200
Received: by localhost (sSMTP sendmail emulation); Wed, 23 Feb 2022 16:24:03 +0200
From:   Mauri Sandberg <maukka@ext.kapsi.fi>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauri Sandberg <maukka@ext.kapsi.fi>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Wed, 23 Feb 2022 16:23:37 +0200
Message-Id: <20220223142337.41757-1-maukka@ext.kapsi.fi>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221062441.2685-1-maukka@ext.kapsi.fi>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 88.196.31.201
X-SA-Exim-Mail-From: maukka@ext.kapsi.fi
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
Subject: [PATCH v2] net: mv643xx_eth: process retval from of_get_mac_address
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mailserv1.kapsi.fi)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obtaining a MAC address may be deferred in cases when the MAC is stored
in an NVMEM block, for example, and it may not be ready upon the first
retrieval attempt and return EPROBE_DEFER.

It is also possible that a port that does not rely on NVMEM has been
already created when getting the defer request. Thus, also the resources
allocated previously must be freed when doing a roll-back.

Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
Cc: Andrew Lunn <andrew@lunn.ch>
---
v1 -> v2
 - escalate all error values from of_get_mac_address()
 - move mv643xx_eth_shared_of_remove() before
   mv643xx_eth_shared_of_probe()
 - release all resources potentially allocated for previous port nodes
 - update commit title and message
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 24 +++++++++++++---------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 105247582684..143ca8be5eb5 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2704,6 +2704,16 @@ MODULE_DEVICE_TABLE(of, mv643xx_eth_shared_ids);
 
 static struct platform_device *port_platdev[3];
 
+static void mv643xx_eth_shared_of_remove(void)
+{
+	int n;
+
+	for (n = 0; n < 3; n++) {
+		platform_device_del(port_platdev[n]);
+		port_platdev[n] = NULL;
+	}
+}
+
 static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 					  struct device_node *pnp)
 {
@@ -2740,7 +2750,9 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	of_get_mac_address(pnp, ppd.mac_addr);
+	ret = of_get_mac_address(pnp, ppd.mac_addr);
+	if (ret)
+		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
@@ -2804,21 +2816,13 @@ static int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 		ret = mv643xx_eth_shared_of_add_port(pdev, pnp);
 		if (ret) {
 			of_node_put(pnp);
+			mv643xx_eth_shared_of_remove();
 			return ret;
 		}
 	}
 	return 0;
 }
 
-static void mv643xx_eth_shared_of_remove(void)
-{
-	int n;
-
-	for (n = 0; n < 3; n++) {
-		platform_device_del(port_platdev[n]);
-		port_platdev[n] = NULL;
-	}
-}
 #else
 static inline int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 {

base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.25.1

