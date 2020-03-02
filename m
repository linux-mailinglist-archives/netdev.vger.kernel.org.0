Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4B175145
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCBASt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 19:18:49 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:52570 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgCBASt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 19:18:49 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 48W12v2HSHzQl9q;
        Mon,  2 Mar 2020 01:18:47 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 4Ihz0PPllqct; Mon,  2 Mar 2020 01:18:44 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] ag71xx: Add support for RMII, RGMII and SGMII
Date:   Mon,  2 Mar 2020 01:18:29 +0100
Message-Id: <20200302001830.14278-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GMAC0 on the AR9344 also supports RMII and RGMII. This is an
external interface which gets connected to an external PHY or an
external switch. Without this patch the driver does not load on PHYs
configured to RMII or RGMII.

The QCA9563 often uses SGMII to connect to external switches.

This still misses the external interface configuration, but that was
also not done before the switch to phylink.

Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 02b7705393ca..69125f870363 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -874,8 +874,11 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_RMII &&
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_MII) {
+	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
@@ -889,7 +892,9 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 	phylink_set(mask, 100baseT_Full);
 
 	if (state->interface == PHY_INTERFACE_MODE_NA ||
-	    state->interface == PHY_INTERFACE_MODE_GMII) {
+	    state->interface == PHY_INTERFACE_MODE_GMII ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII ||
+	    phy_interface_mode_is_rgmii(state->interface)) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	}
-- 
2.20.1

