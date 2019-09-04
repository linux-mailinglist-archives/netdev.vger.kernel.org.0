Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579DCA8A65
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbfIDP7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732295AbfIDP7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B62E20820;
        Wed,  4 Sep 2019 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612752;
        bh=BwMnitDcDnhJKya16RLdKbbWRgE9L65diLVyxaRj83g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCdi/6GxWYVFjbhIBFwVq3AiBqfbWyR81ZAkNKXMwbwMcLS13JdunQCW2SoiWK256
         CjBqKIyA5LyeR7CBZkCH9/iwltPZbA9q26oFVyI0MXZoTChWu8JTPi8RZXpKSf4nyT
         Yve7X6W6P5Slu4HyIqitrm33IvOmcadzi0qcEBGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Hartmann <marco.hartmann@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 61/94] Add genphy_c45_config_aneg() function to phy-c45.c
Date:   Wed,  4 Sep 2019 11:57:06 -0400
Message-Id: <20190904155739.2816-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartmann <marco.hartmann@nxp.com>

[ Upstream commit 94acaeb50ced653bfe2c4d8037c70b107af14124 ]

Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
genphy_config_aneg") introduced a check that aborts phy_config_aneg()
if the phy is a C45 phy.
This causes phy_state_machine() to call phy_error() so that the phy
ends up in PHY_HALTED state.

Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
(analogous to the C22 case) so that the state machine can run
correctly.

genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
in drivers/net/phy/marvell10g.c, excluding vendor specific
configurations for 1000BaseT.

Fixes: 22b56e827093 ("net: phy: replace genphy_10g_driver with genphy_c45_driver")

Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy-c45.c | 26 ++++++++++++++++++++++++++
 drivers/net/phy/phy.c     |  2 +-
 include/linux/phy.h       |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 58bb25e4af106..7935593debb11 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -523,6 +523,32 @@ int genphy_c45_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_status);
 
+/**
+ * genphy_c45_config_aneg - restart auto-negotiation or forced setup
+ * @phydev: target phy_device struct
+ *
+ * Description: If auto-negotiation is enabled, we configure the
+ *   advertising, and then restart auto-negotiation.  If it is not
+ *   enabled, then we force a configuration.
+ */
+int genphy_c45_config_aneg(struct phy_device *phydev)
+{
+	bool changed = false;
+	int ret;
+
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return genphy_c45_pma_setup_forced(phydev);
+
+	ret = genphy_c45_an_config_aneg(phydev);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = true;
+
+	return genphy_c45_check_and_restart_aneg(phydev, changed);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_config_aneg);
+
 /* The gen10g_* functions are the old Clause 45 stub */
 
 int gen10g_config_aneg(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e8885429293ad..57b3376877821 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -499,7 +499,7 @@ static int phy_config_aneg(struct phy_device *phydev)
 	 * allowed to call genphy_config_aneg()
 	 */
 	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
-		return -EOPNOTSUPP;
+		return genphy_c45_config_aneg(phydev);
 
 	return genphy_config_aneg(phydev);
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6424586fe2d65..7c5a9fb9c9f49 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1108,6 +1108,7 @@ int genphy_c45_an_disable_aneg(struct phy_device *phydev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
+int genphy_c45_config_aneg(struct phy_device *phydev);
 
 /* The gen10g_* functions are the old Clause 45 stub */
 int gen10g_config_aneg(struct phy_device *phydev);
-- 
2.20.1

