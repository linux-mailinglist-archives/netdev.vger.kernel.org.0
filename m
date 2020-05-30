Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2D1E9392
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgE3UeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:34:16 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56953 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgE3UeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:34:16 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EB71F22FE6;
        Sat, 30 May 2020 22:34:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590870853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ClnyDmkjn+ApCiw+K/UhmRrQVfpetPmbhNqfoUqBcLw=;
        b=pEMe28L3nJhBP3HgdSgqrQAuVONpgprv06K2mgF7ED8xgNBECq9To8dbqSyXNotzOusdZC
        stcQAmpGB8stu7wCyhhM/obKn1UvA0zeDaFHhph+ab2MvKz5zkqWLa0IolW7uMrgzyH2s8
        8fWwwnqqJT07Tf75Yap0c4N3Cx1kfIM=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH net-next] net: phy: broadcom: don't export RDB/legacy access methods
Date:   Sat, 30 May 2020 22:34:04 +0200
Message-Id: <20200530203404.1665-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't export __bcm_phy_enable_rdb_access() and
__bcm_phy_enable_legacy_access() functions. They aren't used outside this
module and it was forgotten to provide a prototype for these functions.
Just make them static for now.

Fixes: 11ecf8c55b91 ("net: phy: broadcom: add cable test support")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Michael Walle <michael@walle.cc>
---

Hi,

this patch contains a Fixes tag, but is sent to the net-next because the
commit which is fixed is only in net-next.

-michael

 drivers/net/phy/bcm-phy-lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index cb92786e3ded..ef6825b30323 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -583,18 +583,16 @@ int bcm_phy_enable_jumbo(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
 
-int __bcm_phy_enable_rdb_access(struct phy_device *phydev)
+static int __bcm_phy_enable_rdb_access(struct phy_device *phydev)
 {
 	return __bcm_phy_write_exp(phydev, BCM54XX_EXP_REG7E, 0);
 }
-EXPORT_SYMBOL_GPL(__bcm_phy_enable_rdb_access);
 
-int __bcm_phy_enable_legacy_access(struct phy_device *phydev)
+static int __bcm_phy_enable_legacy_access(struct phy_device *phydev)
 {
 	return __bcm_phy_write_rdb(phydev, BCM54XX_RDB_REG0087,
 				   BCM54XX_ACCESS_MODE_LEGACY_EN);
 }
-EXPORT_SYMBOL_GPL(__bcm_phy_enable_legacy_access);
 
 static int _bcm_phy_cable_test_start(struct phy_device *phydev, bool is_rdb)
 {
-- 
2.20.1

