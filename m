Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9683A598224
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiHRLSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244383AbiHRLSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:18:39 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F93FA21;
        Thu, 18 Aug 2022 04:18:35 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oOdXb-0009d4-RR; Thu, 18 Aug 2022 14:18:23 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: cache port state for non-phylink ports too
Date:   Thu, 18 Aug 2022 14:18:21 +0300
Message-Id: <20220818111821.415972-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port event data must stored to port-state cache regardless of whether
the port uses phylink or not since this data is used by ethtool.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_main.c | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ede3e53b9790..3489b80ae0d6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -797,32 +797,30 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 
 		caching_dw = &port->cached_hw_stats.caching_dw;
 
-		if (port->phy_link) {
-			memset(&smac, 0, sizeof(smac));
-			smac.valid = true;
-			smac.oper = pevt->data.mac.oper;
-			if (smac.oper) {
-				smac.mode = pevt->data.mac.mode;
-				smac.speed = pevt->data.mac.speed;
-				smac.duplex = pevt->data.mac.duplex;
-				smac.fc = pevt->data.mac.fc;
-				smac.fec = pevt->data.mac.fec;
-				phylink_mac_change(port->phy_link, true);
-			} else {
-				phylink_mac_change(port->phy_link, false);
-			}
-			prestera_port_mac_state_cache_write(port, &smac);
+		memset(&smac, 0, sizeof(smac));
+		smac.valid = true;
+		smac.oper = pevt->data.mac.oper;
+		if (smac.oper) {
+			smac.mode = pevt->data.mac.mode;
+			smac.speed = pevt->data.mac.speed;
+			smac.duplex = pevt->data.mac.duplex;
+			smac.fc = pevt->data.mac.fc;
+			smac.fec = pevt->data.mac.fec;
 		}
+		prestera_port_mac_state_cache_write(port, &smac);
 
 		if (port->state_mac.oper) {
-			if (!port->phy_link)
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, true);
+			else
 				netif_carrier_on(port->dev);
 
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
-		} else if (netif_running(port->dev) &&
-			   netif_carrier_ok(port->dev)) {
-			if (!port->phy_link)
+		} else {
+			if (port->phy_link)
+				phylink_mac_change(port->phy_link, false);
+			else if (netif_running(port->dev) && netif_carrier_ok(port->dev))
 				netif_carrier_off(port->dev);
 
 			if (delayed_work_pending(caching_dw))
-- 
2.25.1

