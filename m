Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AD7637609
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiKXKPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKXKPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:15:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DB0C053D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:15:14 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9G4-0004Ig-1z; Thu, 24 Nov 2022 11:15:04 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9G0-0000ja-Fi; Thu, 24 Nov 2022 11:15:01 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9Fz-00E4X7-Nb; Thu, 24 Nov 2022 11:14:59 +0100
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
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA configurations to one location
Date:   Thu, 24 Nov 2022 11:14:58 +0100
Message-Id: <20221124101458.3353902-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124101458.3353902-1-o.rempel@pengutronix.de>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
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

To make the code more comparable to KSZ9477 code, move DSA
configurations to the same location.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 060e41b9b6ef..003b0ac2854c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1359,6 +1359,16 @@ int ksz8_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	/* We rely on software untagging on the CPU port, so that we
+	 * can support both tagged and untagged VLANs
+	 */
+	ds->untag_bridge_pvid = true;
+
+	/* VLAN filtering is partly controlled by the global VLAN
+	 * Enable flag
+	 */
+	ds->vlan_filtering_is_global = true;
+
 	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
 
 	/* Enable automatic fast aging when link changed detected. */
@@ -1418,16 +1428,6 @@ int ksz8_switch_init(struct ksz_device *dev)
 	dev->phy_port_cnt = dev->info->port_cnt - 1;
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
-	/* We rely on software untagging on the CPU port, so that we
-	 * can support both tagged and untagged VLANs
-	 */
-	dev->ds->untag_bridge_pvid = true;
-
-	/* VLAN filtering is partly controlled by the global VLAN
-	 * Enable flag
-	 */
-	dev->ds->vlan_filtering_is_global = true;
-
 	return 0;
 }
 
-- 
2.30.2

