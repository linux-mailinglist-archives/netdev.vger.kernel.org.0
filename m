Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A1B433960
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhJSO7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:59:41 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:52997 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhJSO7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:59:37 -0400
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 93D4E100007;
        Tue, 19 Oct 2021 14:57:19 +0000 (UTC)
From:   Kory Maincent <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH] net: renesas: Fix rgmii-id delays
Date:   Tue, 19 Oct 2021 16:57:17 +0200
Message-Id: <20211019145719.122751-1-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invert the configuration of the RGMII delay selected by RGMII_RXID and
RGMII_TXID.

The ravb MAC is adding RX delay if RGMII_RXID is selected and TX delay
if RGMII_TXID but that behavior is wrong.
Indeed according to the ethernet.txt documentation the ravb configuration
should be inverted:
  * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
     should not add an RX delay in this case)
  * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
     should not add an TX delay in this case)

This patch inverts the behavior, i.e adds TX delay when RGMII_RXID is
selected and RX delay when RGMII_TXID is selected.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f85f2d97b18..89cd88e5b450 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2114,13 +2114,13 @@ static void ravb_parse_delay_mode(struct device_node *np, struct net_device *nde
 	/* Fall back to legacy rgmii-*id behavior */
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-		priv->rxcidm = 1;
+		priv->txcidm = 1;
 		priv->rgmii_override = 1;
 	}
 
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-		priv->txcidm = 1;
+		priv->rxcidm = 1;
 		priv->rgmii_override = 1;
 	}
 }
-- 
2.25.1

