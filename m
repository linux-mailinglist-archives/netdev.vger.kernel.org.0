Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D53597696
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbiHQTcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240979AbiHQTb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A64A4B14;
        Wed, 17 Aug 2022 12:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764686; x=1692300686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a1cVPRjpURJObGnztoWTyNOtI+9zky6nPdl5yAwgEHA=;
  b=aqRjajWVspJ0cmEYYwSvMoiuMEPEcEtcWVRdm32WR9NwECDfSYz2BdMm
   JmYIZE2IFY2DxpmFcaS6jX5JkIyAph23lH7euCIP4OBuOUWJCiVKyUEA4
   depjeClNMoRMa7pE7haJOtu6LzHw4PrVa0cC4bwRuk94anDGSHFs/TI2W
   55QmqWBr627iZMHRR7zCeOs0rjqmC1fsbrTeztNRFfGbgXVlgLtgIMkuI
   W2OS1gZUJCfLNTAhthw507ZG3Wi+jN73vkwf446UVQALibrw8yActXxE6
   lOuRNvB6IlXozD0lMuHZCB/KxStKnMsC8d4NhwAXfIsiEnp5r8PL0DCIX
   g==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176673769"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 5/8] net: lan966x: Extend lan966x_foreign_bridging_check
Date:   Wed, 17 Aug 2022 21:34:46 +0200
Message-ID: <20220817193449.1673002-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x_foreign_bridging_check to check also if the upper
interface is a lag device. Don't allow a lan966x port to be part of a
lag if it has foreign interfaces.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_switchdev.c     | 32 ++++++++++++++-----
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index d9b3ca5f6214..c4951eeb6636 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -326,23 +326,25 @@ static int lan966x_port_prechangeupper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
-static int lan966x_foreign_bridging_check(struct net_device *bridge,
+static int lan966x_foreign_bridging_check(struct net_device *upper,
+					  bool *has_foreign,
+					  bool *seen_lan966x,
 					  struct netlink_ext_ack *extack)
 {
 	struct lan966x *lan966x = NULL;
-	bool has_foreign = false;
 	struct net_device *dev;
 	struct list_head *iter;
 
-	if (!netif_is_bridge_master(bridge))
+	if (!netif_is_bridge_master(upper) &&
+	    !netif_is_lag_master(upper))
 		return 0;
 
-	netdev_for_each_lower_dev(bridge, dev, iter) {
+	netdev_for_each_lower_dev(upper, dev, iter) {
 		if (lan966x_netdevice_check(dev)) {
 			struct lan966x_port *port = netdev_priv(dev);
 
 			if (lan966x) {
-				/* Bridge already has at least one port of a
+				/* Upper already has at least one port of a
 				 * lan966x switch inside it, check that it's
 				 * the same instance of the driver.
 				 */
@@ -353,15 +355,24 @@ static int lan966x_foreign_bridging_check(struct net_device *bridge,
 				}
 			} else {
 				/* This is the first lan966x port inside this
-				 * bridge
+				 * upper device
 				 */
 				lan966x = port->lan966x;
+				*seen_lan966x = true;
 			}
+		} else if (netif_is_lag_master(dev)) {
+			/* Allow to have bond interfaces that have only lan966x
+			 * devices
+			 */
+			if (lan966x_foreign_bridging_check(dev, has_foreign,
+							   seen_lan966x,
+							   extack))
+				return -EINVAL;
 		} else {
-			has_foreign = true;
+			*has_foreign = true;
 		}
 
-		if (lan966x && has_foreign) {
+		if (*seen_lan966x && *has_foreign) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Bridging lan966x ports with foreign interfaces disallowed");
 			return -EINVAL;
@@ -374,7 +385,12 @@ static int lan966x_foreign_bridging_check(struct net_device *bridge,
 static int lan966x_bridge_check(struct net_device *dev,
 				struct netdev_notifier_changeupper_info *info)
 {
+	bool has_foreign = false;
+	bool seen_lan966x = false;
+
 	return lan966x_foreign_bridging_check(info->upper_dev,
+					      &has_foreign,
+					      &seen_lan966x,
 					      info->info.extack);
 }
 
-- 
2.33.0

