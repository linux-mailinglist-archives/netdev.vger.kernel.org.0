Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09161ADD67
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgDQMhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 08:37:25 -0400
Received: from mars.blocktrron.ovh ([51.254.112.43]:59536 "EHLO
        mail.blocktrron.ovh" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgDQMhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 08:37:25 -0400
Received: from dbauer-t470.home.david-bauer.net (p200300E53F0BB000FCE978B80865F4DD.dip0.t-ipconnect.de [IPv6:2003:e5:3f0b:b000:fce9:78b8:865:f4dd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 5553C22E3F
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 14:37:18 +0200 (CEST)
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: phy: at803x: add support for AR8032 PHY
Date:   Fri, 17 Apr 2020 14:37:06 +0200
Message-Id: <20200417123706.313513-1-mail@david-bauer.net>
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
 drivers/net/phy/at803x.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 31f731e6df72..4e4002a5fb67 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -106,6 +106,7 @@
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
+#define ATH8032_PHY_ID 0x004dd023
 #define ATH8035_PHY_ID 0x004dd072
 #define AT803X_PHY_ID_MASK			0xffffffef
 
@@ -763,6 +764,21 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 }, {
+	/* Qualcomm Atheros AR8032 */
+	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID)
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
+, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
 	.name			= "Qualcomm Atheros AR9331 built-in PHY",
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

