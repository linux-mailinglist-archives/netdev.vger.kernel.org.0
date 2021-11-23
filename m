Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2F345A885
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhKWQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhKWQnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5695B60295;
        Tue, 23 Nov 2021 16:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685632;
        bh=CVpIWPG36vNkTFZZJMBQeFeOSgxKeePq0d630rHkcDY=;
        h=From:To:Cc:Subject:Date:From;
        b=gZVw9WhaPxSgcF3CaiCpql576BZ7Vtu9IESCGML2taqmuYyfiw1m5doBw38/G48/5
         S/JR22vLlfdRcmDi2tPNLDfxl6DaMmIdMDA/BlrmpOTXfaq1hadenaT8YtgY3326P4
         TnAZSWOWEjofiF8w7hEXK0ZVdZXzw62xRuuALMHC5vnW0jOt36IAJ/keMmQjICKdV8
         anYh9k4yucYB1F+ljejVjLN2uuCWJIZ/7DJT1W97hz8vUC7jtzJQzhv5MOR9zlCHz1
         c+1Tc+snDxDH1smpS8AwJf2HIbzuWeIhGFc8jSqGJ0ULYXssekgHLBGLKSp2/eqzHj
         uwisB8LPdOmNw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 0/8] Extend `phy-mode` to string array
Date:   Tue, 23 Nov 2021 17:40:19 +0100
Message-Id: <20211123164027.15618-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v2 of series that extends the `phy-connection-type` /
`phy-mode` property to be an array of strings, instead of just one
string, and makes the corresponding changes to code. It then uses
this changes to make marvell10g PHY driver choose the best MACTYPE
according to which phy-modes are supported by the MAC, the PHY and
the board.

Conventionaly the `phy-mode` means "this is the mode I want the PHY to
operate in". But we now have some PHYs that may need to change the PHY
mode during operation (marvell10g PHY driver), and so we need to know
all the supported modes. Russell King is working on MAC and PHY drivers
to inform phylink on which PHY interface modes they support, but it is
not enough, because even if a MAC/PHY driver fills all the modes
supported by the driver, still each individual board may have only some
of these modes actually wired.

This series
- changes the type of the `phy-mode` property to be an array of PHY
  interface strings,
- updated documentation of of_get_phy_mode() and related to inform that
  only first mode is returned by these functions (since this function
  is needed to still support conventional usage of the `phy-mode`
  property),
- adds fwnode_get_phy_modes() function which reads the `phy-mode` array
  and fills bitmap with mentioned modes,
- adds code to phylink to intersect the supported interfaces bitmap
  supplied by MAC driver, with interface modes defined in device-tree
  (and keeps backwards compatibility with conventional usage of the
   phy-mode property, for more information read the commit message of
   patch 4/8),
- passes supported interfaces to PHY driver so that it may configure
  a PHY to a specific mode given these interfaces,
- uses this information in marvell10g driver.

Changes since v1:
- added Reviewed-by tags
- added 10gbase-r example scenario to commit message of patch 4
- changed phylink_update_phy_modes() so that if supported_interfaces is
  empty (an unconverted driver that doesn't fill up this member), we
  leave it empty
- rewritten phylink_update_phy_modes() according to Sean Anderson's
  comment: use phy_interface_and/or() instead of several
  if (test_bit) set_bit
- added more explanation to commit message of patch 8, as per Vladimir
  Oltean's suggestion

Changes since RFC:
- update also description of the `phy-connection-type` property

Marek Behún (7):
  dt-bindings: ethernet-controller: support multiple PHY connection
    types
  net: Update documentation for *_get_phy_mode() functions
  device property: add helper function for getting phy mode bitmap
  net: phylink: update supported_interfaces with modes from fwnode
  net: phylink: pass supported PHY interface modes to phylib
  net: phy: marvell10g: Use generic macro for supported interfaces
  net: phy: marvell10g: Use tabs instead of spaces for indentation

Russell King (1):
  net: phy: marvell10g: select host interface configuration

 .../bindings/net/ethernet-controller.yaml     |  94 ++++++------
 drivers/base/property.c                       |  48 +++++-
 drivers/net/phy/marvell10g.c                  | 140 ++++++++++++++++--
 drivers/net/phy/phylink.c                     |  98 ++++++++++++
 include/linux/phy.h                           |  10 ++
 include/linux/property.h                      |   3 +
 net/core/of_net.c                             |   9 +-
 7 files changed, 332 insertions(+), 70 deletions(-)

-- 
2.32.0

