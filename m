Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D51193FE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfLJVMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbfLJVMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5C0246B8;
        Tue, 10 Dec 2019 21:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012340;
        bh=jMXgQtIZOPOIuXUvDseEE9HrBBmr6B6RlBv4+edN7wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOYvdSjBVl2m9WtLy2KwxTBaSw3g74FeaWh1W/fLrZS+lfFsszSd1wsNLSsuiEca2
         jN2tll+QPm1ZvuQCiFAAbofIZdHJ5pClhjb16tbok2aBYWrNOOVIME5Qd5Y5sZW0WK
         q/kyts4rGMw9FoonICRNFMdIi38KHxJKuAIo0K7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 271/350] r8169: respect EEE user setting when restarting network
Date:   Tue, 10 Dec 2019 16:06:16 -0500
Message-Id: <20191210210735.9077-232-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7ec3f872bc85ada93db34448d73bb399d6b82c2c ]

Currently, if network is re-started, we advertise all supported EEE
modes, thus potentially overriding a manual adjustment the user made
e.g. via ethtool. Be friendly to the user and preserve a manual
setting on network re-start.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1d67eeeab79d6..229bc6026ebc4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -680,6 +680,7 @@ struct rtl8169_private {
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
 	u32 saved_wolopts;
+	int eee_adv;
 
 	const char *fw_name;
 	struct rtl_fw *rtl_fw;
@@ -2075,6 +2076,10 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 	}
 
 	ret = phy_ethtool_set_eee(tp->phydev, data);
+
+	if (!ret)
+		tp->eee_adv = phy_read_mmd(dev->phydev, MDIO_MMD_AN,
+					   MDIO_AN_EEE_ADV);
 out:
 	pm_runtime_put_noidle(d);
 	return ret;
@@ -2105,10 +2110,16 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 static void rtl_enable_eee(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
-	int supported = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
+	int adv;
+
+	/* respect EEE advertisement the user may have set */
+	if (tp->eee_adv >= 0)
+		adv = tp->eee_adv;
+	else
+		adv = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 
-	if (supported > 0)
-		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, supported);
+	if (adv >= 0)
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
 }
 
 static void rtl8169_get_mac_version(struct rtl8169_private *tp)
@@ -7064,6 +7075,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
+	tp->eee_adv = -1;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
-- 
2.20.1

