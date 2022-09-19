Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC5B5BCF83
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiISOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiISOsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:48:35 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880962CE36
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 07:48:33 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:ed67:3be8:ebe5:696d])
        by baptiste.telenet-ops.be with bizsmtp
        id MqoW280040GZoLL01qoWqt; Mon, 19 Sep 2022 16:48:31 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oaI4T-005dKX-MD; Mon, 19 Sep 2022 16:48:29 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oaI4T-00GeKC-6I; Mon, 19 Sep 2022 16:48:29 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: sh_eth: Fix PHY state warning splat during system resume
Date:   Mon, 19 Sep 2022 16:48:28 +0200
Message-Id: <c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state"), a warning splat is printed during system
resume with Wake-on-LAN disabled:

	WARNING: CPU: 0 PID: 626 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xe4

As the Renesas SuperH Ethernet driver already calls phy_{stop,start}()
in its suspend/resume callbacks, it is sufficient to just mark the MAC
responsible for managing the power state of the PHY.

Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/renesas/sh_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 67ade78fb7671c4a..7fd8828d3a846169 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2029,6 +2029,8 @@ static int sh_eth_phy_init(struct net_device *ndev)
 	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT)
 		phy_set_max_speed(phydev, SPEED_100);
 
+	/* Indicate that the MAC is responsible for managing PHY PM */
+	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.25.1

