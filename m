Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C8559A03
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiFXM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 08:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiFXM7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 08:59:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D95252B
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 05:59:14 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itu-00076I-Du; Fri, 24 Jun 2022 14:59:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itr-002Qlj-07; Fri, 24 Jun 2022 14:59:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itr-00H4PX-Lw; Fri, 24 Jun 2022 14:59:03 +0200
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
Subject: [PATCH net-next v1 1/3] net: dsa: add get_pause_stats support
Date:   Fri, 24 Jun 2022 14:59:00 +0200
Message-Id: <20220624125902.4068436-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

Add support for pause stats

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/dsa.h |  2 ++
 net/dsa/slave.c   | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..c8d7696cb2bf 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -890,6 +890,8 @@ struct dsa_switch_ops {
 				      struct ethtool_eth_ctrl_stats *ctrl_stats);
 	void	(*get_stats64)(struct dsa_switch *ds, int port,
 				   struct rtnl_link_stats64 *s);
+	void	(*get_pause_stats)(struct dsa_switch *ds, int port,
+				   struct ethtool_pause_stats *pause_stats);
 	void	(*self_test)(struct dsa_switch *ds, int port,
 			     struct ethtool_test *etest, u64 *data);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2e1ac638d135..b2710ee46644 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1097,6 +1097,16 @@ static int dsa_slave_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(dp->pl, cmd);
 }
 
+static void dsa_slave_get_pause_stats(struct net_device *dev,
+				  struct ethtool_pause_stats *pause_stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_pause_stats)
+		ds->ops->get_pause_stats(ds, dp->index, pause_stats);
+}
+
 static void dsa_slave_get_pauseparam(struct net_device *dev,
 				     struct ethtool_pauseparam *pause)
 {
@@ -2087,6 +2097,7 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_eee		= dsa_slave_get_eee,
 	.get_link_ksettings	= dsa_slave_get_link_ksettings,
 	.set_link_ksettings	= dsa_slave_set_link_ksettings,
+	.get_pause_stats	= dsa_slave_get_pause_stats,
 	.get_pauseparam		= dsa_slave_get_pauseparam,
 	.set_pauseparam		= dsa_slave_set_pauseparam,
 	.get_rxnfc		= dsa_slave_get_rxnfc,
-- 
2.30.2

