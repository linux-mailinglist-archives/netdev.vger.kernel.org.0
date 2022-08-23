Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C728059E5E2
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbiHWPVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiHWPVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:21:23 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186FB1F1F6B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:45:35 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.bb.vodafone.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 69898801A9;
        Tue, 23 Aug 2022 12:43:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1661251439;
        bh=sj0KJJ+h/ewTR+e02FhOTBhRQ34TCte9WDf1nPYPsPc=;
        h=From:To:Cc:Subject:Date:From;
        b=pLtVEToRMptJZ7WZItRi1/KWRroa19y86/w2/c0iwb8Nkze6s2HxCptCCP/Nhuu/D
         pWg1XXuy8zBFxgQNJrNwi5AM3Mb5squjwC6VNPmS+jYlxoVEC57TtP0iKpHhgOf/a2
         Of/wXMcjC14xOnz9uhrENiux1ptqpfapSGCNeGnSwVS2oODIILi+gF9/6TcwUfCsPj
         RM45JrQSbORDeRuHOB47T49aEj06v6AByC4qwZaP+7XO+qSZKwK3rvLcRUAF6tqFHi
         dizzkVix2UtwCoAtlgOc6qo+naWnyeJsqj4+6Kya+hj5lBRuCcHvPnw6Yx6Y631JYa
         AZ7vdTOylRUNg==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] net: dsa: microchip: Support GMII on user ports
Date:   Tue, 23 Aug 2022 12:43:43 +0200
Message-Id: <20220823104343.6141-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user ports on KSZ879x indicate they are of GMII interface type instead
of INTERNAL interface type. Add GMII into the list of supported user port
interfaces to avoid the following failure on probe:

"
ksz8795-switch spi0.0 lan1 (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -EINVAL
ksz8795-switch spi0.0 lan1 (uninitialized): failed to connect to PHY: -EINVAL
ksz8795-switch spi0.0 lan1 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 0
"

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ed7d137cba994..4a77c8b0e664e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -803,9 +803,12 @@ static void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->supports_rgmii[port])
 		phy_interface_set_rgmii(config->supported_interfaces);
 
-	if (dev->info->internal_phy[port])
+	if (dev->info->internal_phy[port]) {
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+	}
 
 	if (dev->dev_ops->get_caps)
 		dev->dev_ops->get_caps(dev, port, config);
-- 
2.35.1

