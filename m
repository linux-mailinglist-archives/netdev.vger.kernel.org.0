Return-Path: <netdev+bounces-8329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F67723BB5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E331C20D93
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A2028C34;
	Tue,  6 Jun 2023 08:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7985610E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:27:59 +0000 (UTC)
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07641BD9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:27:29 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed30:a3e8:6562:a823:d832])
	by laurent.telenet-ops.be with bizsmtp
	id 5kT42A00H1Tjf1k01kT4vb; Tue, 06 Jun 2023 10:27:13 +0200
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1q6S1b-004GxN-Ly;
	Tue, 06 Jun 2023 10:27:04 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1q6S1w-00Awvw-EK;
	Tue, 06 Jun 2023 10:27:04 +0200
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: stmmac: Fix build without PCS_LYNX
Date: Tue,  6 Jun 2023 10:27:01 +0200
Message-Id: <7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If STMMAC_ETH=y, but PCS_LYNX=n (e.g. shmobile_defconfig):

    arm-linux-gnueabihf-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
    stmmac_mdio.c:(.text+0xfbc): undefined reference to `lynx_pcs_destroy'

As pcs_lynx is used only on dwmac_socfpga, fix this by adding a check
for PCS_LYNX to the cleanup path in the generic driver.

Fixes: 5d1f3fe7d2d54d04 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index c784a6731f08e108..53ed59d732210814 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -665,7 +665,7 @@ int stmmac_mdio_unregister(struct net_device *ndev)
 	if (priv->hw->xpcs)
 		xpcs_destroy(priv->hw->xpcs);
 
-	if (priv->hw->lynx_pcs)
+	if (IS_ENABLED(CONFIG_PCS_LYNX) && priv->hw->lynx_pcs)
 		lynx_pcs_destroy(priv->hw->lynx_pcs);
 
 	mdiobus_unregister(priv->mii);
-- 
2.34.1


