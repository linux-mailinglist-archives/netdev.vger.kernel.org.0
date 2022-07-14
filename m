Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2DC5755DE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbiGNThE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiGNThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:37:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365805885D;
        Thu, 14 Jul 2022 12:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827419; x=1689363419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4rF/yuL+ZN9c5eOj3OIsnL8kWn7pgcEhED0vM6p8gv0=;
  b=SufXYf3RxK3ONsxpN3fkm2ya6xUxs9dDDnXtEIcKLQfvEO2jOWIFMXBL
   ORdh+LouKVZwsRVmzpDvW5m3Jzf5mFlkEsb4vk2fHFGTlmPhIPHZ8e8Oz
   q6xlUYq6RZJ63CqXc6j852K8g6KsusBtWp8/L4LVnbCk4l2ma8smZAOZ6
   PhM9eLjtaoSQ7JmcQm+b5RiHRr6syA+K0blMlYajU12mswmcgxwIFh/Df
   H8/ZLAiJIJaTVKHmwO1/JlynX38gi3vrfR2qz67+6UhIFGUsCis3rNEli
   OTbwO3KNgdAqDgM9QcxEd6d46km8nPBg1Bd45ti+DwO6kpgDiG7GweJcy
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="167895544"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:36:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:36:56 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:36:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/5] net: lan966x: Fix taking rtnl_lock while holding spin_lock
Date:   Thu, 14 Jul 2022 21:40:36 +0200
Message-ID: <20220714194040.231651-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220714194040.231651-1-horatiu.vultur@microchip.com>
References: <20220714194040.231651-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the HW deletes an entry in MAC table then it generates an
interrupt. The SW will go through it's own list of MAC entries and if it
is not found then it would notify the listeners about this. The problem
is that when the SW will go through it's own list it would take a spin
lock(lan966x->mac_lock) and when it notifies that the entry is deleted.
But to notify the listeners it taking the rtnl_lock which is illegal.

This is fixed by instead of notifying right away that the entry is
deleted, move the entry on a temp list and once, it checks all the
entries then just notify that the entries from temp list are deleted.

Fixes: 5ccd66e01cbe ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 005e56ea5da1..2d2b83c03796 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -325,10 +325,13 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 {
 	struct lan966x_mac_entry *mac_entry, *tmp;
 	unsigned char mac[ETH_ALEN] __aligned(2);
+	struct list_head mac_deleted_entries;
 	u32 dest_idx;
 	u32 column;
 	u16 vid;
 
+	INIT_LIST_HEAD(&mac_deleted_entries);
+
 	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries, list) {
 		bool found = false;
@@ -362,20 +365,26 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		}
 
 		if (!found) {
-			/* Notify the bridge that the entry doesn't exist
-			 * anymore in the HW and remove the entry from the SW
-			 * list
-			 */
-			lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
-					      mac_entry->mac, mac_entry->vid,
-					      lan966x->ports[mac_entry->port_index]->dev);
-
 			list_del(&mac_entry->list);
-			kfree(mac_entry);
+			/* Move the entry from SW list to a tmp list such that
+			 * it would be deleted later
+			 */
+			list_add_tail(&mac_entry->list, &mac_deleted_entries);
 		}
 	}
 	spin_unlock(&lan966x->mac_lock);
 
+	list_for_each_entry_safe(mac_entry, tmp, &mac_deleted_entries, list) {
+		/* Notify the bridge that the entry doesn't exist
+		 * anymore in the HW
+		 */
+		lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+				      mac_entry->mac, mac_entry->vid,
+				      lan966x->ports[mac_entry->port_index]->dev);
+		list_del(&mac_entry->list);
+		kfree(mac_entry);
+	}
+
 	/* Now go to the list of columns and see if any entry was not in the SW
 	 * list, then that means that the entry is new so it needs to notify the
 	 * bridge.
-- 
2.33.0

