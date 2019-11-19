Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399BB102F32
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfKSWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:20:54 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34586 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfKSWTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:41 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJYh2027141;
        Tue, 19 Nov 2019 16:19:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201974;
        bh=/4y19dJx1gaflymlDG1b6ajtK/Qq04Ckzb/q/Njpdjc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=hvbAVFnZGW468r8yJGJEs4Bwl0r7ALuATRQkdxiSas4Lk9qnCCpk7qeHN0p5H9qWR
         eI2qvpe+54IIxrXwEDhrVbOP6Y3yCBdNQqm9P8pM69P5Er4Twx4kXriY0blX4U02Za
         sdTYiM/TiyI3CH8Z/31jy9OGO2sgExlXdJCvpRv4=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJYTd034319;
        Tue, 19 Nov 2019 16:19:34 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:34 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:34 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJX0k055022;
        Tue, 19 Nov 2019 16:19:33 -0600
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
Subject: [PATCH v7 net-next 04/13] net: ethernet: ti: cpsw: resolve build deps of cpsw drivers
Date:   Wed, 20 Nov 2019 00:19:16 +0200
Message-ID: <20191119221925.28426-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
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
index 15a76d3842c5..225e5351752a 100644
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
 
@@ -2774,6 +2785,8 @@ static int cpsw_probe(struct platform_device *pdev)
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
index 8bfa761fa552..65f0e410344d 100644
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

