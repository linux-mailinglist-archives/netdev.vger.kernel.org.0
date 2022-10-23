Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41456095A9
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiJWSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiJWSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:45:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51D5437DD;
        Sun, 23 Oct 2022 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666550716; x=1698086716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zO5TaBiovTLxzRxBjR6lBYtEuGdhCJDREHzQQ8LjDVE=;
  b=cQjek9DboSd3CIAfkP7V4o0RVhwkzdrVR0Yzv4B5v12J7P0afIljoyXY
   pasetWp6ZBQ37QXRid+unGuyG6iG99glQyJZnG+CDaIeu52P/A6riUbkb
   MFFaTMOX7B1dvHvgufnbS7dS7IWry+cfLEhwp8PVfTZNWVSv0BRVPnXqy
   kNCMDLbiHg5PeInXFsSTisD9GhwG4r3d/ygXJ3u+a3AAI8KZS9ixDNXdG
   t1Sm0hx2ZnzpY8AKQuyPz/uWrTEi9ESuG4SKicIlO0bSebipKbLn285bl
   MVG9tH8e8/EGCPHZUKH/SqHyN6iYVxMcFKoz5rJ6oTPIe5teIoEF35PDh
   w==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180146170"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Oct 2022 11:45:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 23 Oct 2022 11:45:13 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 23 Oct 2022 11:45:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/3] net: lan966x: Fix the MTU calculation
Date:   Sun, 23 Oct 2022 20:48:36 +0200
Message-ID: <20221023184838.4128061-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
References: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the MTU was changed, the lan966x didn't take in consideration
the L2 header and the FCS. So the HW was configured with a smaller
value than what was desired. Therefore the correct value to configure
the HW would be new_mtu + ETH_HLEN + ETH_FCS_LEN.
The vlan tag is not considered here, because at the time when the
blamed commit was added, there was no vlan filtering support. The
vlan fix will be part of the next patch.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index be2fd030cccbe..b3070c3fcad0a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -386,7 +386,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 	int old_mtu = dev->mtu;
 	int err;
 
-	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(new_mtu),
+	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(LAN966X_HW_MTU(new_mtu)),
 	       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 	dev->mtu = new_mtu;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 9656071b8289e..4ec33999e4df6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -26,6 +26,8 @@
 #define LAN966X_BUFFER_MEMORY		(160 * 1024)
 #define LAN966X_BUFFER_MIN_SZ		60
 
+#define LAN966X_HW_MTU(mtu)		((mtu) + ETH_HLEN + ETH_FCS_LEN)
+
 #define PGID_AGGR			64
 #define PGID_SRC			80
 #define PGID_ENTRIES			89
-- 
2.38.0

