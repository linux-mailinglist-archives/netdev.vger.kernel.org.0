Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9247202975
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgFUIAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:00:47 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:46470 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbgFUIAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=kQtYqwjscS3GSNl8CVmWVxOV8HgyLgjgKFbONSFgGZs=;
        b=XeKpiVfv/oMzFp9RDzEAB7bpZN3Os+P7fbklB7CPb22z9fbR7FUQDDv48LKo8Wg7svJ2nPwmXOLvOjzWRcbOUx4Hb+MmJlXgwqYruuIdlqlq/HES7FQmbUsmKpAGBFtge1GhWOC4+vQK5SXCzTc0F3LcrAApbFJWYUDepxIUewE=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmuuC-0000ou-7q; Sun, 21 Jun 2020 11:00:44 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/3] net: phy: marvell: Add Marvell 88E1340S support
Date:   Sun, 21 Jun 2020 10:59:51 +0300
Message-Id: <20200621075952.11970-3-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621075952.11970-1-fido_max@inbox.ru>
References: <20200621075952.11970-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E196090AC2CBDFADCC97DA7FD68450178182A05F538085040E543508AA00D9AE05E8123A547DB243D6324C20F506E37E62E99995F3FC63007
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7D3BEF3C661CDD2E7EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637EF3EA0FBF23235768638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC34C26AE549D86D25F6675CD448B530C0ADC0F23014239550389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C091DAD9F922AA71188941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3CF36E64A7E3F8E58117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C5149A672E96B27E12D242C3BD2E3F4C64AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C3C55CB183CB5FC9A4BA3038C0950A5D36B5C8C57E37DE458BCF70BCFA8C8197A467F23339F89546C55F5C1EE8F4F765FCC6A536F79815AD9275ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 223468489A3E5B72A64208AB62F08C93D7597619F858BEBF0ABBBF0539D330EF1275DEE1D8A12566
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojijaCqZVrqPEHGfocAwqXxg==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD28993412C922172FCFC7F7D5A7A5DDCEA0BC305B4AEA34F48939EB09EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this new phy ID.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 drivers/net/phy/marvell.c   | 23 +++++++++++++++++++++++
 include/linux/marvell_phy.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index ee9c352f67ab..0842deb33085 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2943,6 +2943,28 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1340S,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1340S",
+		.probe = m88e1510_probe,
+		/* PHY_GBIT_FEATURES */
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1510_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+	},
 };
 
 module_phy_driver(marvell_drivers);
@@ -2963,6 +2985,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index af6b11d4d673..c4390e9cbf15 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -15,6 +15,7 @@
 #define MARVELL_PHY_ID_88E1149R		0x01410e50
 #define MARVELL_PHY_ID_88E1240		0x01410e30
 #define MARVELL_PHY_ID_88E1318S		0x01410e90
+#define MARVELL_PHY_ID_88E1340S		0x01410dc0
 #define MARVELL_PHY_ID_88E1116R		0x01410e40
 #define MARVELL_PHY_ID_88E1510		0x01410dd0
 #define MARVELL_PHY_ID_88E1540		0x01410eb0
-- 
2.25.1

