Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7227FDC4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgJAKxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:53:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34032 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732140AbgJAKxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:20 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091ArG63097906;
        Thu, 1 Oct 2020 05:53:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549596;
        bh=sfVSy3wFshS7WUEetG2Lmid4ylQ0Anrwk4S6rC/wAkE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=hrFww0B5hnMjXFEextXiQDs9z3SBVRTARm0KnDZPxONyzronLBAda1I0a+0emezIG
         IDP/r+fYPZGtTJ5de4OrzsguTFaQxuYnCV+EclBgwuG+diKbUtBq37f1P6TU5npfal
         EXYGrS4XecjPFx9K7arbXwXxl+1ZmN1RKUNkTaVY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091ArGHZ130234
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:16 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:16 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:16 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091ArF4s129707;
        Thu, 1 Oct 2020 05:53:15 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 2/8] net: ethernet: ti: am65-cpsw: move free desc queue mode selection in pdata
Date:   Thu, 1 Oct 2020 13:52:52 +0300
Message-ID: <20201001105258.2139-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of adding more multi-port K3 CPSW versions move free
descriptor queue mode selection in am65_cpsw_pdata, so it can be selected
basing on DT compatibility property.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0ee1c7a5c90f..6cea338df7ad 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1606,7 +1606,6 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		};
 		struct k3_ring_cfg fdqring_cfg = {
 			.elm_size = K3_RINGACC_RING_ELSIZE_8,
-			.mode = K3_RINGACC_RING_MODE_MESSAGE,
 			.flags = K3_RINGACC_RING_SHARED,
 		};
 		struct k3_udma_glue_rx_flow_cfg rx_flow_cfg = {
@@ -1620,6 +1619,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		rx_flow_cfg.ring_rxfdq0_id = fdqring_id;
 		rx_flow_cfg.rx_cfg.size = max_desc_num;
 		rx_flow_cfg.rxfdq_cfg.size = max_desc_num;
+		rx_flow_cfg.rxfdq_cfg.mode = common->pdata.fdqring_mode;
 
 		ret = k3_udma_glue_rx_flow_init(rx_chn->rx_chn,
 						i, &rx_flow_cfg);
@@ -2006,11 +2006,13 @@ static const struct soc_device_attribute am65_cpsw_socinfo[] = {
 static const struct am65_cpsw_pdata am65x_sr1_0 = {
 	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
 	.ale_dev_id = "am65x-cpsw2g",
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
 };
 
 static const struct am65_cpsw_pdata j721e_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am65x-cpsw2g",
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 9c2186b8eae9..b6f228ddc3a0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/soc/ti/k3-ringacc.h>
 #include "am65-cpsw-qos.h"
 
 struct am65_cpts;
@@ -77,6 +78,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	enum k3_ring_mode fdqring_mode;
 	const char	*ale_dev_id;
 };
 
-- 
2.17.1

