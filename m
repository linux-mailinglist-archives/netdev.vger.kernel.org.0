Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A6CE2E39
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405511AbfJXKJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:09:40 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56542 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733071AbfJXKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:09:39 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9OA9V8M113387;
        Thu, 24 Oct 2019 05:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571911771;
        bh=FwCjmq+ETDcyzWaaMXsKpxbe8Ixvy2fUuw59La/0axA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=iB3VVJM7xrQpMAUE+/GjShBSftaFZxfEc0LLEHEgHS3FJGzikXFsvi5qAITkXOO/J
         USCCtCQhB9MahdfDscQSnncgLxx0gVseWNIKO91J+rH6iWtuc8g9lL7nxXkwYBTaq5
         JvnSbMNQwGc4evVmazMyLfcrQO1FCyoB5wX1A+vw=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9OA9Ual122564
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Oct 2019 05:09:31 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 24
 Oct 2019 05:09:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 24 Oct 2019 05:09:20 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9OA9ThS019429;
        Thu, 24 Oct 2019 05:09:30 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v5 net-next 03/12] net: ethernet: ti: cpsw: resolve build deps of cpsw drivers
Date:   Thu, 24 Oct 2019 13:09:05 +0300
Message-ID: <20191024100914.16840-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024100914.16840-1-grygorii.strashko@ti.com>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A following patches introduce new CPSW switchdev driver which uses common
code with legacy CPSW driver. This will introduce build dependency between
CPSW switchdev and CPSW legacy drivers related to for_each_slave() and
cpsw_slave_index() - they can be compiled both, but only one of them will
be not functional depending in Kconfig settings due to duffrences in Slave
Ports indexes calculation.

To fix this make for_each_slave() local (it's used now only by legacy CPSW
driver) and convert cpsw_slave_index() to be a function pointer which is
assigned in probe. Driver to probe is defined by DT.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c      | 13 +++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.c |  2 ++
 drivers/net/ethernet/ti/cpsw_priv.h | 10 ++--------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 0c160f81c581..ccccc17ed739 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -87,6 +87,17 @@ MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
 #define CPSW_XDP_CONSUMED		1
 #define CPSW_XDP_PASS			0
 
+static int cpsw_slave_index_priv(struct cpsw_common *cpsw,
+				 struct cpsw_priv *priv)
+{
+	return cpsw->data.dual_emac ? priv->emac_port : cpsw->data.active_slave;
+}
+
+static int cpsw_get_slave_port(u32 slave_num)
+{
+	return slave_num + 1;
+}
+
 static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 				    __be16 proto, u16 vid);
 
@@ -2775,6 +2786,8 @@ static int cpsw_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, cpsw);
+	cpsw_slave_index = cpsw_slave_index_priv;
+
 	cpsw->dev = dev;
 
 	mode = devm_gpiod_get_array_optional(dev, "mode", GPIOD_OUT_LOW);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 476d050a022c..a1c83af64835 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -19,6 +19,8 @@
 #include "cpsw_sl.h"
 #include "davinci_cpdma.h"
 
+int (*cpsw_slave_index)(struct cpsw_common *cpsw, struct cpsw_priv *priv);
+
 int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 		     int ale_ageout, phys_addr_t desc_mem_phys,
 		     int descs_pool_size)
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 362c5a986869..957ff0aabfa4 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -373,14 +373,8 @@ struct cpsw_priv {
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
 #define napi_to_cpsw(napi)	container_of(napi, struct cpsw_common, napi)
 
-#define cpsw_slave_index(cpsw, priv)				\
-		((cpsw->data.dual_emac) ? priv->emac_port :	\
-		cpsw->data.active_slave)
-
-static inline int cpsw_get_slave_port(u32 slave_num)
-{
-	return slave_num + 1;
-}
+extern int (*cpsw_slave_index)(struct cpsw_common *cpsw,
+			       struct cpsw_priv *priv);
 
 struct addr_sync_ctx {
 	struct net_device *ndev;
-- 
2.17.1

