Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521D225FE31
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgIGOeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:34:18 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53906 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgIGOb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:31:56 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVph6015786;
        Mon, 7 Sep 2020 09:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489111;
        bh=zRevarR8bBHB46h6T67QBWgaS+xUykO9TW3TMcjN6qY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=n/aJ0Ev9k5KpVjrm1XYHHRkZjjThAGY1HI54EUx7sMTs6uztxiuwKE+A+NinfJwT1
         kaMTT0Pb74dJQiDQJ99eSeXKDc/ilGxPQJFh4iFYJd5HGGEE0L6pZ1WaErJ/rs85Gv
         9d8CsSw5ftKIsIde0kaeswuNV7crLXmT2TI/S4FU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 087EVpA4066777
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 09:31:51 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVo5r072974;
        Mon, 7 Sep 2020 09:31:50 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 3/9] net: ethernet: ti: cpsw: use dev_id for ale configuration
Date:   Mon, 7 Sep 2020 17:31:37 +0300
Message-ID: <20200907143143.13735-4-grygorii.strashko@ti.com>
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
ALE dev_id identifier. Switch TI cpsw driver to use dev_id="cpsw" and
perform clean up by removing "ale_entries" configuration code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c      | 6 ------
 drivers/net/ethernet/ti/cpsw_new.c  | 1 -
 drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.h | 2 --
 4 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 4a65edc5a375..9b425f184f3c 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1278,12 +1278,6 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 	}
 	data->channels = prop;
 
-	if (of_property_read_u32(node, "ale_entries", &prop)) {
-		dev_err(&pdev->dev, "Missing ale_entries property in the DT.\n");
-		return -EINVAL;
-	}
-	data->ale_entries = prop;
-
 	if (of_property_read_u32(node, "bd_ram_size", &prop)) {
 		dev_err(&pdev->dev, "Missing bd_ram_size property in the DT.\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 8ed78577cded..a3528c5c823f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1243,7 +1243,6 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 
 	data->active_slave = 0;
 	data->channels = CPSW_MAX_QUEUES;
-	data->ale_entries = CPSW_ALE_NUM_ENTRIES;
 	data->dual_emac = true;
 	data->bd_ram_size = CPSW_BD_RAM_SIZE;
 	data->mac_control = 0;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 482a1a451e43..51cc29f39038 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -500,8 +500,8 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 
 	ale_params.dev			= dev;
 	ale_params.ale_ageout		= ale_ageout;
-	ale_params.ale_entries		= data->ale_entries;
 	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
+	ale_params.dev_id		= "cpsw";
 
 	cpsw->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(cpsw->ale)) {
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index bf4e179b4ca4..7b7f3596b20d 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -117,7 +117,6 @@ do {								\
 #define CPSW_MAX_QUEUES		8
 #define CPSW_CPDMA_DESCS_POOL_SIZE_DEFAULT 256
 #define CPSW_ALE_AGEOUT_DEFAULT		10 /* sec */
-#define CPSW_ALE_NUM_ENTRIES		1024
 #define CPSW_FIFO_QUEUE_TYPE_SHIFT	16
 #define CPSW_FIFO_SHAPE_EN_SHIFT	16
 #define CPSW_FIFO_RATE_EN_SHIFT		20
@@ -294,7 +293,6 @@ struct cpsw_platform_data {
 	u32	channels;	/* number of cpdma channels (symmetric) */
 	u32	slaves;		/* number of slave cpgmac ports */
 	u32	active_slave;/* time stamping, ethtool and SIOCGMIIPHY slave */
-	u32	ale_entries;	/* ale table size */
 	u32	bd_ram_size;	/*buffer descriptor ram size */
 	u32	mac_control;	/* Mac control register */
 	u16	default_vlan;	/* Def VLAN for ALE lookup in VLAN aware mode*/
-- 
2.17.1

