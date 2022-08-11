Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6BC5901E7
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiHKPyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHKPyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:54:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39DC6B643;
        Thu, 11 Aug 2022 08:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B4F61633;
        Thu, 11 Aug 2022 15:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853A8C433C1;
        Thu, 11 Aug 2022 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232733;
        bh=Q/b5sdn+npo2ooep5nrSplnZeiz1t01Fl6+3JDl+qtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvm/SDY7OFwUnkg3+Y4fy69NCkREMGAgnowVQ20UF5HIe0097ZjT6pDdnQpauxc4H
         DN3FvrA967GAop9sXfR9ApeTI2HqLjbVLXgH0PkzZyuE88/y6eUblMqaJk3UqPQKeA
         VZBIMJcNz8x/cBWkVei0MK9KhNUcXAgLOnO19dEA5o7hmcjLba0A7t0drdC9ZdtEzc
         qoN9Z5yeGW8dvN2e9UU0DRtumkLxMAGATC38lUu7BNCrKtQq5OlsIYyftqHSRzVZyL
         gXY5bMJ5OG+j/cfZm78CBv8leg1HR9L0Go3NVK2HiilqzMbuL0jlYjcnsNdxHZk6IF
         4EkGWSvXKlWBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 25/93] net: phy: marvell-88x2222: set proper phydev->port
Date:   Thu, 11 Aug 2022 11:41:19 -0400
Message-Id: <20220811154237.1531313-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Bornyakov <i.bornyakov@metrotek.ru>

[ Upstream commit 9794ef5a68430946da2dfe7342be53b50bce9a41 ]

phydev->port was not set and always reported as PORT_TP.
Set phydev->port according to inserted SFP module.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell-88x2222.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index d8b31d4d2a73..f070776ca904 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -490,6 +490,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	dev = &phydev->mdio.dev;
 
 	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
+	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
 	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
 
 	dev_info(dev, "%s SFP module inserted\n", phy_modes(sfp_interface));
@@ -526,6 +527,7 @@ static void mv2222_sfp_remove(void *upstream)
 
 	priv->line_interface = PHY_INTERFACE_MODE_NA;
 	linkmode_zero(priv->supported);
+	phydev->port = PORT_NONE;
 }
 
 static void mv2222_sfp_link_up(void *upstream)
-- 
2.35.1

