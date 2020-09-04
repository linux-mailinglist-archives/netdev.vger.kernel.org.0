Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036F025E3FA
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgIDXKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:10:03 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53122 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgIDXJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:09:58 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 084N9sBr003099;
        Fri, 4 Sep 2020 18:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599260995;
        bh=CTccfIY63VWBUNi2zgWrsuMJEQPMenQAMQYVYCKi1o4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=VkdztE0yiLiNFIcdTJb3FpeGnFkPhVvO0y6DALtrXVui7Ek+zV3MlAc1WofKA6Lz+
         +gjXYr9p5DGTKoaHJNSig14APO5jimz6OdUPye7XJu/49GwWTlu8Z1kiBZYhYblXxx
         zaNTO1JelV9jzTAlJZt7/WZ7w+n8nm6KUpnEbMRw=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 084N9s6J090740
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Sep 2020 18:09:54 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 4 Sep
 2020 18:09:54 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 4 Sep 2020 18:09:54 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 084N9rfF062310;
        Fri, 4 Sep 2020 18:09:54 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/9] net: ethernet: ti: cpsw: use dev_id for ale configuration
Date:   Sat, 5 Sep 2020 02:09:18 +0300
Message-ID: <20200904230924.9971-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904230924.9971-1-grygorii.strashko@ti.com>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
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
index 9b17bbbe102f..be5481e542bf 100644
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
index 1247d35d42ef..cb77e9c26de6 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1228,7 +1228,6 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 
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

