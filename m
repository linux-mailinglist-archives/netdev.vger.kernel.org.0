Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982842650D6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIJUal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:30:41 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56040 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgIJU2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:28:40 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSYYC044031;
        Thu, 10 Sep 2020 15:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599769714;
        bh=scvlOAiGSgD3OrgroUOlwub3qAe8XPMOn8s7uBm6JO0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=XtekSim1nCZ7a+AgKxSLD32J5yTJrkhNe9/5DRobJHs4sBfV1KugUwIrn2ccrIH+r
         3j7cwTTeMT0bGMS1EXK8iVZPwWNWunJICkkPwFuqdINhgd8aOxZeXTMEsB8cxb7LbE
         oFypUk0W+7orWiB51mx9aB8DLXbGnf5UQBg32SPA=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AKSY2A046506
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:28:34 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 15:28:34 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 15:28:34 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSXvG066168;
        Thu, 10 Sep 2020 15:28:34 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 4/9] net: netcp: ethss: use dev_id for ale configuration
Date:   Thu, 10 Sep 2020 23:28:02 +0300
Message-ID: <20200910202807.17473-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910202807.17473-1-grygorii.strashko@ti.com>
References: <20200910202807.17473-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch has introduced possibility to select CPSW ALE by using
ALE dev_id identifier. Switch TI Keystone 2 NETCP driver to use dev_id and
perform clean up by removing "ale_entries" configuration code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 28093923a7fb..33c1592d5381 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -51,7 +51,6 @@
 #define GBE13_CPTS_OFFSET		0x500
 #define GBE13_ALE_OFFSET		0x600
 #define GBE13_HOST_PORT_NUM		0
-#define GBE13_NUM_ALE_ENTRIES		1024
 
 /* 1G Ethernet NU SS defines */
 #define GBENU_MODULE_NAME		"netcp-gbenu"
@@ -101,7 +100,6 @@
 #define XGBE10_ALE_OFFSET		0x700
 #define XGBE10_HW_STATS_OFFSET		0x800
 #define XGBE10_HOST_PORT_NUM		0
-#define XGBE10_NUM_ALE_ENTRIES		2048
 
 #define	GBE_TIMER_INTERVAL			(HZ / 2)
 
@@ -711,7 +709,6 @@ struct gbe_priv {
 	struct netcp_device		*netcp_device;
 	struct timer_list		timer;
 	u32				num_slaves;
-	u32				ale_entries;
 	u32				ale_ports;
 	bool				enable_ale;
 	u8				max_num_slaves;
@@ -3309,7 +3306,6 @@ static int set_xgbe_ethss10_priv(struct gbe_priv *gbe_dev,
 	gbe_dev->cpts_reg = gbe_dev->switch_regs + XGBE10_CPTS_OFFSET;
 	gbe_dev->ale_ports = gbe_dev->max_num_ports;
 	gbe_dev->host_port = XGBE10_HOST_PORT_NUM;
-	gbe_dev->ale_entries = XGBE10_NUM_ALE_ENTRIES;
 	gbe_dev->stats_en_mask = (1 << (gbe_dev->max_num_ports)) - 1;
 
 	/* Subsystem registers */
@@ -3433,7 +3429,6 @@ static int set_gbe_ethss14_priv(struct gbe_priv *gbe_dev,
 	gbe_dev->ale_reg = gbe_dev->switch_regs + GBE13_ALE_OFFSET;
 	gbe_dev->ale_ports = gbe_dev->max_num_ports;
 	gbe_dev->host_port = GBE13_HOST_PORT_NUM;
-	gbe_dev->ale_entries = GBE13_NUM_ALE_ENTRIES;
 	gbe_dev->stats_en_mask = GBE13_REG_VAL_STAT_ENABLE_ALL;
 
 	/* Subsystem registers */
@@ -3697,12 +3692,15 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 	ale_params.dev		= gbe_dev->dev;
 	ale_params.ale_regs	= gbe_dev->ale_reg;
 	ale_params.ale_ageout	= GBE_DEFAULT_ALE_AGEOUT;
-	ale_params.ale_entries	= gbe_dev->ale_entries;
 	ale_params.ale_ports	= gbe_dev->ale_ports;
-	if (IS_SS_ID_MU(gbe_dev)) {
-		ale_params.major_ver_mask = 0x7;
-		ale_params.nu_switch_ale = true;
-	}
+	ale_params.dev_id	= "cpsw";
+	if (IS_SS_ID_NU(gbe_dev))
+		ale_params.dev_id = "66ak2el";
+	else if (IS_SS_ID_2U(gbe_dev))
+		ale_params.dev_id = "66ak2g";
+	else if (IS_SS_ID_XGBE(gbe_dev))
+		ale_params.dev_id = "66ak2h-xgbe";
+
 	gbe_dev->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(gbe_dev->ale)) {
 		dev_err(gbe_dev->dev, "error initializing ale engine\n");
-- 
2.17.1

