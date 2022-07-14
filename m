Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868595755E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiGNTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiGNThH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:37:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63E15B7BC;
        Thu, 14 Jul 2022 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827426; x=1689363426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRkeUA7nUyp6MBOLYZsbd9fe58Z7+F2FRtQJMWV8HOU=;
  b=Fnll+vtKGwtodPfpxBzpJ8GmkYY78B7wB1jLlSTmp1WQew9IVUAuaWYG
   lZkHhdpCk+0onNsRWeDBTTFkcR+CdumX5eV37mUBNk5IKyWRRc6dTX+DJ
   MAffZWYWsNwHbiItBRUx0pMZdoapoAt26k1StereYt9xEZveL0WVBu1wV
   za0ecWKIdp/hAOWTkwBHRMJHuioZ83RF6ODJRQ5CPmO6el+AdtmUf331T
   qhiikOA8/QC/N3hecpx91NZef9hM7CsccM3VM8ggWbumgN8mwFB6I9GHm
   shffgg+RwQGjmgSTG4BozrkBHqlqYb5799IZGk9IGow1dpHVXLgMpXTls
   g==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="167895581"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:37:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:37:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:37:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 5/5] net: lan966x: Fix usage of lan966x->mac_lock when used by FDB
Date:   Thu, 14 Jul 2022 21:40:40 +0200
Message-ID: <20220714194040.231651-6-horatiu.vultur@microchip.com>
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

When the SW bridge was trying to add/remove entries to/from HW, the
access to HW was not protected by any lock. In this way, it was
possible to have race conditions.
Fix this by using the lan966x->mac_lock to protect parallel access to HW
for this cases.

Fixes: 25ee9561ec622 ("net: lan966x: More MAC table functionality")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 69e343b7f4af..5893770bfd94 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -201,7 +201,6 @@ static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
 	struct lan966x_mac_entry *res = NULL;
 	struct lan966x_mac_entry *mac_entry;
 
-	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry(mac_entry, &lan966x->mac_entries, list) {
 		if (mac_entry->vid == vid &&
 		    ether_addr_equal(mac, mac_entry->mac) &&
@@ -210,7 +209,6 @@ static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
 			break;
 		}
 	}
-	spin_unlock(&lan966x->mac_lock);
 
 	return res;
 }
@@ -253,8 +251,11 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 {
 	struct lan966x_mac_entry *mac_entry;
 
-	if (lan966x_mac_lookup(lan966x, addr, vid, ENTRYTYPE_NORMAL))
+	spin_lock(&lan966x->mac_lock);
+	if (lan966x_mac_lookup(lan966x, addr, vid, ENTRYTYPE_NORMAL)) {
+		spin_unlock(&lan966x->mac_lock);
 		return 0;
+	}
 
 	/* In case the entry already exists, don't add it again to SW,
 	 * just update HW, but we need to look in the actual HW because
@@ -263,21 +264,25 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 	 * add the entry but without the extern_learn flag.
 	 */
 	mac_entry = lan966x_mac_find_entry(lan966x, addr, vid, port->chip_port);
-	if (mac_entry)
-		return lan966x_mac_learn(lan966x, port->chip_port,
-					 addr, vid, ENTRYTYPE_LOCKED);
+	if (mac_entry) {
+		spin_unlock(&lan966x->mac_lock);
+		goto mac_learn;
+	}
 
 	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
-	if (!mac_entry)
+	if (!mac_entry) {
+		spin_unlock(&lan966x->mac_lock);
 		return -ENOMEM;
+	}
 
-	spin_lock(&lan966x->mac_lock);
 	list_add_tail(&mac_entry->list, &lan966x->mac_entries);
 	spin_unlock(&lan966x->mac_lock);
 
-	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
 	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid, port->dev);
 
+mac_learn:
+	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
+
 	return 0;
 }
 
@@ -291,8 +296,9 @@ int lan966x_mac_del_entry(struct lan966x *lan966x, const unsigned char *addr,
 				 list) {
 		if (mac_entry->vid == vid &&
 		    ether_addr_equal(addr, mac_entry->mac)) {
-			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
-					   ENTRYTYPE_LOCKED);
+			lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+						  mac_entry->vid,
+						  ENTRYTYPE_LOCKED);
 
 			list_del(&mac_entry->list);
 			kfree(mac_entry);
@@ -428,6 +434,12 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 			continue;
 
 		spin_lock(&lan966x->mac_lock);
+		mac_entry = lan966x_mac_find_entry(lan966x, mac, vid, dest_idx);
+		if (mac_entry) {
+			spin_unlock(&lan966x->mac_lock);
+			continue;
+		}
+
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
 		if (!mac_entry) {
 			spin_unlock(&lan966x->mac_lock);
-- 
2.33.0

