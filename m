Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021A45755DD
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbiGNThJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239389AbiGNThG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:37:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB64E5B062;
        Thu, 14 Jul 2022 12:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827425; x=1689363425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMYINw/bQBgU2dOHC2a0xTGgk9HFADbiVbCZ7qS5ZKE=;
  b=y/bVxvpVUonJbVYhlSHYyyj1a2A/Px0iVpAmCIbyzuJ7uBeetBAZlMAk
   xzDkHHUFSOxAxxYwLPGt8IQf074KAYwRIW6S6r4KByWd1Ajp749c6Gn9z
   XQZhqhvJXOpWURpAW3phv4eT55UZGKfldYZ6tKGqnN0UxbinRkBx8A2Ja
   28E0U3YCXJhzhjVbbzLcgnoFFP4Sbe1yBIEVj4zc6vXA/Qsnxg++UZpp9
   qamMW3hXWkAeYBr/x000s+BtFhIIzJpSFwAuqg8pbNm3WgT6/rIrVl7p/
   lcHs0VOJnABneglYfcItsZHVid+0VW3I/mwyO7+SAqtLJJe9tSqOsizWx
   g==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="167895570"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:37:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:37:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:36:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 3/5] net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
Date:   Thu, 14 Jul 2022 21:40:38 +0200
Message-ID: <20220714194040.231651-4-horatiu.vultur@microchip.com>
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

To remove an entry to the MAC table, it is required first to setup the
entry and then issue a command for the MAC to forget the entry.
So if it happens for two threads to remove simultaneously an entry
in MAC table then it would be a race condition.
Fix this by using lan966x->mac_lock to protect the HW access.

Fixes: e18aba8941b40 ("net: lan966x: add mactable support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 4f8fd5cde950..d0b8eba0a66d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -119,11 +119,13 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
 }
 
-int lan966x_mac_forget(struct lan966x *lan966x,
-		       const unsigned char mac[ETH_ALEN],
-		       unsigned int vid,
-		       enum macaccess_entry_type type)
+static int lan966x_mac_forget_locked(struct lan966x *lan966x,
+				     const unsigned char mac[ETH_ALEN],
+				     unsigned int vid,
+				     enum macaccess_entry_type type)
 {
+	lockdep_assert_held(&lan966x->mac_lock);
+
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a forget command */
@@ -134,6 +136,20 @@ int lan966x_mac_forget(struct lan966x *lan966x,
 	return lan966x_mac_wait_for_completion(lan966x);
 }
 
+int lan966x_mac_forget(struct lan966x *lan966x,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid,
+		       enum macaccess_entry_type type)
+{
+	int ret;
+
+	spin_lock(&lan966x->mac_lock);
+	ret = lan966x_mac_forget_locked(lan966x, mac, vid, type);
+	spin_unlock(&lan966x->mac_lock);
+
+	return ret;
+}
+
 int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16 vid)
 {
 	return lan966x_mac_learn(lan966x, PGID_CPU, addr, vid, ENTRYTYPE_LOCKED);
-- 
2.33.0

