Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C13E6B086C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjCHNTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjCHNSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:18:41 -0500
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C455D1602
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 05:15:26 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:614d:21b0:703:d0f9])
        by andre.telenet-ops.be with bizsmtp
        id VpFL2900M3mNwr401pFLRT; Wed, 08 Mar 2023 14:15:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pZtd0-00BF13-Ah;
        Wed, 08 Mar 2023 14:15:20 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pZtTX-00FVfK-Uu;
        Wed, 08 Mar 2023 14:04:59 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v3] net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
Date:   Wed,  8 Mar 2023 14:04:52 +0100
Message-Id: <01605ea233ff7fc09bb0ea34fc8126af73db83f9.1678280599.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new devm_of_phy_optional_get() helper instead of open-coding the
same operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
v3:
  - Add Reviewed-by,

v2:
  - Rebase on top of commit 854617f52ab42418 ("net: ethernet: ti:
    am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in net-next
    (next-20230123 and later).
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4e3861c47708c9e2..25996826edabc019 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1470,11 +1470,9 @@ static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *por
 	struct phy *phy;
 	int ret;
 
-	phy = devm_of_phy_get(dev, port_np, name);
-	if (PTR_ERR(phy) == -ENODEV)
-		return 0;
-	if (IS_ERR(phy))
-		return PTR_ERR(phy);
+	phy = devm_of_phy_optional_get(dev, port_np, name);
+	if (IS_ERR_OR_NULL(phy))
+		return PTR_ERR_OR_ZERO(phy);
 
 	/* Serdes PHY exists. Store it. */
 	port->slave.serdes_phy = phy;
-- 
2.34.1

