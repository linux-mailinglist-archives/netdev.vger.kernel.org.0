Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE2200454
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgFSIt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:49:56 -0400
Received: from smtp33.i.mail.ru ([94.100.177.93]:42284 "EHLO smtp33.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgFSItv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 04:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=Yh3/gOgmDRsHltKBZI6weYe/XMFpfXLtu1YdQvgjalM=;
        b=ji+9yoinq9pTlOC4uIVdzH7Yk6xMjTVd1AT8IIezdSGk1wBtQzXc9bM/4Ol35ajbT/WlhJKK+n9o7fnTxaAD/dF7bJdX5YB95AFIDSW6HRJh1SNcuzpYkFc0L9r5XhrBtvaaxTh75NfzB2ggB5sSwYDjUsyjf1Y7yis9p+GZSxY=;
Received: by smtp33.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmCia-0005tu-Lm; Fri, 19 Jun 2020 11:49:48 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/3] net: phy: marvell: Add Marvell 88E1340S support
Date:   Fri, 19 Jun 2020 11:49:03 +0300
Message-Id: <20200619084904.95432-3-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619084904.95432-1-fido_max@inbox.ru>
References: <20200619084904.95432-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp33.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9FF4B5D0D517DDB955EFB52B18C6CEFA6A30DC408C5A5E331182A05F538085040028F9FDBA818FE68F7867CB6AD44D41F7621B85C3E9C60DEB920700249C46612
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7911D8D445CDAD2FBEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006373A89F5095BA89D4D8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC5347410A10DF4ECD241249CFF21807A8BD89ED736300B91F389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C353FA85A707D24CADCC7F00164DA146DA6F5DAA56C3B73B23E7DDDDC251EA7DABD81D268191BDAD3DC09775C1D3CA48CFACF3E197D74327EBBA3038C0950A5D36C8A9BA7A39EFB7669EC76388C36FFEC7BA3038C0950A5D36D5E8D9A59859A8B66239BBC748D513593AA81AA40904B5D99449624AB7ADAF3726B9191E2D567F0E4AD6D5ED66289B5278DA827A17800CE70BB89B22BF4660DC67F23339F89546C5A8DF7F3B2552694A6FED454B719173D6725E5C173C3A84C3C9BE88FFEDFA497A35872C767BF85DA2F004C906525384306FED454B719173D6462275124DF8B9C91AEFE2C75F2E44D4E5BFE6E7EFDEDCD789D4C264860C145E
X-C8649E89: F64E627A00717B24B68A7A8A64A3AC399DDADB43E33E5C3D25C0CC1FB942E6B11275DEE1D8A12566
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj7ZRlLMijxWqWm6PX0a0CLQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB242766D898BDB74DCB3BC88FDC9ECCE82D334CAB6DA6D09594EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
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
index db5257f3b362..de6bd07a5983 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2459,6 +2459,28 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
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
@@ -2479,6 +2501,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
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

