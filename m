Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1C3799D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfFFQbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:31:35 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54172 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbfFFQbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:31:35 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GVKDX064586;
        Thu, 6 Jun 2019 11:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838680;
        bh=S48YHwd7VbL227WMm5WryGh9q4yCYlwCu31xqUVixwc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=bdAf3w+rjpWp1dbGo7vCQ/qYkjDPWpIGYmuyjppdi2/T83b/e/1UgRB7V5oDMDfUU
         03xpRbs4HonXwb7cyGhD0zZmdnby4Hnq5ibjFi8HI2+cXS8KE86+LFRGmFsGbTdyTU
         HyWrEQllzZTlvy/KB9ftknaW1hV2sJ4x+KYkYL5Y=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GVKI6082758
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:20 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:19 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GVIuB052685;
        Thu, 6 Jun 2019 11:31:19 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 03/10] net: ethernet: ti: netcp_ethss: add support for child cpts node
Date:   Thu, 6 Jun 2019 19:30:40 +0300
Message-ID: <20190606163047.31199-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to place CPTS properties in the child "cpts" DT node. For backward
compatibility - roll-back and read CPTS DT properties from parent node if
"cpts" node is not present.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index ec179700c184..2c1fac33136c 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3554,7 +3554,7 @@ static int set_gbenu_ethss_priv(struct gbe_priv *gbe_dev,
 static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 		     struct device_node *node, void **inst_priv)
 {
-	struct device_node *interfaces, *interface;
+	struct device_node *interfaces, *interface, *cpts_node;
 	struct device_node *secondary_ports;
 	struct cpsw_ale_params ale_params;
 	struct gbe_priv *gbe_dev;
@@ -3713,7 +3713,12 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 		dev_dbg(gbe_dev->dev, "Created a gbe ale engine\n");
 	}
 
-	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg, node);
+	cpts_node = of_get_child_by_name(node, "cpts");
+	if (!cpts_node)
+		cpts_node = of_node_get(node);
+
+	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg, cpts_node);
+	of_node_put(cpts_node);
 	if (IS_ENABLED(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
 		ret = PTR_ERR(gbe_dev->cpts);
 		goto free_sec_ports;
-- 
2.17.1

