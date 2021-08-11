Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23553E9502
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhHKPtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbhHKPto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:49:44 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA88C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 08:49:13 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:438:1ff1:1071:f524])
        by baptiste.telenet-ops.be with bizsmtp
        id gFp92500c1gJxCh01Fp9to; Wed, 11 Aug 2021 17:49:09 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mDqTd-0024wx-1S; Wed, 11 Aug 2021 17:49:09 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mDqTc-005TGq-8U; Wed, 11 Aug 2021 17:49:08 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next] ravb: Remove checks for unsupported internal delay modes
Date:   Wed, 11 Aug 2021 17:49:00 +0200
Message-Id: <2037542ac56e99413b9807e24049711553cc88a9.1628696778.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EtherAVB instances on the R-Car E3/D3 and RZ/G2E SoCs do not support
TX clock internal delay modes, and the EtherAVB driver prints a warning
if an unsupported "rgmii-*id" PHY mode is specified, to catch buggy
DTBs.

Commit a6f51f2efa742df0 ("ravb: Add support for explicit internal
clock delay configuration") deprecated deriving the internal delay mode
from the PHY mode, in favor of explicit configuration using the now
mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps" properties,
thus delegating the warning to the legacy fallback code.

Since explicit configuration of a (valid) internal clock delay
configuration is enforced by validating device tree source files against
DT binding files, and all upstream DTS files have been converted as of
commit a5200e63af57d05e ("arm64: dts: renesas: rzg2: Convert EtherAVB to
explicit delay handling"), the checks in the legacy fallback code can be
removed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/renesas/ravb_main.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f4dfe9f71d067533..62b0605f02ff786e 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1973,13 +1973,6 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	}
 }
 
-static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
-	{ .soc_id = "r8a774c0" },
-	{ .soc_id = "r8a77990" },
-	{ .soc_id = "r8a77995" },
-	{ /* sentinel */ }
-};
-
 /* Set tx and rx clock internal delay modes */
 static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
 {
@@ -2010,12 +2003,8 @@ static void ravb_parse_delay_mode(struct device_node *np, struct net_device *nde
 
 	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-		if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
-			  "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
-			  phy_modes(priv->phy_interface))) {
-			priv->txcidm = 1;
-			priv->rgmii_override = 1;
-		}
+		priv->txcidm = 1;
+		priv->rgmii_override = 1;
 	}
 }
 
-- 
2.25.1

