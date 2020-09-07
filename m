Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1300825FF04
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgIGQZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:25:59 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39198 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbgIGOcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:32:54 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVra6078584;
        Mon, 7 Sep 2020 09:31:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489113;
        bh=scvlOAiGSgD3OrgroUOlwub3qAe8XPMOn8s7uBm6JO0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IUhN0vEiH11b9Re0vTmNyQqM7u1/IrtzaKgTFGx0OkpWdU0vkGQ45Py52h+iRQADq
         DH933ZfhqUQT4EybXkV4+KKDGaiemBVJY40HaCIdO02Q8EgY/6oBmxKnb/uWi1zmsV
         FNvmbYaOcQv8Tdh5nBHStZQboW5Ha1lT8g0BAkwM=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 087EVrOO095432
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 09:31:53 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:52 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:52 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVpWP106437;
        Mon, 7 Sep 2020 09:31:52 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 4/9] net: netcp: ethss: use dev_id for ale configuration
Date:   Mon, 7 Sep 2020 17:31:38 +0300
Message-ID: <20200907143143.13735-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200907143143.13735-1-grygorii.strashko@ti.com>
References: <20200907143143.13735-1-grygorii.strashko@ti.com>
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

