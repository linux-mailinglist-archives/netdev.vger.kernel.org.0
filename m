Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D6200456
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgFSIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:50:03 -0400
Received: from smtp33.i.mail.ru ([94.100.177.93]:48612 "EHLO smtp33.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgFSItw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 04:49:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=R2eNVyqjFQtmInAirehLorGhIlLVYuDU2pYFLvMAuZs=;
        b=pTSQEBJP3SxLBzjmZEQvFzsPhkWdf97uzbtOKS/taAypQbyS3EECZMmtS3qw+poiDLpkIgycBc+yRkpO6g6Z8n5obqDGPalLbLuVWUtROKl/aB8ShsSqNWn7vpt2AoYItthm67R6i6A3Xm/QPnypIYW9H53brISmbg9IDDaFdRY=;
Received: by smtp33.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmCib-0005tu-7a; Fri, 19 Jun 2020 11:49:49 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/3] net: phy: marvell: Add Marvell 88E1548P support
Date:   Fri, 19 Jun 2020 11:49:04 +0300
Message-Id: <20200619084904.95432-4-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619084904.95432-1-fido_max@inbox.ru>
References: <20200619084904.95432-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp33.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9FF4B5D0D517DDB95061B499E6D84E1D2FAA4EF3CF2A594A4182A05F538085040065A60793E5D65748BEA8CDAFB9BEE93090E46B4497988A409A88B000A112534
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7BC21C294753CF0FAEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637BDA91B9D4E4EEA1D8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC5347410A10DF4ECD3A1514A314F6E0887F7859A2A8DD9051389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C353FA85A707D24CADCC7F00164DA146DA6F5DAA56C3B73B23E7DDDDC251EA7DABD81D268191BDAD3DC09775C1D3CA48CF189A88AE0B35AA59BA3038C0950A5D36C8A9BA7A39EFB7669EC76388C36FFEC7BA3038C0950A5D36D5E8D9A59859A8B6FFDD22F168D5683776E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F7900637BF1C901A33650803A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F83C798A30B85E16BC6EABA9B74D0DA47B5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DB374A87274649D866574AF45C6390F7469DAA53EE0834AAEE
X-C8649E89: 1A31A149732C310FB68A7A8A64A3AC3934E5AE0F5BF09445992E6570B02D041ABAB18DE9D6217007
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj7ZRlLMijxWpjTVyeAaI3Lg==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB246F1AB49824E9E9003BC88FDC9ECCE82DD6F2ED42E9333CE7EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this new phy ID.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 drivers/net/phy/marvell.c   | 24 ++++++++++++++++++++++++
 include/linux/marvell_phy.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index de6bd07a5983..38e3ed448c64 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2481,6 +2481,29 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1548P,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1548P",
+		.probe = m88e1510_probe,
+		.features = PHY_GBIT_FIBRE_FEATURES,
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
+
 };
 
 module_phy_driver(marvell_drivers);
@@ -2502,6 +2525,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1548P, MARVELL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index c4390e9cbf15..ff7b7607c8cf 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -20,6 +20,7 @@
 #define MARVELL_PHY_ID_88E1510		0x01410dd0
 #define MARVELL_PHY_ID_88E1540		0x01410eb0
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
+#define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
-- 
2.25.1

