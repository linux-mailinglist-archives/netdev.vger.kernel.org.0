Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F015755E3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240634AbiGNThY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239146AbiGNThH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:37:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64145B7B5;
        Thu, 14 Jul 2022 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827426; x=1689363426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s5rsVG+SCV9f0N6XxblugFs+wdieKaS+IT2HhD1Eask=;
  b=aSx6f9b9pUdZnBVPOW8pIhmZ4NKMAJYTuLMCe11UdfXYfDxG9BCysqWf
   3ZhLw4T/eRMvzwbukODdoxiWqLHyNKq3VEOFodCpVDdgDRJ/r7xFDD23R
   Fti/PL9e9dbYOOEtYSwXDdZYmegXHnYSz7mjMwQF+hMa6dGQ9qZxpPYwI
   YBUzxeoO0YC9Kp8T7SFCuBGiPMQ6fIAaHVzy2LwC3nwAQEgSREAMUQBmN
   yPA3A569UuNBDYa5avSPbf4zbl0wQVpd1iElJnX8dIlfnPDxLWAnyG6lc
   1wZg+cGYEIOJCwNgMWnutidNglZCLThX8xr7FzqCLJXUnHYctef4ej9TI
   g==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="167895576"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:37:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:37:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:37:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 4/5] net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler
Date:   Thu, 14 Jul 2022 21:40:39 +0200
Message-ID: <20220714194040.231651-5-horatiu.vultur@microchip.com>
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

The problem with this spin lock is that it was just protecting the list
of the MAC entries in SW and not also the access to the MAC entries in HW.
Because the access to HW is indirect, then it could happen to have race
conditions.
For example when SW introduced an entry in MAC table and the irq mac is
trying to read something from the MAC.
Update such that also the access to MAC entries in HW is protected by
this lock.

Fixes: 5ccd66e01cbef ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index d0b8eba0a66d..69e343b7f4af 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -183,7 +183,7 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
 {
 	struct lan966x_mac_entry *mac_entry;
 
-	mac_entry = kzalloc(sizeof(*mac_entry), GFP_KERNEL);
+	mac_entry = kzalloc(sizeof(*mac_entry), GFP_ATOMIC);
 	if (!mac_entry)
 		return NULL;
 
@@ -310,8 +310,8 @@ void lan966x_mac_purge_entries(struct lan966x *lan966x)
 	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
 				 list) {
-		lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
-				   ENTRYTYPE_LOCKED);
+		lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+					  mac_entry->vid, ENTRYTYPE_LOCKED);
 
 		list_del(&mac_entry->list);
 		kfree(mac_entry);
@@ -427,13 +427,14 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 			continue;
 
+		spin_lock(&lan966x->mac_lock);
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
-		if (!mac_entry)
+		if (!mac_entry) {
+			spin_unlock(&lan966x->mac_lock);
 			return;
+		}
 
 		mac_entry->row = row;
-
-		spin_lock(&lan966x->mac_lock);
 		list_add_tail(&mac_entry->list, &lan966x->mac_entries);
 		spin_unlock(&lan966x->mac_lock);
 
@@ -455,6 +456,7 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x)
 	       lan966x, ANA_MACTINDX);
 
 	while (1) {
+		spin_lock(&lan966x->mac_lock);
 		lan_rmw(ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_SYNC_GET_NEXT),
 			ANA_MACACCESS_MAC_TABLE_CMD,
 			lan966x, ANA_MACACCESS);
@@ -478,12 +480,15 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x)
 			stop = false;
 
 		if (column == LAN966X_MAC_COLUMNS - 1 &&
-		    index == 0 && stop)
+		    index == 0 && stop) {
+			spin_unlock(&lan966x->mac_lock);
 			break;
+		}
 
 		entry[column].mach = lan_rd(lan966x, ANA_MACHDATA);
 		entry[column].macl = lan_rd(lan966x, ANA_MACLDATA);
 		entry[column].maca = lan_rd(lan966x, ANA_MACACCESS);
+		spin_unlock(&lan966x->mac_lock);
 
 		/* Once all the columns are read process them */
 		if (column == LAN966X_MAC_COLUMNS - 1) {
-- 
2.33.0

