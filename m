Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB0B4B8C1E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiBPPL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:11:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiBPPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:11:27 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541BC2A64E2;
        Wed, 16 Feb 2022 07:11:14 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 7D3C115360;
        Wed, 16 Feb 2022 15:11:12 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 70471219C0A; Wed, 16 Feb 2022 15:11:12 +0000 (GMT)
From:   Mans Rullgard <mans@mansr.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: lan9303: add VLAN IDs to master device
Date:   Wed, 16 Feb 2022 15:11:11 +0000
Message-Id: <20220216151111.6376-1-mans@mansr.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the master device does VLAN filtering, the IDs used by the switch
must be added for any frames to be received.  Do this in the
port_enable() function, and remove them in port_disable().

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 drivers/net/dsa/lan9303-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 873a5588171b..f3bf642fbf92 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1084,20 +1084,32 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
 	struct lan9303 *chip = ds->priv;
+	struct dsa_port *cpu_dp;
 
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		break;
+
+	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	return lan9303_enable_processing_port(chip, port);
 }
 
 static void lan9303_port_disable(struct dsa_switch *ds, int port)
 {
 	struct lan9303 *chip = ds->priv;
+	struct dsa_port *cpu_dp;
 
 	if (!dsa_is_user_port(ds, port))
 		return;
 
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		break;
+
+	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
 }
-- 
2.35.1

