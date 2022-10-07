Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C805F757D
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJGIs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGIs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:48:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361CB97BC
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 01:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F933B8228B
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D99C433C1;
        Fri,  7 Oct 2022 08:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665132534;
        bh=OajIKsqSzyloKzh36jtmM8meC1c85SR5zOoYbtXSFBk=;
        h=From:To:Cc:Subject:Date:From;
        b=C6JCN/e8ITZzk2wVQzNHp+zZKXget7ivhkwGzQ4xZparZknFbBoi2T6RR37Zu+PxG
         jEjeW2Y1cJAVaiN5QBxgrr0SBfn+n1AD02m8cw3q9RiS9DrJWgJCO9gOV0ftXKjkqL
         zXJevaUolQpcG9GAPUaZgEbJYazm2K94Fx8SwViTWSs29dEGHe2q4w/XklWx+bRpV1
         KkTYJv1e8cTZ0p/vUfmggVTTABXwTpYV8depPy21Z8VlyJ1RAgRLg89NdvZR2gTUOv
         lKZhoetjp5fd3oyo97k/pUAUo2OzeyZ3svTSCxU+pc3q8xgdn5bckyUCHWIXb5cpg8
         /RJ+1Wt6BuJMw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] net: sfp: fill also 5gbase-r and 25gbase-r modes in sfp_parse_support()
Date:   Fri,  7 Oct 2022 10:48:44 +0200
Message-Id: <20221007084844.20352-1-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fill in also 5gbase-r and 25gbase-r PHY interface modes into the
phy_interface_t bitmap in sfp_parse_support().

Fixes: fd580c983031 ("net: sfp: augment SFP parsing with phy_interface_t bitmap")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 29e3fa86bac3..daac293e8ede 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -257,6 +257,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	case SFF8024_ECC_100GBASE_SR4_25GBASE_SR:
 		phylink_set(modes, 100000baseSR4_Full);
 		phylink_set(modes, 25000baseSR_Full);
+		__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
 		break;
 	case SFF8024_ECC_100GBASE_LR4_25GBASE_LR:
 	case SFF8024_ECC_100GBASE_ER4_25GBASE_ER:
@@ -268,6 +269,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	case SFF8024_ECC_25GBASE_CR_S:
 	case SFF8024_ECC_25GBASE_CR_N:
 		phylink_set(modes, 25000baseCR_Full);
+		__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
 		break;
 	case SFF8024_ECC_10GBASE_T_SFI:
 	case SFF8024_ECC_10GBASE_T_SR:
@@ -276,6 +278,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		break;
 	case SFF8024_ECC_5GBASE_T:
 		phylink_set(modes, 5000baseT_Full);
+		__set_bit(PHY_INTERFACE_MODE_5GBASER, interfaces);
 		break;
 	case SFF8024_ECC_2_5GBASE_T:
 		phylink_set(modes, 2500baseT_Full);
-- 
2.35.1

