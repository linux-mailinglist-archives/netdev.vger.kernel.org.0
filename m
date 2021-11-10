Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F00C44C87D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhKJTKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhKJTKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DE661027;
        Wed, 10 Nov 2021 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571233;
        bh=jIFmJG6g59FCuW/lpue9iYkUQz0b7tC31LYE3KMS5dg=;
        h=From:To:Cc:Subject:Date:From;
        b=Q3mRqoawP5t2rRV0ah1fOJveuxoUuVPw9f9YuiBF17NkkduY5LDutOmrduP17XjXK
         dEqvm1FHFAZCJXpY54mxDYMBHDourlJYfvh7x0gtlARmbO+4hZxSVmgpgRs8ybokWf
         TxjDW2EMxVYCCQwHVfNe323bc3ahwGeHhSmmkS2lz7egORzB6czIFREHtmViRClxO0
         uVBfL6D2nrdsuQB/yJyO+waFzaJj5Pv3WBEx8f34T78FksIeD2aEIr5FhM6LRVdh/X
         Qc1d4QJ3x3qSiwdpCQ+5u20NjaAbW3lsCeB79I9iYTkR+zgdqR1nKf1FkDkkdkH1rc
         ktHCS2AoxK1bg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 0/8] Extend `phy-mode` to string array
Date:   Wed, 10 Nov 2021 20:07:01 +0100
Message-Id: <20211110190709.16505-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I know that net-next is closed now, so this is just a RFC to get some
feedback/reviews on this. Hopefully this is not a problem, if so,
please ignore it.

This series extends the `phy-connection-type` / `phy-mode` property to
be an array of strings, instead of just one string.

Conventionaly the `phy-mode` means "this is the mode I want the PHY to
operate in". But we now have some PHYs that may need to change the PHY
mode during operation (marvell10g PHY driver), and so we need to know
all the supported modes. Russell King is working on MAC and PHY drivers
to inform phylink on which PHY interface modes they support, but it is
not enough, for a MAC/PHY driver may fill all the modes supported by
the driver, but still each individual board may have only some of those
modes actually wired.

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

Marek

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

 .../bindings/net/ethernet-controller.yaml     |  88 +++++------
 drivers/base/property.c                       |  48 +++++-
 drivers/net/phy/marvell10g.c                  | 140 ++++++++++++++++--
 drivers/net/phy/phylink.c                     |  91 ++++++++++++
 include/linux/phy.h                           |  10 ++
 include/linux/property.h                      |   3 +
 net/core/of_net.c                             |   9 +-
 7 files changed, 321 insertions(+), 68 deletions(-)

-- 
2.32.0

