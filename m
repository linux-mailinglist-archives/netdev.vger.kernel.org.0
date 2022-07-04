Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CEF5659FF
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiGDPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiGDPhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:37:12 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C3D101CE;
        Mon,  4 Jul 2022 08:37:11 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A857F22175;
        Mon,  4 Jul 2022 17:37:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656949029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=49jmyk6Kr/0yocNEo96l8pdLWi/9xTg3Yv6EvEmNyo0=;
        b=otp/j1cF3MyABLdiurF0KYWC8yr8LzLUZTdWmZ+hWcw/UHcaOd/LEDA8L8dEfSAn44D+we
        l67KQaQf6krAueaLTYQqQtQ6/9J9mJGMiWTrFcPAkhNWGHAlRsZYPRzqIjUzGgs9KqsGrd
        C7ZwngsCzBsgi8wK7lXGNbHqO0EZGvc=
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net v2] net: lan966x: hardcode the number of external ports
Date:   Mon,  4 Jul 2022 17:36:54 +0200
Message-Id: <20220704153654.1167886-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of counting the child nodes in the device tree, hardcode the
number of ports in the driver itself.  The counting won't work at all
if an ethernet port is marked as disabled, e.g. because it is not
connected on the board at all.

It turns out that the LAN9662 and LAN9668 use the same switching IP
with the same synthesis parameters. The only difference is that the
output ports are not connected. Thus, we can just hardcode the
number of physical ports to 8.

Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - add fixes tag since the fix is simple
 - switch from new specific compatible to "just use 8 for all"

 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 ++------
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 5784c4161e5e..1d6e3b641b2e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -994,7 +994,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	struct fwnode_handle *ports, *portnp;
 	struct lan966x *lan966x;
 	u8 mac_addr[ETH_ALEN];
-	int err, i;
+	int err;
 
 	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
 	if (!lan966x)
@@ -1025,11 +1025,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		return dev_err_probe(&pdev->dev, err, "Reset failed");
 
-	i = 0;
-	fwnode_for_each_available_child_node(ports, portnp)
-		++i;
-
-	lan966x->num_phys_ports = i;
+	lan966x->num_phys_ports = NUM_PHYS_PORTS;
 	lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
 				      sizeof(struct lan966x_port *),
 				      GFP_KERNEL);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 3b86ddddc756..2787055c1847 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -34,6 +34,7 @@
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
 
+#define NUM_PHYS_PORTS			8
 #define CPU_PORT			8
 
 /* Reserved PGIDs */
-- 
2.30.2

