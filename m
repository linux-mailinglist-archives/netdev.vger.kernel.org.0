Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFEE5F0D70
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiI3OWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiI3OVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13AB1A4096
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A7962364
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68007C4314E;
        Fri, 30 Sep 2022 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547690;
        bh=O9I9OeUiBL2Ok/YnRDiiyywtJH2aj4nUsHhv8RuYc5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC8LJm8StXM2B/uQe65f6IUcZ89wgyuVG655gKAzwjhOGsK6LfT5+lHjufLBmUoxo
         u+A025FZVJtS5i8XussGDAM6vPRgAYRDmCjq//ZqIffnsb3t2p6cIWjaPL5Ulq8Brp
         Xna7R4lFi7zAWBXOkQpKuTk1xkLMczYI0vWOPyQMpBhlc6akEK+3BCWRdqAy7QKrQD
         u6Vjrbm+/4+Fx1dpzLODOePCFSUmtvwdWZmtUlTARWf4ZagL7yxPy8mFgyGs1JdQP4
         RZNC2BGd7q/BYskVgLNlW/OgtgtshbIbvVXunnAQUJD5ewURGAZoXu5OSefUDv+8E/
         2n9IPGSUS9YMg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next 08/12] net: phylink: allow attaching phy for SFP modules on 802.3z mode
Date:   Fri, 30 Sep 2022 16:21:06 +0200
Message-Id: <20220930142110.15372-9-kabel@kernel.org>
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

Some SFPs may contain an internal PHY which may in some cases want to
connect with the host interface in 1000base-x/2500base-x mode.
Do not fail if such PHY is being attached in one of these PHY interface
modes.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9ff8eb516666..75464df191ef 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1669,7 +1669,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 {
 	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
 		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-		     phy_interface_mode_is_8023z(interface))))
+		     phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)))
 		return -EINVAL;
 
 	if (pl->phydev)
@@ -2918,9 +2918,6 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
 		return ret;
 	}
 
-	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
-		return -EINVAL;
-
 	pl->link_port = pl->sfp_port;
 
 	phylink_sfp_set_config(pl, mode, support, &config);
-- 
2.35.1

