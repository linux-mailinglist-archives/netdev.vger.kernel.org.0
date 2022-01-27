Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1578449E799
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbiA0QeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243798AbiA0Qdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:33:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FC0C061747
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 08:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A096191C
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 16:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F5AC340E4;
        Thu, 27 Jan 2022 16:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643301234;
        bh=67GcVQatueXCqCx4riRmWoR3Vcpfoo59Fd9rQL0qgTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Nup9KCLdlPuQn88GQdnggtecEp28kRSkrlvWrNzS057wZU8b60C6oCy7tpk9Yb+lU
         VYLsojT+L2anbtEAcFZ5uR8TT8SgoQKfi/noaHI00FbAk+6gitSnXbgHE5qmVqBlGb
         QA+MWOlOlSQE23RR7DAZVAkDN4ttsSG/6BXVQT5GhhfQRS5CwbxuQlC3hhG6FlLQ4l
         NkGAxl87Sx3WeBLfMwokZHLOGNB8LvDBLJ4/sUz5oTT7uIgjKNKYJQMzY2trXGZ8zM
         S04vTVuVdlrpq8T82caImU+zXFvvw956Yu5IwLi7PYD+uFeGoxnPSszCwYHp4o96hk
         1z1d6HfZIOBYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: mii: remove mii_lpa_mod_linkmode_lpa_sgmii()
Date:   Thu, 27 Jan 2022 08:33:49 -0800
Message-Id: <20220127163349.203240-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir points out that since we removed mii_lpa_to_linkmode_lpa_sgmii(),
mii_lpa_mod_linkmode_lpa_sgmii() is also no longer called.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/mii.h | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index b8a1a17a87dd..5ee13083cec7 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -354,39 +354,6 @@ static inline u32 mii_adv_to_ethtool_adv_x(u32 adv)
 	return result;
 }
 
-/**
- * mii_lpa_mod_linkmode_adv_sgmii
- * @lp_advertising: pointer to destination link mode.
- * @lpa: value of the MII_LPA register
- *
- * A small helper function that translates MII_LPA bits to
- * linkmode advertisement settings for SGMII.
- * Leaves other bits unchanged.
- */
-static inline void
-mii_lpa_mod_linkmode_lpa_sgmii(unsigned long *lp_advertising, u32 lpa)
-{
-	u32 speed_duplex = lpa & LPA_SGMII_DPX_SPD_MASK;
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_1000HALF);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_1000FULL);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_100HALF);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_100FULL);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_10HALF);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, lp_advertising,
-			 speed_duplex == LPA_SGMII_10FULL);
-}
-
 /**
  * mii_adv_mod_linkmode_adv_t
  * @advertising:pointer to destination link mode.
-- 
2.34.1

