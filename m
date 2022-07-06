Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE5567F47
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiGFHCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiGFHCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:02:25 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE3520F75;
        Wed,  6 Jul 2022 00:02:22 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 26672D1o130006;
        Wed, 6 Jul 2022 02:02:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1657090933;
        bh=jCdj0h7QAmp7j0F9vvlvaFSLwy3D0Xt0WBUaK75CTSw=;
        h=From:To:CC:Subject:Date;
        b=Hp6X7OemNztT4azjbZnCzYTwq7/DxGjLKZTmzP0jzp5p4xK8iJCANhhV/+SLS6g68
         f9T1waR5j8VvxiJ/el6CeAQA8ZKVhWUqTgGF4+/QQU++EF8zlBdpP1WwcVNonz4ocP
         2fkzWfRI0lwLpLGzfS5aYUPYLPdZlH9aVAm4Req0=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 26672DnT116700
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Jul 2022 02:02:13 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Jul 2022 02:02:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Jul 2022 02:02:13 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 266728j5113804;
        Wed, 6 Jul 2022 02:02:09 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net v3] net: ethernet: ti: am65-cpsw: Fix devlink port register sequence
Date:   Wed, 6 Jul 2022 12:32:08 +0530
Message-ID: <20220706070208.12207-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Renaming interfaces using udevd depends on the interface being registered
before its netdev is registered. Otherwise, udevd reads an empty
phys_port_name value, resulting in the interface not being renamed.

Fix this by registering the interface before registering its netdev
by invoking am65_cpsw_nuss_register_devlink() before invoking
register_netdev() for the interface.

Move the function call to devlink_port_type_eth_set(), invoking it after
register_netdev() is invoked, to ensure that netlink notification for the
port state change is generated after the netdev is completely initialized.

Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
Changelog:
v2 -> v3:
1. Add error handling to unregister devlink.

v1-> v2:
1. Add Fixes tag in commit message.
2. Update patch subject to include "net".
3. Invoke devlink_port_type_eth_set() after register_netdev() is called.
4. Update commit message describing the cause for moving the call to
   devlink_port_type_eth_set().

v2: https://lore.kernel.org/r/20220704073040.7542-1-s-vadapalli@ti.com/
v1: https://lore.kernel.org/r/20220623044337.6179-1-s-vadapalli@ti.com/

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fb92d4c1547d..f4a6b590a1e3 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2467,7 +2467,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 				port->port_id, ret);
 			goto dl_port_unreg;
 		}
-		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 	devlink_register(common->devlink);
 	return ret;
@@ -2511,6 +2510,7 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
+	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
@@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		return ret;
 	}
 
+	ret = am65_cpsw_nuss_register_devlink(common);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 
@@ -2539,25 +2543,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 				i, ret);
 			goto err_cleanup_ndev;
 		}
+
+		dl_port = &port->devlink_port;
+		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 
 	ret = am65_cpsw_register_notifiers(common);
 	if (ret)
 		goto err_cleanup_ndev;
 
-	ret = am65_cpsw_nuss_register_devlink(common);
-	if (ret)
-		goto clean_unregister_notifiers;
-
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
 
 	return 0;
-clean_unregister_notifiers:
-	am65_cpsw_unregister_notifiers(common);
+
 err_cleanup_ndev:
 	am65_cpsw_nuss_cleanup_ndev(common);
+	am65_cpsw_unregister_devlink(common);
 
 	return ret;
 }
-- 
2.36.1

