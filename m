Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF75F0D69
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiI3OV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiI3OVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B731A3AC1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F41B828F7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BF2C43470;
        Fri, 30 Sep 2022 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547676;
        bh=GJFnnF0TtALxPPD9AXhLEsIwaMU0bK4YL23useYsObw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYZioOAHNFKUrsD3fyjAF2L8ZTFAZ9U2iuBntcm5JOhAHtywxI4LAkHdbWFd+FVeL
         I/Cfnjo2HVepKJMPMVupclMxQzoNZKpmUdTlcYikBns8hH175Hair4FyKeaXwh2uY6
         dWL2aMYOmCRgs0eyhJW2rXQQUp/1ZGxql+310YC9R2rPbtkk2ODnUZf87mpzoA451J
         cUYviOzf8POo9ZzDdZuL2BRg3NQlfb1TyDF0eWMfHptTJZnE6DwYEpFQD56mkV5Mh2
         lO6XQQRABxdOaJxaUs+MYVetLY7VVLCe4Ne1JEgxZjZtltJiCvXXv3TUbnhC1C905u
         k3ep7A2X5kzyw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 01/12] net: phylink: add ability to validate a set of interface modes
Date:   Fri, 30 Sep 2022 16:20:59 +0200
Message-Id: <20220930142110.15372-2-kabel@kernel.org>
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

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Rather than having the ability to validate all supported interface
modes or a single interface mode, introduce the ability to validate
a subset of supported modes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[ rebased on current net-next ]
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d0af026c9afa..2cf388fad1be 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -637,8 +637,9 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
 }
 
-static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
-				struct phylink_link_state *state)
+static int phylink_validate_mask(struct phylink *pl, unsigned long *supported,
+				 struct phylink_link_state *state,
+				 const unsigned long *interfaces)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_adv) = { 0, };
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_s) = { 0, };
@@ -647,7 +648,7 @@ static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
 	int intf;
 
 	for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
-		if (test_bit(intf, pl->config->supported_interfaces)) {
+		if (test_bit(intf, interfaces)) {
 			linkmode_copy(s, supported);
 
 			t = *state;
@@ -668,12 +669,14 @@ static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	if (!phy_interface_empty(pl->config->supported_interfaces)) {
+	const unsigned long *interfaces = pl->config->supported_interfaces;
+
+	if (!phy_interface_empty(interfaces)) {
 		if (state->interface == PHY_INTERFACE_MODE_NA)
-			return phylink_validate_any(pl, supported, state);
+			return phylink_validate_mask(pl, supported, state,
+						     interfaces);
 
-		if (!test_bit(state->interface,
-			      pl->config->supported_interfaces))
+		if (!test_bit(state->interface, interfaces))
 			return -EINVAL;
 	}
 
-- 
2.35.1

