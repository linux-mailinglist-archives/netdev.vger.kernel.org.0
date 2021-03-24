Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E7034763E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhCXKgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhCXKgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 173E061A01;
        Wed, 24 Mar 2021 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616582190;
        bh=K+wu1moqnyaaWnMlMm2Hi99elaBkWYpg6o00k7xiPBY=;
        h=From:To:Cc:Subject:Date:From;
        b=mCjAt6l8xkj+gzbE1PMT0seb76QmBsvopd0YBzHrShOi//z4bLeDAlXjN1dPZNqLL
         2M3ZYsVkiVTvvkNhBr1D54jtig9FIhBS4Dd2aOXLiDSGwAquK4MA9j75GFKN3QgjMG
         x9A+hXsPXU4S/jQHNqUhD9RAFwvRX6oJZJKttmOT2V9+3mdwRBjp77HNmnw1Qn3S37
         P44lQBUrattI9ec3Yh3JYGKHrtg2n7SJUrvYG40L62NVYqCOZqXIuMuqUD6qI6kR1D
         DWIvO/4k6SCnZe2c6RqvmFOGQ5efbz86gjCcFyAd6z+sex1p4kOfPetWsPYXwBobvB
         +klDJpYS35bWg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/2] dt-bindings: define property describing supported ethernet PHY modes
Date:   Wed, 24 Mar 2021 11:35:54 +0100
Message-Id: <20210324103556.11338-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

the Marvell Alaska PHYs (88X3310, 88E2110) can, depending on their
configuration, change the PHY mode to the MAC, depending on the
copper/fiber speed.

The 88X3310, for example, can be configured (via MACTYPE register)
so that it communicates with the MAC in sgmii for 10/100/1000mbps,
2500base-x for 2500mbps, 5gbase-r for 5gbps and either 10gbase-r,
xaui or rxaui for 10gbps. Or the PHY may communicate with the MAC
in usxgmii, or one of the 10gbase-r, rxaui or xaui modes with rate
matching.

So for the 10gbps mode we have options 10gbase-r, xaui, rxaui and
usxgmii. The MAC can support some of these modes, and if it does more
than one, we need to know which one to use. Not all of these modes
must necessarily be supported by the board (xaui required wiring for
4 SerDes lanes, for example, and 10gbase-r requires wiring capable
of transmitting at 10.3125 GBd).

The MACTYPE is upon HW reset configured by strapping pins - so the
board should have a correct mode configured after HW reset.

One problem with this is that some boards configure the MACTYPE to
a rate matching mode, which, according to the errata, is broken in
some situations (it does not work for 10/100/1000, for example).

Another problem is that if lower modes are supported, we should
maybe use them in order to save power.

But for this we need to know which phy-modes are supported on the
board.

This series adds documentation for a new ethernet PHY property,
called `supported-mac-connection-types`.

When this property is present for a PHY node, only the phy-modes
listed in this property should be considered to be functional on
the board.

The second patch adds binding for this property.

The first patch does some YAML magic in ethernet-controller.yaml
in order to be able to reuse the PHY modes enum, so that the same
list does not have to be defined twice.

Marek

Marek Behún (2):
  dt-bindings: ethernet-controller: create a type for PHY interface
    modes
  dt-bindings: ethernet-phy: define `supported-mac-connection-types`
    property

 .../bindings/net/ethernet-controller.yaml     | 89 ++++++++++---------
 .../devicetree/bindings/net/ethernet-phy.yaml | 18 ++++
 2 files changed, 66 insertions(+), 41 deletions(-)

-- 
2.26.2

