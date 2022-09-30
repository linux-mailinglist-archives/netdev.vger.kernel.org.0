Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE45F0D6E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiI3OWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiI3OVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309F11A1EB0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9831BB828F2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D53C433C1;
        Fri, 30 Sep 2022 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547684;
        bh=bRLmCjpwkRnS3WPu/kquVXCnveoP1sdD511oo66fkpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ss8ygralhZURjKMSKgNiUov+inJOS9gIfYEI2LLtWKyukXdJ9RDBWTAijYc2b9Mvz
         6UlriF8rJCPXXNVW3LkiJS4H9Q3jPTngrwxaHILKsXe5GG0RY7jpJdoR7FEMTuO479
         PQAwCpEEiNluh973DfJlyXGlqZpdZ8cl1/WMCTfr9zlZFNRh1S7Ynl4Jsl+bFRIx4m
         0puajFZ/cWCLt1tULmcLcbIlEhyibyfMwrv7jGmeu8hkWb54IbpXpPlzhxenUzOYti
         r2ci/X+GpX9gNBf1Xc/khPR16dzICBOhT0oWYoHW88axj91elBr8QlspLIG36YyZC/
         9/Z3mUkrI0k9w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 05/12] net: phylink: pass supported host PHY interface modes to phylib for SFP's PHYs
Date:   Fri, 30 Sep 2022 16:21:03 +0200
Message-Id: <20220930142110.15372-6-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the supported PHY interface types to phylib if the PHY we are
connecting is inside a SFP, so that the PHY driver can select an
appropriate host configuration mode for their interface according to
the host capabilities.

For example the Marvell 88X3310 PHY inside RollBall SFP modules
defaults to 10gbase-r mode on host's side, and the marvell10g
driver currently does not change this setting. But a host may not
support 10gbase-r. For example Turris Omnia only supports sgmii,
1000base-x and 2500base-x modes. The PHY can be configured to use
those modes, but in order for the PHY driver to do that, it needs
to know which modes are supported.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 17 +++++++++++++++++
 include/linux/phy.h       |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f6e9231f0cbe..9ff8eb516666 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2814,6 +2814,8 @@ static const phy_interface_t phylink_sfp_interface_preference[] = {
 	PHY_INTERFACE_MODE_100BASEX,
 };
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static phy_interface_t phylink_choose_sfp_interface(struct phylink *pl,
 						    const unsigned long *intf)
 {
@@ -3091,6 +3093,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	/* Do the initial configuration */
 	ret = phylink_sfp_config_phy(pl, mode, phy);
 	if (ret < 0)
@@ -3444,4 +3450,15 @@ void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c45_pcs_get_state);
 
+static int __init phylink_init(void)
+{
+	for (int i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); ++i)
+		__set_bit(phylink_sfp_interface_preference[i],
+			  phylink_sfp_interfaces);
+
+	return 0;
+}
+
+module_init(phylink_init);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9c66f357f489..d65fc76fe0ae 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -571,6 +571,7 @@ struct macsec_ops;
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
  * @lp_advertising: Current link partner advertised linkmodes
+ * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
  * @rate_matching: Current rate matching mode
@@ -670,6 +671,9 @@ struct phy_device {
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 
+	/* Host supported PHY interface types. Should be ignored if empty. */
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
+
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
-- 
2.35.1

