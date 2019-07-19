Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFA66E77E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfGSOim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 10:38:42 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:58045 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfGSOim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 10:38:42 -0400
Received: from mc-bl-xps13.lan (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id EFF5D200007;
        Fri, 19 Jul 2019 14:38:38 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        miquel.raynal@bootlin.com
Subject: [PATCH net] net: mvpp2: Don't check for 3 consecutive Idle frames for 10G links
Date:   Fri, 19 Jul 2019 16:38:48 +0200
Message-Id: <20190719143848.3826-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPv2's XLGMAC can wait for 3 idle frames before triggering a link up
event. This can cause the link to be stuck low when there's traffic on
the interface, so disable this feature.

Fixes: 4bb043262878 ("net: mvpp2: phylink support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c51f1d5b550b..b6591ea0c6d6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4739,9 +4739,9 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 	else
 		ctrl0 &= ~MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
 
-	ctrl4 &= ~MVPP22_XLG_CTRL4_MACMODSELECT_GMAC;
-	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC |
-		 MVPP22_XLG_CTRL4_EN_IDLE_CHECK;
+	ctrl4 &= ~(MVPP22_XLG_CTRL4_MACMODSELECT_GMAC |
+		   MVPP22_XLG_CTRL4_EN_IDLE_CHECK);
+	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC;
 
 	if (old_ctrl0 != ctrl0)
 		writel(ctrl0, port->base + MVPP22_XLG_CTRL0_REG);
-- 
2.20.1

