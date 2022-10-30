Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6203B612D0C
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJ3Vca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJ3VcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 17:32:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363D3A1A0;
        Sun, 30 Oct 2022 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667165523; x=1698701523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7uVV0RJ6uV+MAOV6JlyV47tQ54stPcJ90GshRDd7Jk=;
  b=mru/HGiNDdCRAY2bQ6YgL6XaHLUeccM3jbTHVXkgldzPx3szt6LHVSP3
   tIDTWnX3VV7D/Ro4EVsqCPeRh/yZfq1Jky7VbFQCmCQb86gMsy1UAOKXy
   MtaYbqqpVKS0/le7QCDd0FoBLOwv1xeDytcZnJ9X04v9oaPnU0KoTgwSc
   lzvg+DwO9nZfWhkaG0qav3ncwR5lJTLz1/tD4Ac3DjsJQjFX2hI7BSoSG
   f1bahWDfVWvcpktCdbbBcULiQKG4Xa3nYQiPItl77mLc11Ntda5CZds40
   G546zLB0cQ6o3daToTRkgjq1tIP3+AHLmiov8udXv1HdjQQw/vVRmfdp2
   w==;
X-IronPort-AV: E=Sophos;i="5.95,226,1661842800"; 
   d="scan'208";a="184552393"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 14:32:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 14:32:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 30 Oct 2022 14:31:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 2/3] net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
Date:   Sun, 30 Oct 2022 22:36:35 +0100
Message-ID: <20221030213636.1031408-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When vlan filtering is enabled/disabled, it is required to adjust the
maximum received frame size that it can received. When vlan filtering is
enabled, it would all to receive extra 4 bytes, that are the vlan tag.
So the maximum frame size would be 1522 with a vlan tag. If vlan
filtering is disabled then the maximum frame size would be 1518
regardless if there is or not a vlan tag.

Fixes: 6d2c186afa5d ("net: lan966x: Add vlan support.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_regs.h | 15 +++++++++++++++
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 1d90b93dd417a..fb5087fef22e1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -585,6 +585,21 @@ enum lan966x_target {
 #define DEV_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
 	FIELD_GET(DEV_MAC_MAXLEN_CFG_MAX_LEN, x)
 
+/*      DEV:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV_MAC_TAGS_CFG(t)       __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 12, 0, 1, 4)
+
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA        BIT(1)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA, x)
+#define DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA, x)
+
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA            BIT(0)
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+#define DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+
 /*      DEV:MAC_CFG_STATUS:MAC_IFG_CFG */
 #define DEV_MAC_IFG_CFG(t)        __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 20, 0, 1, 4)
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
index 8d7260cd7da9c..3c44660128dae 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
@@ -169,6 +169,12 @@ void lan966x_vlan_port_apply(struct lan966x_port *port)
 		ANA_VLAN_CFG_VLAN_POP_CNT,
 		lan966x, ANA_VLAN_CFG(port->chip_port));
 
+	lan_rmw(DEV_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(port->vlan_aware) |
+		DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA_SET(port->vlan_aware),
+		DEV_MAC_TAGS_CFG_VLAN_AWR_ENA |
+		DEV_MAC_TAGS_CFG_VLAN_DBL_AWR_ENA,
+		lan966x, DEV_MAC_TAGS_CFG(port->chip_port));
+
 	/* Drop frames with multicast source address */
 	val = ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(1);
 	if (port->vlan_aware && !pvid)
-- 
2.38.0

