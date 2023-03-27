Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C236CA775
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjC0OYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjC0OXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:23:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8F7EC9
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hq-Kw; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjZ-0076If-Bh; Mon, 27 Mar 2023 16:22:05 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00Fkjl-VA; Mon, 27 Mar 2023 16:22:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 8/8] net: fec: Indicate EEE (LPI) support for some FEC Ethernet controllers
Date:   Mon, 27 Mar 2023 16:22:02 +0200
Message-Id: <20230327142202.3754446-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230327142202.3754446-1-o.rempel@pengutronix.de>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds EEE (LPI) support indication for specific FEC Ethernet
controllers. By indicating EEE support for these controllers, it allows
PHY drivers to choose the right configuration for EEE and LPI features,
depending on whether the MAC or the PHY is responsible for handling them.

This change provides more flexibility and control over energy-saving
features, enabling PHY drivers to disable SmartEEE functionality in favor
of MAC EEE support when appropriate, depending on their specific use cases
and requirements.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f3b16a6673e2..554a5dc92817 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2318,6 +2318,8 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
+	if (fep->quirks & FEC_QUIRK_HAS_EEE)
+		phy_dev->mac_supports_eee = true;
 	phy_dev->mac_managed_pm = true;
 
 	phy_attached_info(phy_dev);
-- 
2.30.2

