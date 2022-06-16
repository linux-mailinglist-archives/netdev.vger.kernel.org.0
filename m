Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA3054E00D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376620AbiFPLbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359848AbiFPLbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:31:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53D65E154
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:31:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1niO-0005OA-D9; Thu, 16 Jun 2022 13:31:08 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1niL-000rJC-SJ; Thu, 16 Jun 2022 13:31:07 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1niM-003jdk-Md; Thu, 16 Jun 2022 13:31:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: phy: at803x: fix NULL pointer dereference on AR9331 PHY
Date:   Thu, 16 Jun 2022 13:31:05 +0200
Message-Id: <20220616113105.890373-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Latest kernel will explode on the PHY interrupt config, since it depends
now on allocated priv. So, run probe to allocate priv to fix it.

 ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
 CPU 0 Unable to handle kernel paging request at virtual address 0000000a, epc == 8050e8a8, ra == 80504b34
         ...
 Call Trace:
 [<8050e8a8>] at803x_config_intr+0x5c/0xd0
 [<80504b34>] phy_request_interrupt+0xa8/0xd0
 [<8050289c>] phylink_bringup_phy+0x2d8/0x3ac
 [<80502b68>] phylink_fwnode_phy_connect+0x118/0x130
 [<8074d8ec>] dsa_slave_create+0x270/0x420
 [<80743b04>] dsa_port_setup+0x12c/0x148
 [<8074580c>] dsa_register_switch+0xaf0/0xcc0
 [<80511344>] ar9331_sw_probe+0x370/0x388
 [<8050cb78>] mdio_probe+0x44/0x70
 [<804df300>] really_probe+0x200/0x424
 [<804df7b4>] __driver_probe_device+0x290/0x298
 [<804df810>] driver_probe_device+0x54/0xe4
 [<804dfd50>] __device_attach_driver+0xe4/0x130
 [<804dcb00>] bus_for_each_drv+0xb4/0xd8
 [<804dfac4>] __device_attach+0x104/0x1a4
 [<804ddd24>] bus_probe_device+0x48/0xc4
 [<804deb44>] deferred_probe_work_func+0xf0/0x10c
 [<800a0ffc>] process_one_work+0x314/0x4d4
 [<800a17fc>] worker_thread+0x2a4/0x354
 [<800a9a54>] kthread+0x134/0x13c
 [<8006306c>] ret_from_kernel_thread+0x14/0x1c

Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 6a467e7817a6..b72a807f2e03 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2072,6 +2072,8 @@ static struct phy_driver at803x_driver[] = {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
-- 
2.30.2

