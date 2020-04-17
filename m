Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7828E1ADEA0
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgDQNmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 09:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730597AbgDQNmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 09:42:11 -0400
X-Greylist: delayed 3889 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Apr 2020 06:42:11 PDT
Received: from mail.blocktrron.ovh (mars.blocktrron.ovh [IPv6:2001:41d0:401:3000::cbd])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC5CC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 06:42:11 -0700 (PDT)
Received: from dbauer-t470.home.david-bauer.net (p200300E53F0BB000FCE978B80865F4DD.dip0.t-ipconnect.de [IPv6:2003:e5:3f0b:b000:fce9:78b8:865:f4dd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 8BCA222E3F
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 15:42:09 +0200 (CEST)
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Subject: [PATCH v2] net: phy: at803x: add support for AR8032 PHY
Date:   Fri, 17 Apr 2020 15:41:59 +0200
Message-Id: <20200417134159.427556-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the Qualcomm Atheros AR8032 Fast Ethernet PHY.

It shares many similarities with the already supported AR8030 PHY but
additionally supports MII connection to the MAC.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
Accidentally sent a very old WIP as v1.

 drivers/net/phy/at803x.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 31f731e6df72..31b6edcc1fd1 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -106,6 +106,7 @@
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
+#define ATH8032_PHY_ID 0x004dd023
 #define ATH8035_PHY_ID 0x004dd072
 #define AT803X_PHY_ID_MASK			0xffffffef
 
@@ -762,6 +763,21 @@ static struct phy_driver at803x_driver[] = {
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+}, {
+	/* Qualcomm Atheros AR8032 */
+	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
+	.name			= "Qualcomm Atheros AR8032",
+	.probe			= at803x_probe,
+	.remove			= at803x_remove,
+	.config_init		= at803x_config_init,
+	.link_change_notify	= at803x_link_change_notify,
+	.set_wol		= at803x_set_wol,
+	.get_wol		= at803x_get_wol,
+	.suspend		= at803x_suspend,
+	.resume			= at803x_resume,
+	/* PHY_BASIC_FEATURES */
+	.ack_interrupt		= at803x_ack_interrupt,
+	.config_intr		= at803x_config_intr,
 }, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
@@ -778,6 +794,7 @@ module_phy_driver(at803x_driver);
 static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ ATH8030_PHY_ID, AT803X_PHY_ID_MASK },
 	{ ATH8031_PHY_ID, AT803X_PHY_ID_MASK },
+	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
 	{ ATH8035_PHY_ID, AT803X_PHY_ID_MASK },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
 	{ }
-- 
2.26.0

