Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C411612D09
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 22:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJ3VcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 17:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJ3VcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 17:32:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037BFBC14;
        Sun, 30 Oct 2022 14:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667165519; x=1698701519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zO5TaBiovTLxzRxBjR6lBYtEuGdhCJDREHzQQ8LjDVE=;
  b=NjOSvK7hzg5A5oAhCAx1w838B65j+a2JTFnrJ7T6AkyWOZ3dAeAWRru/
   /mP0F5DoubZKvdeAk7ccTb1THV1n5lJ9t/W7Q96jW76AZYwKeVlNONicY
   XitKzp867eD6uKvkQLXKcy9ZuMynKRrqum4Gg9gjll7s4Y+U6V/1sa3qt
   p8+oceexqai4yGwU4sD5hxIA91PQoFU8xGVeqjTnWbuUYm9rTDqlamSjs
   JbZhfNO4ZX5iHiWCb0/oUhzd+wNFS7G/5hZ7aIxqPT3Ru2zjbz9TTUmiQ
   V2sl3sI16YVSRkAhEc5wdfCeQgpRz0RLdLQEXOhamNU87jnKmMOnq1F3w
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,226,1661842800"; 
   d="scan'208";a="186969029"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 14:31:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 14:31:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 30 Oct 2022 14:31:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 1/3] net: lan966x: Fix the MTU calculation
Date:   Sun, 30 Oct 2022 22:36:34 +0100
Message-ID: <20221030213636.1031408-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

