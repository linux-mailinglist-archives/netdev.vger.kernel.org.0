Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70D555D764
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbiF1IwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245342AbiF1IwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:52:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285C32F664
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:52:12 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o66x3-0003tS-2o; Tue, 28 Jun 2022 10:52:05 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66wy-003Aeu-Ng; Tue, 28 Jun 2022 10:52:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66x1-00As7C-Ep; Tue, 28 Jun 2022 10:52:03 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v2 4/4] net: dsa: microchip: count pause packets together will all other packets
Date:   Tue, 28 Jun 2022 10:51:55 +0200
Message-Id: <20220628085155.2591201-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628085155.2591201-1-o.rempel@pengutronix.de>
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switch is calculating tx/rx_bytes for all packets including pause.
So, include rx/tx_pause counter to rx/tx_packets to make tx/rx_bytes fit
to rx/tx_packets.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7c221ec331ee..f5ad9cd8eff5 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -598,8 +598,10 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 
 	spin_lock(&mib->stats64_lock);
 
-	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast;
-	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast;
+	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast +
+		raw->rx_pause;
+	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast +
+		raw->tx_pause;
 
 	/* HW counters are counting bytes + FCS which is not acceptable
 	 * for rtnl_link_stats64 interface
-- 
2.30.2

