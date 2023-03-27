Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E56CA77F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjC0OY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjC0OXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:23:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD788A62
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hi-L1; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjX-0076IH-SB; Mon, 27 Mar 2023 16:22:03 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00Fkj2-RP; Mon, 27 Mar 2023 16:22:02 +0200
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
Subject: [PATCH net-next v2 3/8] net: phy: Add mac_supports_eee variable for EEE support and LPI handling
Date:   Mon, 27 Mar 2023 16:21:57 +0200
Message-Id: <20230327142202.3754446-4-o.rempel@pengutronix.de>
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

This commit introduces a new variable, mac_supports_eee, to the PHY
layer. This variable is used to indicate if a MAC provides EEE support
or is responsible for Low Power Idle (LPI) handling. The
mac_supports_eee variable should be used in conjunction with
is_smart_eee_phy to make proper configuration decisions based on the
capabilities of both the PHY and MAC.

By adding the mac_supports_eee variable, PHY drivers and the PHYlib
framework can better coordinate EEE and LPI management between the PHY
and MAC.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/phy.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6622b59ab5a1..573ad3fc2bf7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -548,6 +548,7 @@ struct macsec_ops;
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @is_smart_eee_phy: Set true if PHY is a Smart EEE PHY
+ * @mac_supports_eee: Set true if MAC supports EEE
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  *
@@ -644,6 +645,7 @@ struct phy_device {
 	unsigned is_on_sfp_module:1;
 	unsigned mac_managed_pm:1;
 	unsigned is_smart_eee_phy:1;
+	unsigned mac_supports_eee:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.30.2

