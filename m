Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B476422AB
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiLEFXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiLEFWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:22:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BC95BB
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:22:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w4-0004GH-SC; Mon, 05 Dec 2022 06:22:36 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w2-002ONK-Kf; Mon, 05 Dec 2022 06:22:35 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w1-00BtK5-Ve; Mon, 05 Dec 2022 06:22:33 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v7 5/6] net: dsa: microchip: enable MTU normalization for KSZ8795 and KSZ9477 compatible switches
Date:   Mon,  5 Dec 2022 06:22:31 +0100
Message-Id: <20221205052232.2834166-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221205052232.2834166-1-o.rempel@pengutronix.de>
References: <20221205052232.2834166-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ8795 and KSZ9477 compatible series of switches use global max frame
size configuration register. So, enable MTU normalization for this reason.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 2 ++
 drivers/net/dsa/microchip/ksz9477.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index d01bfd609130..060e41b9b6ef 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1357,6 +1357,8 @@ int ksz8_setup(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	int i;
 
+	ds->mtu_enforcement_ingress = true;
+
 	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
 
 	/* Enable automatic fast aging when link changed detected. */
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f6e7968ab105..47b54ecf2c6f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1134,6 +1134,8 @@ int ksz9477_setup(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	int ret = 0;
 
+	ds->mtu_enforcement_ingress = true;
+
 	/* Required for port partitioning. */
 	ksz9477_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
 		      true);
-- 
2.30.2

