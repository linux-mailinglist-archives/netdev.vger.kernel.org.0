Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C981668ECB1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjBHKTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjBHKTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:19:16 -0500
Received: from mta-64-226.siemens.flowmailer.net (mta-64-226.siemens.flowmailer.net [185.136.64.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FE246D48
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:18:54 -0800 (PST)
Received: by mta-64-226.siemens.flowmailer.net with ESMTPSA id 20230208101830e5888849101e191f9d
        for <netdev@vger.kernel.org>;
        Wed, 08 Feb 2023 11:18:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=alexander.sverdlin@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=DdYusduobJ13HWhQF+UdUBEQ0UHRjpMDPLY8cTdVg88=;
 b=Edx03IECZBGCQ4oOWyPMTKAM4ZeulP+1TlgNfLvV9qDHEpV91O65MgDJZbuUMFIPvZhKE9
 ByG70GgJEYVKiGvwqOOAmsLXR6rEXwc4iHb1kYIWOK1Ia2Rk6yJPBLxs2JJ242wES1kDQ/31
 lWbBsfUvOWXQVUpc9XwB11cfoD/Nc=;
From:   "A. Sverdlin" <alexander.sverdlin@siemens.com>
To:     Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@siemens.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Date:   Wed,  8 Feb 2023 11:18:20 +0100
Message-Id: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-456497:519-21489:flowmailer
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

In FEC_QUIRK_SINGLE_MDIO case, if fec1 has mdio subnode which is being
probe-deferred because of, for instance, reset-gpio, defer any consequtive
fec2+ probe, we don't want them to register DT-less MDIO bus, but to share
DT-aware MDIO bus from fec1.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 34 +++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2341597408d12..d4d6dc10dba71 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2301,14 +2301,13 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * mdio interface in board design, and need to be configured by
 	 * fec0 mii_bus.
 	 */
-	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
+	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO) {
 		/* fec1 uses fec0 mii_bus */
 		if (mii_cnt && fec0_mii_bus) {
 			fep->mii_bus = fec0_mii_bus;
 			mii_cnt++;
 			return 0;
 		}
-		return -ENOENT;
 	}
 
 	bus_freq = 2500000; /* 2.5MHz by default */
@@ -2319,6 +2318,37 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 							  "suppress-preamble");
 	}
 
+	while (!node) {
+		/* If we've got so far there is either no FEC node with mdio
+		 * subnode at all (in this case original behavior was to go on
+		 * and create an MDIO bus not related to any DT node), or there
+		 * is another FEC node with mdio subnode out there (in this case
+		 * we defer the probe until MDIO bus will be instantiated in the
+		 * context of its parent node.
+		 */
+		struct device_node *np, *cp;
+		const struct of_device_id *of_id = of_match_device(fec_dt_ids, &pdev->dev);
+
+		if (!of_id)
+			break;
+
+		/* Loop over nodes with same "compatible" as pdev has */
+		for_each_compatible_node(np, NULL, of_id->compatible) {
+			if (!of_device_is_available(np))
+				continue;
+
+			cp = of_get_child_by_name(np, "mdio");
+			if (cp) {
+				of_node_put(cp);
+				of_node_put(np);
+
+				return -EPROBE_DEFER;
+			}
+		}
+
+		break;
+	}
+
 	/*
 	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
 	 *
-- 
2.34.1

